/**
 * context-saver — automatic context slimming, non-destructive.
 *
 * The raw session file is never modified; only the per-request LLM view is
 * slimmed, so /tree, resume, exports and built-in compaction all work as-is.
 *
 * Two layers:
 *
 * 1. `context` hook (before every LLM request):
 *    - tool-result text blocks older than the last `keepRecent` messages are
 *      replaced by a short head + marker when they exceed `truncThreshold`;
 *    - earlier identical reads (same path, range and text) are replaced with
 *      a short marker; different ranges and changed text are not duplicates;
 *    - old thinking blocks are dropped (safe by default only for
 *      openai-completions providers; see `dropOldThinking`).
 *
 * 2. `tool_result` hook (at write time): a fresh non-read text result larger
 *    than `maxFreshResult` is capped at `maxFreshKeep` and the full output is
 *    saved to a temp file (mirrors pi's own bash truncation).
 *
 * Config: `~/.pi/agent/context-saver.json` — any subset of the defaults below.
 * Stats: `/ctx-saver` command or the footer status line.
 */

import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

interface Config {
	/** Messages at the tail of the request that are never trimmed. */
	keepRecent: number;
	/** Stale tool-result text blocks longer than this (chars) get trimmed. */
	truncThreshold: number;
	/** Chars of a trimmed block that are kept at the head. */
	keepHead: number;
	/** Replace older exact copies of a read with a short marker. */
	dedupReads: boolean;
	/** "auto" = drop old thinking blocks for openai-completions providers only. */
	dropOldThinking: "auto" | boolean;
	/** Fresh (just executed) text results larger than this are capped... */
	maxFreshResult: number;
	/** ...at this many chars, with the full output saved to a temp file. */
	maxFreshKeep: number;
}

const DEFAULTS: Config = {
	keepRecent: 30,
	truncThreshold: 12000,
	keepHead: 1000,
	dedupReads: true,
	dropOldThinking: "auto",
	maxFreshResult: 100_000,
	maxFreshKeep: 30_000,
};

const CONFIG_PATH = path.join(os.homedir(), ".pi", "agent", "context-saver.json");
const DEBUG_LOG = path.join(os.tmpdir(), "ctx-saver-debug.log");

function dbg(msg: string): void {
	try {
		fs.appendFileSync(DEBUG_LOG, `${new Date().toISOString()} ${msg}\n`);
	} catch {
		// debug logging must never break the session
	}
}

function loadConfig(): Config {
	let file: Partial<Config> = {};
	try {
		file = JSON.parse(fs.readFileSync(CONFIG_PATH, "utf8"));
	} catch {
		// no config file — defaults
	}
	const out = { ...DEFAULTS, ...file };
	for (const key of Object.keys(out) as (keyof Config)[]) {
		if (typeof DEFAULTS[key] === "number" && (typeof out[key] !== "number" || (out[key] as number) < 0)) {
			out[key] = DEFAULTS[key];
		}
	}
	return out;
}

function kb(bytes: number): string {
	return bytes >= 1_000_000 ? `${(bytes / 1_000_000).toFixed(1)} MB` : `${Math.round(bytes / 1024)} KB`;
}

/** Rough token estimate (4 chars ≈ 1 token). */
function tok(bytes: number): string {
	const tokens = Math.round(bytes / 4);
	return tokens >= 1000 ? `${(tokens / 1000).toFixed(1)}k` : `${tokens}`;
}

function status(bytes: number): string {
	return `~${tok(bytes)} tok/req trimmed`;
}

/** Stale = index is below staleFrom. */
interface CallInfo {
	name: string;
	arguments: Record<string, unknown>;
}

export default function (pi: ExtensionAPI) {
	dbg("extension factory loaded");
	let cfg = loadConfig();
	let trimmedBytes = 0;
	let trimmedBlocks = 0;
	let cappedResults = 0;
	let lastSaved = 0; // bytes trimmed on the most recent request (footer metric)

	pi.on("session_start", (_event, ctx) => {
		cfg = loadConfig(); // pick up config changes between sessions
		trimmedBytes = 0;
		trimmedBlocks = 0;
		cappedResults = 0;
		lastSaved = 0;
		dbg(`session_start reason=${String(_event.reason)}`);
		if (ctx.hasUI) {
			ctx.ui.setStatus("ctx-saver", status(lastSaved));
			ctx.ui.notify(`context-saver: on (stale >${kb(cfg.truncThreshold)}, last ${cfg.keepRecent} kept)`, "info");
		}
	});

	// ---- layer 1: slim the per-request view (non-destructive) ----
	pi.on("context", (event, ctx) => {
		const messages = event.messages;
		const staleFrom = messages.length - cfg.keepRecent;
		if (staleFrom <= 0) return;

		// map tool call id -> args (for read-path dedup)
		const calls = new Map<string, CallInfo>();
		for (const m of messages) {
			if (m.role !== "assistant") continue;
			for (const c of m.content) {
				if (c.type === "toolCall") calls.set(c.id, { name: c.name, arguments: c.arguments });
			}
		}

		// Compare the whole successful text result, not just its file path.
		const duplicateReads = new Map<number, number>();
		if (cfg.dedupReads) {
			const latestRead = new Map<string, number>();
			for (let i = messages.length - 1; i >= 0; i--) {
				const m = messages[i];
				if (m.role !== "toolResult" || m.toolName !== "read" || m.isError || !m.content.length) continue;
				if (!m.content.every((block) => block.type === "text" && !block.textSignature)) continue;
				const args = calls.get(m.toolCallId)?.arguments;
				if (typeof args?.path !== "string") continue;
				const key = JSON.stringify([args.path, args.offset, args.limit, m.content]);
				const newer = latestRead.get(key);
				if (newer === undefined) latestRead.set(key, i);
				else if (i < staleFrom) duplicateReads.set(i, newer);
			}
		}

		const dropThinking = cfg.dropOldThinking === true || (cfg.dropOldThinking === "auto" && ctx.model?.api === "openai-completions");

		let sessionSaved = 0;
		let sessionCount = 0;

		for (let i = 0; i < staleFrom; i++) {
			const m = messages[i];

			if (m.role === "assistant") {
				if (!dropThinking) continue;
				// Keep redacted blocks and blocks with an *opaque* signature (JSON
				// reasoning_details for encrypted continuity). A plain field-name
				// signature ("reasoning_content" etc.) just marks the replay field for
				// openai-completions — the text itself is replayed verbatim, so the
				// block is safe to drop.
				m.content = m.content.filter((c) => {
					if (c.type !== "thinking" || c.redacted) return true;
					const sig = c.thinkingSignature;
					if (typeof sig === "string" && (sig.startsWith("[") || sig.startsWith("{"))) return true;
					sessionSaved += c.thinking.length;
					return false;
				});
				if (sessionSaved > 0) sessionCount++;
				continue;
			}

			if (m.role !== "toolResult") continue;

			const newer = duplicateReads.get(i);
			if (newer !== undefined) {
				const replacement = messages[newer];
				// Don't replace the old copy if the newer one will also be truncated.
				const fullCopyKept = newer >= staleFrom || (replacement.role === "toolResult" &&
					replacement.content.every((block) => block.type === "text" && block.text.length <= cfg.truncThreshold));
				const marker = "[context-saver: identical read result appears later]";
				const length = m.content.reduce((sum, block) => sum + (block.type === "text" ? block.text.length : 0), 0);
				if (fullCopyKept && length > marker.length) {
					m.content = [{ type: "text", text: marker }];
					sessionSaved += length - marker.length;
					sessionCount++;
					continue;
				}
			}

			const next: typeof m.content = [];
			let changed = false;
			for (const block of m.content) {
				if (block.type !== "text" || block.textSignature) {
					next.push(block);
					continue;
				}
				if (block.text.length <= cfg.truncThreshold) {
					next.push(block);
					continue;
				}
				changed = true;
				const kept = block.text.slice(0, cfg.keepHead);
				const note = `trimmed ${kb(block.text.length)} of stale ${m.toolName} output (first ${cfg.keepHead} chars kept); rerun the tool call if the full output is needed`;
				sessionSaved += block.text.length - cfg.keepHead;
				next.push({ type: "text", text: `${kept}\n\n[context-saver: ${note}]` });
			}
			if (changed) {
				m.content = next;
				sessionCount++;
			}
		}

		if (sessionSaved > 0) {
			trimmedBytes += sessionSaved;
			trimmedBlocks += sessionCount;
			lastSaved = sessionSaved;
			dbg(`context: msgs=${messages.length} staleFrom=${staleFrom} saved=${sessionSaved} blocks=${sessionCount} dropThinking=${dropThinking}`);
			if (ctx.hasUI) ctx.ui.setStatus("ctx-saver", status(lastSaved));
		} else {
			dbg(`context: msgs=${messages.length} staleFrom=${staleFrom} saved=0`);
		}
		return { messages };
	});

	// ---- layer 2: cap huge fresh results at write time ----
	pi.on("tool_result", (event, ctx) => {
		if (event.toolName === "read") return; // reads already self-limit; deduped per-request
		const texts = event.content.filter((c) => c.type === "text");
		if (texts.length === 0 || texts.length !== event.content.length) return; // all-text only
		const total = texts.reduce((a, c) => a + (c.type === "text" ? c.text.length : 0), 0);
		if (total <= cfg.maxFreshResult) return;

		const fullText = texts.map((c) => (c.type === "text" ? c.text : "")).join("\n");
		const safeId = event.toolCallId.replace(/[^a-zA-Z0-9_-]/g, "").slice(-32);
		const file = path.join(os.tmpdir(), `pi-ctx-saver-${Date.now()}-${safeId}.txt`);
		try {
			fs.writeFileSync(file, fullText);
		} catch {
			return; // never break the tool on a temp-file failure
		}

		const inputHint =
			typeof event.input?.command === "string"
				? `command: ${event.input.command}`
				: `input: ${JSON.stringify(event.input)}`;
		const capped = fullText.slice(0, cfg.maxFreshKeep);
		const note = `trimmed ${kb(total)} of fresh ${event.toolName} result (${kb(total - cfg.maxFreshKeep)} dropped). ${inputHint} — full output saved at ${file}, read it if needed`;
		cappedResults++;
		trimmedBytes += total - cfg.maxFreshKeep;
		lastSaved += total - cfg.maxFreshKeep;
		dbg(`tool_result capped: ${event.toolName} ${total} -> ${cfg.maxFreshKeep} file=${file}`);
		if (ctx.hasUI) ctx.ui.setStatus("ctx-saver", status(lastSaved));
		return {
			content: [{ type: "text", text: `${capped}\n\n[context-saver: ${note}]` }],
		};
	});

	// ---- stats ----
	pi.registerCommand("ctx-saver", {
		description: "Show context-saver stats for this session",
		handler: async (_args, ctx) => {
			ctx.ui.notify(
				`context-saver: last request ${kb(lastSaved)} (~${tok(lastSaved)} tok) trimmed; total this session ${kb(trimmedBytes)} (~${tok(trimmedBytes)} tok) across ${trimmedBlocks} stale blocks, ${cappedResults} fresh results capped`,
				"info",
			);
		},
	});
}

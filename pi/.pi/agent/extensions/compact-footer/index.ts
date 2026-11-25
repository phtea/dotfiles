/**
 * Compact one-line footer, everything left-aligned:
 *   ~/Projects/foo (master) · qwen3-8 · 38% (128k) · 33 tok/s
 *
 * Also rewrites the built-in "Working..." line while an assistant message is
 * streaming: `Working... 1m 23s · 33 tok/s`.
 *
 * Replaces the built-in footer (and any package footer): one dim row with
 * path (+ git branch), model id, context usage as `38% (128k)` (percent of the
 * context window + window size), and a live TPS measured from streaming
 * updates.
 *
 * TPS is approximate: characters streamed during a rolling ~1s window,
 * divided by 4 (chars-per-token heuristic). Visible while the last assistant
 * message streamed; cleared when the run settles.
 */
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Text, truncateToWidth } from "@earendil-works/pi-tui";

const CHARS_PER_TOKEN = 4;
const WINDOW_MS = 1000;
const MIN_SPAN_MS = 300;
const WORK_UPDATE_MS = 500;

let rate: number | null = null;
let samples: { t: number; chars: number }[] = [];
let startedAt: number | null = null;
let runStartAt: number | null = null;
let runOutputTokens = 0;
let workTimer: ReturnType<typeof setInterval> | null = null;

function countChars(content: unknown): number {
	if (typeof content === "string") return content.length;
	if (!Array.isArray(content)) return 0;
	let chars = 0;
	for (const block of content) {
		if (typeof block !== "object" || block === null) continue;
		const b = block as { type?: string; text?: string; thinking?: string };
		if (b.type === "text" && typeof b.text === "string") chars += b.text.length;
		else if (b.type === "thinking" && typeof b.thinking === "string") chars += b.thinking.length;
	}
	return chars;
}

function fmtTokens(n: number): string {
	return n >= 1000 ? `${(n / 1000).toFixed(1)}k` : `${n}`;
}

function fmtDuration(ms: number): string {
	const totalSec = Math.floor(ms / 1000);
	const d = Math.floor(totalSec / 86400);
	const h = Math.floor((totalSec % 86400) / 3600);
	const m = Math.floor((totalSec % 3600) / 60);
	const s = totalSec % 60;
	const parts: string[] = [];
	if (d > 0) parts.push(`${d}d`);
	if (d > 0 || h > 0) parts.push(`${h}h`);
	if (d > 0 || h > 0 || m > 0) parts.push(`${m}m`);
	parts.push(`${s}s`);
	return parts.join("");
}

export default function (pi: ExtensionAPI) {
	let ctxRef: ExtensionContext | null = null;

	// opencode-style "Worked for 1m 12s" line after each agent answer
	pi.registerEntryRenderer("worked-for", (entry, _options, theme) => {
		const { ms, avg } = entry.data as { ms: number; avg: number | null };
		const text = avg != null && avg > 0 ? `Worked for ${fmtDuration(ms)} · avg ${avg} tok/s` : `Worked for ${fmtDuration(ms)}`;
		return new Text(theme.fg("dim", text));
	});

	pi.on("agent_start", () => {
		if (runStartAt == null) runOutputTokens = 0;
		runStartAt ??= Date.now();
	});

	const updateWorking = () => {
		if (startedAt == null || !ctxRef) return;
		const elapsed = `Working... ${fmtDuration(Date.now() - startedAt)}`;
		ctxRef.ui.setWorkingMessage(rate != null ? `${elapsed} · ${rate} tok/s` : elapsed);
	};

	pi.on("message_start", (event) => {
		if (event.message.role !== "assistant") return;
		samples = [];
		rate = null;
		startedAt = Date.now();
		updateWorking();
		if (!workTimer) workTimer = setInterval(updateWorking, WORK_UPDATE_MS);
	});

	pi.on("message_update", (event) => {
		if (event.message.role !== "assistant") return;
		const now = Date.now();
		const chars = countChars((event.message as { content?: unknown }).content);
		samples.push({ t: now, chars });
		while (samples.length && now - samples[0].t > WINDOW_MS) samples.shift();
		const first = samples[0];
		const last = samples[samples.length - 1];
		if (first && last && last.t - first.t >= MIN_SPAN_MS && last.chars > first.chars) {
			rate = Math.round((last.chars - first.chars) / CHARS_PER_TOKEN / ((last.t - first.t) / 1000));
		}
	});

	pi.on("message_end", (event) => {
		if (event.message.role !== "assistant") return;
		runOutputTokens += (event.message as { usage?: { output?: number } }).usage?.output ?? 0;
		startedAt = null;
		if (workTimer) {
			clearInterval(workTimer);
			workTimer = null;
		}
		ctxRef?.ui.setWorkingMessage(); // restore the default working line
	});

	pi.on("agent_settled", (event) => {
		rate = null;
		if (!event.aborted && runStartAt != null) {
			const ms = Date.now() - runStartAt;
			const avg =
				ms > 0 && runOutputTokens > 0 ? Math.round(runOutputTokens / (ms / 1000)) : null;
			pi.appendEntry("worked-for", { ms, avg });
		}
		runStartAt = null;
	});

	pi.on("session_start", (_event, ctx) => {
		ctxRef = ctx;
		if (ctx.mode !== "tui") return;
		const home = process.env.HOME ?? "";
		ctx.ui.setFooter((tui, theme, footerData) => {
			const unsub = footerData.onBranchChange(() => tui.requestRender());
			return {
				dispose: unsub,
				invalidate() {},
				render(width: number): string[] {
					const dim = (s: string) => theme.fg("dim", s);
					let path = ctx.sessionManager.getCwd();
					if (home && path.startsWith(home)) path = "~" + path.slice(home.length);

					const parts: string[] = [dim(path)];
					const branch = footerData.getGitBranch();
					if (branch) parts.push(theme.fg("accent", ` ${branch}`));
					if (ctx.model?.id) parts.push(ctx.model.id);
					const usage = ctx.getContextUsage();
					if (usage?.percent != null) {
						parts.push(dim(`${Math.round(usage.percent)}% (${fmtTokens(usage.contextWindow)})`));
					}

					return [truncateToWidth(parts.join(dim(" · ")), width)];
				},
			};
		});
	});
}

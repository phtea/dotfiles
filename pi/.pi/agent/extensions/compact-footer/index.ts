/**
 * Compact one-line footer, everything left-aligned:
 *   ~/Projects/foo (master) · qwen3-8 · 38% (128k)
 *
 * Updates the native working indicator with elapsed time and average TPS over
 * the whole working period, from streamed text, thinking and tool-call deltas
 * (four chars per token).
 */
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Text, truncateToWidth } from "@earendil-works/pi-tui";

const CHARS_PER_TOKEN = 4;
const MIN_SPAN_MS = 250;
const WORK_UPDATE_MS = 250;

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
	let runStartAt: number | undefined;
	let runOutputTokens = 0;
	let runChars = 0; // chars streamed since run start (for avg TPS)
	let workTimer: ReturnType<typeof setInterval> | undefined;
	let lastLabel: string | undefined;

	function resetStream() {
		runChars = 0;
	}

	function stopWorking() {
		clearInterval(workTimer);
		workTimer = undefined;
		lastLabel = undefined;
		resetStream();
	}

	// opencode-style "Worked for 1m 12s" line after each agent answer
	pi.registerEntryRenderer("worked-for", (entry, _options, theme) => {
		const { ms, avg } = entry.data as { ms: number; avg: number | null };
		const text = avg != null && avg > 0 ? `Worked for ${fmtDuration(ms)} · avg ${avg} tok/s` : `Worked for ${fmtDuration(ms)}`;
		return new Text(theme.fg("dim", text));
	});

	function updateWorking(ctx: ExtensionContext) {
		if (runStartAt === undefined) return;
		const now = performance.now();
		const elapsed = now - runStartAt;
		const rate = elapsed >= MIN_SPAN_MS ? Math.round((runChars * 1000) / CHARS_PER_TOKEN / elapsed) : 0;
		const label = rate > 0 ? `Working... ${fmtDuration(elapsed)} · ${rate} tok/s` : `Working... ${fmtDuration(elapsed)}`;
		if (label === lastLabel) return;
		lastLabel = label;
		ctx.ui.setWorkingMessage(label);
	}

	pi.on("agent_start", (_event, ctx) => {
		if (runStartAt === undefined) {
			runOutputTokens = 0;
			runChars = 0;
		}
		runStartAt ??= performance.now();
		if (ctx.mode !== "tui" || workTimer) return;
		updateWorking(ctx);
		workTimer = setInterval(() => updateWorking(ctx), WORK_UPDATE_MS);
		workTimer.unref();
	});

	pi.on("message_update", (event, ctx) => {
		if (ctx.mode !== "tui" || runStartAt === undefined) return;
		const delta = event.assistantMessageEvent;
		if (delta.type !== "text_delta" && delta.type !== "thinking_delta" && delta.type !== "toolcall_delta") return;
		if (!delta.delta) return;
		runChars += delta.delta.length;
	});

	pi.on("message_end", (event, ctx) => {
		if (event.message.role !== "assistant") return;
		runOutputTokens += event.message.usage?.output ?? 0;
		if (ctx.mode === "tui") updateWorking(ctx);
	});

	pi.on("agent_settled", (_event, ctx) => {
		stopWorking();
		if (ctx.mode === "tui") ctx.ui.setWorkingMessage();
		if (runStartAt !== undefined) {
			const ms = performance.now() - runStartAt;
			const avg =
				ms > 0 && runOutputTokens > 0 ? Math.round(runOutputTokens / (ms / 1000)) : null;
			pi.appendEntry("worked-for", { ms, avg });
		}
		runStartAt = undefined;
	});

	pi.on("session_shutdown", stopWorking);

	pi.on("session_start", (_event, ctx) => {
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
					if (ctx.model?.id) {
						const level = ctx.thinkingLevel || "off";
						const effort = ctx.model.reasoning ? ` ${ctx.ui.theme.getThinkingBorderColor(level)(`(${level})`)}` : "";
						parts.push(ctx.model.id + effort);
					}
					const branch = footerData.getGitBranch();
					if (branch) parts.push(theme.fg("accent", ` ${branch}`));
					const usage = ctx.getContextUsage();
					if (usage?.percent != null) {
						parts.push(dim(`${Math.round(usage.percent)}% (${fmtTokens(usage.contextWindow)})`));
					}
					// Extension statuses (e.g. ctx-saver), appended after the standard parts
					const statuses = footerData.getExtensionStatuses();
					if (statuses.size > 0) {
						for (const [key, text] of [...statuses.entries()].sort(([a], [b]) => a.localeCompare(b))) {
							parts.push(dim(text));
						}
					}

					return [truncateToWidth(parts.join(dim(" · ")), width)];
				},
			};
		});
	});
}

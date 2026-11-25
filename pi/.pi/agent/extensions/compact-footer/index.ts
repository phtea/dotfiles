/**
 * Compact one-line footer, everything left-aligned:
 *   ~/Projects/foo (master) · qwen3-8 · 38% (128k) · 33 tok/s
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
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth } from "@earendil-works/pi-tui";

const CHARS_PER_TOKEN = 4;
const WINDOW_MS = 1000;
const MIN_SPAN_MS = 300;

let rate: number | null = null;
let samples: { t: number; chars: number }[] = [];

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

export default function (pi: ExtensionAPI) {
	// Track streaming output for the live TPS
	let tuiRef: { requestRender(): void } | null = null;

	pi.on("message_start", (event) => {
		if (event.message.role === "assistant") {
			samples = [];
			rate = null;
		}
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
		tuiRef?.requestRender();
	});

	pi.on("agent_settled", () => {
		rate = null;
	});

	pi.on("session_start", (_event, ctx) => {
		if (ctx.mode !== "tui") return;
		const home = process.env.HOME ?? "";
		ctx.ui.setFooter((tui, theme, footerData) => {
			tuiRef = tui;
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
					if (rate != null) parts.push(theme.fg("success", `${rate} tok/s`));

					return [truncateToWidth(parts.join(dim(" · ")), width)];
				},
			};
		});
	});
}

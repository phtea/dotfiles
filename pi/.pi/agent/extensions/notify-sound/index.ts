/**
 * Notifies when Pi finishes a run and is waiting for input.
 *
 * Strategy:
 * - Linux desktop: `notify-send` desktop notification (shows the text of the
 *   final answer and plays the desktop notification sound);
 * - Kitty: OSC 99 terminal notification, otherwise OSC 777 (Ghostty, iTerm2,
 *   WezTerm, rxvt-unicode);
 * - always a terminal bell: tmux marks the window (monitor-bell) and
 *   bell-only terminals still get a sound.
 *
 * `agent_settled` fires only after retries, auto-compaction and queued
 * follow-up messages are done — i.e. the final answer is ready. Aborted
 * runs (e.g. Escape) are skipped.
 */
import { execFile } from "node:child_process";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const MAX_BODY = 200;

function escape777(text: string): string {
	return text.replace(/;/g, " ").replace(/\x1b/g, "").replace(/\x07/g, " ");
}

function notifyOSC777(title: string, body: string): void {
	process.stdout.write(`\x1b]777;notify;${escape777(title)};${escape777(body)}\x07`);
}

function notifyOSC99(title: string, body: string): void {
	process.stdout.write(`\x1b]99;i=1;d=0;${escape777(title)}\x1b\\`);
	process.stdout.write(`\x1b]99;i=1;p=body;${escape777(body)}\x1b\\`);
}

function desktopNotify(title: string, body: string): void {
	execFile(
		"notify-send",
		["-a", "pi", "-u", "normal", title, body.slice(0, MAX_BODY)],
		{ timeout: 3000 },
		() => {},
	);
	// Play a specific sound (desktop notification sounds can be muted by the DE).
	execFile("pw-play", ["/usr/share/sounds/freedesktop/stereo/bell.oga"], { timeout: 5000 }, () => {});
}

function lastAssistantText(ctx: ExtensionContext): string {
	try {
		const entries = ctx.sessionManager.getBranch();
		for (let i = entries.length - 1; i >= 0; i--) {
			const entry = entries[i] as { type?: string; message?: { role?: string; content?: unknown } };
			if (entry?.type !== "message" || entry.message?.role !== "assistant") continue;
			const content = entry.message.content;
			const texts: string[] =
				typeof content === "string"
					? [content]
					: Array.isArray(content)
						? content
								.filter((block) => typeof block === "object" && block !== null && "type" in block && (block as { type?: string }).type === "text")
								.map((block) => (block as { text?: string }).text ?? "")
						: [];
			const text = texts.join(" ").replace(/\s+/g, " ").trim();
			if (text) return text;
		}
	} catch {
		// session access failed — fall back to the generic text below
	}
	return "Готово — ответ ожидает вашего ввода";
}

export default function (pi: ExtensionAPI) {
	pi.on("agent_settled", async (event, ctx) => {
		if (event.aborted) return;

		const body = lastAssistantText(ctx);
		const title = "Pi: готов";

		if (process.platform === "linux" && process.env.XDG_SESSION_TYPE) {
			desktopNotify(title, body);
		}
		if (process.env.KITTY_WINDOW_ID) {
			notifyOSC99(title, body);
		} else {
			notifyOSC777(title, body);
		}
		// Bell: marks the tmux window (monitor-bell) and works on terminals
		// without desktop notifications.
		process.stdout.write("\x07");
	});
}

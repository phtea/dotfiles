import { execFile } from "node:child_process";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const colors = {
	idle: "",
	running: "#61aeee",
	ready: "#e5c07b",
	waiting: "#c678dd",
};

const ownerOption = "@pi_window_owner";
const colorOption = "@pi_window_color";
const labelOption = "@pi_window_label";

function tabLabel(name: string | undefined): string {
	return (name ?? "")
		.replace(/\s+/gu, " ")
		.replace(/[\p{Cc}\p{Bidi_Control}]/gu, "")
		.replace(/#(?=\[)/g, "＃") // Prevent tmux status style markup in the label.
		.trim();
}

export default function (pi: ExtensionAPI) {
	const pane = process.env.TMUX_PANE;
	const socket = process.env.TMUX?.match(/^(.*),\d+,\d+$/)?.[1];
	if (!socket || !pane || !/^%\d+$/.test(pane) || !process.stdin.isTTY || !process.stdout.isTTY) return;

	const tmux = (...args: string[]) => new Promise<string | undefined>((resolve) => {
		execFile("tmux", ["-S", socket, ...args], { timeout: 1000 }, (error, stdout) => {
			resolve(error ? undefined : stdout.replace(/\n$/, ""));
		});
	});

	let windowId: string | undefined;
	let phase: "idle" | "running" | "ready" = "idle";
	let waiting = false;
	let pending = Promise.resolve();
	let lastColor: string | undefined;
	let label = "";
	let lastLabel: string | undefined;

	function render() {
		const id = windowId;
		if (!id) return;
		const color = colors[waiting ? "waiting" : phase];
		const nextLabel = label;
		pending = pending.then(async () => {
			if (lastColor !== color) {
				const result = color
					? await tmux("set-option", "-w", "-t", id, colorOption, color)
					: await tmux("set-option", "-wqu", "-t", id, colorOption);
				if (result !== undefined) lastColor = color;
			}
			if (lastLabel !== nextLabel) {
				// The config strips the sentinel. It keeps a trailing semicolon literal.
				const result = nextLabel
					? await tmux("set-option", "-w", "-t", id, "--", labelOption, `${nextLabel}!`)
					: await tmux("set-option", "-wqu", "-t", id, labelOption);
				if (result !== undefined) lastLabel = nextLabel;
			}
		});
		return pending;
	}

	pi.on("session_start", async (_event, ctx) => {
		if (ctx.mode !== "tui") return;
		const id = await tmux("display-message", "-p", "-t", pane, "#{window_id}");
		if (!id || !/^@\d+$/.test(id)) return;

		// In a split window, only one Pi instance controls the window tab.
		const owner = String(process.pid);
		await tmux("set-option", "-woq", "-t", id, ownerOption, owner);
		if (await tmux("show-options", "-wqv", "-t", id, ownerOption) !== owner) return;

		windowId = id;
		label = tabLabel(pi.getSessionName());
		await render();
	});

	pi.on("session_info_changed", (event) => {
		label = tabLabel(event.name);
		return render();
	});
	pi.on("agent_start", () => {
		phase = "running";
		return render();
	});
	pi.on("agent_settled", (event) => {
		phase = event.aborted ? "idle" : "ready";
		return render();
	});
	pi.on("ui_prompt_start", () => {
		waiting = true;
		return render();
	});
	pi.on("ui_prompt_end", () => {
		waiting = false;
		return render();
	});

	pi.on("session_shutdown", async () => {
		const id = windowId;
		windowId = undefined;
		if (!id) return;
		await pending;
		await tmux(
			"set-option", "-wqu", "-t", id, colorOption, ";",
			"set-option", "-wqu", "-t", id, labelOption, ";",
			"set-option", "-wqu", "-t", id, ownerOption,
		);
	});
}

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

	function render() {
		const id = windowId;
		if (!id) return;
		const color = colors[waiting ? "waiting" : phase];
		pending = pending.then(async () => {
			if (lastColor === color) return;
			const result = color
				? await tmux("set-option", "-w", "-t", id, colorOption, color)
				: await tmux("set-option", "-wqu", "-t", id, colorOption);
			if (result !== undefined) lastColor = color;
		});
		return pending;
	}

	pi.on("session_start", async (_event, ctx) => {
		if (ctx.mode !== "tui") return;
		const id = await tmux("display-message", "-p", "-t", pane, "#{window_id}");
		if (!id || !/^@\d+$/.test(id)) return;

		// In a split window, only one Pi instance controls the status color.
		const owner = String(process.pid);
		await tmux("set-option", "-woq", "-t", id, ownerOption, owner);
		if (await tmux("show-options", "-wqv", "-t", id, ownerOption) !== owner) return;

		windowId = id;
		await render();
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
			"set-option", "-wqu", "-t", id, ownerOption,
		);
	});
}

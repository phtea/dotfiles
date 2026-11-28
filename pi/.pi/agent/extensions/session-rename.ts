import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	pi.registerShortcut("ctrl+r", {
		description: "Rename the current session",
		async handler(ctx) {
			if (ctx.mode !== "tui") return;
			const name = (await ctx.ui.input("Rename current session", pi.getSessionName() ?? "New name"))?.trim();
			if (name) pi.setSessionName(name);
		},
	});
}

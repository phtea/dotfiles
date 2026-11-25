/**
 * "left" opens the /resume session selector only when the prompt is empty.
 *
 * With a non-empty prompt, "left" moves the cursor as usual: for that single
 * keystroke the user binding of app.session.resume is temporarily cleared so
 * the editor falls through to its normal cursor-left handling.
 */
import { CustomEditor, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import type { KeybindingsManager } from "@earendil-works/pi-tui";

const WRAPPED_FLAG = "__emptyOnlyResumeWrapped";

export default function (pi: ExtensionAPI) {
	pi.on("session_start", (_event, ctx) => {
		if (ctx.mode !== "tui") return;
		const previous = ctx.ui.getEditorComponent();
		ctx.ui.setEditorComponent((tui, theme, keybindings) => {
			const base: CustomEditor = previous
				? (previous(tui, theme, keybindings) as CustomEditor)
				: new CustomEditor(tui, theme, keybindings, { embedWorkingStatus: true });
			if ((base as unknown as Record<string, boolean>)[WRAPPED_FLAG]) return base;
			(base as unknown as Record<string, boolean>)[WRAPPED_FLAG] = true;

			const original = base.handleInput.bind(base);
			base.handleInput = (data: string) => {
				const kb = keybindings as KeybindingsManager;
				if (base.getText().length > 0 && kb.matches(data, "tui.editor.cursorLeft")) {
					const current = kb.getUserBindings();
					kb.setUserBindings({ ...current, "app.session.resume": [] });
					try {
						original(data);
					} finally {
						kb.setUserBindings(current);
					}
					return;
				}
				original(data);
			};
			return base;
		});
	});
}

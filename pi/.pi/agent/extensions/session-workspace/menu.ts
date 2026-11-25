import { homedir } from "node:os";
import type { ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Input, matchesKey, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import type { Worktree } from "./git.ts";

interface Row { tree: Worktree; removeBlocked?: string; current: boolean }
type Pick = { action: "new" } | { action: "switch" | "remove"; tree: Worktree; removeBlocked?: string };
const PAGE = 10;
const printable = (text: string) => text.replace(/[\p{Cc}\p{Cf}]/gu, "?");

export function pickWorktree(ctx: ExtensionContext, rows: Row[]): Promise<Pick | undefined> {
	const home = homedir();
	const entries = rows.map((row) => {
		const { path, branch, head, locked } = row.tree;
		const label = printable(path.startsWith(`${home}/`) ? `~${path.slice(home.length)}` : path);
		const detail = printable([branch ?? `detached ${head?.slice(0, 8) ?? "HEAD"}`, row.current ? "current" : "", locked ? "locked" : ""].filter(Boolean).join(" · "));
		return { row, label, detail, search: `${path} ${label} ${detail}`.toLowerCase() };
	});
	return ctx.ui.custom<Pick | undefined>((tui, theme, keys, done) => {
		const input = new Input({ placeholder: "Filter by path or branch", placeholderStyle: (text) => theme.fg("dim", text) });
		let items = entries;
		let index = Math.max(0, entries.findIndex(({ row }) => row.current));
		function choose(action: "switch" | "remove") {
			const row = items[index]?.row;
			if (row) done({ action, tree: row.tree, removeBlocked: row.removeBlocked });
		}
		return {
			get focused() { return input.focused; },
			set focused(value: boolean) { input.focused = value; },
			invalidate() { input.invalidate(); },
			render(width) {
				if (width < 1) return [];
				const heading = `${theme.fg("text", "Git Worktrees")}${theme.fg("dim", ` · ${entries.length}`)}`;
				const start = Math.max(0, Math.min(index - Math.floor(PAGE / 2), items.length - PAGE));
				const lines = items.slice(start, start + PAGE).map(({ row, label, detail }, offset) => {
					const active = start + offset === index;
					const right = truncateToWidth(detail, Math.floor(width / 2), "…");
					const room = Math.max(0, width - visibleWidth(right) - (right ? 2 : 0));
					const left = truncateToWidth(`${active ? "› " : "  "}${label}`, room, "…");
					const styledLeft = active ? theme.bold(theme.fg("accent", left)) : theme.fg(row.current ? "accent" : "text", left);
					const line = styledLeft + " ".repeat(Math.max(0, width - visibleWidth(left) - visibleWidth(right))) + theme.fg("dim", right);
					return active ? theme.bg("selectedBg", line) : line;
				});
				const border = theme.fg("accent", "─".repeat(width));
				return [border, "", truncateToWidth(heading, width),
					truncateToWidth(theme.fg("muted", "enter switch · ctrl+n new · ctrl+d delete · esc cancel"), width), "",
					...input.render(width), "", ...(lines.length ? lines : [truncateToWidth(theme.fg("muted", "No matching worktrees"), width)]),
					...(items.length > PAGE ? [truncateToWidth(theme.fg("dim", `  (${index + 1}/${items.length})`), width)] : []), "", border];
			},
			handleInput(data) {
				if (matchesKey(data, "ctrl+n")) { done({ action: "new" }); return; }
				if (matchesKey(data, "ctrl+d")) { choose("remove"); return; }
				if (keys.matches(data, "tui.select.confirm")) { choose("switch"); return; }
				if (keys.matches(data, "tui.select.cancel")) { done(undefined); return; }
				if (keys.matches(data, "tui.select.up")) index--;
				else if (keys.matches(data, "tui.select.down")) index++;
				else if (keys.matches(data, "tui.select.pageUp")) index -= PAGE;
				else if (keys.matches(data, "tui.select.pageDown")) index += PAGE;
				else {
					const before = input.getValue();
					input.handleInput(data);
					const query = input.getValue();
					if (query !== before) {
						const terms = query.trim().toLowerCase().split(/\s+/);
						items = entries.filter((entry) => terms.every((term) => entry.search.includes(term)));
						index = 0;
					}
				}
				index = Math.max(0, Math.min(index, items.length - 1));
				tui.requestRender();
			},
		};
	}, { blocked: { kind: "question", message: "Select a Git worktree" } });
}

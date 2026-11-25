import { readdir } from "node:fs/promises";
import { dirname } from "node:path";
import {
	createBashToolDefinition, createEditToolDefinition, createFindToolDefinition, createGrepToolDefinition,
	createLocalBashOperations, createLsToolDefinition, createPowerShellToolDefinition, createReadToolDefinition, createWriteToolDefinition,
	SessionManager, type ExtensionAPI, type ExtensionContext, type ToolDefinition,
} from "@earendil-works/pi-coding-agent";
import { Type, type TSchema } from "typebox";
import { CombinedAutocompleteProvider } from "@earendil-works/pi-tui";
import { createWorktree, describe, gitBranch, listWorktrees } from "./git.ts";
import { directory, ENTRY, expand, RESOLVE, selected, type Selection, type WorkspaceRequest } from "./state.ts";

const STATUS = "session-workspace";
const SWITCH_TOOLS = new Set(["change_dir", "worktree_create", "worktree_switch"]);
const printable = (text: string) => text.replace(/[\p{Cc}\p{Cf}]/gu, "?");
const message = (error: unknown) => printable(error instanceof Error ? error.message : String(error));
const result = (text: string) => ({ content: [{ type: "text" as const, text }], details: {} });

export default function (pi: ExtensionAPI) {
	let state: Selection | undefined;
	let sessionId: string | undefined;
	let branch = "";
	let revision = 0;
	let restoredToOrigin = false;

	function init(ctx: ExtensionContext) {
		const id = ctx.sessionManager.getSessionId();
		if (state && sessionId === id) return state;
		const origin = ctx.sessionManager.getCwd();
		state = selected(ctx.sessionManager, origin) ?? { origin, current: origin };
		sessionId = id;
		branch = "";
		restoredToOrigin = false;
		return state;
	}

	function cwd(ctx: ExtensionContext): string {
		const s = init(ctx);
		return directory(s.origin, s.current);
	}

	async function refresh(ctx: ExtensionContext) {
		if (ctx.mode !== "tui" || !state) return;
		const version = ++revision;
		const { current, origin } = state;
		const value = current === origin ? "" : await gitBranch(pi.exec, current).catch(() => "");
		if (version !== revision) return;
		branch = value;
		ctx.ui.setStatus(STATUS, current === origin ? undefined : printable(`cwd: ${current}${branch ? ` · ${branch}` : ""}`));
	}

	function switchTo(ctx: ExtensionContext, path: string) {
		const s = init(ctx);
		const target = directory(s.current, path);
		if (target !== s.current || restoredToOrigin) {
			const next = { origin: s.origin, current: target, previous: target === s.current ? s.previous : s.current };
			pi.appendEntry(ENTRY, next);
			state = next;
			restoredToOrigin = false;
			branch = "";
			void refresh(ctx).catch(() => {});
		}
		return target;
	}

	pi.events.on(RESOLVE, (input) => {
		const request = input as WorkspaceRequest;
		if (!state || request.sessionId !== sessionId) return;
		request.cwd = state.current;
		request.branch = branch;
		if (request.displayOnly) return;
		try { directory(state.origin, state.current); }
		catch (error) { request.error = message(error); }
	});

	function wrap<P extends TSchema, D, S>(origin: string, factory: (cwd: string) => ToolDefinition<P, D, S>) {
		const tool = factory(origin);
		pi.registerTool({ ...tool, defaultActive: false,
			execute(id, params, signal, update, ctx) {
				const executionCwd = cwd(ctx);
				return tool.execute(id, params, signal, update, { ...ctx, cwd: executionCwd });
			},
		});
	}

	pi.on("session_start", async (event, ctx) => {
		let s = init(ctx);
		if (event.reason === "fork" && event.previousSessionFile) {
			// Pi forks only the selected branch. Copy the parent's last session-wide selection
			// even if its journal record was on a different branch.
			try {
				const parent = SessionManager.open(event.previousSessionFile);
				const inherited = parent.getCwd() === s.origin ? selected(parent, s.origin) : undefined;
				if (inherited) {
					pi.appendEntry(ENTRY, inherited);
					s = state = inherited;
				}
			} catch (error) { ctx.ui.notify(`Could not restore fork cwd: ${message(error)}`, "warning"); }
		}
		try { directory(s.origin, s.current); }
		catch (error) {
			ctx.ui.notify(`Saved cwd is unavailable: ${message(error)}. Falling back to ${printable(s.origin)}.`, "warning");
			state = { ...s, current: s.origin };
			restoredToOrigin = true;
		}
		const settings = pi.getSettings();
		const native = new Set(pi.getAllTools().filter((tool) => tool.sourceInfo.source === "builtin").map((tool) => tool.name));
		if (native.has("read")) wrap(s.origin, (path) => createReadToolDefinition(path, { autoResizeImages: settings.images?.autoResize }));
		if (native.has("bash")) wrap(s.origin, (path) => createBashToolDefinition(path, { shellPath: settings.shellPath, commandPrefix: settings.shellCommandPrefix }));
		if (native.has("powershell")) wrap(s.origin, createPowerShellToolDefinition);
		if (native.has("write")) wrap(s.origin, createWriteToolDefinition);
		if (native.has("edit")) wrap(s.origin, createEditToolDefinition);
		if (native.has("find")) wrap(s.origin, createFindToolDefinition);
		if (native.has("grep")) wrap(s.origin, createGrepToolDefinition);
		if (native.has("ls")) wrap(s.origin, createLsToolDefinition);
		if (ctx.mode === "tui") {
			ctx.ui.addAutocompleteProvider((previous) => ({
				triggerCharacters: [...new Set([...(previous.triggerCharacters ?? []), "@"])],
				async getSuggestions(lines, line, col, options) {
					const before = (lines[line] ?? "").slice(0, col);
					if (!state || state.current === state.origin || !/(?:^|\s)@(?:"[^"]*|[^\s"]*)$/.test(before)) {
						return previous.getSuggestions(lines, line, col, options);
					}
					let base: string;
					try { base = cwd(ctx); } catch { return null; }
					const completion = await new CombinedAutocompleteProvider([], base, "fd").getSuggestions(lines, line, col, options);
					if (!completion?.prefix.startsWith("@")) return null;
					const items = completion.items.flatMap((item) => {
						const path = item.description;
						if (!path || /["\p{Cc}\p{Cf}]/u.test(path)) return [];
						const expanded = expand(path);
						const resolved = expanded.startsWith("/") ? expanded : `${base}/${expanded}`;
						const absolute = item.label.endsWith("/") && !resolved.endsWith("/") ? `${resolved}/` : resolved;
						return [{ ...item, value: /\s/u.test(absolute) ? `@"${absolute}"` : `@${absolute}` }];
					});
					return items.length ? { ...completion, items } : null;
				},
				applyCompletion: (lines, line, col, item, prefix) => previous.applyCompletion(lines, line, col, item, prefix),
				shouldTriggerFileCompletion: previous.shouldTriggerFileCompletion?.bind(previous),
			}));
		}
		await refresh(ctx);
	});

	pi.on("tool_call", (event, ctx) => {
		if (event.parentToolCallId) {
			if (SWITCH_TOOLS.has(event.toolName)) return { block: true, reason: "Call workspace-changing tools directly, not from another tool." };
			return;
		}
		const entry = ctx.sessionManager.getBranch().findLast((entry) => entry.type === "message" && entry.message.role === "assistant");
		if (entry?.type !== "message" || entry.message.role !== "assistant") return;
		const calls = entry.message.content.filter((item) => item.type === "toolCall");
		if (calls.length > 1 && calls.some((call) => call.id === event.toolCallId) && calls.some((call) => SWITCH_TOOLS.has(call.name))) {
			return { block: true, reason: "Call the workspace-changing tool by itself, then wait for its result before running other tools." };
		}
	});

	pi.on("user_bash", (_event, ctx) => {
		const s = init(ctx);
		if (s.current === s.origin) return;
		const local = createLocalBashOperations({ shellPath: pi.getSettings().shellPath });
		return { operations: { exec(command, _cwd, options) { return local.exec(command, cwd(ctx), options); } } };
	});

	pi.on("session_shutdown", () => { ++revision; });
	pi.on("agent_settled", async (_event, ctx) => { await refresh(ctx); });
	pi.on("before_agent_start", (event, ctx) => {
		const s = init(ctx);
		const sections = event.systemPromptOptions.sections ??= {};
		if (s.current === s.origin) { delete sections.session_workspace; return; }
		sections.session_workspace = `Session execution directory at the start of this run: ${JSON.stringify(s.current)}. If a tool successfully switches the execution directory during this run, use the latest directory reported by that tool instead. Use paths relative to the current execution directory in native file and shell tools. Project instructions and resources remain bound to ${JSON.stringify(s.origin)}.`;
	});

	pi.registerCommand("cwd", {
		description: "Show or set session execution directory; - goes back, reset returns to origin",
		async getArgumentCompletions(prefix) {
			if (!state) return null;
			const slash = prefix.lastIndexOf("/");
			const base = prefix.slice(0, slash + 1);
			const term = prefix.slice(slash + 1);
			try {
				const entries = await readdir(directory(state.current, expand(base || ".")), { withFileTypes: true });
				return entries.filter((entry) => {
					if (!entry.name.startsWith(term) || /[\p{Cc}\p{Cf}]/u.test(entry.name)) return false;
					if (entry.isDirectory()) return true;
					if (!entry.isSymbolicLink()) return false;
					try { directory(state!.current, `${base}${entry.name}`); return true; } catch { return false; }
				})
					.slice(0, 100).map((entry) => ({ value: `${base}${entry.name}/`, label: `${entry.name}/` }));
			} catch { return null; }
		},
		async handler(args, ctx) {
			try {
				const s = init(ctx);
				const path = args.trim();
				if (!path) { ctx.ui.notify(`cwd: ${cwd(ctx)}\nSession origin: ${printable(s.origin)}`, "info"); return; }
				if (!ctx.isIdle()) throw new Error("Wait until the current run settles.");
				if (path === "-" && !s.previous) throw new Error("No previous directory.");
				ctx.ui.notify(`cwd: ${switchTo(ctx, path === "reset" ? s.origin : path === "-" ? s.previous! : path)}`, "info");
			} catch (error) { ctx.ui.notify(message(error), "error"); }
		},
	});

	const list = (ctx: ExtensionContext, signal?: AbortSignal) => listWorktrees(pi.exec, cwd(ctx), signal);
	const selectTree = async (ctx: ExtensionContext, path: string, signal?: AbortSignal) => {
		const target = directory(cwd(ctx), path);
		if (!(await list(ctx, signal)).some((tree) => !tree.bare && !tree.prunable && tree.path === target)) {
			throw new Error("That path is not an available worktree of the current repository.");
		}
		if (signal?.aborted) throw new Error("Worktree switch cancelled.");
		return switchTo(ctx, target);
	};
	const add = async (ctx: ExtensionContext, name: string, ref: string, detached: boolean, parent?: string, signal?: AbortSignal) => {
		const base = cwd(ctx);
		const main = (await listWorktrees(pi.exec, base, signal))[0];
		if (!main) throw new Error("No worktrees found.");
		return createWorktree(pi.exec, base, parent ?? dirname(main.path), name, ref, detached, signal);
	};

	pi.registerCommand("worktree", { description: "Select a Git worktree, or use list / new",
		getArgumentCompletions: (p) => ["list", "new"].filter((s) => s !== p && s.startsWith(p)).map((s) => ({ value: s, label: s })),
		async handler(args, ctx) {
			try {
				if (!ctx.isIdle()) throw new Error("Wait until the current run settles.");
				const action = args.trim();
				if (action === "new") {
					if (!ctx.hasUI) throw new Error("Worktree creation via /worktree new needs interactive UI.");
					const ref = await ctx.ui.input("Ref or commit for detached worktree", "HEAD");
					if (ref === undefined) return;
					const name = await ctx.ui.input("New directory name (next to the main worktree)");
					if (!name?.trim()) return;
					const target = await add(ctx, name.trim(), ref.trim() || "HEAD", true);
					ctx.ui.notify(`Created detached worktree; cwd: ${switchTo(ctx, target)}`, "info");
					return;
				}
				if (action && action !== "list") throw new Error(`Unknown worktree action ${JSON.stringify(printable(action))}. Usage: /worktree [list|new]`);
				const trees = await list(ctx);
				if (action === "list") { ctx.ui.notify(trees.map(describe).join("\n") || "No worktrees", "info"); return; }
				const available = trees.filter((tree) => !tree.bare && !tree.prunable);
				const rows = available.map((tree, i) => `${i + 1}. ${describe(tree)}${tree.path === state?.current ? " (current)" : ""}`);
				const item = await ctx.ui.select("Switch worktree", rows);
				const tree = item === undefined ? undefined : available[rows.indexOf(item)];
				if (tree) ctx.ui.notify(`cwd: ${await selectTree(ctx, tree.path)}`, "info");
			} catch (error) { ctx.ui.notify(message(error), "error"); }
		},
	});

	pi.registerTool({ name: "change_dir", label: "Change directory",
		description: "Change the execution directory for this Pi session and its subsequent native file and shell calls. Unlike Bash cd, it persists across calls. Call by itself and wait for success.",
		promptSnippet: "Change the execution directory for subsequent file and shell calls",
		promptGuidelines: ["Use change_dir instead of Bash cd when subsequent calls need a different directory. A Bash cd affects only that Bash call. Call change_dir by itself and wait for success."],
		parameters: Type.Object({ path: Type.String({ description: "Existing directory; relative to the current execution directory, absolute, or ~/…" }) }), executionMode: "sequential",
		async execute(_id, args, _signal, _update, ctx) { return result(`Session execution cwd: ${switchTo(ctx, args.path)}`); },
	});
	pi.registerTool({ name: "worktree_list", label: "List worktrees", description: "List worktrees of the Git repository at the session execution cwd.",
		parameters: Type.Object({}),
		async execute(_id, _args, signal, _update, ctx) { return result((await list(ctx, signal)).map(describe).join("\n") || "No worktrees"); },
	});
	pi.registerTool({ name: "worktree_create", label: "Create worktree",
		description: "Create a Git worktree without forcing or deleting anything. Detached by default, suitable for review. Set switchTo: true to make it the execution directory of this session. Call by itself and wait for success.",
		promptSnippet: "Create an isolated Git worktree and optionally switch the session into it",
		promptGuidelines: ["When the user asks to review code in a new worktree, call worktree_create by itself with the requested ref, detached: true and switchTo: true. Wait for success, then review in the reported directory using relative paths. If creation or switching fails, do not proceed in the old directory."],
		parameters: Type.Object({
			name: Type.String({ description: "Name for a new directory" }),
			ref: Type.String({ description: "Commit/ref, or an existing local branch in attached mode" }),
			detached: Type.Optional(Type.Boolean({ description: "Use detached HEAD; defaults to true. Set false to check out an existing local branch." })),
			parent: Type.Optional(Type.String({ description: "Existing parent directory; defaults to the main worktree's parent" })),
			switchTo: Type.Optional(Type.Boolean({ description: "Set true to make the new worktree this session's execution directory. Defaults to false (create only)." })),
		}),
		executionMode: "sequential",
		async execute(_id, args, signal, _update, ctx) {
			const path = await add(ctx, args.name, args.ref, args.detached ?? true, args.parent, signal);
			if (args.switchTo && !signal?.aborted) return result(`Created ${path}. Session execution cwd: ${switchTo(ctx, path)}`);
			return result(`Created ${path}. Execution cwd is unchanged.`);
		},
	});
	pi.registerTool({ name: "worktree_switch", label: "Switch worktree", description: "Select a listed worktree by path for subsequent native tool calls. Call by itself before using relative paths.",
		parameters: Type.Object({ path: Type.String() }), executionMode: "sequential",
		async execute(_id, args, signal, _update, ctx) { return result(`Session execution cwd: ${await selectTree(ctx, args.path, signal)}`); },
	});
}

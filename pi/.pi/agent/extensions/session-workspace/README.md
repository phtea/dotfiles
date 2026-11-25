# Session Workspace for Pi 1.6.1 (Linux / WSL)

Change where built-in tools execute without changing the session's project identity. This is not a sandbox and does not call `process.chdir()`.

## Commands

| Command | Action |
|---|---|
| `/cwd` | Show the execution directory and the original Pi project directory. |
| `/cwd <path>` | Select an existing directory (`~`, `~/…`, relative to current execution cwd, or absolute). Tab completes directories. Enter paths as written, without shell quotes; spaces are supported. Use `./-` or `./reset` for directories with those names. |
| `/cwd -` | Go back to the previous successful selection (can toggle between two directories). |
| `/cwd reset` | Return to the session's original directory. |
| `/worktree` | Pick an available worktree of the Git repo at the execution cwd. |
| `/worktree list` | Show paths, branches or detached commit IDs. |
| `/worktree new` | Ask for a ref (blank means `HEAD`) and a new directory name. Create a detached worktree next to the first/main worktree, then select it. |

Agent tools: `change_dir({path})`, `worktree_list({})`, `worktree_create({name, ref, detached?, parent?, switchTo?})`, and `worktree_switch({path})`. `detached` defaults to `true`; `switchTo` defaults to `false`. Set `detached: false` to check out an **existing local branch** (Git will refuse if it is already checked out). `parent` is an existing directory relative to the execution cwd or an absolute path. Nothing is removed, forced, fetched, merged, or automatically cleaned up. Git checkout still honors attributes/filters configured by Git; use it on repositories you trust. The extension disables `post-checkout` hooks for its own worktree creation.

Example prompt:

> Create a detached worktree named `review-feature` from the local ref `feature`, switch to it, then review `main...HEAD`. Don't edit files. Call the create/switch tool on its own before issuing file and shell calls.

An ordinary branch/ref must exist locally. Use `origin/feature` for a locally available remote-tracking ref; this extension does not fetch. When delegating review, give `reviewer` the worktree path as its explicit `cwd` (and supply the diff if needed).

## Execution and state

- `state.ts` validates/canonicalizes paths and reads session state; `git.ts` uses `pi.exec` with argv and explicit cwd; `index.ts` registers commands, tools and UI. The standard Bash, PowerShell, read, write, edit, find, grep and ls tool definitions are wrapped at session start, without activating unavailable/inactive built-ins or replacing existing custom tools under those names. They keep their normal arguments and run with an execution context whose cwd is selected once per invocation. A workspace-changing tool must run directly and alone: mixed batches are blocked so a failed switch cannot silently send sibling calls to the old directory.
- `!`/`!!` use the selected directory unless an earlier `user_bash` handler takes ownership. The existing compact footer shows the selected path and Git branch (or detached commit); the standard footer gets a `cwd:` status without replacement. The branch is refreshed on switching and after an agent run. `@` autocomplete in the override uses Pi's completion engine with `fd` on `PATH` and inserts an **absolute** attachment path. Without `fd`, or when typing an attachment manually, use an explicit absolute path; Pi expands relative attachments against the original project directory. Normal command completion is unchanged.
- Cwd selections are native `session-workspace:v1` custom entries, excluded from the model transcript. Restoration uses the newest recorded selection for the original cwd across **all** journal entries, not the active leaf. Thus `/tree` and compaction don't rewind the selection. An interactive fork inherits the parent selection when the parent journal is available and the original cwd is the same; a CLI fork to a different original cwd starts there. If Pi hasn't persisted a conversation yet (or if using `--no-session`), there is no disk recovery after exiting. Independent sessions don't share workspace state.
- On loading an unavailable saved path, the extension warns and falls back to the original cwd; the saved selection remains until the next explicit selection/reset. If the selected path disappears mid-session, managed operations fail rather than silently running somewhere else.
- For custom commands, tools and a future Command Center, synchronous query: `const request = { sessionId: ctx.sessionManager.getSessionId(), cwd: undefined, branch: undefined, error: undefined }; pi.events.emit("session-workspace:resolve", request)`. Respect `error`; absent a responder, use `ctx.cwd`. A consumer may send `displayOnly: true` to skip filesystem verification for a renderer. The main Bash permission gate checks global rules plus both the original and execution directory's `.pi/permissions.json` (additive). Worktree tools are separate, narrowly scoped Git operations, not generic Bash commands.

## Project boundary

Pi 1.6.1 has no public setter for the actual session cwd. `ctx.cwd`, `SessionManager.getCwd()`, project trust, `AGENTS.md`, skills, project settings, discovered resources/extensions, session storage and third-party backends stay attached to the original project, even after `/reload`. The extension tells the model which execution directory is selected, without reloading or executing target project configuration. Arbitrary extension/MCP tools and the subagent launcher do not inherit this override automatically. To load the worktree's own resources, start Pi there, or copy your history there with `(cd /path/to/worktree && pi --fork <session-id-or-file>)`. The original session remains unchanged.

## Design references and verification

- [fitchmultz/pi-change-working-dir](https://github.com/fitchmultz/pi-change-working-dir): execution overlay and event-bus integration while preserving original project configuration. This extension keeps cwd session-wide rather than branch-local.
- [narumiruna/pi-extensions](https://github.com/narumiruna/pi-extensions/tree/HEAD/packages/pi-worktree): `src/session.ts` uses a native session replacement for full project switching. That is a better fit when resources must change too, but changes session identity.
- [harms-haus/pi-worktrees](https://github.com/harms-haus/pi-worktrees): delegates switching to `/cwd`; this implementation shares selection directly and deliberately omits merge/cleanup.

Verified in temporary repositories with Pi 1.6.1: TUI selection, `!pwd`, path completion, `@` absolute completion, worktree dialog/list and footer; native tool execution for Bash and all six file/search tools; two independent sessions, persisted reopen, native runtime resume/new/fork, tree navigation, simulated compaction record and missing paths. Source branch and working tree stayed unchanged in Git tests. No live model request, provider-driven compaction or PowerShell executable was tested.

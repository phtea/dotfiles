import { lstatSync } from "node:fs";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { directory } from "./state.ts";

export interface Worktree { path: string; head?: string; branch?: string; bare?: boolean; prunable?: boolean; locked?: boolean }

export async function listWorktrees(exec: ExtensionAPI["exec"], cwd: string, signal?: AbortSignal): Promise<Worktree[]> {
	const result = await exec("git", ["worktree", "list", "--porcelain", "-z"], { cwd, signal, timeout: 10_000, maxBuffer: 2_000_000 });
	if (result.code) throw new Error(result.stderr.trim() || "Could not list Git worktrees.");
	const trees: Worktree[] = [];
	let current: Worktree | undefined;
	for (const field of result.stdout.split("\0")) {
		if (field.startsWith("worktree ")) {
			current = { path: field.slice(9) };
			trees.push(current);
		} else if (current) {
			if (field.startsWith("HEAD ")) current.head = field.slice(5);
			else if (field.startsWith("branch refs/heads/")) current.branch = field.slice(18);
			else if (field === "bare") current.bare = true;
			else if (field === "locked" || field.startsWith("locked ")) current.locked = true;
			else if (field === "prunable" || field.startsWith("prunable ")) current.prunable = true;
		}
	}
	return trees;
}

export function describe(tree: Worktree): string {
	return `${tree.path} · ${tree.branch ?? (tree.bare ? "bare" : `detached ${tree.head?.slice(0, 8) ?? "HEAD"}`)}${tree.prunable ? " (unavailable)" : ""}`.replace(/[\p{Cc}\p{Cf}]/gu, "?");
}

export async function createWorktree(exec: ExtensionAPI["exec"], cwd: string, parent: string, name: string, ref: string, detached: boolean, signal?: AbortSignal): Promise<string> {
	if (!/^[\w.-]+$/.test(name) || name === "." || name === "..") throw new Error("Use a new directory name with letters, digits, dots, underscores or hyphens.");
	const target = join(directory(cwd, parent), name);
	try {
		lstatSync(target);
		throw new Error(`Path already exists: ${target}`);
	} catch (error) {
		if ((error as NodeJS.ErrnoException).code !== "ENOENT") throw error;
	}
	if (!ref || ref.startsWith("-") || /[\p{Cc}\p{Cf}]/u.test(ref)) throw new Error("Expected a Git ref, not a command line option.");
	if (!detached) {
		const valid = await exec("git", ["check-ref-format", `refs/heads/${ref}`], { cwd, signal, timeout: 10_000 });
		if (valid.code) throw new Error(`Invalid local branch name: ${ref}`);
	}
	const rev = detached ? `${ref}^{commit}` : `refs/heads/${ref}^{commit}`;
	const resolved = await exec("git", ["rev-parse", "--verify", "--end-of-options", rev], { cwd, signal, timeout: 10_000, maxBuffer: 64_000 });
	const oid = resolved.stdout.trim();
	if (resolved.code || !/^(?:[0-9a-f]{40}|[0-9a-f]{64})$/.test(oid)) {
		throw new Error(detached ? `Not a commit or ref: ${ref}` : `Not an existing local branch: ${ref}`);
	}
	// No force, deletion, branch creation or fetch. Avoid post-checkout hooks.
	const args = ["-c", "core.hooksPath=/dev/null", "worktree", "add", ...(detached ? ["--detach"] : []), "--", target, detached ? oid : ref];
	const result = await exec("git", args, { cwd, signal, timeout: 120_000, maxBuffer: 1_000_000 });
	if (result.code) throw new Error(result.stderr.trim() || `Git worktree add failed; inspect ${target} before retrying.`);
	return target;
}

export function removalBlock(tree: Worktree, mainPath: string, current: string, origin: string): string | undefined {
	if (tree.bare || tree.path === mainPath) return "The main worktree cannot be removed here.";
	if (tree.prunable) return "This worktree is unavailable.";
	if (tree.locked) return "This worktree is locked.";
	const target = directory(current, tree.path);
	for (const [label, path] of [["current directory", current], ["session origin", origin]]) {
		const protectedPath = directory(current, path);
		if (protectedPath === target || protectedPath.startsWith(`${target}/`)) return `Cannot remove the worktree containing this session's ${label}.`;
	}
}

export async function removeWorktree(exec: ExtensionAPI["exec"], cwd: string, origin: string, chosen: Worktree, force = false): Promise<void> {
	const trees = await listWorktrees(exec, cwd);
	const tree = trees.find((entry) => entry.path === chosen.path);
	if (!tree || tree.head !== chosen.head || tree.branch !== chosen.branch) throw new Error("The worktree changed. Reopen the menu before removing it.");
	const blocked = removalBlock(tree, trees[0].path, cwd, origin);
	if (blocked) throw new Error(blocked);
	if (!force) {
		const status = await exec("git", ["status", "--porcelain", "-z", "--untracked-files=all", "--ignored=matching"], { cwd: tree.path, timeout: 15_000, maxBuffer: 1_000_000 });
		if (status.code) throw new Error(status.stderr.trim() || "Could not check the worktree for local files.");
		if (status.stdout) throw new Error("Worktree has changes, untracked or ignored files. Nothing removed.");
	}
	const result = await exec("git", ["worktree", "remove", ...(force ? ["--force"] : []), "--", tree.path], { cwd, timeout: 30_000, maxBuffer: 1_000_000 });
	if (result.code) throw new Error(result.stderr.trim() || "Git refused to remove the worktree.");
}

export async function gitBranch(exec: ExtensionAPI["exec"], cwd: string): Promise<string> {
	const args = { cwd, timeout: 4_000, maxBuffer: 64_000 };
	const branch = await exec("git", ["symbolic-ref", "--quiet", "--short", "HEAD"], args);
	if (branch.code === 0) return branch.stdout.trim();
	const head = await exec("git", ["rev-parse", "--short", "HEAD"], args);
	return head.code === 0 ? `detached ${head.stdout.trim()}` : "";
}

import { accessSync, constants, realpathSync, statSync } from "node:fs";
import { homedir } from "node:os";
import type { ExtensionContext } from "@earendil-works/pi-coding-agent";

export const ENTRY = "session-workspace:v1";
export const RESOLVE = "session-workspace:resolve";
export interface WorkspaceRequest {
	sessionId: string;
	cwd?: string;
	branch?: string;
	error?: string;
	displayOnly?: boolean;
}
export interface Selection { origin: string; current: string; previous?: string }

export function expand(input: string): string {
	return input === "~" ? homedir() : input.startsWith("~/") ? `${homedir()}${input.slice(1)}` : input;
}

export function directory(base: string, input: string): string {
	if (!input || /[\p{Cc}\p{Cf}]/u.test(input)) throw new Error("Expected a directory path without control characters.");
	const p = expand(input);
	const full = p.startsWith("/") ? p : `${base}/${p}`; // preserve symlink/.. traversal
	const canonical = realpathSync(full);
	if (/[\p{Cc}\p{Cf}]/u.test(canonical)) throw new Error("Resolved directory contains control characters.");
	if (!statSync(canonical).isDirectory()) throw new Error(`Not a directory: ${full}`);
	accessSync(canonical, constants.X_OK);
	return canonical;
}

export function selected(sm: Pick<ExtensionContext["sessionManager"], "getEntries">, origin: string): Selection | undefined {
	for (const entry of [...sm.getEntries()].reverse()) {
		if (entry.type !== "custom" || entry.customType !== ENTRY) continue;
		const data = entry.data as Partial<Selection> | undefined;
		if (data?.origin === origin && typeof data.current === "string") {
			return { origin, current: data.current, previous: typeof data.previous === "string" ? data.previous : undefined };
		}
	}
}

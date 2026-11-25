import { readFile } from "node:fs/promises";
import { join } from "node:path";
import { getAgentDir, type ExtensionAPI, type ExtensionContext } from "@earendil-works/pi-coding-agent";

interface Rule {
	text: string;
	pattern: RegExp;
	source: string;
}

function escapeRegex(text: string): string {
	return text.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function compileRule(text: string, source: string): Rule {
	const trimmed = text.trim();
	if (!/^[\w./-]+(?:[ \t]+[\w./-]+)*(?:[ \t]*\*)?$/.test(trimmed)) {
		throw new Error(`Invalid rule in ${source}: use literal command words and an optional trailing *`);
	}
	const prefix = trimmed.endsWith("*");
	const [exe, ...args] = trimmed.replace(/\*$/, "").trimEnd().split(/[ \t]+/);
	const token = (word: string) => {
		const escaped = escapeRegex(word);
		return `(?:${escaped}|'${escaped}'|"${escaped}")`;
	};
	const start = String.raw`(?:^|[\n;|&({])[ \t]*`;
	const wrappers = String.raw`(?:(?:command|exec|env)[ \t]+|[A-Za-z_][\w]*=[^\s;|&()]*[ \t]+)*`;
	const dir = exe!.includes("/") ? "" : String.raw`(?:[^\s;|&()"']+/)?`;
	// Recognize common Git global options before the subcommand (git -C path push).
	const gitFlags = exe === "git" && args.length
		? String.raw`(?:[ \t]+(?:(?:-C|-c|--git-dir|--work-tree|--namespace)[ \t]+(?:"[^"]*"|'[^']*'|[^\s;|&()]+)|--?[^\s;|&()]+))*`
		: "";
	const tail = args.map((arg) => `[ \\t]+${token(arg)}`).join("");
	const end = prefix ? String.raw`(?=$|[\s;|&()<>])` : String.raw`(?=[ \t]*(?:$|[\n;|&)}<>]))`;
	return { text, source, pattern: new RegExp(`${start}${wrappers}${dir}${token(exe!)}${gitFlags}${tail}${end}`) };
}

function rules(value: unknown, source: string): Rule[] {
	if (!Array.isArray(value) || !value.every((entry) => typeof entry === "string")) {
		throw new Error(`Expected a deny list in ${source}`);
	}
	return value.map((entry) => compileRule(entry, source));
}

async function readRules(path: string, agent: string): Promise<Rule[]> {
	let raw: string;
	try {
		raw = await readFile(path, "utf8");
	} catch (error) {
		if ((error as NodeJS.ErrnoException).code === "ENOENT") return [];
		throw error;
	}
	try {
		const data = JSON.parse(raw);
		if (!data || typeof data !== "object" || Array.isArray(data)) throw new Error("Expected a policy object");
		const shared = rules(Object.hasOwn(data, "deny") ? data.deny : [], path);
		if (!Object.hasOwn(data, "agents")) return shared;
		if (!data.agents || typeof data.agents !== "object" || Array.isArray(data.agents)) {
			throw new Error("Expected an agents object");
		}
		if (!Object.hasOwn(data.agents, agent)) return shared;
		const profile = data.agents[agent];
		if (!profile || typeof profile !== "object" || Array.isArray(profile)) throw new Error("Expected an agent policy");
		return [...shared, ...rules(Object.hasOwn(profile, "deny") ? profile.deny : [], `${path} [${agent}]`)];
	} catch (error) {
		throw new Error(`Invalid policy in ${path}: ${(error as Error).message}`);
	}
}

export default function (pi: ExtensionAPI) {
	const globalPath = join(getAgentDir(), "permissions.json");
	const agent = process.env.PI_SUBAGENT_PERMISSION_PROFILE || "main";

	async function effectiveRules(ctx: ExtensionContext): Promise<Rule[]> {
		const request: { sessionId: string; cwd?: string; error?: string } = { sessionId: ctx.sessionManager.getSessionId() };
		pi.events.emit("session-workspace:resolve", request);
		if (request.error) throw new Error(request.error);
		const paths = new Set([globalPath, join(ctx.cwd, ".pi", "permissions.json")]);
		if (request.cwd) paths.add(join(request.cwd, ".pi", "permissions.json"));
		return (await Promise.all([...paths].map((path) => readRules(path, agent)))).flat();
	}

	pi.registerCommand("permissions", {
		description: "Show denied shell commands for the current agent",
		async handler(_args, ctx) {
			try {
				const deny = await effectiveRules(ctx);
				ctx.ui.notify(`Shell (${agent}): allowed by default.\n${deny.map((rule) => `${rule.text} — ${rule.source}`).join("\n") || "No denies"}`, "info");
			} catch (error) {
				ctx.ui.notify((error as Error).message, "error");
			}
		},
	});

	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName !== "bash" || typeof event.input.command !== "string") return;
		try {
			const command = event.input.command.replace(/\\\r?\n/g, "");
			const deny = await effectiveRules(ctx);
			const rule = deny.find((item) => item.pattern.test(command));
			if (rule) return { block: true, reason: `Command denied by ${rule.source}: ${rule.text}` };
		} catch (error) {
			return { block: true, reason: `Shell command blocked: ${(error as Error).message}` };
		}
	});
}

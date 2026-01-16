local M = {}

local save_file = vim.fn.stdpath("data") .. "/run_commands.json"

-- ---------------- persistence ----------------

local function load_commands()
	local f = io.open(save_file, "r")
	if not f then return {} end
	local ok, data = pcall(vim.fn.json_decode, f:read("*a"))
	f:close()
	return ok and type(data) == "table" and data or {}
end

local function save_commands(tbl)
	local f = io.open(save_file, "w")
	if not f then return end
	f:write(vim.fn.json_encode(tbl))
	f:close()
end

local function cwd()
	return vim.fn.getcwd()
end

-- ---------------- runner ----------------

local function run_async_qf(cmd)
	vim.notify("Running cmd: " .. cmd, vim.log.levels.INFO)
	vim.cmd("copen")

	vim.fn.setqflist({}, "r")

	vim.fn.jobstart(cmd, {
		stdout_buffered = false,
		stderr_buffered = false,

		on_stdout = function(_, data)
			if not data then return end
			vim.fn.setqflist({}, "a", {
				lines = data,
				efm = vim.o.errorformat,
			})
		end,

		on_stderr = function(_, data)
			if not data then return end
			vim.fn.setqflist({}, "a", {
				lines = data,
				efm = vim.o.errorformat,
			})
		end,

		on_exit = function(_, code)
			if code ~= 0 then
				vim.notify("Command failed: " .. cmd, vim.log.levels.ERROR)
			end
		end,
	})
end

-- ---------------- public ----------------

function M.prompt()
	local cmds = load_commands()
	local default = cmds[cwd()] or ""

	vim.ui.input({ prompt = "Run: ", default = default }, function(input)
		if not input or input == "" then return end
		cmds[cwd()] = input
		save_commands(cmds)
		run_async_qf(input)
	end)
end

function M.run_saved()
	local cmds = load_commands()
	local cmd = cmds[cwd()]
	if not cmd then
		vim.notify("No saved command for this directory", vim.log.levels.WARN)
		return
	end
	run_async_qf(cmd)
end

return M

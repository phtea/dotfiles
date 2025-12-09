if true then return end -- deprecated i think (in favour of vim-dispatch)

-- Execute commands
-- TODO: parse the parts where it compiles and actually run it through :make
-- and run the result in a separate special terminal if successfully compiled

local state_dir = vim.fn.stdpath("state")
local execute_file = state_dir .. "/execute_commands.json"

local function load_commands()
	local f = io.open(execute_file, "r")
	if not f then return {} end
	local content = f:read("*a")
	f:close()
	if content == "" then return {} end
	local ok, data = pcall(vim.json.decode, content)
	if not ok or type(data) ~= "table" then return {} end
	return data
end

local function save_commands(cmds)
	vim.fn.mkdir(state_dir, "p")
	local f, err = io.open(execute_file, "w")
	if not f then
		vim.notify("Failed to write execute commands: " .. tostring(err), vim.log.levels.ERROR)
		return
	end
	f:write(vim.json.encode(cmds))
	f:close()
end

local function open_terminal_run(cmd)
	-- Open a terminal split running your configured shell (stays open)
	vim.cmd("botright split | resize 12 | terminal")
	local buf = vim.api.nvim_get_current_buf()

	-- Manual close: press q in terminal-mode
	vim.keymap.set("t", "<C-c>", [[<C-\><C-n>:bd!<CR>]], { buffer = buf, silent = true })

	-- Send the command to the terminal job
	local job = vim.b.terminal_job_id
	if not job then
		vim.notify("No terminal job id", vim.log.levels.ERROR)
		return
	end

	-- Run it (supports && | redirects etc because the shell interprets it)
	vim.fn.chansend(job, cmd .. "\n")

	vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("Execute", function()
	local cwd = vim.uv.cwd() or vim.fn.getcwd()
	if not cwd or cwd == "" then
		vim.notify("No current working directory", vim.log.levels.ERROR)
		return
	end

	local commands = load_commands()
	local prev = commands[cwd] or ""

	vim.ui.input({
		prompt = "Execute command: ",
		default = prev,
		completion = "shellcmdline",
	}, function(input)
		if input == nil or input == "" then return end

		commands[cwd] = input
		save_commands(commands)

		-- TODO: if compile (kinda like this)
		-- :let &makeprg="g++ -std=c++20 -O0 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wsign-conversion -Werror main.cpp -o main" | make | cwindow | !./main)
		-- failed - don't open terminal, else execute compiled command (only for compiled languages)

		open_terminal_run(input)
	end)
end, { nargs = 0, desc = "Execute (per cwd) using a stored shell command in a terminal" })

vim.keymap.set("n", "<leader>x", "<CMD>Execute<CR>", { desc = "Execute code" })

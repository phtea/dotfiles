local M = {}

-- Toggle Quickfix window
M.toggle_quickfix = function()
	local win_ids = vim.fn.getwininfo()
	for _, win in ipairs(win_ids) do
		if win.quickfix == 1 then
			vim.cmd("cclose")
			return
		end
	end
	vim.cmd("copen")
end

-- Copy paths
local function copy_to_clipboard(path)
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end

M.copy_relative_path = function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
	copy_to_clipboard(path)
end

M.copy_absolute_path = function()
	copy_to_clipboard(vim.fn.expand("%:p"))
end

M.copy_filename = function()
	copy_to_clipboard(vim.fn.expand("%:t"))
end

M.copy_directory = function()
	copy_to_clipboard(vim.fn.expand("%:p:h"))
end

-- Session handling
local session_file = vim.fn.stdpath("state") .. "/Session.vim"
M.save_and_restart_session = function()
	vim.cmd("mks! " .. vim.fn.fnameescape(session_file))
	vim.cmd("restart source " .. vim.fn.fnameescape(session_file))
end

-- Turn ", " into ",\n" in visual selection
M.split_inline_args = function()
	vim.cmd([[silent! s/, /,\r/g|noh]])
end

-- Toggle diagnostics
M.toggle_diagnostics = function()
	local enabled = not vim.diagnostic.is_enabled()
	vim.diagnostic.enable(enabled)
	print("Diagnostics: " .. (enabled and "ON" or "OFF"))
end

-- Generate ctags
M.generate_ctags = function()
	local result = vim.fn.system("ctags -R .")
	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to generate ctags: " .. result, vim.log.levels.ERROR)
	else
		vim.notify("Ctags generated successfully", vim.log.levels.INFO)
	end
end

-- Notes: open
local notes_path = vim.fn.expand("~/notes.md")
M.open_notes = function()
	vim.cmd("keepjumps edit +$ " .. notes_path)
	vim.bo.buflisted = false
	vim.bo.bufhidden = "hide"
end

-- Notes: append visual selection
M.append_selection_to_notes = function()
	local file = vim.fn.expand("%:p")
	local stamp = os.date("%Y-%m-%d %H:%M")
	vim.cmd([[normal! "zy]])
	local lines = vim.fn.split(vim.fn.getreg("z"), "\n")
	local ft = vim.bo.filetype
	if ft == "" then
		local ext = vim.fn.fnamemodify(file, ":e")
		ft = ext ~= "" and ext or "text"
	end
	local start_line = vim.fn.getpos("'<")[2]
	local header = string.format("## %s: %s:%d", stamp, file, start_line)
	local to_append = { "", header, "```" .. ft }
	vim.list_extend(to_append, lines)
	vim.list_extend(to_append, { "```", "" })
	vim.fn.writefile(to_append, notes_path, "a")
	print("Appended selection to " .. notes_path)
end

-- Explorer
local function is_wsl()
	local uname = vim.loop.os_uname()
	return uname.release:match("Microsoft") or uname.release:match("WSL")
end

M.open_explorer = function()
	local dir = vim.fn.expand("%:p:h")
	if dir == "" then dir = vim.fn.getcwd() end
	local sys = vim.loop.os_uname().sysname

	if is_wsl() then
		local win_path = dir:gsub("^/mnt/([a-z])", "%1:"):gsub("/", "\\")
		vim.fn.jobstart({ "explorer.exe", win_path }, { detach = true })
	elseif sys == "Linux" then
		vim.fn.jobstart({ "xdg-open", dir }, { detach = true })
	elseif sys == "Darwin" then
		vim.fn.jobstart({ "open", dir }, { detach = true })
	elseif sys:match("Windows") then
		vim.fn.jobstart({ "explorer.exe", dir }, { detach = true })
	end
end

function M.netrw_parent_dir()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		vim.cmd("Explore")
		return
	end

	local name = vim.fn.fnamemodify(file, ":t")

	-- Open netrw in the file's directory
	vim.cmd("Explore")

	-- netrw populates asynchronously → defer cursor move
	vim.defer_fn(function()
		local buf = vim.api.nvim_get_current_buf()

		-- safety: ensure this is a netrw buffer
		if vim.bo[buf].filetype ~= "netrw" then
			return
		end

		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

		for i, line in ipairs(lines) do
			-- netrw adds trailing symbols, so match loosely
			if line:find(name, 1, true) then
				vim.api.nvim_win_set_cursor(0, { i, 0 })
				return
			end
		end
	end, 0)
end

return M

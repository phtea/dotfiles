-- Leader key
vim.g.mapleader = " "

-- Windows
vim.keymap.set("n", "<leader>w", "<C-W>", { remap = true })

-- Quickfix list navigation
vim.keymap.set("n", "<A-j>", ":cnext<CR>", { noremap = true, silent = true, })
vim.keymap.set("n", "<A-k>", ":cprev<CR>", { noremap = true, silent = true, })

-- F alternatives
vim.keymap.set("n", "<F2>", ":cnext<CR>", { noremap = true, silent = true, })
vim.keymap.set("n", "<F1>", ":cprev<CR>", { noremap = true, silent = true, })

-- Comment
vim.keymap.set("n", "<leader>c", "gcc", { remap = true, desc = "Comment current line" })
vim.keymap.set("v", "<leader>c", "gc", { remap = true, desc = "Comment selected lines" })

-- Substitute current word in this file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-R><C-W>\>/<C-R><C-W>/gIc<Left><Left><Left><Left>]],
	{ desc = "Replace word under cursor" })
vim.keymap.set("v", "<leader>s", [["sy:%s/<C-R>s/<C-R>s/gIc<Left><Left><Left><Left>]],
	{ desc = "Replace visual selection" })

-- Replace word under cursor (project)
vim.keymap.set("n", "<leader>S", [[:Grep -w <C-R><C-W><CR><C-W>k:cdo s/\<<C-R><C-W>\>/<C-R><C-W>/gc<Left><Left><Left>]],
	{ desc = "Replace word under cursor (project)" })
vim.keymap.set("v", "<leader>S", [["sy:Grep "<C-R>s"<CR><C-W>k:cdo s/<C-R>s/<C-R>s/gc<Left><Left><Left>]],
	{ desc = "Replace visual selection (project)" })

-- Grep
vim.api.nvim_create_user_command("Grep", "silent grep! <args> | redraw! | cwindow", { nargs = "+", complete = "file" })
vim.api.nvim_create_user_command("Ggrep", "silent grep! <args> `git ls-files` | redraw! | cwindow", { nargs = "+" })

-- Yank
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+y$]], { desc = "Yank to system clipboard to EOL" })

-- Paste
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste after from system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>P", [["+P]], { desc = "Paste before from system clipboard" })

-- Misc
local function toggle_qf()
	for _, win in ipairs(vim.fn.getwininfo()) do
		if win.quickfix == 1 then
			vim.cmd("cclose")
			return
		end
	end
	vim.cmd("copen")
end
vim.keymap.set("n", "Q", toggle_qf, { silent = true })
vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, { desc = "Show documentation" })
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true, })
vim.keymap.set("n", "<leader>td", function()
	local enabled = not vim.diagnostic.is_enabled()
	vim.diagnostic.enable(enabled)
	print("Diagnostics: " .. (enabled and "ON" or "OFF"))
end, { desc = "Toggle diagnostics" })

-- Session handling
local session_file = vim.fn.stdpath("state") .. "/Session.vim"
vim.keymap.set("n", "<leader>R", function()
	vim.cmd("mks! " .. vim.fn.fnameescape(session_file))
	vim.cmd("restart source " .. vim.fn.fnameescape(session_file))
end, { desc = "Save session and restart with it" })

-- Turn ", " into ",\n" in visual selection
vim.keymap.set("x", "<leader>,", function()
	vim.cmd([[silent! s/, /,\r/g|noh]])
end, { desc = "Split inline args to multiline" })

-- Reindent whole file
vim.keymap.set("n", "<leader>=",
	"gg=G``zz",
	{ desc = "Reindent whole file" }
)

-- Lsp and code
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { desc = "LSP: Code action" })
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "LSP: Rename symbol" })
vim.api.nvim_create_user_command("Fmt", function() vim.lsp.buf.format() end, { nargs = 0, desc = "LSP: Format buffer" })
vim.keymap.set("n", "<leader>x", "<CMD>Compile<CR>", { desc = "Compile code" })

-- Git
vim.api.nvim_create_user_command("ResetDiffChange", "Gitsigns reset_hunk", { nargs = 0, desc = "Git: Reset hunk" })
vim.api.nvim_create_user_command("StageDiffChange", "Gitsigns stage_hunk", { nargs = 0, desc = "Git: Reset hunk" })
vim.api.nvim_create_user_command("LogFile", "lua Snacks.lazygit.log_file()", { nargs = 0, desc = "Lazygit: Log file" })

-- Notes
vim.keymap.set("n", "<leader>n", function()
	vim.cmd("edit +$ " .. vim.fn.expand("~/notes.md"))
end, { desc = "Open global notes" })

vim.keymap.set("x", "<leader>an", function()
	-- absolute path of current file
	local file = vim.fn.expand("%:p")
	local stamp = os.date("%Y-%m-%d %H:%M")

	-- yank selection into "z
	vim.cmd([[normal! "zy]])
	local lines = vim.fn.split(vim.fn.getreg("z"), "\n")

	local notes_path = vim.fn.expand("~/notes.md")

	-- choose language for code fence
	local ft = vim.bo.filetype or ""
	if ft == "" then
		-- fallback: use extension, or "text" if none
		local ext = vim.fn.fnamemodify(file, ":e")
		ft = ext ~= "" and ext or "text"
	end

	local header = string.format("## %s (%s)", stamp, file)

	local to_append = { "", header, "", "```" .. ft }
	vim.list_extend(to_append, lines)
	vim.list_extend(to_append, { "```", "" })

	vim.fn.writefile(to_append, notes_path, "a")
	print("Appended selection to notes.md")
end, { desc = "Append selection to global notes" })

local function is_wsl()
	local uname = vim.loop.os_uname()
	return uname.release:match("Microsoft") or uname.release:match("WSL")
end

local function open_explorer()
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

vim.keymap.set("n", "<leader>ex", open_explorer, { desc = "Open folder in system explorer" })

-- Remove default LSP keymaps if present
pcall(vim.keymap.del, "n", "gri")
pcall(vim.keymap.del, "n", "grr")
pcall(vim.keymap.del, "x", "gra")
pcall(vim.keymap.del, "n", "gra")
pcall(vim.keymap.del, "n", "grn")
pcall(vim.keymap.del, "n", "grc")
pcall(vim.keymap.del, "n", "grt")

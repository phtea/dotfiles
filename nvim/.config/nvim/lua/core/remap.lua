local H = require("core.helper_functions")
local run = require("core.run_cmd")

vim.keymap.set("n", "`<Space>", run.prompt, { silent = true })
vim.keymap.set("n", "`<CR>", run.run_saved, { silent = true })

-- Leader key
vim.g.mapleader = " "

local set_keymap = vim.keymap.set
local set_command = vim.api.nvim_create_user_command

-- Windows
set_keymap("n", "<leader>w", "<C-W>", { remap = true })

-- Open parent dir
set_keymap("n", "-", H.netrw_parent_dir, { desc = "" })

-- Yank
set_keymap({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
set_keymap("n", "<leader>Y", [["+y$]], { desc = "Yank to system clipboard to EOL" })

-- Quickfix
set_keymap("n", "<F1>", ":cprev<CR>", { silent = true, })
set_keymap("n", "<F2>", ":cnext<CR>", { silent = true, })
set_keymap('n', '<leader>q', H.toggle_quickfix, { silent = true, desc = "Toggle quickfix window" })

-- Comment
set_keymap("n", "<leader>c", "gcc", { remap = true, desc = "Comment current line" })
set_keymap("v", "<leader>c", "gc", { remap = true, desc = "Comment selected lines" })

-- <F1> for file info if in insert mode cuz I definitely would prefer that over vim's help
set_keymap("i", "<F1>", "<Esc>g<C-G>", { silent = true, })

-- Substitute current word in this file
set_keymap("n", "<Esc>", ":nohlsearch<CR>", { silent = true, })
set_keymap("n", "<leader>s", [[:%s/\<<C-R><C-W>\>/<C-R><C-W>/gIc<Left><Left><Left><Left>]],
	{ desc = "Replace word under cursor" })
set_keymap("v", "<leader>s", [["sy:%s/<C-R>s/<C-R>s/gIc<Left><Left><Left><Left>]],
	{ desc = "Replace visual selection" })

-- Grep
set_command("Grep", "silent grep! <args> | redraw! | cwindow", { nargs = "+", complete = "file" })
set_command("Ggrep", "silent grep! <args> `git ls-files` | redraw! | cwindow", { nargs = "+" })

-- Copy paths
set_keymap("n", "<leader>pr", H.copy_relative_path, { desc = "Copy relative path" })
set_keymap("n", "<leader>pa", H.copy_absolute_path, { desc = "Copy absolute path" })
set_keymap("n", "<leader>pf", H.copy_filename, { desc = "Copy filename" })
set_keymap("n", "<leader>pd", H.copy_directory, { desc = "Copy directory path" })

-- Session
set_keymap("n", "<leader>R", H.save_and_restart_session, { desc = "Save session and restart with it" })

-- Visual manipulation
set_keymap("x", "<leader>,", H.split_inline_args, { desc = "Split inline args to multiline" })

-- Notes
set_keymap("n", "<leader>nn", H.open_notes, { desc = "Open global notes (no jumplist)" })
set_keymap("x", "<leader>na", H.append_selection_to_notes, { desc = "Append selection to global notes" })

-- Reindent whole file
set_keymap("n", "<leader>=", "gg=G``", { desc = "Reindent whole file" })

-- Lsp and diagnostics
set_keymap("n", "<leader>k", vim.lsp.buf.hover, { desc = "Show documentation" })
set_keymap("n", "<leader>a", vim.lsp.buf.code_action, { desc = "LSP: Code action" })
set_keymap("n", "<leader>r", vim.lsp.buf.rename, { desc = "LSP: Rename symbol" })
set_command("Fmt", function() vim.lsp.buf.format() end, { nargs = 0, desc = "LSP: Format buffer" })
set_keymap("n", "<leader>td", H.toggle_diagnostics, { desc = "Toggle diagnostics" })

-- Ctags
set_keymap("n", "<leader>C", H.generate_ctags, { desc = "Generate Ctags" })

-- Git
set_command("LogFile", "lua Snacks.lazygit.log_file()", { nargs = 0, desc = "Lazygit: Log file" })

-- Explorer
set_keymap("n", "<leader>ex", H.open_explorer, { desc = "Open folder in system explorer" })

-- Remove default LSP keymaps if present
pcall(vim.keymap.del, "n", "gri")
pcall(vim.keymap.del, "n", "grr")
pcall(vim.keymap.del, "x", "gra")
pcall(vim.keymap.del, "n", "gra")
pcall(vim.keymap.del, "n", "grn")
pcall(vim.keymap.del, "n", "grc")
pcall(vim.keymap.del, "n", "grt")

local H = require("core.helper_functions")
local RUN = require("core.run_cmd")

-- Leader key
vim.g.mapleader = " "

-- Windows
vim.keymap.set("n", "<leader>w", "<C-W>", { remap = true })

-- Open parent dir
vim.keymap.set("n", "-", H.netrw_parent_dir, { desc = "Open parent directory (netrw)" })

-- Yank
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+y$]], { desc = "Yank to system clipboard to EOL" })

-- Quickfix
vim.keymap.set("n", "<F1>", ":cprev<CR>", { silent = true, })
vim.keymap.set("n", "<F2>", ":cnext<CR>", { silent = true, })
vim.keymap.set('n', '<leader>q', H.toggle_quickfix, { silent = true, desc = "Toggle quickfix window" })

-- Comment
vim.keymap.set("n", "<leader>c", "gcc", { remap = true, desc = "Comment current line" })
vim.keymap.set("v", "<leader>c", "gc", { remap = true, desc = "Comment selected lines" })

-- <F1> for file info if in insert mode cuz I definitely would prefer that over vim's help
vim.keymap.set("i", "<F1>", "<Esc>g<C-G>", { silent = true, })
-- Hide highlight on Esc
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true, })
-- Reindent whole file
vim.keymap.set("n", "<leader>=", "gg=G``", { desc = "Reindent whole file" })

-- Substitute current word in this file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-R><C-W>\>/<C-R><C-W>/gIc<Left><Left><Left><Left>]], { desc = "Replace word under cursor" })
vim.keymap.set("v", "<leader>s", [["sy:%s/<C-R>s/<C-R>s/gIc<Left><Left><Left><Left>]], { desc = "Replace visual selection" })

-- Copy paths
vim.keymap.set("n", "<leader>pr", H.copy_relative_path, { desc = "Copy relative path" })
vim.keymap.set("n", "<leader>pa", H.copy_absolute_path, { desc = "Copy absolute path" })
vim.keymap.set("n", "<leader>pf", H.copy_filename, { desc = "Copy filename" })
vim.keymap.set("n", "<leader>pd", H.copy_directory, { desc = "Copy directory path" })

-- Session
vim.keymap.set("n", "<leader>R", H.save_and_restart_session, { desc = "Save session and restart with it" })

-- Notes
vim.keymap.set("n", "<leader>nn", H.open_notes, { desc = "Open global notes (no jumplist)" })
vim.keymap.set("x", "<leader>na", H.append_selection_to_notes, { desc = "Append selection to global notes" })

-- Lsp and diagnostics
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { desc = "LSP: Code action" })
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "LSP: Rename symbol" })
vim.keymap.set("n", "<leader>td", H.toggle_diagnostics, { desc = "Toggle diagnostics" })
vim.api.nvim_create_user_command("Fmt", function() vim.lsp.buf.format() end, { nargs = 0, desc = "LSP: Format buffer" })

-- Explorer
vim.keymap.set("n", "<leader>ex", H.open_explorer, { desc = "Open folder in system explorer" })

-- Run code
vim.keymap.set("n", "`<Space>", RUN.prompt, { silent = true })
vim.keymap.set("n", "`<CR>", RUN.run_saved, { silent = true })

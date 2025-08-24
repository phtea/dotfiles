-- Leader key
vim.g.mapleader = " "

-- Windows
vim.keymap.set("n", "<leader>w", "<C-w>", { remap = true })

-- Quickfix list navigation
vim.keymap.set("n", "<A-j>", ":cnext<CR>", { noremap = true, silent = true, })
vim.keymap.set("n", "<A-k>", ":cprev<CR>", { noremap = true, silent = true, })

-- Comment
vim.keymap.set("n", "<leader>c", "gcc", { remap = true, desc = "Comment current line" })
vim.keymap.set("v", "<leader>c", "gc", { remap = true, desc = "Comment selected lines" })

-- Subsitute current word in this file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor" })
vim.keymap.set("n", "<leader>S", [[:Grep -w <C-R><C-W><CR><C-w>k:cdo s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]],
	{ desc = "Replace word under cursor (project)" })

-- Grep
vim.api.nvim_create_user_command("Grep", "silent grep! <args> | redraw! | cwindow", { nargs = "+", complete = "file" })
vim.api.nvim_create_user_command("Ggrep", "silent grep! <args> `git ls-files` | redraw! | cwindow", { nargs = "+" })

-- Yank
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank to system clipboard to EOL" })

-- Paste
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste after from system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>P", [["+P]], { desc = "Paste before from system clipboard" })

-- Misc
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, { desc = "Show documentation" })
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true, })

-- Lsp
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { desc = "LSP: Code action" })
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "LSP: Rename symbol" })
vim.api.nvim_create_user_command("Fmt", function() vim.lsp.buf.format() end, { nargs = 0, desc = "LSP: Format buffer" })

-- Git
vim.api.nvim_create_user_command("ResetDiffChange", "Gitsigns reset_hunk", { nargs = 0, desc = "Git: Reset hunk" })
vim.api.nvim_create_user_command("StageDiffChange", "Gitsigns stage_hunk", { nargs = 0, desc = "Git: Reset hunk" })
vim.api.nvim_create_user_command("LogFile", "lua Snacks.lazygit.log_file()", { nargs = 0, desc = "Lazygit: Log file" })

-- Remove default LSP keymaps if present
pcall(vim.keymap.del, "n", "gri")
pcall(vim.keymap.del, "n", "grr")
pcall(vim.keymap.del, "x", "gra")
pcall(vim.keymap.del, "n", "gra")
pcall(vim.keymap.del, "n", "grn")
pcall(vim.keymap.del, "n", "grc")
pcall(vim.keymap.del, "n", "grt")

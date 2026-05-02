local H = require("core.helper_functions")

-- Leader key
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>w", "<C-W>", { remap = true, desc = "Window prefix remap" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank: to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+y$]], { desc = "Yank: to system clipboard to EOL" })

vim.keymap.set("n", "<F1>", "<CMD>cprev<CR>", { silent = true, desc = "Quickfix: prev" })
vim.keymap.set("n", "<F2>", "<CMD>cnext<CR>", { silent = true, desc = "Quickfix: next" })

vim.keymap.set("i", "<F1>", "<Esc>g<C-G>", { silent = true, desc = "Prefer that over vim's help" })
vim.keymap.set("n", "<Esc>", "<CMD>nohlsearch<CR>", { silent = true, desc = "Hide highlight" })
vim.keymap.set("n", "<leader>=", "gg=G``", { desc = "Reindent whole file" })

-- Copy paths
vim.keymap.set("n", "<leader>pr", H.copy_relative_path, { desc = "Copy: relative path" })
vim.keymap.set("n", "<leader>pa", H.copy_absolute_path, { desc = "Copy: absolute path" })
vim.keymap.set("n", "<leader>pf", H.copy_filename, { desc = "Copy: filename" })
vim.keymap.set("n", "<leader>pd", H.copy_directory, { desc = "Copy: directory path" })

-- Lsp
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Goto Definition", })
vim.keymap.set("n", "<leader>td", H.toggle_diagnostics, { desc = "LSP: Toggle diagnostics" })
vim.api.nvim_create_user_command("Fmt", function() vim.lsp.buf.format() end, { nargs = 0, desc = "LSP: Format buffer" })

-- Perfect command that does everything
vim.keymap.set("n", "<leader>x", ":ene|setl bt=nofile bh=wipe|0r !", { desc = "Scratch buffer + shell output" })

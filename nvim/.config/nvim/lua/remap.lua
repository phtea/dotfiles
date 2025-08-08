-- Set leader key and make it wait for 5 seconds
vim.g.mapleader = " "

-- Windows
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Quickfix list navigation
vim.keymap.set("n", "<A-j>", ":cnext<CR>")
vim.keymap.set("n", "<A-k>", ":cprev<CR>")

-- Subsitute current word in this file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>S", [[:Grep -w <C-R><C-W><CR><C-w>k:cdo s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]])

-- Grep
vim.api.nvim_create_user_command("Grep", "silent grep! <args> | redraw! | cwindow", { nargs = "+", complete = "file" })
vim.api.nvim_create_user_command("Ggrep", "silent grep! <args> `git ls-files` | redraw! | cwindow", { nargs = "+" })

-- Copy/paste with system buffer
vim.keymap.set("n", "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("v", "<leader>", [["+y]])

-- Hide highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true, })

-- Misc
vim.keymap.set("n", "Q", "<nop>")

-- Lsp
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>ld", function()
  local current_state = not vim.diagnostic.is_enabled()
  vim.diagnostic.enable(current_state)
  print("Diagnostics " .. (current_state and "enabled" or "disabled"))
end)
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename)
vim.api.nvim_create_user_command("Fmt", function() vim.lsp.buf.format() end, { nargs = 0 })

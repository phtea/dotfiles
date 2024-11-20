-- keymaps.lua

local opts = { noremap = true, silent = true }

-- Clear search highlights
vim.api.nvim_set_keymap("n", "<Esc>", ":nohlsearch<CR>", opts)

-- Better window navigation
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", opts)
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", opts)
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", opts)
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", opts)

-- Map for ` (exact position of marks)
vim.keymap.set('n', "`", function()
  return "`" .. vim.fn.getcharstr() .. "zz"
end, { expr = true, desc = "Go to mark and center" })

-- Map for ' (line of marks)
vim.keymap.set('n', "'", function()
  return "'" .. vim.fn.getcharstr() .. "zz"
end, { expr = true, desc = "Go to line of mark and center" })

-- Center the screen when <C-d> and <C-u>
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", opts)
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", opts)

-- Map <C-c> to copy the selected text to the clipboard in visual mode
vim.api.nvim_set_keymap("v", "<C-c>", '"+y', opts)

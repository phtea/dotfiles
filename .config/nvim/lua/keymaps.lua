local opts = { noremap = true, silent = true }

-- Clear search highlights
vim.api.nvim_set_keymap("n", "<Space>", ":nohlsearch<CR>", opts)

-- Navigate buffers
vim.api.nvim_set_keymap("n", "<C-n>", ":bnext<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-p>", ":bprev<CR>", opts)

-- Better window navigation
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", opts)
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", opts)
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", opts)
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", opts)

-- Map <C-c> to copy the selected text to the clipboard in visual mode
vim.api.nvim_set_keymap("v", "<C-c>", '"+y', { noremap = true, silent = true })

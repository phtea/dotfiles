vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = "Clear search highlights" })
vim.keymap.set('n', '<A-q>', '<cmd>only<CR>', { desc = 'Close all other windows besides this one' })
vim.keymap.set('n', '<C-q>', '<cmd>only<CR>', { desc = 'Close all other windows besides this one' })
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = 'Delete selection and put new text' })
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = 'Yank to system clipboard' } )
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<leader>dd', "<cmd>w<CR><cmd>!go run main.go<CR>", { desc = 'Go run main.go' })
vim.keymap.set('n', '<leader>ger', "oif err != nil {<CR>}<Esc>O<Esc>")

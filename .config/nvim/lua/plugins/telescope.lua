-- plugins/telescope.lua

local opts = { noremap = true, silent = true }

-- Map <leader>ff to open Telescope's find_files function
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files({ cwd = vim.fn.expand('%:p:h') })<CR>", opts)

-- Map <leader>pf to open Telescope's find_files function in the current working directory
vim.api.nvim_set_keymap('n', '<leader>pf', "<cmd>lua require('telescope.builtin').find_files({ cwd = vim.fn.getcwd() })<CR>", opts)

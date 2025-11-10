-- gd => :g//d -> [D]elete all matching lines
vim.keymap.set("n", "D", ":g//d<CR>", { buffer = true, silent = true })

-- gd => :g!//d -> [K]eep all matching lines
vim.keymap.set("n", "K", ":g!//d<cr>", { buffer = true, silent = true })

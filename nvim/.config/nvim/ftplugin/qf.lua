-- D => :g//d -> [D]elete all matching lines
vim.keymap.set("n", "D", ":g//d<CR>", { buffer = true, silent = true })

-- K => :g!//d -> [K]eep all matching lines
vim.keymap.set("n", "K", ":g!//d<cr>", { buffer = true, silent = true })

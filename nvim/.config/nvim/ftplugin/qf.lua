-- gd => :g//d
vim.keymap.set("n", "gd", ":g//d<CR>", { buffer = true, silent = true })

-- gD => :g!//d  (delete non-matching lines, keep only matches)
vim.keymap.set("n", "gD", ":g!//d<CR>", { buffer = true, silent = true })

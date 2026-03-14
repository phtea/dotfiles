vim.keymap.set("v", "f", ":norm mf<CR>", { buffer = true, silent = true, nowait = true })
vim.keymap.set("n", "m/", ":g//norm mf<CR>", { buffer = true, silent = true })

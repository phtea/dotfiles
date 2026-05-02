-- Manually highlight stuff by pattern or selection
vim.pack.add({ "https://github.com/azabiong/vim-highlighter" })

vim.keymap.set("n", "n", "<CMD>call HiSearch('n')<CR>", { desc = "Vim-highlighter: Next", })
vim.keymap.set("n", "N", "<CMD>call HiSearch('N')<CR>", { desc = "Vim-highlighter: Previous", })

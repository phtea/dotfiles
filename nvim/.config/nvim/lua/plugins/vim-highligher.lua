-- Manually highlight stuff by pattern or selection
vim.pack.add({ "https://github.com/azabiong/vim-highlighter" })

vim.keymap.set("n", "<M-n>", function() vim.cmd("Hi>") end, { desc = "Vim-highlighter: Next", })
vim.keymap.set("n", "<M-N>", function() vim.cmd("Hi<") end, { desc = "Vim-highlighter: Previous", })

vim.pack.add({"https://github.com/azabiong/vim-highlighter"})

vim.keymap.set("n", "<M-n>", function() vim.cmd("Hi>") end, { desc = "Vim-highlighter: Next", })
vim.keymap.set("n", "<M-p>", function() vim.cmd("Hi<") end, { desc = "Vim-highlighter: Previous", })

-- :Hi clear or f<C-l> to clear highlights

-- :Dispatch - magically easy running code with populating quickfix list 🎉
vim.pack.add({
	"https://github.com/tpope/vim-dispatch"
})

-- E[x]ecute (d is taken by diagnostics)
vim.keymap.set("n", "<leader>x", ":Dispatch ", { desc = "Command for compiling and quickfix-ing" })

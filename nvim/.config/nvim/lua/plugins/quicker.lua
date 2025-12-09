vim.pack.add({ "https://github.com/stevearc/quicker.nvim" })

require("quicker").setup({
	keys = {
		{
			"<leader>k",
			":g!//d<CR>",
			desc = "Keep all matching lines",
		},
		{
			"<leader>d",
			":g//d<CR>",
			desc = "Delete all matching lines",
		},
	}
})

vim.keymap.set("n", "Q", function() require("quicker").toggle() end, { desc = "Toggle quickfix", })

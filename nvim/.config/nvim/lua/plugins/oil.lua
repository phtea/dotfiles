vim.pack.add({ "https://github.com/stevearc/oil.nvim" })
require("oil").setup({
	view_options = {
		show_hidden = true,
	},
	skip_confirm_for_simple_edits = true,
	use_default_keymaps = false,
	keymaps = {
		["<CR>"] = "actions.select",
		["-"] = { "actions.parent", mode = "n" },
	},
})

vim.keymap.set('n', '-', "<CMD>Oil<CR>", { desc = "Oil: Open parent directory" })

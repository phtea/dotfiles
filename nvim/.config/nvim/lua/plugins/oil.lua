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
	buf_options = {
		bufhidden = "", -- don't hide this buffer
		buflisted = false, -- and yet don't list it (I want to see Oil in the jumplist but not in buflist)
	},
	columns = {
		-- explicitly don't use it
		-- "icon",
		-- "permissions",
		-- "size",
		-- "mtime",
	},
})

vim.keymap.set('n', '-', "<CMD>Oil<CR>", { desc = "Oil: Open parent directory" })

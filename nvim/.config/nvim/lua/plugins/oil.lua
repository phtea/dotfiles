return {
	"stevearc/oil.nvim",
	keys = {
		{ "-", "<cmd>Oil<cr>", desc = "Oil: Open parent directory" },
	},
	opts = {
		view_options = { show_hidden = true, },
		skip_confirm_for_simple_edits = true,
	},
}

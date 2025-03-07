return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional for file icons
	keys = {
        { "<leader>e", function() require("oil").toggle_float() end, desc = "Toggle Oil floating window" },
    },
	opts = {
		default_file_explorer = true,
		view_options = { show_hidden = true, }, -- Show hidden files
		float = {
			padding = 2, -- Add padding around floating window
			max_width = 100, -- Max width of the floating window
			max_height = 20, -- Max height of the floating window
		},
		win_options = {
			-- huge W this one
			winhighlight = "NormalFloat:TelescopeNormal,FloatBorder:TelescopePreviewBorder"
		},
	},
}

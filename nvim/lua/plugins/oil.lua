return {
	"stevearc/oil.nvim",
	lazy=false,
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional for file icons
	keys = {
        { "<leader>e", "<CMD>Oil<CR>", desc = "Open parent directory" },
        { "<CR>", "actions.select", desc = "Open file or enter directory" },
        { "<C-p>", "actions.preview", desc = "Preview file" },
        { "q", "actions.close", desc = "Close Oil" },
    },
	opts = {
		-- Oil-specific options
		default_file_explorer = true,
		view_options = {
			show_hidden = true, -- Show hidden files
		},
		float = {
			padding = 2, -- Add padding around floating window
			max_width = 100, -- Max width of the floating window
			max_height = 20, -- Max height of the floating window
		},
	},
}
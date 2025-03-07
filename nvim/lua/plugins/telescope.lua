return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" }, -- Required dependency for Telescope
	cmd = "Telescope", -- Load Telescope on demand
	keys = {
		{ "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Show LSP diagnostics" },
		{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Search help documentation" },
		{ "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Search in project (grep)" },
		{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files in current directory" },
		{ "<leader><leader>", "<cmd>Telescope find_files<CR>", desc = "Find files in current directory" },
		{ "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Search Keymaps" },
		{ "<leader>fn", "<cmd>Telescope find_files search_dirs={'~/.config/nvim'}<CR>", desc = "Find Neovim config files" },
		{ "<leader>fc", "<cmd>Telescope colorscheme<CR>", desc = "Find colorschemes" },
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				sorting_strategy = "ascending",
				mappings = {
					i = {
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					theme = "ivy",
				},
			},
		})
	end,
}

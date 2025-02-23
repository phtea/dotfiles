return {
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		enabled = false,
		priority = 1000,
		config = function()
			require('nightfox').setup({
				options = {
					styles = {
						comments = "italic",
						keywords = "bold",
						types = "italic,bold",
					}
				}
			})
			vim.cmd.colorscheme("nightfox")
			-- Set the statusline highlight to match the normal background
			local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
			vim.api.nvim_set_hl(0, "StatusLine", { bg = normal_hl.background, fg = normal_hl.foreground })

			-- Set the mode indicators (like -- INSERT --) to match the primary foreground color
			local primary_fg = normal_hl.foreground
			vim.api.nvim_set_hl(0, "ModeMsg", { fg = primary_fg })  -- Use the same foreground as the Normal text
		end,
	},
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		enabled = true,
		priority = 1000,
		config = function()
			vim.o.background = 'dark'
			require('vscode').setup({
				-- Override colors (see ./lua/vscode/colors.lua)
				color_overrides = {
					vscBack = '#000000',
					vscTabCurrent = '#000000',
					vscTabOutside = '#000000',
					vscLeftDark = '#000000',
					vscPopupBack = '#000000',
				},
			})
			vim.cmd.colorscheme("vscode")
			local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
			vim.api.nvim_set_hl(0, "StatusLine", { bg = normal_hl.background, fg = normal_hl.foreground })
		end,
	},
	{
		"dgox16/oldworld.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"sam4llis/nvim-tundra",
		lazy = false,
		enabled = false,
		priority = 1000,
		config = function()
			vim.g.tundra_biome = "jungle" -- 'arctic' or 'jungle'
			vim.opt.background = "dark"
			vim.cmd.colorscheme("tundra")
		end,
	},
	{
		"mellow-theme/mellow.nvim",
		enabled = false,
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("mellow")
		end,
	},
}

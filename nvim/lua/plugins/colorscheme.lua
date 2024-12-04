return {
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- Set the colorscheme
			vim.cmd.colorscheme("nightfox")
			-- Set the statusline highlight to match the normal background
			local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
			vim.api.nvim_set_hl(0, "StatusLine", { bg = normal_hl.background, fg = normal_hl.foreground })

			-- Set the mode indicators (like -- INSERT --) to match the primary foreground color
			local primary_fg = normal_hl.foreground
			vim.api.nvim_set_hl(0, "ModeMsg", { fg = primary_fg })  -- Use the same foreground as the Normal text
		end,
	},
}

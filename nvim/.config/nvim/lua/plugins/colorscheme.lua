return {
	{
		"Mofiqul/vscode.nvim",
		enabled = false,
		config = function()
			vim.cmd [[colorscheme vscode]]
			vim.cmd [[set cursorline]]
		end,
	},
	{
		"webhooked/kanso.nvim",
		enabled = false,
		config = function()
			require('kanso').setup({
				italics = false,
			})
			vim.cmd [[colorscheme kanso-zen]]
		end
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require('rose-pine').setup({
				styles = {
					italic = false,
				},
				highlight_groups = {
					NormalFloat = { link = "Normal" },
					FloatBorder = { fg = "muted", bg = "none" },
					FloatTitle = { bg = "base" },
					StatusLine = { bg = "base" },
					DiagnosticVirtualTextInfo = { bg = "none" },
				},
			})
			vim.cmd [[colorscheme rose-pine]]
		end
	}
}

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
					StatusLine = { bg = "#1f1d2e" },
					StatusLineNC = { bg = "#1f1d2e" },
					DiagnosticVirtualTextInfo = { bg = "none" },
					Pmenu = { bg = "none", },
					GitSignsAdd = { fg = "#88D8AA" },
					GitSignsChange = { fg = "#F6C177" },
					GitSignsDelete = { fg = "#F02961" }
				},
			})
			vim.cmd [[colorscheme rose-pine]]
		end
	}
}

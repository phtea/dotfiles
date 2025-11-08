return {
	"rose-pine/neovim",
	name = "rose-pine",
	config = function()
		require('rose-pine').setup({
			styles = {
				bold = false,
				italic = false,
			},
			highlight_groups = {
				NormalFloat = { link = "Normal" },
				FloatBorder = { fg = "muted", bg = "none" },
				FloatTitle = { bg = "base" },
				StatusLine = { bg = "#1F1D2E" },
				StatusLineNC = { bg = "#1F1D2E" },
				DiagnosticVirtualTextInfo = { bg = "none" },
				Pmenu = { bg = "none", },
				DiffAdd = { fg = "#88D8AA" },
				GitSignsAdd = { fg = "#88D8AA" },
				GitSignsChange = { fg = "#F6C177" },
				GitSignsDelete = { fg = "#F02961" },
				WordSelected =  { bg = '#3c394e' },
			},
		})
		vim.cmd.colorscheme('rose-pine')
	end
}

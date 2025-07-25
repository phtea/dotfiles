require('kanagawa').setup({
	compile = false,
	undercurl = true,
	commentStyle = { italic = false },
	functionStyle = {},
	keywordStyle = { italic = false },
	statementStyle = { bold = true },
	typeStyle = {},
	transparent = false,
	dimInactive = false,
	terminalColors = true,
	colors = {
		palette = {},
		theme = { wave = {}, lotus = {}, dragon = {}, all = { ui = { bg_gutter = "none" } } },
	},
	overrides = function(colors)
		local theme = colors.theme
		local makeDiagnosticColor = function(color)
			local c = require("kanagawa.lib.color")
			return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
		end
		return {
			TelescopeTitle             = { fg = theme.ui.special, bold = true },
			TelescopePromptNormal      = { bg = theme.ui.bg_p1 },
			TelescopePromptBorder      = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
			TelescopeResultsNormal     = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
			TelescopeResultsBorder     = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
			TelescopePreviewNormal     = { bg = theme.ui.bg_dim },
			TelescopePreviewBorder     = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

			NormalFloat                = { bg = "none" },
			FloatBorder                = { bg = "none" },
			FloatTitle                 = { bg = "none" },
			NormalDark                 = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
			LazyNormal                 = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
			MasonNormal                = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

			DiagnosticVirtualTextHint  = makeDiagnosticColor(theme.diag.hint),
			DiagnosticVirtualTextInfo  = makeDiagnosticColor(theme.diag.info),
			DiagnosticVirtualTextWarn  = makeDiagnosticColor(theme.diag.warning),
			DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
		}
	end,
	theme = "wave",
	background = {
		dark = "wave",
		light = "lotus"
	},
})

vim.cmd("colorscheme kanagawa")
vim.o.winborder = 'none'

vim.pack.add({{
	src = 'https://github.com/saghen/blink.cmp',
	version = vim.version.range('^1')
}})

-- My personal setup

require("blink.cmp").setup({
	keymap = {
		preset = 'super-tab'
	},
	appearance = {
		nerd_font_variant = 'mono',
	},
	signature = {
		enabled = true,
		window = { border = 'single' },
	},
	completion = {
		menu = { border = 'none' },
		documentation = { window = { border = 'single' } },
	},
	cmdline = {
		keymap = { preset = 'inherit' },
		completion = {
			menu = {
				auto_show = function(ctx)
					-- if ':command' has more than n symbols (with :) => auto show completions 
					return vim.fn.getcmdtype() == ':' and #ctx.line >= 3
				end,
			}
		},
	},
})

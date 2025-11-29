vim.pack.add({{
	src = 'https://github.com/saghen/blink.cmp',
	version = vim.version.range('^1')
}})

require("blink.cmp").setup({
	keymap = {
		preset = 'super-tab'
	},
	appearance = {
		nerd_font_variant = 'mono',
	},
	signature = {
		enabled = true
	},
	cmdline = {
		keymap = { preset = 'inherit' },
		completion = {
			menu = {
				auto_show = function()
					return vim.fn.getcmdtype() == ':'
				end,
			}
		},
	},
})

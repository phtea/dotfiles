vim.pack.add({{src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.0')}})
require("blink.cmp").setup({
	keymap = { preset = 'default' },
	appearance = { nerd_font_variant = 'mono', },
	signature = { enabled = true },
	cmdline = {
		enabled = true,
	},
})

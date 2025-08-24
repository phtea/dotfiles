return {
	'saghen/blink.cmp',
	version = '1.*',
	opts = {
		keymap = { preset = 'default' },
		appearance = { nerd_font_variant = 'mono', },
		signature = { enabled = true },
		cmdline = {
			enabled = true,
			keymap = {
				['<Tab>'] = { 'accept' },
			},
			completion = {
				menu = {
					auto_show = true,
				},
			},
		},
	},
}

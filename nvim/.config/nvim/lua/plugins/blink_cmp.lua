if vim.g.use_native_complete then return {} end

vim.pack.add({ {
	src = 'https://github.com/saghen/blink.cmp',
	version = vim.version.range('^1')
} })

require("blink.cmp").setup({
	keymap = {
		preset = 'default',

		['<Tab>'] = {
			function(cmp)
				if cmp.snippet_active() then
					return cmp.accept()
				else
					return cmp.select_and_accept()
				end
			end,
			'snippet_forward',
			'fallback'
		},
		['<S-Tab>'] = { 'snippet_backward', 'fallback' },
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
	cmdline = { enabled = false },
})

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
	cmdline = {
		enabled = false,
		keymap = { preset = 'inherit' },
		completion = {
			menu = {
				auto_show = function(ctx)
					-- if ':command' has more than n symbols (with :) => auto show completions
					return vim.fn.getcmdtype() == ':' -- and #ctx.line >= 3
				end,
			}
		},
	},
})

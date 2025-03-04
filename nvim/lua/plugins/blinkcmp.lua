return {
	{
		'saghen/blink.cmp',
		dependencies = 'rafamadriz/friendly-snippets',
		version = 'v0.*',
		opts = {
			keymap = {
				['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
				['<Tab>'] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.accept()
						else
							return cmp.select_and_accept()
						end
					end,
					'snippet_forward',
					'fallback',
				},
				['<S-Tab>'] = { 'snippet_backward', 'fallback' },

				['<C-j>'] = { 'select_next', 'fallback' },
				['<C-k>'] = { 'select_prev', 'fallback' },

				['<C-d>'] = { 'scroll_documentation_up', 'fallback' },
				['<C-u>'] = { 'scroll_documentation_down', 'fallback' },

			},

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = 'mono'
			},

			signature = { enabled = true },
			cmdline = { enabled = false, }, -- disable in command mode!!
			completion = {
				-- show documentation automatically
				documentation = { auto_show = true, auto_show_delay_ms = 500 }, 
			}
		},
	},
}

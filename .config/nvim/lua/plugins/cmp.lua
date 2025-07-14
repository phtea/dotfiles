return {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = '*',
    opts = {
	keymap = {
	    preset = 'none',
	    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },

	    ['<Tab>'] = { 'select_and_accept', 'fallback' },

	    ['<C-n>'] = { 'snippet_forward', 'fallback_to_mappings' },
	    ['<C-p>'] = { 'snippet_backward', 'fallback_to_mappings' },

	    ['<C-j>'] = { 'select_next', 'fallback' },
	    ['<C-k>'] = { 'select_prev', 'fallback' },

	    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
	    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
	},
	signature = {
	    enabled = true,
	    window = { show_documentation = true, },
	},

	cmdline = { enabled = false, }, -- disable in command mode!!

	completion = {
	    documentation = { auto_show = true, auto_show_delay_ms = 100, },
	}
    },
}

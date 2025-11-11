vim.pack.add({"https://github.com/tzachar/local-highlight.nvim"})
require('local-highlight').setup({
	debounce_timeout = 0,
	animate = {
		enabled = false,
	},
})

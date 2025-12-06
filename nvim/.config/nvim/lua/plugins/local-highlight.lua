vim.pack.add({ "https://github.com/tzachar/local-highlight.nvim" })
require('local-highlight').setup({
	debounce_timeout = 200,
	animate = {
		enabled = false,
	},
})

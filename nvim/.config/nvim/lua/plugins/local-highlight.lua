vim.pack.add({ "https://github.com/tzachar/local-highlight.nvim" })

require('local-highlight').setup({
	debounce_timeout = 200,
	animate = {
		enabled = false,
	},
	file_types = { 'xxx' }, -- don't attach to any by dafault
})

vim.keymap.set("n", "<leader>th", function()
	vim.cmd("LocalHighlightToggle")
end, { desc = "LocalHighlight: Toggle highlights" })

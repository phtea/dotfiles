-- Visually show currently selected lines
vim.pack.add({ "https://github.com/wurli/visimatch.nvim" })

require("visimatch").setup({
	chars_lower_limit = 2, -- trigger when N chars selected minimum
	-- hl_group = "Visimatch", -- by default it's LspReferenceTarget (links to LspReferenceText)
	buffers = "current",
})

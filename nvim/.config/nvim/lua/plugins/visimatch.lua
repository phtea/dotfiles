-- Visually show selected lines
vim.pack.add({
	"https://github.com/wurli/visimatch.nvim",
})

require("visimatch").setup({
	chars_lower_limit = 3, -- trigger when 3 chars selected minimum
	-- hl_group = "Visimatch",
	buffers = "current",
})

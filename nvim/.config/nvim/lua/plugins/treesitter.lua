vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

require('nvim-treesitter').install {
	"lua", "python", "bash", "vim", "javascript", "typescript", "json", "yaml", "markdown", "ruby"
}

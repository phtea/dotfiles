vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
})

vim.lsp.enable("pyright")
vim.lsp.enable("solargraph")
vim.lsp.enable("clangd")
vim.lsp.enable("lua_ls")
vim.lsp.enable("gopls")
vim.lsp.enable("rust_analyzer")

vim.diagnostic.config({
	float = {
		border = "single",
	}
})

require('mason').setup()

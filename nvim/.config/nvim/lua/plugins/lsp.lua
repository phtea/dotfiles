return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.lsp.enable("pyright")
			vim.lsp.enable("solargraph")
			vim.lsp.enable("clangd")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("gopls")
			vim.lsp.enable("rust_analyzer")
		end,
	},
	{
		'dgagn/diagflow.nvim',
		-- event = 'LspAttach', This is what recommended for Lazy plugin manager
		opts = {}
	},
	{
		"mason-org/mason.nvim",
		opts = {}
	}
}

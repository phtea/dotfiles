return {
  "neovim/nvim-lspconfig",
  config = function()
	local lspconfig = require('lspconfig')
	lspconfig.pyright.setup {}
	lspconfig.solargraph.setup {} -- or ruby_lsp
	lspconfig.clangd.setup {}
	lspconfig.lua_ls.setup {}
	lspconfig.gopls.setup {}

	vim.api.nvim_create_autocmd('LspAttach', {
	  group = vim.api.nvim_create_augroup('my.lsp', {}),
	  callback = function()
		vim.diagnostic.config({ virtual_text = { current_line = true } })
	  end,
	})
  end,
}

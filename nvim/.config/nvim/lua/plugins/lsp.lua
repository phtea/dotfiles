return {
  {
	"neovim/nvim-lspconfig",
	config = function()
	  local lspconfig = require('lspconfig')
	  lspconfig.pyright.setup {}
	  lspconfig.solargraph.setup {} -- or ruby_lsp
	  lspconfig.clangd.setup {}
	  lspconfig.lua_ls.setup {}
	  lspconfig.gopls.setup {}
	  lspconfig.rust_analyzer.setup {}
	end,
  },
  {
	'dgagn/diagflow.nvim',
	-- event = 'LspAttach', This is what recommended for Lazy plugin manager
	opts = {}
  }
}

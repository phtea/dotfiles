return {
  "neovim/nvim-lspconfig",
  config = function()
	local lspconfig = require('lspconfig')
	lspconfig.pyright.setup {}
	lspconfig.solargraph.setup {} -- ruby_lsp
	lspconfig.clangd.setup {}
	lspconfig.lua_ls.setup { settings = { Lua = { diagnostics = { globals = { "vim" }, } } } }
	lspconfig.gopls.setup {}

	vim.api.nvim_create_autocmd('LspAttach', {
	  group = vim.api.nvim_create_augroup('my.lsp', {}),
	  callback = function()
		vim.api.nvim_create_user_command("Fmt", function() vim.lsp.buf.format() end, { nargs = 0 })
		vim.diagnostic.config({ virtual_text = { current_line = true } })
	  end,
	})
  end,
}

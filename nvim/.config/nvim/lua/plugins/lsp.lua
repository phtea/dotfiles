return {
  "neovim/nvim-lspconfig",
  config = function()
	local lspconfig = require('lspconfig')
	lspconfig.pyright.setup {}
	lspconfig.solargraph.setup {}
	-- lspconfig.ruby_lsp.setup{}
	lspconfig.clangd.setup {}
	lspconfig.lua_ls.setup {}

	vim.api.nvim_create_autocmd('LspAttach', {
	  group = vim.api.nvim_create_augroup('my.lsp', {}),
	  callback = function(args)
		vim.api.nvim_create_user_command("Fmt", function() vim.lsp.buf.format() end, { nargs = 0 })
		vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Give code actions" })
		vim.diagnostic.enable(false)
		vim.diagnostic.config({ virtual_text = { current_line = true } })

		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
		  vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
		  local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
		  client.server_capabilities.completionProvider.triggerCharacters = chars
		  vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	  end,
	})
  end,
}

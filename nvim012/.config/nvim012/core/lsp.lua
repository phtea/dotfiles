vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)

		vim.api.nvim_create_user_command("Fmt", function() vim.lsp.buf.format() end, { nargs = 0 })
		vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Give code actions" })
		vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Give code actions" })

		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

vim.lsp.config('*', {
	capabilities = { textDocument = { semanticTokens = { multilineTokenSupport = true, } } },
	root_markers = { '.git' },
})

vim.diagnostic.config({ virtual_text = { current_line = true } })
vim.lsp.enable({ 'clangd', 'lua_ls', 'solargraph', })

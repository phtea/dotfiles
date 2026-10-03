vim.lsp.enable({
	"pyright", "solargraph", "clangd",
	"lua_ls", "gopls", "rust_analyzer",
	"arduino_language_server", "zls",
})

vim.diagnostic.config({ virtual_text = true, })

-- Completion
vim.opt.completeopt = { "menuone", "noinsert", "popup", "fuzzy" }

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then return end

		local chars = {}
		for i = 32, 126 do chars[#chars + 1] = string.char(i) end
		client.server_capabilities.completionProvider.triggerCharacters = chars
		vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true, })
	end,
})

vim.keymap.set({ "i", "s" }, "<Tab>", function()
	if vim.fn.pumvisible() == 1 then return "<C-y>" end
	if vim.snippet.active({ direction = 1 }) then return "<Cmd>lua vim.snippet.jump(1)<CR>" end
	return "<Tab>"
end, { expr = true, silent = true, desc = "Complete / snippet next / tab", })

vim.keymap.set("i", "<CR>", function()
	if vim.fn.pumvisible() == 1 then return vim.keycode("<C-e><CR>") end
	return vim.keycode("<CR>")
end, { expr = true, silent = true, desc = "Enter without accepting completion", })

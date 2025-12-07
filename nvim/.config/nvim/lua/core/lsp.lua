-- Native fuzzy popup filtering
vim.o.completeopt = "menuone,noinsert,fuzzy,popup"

-- Enable native LSP completion + autotrigger when an LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
		client.server_capabilities.completionProvider.triggerCharacters = chars
		vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })

		-- vim.keymap.set("i", "<Tab>",
		-- 	function() return vim.fn.pumvisible() == 1 and "<C-y>" or "<Tab>" end,
		-- 	{ expr = true, noremap = true })
		-- vim.keymap.set("i", "<CR>",
		-- 	function() return vim.fn.pumvisible() == 1 and "<C-e><CR>" or "<CR>" end,
		-- 	{ expr = true, noremap = true }) -- Enter should always be enter
	end,
})

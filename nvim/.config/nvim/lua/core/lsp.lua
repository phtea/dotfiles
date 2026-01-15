-- Autoformat with LSP, toggle with <leader>tf (default: OFF)

vim.g.autoformat_enabled = false

-- Toggle autoformat
vim.keymap.set("n", "<leader>tf", function()
	vim.g.autoformat_enabled = not vim.g.autoformat_enabled
	if vim.g.autoformat_enabled then
		vim.notify("Autoformat: ON")
	else
		vim.notify("Autoformat: OFF")
	end
end, { desc = "Toggle format-on-save (LSP)" })

-- format-on-save when enabled
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		if vim.g.autoformat_enabled then
			vim.cmd("Fmt")
		end
	end,
})

vim.g.autocmp_disable_servers = {
	solargraph = true,
	lua_ls = true,
}

vim.o.completeopt = "menuone,noinsert,fuzzy,popup"
vim.o.pumheight = 10 -- show only first 10 entries (less intrusive)

vim.keymap.set('i', '<c-space>', function() vim.lsp.completion.get() end)
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		-- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
		if client:supports_method('textDocument/completion') then
			if not vim.g.autocmp_disable_servers[client.name] then -- Only enable for not disabled servers
				local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
				client.server_capabilities.completionProvider.triggerCharacters = chars
			end

			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

-- Show signature help automatically
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client or not client:supports_method("textDocument/signatureHelp") then return end

		vim.api.nvim_create_autocmd("InsertCharPre", {
			buffer = ev.buf,
			callback = function()
				if vim.fn.pumvisible() == 1 then return end
				local ch = vim.v.char
				if ch == "(" or ch == "," then
					vim.schedule(vim.lsp.buf.signature_help)
				end
			end,
		})
	end,
})

-- -----------------------------
-- Super-Tab
-- Helper: feed keys like mappings (handles <C-y>, <Tab>, etc.)
local function feed(keys)
	vim.api.nvim_feedkeys(vim.keycode(keys), "n", false)
end

-- Helper: accept completion. If no item selected, select first then accept.
local function accept_completion_first()
	if vim.fn.pumvisible() ~= 1 then return false end

	local ci = vim.fn.complete_info({ "selected" })
	if ci.selected == -1 then
		-- select first item
		feed("<C-n>")
	end
	-- accept selection
	feed("<C-y>")
	return true
end

vim.keymap.set("i", "<Tab>", function()
	-- 1) completion
	if accept_completion_first() then return end

	-- 2) snippet jump (native)
	-- Works on newer NVIM where vim.snippet.active accepts a direction filter. :contentReference[oaicite:1]{index=1}
	if vim.snippet and vim.snippet.active({ direction = 1 }) then
		vim.snippet.jump(1)
		return
	end

	-- 3) literal tab
	feed("<Tab>")
end, { desc = "Supertab: complete / snippet jump / tab" })

vim.keymap.set("i", "<S-Tab>", function()
	-- reverse snippet jump when active, else backtab
	if vim.snippet and vim.snippet.active({ direction = -1 }) then
		vim.snippet.jump(-1)
		return
	end
	feed("<S-Tab>")
end, { desc = "Snippet jump back / backtab" })

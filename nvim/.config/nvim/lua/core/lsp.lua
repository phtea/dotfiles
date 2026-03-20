-- Autoformat with LSP, togglable (default: OFF)
vim.g.autoformat_enabled = false

vim.o.completeopt = "menuone,noinsert,fuzzy,popup"
vim.o.pumheight = 10 -- show only first 10 entries (less intrusive)

vim.keymap.set('i', '<c-space>', function() vim.lsp.completion.get() end, { desc = 'Show autocomplete (LSP)' })
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		-- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end

		-- Auto-format ("lint") on save.
		if not client:supports_method('textDocument/willSaveWaitUntil') and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
				buffer = args.buf,
				callback = function()
					if not vim.g.autoformat_enabled then return end

					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})

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

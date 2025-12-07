-- Native fuzzy popup filtering
vim.o.completeopt = "menuone,noinsert,fuzzy,popup"

-- Enable native LSP completion + autotrigger when an LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		if not client:supports_method('textDocument/completion') then return end

		local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
		client.server_capabilities.completionProvider.triggerCharacters = chars
		vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {
			autotrigger = true,
		})
	end,
})

-- -----------------------------
-- Autoformat: native LSP, toggle with <leader>tf (default OFF)
-- -----------------------------
vim.g.autoformat_enabled = false

local function format_buf(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	-- only if some attached client supports formatting
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	for _, c in ipairs(clients) do
		if c.supports_method("textDocument/formatting") or c.supports_method("textDocument/rangeFormatting") then
			vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
			return
		end
	end
end

-- format-on-save when enabled
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		if vim.g.autoformat_enabled then
			format_buf(args.buf)
		end
	end,
})

-- Toggle autoformat
vim.keymap.set("n", "<leader>tf", function()
	vim.g.autoformat_enabled = not vim.g.autoformat_enabled
	if vim.g.autoformat_enabled then
		vim.notify("Autoformat: ON")
	else
		vim.notify("Autoformat: OFF")
	end
end, { desc = "Toggle format-on-save (LSP)" })

-- -----------------------------
-- Super-Tab
-- -----------------------------
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

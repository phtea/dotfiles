-- -----------------------------
-- Autoformat: native LSP, toggle with <leader>tf (default OFF)

vim.g.autoformat_enabled = false

local function format_buf(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	-- only if some attached client supports formatting
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	for _, c in ipairs(clients) do
		if c.supports_method('textDocument/formatting', bufnr) or c.supports_method('textDocument/rangeFormatting', bufnr) then
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

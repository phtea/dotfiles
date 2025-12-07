-- Native fuzzy popup filtering
vim.o.completeopt = "menuone,noinsert,fuzzy,popup"

-- Enable native LSP completion + autotrigger when an LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		if not client:supports_method('textDocument/completion') then return end
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

-- -----------------------------
-- autoformat: native LSP, toggle with <leader>tf (default OFF)
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

-- toggle
vim.keymap.set("n", "<leader>tf", function()
  vim.g.autoformat_enabled = not vim.g.autoformat_enabled
  if vim.g.autoformat_enabled then
    vim.notify("Autoformat: ON")
  else
    vim.notify("Autoformat: OFF")
  end
end, { desc = "Toggle format-on-save (LSP)" })

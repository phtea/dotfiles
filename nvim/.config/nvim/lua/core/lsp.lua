-- Native fuzzy popup filtering
vim.o.completeopt = "menuone,noinsert,fuzzy,popup"
vim.o.pumheight = 10 -- show only first 10 entries (less intrusive)

-- LSP CompletionItemKind (1..25) -> icon
local icon = {
  [1]  = "󰉿", -- Text
  [2]  = "󰆧", -- Method
  [3]  = "󰊕", -- Function
  [4]  = "",  -- Constructor
  [5]  = "󰜢", -- Field
  [6]  = "󰀫", -- Variable
  [7]  = "󰠱", -- Class
  [8]  = "",  -- Interface
  [9]  = "󰏗", -- Module
  [10] = "󰜢", -- Property
  [11] = "󰑭", -- Unit
  [12] = "󰎠", -- Value
  [13] = "",  -- Enum
  [14] = "󰌋", -- Keyword
  [15] = "",  -- Snippet
  [16] = "󰏘", -- Color
  [17] = "󰈙", -- File
  [18] = "󰈇", -- Reference
  [19] = "󰉋", -- Folder
  [20] = "",  -- EnumMember
  [21] = "󰏿", -- Constant
  [22] = "󰙅", -- Struct
  [23] = "",  -- Event
  [24] = "󰆕", -- Operator
  [25] = "󰊄", -- TypeParameter
}

local kind_hl = {
  [1]  = "PmenuKindText",
  [2]  = "PmenuKindMethod",
  [3]  = "PmenuKindFunction",
  [4]  = "PmenuKindConstructor",
  [5]  = "PmenuKindField",
  [6]  = "PmenuKindVariable",
  [7]  = "PmenuKindClass",
  [8]  = "PmenuKindInterface",
  [9]  = "PmenuKindModule",
  [10] = "PmenuKindProperty",
  [11] = "PmenuKindUnit",
  [12] = "PmenuKindValue",
  [13] = "PmenuKindEnum",
  [14] = "PmenuKindKeyword",
  [15] = "PmenuKindSnippet",
  [16] = "PmenuKindColor",
  [17] = "PmenuKindFile",
  [18] = "PmenuKindReference",
  [19] = "PmenuKindFolder",
  [20] = "PmenuKindEnumMember",
  [21] = "PmenuKindConstant",
  [22] = "PmenuKindStruct",
  [23] = "PmenuKindEvent",
  [24] = "PmenuKindOperator",
  [25] = "PmenuKindTypeParam",
}

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

-- Enable native LSP completion + autotrigger when an LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		if not client:supports_method('textDocument/completion') then return end

		local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
		client.server_capabilities.completionProvider.triggerCharacters = chars

		vim.lsp.completion.enable(true, client.id, _, {
			autotrigger = true,
			convert = function(item)
				local k = item.kind
				local ic = icon[k] or "·"
				return {
					-- Put icon abbr so it's on the left
					abbr = ic,
					abbr_hlgroup = kind_hl[k] or "",

					-- Menu is label and detail now
					menu = string.format("%s %s", item.label, item.detail),

					-- Kind is empty since it's part of abbr
					kind = "",
				}
			end,
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

-- Autoformat with LSP, togglable (default: OFF)
vim.g.autoformat_enabled = false

vim.o.completeopt = "menuone,noinsert,fuzzy,popup"
vim.o.complete = "o,.,w,b"
vim.o.autocomplete = false
vim.o.pumheight = 10 -- show only first 10 entries (less intrusive)

-- Less than optimal, just for show, only needed if your colorscheme
-- doesn't have completion kind hlgroups already built in
local _kind_hl = {
  Text          = "@string",
  Method        = "@function",
  Function      = "@function",
  Constructor   = "@constructor",
  Field         = "@variable.member",
  Variable      = "@variable",
  Class         = "@type",
  Interface     = "@type",
  Module        = "@module",
  Property      = "@property",
  Unit          = "@operator",
  Value         = "@constant",
  Enum          = "@type",
  Keyword       = "@keyword",
  Snippet       = "@string",
  Color         = "@string",
  File          = "@constant",
  Reference     = "@constant",
  Folder        = "@constant",
  EnumMember    = "@constant",
  Constant      = "@constant",
  Struct        = "@type",
  Event         = "@keyword",
  Operator      = "@operator",
  TypeParameter = "@variable.parameter",
}

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		-- Completion
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = false,
        convert = function(item)
          if vim.lsp.protocol.CompletionItemKind[item.kind] ~= nil then
            return { kind_hlgroup = _kind_hl[vim.lsp.protocol.CompletionItemKind[item.kind]] }
          end

          return {}
        end,
      })
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

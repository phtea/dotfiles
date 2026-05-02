local augroup = vim.api.nvim_create_augroup('phtea', { clear = true })
local function autocmd(event, opts)
	opts.group = augroup
	vim.api.nvim_create_autocmd(event, opts)
end

-- Syntax highlighting for dotenv files
autocmd('BufRead', {
	pattern = { '.env', '.env.*' },
	callback = function() vim.bo.filetype = 'dosini' end,
})

-- Syntax highlighting for yml files
autocmd('BufRead', {
	pattern = { '*.yml', '*.yml.*' },
	callback = function() vim.bo.filetype = 'yaml' end,
})

-- When package is changed (installed, updated, deleted)
autocmd('PackChanged', {
	callback = function(ev)
		local data = ev.data or vim.v.event -- depending on Neovim version

		if not data then return end

		local kind = data.kind -- 'install' | 'update' | 'delete'
		local spec = data.spec or {}
		local name = spec.name or ''

		-- Only for nvim-treesitter, and only on install or update
		if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then vim.cmd('TSUpdate') end
	end,
})

autocmd('LspAttach', {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then return end
		-- Completion
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false, })
		end
	end,
})

autocmd("TermOpen", { command = "startinsert", })

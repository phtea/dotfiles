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

-- Terminal goodies
autocmd("TermOpen", { command = "startinsert", })
autocmd("TermClose", { callback = function(e) vim.schedule(function() pcall(vim.api.nvim_buf_delete, e.buf, { force = true }) end) end, })

local augroup = vim.api.nvim_create_augroup('phtea', { clear = true })
local function autocmd(event, opts)
	opts.group = augroup
	vim.api.nvim_create_autocmd(event, opts)
end

autocmd("TermOpen", {
	callback = function()
		vim.cmd [[setlocal cmdheight=0 laststatus=0 | startinsert]]
	end
})

autocmd("TermClose", {
	callback = function(e)
		vim.schedule(function() pcall(vim.api.nvim_buf_delete, e.buf, { force = true }) end) -- free terminal resources
		vim.cmd [[setlocal cmdheight& laststatus=2]]
	end
})

autocmd("FileType", {
	pattern = "ruby",
	callback = function(args)
		vim.diagnostic.enable(false, { bufnr = args.buf })
	end,
})

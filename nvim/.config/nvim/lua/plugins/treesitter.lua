vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = 'main' } })

local languages = { "lua", "python", "bash", "vim", "javascript", "typescript", "json", "yaml", "markdown", "ruby" }

require('nvim-treesitter').install(languages)
vim.api.nvim_create_autocmd('FileType', {
	pattern = languages,
	callback = function(ev)
		vim.treesitter.start()
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

local function ts_select(method)
	return function()
		if vim.treesitter.get_parser(nil, nil, { error = false }) then
			require('vim.treesitter._select')[method](vim.v.count1)
		end
	end
end

vim.keymap.set({ 'n', 'x', 'o' }, '<M-o>', ts_select('select_parent'), { desc = 'TS: Select parent' })
vim.keymap.set({ 'n', 'x', 'o' }, '<M-i>', ts_select('select_child'),  { desc = 'TS: Select child' })

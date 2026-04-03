vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = 'main' } })

local languages = { "lua", "python", "bash", "vim", "javascript", "typescript", "json", "yaml", "markdown", "ruby" }
local regex_languages = { "ruby" }

require('nvim-treesitter').install(languages)
vim.api.nvim_create_autocmd('FileType', {
	pattern = languages,
	callback = function(ev)
		vim.treesitter.start()
		if vim.list_contains(regex_languages, ev.match) then vim.bo[ev.buf].syntax = 'ON' end
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

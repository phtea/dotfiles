local languages = { "lua", "python", "bash", "vim", "javascript", "typescript", "json", "yaml", "markdown", "ruby" }

require('nvim-treesitter').install(languages)
vim.api.nvim_create_autocmd('FileType', {
	pattern = languages,
	callback = function()
		vim.treesitter.start()
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

vim.keymap.set({"n","x","o"}, "<M-o>", function() vim.treesitter.select("parent", vim.v.count1) end, { desc = "TS: Select parent" })
vim.keymap.set({"n","x","o"}, "<M-i>", function() vim.treesitter.select("child", vim.v.count1) end, { desc = "TS: Select child" })

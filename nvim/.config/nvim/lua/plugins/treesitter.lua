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

vim.keymap.set("n", "<M-o>", "van", { remap = true, desc = "Treesitter: Init selection" })
vim.keymap.set("x", "<M-o>", "an", { remap = true, desc = "Treesitter: Expand selection" })
vim.keymap.set("x", "<M-i>", "in", { remap = true, desc = "Treesitter: Shrink selection" })

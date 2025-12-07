vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
})

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"lua", "python", "bash", "vim", "javascript", "typescript", "json", "yaml", "markdown", "ruby"
	},
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = true,
	},
	indent = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection   = "<M-o>", -- init
			node_incremental = "<M-o>", -- expand
			node_decremental = "<M-i>", -- shrink
		},
	},
})

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.cmd [[
	set foldcolumn=5
]]

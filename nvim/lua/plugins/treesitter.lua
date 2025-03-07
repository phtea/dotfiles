return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			highlight = { enable = true, additional_vim_regex_highlighting = false },
			indent = { enable = false }, -- Try disabling this if it's causing lag
			auto_install = true,
		})
	end,
}

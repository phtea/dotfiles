return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			auto_install = true,
			highlight = { enable = true, },
			indent = { enable = true },
			-- ensure_installed = {
			-- 	"bash", "c", "diff", "html", "javascript",
			-- 	"json", "markdown", "markdown_inline", "lua", "python", "go",
			-- 	"vim", "vimdoc", "regex",
			-- },
		})
	end,
}

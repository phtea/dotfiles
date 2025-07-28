require("nvim-treesitter.configs").setup {
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
	    init_selection   = "<M-o>",
	    node_incremental = "<M-o>",
	    node_decremental = "<M-i>",
	},
    },
}

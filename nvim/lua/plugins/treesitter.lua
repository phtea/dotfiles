return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true, },
                indent = { enable = true },
                ensure_installed = {
                    "bash", "c", "diff", "html", "javascript",
                    "json", "markdown", "lua", "python", "go",
					"vim", "vimdoc",
                },
            })
        end,
    },
}

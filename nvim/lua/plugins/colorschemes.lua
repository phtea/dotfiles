return {
    {
        "EdenEast/nightfox.nvim",
        lazy = true,
        config = function()
            require('nightfox').setup({
                options = {
                    styles = {
                        comments = "italic",
                        keywords = "bold",
                        types = "italic,bold",
                    }
                }
            })
        end,
    },
    {
        "Mofiqul/vscode.nvim",
        lazy = true,
        config = function()
            vim.o.background = 'dark'
            local color1 = '#080808'
            require('vscode').setup({
                italic_comments = true,
                color_overrides = {
                    vscBack = color1,
                    vscTabCurrent = color1,
                    vscTabOutside = color1,
                    vscLeftDark = color1,
                    vscPopupBack = color1,
                },
            })
        end,
    },
    {
        "dgox16/oldworld.nvim",
        lazy = true,
    },
    {
        "sam4llis/nvim-tundra",
        lazy = true,
        config = function()
            vim.g.tundra_biome = "jungle"
            vim.opt.background = "dark"
        end,
    },
    {
        "mellow-theme/mellow.nvim",
        lazy = true,
    },
}

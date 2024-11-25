return function(use)
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { "lua", "python", "go" }, -- Specify the parsers you want
                highlight = {
                    enable = true,                             -- Enable Treesitter-based highlighting
                    additional_vim_regex_highlighting = false, -- Disable legacy syntax highlighting
                },
                indent = { enable = true } -- Enable Treesitter-based indentation
            }
        end
    }
end


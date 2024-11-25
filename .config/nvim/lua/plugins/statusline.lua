return function(use)
    use {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup {
                options = {
                    theme = 'auto', -- Automatically use theme based on colorscheme
                    section_separators = '',
                    component_separators = '',
                }
            }
            vim.opt.showmode = false -- Hide redundant mode in the command area
        end
    }
end


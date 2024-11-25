local packer = require('packer')

local plugins = function(use)
    -- Plugin manager
    use 'wbthomason/packer.nvim'

    -- Plugins
    require('plugins.comment')(use)  -- Comments
    require('plugins.faster')(use)   -- Performance improvement for big files
    require('plugins.colorscheme')(use) -- VSCode theme
    require('plugins.treesitter')(use) -- Treesitter (syntax highlighting)
    require('plugins.telescope')(use) -- Telescope (file-picker)
    require('plugins.statusline')(use) -- Status-line (lualine)
    require('plugins.lsp').setup(use) -- Call the setup function from plugins/lsp
end

packer.startup(plugins)

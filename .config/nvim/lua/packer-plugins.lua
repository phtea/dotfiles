-- bootstrap

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer() -- Check if Packer is installed

-- bootstrap

local packer = require('packer')

return packer.startup(function(use) -- Plugin manager
    use 'wbthomason/packer.nvim'

    -- Plugins
    require('plugins.comment')(use)     -- Comments
    require('plugins.faster')(use)      -- Performance improvement for big files
    require('plugins.colorscheme')(use) -- VSCode theme
    require('plugins.treesitter')(use)  -- Treesitter (syntax highlighting)
    require('plugins.telescope')(use)   -- Telescope (file-picker)
    require('plugins.statusline')(use)  -- Status-line (lualine)
    require('plugins.lsp').setup(use)   -- Call the setup function from plugins/lsp

    -- Automatically sync Packer if bootstrapped
    if packer_bootstrap then
        packer.sync()
    end
end)

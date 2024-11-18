-- Ensure packer is installed
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Initialize packer if needed
require('packer').startup(function(use)
    -- Add plugins here
    use 'wbthomason/packer.nvim'  -- Plugin manager itself
    use 'neovim/nvim-lspconfig' -- Plugin for lsp
    use 'hrsh7th/cmp-nvim-lsp' -- Plugin for completion
    use 'hrsh7th/nvim-cmp'  -- Completion plugin
    use 'L3MON4D3/LuaSnip' -- LuaSnip plugin
    use { "catppuccin/nvim", as = "catppuccin" }

    -- Add other plugins...
    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- Load core settings
require("settings")

-- Load keymaps
require("keymaps")

-- Load plugins
require("plugins.colorscheme")
require("plugins.lsp")

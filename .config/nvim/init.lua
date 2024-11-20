-- init.lua

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

-- Add plugins here
require('packer').startup(function(use)

    -- Plugin manager
    use 'wbthomason/packer.nvim'

    -- LSP
    use 'neovim/nvim-lspconfig' -- Lsp
    use 'hrsh7th/cmp-nvim-lsp' -- Lsp dependency
    use 'hrsh7th/nvim-cmp'  -- Lsp dependency 2
    use { 'L3MON4D3/LuaSnip', run = "make install_jsregexp" } -- LuaSnip (lsp -> snippets)

    -- Comments
    use {
        'numToStr/Comment.nvim',
        config = require("plugins.comment")
    }
    -- VSCode theme
    use 'Mofiqul/vscode.nvim'

    use 'pteroctopus/faster.nvim' -- fast big files

    -- Treesitter for syntax support
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require("plugins.treesitter")
        end
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('plugins.telescope')
        end
    }

    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- Load core settings
require("settings")

-- Load keymaps
require("keymaps")

-- Load plugins
require("plugins.lsp")

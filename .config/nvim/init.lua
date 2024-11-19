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

-- Initialize packer if needed
require('packer').startup(function(use)
    -- Add plugins here
    use 'wbthomason/packer.nvim'  -- Plugin manager
    use 'neovim/nvim-lspconfig' -- Lsp
    use 'hrsh7th/cmp-nvim-lsp' -- Completion
    use 'hrsh7th/nvim-cmp'  -- Completion 2?
    use { 'L3MON4D3/LuaSnip', run = "make install_jsregexp" } -- LuaSnip (dependency for completion)
    use { "junegunn/fzf", run = "./install --bin" } -- Fuzzyfinder (file picker)
    use 'numToStr/Comment.nvim' -- Comments
    use 'Mofiqul/vscode.nvim' -- Vscode theme
    use 'pteroctopus/faster.nvim' -- fast big files
    use 'nvim-treesitter/nvim-treesitter' -- Treesitter (syntax highlighting)
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
require("plugins.comment")
require("plugins.treesitter")

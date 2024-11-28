-- Bootstrap lazy.nvim (if it's not installed)
local ensure_lazy = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/lazy/lazy.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--filter=blob:none', '--depth', '1', 'https://github.com/folke/lazy.nvim.git', install_path })
        vim.cmd [[packadd lazy.nvim]]
        return true
    end
    return false
end

local lazy_bootstrap = ensure_lazy() -- Check if lazy.nvim is installed

-- Initialize lazy.nvim
local lazy = require('lazy')

-- Setup plugins using lazy.nvim
lazy.setup({
    -- Plugin manager itself (lazy.nvim)
    { 'folke/lazy.nvim' },

    -- Plugins setup
    { 'tpope/vim-commentary', config = require('plugins.comment') },  -- Comments
    { 'famiu/faster.nvim', config = require('plugins.faster') },      -- Performance improvement for big files
    { 'Mofiqul/vscode.nvim', config = require('plugins.colorscheme') }, -- VSCode theme
    { 'nvim-treesitter/nvim-treesitter', config = require('plugins.treesitter') }, -- Treesitter (syntax highlighting)
    { 'nvim-telescope/telescope.nvim', config = require('plugins.telescope') }, -- Telescope (file-picker)
    { 'nvim-lualine/lualine.nvim', config = require('plugins.statusline') }, -- Status-line (lualine)
    -- LSP setup

    { 'neovim/nvim-lspconfig', config = function() require('plugins.lsp').setup() end },
})

-- Automatically sync lazy.nvim if bootstrapped
if lazy_bootstrap then
    lazy.sync()  -- Sync after bootstrapping
end


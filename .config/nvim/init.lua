local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local packer = require('packer')

-- Add plugins here
packer.startup(function(use)
    -- Plugin manager
    use 'wbthomason/packer.nvim'

    -- LSP
    use 'neovim/nvim-lspconfig' -- LSP
    use 'hrsh7th/cmp-nvim-lsp'  -- LSP dependency
    use 'hrsh7th/nvim-cmp'      -- LSP dependency 2
    use { 'L3MON4D3/LuaSnip', run = "make install_jsregexp" } -- LuaSnip

    -- Comments
    use {
        'numToStr/Comment.nvim',
        config = function() require("plugins.comment") end
    }

    -- VSCode theme
    use 'Mofiqul/vscode.nvim'

    -- Performance improvement for big files
    use 'pteroctopus/faster.nvim'

    -- Treesitter for syntax support
    use {
        'nvim-treesitter/nvim-treesitter',
        config = function() require("plugins.treesitter") end
    }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function() require('plugins.telescope') end
    }

    -- Sync Packer if we bootstrapped it
    if packer_bootstrap then
        packer.sync()
    end
end)

-- Load core settings
require("settings")

-- Load keymaps
require("keymaps")

-- Load plugin-specific settings
require("plugins.lsp")

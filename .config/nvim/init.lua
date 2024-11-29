-- ===========================
-- Lazy Plugins
-- ===========================

vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

if not vim.loop.fs_stat(vim.fn.stdpath("data") .. "/lazy/lazy.nvim") then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
  })
end

require("lazy").setup({
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = true, -- Automatically loaded when required by dependent plugins
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()

      local lspconfig = require("lspconfig")
      lspconfig.gopls.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
        capabilities = capabilities,
      })

		vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
		})

		-- Common LSP keybindings
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition" })
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "Find References" })
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover Documentation" })
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename Symbol" })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- Load when entering insert mode
    dependencies = {
      { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate", -- Equivalent to `run` in packer.nvim
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
		},
		indent = { enable = true },
		-- Include markdown parsers for lsp hover documentation.
		ensure_installed = {
			"bash",
			"c",
			"diff",
			"html",
			"javascript",
			"jsdoc",
			"json",
			"jsonc",
			"lua",
			"luadoc",
			"luap",
			"markdown",
			"markdown_inline",
			"printf",
			"python",
			"query",
			"regex",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
		    "go",
		 }
      })
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false, -- Load immediately during startup
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("nightfox")
    end,
  },
})

-- ===========================
-- General Settings & Options
-- ===========================

vim.g.mapleader = " "
vim.opt.undofile = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 10
vim.opt.signcolumn = 'yes'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.tabstop = 4
vim.shiftwidth = 4
vim.opt.relativenumber = true
vim.opt.number = true
vim.cmd("highlight CursorLineNr guifg=#ff6347") -- Change the color code as you like
vim.opt.cursorline = true
-- Force netrw to open in a vertical split (left side)
vim.g.netrw_browse_split = 4  -- Open netrw in a vertical split (on the left)
vim.g.netrw_altv = 1          -- Force vertical split when opening netrw
vim.g.netrw_winsize = 25      -- Optional: set the width of the netrw window

-- ===========================
-- Key Mappings
-- ===========================

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = "Clear search highlights" })
vim.keymap.set('n', '<leader>e', ':Lexplore<CR>', { desc = 'Open Netrw Explorer on the left' })
vim.keymap.set('n', '<A-j>', ':cnext<CR>', { desc = 'Scroll to next quickfix item' })
vim.keymap.set('n', '<A-k>', ':cprev<CR>', { desc = 'Scroll to previous quickfix item' })
vim.keymap.set('n', '<A-q>', ':only<CR>', { desc = 'Close all other windows besides this one' })

-- ===========================
-- Clipboard Setup (for WSL)
-- ===========================

vim.g.clipboard = {
		name = 'WslClipboard',
		copy = {
				['+'] = '/mnt/c/Windows/System32/clip.exe',
				['*'] = '/mnt/c/Windows/System32/clip.exe',
		},
		paste = {
				['+'] =
				'/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
				['*'] =
				'/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		},
		cache_enabled = 0,
}

-- ===========================
-- Autocommands for completion & UI
-- ===========================

-- Highlight text when yanking (copying)
vim.api.nvim_create_autocmd('TextYankPost', {
		desc = 'Highlight when yanking (copying) text',
		group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
		callback = function()
				vim.highlight.on_yank()
		end,
})

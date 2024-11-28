-- Packer install

local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false
print("Install Path: " .. install_path)

-- If Packer is not installed, install it
if vim.fn.isdirectory(install_path) == 0 then  -- 0 means directory doesn't exist
  print("Packer not found, installing...")
  local result = vim.fn.system({
    'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path
  })

  if vim.v.shell_error == 0 then
    print("Packer successfully installed!")
    vim.cmd('packadd packer.nvim')
    packer_bootstrap = true
  else
    print("Error installing Packer: " .. result)
  end
end

-- Initialize packer
require('packer').startup(function(use)
		-- Plugin manager itself
		use 'wbthomason/packer.nvim'

		-- LSP configurations and dependencies
		use {
				'neovim/nvim-lspconfig',
				requires = { 'hrsh7th/cmp-nvim-lsp' },
				config = function ()
						local cmp_nvim_lsp = require('cmp_nvim_lsp')
						local capabilities = cmp_nvim_lsp.default_capabilities()
						-- LSP setups
						local lspconfig = require('lspconfig')
						lspconfig.gopls.setup({capabilities = capabilities,})
						lspconfig.pyright.setup({capabilities = capabilities,})
						lspconfig.lua_ls.setup({
								settings = {
										Lua = {
												diagnostics = {
														globals = {'vim'},
												},
										},
								},
								capabilities = capabilities,
						})
				end,
		}
		use 'hrsh7th/nvim-cmp'                                        -- Completion plugin
		use { 'L3MON4D3/LuaSnip', run = "make install_jsregexp" }     -- Snippet plugin
		use {
				'nvim-treesitter/nvim-treesitter',
				run = function()
					local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
					ts_update()
				end,
		}
		use {
				'EdenEast/nightfox.nvim',
				config = function()
						vim.cmd('colorscheme nightfox')
				end
		}

		-- Sync Packer if it's just been installed
		if packer_bootstrap then
				require('packer').sync()
		end
end)

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
-- LSP Configuration
-- ===========================

local cmp = require('cmp')
local luasnip = require('luasnip')

-- Common LSP keybindings
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "Find References" })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename Symbol" })

-- Define capabilities for LSP (used for autocompletion)

vim.diagnostic.config({
		virtual_text = true,
		signs = true,
		underline = true,
})

-- ===========================
-- Treesitter Configuration
-- ===========================

require'nvim-treesitter.configs'.setup {
		-- Enable treesitter-based highlighting
		highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
		},
		-- Add additional parsers as needed
		ensure_installed = { "go", "python", "lua" },
}

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
-- Autocompletion Setup
-- ===========================

-- nvim-cmp setup
cmp.setup({
		snippet = {
				expand = function(args)
						luasnip.lsp_expand(args.body)  -- For snippet support
				end,
		},
		mapping = cmp.mapping.preset.insert({
				['<C-Space>'] = cmp.mapping.complete(),
				['<CR>'] = cmp.mapping.confirm({ select = true }),
				['<Tab>'] = cmp.mapping.confirm({ select = true }),
		}),
		sources = {
				{ name = 'nvim_lsp' }, -- LSP source
				{ name = 'luasnip' }, -- Snippet source
		},
})

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

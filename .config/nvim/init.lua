-- ===========================
-- Lazy Plugins
-- ===========================

-- Lazy bootstrap
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

-- Lazy plugins setup
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

			-- Add quickfix list with all diagnostics
			vim.keymap.set('n', 'grd', function()
				local diagnostics = vim.diagnostic.get(0)  -- Get diagnostics for the current buffer

				if #diagnostics == 0 then
					print("No diagnostics available.")
				else
					vim.diagnostic.setqflist()  -- Populates the quickfix list with diagnostics from the current buffer
					vim.cmd('copen')            -- Opens the quickfix list
					vim.cmd('cnext')
				end
			end, { desc = "Show all diagnostics in Quickfix" })
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
				ensure_installed = {
					"bash", "c", "diff", "html", "javascript",
					"jsdoc", "json", "jsonc", "markdown", "markdown_inline",
					"printf", "query", "regex", "toml", "tsx",
					"typescript", "vim", "vimdoc", "xml", "yaml",
					"go", "python", "lua", "luadoc", "luap",
				},
			})
		end,
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = false, -- Load immediately during startup
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("nightfox")
			vim.cmd("highlight CursorLineNr guifg=#ff6347")
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
vim.opt.scrolloff = 20
vim.opt.signcolumn = 'yes'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.tabstop = 4
vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true

-- Netrw
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
vim.keymap.set('n', '<C-q>', ':only<CR>', { desc = 'Close all windows besides current' })
vim.keymap.set('n', '<A-q>', ':only<CR>', { desc = 'Close all windows besides current' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = "Clear search highlights" })
vim.keymap.set('n', '<leader>e', ':Lex<CR>', { desc = 'Open Netrw Explorer on the left' })
vim.keymap.set('n', '<A-j>', ':cnext<CR>', { desc = 'Scroll to next quickfix item' })
vim.keymap.set('n', '<A-k>', ':cprev<CR>', { desc = 'Scroll to previous quickfix item' })

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

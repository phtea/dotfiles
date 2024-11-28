-- phtea's minimal init.lua

-- ===========================
-- General Settings & Options
-- ===========================

-- Set line numbers and relative numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Enable undo history
vim.opt.undofile = true

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Scroll settings
vim.opt.scrolloff = 10  -- Keep minimal number of screen lines above and below the cursor.
vim.opt.signcolumn = 'yes'  -- Always show the sign column

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- ===========================
-- Leader Key & Key Mappings
-- ===========================

-- Set leader key
vim.g.mapleader = " "

-- Key mappings for window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Clear search highlights when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = "Clear search highlights" })

-- ===========================
-- LSP Configuration
-- ===========================

-- General LSP setup function
local function setup_lsp(server_name, server_cmd, filetypes)
    -- Autostart LSP for specified filetypes
    vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function()
            vim.lsp.start({
                name = server_name,
                cmd = server_cmd,
                root_dir = vim.fn.getcwd(),  -- Use the current directory as root
            })
        end,
    })
end

-- Example LSP setups
setup_lsp("gopls", { "gopls" }, { "go" })  -- Go LSP
setup_lsp("pyls", { "pyls" }, { "python" }) -- Python LSP

-- Common LSP keybindings
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "Find References" })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename Symbol" })

-- Trigger LSP completion on Ctrl-Space (same as Ctrl-X Ctrl-O)
vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', { desc = "Trigger LSP Completion" })

-- ===========================
-- Completion Navigation & Selection
-- ===========================

-- Key mappings for navigating and selecting completions
vim.keymap.set('i', '<Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-n>'  -- Scroll down in the completion menu
  else
    return '<Tab>'  -- Default behavior if no menu is visible
  end
end, { expr = true, desc = "Scroll down in completion menu" })

vim.keymap.set('i', '<S-Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-p>'  -- Scroll up in the completion menu
  else
    return '<S-Tab>'  -- Default behavior if no menu is visible
  end
end, { expr = true, desc = "Scroll up in completion menu" })

-- Select completion with Enter (if menu is visible)
vim.keymap.set('i', '<CR>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-y>'  -- Confirm completion selection
  else
    return '<CR>'  -- Default behavior if no menu is visible
  end
end, { expr = true, desc = "Confirm completion selection" })

-- ===========================
-- Diagnostics & UI Configuration
-- ===========================

-- Diagnostics configuration (showing virtual text, signs, and underlining)
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
})

-- Set the colorscheme to 'slate'
vim.cmd("colorscheme slate")

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
-- Autocommands
-- ===========================

-- Highlight text when yanking (copying)
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

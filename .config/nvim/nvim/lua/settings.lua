-- General Neovim settings
vim.o.number = true                   -- Enable line numbers
vim.o.relativenumber = true           -- Relative line numbers
vim.o.tabstop = 4                     -- Number of spaces per tab
vim.o.shiftwidth = 4                  -- Spaces per indentation
vim.o.expandtab = true                -- Convert tabs to spaces
vim.o.smartindent = true              -- Auto-indent new lines
vim.o.wrap = false                    -- Disable line wrapping
vim.o.mouse = "a"                     -- Enable mouse in all modes
vim.o.clipboard = "unnamedplus"       -- Use system clipboard

-- Search behavior
vim.o.ignorecase = true               -- Ignore case
vim.o.smartcase = true                -- Enable smart case
vim.o.hlsearch = true                 -- Disable search highlighting
vim.o.incsearch = true                -- Show matches while typing the search term

-- Undo settings
vim.o.undofile = true                 -- Enable undo files
vim.o.undodir = vim.fn.stdpath("data") .. "/undo"

-- Split behavior
vim.o.splitright = true               -- Vertical splits to the right
vim.o.splitbelow = true               -- Horizontal splits below

-- General clipboard settings for WSL compatibility
vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
        ['+'] = 'clip.exe',
        ['*'] = 'clip.exe',
    },
    paste = {
        ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
}

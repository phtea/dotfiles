-- General Neovim settings
vim.o.number = true         -- Enable line numbers
vim.o.relativenumber = true -- Relative line numbers
vim.o.tabstop = 4           -- Number of spaces per tab
vim.o.shiftwidth = 4        -- Spaces per indentation
vim.o.expandtab = true      -- Convert tabs to spaces
vim.o.smartindent = true    -- Auto-indent new lines
vim.o.wrap = false          -- Disable line wrapping
vim.o.mouse = "a"           -- Enable mouse in all modes
vim.o.clipboard = ""        -- Use default clipboard (disabled by default)
vim.opt.swapfile = false    -- Don't use swapfiles
vim.o.so = 30               -- Automatically center (see N lines below and above)
vim.opt.cursorline = true   -- Show which line your cursor is on
vim.opt.signcolumn = 'yes'  -- Keep signcolumn on by default

-- Search behavior
vim.o.ignorecase = true -- Ignore case
vim.o.smartcase = true  -- Enable smart case
vim.o.hlsearch = true   -- Disable search highlighting
vim.o.incsearch = true  -- Show matches while typing the search term

-- Undo settings
vim.o.undofile = true -- Enable undo files
vim.o.undodir = vim.fn.stdpath("data") .. "/undo"

-- Split behavior
vim.o.splitright = true -- Vertical splits to the right
vim.o.splitbelow = true -- Horizontal splits below

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

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

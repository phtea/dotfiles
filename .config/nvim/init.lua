-- Enable syntax highlighting and line numbers
vim.cmd("syntax on")                    -- Turn on syntax highlighting
vim.o.number = true                     -- Show line numbers
vim.o.relativenumber = true             -- Show relative line numbers

-- Set indentation and tabs
vim.o.tabstop = 4                       -- Number of spaces a <Tab> counts for
vim.o.shiftwidth = 4                    -- Number of spaces for each indent step
vim.o.expandtab = true                  -- Use spaces instead of tabs
vim.o.autoindent = true                 -- Maintain indent of current line
vim.o.smartindent = true                -- Automatically indent new lines

-- Enable line wrapping and search settings
vim.o.wrap = true                       -- Enable line wrapping
vim.o.ignorecase = true                 -- Ignore case when searching
vim.o.smartcase = true                  -- Override ignorecase if search includes capitals
vim.o.incsearch = true                  -- Show matches as you type
vim.o.hlsearch = true                   -- Highlight search matches

-- Display settings
-- vim.o.cursorline = true               -- Highlight the current line (uncomment if needed)
vim.o.showcmd = true                    -- Display incomplete commands
vim.o.wildmenu = true                   -- Enhanced command line completion
vim.o.scrolloff = 8                     -- Keep 8 lines visible above/below cursor when scrolling

-- Enable mouse support and clipboard
vim.o.mouse = "a"                       -- Enable mouse usage in all modes

-- Better backspacing and undo options
vim.o.backspace = "indent,eol,start"    -- Make backspace more powerful
vim.o.undofile = true                   -- Enable undo file
vim.o.undodir = vim.fn.stdpath('data') .. '/undo'  -- Set undo directory

-- Status line and color scheme
vim.o.laststatus = 2                    -- Always show the status line
vim.o.ruler = true                      -- Show cursor position in the status line
vim.cmd("colorscheme slate")            -- Set color scheme
vim.o.background = "dark"               -- Preferred background for better contrast

-- Split window preferences
vim.o.splitbelow = true                 -- Horizontal splits open below
vim.o.splitright = true                 -- Vertical splits open to the right

-- Basic key mappings for productivity
vim.api.nvim_set_keymap("n", "<Space>", ":nohlsearch<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-n>", ":bn<CR>", { noremap = true, silent = true })  -- Move to the next buffer
vim.api.nvim_set_keymap("n", "<C-p>", ":bp<CR>", { noremap = true, silent = true })  -- Move to the previous buffer
-- Map <C-c> to copy the selected text to the clipboard in visual mode
vim.api.nvim_set_keymap("v", "<C-c>", '"+y', { noremap = true, silent = true })

-- Define <F5> key to run SQL files in SQLite3 only if file type is SQL
vim.api.nvim_create_autocmd("FileType", {
    pattern = "sql",
    callback = function()
        vim.api.nvim_set_keymap(
            "n", 
            "<F5>", 
            ":w<CR>:!cat % | sqlite3 -column -header fiftyville.db<CR>", 
            { noremap = true, silent = true }
        )
    end,
})

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


-- Enable filetype plugins and indentation
vim.cmd("filetype plugin indent on")    -- Enable filetype-specific plugins and indentation


-- Colorscheme
vim.cmd.colorscheme("wildcharm")

-- Transparent background
vim.api.nvim_set_hl(0, "Normal",      { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC",    { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })


-- Make NormalFloat transparent
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

-- Line numbers
vim.api.nvim_set_hl(0, "LineNr",      { fg = "#80a0ff", ctermfg = "LightBlue" })
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "Gray", ctermfg = "Gray" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "Gray", ctermfg = "Gray" })

-- Sign column always visible
vim.opt.signcolumn = "yes"

-- Status line transparent
vim.api.nvim_set_hl(0, "StatusLine",   { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", ctermbg = "NONE" })

vim.opt.termguicolors = true
vim.wo.relativenumber = true
vim.o.scrolloff = 10
vim.o.statusline = "%{v:lua.require'git_branch'.get_branch()}%f %h%m%r%=%y %p%%"

vim.o.swapfile = false

-- Search and interface
vim.opt.path:append("**")
vim.opt.number = true
vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Size of and indent
vim.opt.shiftwidth = 4

-- Grep
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Enable persistent undo
vim.opt.undofile = true

-- Set undo directory
local undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undodir = undodir

-- Auto-create the undo directory if it doesn't exist
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end

-- Highlight on yank
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   desc = 'Highlight when yanking (copying) text',
--   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
--   callback = function()
--     vim.hl.on_yank()
--   end,
-- })

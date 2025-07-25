vim.g.netrw_banner = 0
vim.g.mapleader = " "

-- General settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.winbar = "single"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 2
vim.opt.swapfile = false
vim.opt.scrolloff = 10
vim.opt.cursorline = true
vim.opt.lazyredraw = true
vim.opt.path:append("**")
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.showcmd = true

-- Enable persistent undo
vim.opt.undofile = true

-- Set undo directory
local undodir = vim.fn.stdpath("config") .. "/undo"
vim.opt.undodir = undodir

-- Auto-create the undo directory if it doesn't exist
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

vim.o.swapfile = false
vim.o.lazyredraw = true

-- Search and interface
vim.opt.path:append("**")
vim.opt.number = true
vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.o.winborder = 'single'

vim.opt.termguicolors = true
vim.wo.relativenumber = true
vim.o.scrolloff = 10

vim.opt.tabstop = 4
vim.opt.shiftwidth = 2

-- Grep
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Sign column always visible
vim.opt.signcolumn = "yes"
vim.o.statusline = "%{v:lua.require'git_branch'.get_branch()}%f %h%m%r%=%y %p%%"

-- Enable persistent undo
vim.opt.undofile = true
local undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undodir = undodir

-- Auto-create the undo directory if it doesn't exist
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

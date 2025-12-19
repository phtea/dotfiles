vim.cmd [[
	set hlsearch incsearch ignorecase smartcase " search
	set number relativenumber " line numbers
	set tabstop=2 shiftwidth=2 scrolloff=5 signcolumn=yes
	set path+=** lazyredraw
	set termguicolors showcmd winborder=single " ui
	set cursorline " enable cursorline
	set showtabline=0  " don't show tabs
	set shortmess+=I " no intro message
	set undofile noswapfile " file handling
	"set guicursor= " if i don't want different cursors for insert and other modes
	set timeoutlen=5000 " wait for combination for 5 seconds (when I'm thinking slow)
]]

-- Grep
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Enable persistent undo
local undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undodir = undodir

-- Auto-create the undo directory if it doesn't exist
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

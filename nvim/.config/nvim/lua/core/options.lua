vim.cmd [[
	set hlsearch incsearch ignorecase smartcase " search
	set number relativenumber " line numbers
	set tabstop=2 shiftwidth=2 scrolloff=5 signcolumn=yes
	set path+=** lazyredraw
	set cursorline " enable cursorline
	set showtabline=0  " don't show tabs
	set undofile noswapfile " file handling
	set timeoutlen=5000 " wait for combination for 5 seconds (when I'm thinking slow)
	set exrc " for .nvim.lua (project-specific files)
	" UI
	set termguicolors
	set noshowmode " since cursor is default again I don't really need to see the mode - cursor says it all
	set winborder=single
	"set guicursor=n-v-c-i-r-sm-t:block,o:hor20 " operator-pending mode should be horizontal bar; else default
	"set list listchars=tab:»\ ,trail:·,extends:❯,precedes:❮,nbsp:␣
]]

-- Enable persistent undo
local undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undodir = undodir
-- Auto-create the undo directory if it doesn't exist
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

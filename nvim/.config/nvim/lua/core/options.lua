vim.cmd [[
	set hlsearch incsearch ignorecase smartcase " search
	set number relativenumber " line numbers
	set tabstop=2 shiftwidth=2 scrolloff=5 signcolumn=yes
	set path+=** lazyredraw
	set cursorlineopt=number cursorline " enable cursorline
	set showtabline=0  " don't show tabs
	set undofile noswapfile " file handling
	set timeoutlen=5000 " wait for combination for 5 seconds (when I'm thinking slow)
	set exrc " for .nvim.lua (project-specific files)
	" UI
	set termguicolors
	set winborder=single
	set list listchars=tab:\ \ ,trail:·,extends:❯,precedes:❮,nbsp:␣

	set grepprg=rg\ --vimgrep\ --smart-case\ --no-messages
	set grepformat=%f:%l:%c:%m

	set switchbuf=useopen " existing buffer should be reused

	" Cursor stuff
	"set noshowmode " show current mode like -- INSERT --
	set guicursor=n-v-c-i-r-sm-t:block,o:hor20 " => operator-pending mode should be horizontal bar; else default
]]

local paths = {
  undo  = vim.fn.stdpath("data") .. "/undo",
  cache = vim.fn.stdpath("cache"),
}

for _, path in pairs(paths) do
  vim.fn.mkdir(path, "p")
end

-- Persistent undo
vim.opt.undodir = paths.undo

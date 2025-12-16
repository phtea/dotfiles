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

vim.opt.statusline = table.concat({
	"%{v:lua.get_git_branch()}",
	"%{v:lua.statusline_filename()} %h%m%r%=",
	"%{v:lua.get_current_lsp_names()}",
	"%l:%v",
})

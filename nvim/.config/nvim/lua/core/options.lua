vim.cmd[[
  set hlsearch incsearch ignorecase smartcase number relativenumber tabstop=2 shiftwidth=2 scrolloff=5 signcolumn=yes
  set path+=** lazyredraw cursorline cursorlineopt=number showtabline=0 switchbuf=useopen confirm
  set undofile noswapfile exrc secure guicursor= termguicolors winborder=single noshowmode tm=10000
  set complete=o,.,w,b completeopt=menuone,noinsert,fuzzy,popup pumheight=10
]]

local paths = {
	undo = vim.fn.stdpath("data") .. "/undo",
	cache = vim.fn.stdpath("cache"),
}

for _, path in pairs(paths) do
	vim.fn.mkdir(path, "p")
end

vim.opt.undodir = paths.undo

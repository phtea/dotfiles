vim.cmd[[
  set ignorecase smartcase number relativenumber tabstop=2 shiftwidth=2 signcolumn=yes
  set path+=** lazyredraw cursorline cursorlineopt=number showtabline=0 switchbuf=useopen confirm
  set undofile noswapfile winborder=single tm=10000
]]

local paths = {
	undo = vim.fn.stdpath("data") .. "/undo",
	cache = vim.fn.stdpath("cache"),
}

for _, path in pairs(paths) do
	vim.fn.mkdir(path, "p")
end

vim.opt.undodir = paths.undo

-- Filetype mappings
vim.filetype.add({
		extension = { yml = "yaml" },
		filename = { [".env"] = "dosini" },
		pattern = {
			[".*%.env%..*"] = "dosini",
			[".*%.yml%..*"] = "yaml",
		},
})

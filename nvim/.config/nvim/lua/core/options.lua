vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.scrolloff = 5
vim.opt.signcolumn = "yes"

vim.opt.path:append("**")
vim.opt.lazyredraw = true

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.opt.showtabline = 0

vim.opt.undofile = true
vim.opt.swapfile = false

vim.opt.exrc = true
vim.opt.secure = true

vim.opt.guicursor = "n-v-c-i-r-sm-t:block,o:hor20"

vim.opt.completeopt = { "menuone", "noinsert", "fuzzy", "popup" }
vim.opt.complete = { "o", ".", "w", "b" }
vim.opt.autocomplete = false

vim.opt.switchbuf = "useopen"

vim.opt.termguicolors = true
vim.opt.winborder = "single"

if vim.fn.executable("rg") == 1 then
	function _G.RgFindFiles(cmdarg, _cmdcomplete)
		local fnames = vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git"')
		if #cmdarg == 0 then
			return fnames
		else
			return vim.fn.matchfuzzy(fnames, cmdarg)
		end
	end

	vim.opt.findfunc = "v:lua.RgFindFiles"
	vim.opt.grepprg = "rg --vimgrep --smart-case --no-messages"
	vim.opt.grepformat = "%f:%l:%c:%m"
end

local paths = {
	undo = vim.fn.stdpath("data") .. "/undo",
	cache = vim.fn.stdpath("cache"),
}

for _, path in pairs(paths) do
	vim.fn.mkdir(path, "p")
end

vim.opt.undodir = paths.undo

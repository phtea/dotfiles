vim.opt.swapfile = false
vim.opt.lazyredraw = true
vim.opt.path:append("**")
vim.opt.number = true
vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 10
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.winborder = "single"
vim.opt.showmode = false
vim.opt.cursorline = true

-- No intro message
vim.opt.shortmess:append("I")

-- Grep
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Enable persistent undo
vim.opt.undofile = true
local undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undodir = undodir

-- Auto-create the undo directory if it doesn't exist
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

function _G.statusline_mode()
	local modes = {
		n = "NORMAL",
		i = "INSERT",
		v = "VISUAL",
		V = "V-LINE",
		[""] = "V-BLOCK",
		c = "COMMAND",
		R = "REPLACE",
		t = "TERMINAL",
	}
	local m = vim.fn.mode()
	return modes[m] or m
end

vim.opt.statusline = table.concat({
	" %{v:lua.statusline_mode()} ",
	"%{v:lua.require'git_branch'.get_branch()}",
	"  %f %h%m%r%=",
	"%{v:lua.require'lsp_statusline'.get_lsp()}",
	" %l:%v ",
})

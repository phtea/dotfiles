-- General Settings
vim.g.mapleader = " "
vim.opt.undofile = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 20
vim.opt.signcolumn = "yes"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.tabstop = 4
vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true

-- Clipboard Setup (for WSL)
vim.g.clipboard = {
	name = "WslClipboard",
	copy = {
		["+"] = "/mnt/c/Windows/System32/clip.exe",
		["*"] = "/mnt/c/Windows/System32/clip.exe",
	},
	paste = {
		["+"] =
			"/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace('`r', ''))",
		["*"] =
			"/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace('`r', ''))",
	},
	cache_enabled = 0,
}



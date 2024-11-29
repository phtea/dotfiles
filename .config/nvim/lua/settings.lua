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

-- Netrw
vim.g.netrw_browse_split = 4  -- Open netrw in a vertical split (on the left)
vim.g.netrw_altv = 1          -- Force vertical split when opening netrw
vim.g.netrw_winsize = 25      -- Optional: set the width of the netrw window

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

-- Autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

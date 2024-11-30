-- Lazy bootstrap
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
if not vim.loop.fs_stat(vim.fn.stdpath("data") .. "/lazy/lazy.nvim") then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
	})
end

require("config.autocmds")
require("config.keymaps")
require("config.options")

-- Load plugins from the plugins folder
require("lazy").setup("plugins")


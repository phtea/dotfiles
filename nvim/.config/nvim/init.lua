-- BOOTSTRAP Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
	"git",
	"clone",
	"--filter=blob:none",
	"https://github.com/folke/lazy.nvim.git",
	"--branch=stable",
	lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("options")
require("remap")
require("lazy").setup("plugins", { change_detection = { notify = false, }, })

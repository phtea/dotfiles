-- Colorscheme
vim.cmd.colorscheme("slate")

-- -- Transparent background
-- vim.api.nvim_set_hl(0, "Normal",      { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, "NormalNC",    { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })
--
--
-- -- Make NormalFloat transparent
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
--
-- -- Line numbers
-- vim.api.nvim_set_hl(0, "LineNr",      { fg = "#80a0ff", ctermfg = "LightBlue" })
-- vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "Gray", ctermfg = "Gray" })
-- vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "Gray", ctermfg = "Gray" })

-- Sign column always visible
vim.opt.signcolumn = "yes"

-- Status line transparent
vim.api.nvim_set_hl(0, "StatusLine",   { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", ctermbg = "NONE" })

vim.opt.termguicolors = true
vim.wo.relativenumber = true
vim.o.scrolloff = 10
vim.o.statusline = "%{v:lua.require'git_branch'.get_branch()}%f %h%m%r%=%y %p%%"

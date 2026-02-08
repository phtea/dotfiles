vim.cmd.colorscheme "habamax"

vim.api.nvim_set_hl(0, "Pmenu", { link = "ModeMsg" })
vim.api.nvim_set_hl(0, "VertSplit", { link = "ModeMsg" })

vim.api.nvim_set_hl(0, "Visual", { bg = "#3D4F4F" })
vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#273333" })

vim.api.nvim_set_hl(0, "StatusLine", { bg = "#373737", fg = "#D4D4D4" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#252526", fg = "#D4D4D4" })

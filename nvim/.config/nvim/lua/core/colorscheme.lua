vim.cmd.colorscheme "habamax"

vim.api.nvim_set_hl(0, "Pmenu", { link = "ModeMsg" })
vim.api.nvim_set_hl(0, "VertSplit", { link = "ModeMsg" })
vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#3D4F4F" })
vim.api.nvim_set_hl(0, "Visual", { bg = "#1C1C1C", fg = "#4F6666", reverse = true })

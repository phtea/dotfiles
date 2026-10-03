vim.cmd[[colorscheme vscode]]
vim.api.nvim_set_hl(0, "Pmenu", { link = "ModeMsg" })
vim.api.nvim_set_hl(0, "netrwMarkFile", { link = "MatchParen" })
vim.api.nvim_set_hl(0, "ModeMsg", { link = "Normal" })
vim.api.nvim_set_hl(0, "SnacksPickerMatch", { underline = true, })

-- For visimatch.nvim plugin
vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#113d6f" })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "LspReferenceText" })
vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "LspReferenceText" })
vim.api.nvim_set_hl(0, "LspReferenceTarget", { link = "LspReferenceText" })
vim.api.nvim_set_hl(0, "Visimatch", { bg = "#373737" })

-- Snacks picker colors
vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#AAAAAA", bg = "NONE", })
vim.api.nvim_set_hl(0, "SnacksPickerMatch", { fg = "#75BEFF", bold = true, })
vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", { bg = "NONE", bold = true, })

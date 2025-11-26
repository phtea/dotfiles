vim.pack.add({"https://github.com/vague-theme/vague.nvim"})
require("vague").setup({
	bold = false,
	italic = false,
})
vim.cmd("colorscheme vague")

-- Make statusline transparent
vim.api.nvim_set_hl(0, "StatusLine",   { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })

-- Make CursorLine barely visible
vim.api.nvim_set_hl(0, "CursorLine",   { bg = "#1A1A1A" })

-- Custom hls
vim.api.nvim_set_hl(0, "LocalHighlight",   { bg = "#444444" })
vim.api.nvim_set_hl(0, "Visual",   { bg = "#333333" })
vim.api.nvim_set_hl(0, "WordSelected",   { link = "Visual" })
vim.api.nvim_set_hl(0, "IncSearch",   { bg = "#BFAFA9", fg = "#323232" })

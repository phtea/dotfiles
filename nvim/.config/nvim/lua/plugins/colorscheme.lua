vim.pack.add({
  "https://github.com/vague-theme/vague.nvim",
  "https://github.com/Mofiqul/vscode.nvim",
})

require("vague").setup({
  bold = false,
  italic = false,
})

local M = {}
M.default = "vscode" -- default colorscheme

local set_hl = vim.api.nvim_set_hl

M.overrides = {}

M.overrides.vague = function()
  set_hl(0, "StatusLine",   { bg = "none" })
  set_hl(0, "StatusLineNC", { bg = "none" })
  set_hl(0, "LocalHighlight", { bg = "#444444" })
  set_hl(0, "Search", { bg = "#405065", ctermbg = 11, ctermfg = 0, fg = "#CDCDCD" })
  set_hl(0, "CurSearch", { bg = "#BFAFA9", fg = "#323232" })
  set_hl(0, "IncSearch", { link = "CurSearch" })
end

M.overrides.vscode = function()
  set_hl(0, "StatusLine",   { link = "StatusLineNC" })
end

return M

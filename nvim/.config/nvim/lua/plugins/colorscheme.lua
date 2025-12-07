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
	set_hl(0, "StatusLine", { bg = "none" })
	set_hl(0, "StatusLineNC", { bg = "none" })
	set_hl(0, "Search", { bg = "#405065", ctermbg = 11, ctermfg = 0, fg = "#CDCDCD" })
	set_hl(0, "CurSearch", { bg = "#BFAFA9", fg = "#323232" })
	set_hl(0, "IncSearch", { link = "CurSearch" })
end

M.overrides.vscode = function()
	set_hl(0, "StatusLine", { link = "StatusLineNC" })
	set_hl(0, "Pmenu", { bg = "#252525" })
	set_hl(0, "PmenuKindFunction", { fg = "#DCDCAA" })
	set_hl(0, "PmenuKindMethod", { fg = "#DCDCAA" })
	set_hl(0, "PmenuKindVariable", { fg = "#9CDCFE" })
	set_hl(0, "PmenuKindField", { fg = "#9CDCFE" })
	set_hl(0, "PmenuKindProperty", { fg = "#9CDCFE" })
	set_hl(0, "PmenuKindClass", { fg = "#4EC9B0" })
	set_hl(0, "PmenuKindInterface", { fg = "#4EC9B0" })
	set_hl(0, "PmenuKindStruct", { fg = "#4EC9B0" })
	set_hl(0, "PmenuKindEnum", { fg = "#B8D7A3" })
	set_hl(0, "PmenuKindEnumMember", { fg = "#B8D7A3" })
	set_hl(0, "PmenuKindKeyword", { fg = "#C586C0" })
	set_hl(0, "PmenuKindModule", { fg = "#C586C0" })
	set_hl(0, "PmenuKindConstant", { fg = "#CE9178" })
	set_hl(0, "PmenuKindConstructor", { fg = "#DCDCAA" })
	set_hl(0, "PmenuKindTypeParam", { fg = "#4EC9B0" })
	set_hl(0, "PmenuKindSnippet", { fg = "#D7BA7D" })
	set_hl(0, "PmenuKindFile", { fg = "#D4D4D4" })
	set_hl(0, "PmenuKindFolder", { fg = "#D4D4D4" })
	set_hl(0, "PmenuKindReference", { fg = "#D4D4D4" })
	set_hl(0, "PmenuKindOperator", { fg = "#D4D4D4" })
	set_hl(0, "PmenuKindText", { fg = "#D4D4D4" })
	set_hl(0, "PmenuKindValue", { fg = "#CE9178" })
	set_hl(0, "PmenuKindUnit", { fg = "#CE9178" })
	set_hl(0, "PmenuKindColor", { fg = "#D4D4D4" })
	set_hl(0, "PmenuKindEvent", { fg = "#D7BA7D" })
end

return M

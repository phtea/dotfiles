vim.pack.add({ "https://github.com/Mofiqul/vscode.nvim", })

local M = {}
M.default = "vscode" -- default colorscheme

M.overrides = {}

local set_hl = vim.api.nvim_set_hl
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

	-- Make keywords/functions/types pop more (VS-like)
	set_hl(0, "Keyword", { fg = "#C586C0" })
	set_hl(0, "Function", { fg = "#DCDCAA" })
	set_hl(0, "Identifier", { fg = "#9CDCFE" })
	set_hl(0, "Type", { fg = "#4EC9B0" })
	set_hl(0, "String", { fg = "#CE9178" })
	set_hl(0, "Number", { fg = "#B5CEA8" })

	-- Tree-sitter groups (C++ heavily uses these)
	set_hl(0, "@keyword", { link = "Keyword" })
	set_hl(0, "@keyword.function", { link = "Keyword" })
	set_hl(0, "@function", { link = "Function" })
	set_hl(0, "@function.call", { link = "Function" })
	set_hl(0, "@function.builtin", { link = "Function" })
	set_hl(0, "@type", { link = "Type" })
	set_hl(0, "@type.builtin", { fg = "#569CD6" }) -- keep your tweak
	set_hl(0, "@variable", { link = "Identifier" })
	set_hl(0, "@variable.builtin", { fg = "#9CDCFE" })
	set_hl(0, "@constant", { fg = "#4FC1FF" })
	set_hl(0, "@number", { link = "Number" })
	set_hl(0, "@string", { link = "String" })
	set_hl(0, "@string.escape", { fg = "#D7BA7D" })

	-- Comments (your VS green)
	set_hl(0, "Comment", { fg = "#57a548" })
	set_hl(0, "@comment", { link = "Comment" })

	-- Optional: subtle current line / cursorline like in your screenshot
	set_hl(0, "CursorLine", { bg = "#2A2A2A" })
	set_hl(0, "CursorLineNr", { fg = "#D4D4D4" })
end

return M

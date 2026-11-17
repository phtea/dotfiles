vim.cmd[[colorscheme vscode]]

local function set_custom_highlights()
	vim.api.nvim_set_hl(0, "Pmenu", { link = "ModeMsg" })
	vim.api.nvim_set_hl(0, "netrwMarkFile", { link = "MatchParen" })
	vim.api.nvim_set_hl(0, "ModeMsg", { link = "Normal" })
	vim.api.nvim_set_hl(0, "PmenuBorder", { fg = "#808080", bg = "#1e1e1e" })

	-- For visimatch.nvim plugin
	vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#113d6f" })
	vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "LspReferenceText" })
	vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "LspReferenceText" })
	vim.api.nvim_set_hl(0, "LspReferenceTarget", { link = "LspReferenceText" })
	vim.api.nvim_set_hl(0, "Visimatch", { bg = "#373737" })

	-- Snacks picker colors
	vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#4085C9", bg = "NONE", })
	vim.api.nvim_set_hl(0, "SnacksPickerMatch", { fg = "#75BEFF", bold = true, })
	vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", { bg = "#282828" })

	-- Keep changed lines distinct from additions and deleted-line fillers.
	vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#2d5037" })
	vim.api.nvim_set_hl(0, "DiffChange", { bg = "#2d4663" })
	vim.api.nvim_set_hl(0, "DiffText", { fg = "#ffffff", bg = "#806638", bold = true })
	vim.api.nvim_set_hl(0, "DiffTextAdd", { bg = "#416b45", bold = true })
	vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#b08080", bg = "#503236" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("CustomDiffHighlights", { clear = true }),
	callback = set_custom_highlights,
})
set_custom_highlights()

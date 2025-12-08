vim.pack.add({ "https://github.com/Mofiqul/vscode.nvim", })

require("vscode").setup({
	color_overrides = {
		vscNone = 'NONE',
		vscFront = '#D4D4D4',
		vscBack = '#1F1F1F',

		vscTabCurrent = '#1F1F1F',
		vscTabOther = '#2D2D2D',
		vscTabOutside = '#252526',

		vscLeftDark = '#252526',
		vscLeftMid = '#373737',
		vscLeftLight = '#636369',

		vscPopupFront = '#BBBBBB',
		vscPopupBack = '#202020',
		vscPopupHighlightBlue = '#04395E',
		vscPopupHighlightGray = '#343B41',

		vscSplitLight = '#898989',
		vscSplitDark = '#444444',
		vscSplitThumb = '#424242',

		vscCursorDarkDark = "#2A2A2A", -- VS (IDE)
		vscCursorDark = '#51504F',
		vscCursorLight = '#AEAFAD',
		vscSelection = '#264F78',
		vscLineNumber = '#5A5A5A',

		vscDiffRedDark = '#4B1818',
		vscDiffRedLight = '#6F1313',
		vscDiffRedLightLight = '#FB0101',
		vscDiffGreenDark = '#373D29',
		vscDiffGreenLight = '#4B5632',
		vscSearchCurrent = '#515c6a',
		vscSearch = '#613315',

		vscGitAdded = '#81b88b',
		vscGitModified = '#e2c08d',
		vscGitDeleted = '#c74e39',
		vscGitRenamed = '#73c991',
		vscGitUntracked = '#73c991',
		vscGitIgnored = '#8c8c8c',
		vscGitStageModified = '#e2c08d',
		vscGitStageDeleted = '#c74e39',
		vscGitConflicting = '#e4676b',
		vscGitSubmodule = '#8db9e2',

		vscContext = '#404040',
		vscContextCurrent = '#707070',

		vscFoldBackground = '#202d39',

		vscSuggestion = '#6A6A6A',

		-- Syntax colors
		vscGray = '#808080',
		vscViolet = '#646695',
		vscBlue = '#569CD6',
		vscAccentBlue = '#4FC1FF',
		vscDarkBlue = '#223E55',
		vscMediumBlue = '#18a2fe',
		vscDisabledBlue = '#729DB3',
		vscLightBlue = '#9CDCFE',
		vscGreen = "#57A548", -- VS (IDE)
		vscBlueGreen = '#4EC9B0',
		vscLightGreen = '#B5CEA8',
		vscRed = '#F44747',
		vscOrange = "#CE9178", -- VS (IDE)
		vscLightRed = '#D16969',
		vscYellowOrange = '#D7BA7D',
		vscYellow = '#DCDCAA',
		vscDarkYellow = '#FFD602',
		vscPink = "#C586C0", -- VS (IDE)

		-- Low contrast with default background
		vscDimHighlight = '#51504F',
	}
})

vim.cmd.colorscheme "vscode"

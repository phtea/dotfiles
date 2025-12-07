vim.pack.add({ "https://github.com/Mofiqul/vscode.nvim", })

require("vscode").setup({
	color_overrides = {
		-- VS (IDE) feel picks (tweak as you like)
		vscGreen = "#57A548",
		vscOrange = "#CE9178",
		vscPink = "#C586C0",
		vscCursorDarkDark = "#2A2A2A",
		-- vscFoldBackground = "#000000" -- literally what it says
	}
})

vim.cmd.colorscheme "vscode"

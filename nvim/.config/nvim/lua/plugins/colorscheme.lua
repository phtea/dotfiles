vim.pack.add({
	"https://github.com/Mofiqul/vscode.nvim",
})

vim.cmd.colorscheme "vscode"
vim.api.nvim_set_hl(0, "Pmenu", { link = "ModeMsg" })
vim.api.nvim_set_hl(0, "netrwMarkFile", { link="MatchParen" })

vim.pack.add({
	"https://github.com/Mofiqul/vscode.nvim",
})

local function override_vscode()
	vim.api.nvim_set_hl(0, "ModeMsg", { link = "Normal" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("MyColors", { clear = true }),
	callback = function(args)
		local colorscheme = args.match
		if colorscheme == "vscode" then
			override_vscode()
		end
	end,
})

vim.cmd.colorscheme "vscode"

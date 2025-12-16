vim.pack.add({ "https://github.com/Mofiqul/vscode.nvim", })

local function override_vscode()
	vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#113d6f" })
	vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "LspReferenceText" })
	vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "LspReferenceText" })
	vim.api.nvim_set_hl(0, "LspReferenceTarget", { link = "LspReferenceText" })
	vim.api.nvim_set_hl(0, "Visimatch", { bg = "#373737" })

	vim.api.nvim_set_hl(0, "StatusLine", { link = "Normal" })
	vim.api.nvim_set_hl(0, "StatusLineNC", { link = "Normal" })
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

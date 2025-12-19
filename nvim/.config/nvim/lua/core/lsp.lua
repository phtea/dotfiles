-- Autoformat with LSP, toggle with <leader>tf (default: OFF)

vim.g.autoformat_enabled = false

-- Toggle autoformat
vim.keymap.set("n", "<leader>tf", function()
	vim.g.autoformat_enabled = not vim.g.autoformat_enabled
	if vim.g.autoformat_enabled then
		vim.notify("Autoformat: ON")
	else
		vim.notify("Autoformat: OFF")
	end
end, { desc = "Toggle format-on-save (LSP)" })

-- format-on-save when enabled
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		if vim.g.autoformat_enabled then
			vim.cmd("Fmt")
		end
	end,
})

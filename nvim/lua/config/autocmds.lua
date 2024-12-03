-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

--  Cd into dir that was just opened
vim.api.nvim_create_autocmd("VimEnter", {
	desc = "Cd into dir that was just opened",
	callback = function()
		local arg = vim.fn.argv(0)
		if arg and vim.loop.fs_stat(arg) and vim.loop.fs_stat(arg).type == "directory" then
			vim.cmd("cd " .. arg)
			print("Changed directory to: " .. arg)
		end
	end,
})

local M = {}

M.copy_relative_path = function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end

-- Toggle diagnostics
M.toggle_diagnostics = function()
	local enabled = not vim.diagnostic.is_enabled()
	vim.diagnostic.enable(enabled)
	print("Diagnostics: " .. (enabled and "ON" or "OFF"))
end

return M

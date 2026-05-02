local M = {}

-- Copy paths
local function copy_to_clipboard(path)
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end

M.copy_relative_path = function()
	local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
	copy_to_clipboard(path)
end

M.copy_absolute_path = function()
	copy_to_clipboard(vim.fn.expand("%:p"))
end

M.copy_filename = function()
	copy_to_clipboard(vim.fn.expand("%:t"))
end

M.copy_directory = function()
	copy_to_clipboard(vim.fn.expand("%:p:h"))
end

-- Toggle diagnostics
M.toggle_diagnostics = function()
	local enabled = not vim.diagnostic.is_enabled()
	vim.diagnostic.enable(enabled)
	print("Diagnostics: " .. (enabled and "ON" or "OFF"))
end

return M

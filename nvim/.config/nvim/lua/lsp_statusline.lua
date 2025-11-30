local M = {}

function M.get_lsp()
	local buf_clients = vim.lsp.get_clients()
	if next(buf_clients) == nil then
		return "" -- No LSP attached
	end

	-- Collect client names
	local names = {}
	for _, client in pairs(buf_clients) do
		table.insert(names, client.name)
	end

	return " " .. table.concat(names, ",") .. " "
end

return M

function _G.statusline_filename()
  -- full path to current buffer
  local fname = vim.api.nvim_buf_get_name(0)
  if fname == "" then
    return "[No Name]"
  end

  -- make it relative to cwd (like `realpath --relative-to` style)
  local rel = vim.fn.fnamemodify(fname, ':.')  -- :.(dot) = relative to cwd
  return rel
end

function _G.get_git_branch()
	local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
	if not handle then return '' end
	local result = handle:read("*a")
	handle:close()
	result = result:gsub("%s+", "")
	return result ~= "" and result .. " " or ""
end

function _G.get_current_lsp_names()
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

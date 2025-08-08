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

  -- Add a nice icon before the names
  local icon = " " -- nf-fa-cog
  return icon .. table.concat(names, ",")
end

return M

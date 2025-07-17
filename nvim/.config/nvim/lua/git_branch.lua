local M = {}

function M.get_branch()
  local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
  if not handle then return '' end
  local result = handle:read("*a")
  handle:close()
  result = result:gsub("%s+", "")
  return result ~= "" and result .. " | " or ""
end

return M

-- Directory that contains this file and all plugin config files
local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"

-- Auto load plugins settings
for _, file in ipairs(vim.fn.readdir(plugin_dir)) do
  -- Only *.lua and skip this init.lua itself
  if file:match("%.lua$") and file ~= "init.lua" then
    local mod_name = file:gsub("%.lua$", "")
    local ok, err = pcall(require, "plugins." .. mod_name)
    if not ok then
      vim.notify(
        "Error loading plugin config: " .. mod_name .. "\n" .. err,
        vim.log.levels.ERROR
      )
    end
  end
end

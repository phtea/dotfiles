local uv = vim.loop

local flag = vim.fn.stdpath("state") .. "/nvim-reload.flag"

-- Ensure the parent directory exists (normally it does)
vim.fn.mkdir(vim.fn.fnamemodify(flag, ":h"), "p")

-- Ensure the flag file exists BEFORE we start watching it
if vim.fn.filereadable(flag) == 0 then
  local fd = io.open(flag, "w") -- create empty file
  if fd then fd:close() end
end

-- Create the watcher safely
local fsevent = uv.new_fs_event()
if not fsevent then
  vim.notify("Failed to create fs_event watcher", vim.log.levels.ERROR)
  return
end

fsevent:start(flag, {}, vim.schedule_wrap(function()
  vim.notify("Config changed — please reload your config", vim.log.levels.WARN)
end))

vim.api.nvim_create_user_command("BroadcastChanges", function()
	os.execute("touch " .. flag)
  vim.notify("Broadcast sent to all Neovim instances", vim.log.levels.INFO)
end, {})

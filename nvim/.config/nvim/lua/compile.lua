local state_dir = vim.fn.stdpath("state")
local compile_file = state_dir .. "/compile_commands.json"

local function load_commands()
  local f = io.open(compile_file, "r")
  if not f then
    return {}
  end

  local content = f:read("*a")
  f:close()

  if content == "" then
    return {}
  end

  local ok, data = pcall(vim.json.decode, content)
  if not ok or type(data) ~= "table" then
    return {}
  end

  return data
end

local function save_commands(cmds)
  vim.fn.mkdir(state_dir, "p")

  local f, err = io.open(compile_file, "w")
  if not f then
    vim.notify("Failed to write compile commands: " .. tostring(err), vim.log.levels.ERROR)
    return
  end

  f:write(vim.json.encode(cmds))
  f:close()
end

vim.api.nvim_create_user_command("Compile", function()
  -- robust cwd
  local cwd = vim.loop.cwd() or vim.fn.getcwd()
  if not cwd or cwd == "" then
    vim.notify("No current working directory", vim.log.levels.ERROR)
    return
  end

  local commands = load_commands()
  local prev = commands[cwd] or ""

  vim.ui.input({
    prompt = "Compile command: ",
    default = prev,          -- empty if none for this cwd yet
    completion = "shellcmd", -- bash-ish completion
  }, function(input)
    -- user aborted with <Esc> or closed the prompt
    if input == nil then
      return
    end

    -- user confirmed but left it empty → do nothing (don’t save, don’t run)
    if input == "" then
      return
    end

    local cmd = input

    commands[cwd] = cmd
    save_commands(commands)

    -- run as shell command
    vim.cmd("!" .. cmd)
  end)
end, {
  nargs = 0,
  desc = "Compile (per cwd) using a stored shell command",
})

local state_dir = vim.fn.stdpath("state")
local execute_file = state_dir .. "/execute_commands.json"

local function load_commands()
  local f = io.open(execute_file, "r")
  if not f then return {} end
  local content = f:read("*a")
  f:close()
  if content == "" then return {} end
  local ok, data = pcall(vim.json.decode, content)
  if not ok or type(data) ~= "table" then return {} end
  return data
end

local function save_commands(cmds)
  vim.fn.mkdir(state_dir, "p")
  local f, err = io.open(execute_file, "w")
  if not f then
    vim.notify("Failed to write execute commands: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  f:write(vim.json.encode(cmds))
  f:close()
end

local function open_terminal_run(cmd)
  -- open a split for terminal
  vim.cmd("botright split")
  vim.cmd("resize 12")
  local win = vim.api.nvim_get_current_win()

  -- create terminal buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)

  -- run under user's shell for "&& |" etc
  local shell = vim.o.shell
  local shellcmdflag = vim.o.shellcmdflag
  vim.fn.termopen({ shell, shellcmdflag, cmd }, {
    on_exit = function() end, -- TermClose handles UI cleanup
  })

  vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("Execute", function()
  local cwd = vim.uv.cwd() or vim.fn.getcwd()
  if not cwd or cwd == "" then
    vim.notify("No current working directory", vim.log.levels.ERROR)
    return
  end

  local commands = load_commands()
  local prev = commands[cwd] or ""

  vim.ui.input({
    prompt = "Execute command: ",
    default = prev,
    completion = "shellcmdline",
  }, function(input)
    if input == nil or input == "" then return end

    commands[cwd] = input
    save_commands(commands)

    open_terminal_run(input)
  end)
end, { nargs = 0, desc = "Execute (per cwd) using a stored shell command in a terminal" })

vim.keymap.set("n", "<leader>x", "<CMD>Execute<CR>", { desc = "Execute code" })

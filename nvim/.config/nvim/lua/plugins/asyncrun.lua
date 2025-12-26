-- load asyncrun plugin (packer-style)
vim.pack.add({ "https://github.com/skywind3000/asyncrun.vim" })

vim.cmd [[
	let g:asyncrun_open = 10
]]

-- Some porcelain above it
local M = {}

-- path to save JSON
local save_file = vim.fn.stdpath("data") .. "/asyncrun_commands.json"

-- load saved commands from disk
local function load_commands()
  local f = io.open(save_file, "r")
  if not f then return {} end
  local content = f:read("*a")
  f:close()
  local ok, tbl = pcall(vim.fn.json_decode, content)
  if ok and type(tbl) == "table" then
    return tbl
  else
    return {}
  end
end

-- save commands table to disk
local function save_commands(tbl)
  local f = io.open(save_file, "w")
  if not f then return end
  f:write(vim.fn.json_encode(tbl))
  f:close()
end

-- get cwd key
local function cwd()
  return vim.fn.getcwd()
end

-- prompt user for command, save, and run
function M.prompt()
  local commands = load_commands()
  local default = commands[cwd()] or ""
  vim.ui.input({ prompt = ":AsyncRun ", default = default, completion = "command" }, function(input)
    if not input or input == "" then
      print("Cancelled")
      return
    end

    commands[cwd()] = input
    save_commands(commands)

    vim.cmd("AsyncRun " .. input)
  end)
end

-- run saved command for current cwd
function M.run_saved()
  local commands = load_commands()
  local cmd = commands[cwd()]
  if not cmd or cmd == "" then
    print("No saved command for this directory")
    return
  end
  vim.cmd("AsyncRun " .. cmd)
end

-- keymaps (local to this file)
vim.keymap.set("n", "`<Space>", M.prompt, { noremap = true, silent = true })
vim.keymap.set("n", "`<CR>", M.run_saved, { noremap = true, silent = true })

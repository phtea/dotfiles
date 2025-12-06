vim.api.nvim_create_user_command("Make", function(opts)
  local args = opts.args or ""
  if args ~= "" then
    vim.o.makeprg = args -- raw shell command; supports && | redirects
  end
  vim.cmd("make")
end, {
  nargs = "*",
  complete = "shellcmd",
  desc = "Set makeprg (raw shell cmd) then run :make",
})

local function last_make_from_history()
  local n = vim.fn.histnr("cmd")
  for i = n, 1, -1 do
    local h = vim.fn.histget("cmd", i)
    -- history lines look like "Make ..." (without the leading ':')
    local args = h:match("^Make%s+(.+)$")
    if args and args ~= "" then
      return args
    end
  end
  return ""
end

vim.keymap.set("n", "<leader>m", function()
  local last = last_make_from_history()
  local cmd = ":Make" .. (last ~= "" and (" " .. last) or " ")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "n", false)
end, { desc = "Make wrapper (prefill from cmdline history)" })

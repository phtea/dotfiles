-- Load the module
local highlight = require('custom_code.highlight')

-- Add keymaps (optional but convenient)
vim.keymap.set('n', '<leader>mm', function()
  local pattern = vim.fn.input('Pattern to highlight: ')
  if pattern ~= "" then
    highlight.match(pattern)
  end
end)

vim.keymap.set('v', '<leader>m', function()
  vim.cmd('normal! "xy')
  local selected = vim.fn.getreg('x')

  if selected == "" then return end

  selected = selected:gsub('\n$', '')

  if selected == "" then return end

  highlight.match('\\V' .. selected:gsub('\\', '\\\\'))
end)

vim.keymap.set('n', '<leader>mc', highlight.clear_matches)
vim.keymap.set('n', '<leader>ml', highlight.list_matches)

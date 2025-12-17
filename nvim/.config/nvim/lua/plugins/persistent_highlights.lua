-- Load the module
local highlight = require('custom_code.persistent_highlight')
-- highlight.setup({
--   color_groups = {
--     { name = "PH1", bg = "#222244", bold = true },
--     { name = "PH2", fg = "#224422", underline = true },
--   }
-- })

-- Add keymaps (optional but convenient)
vim.keymap.set('n', '<leader>mm', function()
  local pattern = vim.fn.input('Pattern to highlight: ')
  if pattern ~= "" then
    highlight.match(pattern)
  end
end)

vim.keymap.set("n", "<leader>mw", highlight.highlight_word)

vim.keymap.set('v', '<leader>m', highlight.highlight_selection)

vim.keymap.set('n', '<leader>mc', highlight.clear_matches)
vim.keymap.set('n', '<leader>ml', highlight.list_matches)

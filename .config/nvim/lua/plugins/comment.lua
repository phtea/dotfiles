-- comment.lua

require('Comment').setup {
    -- Optional: Customize settings if needed
}

-- Normal mode: Toggle comment for the current line
vim.api.nvim_set_keymap('n', '<C-_>', '<Plug>(comment_toggle_linewise_current)', { silent = true })

-- Visual mode: Toggle comment for the selected block
vim.api.nvim_set_keymap('x', '<C-_>', '<Plug>(comment_toggle_linewise_visual)', { silent = true })


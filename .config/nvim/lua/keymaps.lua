-- Options
local opts = { noremap = true, silent = true }

local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    local opts = { noremap = true, silent = true, desc = desc }
    vim.api.nvim_set_keymap(mode, keys, func, opts)
end

-- Clear search highlights
map("<Esc>", ":nohlsearch<CR>", "Clear search highlights")
map("<leader>ex", ":Ex<CR>", "Open [Ex]plorer")
map("<leader>ac", ':%y+<CR>', "Copy all to system register")

-- Map <C-c> to copy the selected text to the clipboard in visual mode
vim.api.nvim_set_keymap("v", "<C-c>", '"+y', opts)

-- Create an autocommand group for Go-specific settings
vim.api.nvim_create_augroup("GoFileMappings", { clear = true })

-- Set the keymap only for Go files
vim.api.nvim_create_autocmd("FileType", {
    group = "GoFileMappings",
    pattern = "go",
    callback = function()
        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>d", ':w<CR>:!go run main.go<CR>', opts)
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>er", 'oif err != nil {<CR>}<Esc>O<Esc>', opts)
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>pr", 'yiwofmt.Printf("<Esc>pa: %v\\n", <Esc>pa)<Esc>', opts)
    end,
})


-- keymaps.lua

-- Leader key is space
vim.g.mapleader = " "

-- Options
local opts = { noremap = true, silent = true }

-- Clear search highlights
vim.api.nvim_set_keymap("n", "<Esc>", ":nohlsearch<CR>", opts)

-- Better window navigation
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", opts)
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", opts)
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", opts)
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", opts)

-- Map <leader>e to open explorer
vim.api.nvim_set_keymap("n", "<leader>ex", ":Ex<CR>", opts)

-- Map <leader>ac to copy all to system register
vim.api.nvim_set_keymap("n", "<leader>ac", ':%y+<CR>', opts)

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

-- Generic function for mark navigation and centering
local function mark_and_center(mark_type)
  return function()
    return mark_type .. vim.fn.getcharstr() .. "zz"
  end
end

-- Map for exact position of marks (`` ` ``)
vim.keymap.set('n', "`", mark_and_center("`"), { expr = true, desc = "Go to mark and center" })

-- Map for line of marks (`'`)
vim.keymap.set('n', "'", mark_and_center("'"), { expr = true, desc = "Go to line of mark and center" })

-- Center the screen when <C-d> and <C-u>
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", opts)
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", opts)

-- Map <C-c> to copy the selected text to the clipboard in visual mode
vim.api.nvim_set_keymap("v", "<C-c>", '"+y', opts)

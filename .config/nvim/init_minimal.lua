-- phtea's minimal init.lua

-- General LSP configuration function
local function setup_lsp(server_name, server_cmd, filetypes)
    -- Autostart LSP for specified filetypes
    vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function()
            vim.lsp.start({
                name = server_name,
                cmd = server_cmd,
                root_dir = vim.fn.getcwd(), -- Use current project directory
            })
        end,
    })
end

-- Example: Go LSP (gopls)
setup_lsp("gopls", { "gopls" }, { "go" })

-- Example: Python LSP (pyright)
setup_lsp("pyright", { "pyright-langserver", "--stdio" }, { "python" })

-- Set relative numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Set leader key
vim.g.mapleader = " "

-- Common LSP keybindings
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "Find References" })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename Symbol" })

-- Diagnostics configuration
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
})

-- Clipboard setup (specific to WSL)
vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
        ['+'] = '/mnt/c/Windows/System32/clip.exe',
        ['*'] = '/mnt/c/Windows/System32/clip.exe',
    },
    paste = {
        ['+'] =
        '/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        ['*'] =
        '/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
}

-- Set the colorscheme to 'slate'
vim.cmd("colorscheme slate")


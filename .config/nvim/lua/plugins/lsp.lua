-- lsp.lua

-- Ensure required modules are loaded
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local cmp = require('cmp') -- nvim cap
local luasnip = require("luasnip")  -- Load LuaSnip

-- nvim-cmp setup
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)  -- Use LuaSnip for snippets
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },  -- Optional, if you're using LuaSnip
    },
})

-- Define capabilities for LSP (used for autocompletion)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Reusable `on_attach` function for keybindings
local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true }

    -- Key mappings
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<F12>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)

    -- Diagnostics navigation
    vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

    -- Show diagnostics in floating window
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
end

-- Automatically close Quickfix List after jumping to an item
vim.cmd([[
  augroup AutoCloseQuickfix
    autocmd!
    autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>
  augroup END
]])


-- Configure LSP servers
local servers = { "pyright", "gopls", } -- Add other servers as needed

for _, server in ipairs(servers) do
    lspconfig[server].setup({
        capabilities = capabilities,
        on_attach = on_attach,
    })
end

-- Additional diagnostic settings (optional)
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})



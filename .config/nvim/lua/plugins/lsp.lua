-- lsp.lua

-- Unmap keys for LSP actions in Lua
vim.api.nvim_del_keymap('n', 'gri')
vim.api.nvim_del_keymap('n', 'grr')
vim.api.nvim_del_keymap('n', 'gra')
vim.api.nvim_del_keymap('n', 'grn')


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

local on_attach = function(client, bufnr)

    local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        local opts = { noremap = true, silent = true, desc = 'LSP: ' .. desc }
        vim.api.nvim_buf_set_keymap(bufnr, mode, keys, func, opts)
    end
    
    -- Key mappings
    map("K", "<cmd>lua vim.lsp.buf.hover()<CR>", "Show Documentation")
    map("gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "[G]o [D]efinition")
    -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    map("gr", "<cmd>lua vim.lsp.buf.references()<CR>", "[G]o [R]eferences")
    map("<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", "[R]e[n]ame")

    -- Diagnostics navigation
    map("[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Go To Previous [D]efinition")
    map("]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", "Go To Next [D]efinition")

    -- Autoformat on save
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
            buffer = bufnr,
            callback = function()
                
                -- -- Organize imports (if supported by the LSP)
                -- if client.server_capabilities.codeActionProvider then
                --     vim.lsp.buf.code_action({
                --         context = { only = { "source.organizeImports" } },
                --         apply = true,
                --     })
                -- end

                -- Format the document
                vim.lsp.buf.format({ async = false })
            end,
        })
    end
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



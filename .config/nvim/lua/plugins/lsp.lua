-- plugins/lsp.lua
local M = {}

function M.setup(use)
    -- Add your LSP-related plugins here using `use`
    use 'neovim/nvim-lspconfig'  -- LSP configurations
    use 'hrsh7th/cmp-nvim-lsp'   -- LSP completion source for nvim-cmp
    use 'hrsh7th/nvim-cmp'       -- Completion plugin
    use { 'L3MON4D3/LuaSnip', run = "make install_jsregexp" } -- Snippet plugin

    -- Ensure required modules are loaded
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local cmp = require('cmp')
    local luasnip = require("luasnip")

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
            vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        -- Key mappings
        map("K", vim.lsp.buf.hover, "Show Documentation")
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map("gr", require('telescope.builtin').lsp_references, "[G]o [R]eferences")
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

        -- Diagnostics navigation
        map("[d", vim.diagnostic.goto_prev, "Go To Previous [D]iagnostic")
        map("]d", vim.diagnostic.goto_next, "Go To Next [D]iagnostic")

        -- Autoformat on save
        if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end
    end

    -- Configure LSP servers
    local servers = { "pyright", "gopls" } -- Add other servers as needed
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
end

return M


return {
    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local capabilities = cmp_nvim_lsp.default_capabilities()

            local lspconfig = require("lspconfig")
            lspconfig.gopls.setup({
                capabilities = capabilities,
            })
            lspconfig.pyright.setup({ capabilities = capabilities })
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
                capabilities = capabilities,
            })

            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
            })

            -- Key mappings for LSP
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions", silent = true })
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol", silent = true })
        end,
    }
}


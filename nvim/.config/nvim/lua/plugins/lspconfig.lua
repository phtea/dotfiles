vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

vim.lsp.enable({ "pyright", "solargraph", "clangd", "lua_ls", "gopls", "rust_analyzer" })

vim.diagnostic.config({})
vim.diagnostic.enable(false) -- disabled by default

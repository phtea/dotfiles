vim.lsp.enable({
	"pyright", "solargraph", "clangd",
	"lua_ls", "gopls", "rust_analyzer",
	"arduino_language_server", "zls",
})

vim.diagnostic.enable(false) -- disabled by default

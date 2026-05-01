vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

vim.lsp.enable({
	"pyright",
	"solargraph",
	"clangd",
	"lua_ls",
	"gopls",
	"rust_analyzer",
	"arduino_language_server",
})

vim.lsp.config('arduino_language_server', {
  cmd = {
    "arduino-language-server",
    "-cli-config", "/home/phtea/.arduino15/arduino-cli.yaml",
    "-fqbn", "arduino:avr:uno",
  }
})

vim.diagnostic.config({})
vim.diagnostic.enable(false) -- disabled by default

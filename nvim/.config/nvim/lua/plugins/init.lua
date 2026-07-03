-- Add plugins
vim.pack.add({
	"https://github.com/folke/snacks.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/azabiong/vim-highlighter",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/Mofiqul/vscode.nvim",
	"https://github.com/phtea/arduino.nvim",
})

-- Configure plugins
require("plugins.snacks")          -- Picker
require("plugins.gitsigns")        -- Git Signs
require("plugins.treesitter")      -- Syntax highlighting
require("plugins.vim-highlighter") -- Permanently highlight selections
require("plugins.lspconfig")       -- Lsp
require("plugins.oil")             -- File management
require("plugins.colorscheme")     -- Colorscheme
require("plugins.arduino")         -- My arduino development plugin

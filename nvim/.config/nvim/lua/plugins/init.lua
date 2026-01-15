-- Picker + Lazygit Interface. Should go first
require("plugins.snacks")

-- Brackets
require("plugins.autopairs")
require("plugins.surround")

-- Git Signs
require("plugins.gitsigns")

-- M-x compile but nvim
require("plugins.asyncrun")

-- Pick and run project-specific tasks
require("plugins.simple_tasks")

-- Highlight plugins
require("plugins.treesitter")     -- Syntax highlighting
require("plugins.visimatch")      -- Highlight selection
require("plugins.vim-highligher") -- Permanently highlight selections

-- Lsp
require("plugins.lspconfig")

-- File management
require("plugins.oil")

-- Autocomplete
require("plugins.blink_cmp")

-- Should go last
require("plugins.colorscheme")

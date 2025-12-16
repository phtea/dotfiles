-- Should go first, some plugins depend on it
require("plugins.snacks")

-- Brackets
require("plugins.autopairs")
require("plugins.surround")

-- Git signs on the left
require("plugins.gitsigns")

-- M-x compile but nvim
require("plugins.vim-dispatch")

-- Highlight plugins
require("plugins.visimatch") -- Highlight selection
require("plugins.local-highlight") -- Highlight current word

-- Syntax highlighting
require("plugins.treesitter")

-- Navigation
require("plugins.lsp")
require("plugins.quicker")

-- File management
require("plugins.oil")

-- Autocomplete
require("plugins.blink_cmp")

-- Should go last
require("plugins.langmapper")
require("plugins.colorscheme")

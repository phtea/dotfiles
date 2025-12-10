-- Should go first, some plugins depend on it
require("plugins.snacks")

-- Quality of life plugins
require("plugins.autopairs")
require("plugins.surround")
require("plugins.gitsigns")
require("plugins.vim-dispatch")
require("plugins.visimatch")

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

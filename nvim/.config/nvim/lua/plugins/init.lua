-- Should go first, some plugins depend on it
require("plugins.snacks")

-- Brackets
require("plugins.autopairs")
require("plugins.gitsigns")

-- Syntax highlighting
require("plugins.treesitter")

-- Navigation
require("plugins.lsp")
require("plugins.quicker")

-- File management
require("plugins.oil")

-- Autocomplete
require("plugins.blink_cmp")

-- Should go last (so nothing else overrides user-defined highlights)
require("plugins.colorscheme")

-- Langmapper
require("plugins.langmapper")

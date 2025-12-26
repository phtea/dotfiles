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
require("plugins.treesitter")     -- Syntax highlighting
require("plugins.visimatch")      -- Highlight selection
require("plugins.vim-highligher") -- Permanently highlight selections
require("plugins.multicursor") -- Multicursor plugin (I hope nvim soon has native one so I can get rid of current one but for now I'll stick to it cuz it's more intuitive than :s or :g or cgn the list goes on)

-- Navigation
require("plugins.lsp")

-- File management
require("plugins.oil")

-- Autocomplete
require("plugins.blink_cmp")

-- Should go last
require("plugins.colorscheme")

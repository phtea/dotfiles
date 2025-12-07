-- Should go first, some plugins depend on it
require("plugins.snacks")

require("plugins.autopairs")
require("plugins.gitsigns")
require("plugins.local-highlight")
require("plugins.lsp")
require("plugins.oil")
require("plugins.quicker")
require("plugins.surround")
require("plugins.treesitter")

-- Should go last (so nothing else overrides user-defined highlights)
require("plugins.colorscheme")

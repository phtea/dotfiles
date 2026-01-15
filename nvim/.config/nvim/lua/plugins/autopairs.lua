vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })

local nap = require("nvim-autopairs")

nap.setup({})
nap.remove_rule('`') -- remove rule `

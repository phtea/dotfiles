-- nvim config for nvim 0.12+ (hyped for release 😃)
package.path = vim.fn.stdpath("config") .. "/?.lua;" .. package.path -- Enable local Lua modules

require("core.mappings")
require("core.options")
require("core.lsp")
require("core.plugins")

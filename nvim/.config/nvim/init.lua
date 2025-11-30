-- nvim config for nvim 0.12+ (hyped for release 😃)
package.path = vim.fn.stdpath("config") .. "/?.lua;" .. package.path -- Enable local Lua modules

require("options")
require("remap")
require("autocmds")

require("plugins")

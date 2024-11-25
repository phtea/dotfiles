vim.g.mapleader = " "       -- Leader key is space

require("settings")         -- Load core settings
require("keymaps")          -- Load keymaps
require('packer-bootstrap') -- Bootstrap Packer
require('packer-plugins')   -- Load plugins configuration

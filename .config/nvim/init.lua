-- Leader key is space
vim.g.mapleader = " "

-- Bootstrap Packer
require('packer-bootstrap')

-- Load plugins configuration
require('packer-plugins')

-- Load core settings
require("settings")

-- Load keymaps
require("keymaps")

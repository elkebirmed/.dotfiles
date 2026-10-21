local g = vim.g

-- Leader (must be set before any plugin is loaded)
g.mapleader = " "
g.maplocalleader = " "

require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")

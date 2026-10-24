-- Leader (must be set before any plugin is loaded)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("nixCatsUtils").setup({non_nix_value = true})

require("config.options")
require("config.filetypes")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")

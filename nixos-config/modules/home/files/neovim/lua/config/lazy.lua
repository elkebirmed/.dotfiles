-- ---------------------------------------------------------------------------
-- lazy.nvim setup through the nixCats wrapper
-- ---------------------------------------------------------------------------
-- nixCats installs lazy.nvim and every plugin in the Nix store. The wrapper
-- teaches lazy.nvim to use those paths instead of downloading repositories.
require("nixCatsUtils.lazyCat").setup(
    nixCats.pawsible({"allPlugins", "start", "lazy.nvim"}),
    {
        spec = {
            {import = "plugins"},
        },
        install = {colorscheme = {"habamax"}},
        checker = {enabled = false, notify = false},
    }
)

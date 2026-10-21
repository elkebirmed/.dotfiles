return {
    "RRethy/base16-nvim",
    lazy = false,
    priority = 1000,
    config = function()
        -- Default colorscheme, overridden by matugen/Noctalia if available.
        -- Noctalia renders lua/matugen.lua from its palette template at
        -- runtime; the stub in roles/neovim/files/matugen.lua keeps this
        -- working before the first render.
        vim.cmd.colorscheme("default")

        local ok, matugen = pcall(require, "matugen")
        if ok then
            matugen.setup()
        end
    end,
}

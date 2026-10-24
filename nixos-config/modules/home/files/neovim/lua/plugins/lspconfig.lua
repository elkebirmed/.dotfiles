-- ===========================================================================
-- LSP configuration
-- https://github.com/neovim/nvim-lspconfig
-- ===========================================================================

return {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    lazy = false,
    config = function()
        vim.lsp.config("*", {
            capabilities = require("blink.cmp").get_lsp_capabilities(),
        })

        local servers = require("config.lsp-servers")

        -- Per-server tweaks, merged on top of the nvim-lspconfig defaults.
        for name, config in pairs(servers.overrides) do
            vim.lsp.config(name, config)
        end

        for _, server in ipairs(servers.all) do
            vim.lsp.enable(server)
        end
    end,
}

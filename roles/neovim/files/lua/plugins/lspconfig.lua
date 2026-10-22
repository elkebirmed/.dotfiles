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

        local servers = {
            "bashls",
            "gopls",
            "jsonls",
            "lua_ls",
            "marksman",
            "pyright",
            "rust_analyzer",
            "taplo",
            "vtsls",
            "yamlls",
        }
        for _, server in ipairs(servers) do
            vim.lsp.enable(server)
        end
    end,
}

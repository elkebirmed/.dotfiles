return {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    lazy = false,
    keys = {
        { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
        { "gr", vim.lsp.buf.references, desc = "References" },
        { "K", vim.lsp.buf.hover, desc = "Hover documentation" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
        { "<leader>cr", vim.lsp.buf.rename, desc = "Rename symbol" },
        { "<leader>cd", vim.diagnostic.open_float, desc = "Show line diagnostics" },
    },
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

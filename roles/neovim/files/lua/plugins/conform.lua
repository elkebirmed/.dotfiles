return {
    "stevearc/conform.nvim",
    lazy = false,
    keys = {
        { "<leader>cf", function()
            require("conform").format({ async = false, lsp_fallback = true })
        end, desc = "Format buffer" },
    },
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff_format", "ruff" },
            go = { "gofmt", "goimports" },
            rust = { "rustfmt" },
            javascript = { "prettier" },
            javascriptreact = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            toml = { "taplo" },
            sh = { "shfmt" },
            fish = { "fish_indent" },
        },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
}

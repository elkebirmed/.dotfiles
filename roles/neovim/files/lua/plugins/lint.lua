return {
    "mfussenegger/nvim-lint",
    lazy = false,
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            lua = { "luacheck" },
            python = { "ruff" },
            go = { "golangci_lint" },
            javascript = { "eslint" },
            javascriptreact = { "eslint" },
            typescript = { "eslint" },
            typescriptreact = { "eslint" },
            sh = { "shellcheck" },
            markdown = { "markdownlint" },
            toml = { "taplo" },
            yaml = { "yamllint" },
        }
    end,
}

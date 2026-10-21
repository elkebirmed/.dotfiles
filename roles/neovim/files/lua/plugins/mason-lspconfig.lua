return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    lazy = false,
    opts = {
        ensure_installed = {
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
        },
    },
}

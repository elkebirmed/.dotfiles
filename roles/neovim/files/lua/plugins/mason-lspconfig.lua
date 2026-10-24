return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    lazy = false,
    opts = {
        ensure_installed = require("config.lsp-servers").mason,
    },
    config = function(_, opts)
        require("mason-lspconfig").setup(opts)

        -- Packages that cannot be requested through `ensure_installed` because
        -- the server name maps to more than one package (see
        -- config/lsp-servers.lua).
        local registry = require("mason-registry")
        for _, package in pairs(require("config.lsp-servers").pinned) do
            if registry.has_package(package) then
                local pkg = registry.get_package(package)
                if not pkg:is_installed() then
                    pkg:install()
                end
            end
        end
    end,
}

-- ===========================================================================
-- Language servers
-- ===========================================================================
-- Single source of truth for the language servers Neovim drives.
--
-- Every server is installed by nixCats (see the Neovim Home-Manager feature).
-- plugins/lspconfig.lua enables every server listed here.

local M = {}

M.all = {
    "bashls",
    "codebook",
    "css_variables",
    "docker_language_server",
    "emmet_ls",
    "eslint",
    "fish_lsp",
    "gopls",
    "graphql",
    "harper_ls",
    "helm_ls",
    "html",
    "htmx",
    "intelephense",
    "jqls",
    "jsonls",
    "just",
    "lua_ls",
    "luau_lsp",
    "marksman",
    "nginx_language_server",
    "postgres_lsp",
    "pyright",
    "rust_analyzer",
    -- `sqls` replaces `sqlls`: the npm implementation of the same server
    -- crashes on recent Node versions, the Go one works.
    "sqls",
    "tailwindcss",
    "taplo",
    "terraformls",
    "vtsls",
    "yamlls",
}

-- Per-server configuration merged on top of the nvim-lspconfig defaults.
M.overrides = {
    -- Harper checks prose, Codebook checks code. Keeping them apart avoids
    -- two diagnostics for the same typo in a comment.
    harper_ls = {
        filetypes = {
            "asciidoc",
            "gitcommit",
            "markdown",
            "org",
            "rst",
            "tex",
            "text",
            "typst",
        },
        settings = {
            -- Harper refuses to start without a "harper-ls" object. An empty
            -- table would be encoded as an empty JSON array and rejected, so
            -- the object carries an actual setting.
            ["harper-ls"] = {
                diagnosticSeverity = "hint",
            },
        },
    },
    codebook = {
        filetypes = {
            "c",
            "css",
            "go",
            "haskell",
            "html",
            "java",
            "javascript",
            "javascriptreact",
            "lua",
            "php",
            "python",
            "ruby",
            "rust",
            "swift",
            "toml",
            "typescript",
            "typescriptreact",
            "zig",
        },
    },
}

return M

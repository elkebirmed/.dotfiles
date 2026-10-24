-- ===========================================================================
-- Language servers
-- ===========================================================================
-- Single source of truth for the language servers Neovim drives.
--
-- The list is split by the way every server is installed:
--   mason  -> installed by Mason (see plugins/mason-lspconfig.lua)
--   pinned -> installed by Mason as well, but the package is pinned because
--             the server name maps to more than one package
--   system -> installed from the system repositories (see the neovim role),
--             Mason does not package them
--
-- plugins/lspconfig.lua enables every server listed here, and
-- plugins/mason-lspconfig.lua installs the Mason ones.

local M = {}

-- Servers installed by Mason. The entry is the nvim-lspconfig server name;
-- mason-lspconfig resolves it to the matching Mason package.
M.mason = {
    "ansiblels",
    "bashls",
    "codebook",
    "css_variables",
    "docker_language_server",
    "emmet_ls",
    "eslint",
    "fish_lsp",
    "gh_actions_ls",
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

-- Servers whose Mason package is pinned: the server name maps to more than one
-- package and only one of them ships the binary nvim-lspconfig runs.
M.pinned = {
    -- nvim-lspconfig runs `stylelint-language-server`, which comes from the
    -- official @stylelint/language-server package. The other candidate
    -- (bmatcuk's `stylelint-lsp`) installs a `stylelint-lsp` binary instead.
    stylelint_lsp = "stylelint-language-server",
}

-- Servers that come from the system repositories instead of Mason.
M.system = {
    "kdl_lsp",
}

-- Per-server configuration merged on top of the nvim-lspconfig defaults.
M.overrides = {
    ansiblels = {
        settings = {
            ansible = {
                validation = {
                    -- ansible-lint is not installed here: the server runs its
                    -- own validation instead.
                    lint = { enabled = false },
                },
            },
        },
    },
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

-- Every server Neovim enables.
M.all = {}
vim.list_extend(M.all, M.mason)
vim.list_extend(M.all, vim.tbl_keys(M.pinned))
vim.list_extend(M.all, M.system)

return M

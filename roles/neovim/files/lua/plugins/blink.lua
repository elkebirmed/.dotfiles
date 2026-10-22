-- ===========================================================================
-- Blink.nvim configuration
-- https://github.com/saghen/blink.cmp
-- https://cmp.saghen.dev/
-- ===========================================================================

return {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
        "rafamadriz/friendly-snippets",
        'disrupted/blink-cmp-conventional-commits',
        "moyiz/blink-emoji.nvim",
        "MahanRahmati/blink-nerdfont.nvim",
    },
    lazy = false,
    opts = {
        keymap = {
            preset = "default",
        },

        appearance = {
            nerd_font_variant = "mono", -- icons align on a fixed grid
        },

        completion = {
            trigger = { prefetch_on_insert = false },

            -- Don't insert text while moving through the list. Without this,
            -- browsing long minuet suggestions pastes them into the buffer.
            list = { selection = { preselect = true, auto_insert = false } },

            menu = {
                border = "rounded",
                max_height = 12,
                draw = {
                    treesitter = { "lsp" }, -- syntax-highlight LSP labels
                    columns = {
                        { "kind_icon" },
                        { "label", "label_description", gap = 1 },
                        { "source_name" }, -- LSP / Path / Snippets / Buffer / minuet
                    },
                    components = {
                        -- Let long labels (minuet's full-line suggestions) use more room
                        label = { width = { fill = true, max = 60 } },
                        -- Dedicated icon so AI suggestions stand out from plain text items
                        kind_icon = {
                            text = function(ctx)
                                if ctx.item.source_id == "minuet" then
                                    return "󰚩" .. ctx.icon_gap
                                end
                                return ctx.kind_icon .. ctx.icon_gap
                            end,
                        },
                    },
                },
            },

            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
                window = { border = "rounded", max_width = 80, max_height = 20 },
            },

            ghost_text = { enabled = false }, -- set true for an inline preview of the selected item
        },

        -- Signature help popup while typing arguments (blink's default key: <C-k>)
        signature = {
            enabled = true,
            window = { border = "rounded" },
        },

        -- Completion menu for : commands and / search too
        cmdline = {
            keymap = { preset = "inherit" },
            completion = { menu = { auto_show = true } },
        },

        sources = {
            default = {
                'conventional_commits',
                'lsp',
                'path',
                'snippets',
                'buffer',
                'minuet',
                "emoji",
                "nerdfont",
            },
            providers = {
                minuet = {
                    name = "minuet",
                    module = "minuet.blink",
                    async = true,
                    -- Matches minuet request_timeout (10s) in milliseconds.
                    timeout_ms = 10000,
                    score_offset = 50,
                },
                conventional_commits = {
                    name = 'Conventional Commits',
                    module = 'blink-cmp-conventional-commits',
                    enabled = function()
                        return vim.bo.filetype == 'gitcommit'
                    end,
                    ---@module 'blink-cmp-conventional-commits'
                    ---@type blink-cmp-conventional-commits.Options
                    opts = {
                        -- See Configuration section below for available options
                    },
                },
                emoji = {
                    module = "blink-emoji",
                    name = "Emoji",
                    score_offset = 15, -- Tune by preference
                    opts = {
                        insert = true, -- Insert emoji (default) or complete its name
                        ---@type string|table|fun():table
                        trigger = function()
                            return { ":" }
                        end,
                    },
                },
                nerdfont = {
                    module = "blink-nerdfont",
                    name = "Nerd Fonts",
                    score_offset = 15, -- Tune by preference
                    opts = {
                        insert = true, -- Insert nerdfont icon (default) or complete its name
                        trigger = ":" -- Customize the trigger. Defaults to ":"
                    },
                }

            },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
}
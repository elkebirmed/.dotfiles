return {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    lazy = false,
    opts = {
        keymap = { preset = "default" },
        completion = { trigger = { prefetch_on_insert = false } },
        sources = {
            default = { "lsp", "path", "snippets", "buffer", "minuet" },
            providers = {
                minuet = {
                    name = "minuet",
                    module = "minuet.blink",
                    async = true,
                    -- Matches minuet request_timeout (10s) in milliseconds.
                    timeout_ms = 10000,
                    score_offset = 50,
                },
            },
        },
    },
}

-- AI chat wired to the locally-running OmniRoute (localhost:20128) which
-- proxies OpenCode-compatible model requests via the OpenAI chat-completions
-- API. The API key is read from
-- OMNIROUTE_API_KEY or ~/.omniroute/api-key (created by the omniroute role).
--
-- NOTE: OmniRoute's exact chat contract should be verified against its docs.
-- If the adapter shape changes, only this file needs updating. A failed
-- setup here is non-fatal: Neovim still starts, AI features are just
-- unavailable until it is fixed.

return {
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        cmd = {
            "CodeCompanion",
            "CodeCompanionChat",
            "CodeCompanionActions",
            "CodeCompanionCodeReview",
            "CodeCompanionCmd",
            "CodeCompanionCLI",
        },
        keys = {
            { "<leader>ai", "<cmd>CodeCompanionActions<cr>",     desc = "AI Actions",  mode = { "n", "v" } },
            { "<leader>ac", "<cmd>CodeCompanionChat toggle<cr>", desc = "AI chat",     mode = { "n", "v" } },
            { "<leader>al", "<cmd>CodeCompanion<cr>",            desc = "AI inline",   mode = { "n", "v" } },
            { "<leader>aa", "<cmd>CodeCompanionChat Add<cr>",    desc = "Add tp chat", mode = "v" },
        },
        config = function()
            local ok, codecompanion = pcall(require, "codecompanion")
            if not ok then
                return
            end

            local function omniroute_api_key()
                local key = vim.env.OMNIROUTE_API_KEY
                if key and #key > 0 then
                    return key
                end

                local path = vim.fn.expand("~/.omniroute/api-key")
                local f = io.open(path, "r")
                if f then
                    key = vim.trim(f:read("*a") or "")
                    f:close()
                    if #key > 0 then
                        return key
                    end
                end

                return nil
            end

            codecompanion.setup({
                adapters = {
                    http = {
                        omniroute = function()
                            return require("codecompanion.adapters").extend("openai_compatible", {
                                formatted_name = "OmniRoute",
                                env = {
                                    url = "http://127.0.0.1:20128",
                                    api_key = omniroute_api_key() or "",
                                },
                                schema = {
                                    model = {
                                        default = os.getenv("OMNIROUTE_MODEL"),
                                    },
                                },
                            })
                        end,
                    },
                },
                interactions = {
                    chat = {
                        adapter = "omniroute",
                        tools = {
                            ["web_search"] = {
                                opts = {
                                    adapter = "duckduckgo",
                                },
                            },
                        },
                    },
                    inline = { adapter = "omniroute" },
                    agent = { adapter = "omniroute" },
                },
            })
        end,
    },
}

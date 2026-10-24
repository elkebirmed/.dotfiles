-- AI completion wired to the locally-running OmniRoute (localhost:20128) which
-- proxies OpenAI-compatible chat-completion requests. The API key is read from
-- OMNIROUTE_API_KEY or ~/.omniroute/api-key (created by the OmniRoute activation).

return {
    {
        "milanglacier/minuet-ai.nvim",
        event = "InsertEnter",
        config = function()
            local ok, minuet = pcall(require, "minuet")
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

            minuet.setup({
                provider = "openai_compatible",
                request_timeout = 10,
                throttle = 1000,
                debounce = 400,
                notify = "warn",
                context_window = 16000,
                context_ratio = 0.75,
                add_single_line_entry = true,
                n_completions = 3,
                provider_options = {
                    openai_compatible = {
                        name = "OmniRoute",
                        end_point = "http://127.0.0.1:20128/v1/chat/completions",
                        -- Non-reasoning model: reasoning models spend the token
                        -- budget on hidden reasoning and return null content.
                        model = os.getenv("OMNIROUTE_MODEL") or "openrouter/minimax/minimax-m3.1-flash:free-low",
                        stream = true,
                        api_key = omniroute_api_key,
                        optional = {
                            max_tokens = 256,
                            temperature = 0.7,
                            top_p = 1,
                        },
                    },
                },
            })
        end,
    }
}

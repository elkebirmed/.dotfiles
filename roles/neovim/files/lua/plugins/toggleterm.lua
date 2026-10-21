return {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = false,
    keys = {
        { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
        { "<leader>g", "<cmd>lua _lazygit_toggle()<cr>", desc = "Lazygit" },
    },
    config = function()
        require("toggleterm").setup({
            size = 20,
            open_mapping = [[<c-\>]],
            direction = "float",
            float_opts = { border = "rounded" },
            shade_terminals = true,
        })

        function _lazygit_toggle()
            local Terminal = require("toggleterm.terminal").Terminal
            local lazygit = Terminal:new({
                cmd = "lazygit",
                direction = "float",
                hidden = true,
            })
            lazygit:toggle()
        end
    end,
}

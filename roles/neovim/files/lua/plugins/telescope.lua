return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    lazy = false,
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("telescope").setup({ extensions = { fzf = {} } })
        require("telescope").load_extension("fzf")
    end,
}

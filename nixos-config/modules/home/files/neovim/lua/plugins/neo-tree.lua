return {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    keys = {
        { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle explorer" },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        close_if_last_window = false,
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
            hijack_netrw = true,
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
                hide_gitignored = true,
            },
        },
        window = {
            width = 30,
            mappings = { ["<space>"] = "none" },
        },
    },
}

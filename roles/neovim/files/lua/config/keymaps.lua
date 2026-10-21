local map = vim.keymap.set

local function opts(desc)
    return { desc = desc, silent = true }
end

-- ---------------------------------------------------------------------------
-- General keymaps (not tied to any plugin)
-- Plugin-specific keymaps live in each plugin's file under lua/plugins/.
-- ---------------------------------------------------------------------------

-- File saving
map("n", "<leader>ww", "<cmd>write<cr>", opts("Save file"))
map("n", "<leader>wa", "<cmd>wall<cr>", opts("Save all files"))

-- Window quitting
map("n", "<leader>qq", "<cmd>quit<cr>", opts("Quit window"))
map("n", "<leader>qa", "<cmd>qa<cr>", opts("Quit all windows"))
map("n", "<leader>qx", "<cmd>qa!<cr>", opts("Quit all windows without saving"))

-- Buffer closing
map("n", "<leader>xx", "<cmd>bdelete<cr>", opts("Close buffer"))
map("n", "<leader>xa", "<cmd>bdelete!<cr>", opts("Close all buffers"))

-- Clear search highlight
map("n", "<leader>hh", "<cmd>nohlsearch<cr>", opts("Clear search highlight"))

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts("Go to left window"))
map("n", "<C-j>", "<C-w>j", opts("Go to lower window"))
map("n", "<C-k>", "<C-w>k", opts("Go to upper window"))
map("n", "<C-l>", "<C-w>l", opts("Go to right window"))
map("n", "<C-Left>", "<C-w>h", opts("Go to left window"))
map("n", "<C-Down>", "<C-w>j", opts("Go to lower window"))
map("n", "<C-Up>", "<C-w>k", opts("Go to upper window"))
map("n", "<C-Right>", "<C-w>l", opts("Go to right window"))

-- Window splitting
map("n", "<leader>ws", "<C-w>s", opts("Split window horizontally"))
map("n", "<leader>wv", "<C-w>v", opts("Split window vertically"))

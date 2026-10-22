-- ===========================================================================
-- Keymaps
-- ===========================================================================

local map = vim.keymap.set

local function opts(desc, extra)
	return vim.tbl_extend("force", { desc = desc, silent = true }, extra or {})
end

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

-- Close current buffer but keep the window layout (switch to another buffer first)
local function close_buffer(force)
	local buf = vim.api.nvim_get_current_buf()
	if vim.bo[buf].modified and not force then
		vim.notify("Buffer has unsaved changes (use <leader>xX to force)", vim.log.levels.WARN)
		return
	end
	if #vim.fn.getbufinfo({ buflisted = 1 }) > 1 then
		vim.cmd("bprevious")
	end
	vim.cmd((force and "bdelete! " or "bdelete ") .. buf)
end

-- Close every listed buffer except the current one (skips unsaved ones)
local function close_other_buffers()
	local current = vim.api.nvim_get_current_buf()
	for _, b in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		if b.bufnr ~= current and b.changed == 0 then
			vim.api.nvim_buf_delete(b.bufnr, {})
		end
	end
end

-- Toggle a boolean window/buffer option and tell me the new value
local function toggle(option)
	return function()
		vim.opt_local[option] = not vim.opt_local[option]:get()
		vim.notify(option .. ": " .. tostring(vim.opt_local[option]:get()))
	end
end

-- Copy part of the current file path to the system clipboard
local function copy_path(modifier)
	return function()
		local path = vim.fn.expand(modifier)
		vim.fn.setreg("+", path)
		vim.notify("Copied: " .. path)
	end
end

-- ---------------------------------------------------------------------------
-- File saving
-- ---------------------------------------------------------------------------
map("n", "<leader>ww", "<cmd>write<cr>", opts("Save file"))
map("n", "<leader>wa", "<cmd>wall<cr>", opts("Save all files"))
map({ "n", "i", "x" }, "<C-s>", "<cmd>write<cr><esc>", opts("Save file"))

-- ---------------------------------------------------------------------------
-- Window quitting
-- ---------------------------------------------------------------------------
map("n", "<leader>qq", "<cmd>quit<cr>", opts("Quit window"))
map("n", "<leader>qa", "<cmd>qa<cr>", opts("Quit all windows"))
map("n", "<leader>qx", "<cmd>qa!<cr>", opts("Quit all windows without saving"))

-- ---------------------------------------------------------------------------
-- Buffer closing
-- ---------------------------------------------------------------------------
map("n", "<leader>xx", function()
	close_buffer(false)
end, opts("Close buffer (keep window)"))
map("n", "<leader>xX", function()
	close_buffer(true)
end, opts("Force close buffer"))
map("n", "<leader>xo", close_other_buffers, opts("Close other buffers"))
map("n", "<leader>xa", "<cmd>%bdelete<cr>", opts("Close all buffers"))

-- ---------------------------------------------------------------------------
-- Buffer navigation
-- ---------------------------------------------------------------------------
map("n", "<s-h>", "<cmd>bprevious<cr>", opts("previous buffer"))
map("n", "<s-l>", "<cmd>bnext<cr>", opts("next buffer"))
map("n", "<s-Left>", "<cmd>bprevious<cr>", opts("previous buffer"))
map("n", "<s-Right>", "<cmd>bnext<cr>", opts("next buffer"))
map("t", "<C-h>", "<cmd>wincmd h<cr>", opts("Go to left window"))
map("t", "<C-j>", "<cmd>wincmd j<cr>", opts("Go to lower window"))
map("t", "<C-k>", "<cmd>wincmd k<cr>", opts("Go to upper window"))
map("t", "<C-l>", "<cmd>wincmd l<cr>", opts("Go to right window"))
map("n", "<leader>bb", "<cmd>b#<cr>", opts("Switch to last buffer"))

-- ---------------------------------------------------------------------------
-- Clear search highlight
-- ---------------------------------------------------------------------------
map("n", "<leader>hh", "<cmd>nohlsearch<cr>", opts("Clear search highlight"))
map("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>", opts("Clear search highlight"))

-- ---------------------------------------------------------------------------
-- Window navigation
-- ---------------------------------------------------------------------------
map("n", "<C-h>", "<C-w>h", opts("Go to left window"))
map("n", "<C-j>", "<C-w>j", opts("Go to lower window"))
map("n", "<C-k>", "<C-w>k", opts("Go to upper window"))
map("n", "<C-l>", "<C-w>l", opts("Go to right window"))
map("n", "<C-Left>", "<C-w>h", opts("Go to left window"))
map("n", "<C-Down>", "<C-w>j", opts("Go to lower window"))
map("n", "<C-Up>", "<C-w>k", opts("Go to upper window"))
map("n", "<C-Right>", "<C-w>l", opts("Go to right window"))

-- ---------------------------------------------------------------------------
-- Window splitting & management
-- ---------------------------------------------------------------------------
map("n", "<leader>ws", "<C-w>s", opts("Split window horizontally"))
map("n", "<leader>wv", "<C-w>v", opts("Split window vertically"))
map("n", "<leader>wc", "<C-w>c", opts("Close window"))
map("n", "<leader>wo", "<C-w>o", opts("Close other windows"))
map("n", "<leader>we", "<C-w>=", opts("Equalize window sizes"))
map("n", "<leader>wm", "<C-w>|<C-w>_", opts("Maximize window"))

-- ---------------------------------------------------------------------------
-- Window resizing
-- ---------------------------------------------------------------------------
map("n", "<A-k>", "<cmd>resize +2<cr>", opts("Increase window height"))
map("n", "<A-j>", "<cmd>resize -2<cr>", opts("Decrease window height"))
map("n", "<A-h>", "<cmd>vertical resize -2<cr>", opts("Decrease window width"))
map("n", "<A-l>", "<cmd>vertical resize +2<cr>", opts("Increase window width"))
map("n", "<A-Up>", "<cmd>resize +2<cr>", opts("Increase window height"))
map("n", "<A-Down>", "<cmd>resize -2<cr>", opts("Decrease window height"))
map("n", "<A-Left>", "<cmd>vertical resize -2<cr>", opts("Decrease window width"))
map("n", "<A-Right>", "<cmd>vertical resize +2<cr>", opts("Increase window width"))

-- ---------------------------------------------------------------------------
-- Tabs
-- ---------------------------------------------------------------------------
map("n", "<leader><tab>t", "<cmd>tabnew<cr>", opts("New tab"))
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", opts("Close tab"))
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", opts("Close other tabs"))
map("n", "<leader><tab>n", "<cmd>tabnext<cr>", opts("Next tab"))
map("n", "<leader><tab>p", "<cmd>tabprevious<cr>", opts("Previous tab"))

-- ---------------------------------------------------------------------------
-- Better movement
-- ---------------------------------------------------------------------------
-- j/k move by visual line when a line wraps (but still respect counts like 5j)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", opts("Down", { expr = true }))
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", opts("Up", { expr = true }))
-- Keep the cursor centered when jumping
map("n", "<C-d>", "<C-d>zz", opts("Half page down (centered)"))
map("n", "<C-u>", "<C-u>zz", opts("Half page up (centered)"))
map("n", "n", "nzzzv", opts("Next match (centered)"))
map("n", "N", "Nzzzv", opts("Previous match (centered)"))
-- Leave insert mode without reaching for Esc
map("i", "jk", "<Esc>", opts("Exit insert mode"))

-- ---------------------------------------------------------------------------
-- Better editing
-- ---------------------------------------------------------------------------
-- Move lines up/down (Alt+j / Alt+k)
map("n", "<A-j>", "<cmd>m .+1<cr>==", opts("Move line down"))
map("n", "<A-k>", "<cmd>m .-2<cr>==", opts("Move line up"))
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", opts("Move line down"))
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", opts("Move line up"))
map("x", "<A-j>", ":m '>+1<cr>gv=gv", opts("Move selection down"))
map("x", "<A-k>", ":m '<-2<cr>gv=gv", opts("Move selection up"))
map("n", "<A-Down>", "<cmd>m .+1<cr>==", opts("Move line down"))
map("n", "<A-Up>", "<cmd>m .-2<cr>==", opts("Move line up"))
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", opts("Move line down"))
map("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", opts("Move line up"))
map("x", "<A-Down>", ":m '>+1<cr>gv=gv", opts("Move selection down"))
map("x", "<A-Up>", ":m '<-2<cr>gv=gv", opts("Move selection up"))
-- Stay in visual mode after indenting
map("x", "<", "<gv", opts("Indent left (keep selection)"))
map("x", ">", ">gv", opts("Indent right (keep selection)"))
-- Join lines without moving the cursor
map("n", "J", "mzJ`z", opts("Join lines (keep cursor)"))
-- Paste over a selection without losing what's in the register
map("x", "p", [["_dP]], opts("Paste without overwriting register"))
-- x never touches the register
map({ "n", "x" }, "x", [["_x]], opts("Delete char (no yank)"))
-- Reselect the text you just pasted or yanked
map("n", "gp", "`[v`]", opts("Select last pasted/yanked text"))
-- Add blank lines below/above without leaving normal mode
map("n", "]<space>", function()
	vim.fn.append(vim.fn.line("."), vim.fn["repeat"]({ "" }, vim.v.count1))
end, opts("Add blank line below"))
map("n", "[<space>", function()
	vim.fn.append(vim.fn.line(".") - 1, vim.fn["repeat"]({ "" }, vim.v.count1))
end, opts("Add blank line above"))

-- ---------------------------------------------------------------------------
-- Search & replace
-- ---------------------------------------------------------------------------
-- Search for the selected text (forward / backward)
map("x", "*", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], opts("Search selection forward", { silent = false }))
map("x", "#", [[y?\V<C-R>=escape(@",'?\')<CR><CR>]], opts("Search selection backward", { silent = false }))
-- Replace the word under the cursor across the file
map(
	"n",
	"<leader>rw",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	opts("Replace word under cursor", { silent = false })
)
-- Source the current file (handy when editing your config)
map("n", "<leader>rr", "<cmd>source %<cr>", opts("Source current file"))

-- ---------------------------------------------------------------------------
-- File path helpers
-- ---------------------------------------------------------------------------
map("n", "<leader>fp", copy_path("%:p"), opts("Copy absolute path"))
map("n", "<leader>fr", copy_path("%:."), opts("Copy relative path"))
map("n", "<leader>fn", copy_path("%:t"), opts("Copy file name"))

-- ---------------------------------------------------------------------------
-- Toggles
-- ---------------------------------------------------------------------------
map("n", "<leader>uw", toggle("wrap"), opts("Toggle wrap"))
map("n", "<leader>us", toggle("spell"), opts("Toggle spellcheck"))
map("n", "<leader>un", toggle("relativenumber"), opts("Toggle relative numbers"))
map("n", "<leader>ul", toggle("list"), opts("Toggle invisible characters"))

-- ---------------------------------------------------------------------------
-- Diagnostics
-- ---------------------------------------------------------------------------
map("n", "<leader>cd", vim.diagnostic.open_float, opts("Line diagnostics"))
map("n", "<leader>cl", vim.diagnostic.setloclist, opts("Diagnostics to location list"))

-- ---------------------------------------------------------------------------
-- Format buffer (with conform.nvim if available, otherwise fallback to LSP)
-- ---------------------------------------------------------------------------
map({ "n", "x" }, "<leader>cf", function()
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({ async = true, lsp_format = "fallback" }) -- older conform: lsp_fallback = true
	else
		vim.lsp.buf.format({ async = true })
	end
end, opts("Format buffer"))

-- ---------------------------------------------------------------------------
-- Terminal
-- ---------------------------------------------------------------------------
map("n", "<leader>tt", "<cmd>botright 12split | terminal<cr>", opts("Open terminal"))
map("t", "<Esc><Esc>", [[<C-\><C-n>]], opts("Exit terminal mode"))
map("t", "<C-h>", "<cmd>wincmd h<cr>", opts("Go to left window"))
map("t", "<C-j>", "<cmd>wincmd j<cr>", opts("Go to lower window"))
map("t", "<C-k>", "<cmd>wincmd k<cr>", opts("Go to upper window"))
map("t", "<C-l>", "<cmd>wincmd l<cr>", opts("Go to right window"))
map("t", "<C-Left>", "<cmd>wincmd h<cr>", opts("Go to left window"))
map("t", "<C-Down>", "<cmd>wincmd j<cr>", opts("Go to lower window"))
map("t", "<C-Up>", "<cmd>wincmd k<cr>", opts("Go to upper window"))
map("t", "<C-Right>", "<cmd>wincmd l<cr>", opts("Go to right window"))

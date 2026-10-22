-- ===========================================================================
--  Autocmds
-- ===========================================================================

local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true }) -- clear = true avoids duplicates on re-source
end

-- ---------------------------------------------------------------------------
-- Highlight yanked text briefly
-- ---------------------------------------------------------------------------
autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank({ timeout = 200 }) -- use vim.highlight.on_yank on nvim < 0.11
  end,
  desc = "Highlight yanked text",
})

-- ---------------------------------------------------------------------------
-- Lint modified file on save
-- ---------------------------------------------------------------------------
autocmd("BufWritePost", {
  group = augroup("lint_on_save"),
  callback = function()
    local ok, lint = pcall(require, "lint")
    if ok then
      lint.try_lint()
    end
  end,
  desc = "Lint modified file on save",
})

-- ---------------------------------------------------------------------------
-- Restore cursor position when reopening a file
-- ---------------------------------------------------------------------------
autocmd("BufReadPost", {
  group = augroup("restore_cursor"),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lines = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Restore cursor position when reopening a file",
})

-- ---------------------------------------------------------------------------
-- Auto-create missing parent directories on save
-- ---------------------------------------------------------------------------
autocmd("BufWritePre", {
  group = augroup("auto_mkdir"),
  callback = function(args)
    if args.match:match("^%w%w+:[\\/][\\/]") then return end -- skip URLs (oil://, http://…)
    vim.fn.mkdir(vim.fn.fnamemodify(args.file, ":p:h"), "p")
  end,
  desc = "Auto-create missing parent directories on save",
})

-- ---------------------------------------------------------------------------
-- Equalize splits when the terminal is resized
-- ---------------------------------------------------------------------------
autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. tab)
  end,
  desc = "Equalize splits when the terminal is resized",
})

-- ---------------------------------------------------------------------------
-- Close utility windows with just "q"
-- ---------------------------------------------------------------------------
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = { "help", "qf", "man", "checkhealth", "lspinfo", "notify", "startuptime" },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, silent = true })
  end,
  desc = "Close utility windows with just 'q'",
})

-- ---------------------------------------------------------------------------
-- Reload files changed outside nvim (pairs with 'autoread')
-- ---------------------------------------------------------------------------
autocmd({ "FocusGained", "TermClose", "TermLeave", "BufEnter" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then vim.cmd("checktime") end
  end,
  desc = "Reload files changed outside nvim",
})

-- ---------------------------------------------------------------------------
-- Wrap and spellcheck in prose filetypes
-- ---------------------------------------------------------------------------
autocmd("FileType", {
  group = augroup("prose"),
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  desc = "Wrap and spellcheck in prose filetypes",
})

-- ---------------------------------------------------------------------------
-- Cleaner terminal buffers: no numbers, start in insert mode
-- ---------------------------------------------------------------------------
autocmd("TermOpen", {
  group = augroup("terminal"),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
  desc = "Cleaner terminal buffers: no numbers, start in insert mode",
})

-- ---------------------------------------------------------------------------
-- Cursorline only in the active window
-- ---------------------------------------------------------------------------
local cursorline_group = augroup("cursorline_active")
autocmd({ "WinEnter", "BufEnter" }, {
  group = cursorline_group,
  callback = function() vim.opt_local.cursorline = true end,
  desc = "Show cursorline in the focused window",
})
autocmd("WinLeave", {
  group = cursorline_group,
  callback = function() vim.opt_local.cursorline = false end,
  desc = "Hide cursorline in unfocused windows",
})

-- ---------------------------------------------------------------------------
-- Open help and man pages in a vertical split on the right
-- ---------------------------------------------------------------------------
autocmd("FileType", {
  group = augroup("help_vsplit"),
  pattern = { "help", "man" },
  callback = function() vim.cmd("wincmd L") end,
  desc = "Open help and man pages in a vertical split on the right",
})

-- ---------------------------------------------------------------------------
-- Big files: turn off the expensive stuff (> 1 MB)
-- ---------------------------------------------------------------------------
local bigfile_group = augroup("bigfile")
autocmd("BufReadPre", {
  group = bigfile_group,
  callback = function(args)
    local ok, stats = pcall(vim.uv.fs_stat, args.file) -- vim.uv needs nvim 0.10+, else vim.loop
    if ok and stats and stats.size > 1024 * 1024 then
      vim.b[args.buf].bigfile = true
      vim.bo[args.buf].undolevels = -1 -- no undo history for huge files
    end
  end,
  desc = "Detect big files",
})
autocmd("FileType", {
  group = bigfile_group,
  callback = function(args)
    if not vim.b[args.buf].bigfile then return end
    vim.schedule(function() -- run after plugins attach
      if not vim.api.nvim_buf_is_valid(args.buf) then return end
      vim.bo[args.buf].syntax = "off"
      pcall(vim.treesitter.stop, args.buf)
    end)
  end,
  desc = "Disable syntax and treesitter in big files",
})

-- ---------------------------------------------------------------------------
-- No undo/swap/backup files for sensitive or temporary files
-- ---------------------------------------------------------------------------
autocmd({ "BufNewFile", "BufReadPre" }, {
  group = augroup("sensitive_files"),
  pattern = { "/tmp/*", "/dev/shm/*", "*.gpg", "*.asc", "*/.ssh/*", "*/.aws/*" },
  callback = function()
    vim.opt_local.undofile = false
    vim.opt_local.swapfile = false
    vim.opt_local.backup = false
    vim.opt_local.writebackup = false
  end,
  desc = "No undo/swap/backup files for sensitive or temporary files",
})

-- ---------------------------------------------------------------------------
-- Open quickfix / location list automatically after :grep, :make, :vimgrep
-- ---------------------------------------------------------------------------
local qf_group = augroup("auto_quickfix")
autocmd("QuickFixCmdPost", {
  group = qf_group,
  pattern = "[^l]*",
  command = "cwindow",
  nested = true,
  desc = "Open quickfix list after a command fills it",
})
autocmd("QuickFixCmdPost", {
  group = qf_group,
  pattern = "l*",
  command = "lwindow",
  nested = true,
  desc = "Open location list after a command fills it",
})

-- ---------------------------------------------------------------------------
-- Close terminal buffers when the shell exits cleanly
-- ---------------------------------------------------------------------------
autocmd("TermClose", {
  group = augroup("terminal_close"),
  callback = function(args)
    if vim.v.event.status == 0 then
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          vim.api.nvim_buf_delete(args.buf, { force = true })
        end
      end)
    end
  end,
  desc = "Close terminal buffers when the shell exits cleanly",
})

-- ---------------------------------------------------------------------------
-- Re-enter insert mode when switching back to a terminal buffer
-- ---------------------------------------------------------------------------
autocmd("BufEnter", {
  group = augroup("terminal_enter"),
  pattern = "term://*",
  command = "startinsert",
  desc = "Re-enter insert mode when switching back to a terminal buffer",
})

-- ---------------------------------------------------------------------------
-- Don't hide quotes in JSON (conceallevel = 2 would conceal them)
-- ---------------------------------------------------------------------------
autocmd("FileType", {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc" },
  callback = function() vim.opt_local.conceallevel = 0 end,
  desc = "Don't hide quotes in JSON",
})

-- ---------------------------------------------------------------------------
-- LSP keymaps (only exist in buffers where a language server is attached)
-- ---------------------------------------------------------------------------
autocmd("LspAttach", {
  group = augroup("lsp_attach"),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
 
    -- Map a key only if this server actually supports the LSP method behind it
    local function lsp_map(keys, method, fn, desc, mode)
      if not client:supports_method(method, args.buf) then return end -- colon call: nvim 0.11+
      vim.keymap.set(mode or "n", keys, fn, { buffer = args.buf, silent = true, desc = "LSP: " .. desc })
    end
 
    -- Navigation
    lsp_map("gd", "textDocument/definition", vim.lsp.buf.definition, "Go to definition")
    lsp_map("gD", "textDocument/declaration", vim.lsp.buf.declaration, "Go to declaration")
    lsp_map("gi", "textDocument/implementation", vim.lsp.buf.implementation, "Go to implementation")
    lsp_map("gy", "textDocument/typeDefinition", vim.lsp.buf.type_definition, "Go to type definition")
    lsp_map("gR", "textDocument/references", vim.lsp.buf.references, "Show references") -- gR: nvim 0.11 owns gr* (grr, grn, gra…)
 
    -- Actions
    lsp_map("<leader>ca", "textDocument/codeAction", vim.lsp.buf.code_action, "Code action", { "n", "x" })
    lsp_map("<leader>rn", "textDocument/rename", vim.lsp.buf.rename, "Rename symbol")
    lsp_map("<leader>cd", "textDocument/publishDiagnostics", vim.diagnostic.open_float, "Show line diagnostics")
 
    -- Help while typing (<C-s> is taken by "save" in your keymaps)
    lsp_map("<C-k>", "textDocument/signatureHelp", vim.lsp.buf.signature_help, "Signature help", "i")
 
    -- Inlay hints toggle (only for servers that provide them)
    lsp_map("<leader>ch", "textDocument/inlayHint", function()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = args.buf })
    end, "Toggle inlay hints")
 
    -- Note: formatting is NOT mapped here. It lives in your keymaps file so it
    -- also works in buffers without an LSP (see below).
  end,
  desc = "Buffer-local LSP keymaps",
})

-- ---------------------------------------------------------------------------
-- Column width by filetype
-- ---------------------------------------------------------------------------

-- cc   = column for the visual ruler ('colorcolumn')
-- tw   = hard-wrap width ('textwidth'); omit to leave wrapping alone
-- prose = also auto-wrap text while typing (adds "t" to 'formatoptions')
local widths = {
  -- Code: match each language's common formatter
  lua        = { cc = 120, tw = 120 },  -- stylua default
  python     = { cc = 88,  tw = 88 },   -- black / ruff
  rust       = { cc = 100, tw = 100 },  -- rustfmt
  go         = { cc = 100 },            -- gofmt has no limit, ruler only
  javascript = { cc = 100, tw = 100 },
  typescript = { cc = 100, tw = 100 },
  java       = { cc = 100, tw = 100 },
  c          = { cc = 80,  tw = 80 },
  cpp        = { cc = 80,  tw = 80 },
  sh         = { cc = 80,  tw = 80 },
  -- Data / config: no limit, no ruler
  json       = { cc = "" },
  yaml       = { cc = "" },
  -- Prose: narrower, with real wrapping while typing
  markdown   = { cc = 80, tw = 80, prose = true },
  text       = { cc = 80, tw = 80, prose = true },
  gitcommit  = { cc = 72, tw = 72, prose = true }, -- 72 is the git convention
}

autocmd("FileType", {
  group = augroup("filetype_widths"),
  pattern = vim.tbl_keys(widths),
  callback = function(args)
    local cfg = widths[args.match]
    if not cfg then return end

    vim.opt_local.colorcolumn = tostring(cfg.cc)
    if cfg.tw then
      vim.opt_local.textwidth = cfg.tw
    end
    if cfg.prose then
      vim.opt_local.formatoptions:append("t") -- auto-wrap text as you type
    end
  end,
  desc = "Column width by filetype",
})

-- ---------------------------------------------------------------------------
-- Indentation by filetype
-- ---------------------------------------------------------------------------

-- sw   = indent width (also used for tabstop/softtabstop)
-- tabs = use real tab characters instead of spaces
local indents = {
  -- 2 spaces
  lua             = { sw = 2 },
  javascript      = { sw = 2 },
  typescript      = { sw = 2 },
  javascriptreact = { sw = 2 },
  typescriptreact = { sw = 2 },
  json            = { sw = 2 },
  jsonc           = { sw = 2 },
  yaml            = { sw = 2 },
  html            = { sw = 2 },
  css             = { sw = 2 },
  scss            = { sw = 2 },
  -- 4 spaces
  python          = { sw = 4 },
  rust            = { sw = 4 },
  -- Real tabs
  go              = { sw = 4, tabs = true },
  make            = { sw = 8, tabs = true }, -- Makefiles require tabs
}

autocmd("FileType", {
  group = augroup("filetype_indents"),
  pattern = vim.tbl_keys(indents),
  callback = function(args)
    local cfg = indents[args.match]
    if not cfg then return end

    vim.opt_local.shiftwidth = cfg.sw
    vim.opt_local.tabstop = cfg.sw
    vim.opt_local.softtabstop = cfg.sw
    vim.opt_local.expandtab = not cfg.tabs
  end,
  desc = "Indentation by filetype",
})
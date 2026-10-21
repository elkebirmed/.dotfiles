local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.wrap = false
opt.cursorline = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " " }
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "split"
opt.pumheight = 10
opt.pumblend = 10
opt.winblend = 0
opt.completeopt = { "menuone", "noselect" }
opt.spelllang = { "en" }
opt.termguicolors = true

-- ---------------------------------------------------------------------------
-- Undo / backup / swap
-- ---------------------------------------------------------------------------
opt.undofile = true
opt.undolevels = 10000
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- ---------------------------------------------------------------------------
-- Folding
-- ---------------------------------------------------------------------------
opt.foldenable = true
opt.foldlevelstart = 99

-- ---------------------------------------------------------------------------
-- Diff
-- ---------------------------------------------------------------------------
opt.diffopt:append({ "linematch:60" })

-- ---------------------------------------------------------------------------
-- Grep / shell
-- ---------------------------------------------------------------------------
opt.grepprg = "rg --vimgrep --smart-case --hidden"
opt.grepformat = "%f:%l:%c:%m"
opt.shellslash = true

-- ---------------------------------------------------------------------------
-- Completion / menu
-- ---------------------------------------------------------------------------
opt.wildmenu = true
opt.wildmode = { "list:longest" }
opt.shortmess:append({ c = true })

-- ---------------------------------------------------------------------------
-- UI
-- ---------------------------------------------------------------------------
opt.title = true
opt.titlestring = "%t(%{expand('%:p:h:t')}) - nvim"
opt.modeline = false
opt.confirm = true
opt.hidden = true

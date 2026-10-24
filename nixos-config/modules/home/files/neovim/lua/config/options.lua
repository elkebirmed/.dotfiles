-- ===========================================================================
-- OPTIONS
-- ===========================================================================

local opt = vim.opt

-- ---------------------------------------------------------------------------
-- GENERAL BEHAVIOR
-- ---------------------------------------------------------------------------
opt.mouse = "a"                  -- enable mouse in all modes
opt.clipboard = "unnamedplus"    -- use system clipboard for yank/paste
opt.hidden = true                -- allow switching buffers with unsaved changes
opt.confirm = true               -- ask to save instead of failing on :q
opt.autoread = true              -- reload files changed outside nvim
opt.updatetime = 250             -- ms idle before CursorHold / swap write
opt.timeoutlen = 400             -- ms to wait for mapped key sequence
opt.ttimeoutlen = 10             -- ms to wait for key codes (fast <Esc>)
opt.history = 1000               -- command-line history size
opt.belloff = "all"              -- never ring the bell
opt.visualbell = false           -- no screen flash either
opt.modeline = false             -- ignore modelines in files (security)
opt.timeout = true               -- time out on mapped key sequences
opt.ttimeout = true              -- time out on key codes too
opt.mousemodel = "popup_setpos"  -- right-click opens menu and moves the cursor
opt.mousescroll = "ver:3,hor:6"  -- lines/columns scrolled per wheel tick
opt.mousemoveevent = true        -- report mouse movement (hover plugins)
opt.errorbells = false           -- no beep on errors
opt.redrawtime = 1500            -- ms before giving up on slow syntax highlighting
opt.exrc = false                 -- don't auto-load local .nvim.lua/.exrc files
opt.jumpoptions = "view"         -- restore scroll position when jumping back

-- ---------------------------------------------------------------------------
-- FILES, BACKUP & UNDO
-- ---------------------------------------------------------------------------
opt.swapfile = false             -- no .swp files
opt.backup = false               -- no backup~ files
opt.writebackup = false          -- no temp backup while writing
opt.undofile = true              -- persistent undo across sessions
opt.undolevels = 10000           -- max undo steps
opt.undodir = vim.fn.stdpath("state") .. "/undo" -- where undo files live
opt.directory = vim.fn.stdpath("state") .. "/swap" -- swap file dir (if enabled)
opt.backupdir = vim.fn.stdpath("state") .. "/backup" -- backup dir (if enabled)
opt.shada = "!,'100,<50,s10,h"   -- what to persist: marks, registers, history
opt.fileformat = "unix"          -- default line endings for new files
opt.fileencodings = "ucs-bom,utf-8,default,latin1" -- encodings tried when opening a file
opt.undoreload = 10000           -- max lines saved for undo when reloading a buffer
opt.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds" -- what :mksession saves
opt.viewoptions = "folds,cursor,curdir" -- what :mkview saves
opt.path:append("**")            -- :find searches recursively from cwd
opt.suffixesadd = { ".lua", ".js", ".ts", ".py" } -- extensions tried by gf / :find

-- ---------------------------------------------------------------------------
-- UI & APPEARANCE
-- ---------------------------------------------------------------------------
opt.number = true                -- show absolute line number on cursor line
opt.relativenumber = true        -- relative numbers elsewhere (great for 5j/3k)
opt.numberwidth = 4              -- minimum width of number column
opt.cursorline = true            -- highlight current line
opt.signcolumn = "yes"           -- always show sign column (no layout jumps)
opt.termguicolors = true         -- 24-bit colors
opt.background = "dark"          -- hint for colorschemes
opt.showmode = false             -- hide -- INSERT -- (statusline shows it)
opt.showcmd = true               -- show pending keys in the bottom right
opt.cmdheight = 1                -- command line height (0 to hide it)
opt.laststatus = 3               -- single global statusline
opt.ruler = true                 -- show cursor position (if no statusline)
opt.showtabline = 1              -- tabline only when 2+ tabs
opt.title = true                 -- set terminal window title
opt.list = true                  -- show invisible characters
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" } -- how to draw them
opt.fillchars = { eob = " ", fold = " ", diff = "╱" } -- filler chars (hide ~ at end of buffer)
opt.conceallevel = 2             -- hide markup (markdown, json quotes…)
opt.pumheight = 12               -- max items in popup menu
opt.pumblend = 10                -- popup menu transparency
opt.winblend = 10                -- floating window transparency
opt.scrolloff = 8                -- keep 8 lines visible above/below cursor
opt.sidescrolloff = 8            -- same for columns when nowrap
opt.synmaxcol = 300              -- don't syntax-highlight very long lines
opt.lazyredraw = false           -- keep false in modern nvim (can cause glitches)
opt.winborder = "rounded"        -- border style for floating windows (nvim 0.11+)
opt.cursorlineopt = "both"       -- highlight line number and text of cursor line
opt.pumwidth = 15                -- minimum width of popup menu
opt.cmdwinheight = 7             -- height of the q: command-line window
opt.emoji = true                 -- treat emoji as full-width
opt.ambiwidth = "single"         -- ambiguous-width chars take one cell
opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr-o:hor20" -- block in normal, bar in insert, underline in replace
opt.tabpagemax = 15              -- max tab pages opened by -p / :tab all

-- ---------------------------------------------------------------------------
-- LINE WRAPPING & TEXT LAYOUT
-- ---------------------------------------------------------------------------
opt.wrap = false                 -- don't wrap long lines
opt.linebreak = true             -- if wrap is on, break at words not mid-word
opt.breakindent = true           -- wrapped lines keep indentation
opt.showbreak = "↪ "             -- marker for wrapped line continuation
opt.textwidth = 0                -- no automatic hard wrapping
opt.formatoptions = "jcroql"     -- j: join comments, c/r/o: comment continue, q: gq, l: no break long
opt.smoothscroll = true          -- scroll wrapped lines smoothly (0.10+)
opt.display = "lastline"         -- show as much of a long last line as possible
opt.breakindentopt = "shift:2"   -- extra indent for wrapped lines
opt.joinspaces = false           -- one space (not two) after . when joining lines
opt.scrolljump = 1               -- minimum lines to scroll when cursor leaves the screen

-- ---------------------------------------------------------------------------
-- INDENTATION & TABS
-- ---------------------------------------------------------------------------
opt.tabstop = 4                  -- visual width of a <Tab>
opt.shiftwidth = 4               -- width of >> / << / auto-indent
opt.softtabstop = 4              -- <Tab>/<BS> width while editing
opt.expandtab = true             -- insert spaces instead of tabs
opt.smarttab = true              -- <Tab> at line start uses shiftwidth
opt.autoindent = true            -- copy indent from current line on <CR>
opt.smartindent = true           -- basic C-like auto-indent
opt.shiftround = true            -- round indent to multiple of shiftwidth
opt.copyindent = true            -- copy the structure of existing line's indent
opt.preserveindent = true        -- keep existing indent chars when re-indenting
opt.cindent = false              -- no strict C indenting (filetype plugins decide)

-- ---------------------------------------------------------------------------
-- SEARCH & REPLACE
-- ---------------------------------------------------------------------------
opt.ignorecase = true            -- case-insensitive search…
opt.smartcase = true             -- …unless pattern has an uppercase letter
opt.hlsearch = true              -- highlight all matches
opt.incsearch = true             -- show matches while typing
opt.wrapscan = true              -- wrap around end of file
opt.inccommand = "split"         -- live preview of :s in a split
opt.gdefault = false             -- true makes :s replace all per line by default
opt.grepprg = "rg --vimgrep --smart-case" -- use ripgrep for :grep
opt.grepformat = "%f:%l:%c:%m"   -- parse ripgrep's output format
opt.magic = true                 -- standard regex special characters
opt.regexpengine = 0             -- pick regex engine automatically
opt.tagcase = "followscs"        -- tag search follows ignorecase/smartcase

-- ---------------------------------------------------------------------------
-- WINDOW SPLITS
-- ---------------------------------------------------------------------------
opt.splitright = true            -- :vsplit opens to the right
opt.splitbelow = true            -- :split opens below
opt.splitkeep = "screen"         -- keep text stable when splitting/closing
opt.equalalways = false          -- don't auto-resize all windows on split/close
opt.winminwidth = 5              -- minimum width of a non-focused window
opt.winminheight = 1             -- minimum height of a non-focused window
opt.winwidth = 20                -- preferred width of the focused window
opt.winheight = 1                -- preferred height of the focused window
opt.helpheight = 12              -- initial height of :help windows
opt.previewheight = 12           -- height of the preview window

-- ---------------------------------------------------------------------------
-- EDITING BEHAVIOR
-- ---------------------------------------------------------------------------
opt.backspace = "indent,eol,start" -- <BS> can delete anything in insert mode
opt.whichwrap = "b,s,<,>,[,]"    -- arrow keys wrap across lines
opt.virtualedit = "block"        -- cursor can go past EOL in visual-block
opt.matchpairs = "(:),{:},[:],<:>" -- pairs jumped with %
opt.showmatch = false            -- don't jump to matching bracket on typing
opt.iskeyword:append("-")        -- treat foo-bar as one word
opt.selection = "inclusive"      -- last char of a selection is included
opt.startofline = false          -- keep cursor column on big jumps (<C-d>, gg…)
opt.matchtime = 2                -- tenths of a second to show matching bracket
opt.diffopt = "internal,filler,closeoff,linematch:60" -- smarter :diffthis behavior

-- ---------------------------------------------------------------------------
-- FOLDING
-- ---------------------------------------------------------------------------
opt.foldenable = true            -- folding enabled
opt.foldmethod = "expr"          -- fold by expression (treesitter below)
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- companion to foldmethod: treesitter folds
opt.foldlevel = 99               -- start with folds open
opt.foldlevelstart = 99          -- same when opening a new buffer
opt.foldcolumn = "0"             -- hide fold column ("1" to show)
opt.foldnestmax = 4              -- max nesting depth for folds
opt.foldminlines = 1             -- fold must span at least this many lines
opt.foldtext = ""                -- show the folded line with its own highlighting (new, nvim 0.10+)

-- ---------------------------------------------------------------------------
-- SPELLING
-- ---------------------------------------------------------------------------
opt.spell = false                -- off by default (toggle with :set spell)
opt.spelllang = { "en_us" }      -- dictionary language(s)
opt.spelloptions = "camel"       -- treat camelCase parts as separate words
opt.spellsuggest = "best,9"      -- show 9 best suggestions

-- ---------------------------------------------------------------------------
-- COMPLETION & COMMAND LINE
-- ---------------------------------------------------------------------------
opt.wildmenu = true              -- enhanced command-line completion
opt.wildmode = "longest:full,full" -- complete longest match, then cycle
opt.wildignore = { "*.o", "*.pyc", "*/node_modules/*", "*/.git/*" } -- skip these in completion
opt.wildoptions = "pum"          -- show cmdline completions in a popup menu
opt.completeopt = { "menu", "menuone", "noselect" } -- completion popup behavior
opt.shortmess:append("cI")       -- no "match 1 of 2" noise, no intro screen
opt.complete = ".,w,b,u"         -- insert completion sources: current, windows, buffers, unloaded
opt.infercase = true             -- adjust case of completed word to what you typed
opt.wildignorecase = true        -- case-insensitive file/command completion
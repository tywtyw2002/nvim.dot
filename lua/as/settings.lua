local fn = vim.fn
local opt = vim.opt
local g = vim.g

g.nvchad_theme = "tomorrow_night"
g.base46_cache = vim.fn.stdpath "cache" .. "/nvchad/base46/"
g.transparency = false
g.toggle_theme_icon = g.transparency and "  " or "  "

--g.nvchad_theme = "gruvchad"
opt.cul = true -- cursor line

--if not vim.g.neovide then
--  g.transparency = true
--end

-- GUI
g.neovide_transparency = 0.9
g.neovide_cursor_antialiasing = true
opt.guifont = 'PragmataPro_Liga:h14'
-----------------------------------------------------------------------------//
-- Message output on vim actions {{{1
-----------------------------------------------------------------------------//
opt.shortmess = {
  t = true, -- truncate file messages at start
  A = true, -- ignore annoying swap file messages
  o = true, -- file-read message overwrites previous
  O = true, -- file-read message overwrites previous
  T = true, -- truncate non-file messages in middle
  f = true, -- (file x of x) instead of just (x of x
  F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
  s = true,
  c = true,
  W = true, -- Don't show [w] or written when writing
}
-----------------------------------------------------------------------------//
-- Timings {{{1
-----------------------------------------------------------------------------//
opt.updatetime = 250
--opt.timeout = true
opt.timeoutlen = 500
--opt.ttimeoutlen = 50
-----------------------------------------------------------------------------//
-- Window splitting and buffers {{{1
-----------------------------------------------------------------------------//
--- NOTE: remove this once 0.6 lands as it is now default
opt.hidden = true
opt.splitbelow = true
opt.splitright = true
opt.eadirection = 'hor'
-- exclude usetab as we do not want to jump to buffers in already open tabs
-- do not use split or vsplit to ensure we don't open any new windows
vim.o.switchbuf = 'useopen,uselast'
opt.fillchars = {
  vert = '▕', -- alternatives │
  fold = ' ',
  eob = ' ', -- suppress ~ at EndOfBuffer
  diff = '╱', -- alternatives = ⣿ ░ ─
  msgsep = '‾',
  foldopen = '▾',
  foldsep = '│',
  foldclose = '▸',
}
-----------------------------------------------------------------------------//
-- Diff {{{1
-----------------------------------------------------------------------------//
-- Use in vertical diff mode, blank lines to keep sides aligned, Ignore whitespace changes
opt.diffopt = opt.diffopt
  + {
    'vertical',
    'iwhite',
    'hiddenoff',
    'foldcolumn:0',
    'context:4',
    'algorithm:histogram',
    'indent-heuristic',
  }
-----------------------------------------------------------------------------//
-- Format Options {{{1
-----------------------------------------------------------------------------//
opt.formatoptions = {
  ['1'] = true,
  ['2'] = true, -- Use indent from 2nd line of a paragraph
  q = true, -- continue comments with gq"
  c = true, -- Auto-wrap comments using textwidth
  r = true, -- Continue comments when pressing Enter
  n = true, -- Recognize numbered lists
  t = false, -- autowrap lines using text width value
  j = true, -- remove a comment leader when joining lines.
  -- Only break if the line was not longer than 'textwidth' when the insert
  -- started and only at a white character that has been entered during the
  -- current insert command.
  l = true,
  v = true,
}
-----------------------------------------------------------------------------//
-- Folds {{{1
-----------------------------------------------------------------------------//
opt.foldtext = 'v:lua.as.folds()'
--opt.foldopen = opt.foldopen + 'search'
opt.foldlevelstart = 10
opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldmethod = 'expr'
-----------------------------------------------------------------------------//
-- Quickfix {{{1
-----------------------------------------------------------------------------//
--- FIXME: Need to use a lambda rather than a lua function directly
--- @see https://github.com/neovim/neovim/pull/14886
-- vim.o.quickfixtextfunc = '{i -> v:lua.as.qftf(i)}'
-----------------------------------------------------------------------------//
-- Grepprg {{{1
-----------------------------------------------------------------------------//
-- Use faster grep alternatives if possible
if as.executable 'rg' then
  vim.o.grepprg = [[rg --glob "!.git" --no-heading --vimgrep --follow $*]]
  opt.grepformat = opt.grepformat ^ { '%f:%l:%c:%m' }
elseif as.executable 'ag' then
  vim.o.grepprg = [[ag --nogroup --nocolor --vimgrep]]
  opt.grepformat = opt.grepformat ^ { '%f:%l:%c:%m' }
end
-----------------------------------------------------------------------------//
-- Wild and file globbing stuff in command mode {{{1
-----------------------------------------------------------------------------//
opt.wildcharm = fn.char2nr(as.replace_termcodes [[<Tab>]])
opt.wildmode = 'longest:full,full' -- Shows a menu bar as opposed to an enormous list
opt.wildignorecase = true -- Ignore case when completing file names and directories
-- Binary
opt.wildignore = {
  '*.aux',
  '*.out',
  '*.toc',
  '*.o',
  '*.obj',
  '*.dll',
  '*.jar',
  '*.pyc',
  '*.rbc',
  '*.class',
  '*.gif',
  '*.ico',
  '*.jpg',
  '*.jpeg',
  '*.png',
  '*.avi',
  '*.wav',
  -- Temp/System
  '*.*~',
  '*~ ',
  '*.swp',
  '.lock',
  '.DS_Store',
  'tags.lock',
}
opt.wildoptions = 'pum'
opt.pumblend = 3 -- Make popup window translucent
-----------------------------------------------------------------------------//
-- Display {{{1
-----------------------------------------------------------------------------//
--vim.wo.number = true
opt.number = true
opt.numberwidth = 2
opt.conceallevel = 2
opt.breakindentopt = 'sbr'
opt.linebreak = true -- lines wrap at words rather than random characters
opt.synmaxcol = 1024 -- don't syntax highlight long lines
-- FIXME: use 'auto:2-4' when the ability to set only a single lsp sign is restored
--@see: https://github.com/neovim/neovim/issues?q=set_signs
--opt.signcolumn = 'yes:2'
opt.colorcolumn = "79"  
opt.ruler = false
opt.cmdheight = 1 -- Set command line height to two lines
opt.showbreak = [[↪ ]] -- Options include -> '…', '↳ ', '→','↪ '
--- This is used to handle markdown code blocks where the language might
--- be set to a value that isn't equivalent to a vim filetype
vim.g.markdown_fenced_languages = {
  'js=javascript',
  'ts=typescript',
  'shell=sh',
  'bash=sh',
  'console=sh',
}
-----------------------------------------------------------------------------//
-- List chars {{{1
-----------------------------------------------------------------------------//
opt.list = true -- invisible chars
opt.listchars = {
  eol = nil,
  tab = '│ ',
  extends = '›', -- Alternatives: … »
  precedes = '‹', -- Alternatives: … «
  trail = '•', -- BULLET (U+2022, UTF-8: E2 80 A2)
}
-----------------------------------------------------------------------------//
-- Indentation
-----------------------------------------------------------------------------//
opt.wrap = true
opt.wrapmargin = 2
opt.textwidth = 80
opt.autoindent = true
opt.shiftround = true
opt.expandtab = true
opt.smartindent = true
opt.shiftwidth = 4
opt.tabstop = 4
-----------------------------------------------------------------------------//
-- vim.o.debug = "msg"
--- NOTE: remove this once 0.6 lands, it is now default
opt.joinspaces = false
opt.gdefault = true
opt.pumheight = 15
opt.confirm = true -- make vim prompt me to save before doing destructive things
opt.completeopt = { 'menuone', 'noselect' }
opt.hlsearch = false
opt.autowriteall = true -- automatically :write before running commands and changing files
opt.clipboard = { 'unnamedplus' }
--opt.laststatus = 2
opt.termguicolors = true

-----------------------------------------------------------------------------//
-- Emoji {{{1
-----------------------------------------------------------------------------//
-- emoji is true by default but makes (n)vim treat all emoji as double width
-- which breaks rendering so we turn this off.
-- CREDIT: https://www.youtube.com/watch?v=F91VWOelFNE
opt.emoji = false
-----------------------------------------------------------------------------//
--- NOTE: remove this once 0.6 lands, it is now default
opt.inccommand = 'nosplit'
-----------------------------------------------------------------------------//
-- Cursor {{{1
-----------------------------------------------------------------------------//
-- This is from the help docs, it enables mode shapes, "Cursor" highlight, and blinking
opt.guicursor = {
  [[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50]],
  [[a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor]],
  [[sm:block-blinkwait175-blinkoff150-blinkon175]],
}

opt.cursorlineopt = 'screenline,number'
-----------------------------------------------------------------------------//
-- Title {{{1
-----------------------------------------------------------------------------//
--opt.titlestring = require('as.external').title_string() or ' ❐ %t %r %m'
opt.titleold = fn.fnamemodify(vim.loop.os_getenv 'SHELL', ':t')
opt.title = true
opt.titlelen = 70
-----------------------------------------------------------------------------//
-- Utilities {{{1
-----------------------------------------------------------------------------//
opt.showmode = false
opt.sessionoptions = {
  'globals',
  'buffers',
  'curdir',
  'help',
  'winpos',
  -- "tabpages",
}
opt.viewoptions = { 'cursor', 'folds' } -- save/restore just these (with `:{mk,load}view`)
opt.virtualedit = 'block' -- allow cursor to move where there is no text in visual block mode
-----------------------------------------------------------------------------//
-- Shada (Shared Data)
-----------------------------------------------------------------------------//
-- NOTE: don't store marks as they are currently broke i.e.
-- are incorrectly resurrected after deletion
-- replace '100 with '0 the default which stores 100 marks
-- add f0 so file marks aren't stored
-- @credit: wincent
opt.shada = "!,'0,f0,<50,s10,h"
-------------------------------------------------------------------------------
-- BACKUP AND SWAPS {{{
-------------------------------------------------------------------------------
opt.backup = false
opt.writebackup = false
if fn.isdirectory(vim.o.undodir) == 0 then
  fn.mkdir(vim.o.undodir, 'p')
end
opt.undofile = true
opt.swapfile = false
-- The // at the end tells Vim to use the absolute path to the file to create the swap file.
-- This will ensure that swap file name is unique, so there are no collisions between files
-- with the same name from different directories.
opt.directory = fn.stdpath 'data' .. '/swap//'
if fn.isdirectory(vim.o.directory) == 0 then
  fn.mkdir(vim.o.directory, 'p')
end
--}}}
-----------------------------------------------------------------------------//
-- Match and search {{{1
-----------------------------------------------------------------------------//
opt.ignorecase = true
opt.smartcase = true
opt.wrapscan = true -- Searches wrap around the end of the file
opt.scrolloff = 3
opt.sidescrolloff = 5
opt.sidescroll = 1
-----------------------------------------------------------------------------//
-- Spelling {{{1
-----------------------------------------------------------------------------//
opt.spellsuggest:prepend { 12 }
opt.spelloptions = 'camel'
opt.spellcapcheck = '' -- don't check for capital letters at start of sentence
opt.fileformats = { 'unix' }
-----------------------------------------------------------------------------//
-- Mouse {{{1
-----------------------------------------------------------------------------//
opt.mouse = 'a'
opt.mousefocus = true
-----------------------------------------------------------------------------//
-- these only read ".vim" files
opt.secure = true -- Disable autocmd etc for project local vimrc files.
opt.exrc = true -- Allow project local vimrc files example .nvimrc see :h exrc
-----------------------------------------------------------------------------//
-- Git editor
-----------------------------------------------------------------------------//
if as.executable 'nvr' then
  vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
  vim.env.EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
end

-- Disable Builtin plugins
local disabled_built_ins = {
   "2html_plugin",
   "getscript",
   "getscriptPlugin",
   "gzip",
   "logipat",
   "netrw",
   "netrwPlugin",
   "netrwSettings",
   "netrwFileHandlers",
   "matchit",
   "tar",
   "tarPlugin",
   "rrhelper",
   "spellfile_plugin",
   "vimball",
   "vimballPlugin",
   "zip",
   "zipPlugin",
}
for _, plugin in pairs(disabled_built_ins) do
   g["loaded_" .. plugin] = 1
end
-- vim:foldmethod=marker

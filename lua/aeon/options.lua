local opt = vim.opt
local o = vim.o
local g = vim.g

-------------------------------------- options ------------------------------------------
o.laststatus = 3
o.showmode = false

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "screenline,number"
opt.completeopt = { 'menuone', 'noselect' }
opt.guicursor = {
    [[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50]],
    [[a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor]],
    [[sm:block-blinkwait175-blinkoff150-blinkon175]],
}

-- Indenting
o.wrap = true
o.wrapmargin = 2
o.textwidth = 80
o.autoindent = true
o.expandtab = true
o.shiftwidth = 4
o.smartindent = true
o.tabstop = 4
o.softtabstop = 4

opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250
o.timeoutlen = 500

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- o.titleold = vim.fn.fnamemodify(vim.loop.os_getenv 'SHELL', ':t')
o.title = true
o.titlelen = 70


if g.neovide then
    o.guifont = 'PragmataProLiga Nerd Font:h14'
    g.neovide_transparency = 0.9
    g.neovide_cursor_antialiasing = true
    -- vim.g.neovide_refresh_rate = 75

    -- vim.g.neovide_cursor_vfx_mode = "railgun"
end

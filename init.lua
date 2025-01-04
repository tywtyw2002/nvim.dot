vim.g.dotpath = vim.fn.expand("~/.nvim")
vim.g.vim_dir = vim.fn.expand("~/.nvim")
vim.opt.rtp:prepend(vim.g.dotpath)

------------------------------------------------------------------------
-- Leader bindings
------------------------------------------------------------------------
vim.g.mapleader = "," -- Remap leader key
vim.g.maplocalleader = "\\" -- Local leader is \

local ok, reload = pcall(require, "plenary.reload")
RELOAD = ok and reload.reload_module or function(...)
    return ...
end
function R(name)
    RELOAD(name)
    return require(name)
end

------------------------------------------------------------------------
-- Plugin Configurations
----------------------------------------------------------------------
R("aeon") -- load core paths

R("aeon.core.plugins") -- load plugins

-- load core
-- - Core Functions
-- - Options
-- - Autocommands
R("aeon.core.core") -- load core

R("aeon.core.keymaps")

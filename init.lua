vim.g.dotpath = vim.fn.expand "~/.nvim"
vim.opt.rtp:prepend(vim.g.dotpath)
vim.g.os = vim.loop.os_uname().sysname
vim.g.open_command = vim.g.os == 'Darwin' and 'open' or 'xdg-open'
vim.g.vim_dir = vim.fn.expand '~/.nvim'

-- mason path
vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath "data" .. "/mason/bin"

------------------------------------------------------------------------
-- Leader bindings
------------------------------------------------------------------------
vim.g.mapleader = ',' -- Remap leader key
vim.g.maplocalleader = '\\' -- Local leader is \

local ok, reload = pcall(require, 'plenary.reload')
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
R 'as.globals'
R 'as.autocmds'
R 'as.settings'
--R 'as.highlights'
--R 'as.statusline'
R 'as.plugins'

local fn = vim.fn
local api = vim.api
local fmt = string.format

-----------------------------------------------------------------------------//
-- Global namespace
-----------------------------------------------------------------------------//
--- Inspired by @tjdevries' astraunauta.nvim/ @TimUntersberger's config
--- store all callbacks in one global table so they are able to survive re-requiring this file
_G.__as_global_callbacks = __as_global_callbacks or {}

_G.as = {
  _store = __as_global_callbacks,
  --- work around to place functions in the global scope but namespaced within a table.
  --- TODO: refactor this once nvim allows passing lua functions to mappings
  mappings = {},
}

-- inject mapping helpers into the global namespace
R 'as.utils.mappings'

-----------------------------------------------------------------------------//
-- UI
-----------------------------------------------------------------------------//
-- Consistent store of various UI items to reuse throughout my config
--do
--  local palette = {
--    pale_red = '#E06C75',
--    dark_red = '#be5046',
--    light_red = '#c43e1f',
--    dark_orange = '#FF922B',
--    green = '#98c379',
--    bright_yellow = '#FAB005',
--    light_yellow = '#e5c07b',
--    dark_blue = '#4e88ff',
--    magenta = '#c678dd',
--    comment_grey = '#5c6370',
--    grey = '#3E4556',
--    whitesmoke = '#626262',
--    bright_blue = '#51afef',
--    teal = '#15AABF',
--  }

--  as.style = {
--    icons = {
--      error = '',
--      warn = '',
--      info = '',
--      hint = '',
--    },
--    lsp = {
--      colors = {
--        error = palette.pale_red,
--        warn = palette.dark_orange,
--        hint = palette.bright_yellow,
--        info = palette.teal,
--      },
--      kind_highlights = {
--        Text = 'String',
--        Method = 'Method',
--        Function = 'Function',
--        Constructor = 'TSConstructor',
--        Field = 'Field',
--        Variable = 'Variable',
--        Class = 'Class',
--        Interface = 'Constant',
--        Module = 'Include',
--        Property = 'Property',
--        Unit = 'Constant',
--        Value = 'Variable',
--        Enum = 'Type',
--        Keyword = 'Keyword',
--        File = 'Directory',
--        Reference = 'Preproc',
--        Constant = 'Constant',
--        Struct = 'Type',
--        Event = 'Variable',
--        Operator = 'Operator',
--        TypeParameter = 'Type',
--      },
--      kinds = {
--        Text = '',
--        Method = '',
--        Function = '',
--        Constructor = '',
--        Field = '',
--        Variable = '',
--        Class = '',
--        Interface = '',
--        Module = '',
--        Property = '',
--        Unit = '',
--        Value = '',
--        Enum = '',
--        Keyword = '',
--        Snippet = '',
--        Color = '',
--        File = '',
--        Reference = '',
--        Folder = '',
--        EnumMember = '',
--        Constant = '',
--        Struct = '',
--        Event = '',
--        Operator = '',
--        TypeParameter = '',
--      },
--    },
--    palette = palette,
--  }
--end


local L = vim.log.levels

local installed
---Check if a plugin is on the system not whether or not it is loaded
---@param plugin_name string
---@return boolean
function as.plugin_installed(plugin_name)
  if not installed then
    local dirs = fn.expand(fn.stdpath 'data' .. '/site/pack/packer/start/*', true, true)
    local opt = fn.expand(fn.stdpath 'data' .. '/site/pack/packer/opt/*', true, true)
    vim.list_extend(dirs, opt)
    installed = vim.tbl_map(function(path)
      return fn.fnamemodify(path, ':t')
    end, dirs)
  end
  return vim.tbl_contains(installed, plugin_name)
end

---NOTE: this plugin returns the currently loaded state of a plugin given
---given certain assumptions i.e. it will only be true if the plugin has been
---loaded e.g. lazy loading will return false
---@param plugin_name string
---@return boolean?
function as.plugin_loaded(plugin_name)
  local plugins = packer_plugins or {}
  return plugins[plugin_name] and plugins[plugin_name].loaded
end

---Check whether or not the location or quickfix list is open
---@return boolean
function as.is_vim_list_open()
  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    local location_list = fn.getloclist(0, { filewinid = 0 })
    local is_loc_list = location_list.filewinid > 0
    if vim.bo[buf].filetype == 'qf' or is_loc_list then
      return true
    end
  end
  return false
end

function as._create(f)
  table.insert(as._store, f)
  return #as._store
end

function as._execute(id, args)
  as._store[id](args)
end

---@param command Autocommand
local function is_valid_target(command)
  local valid_type = command.targets and vim.tbl_islist(command.targets)
  return valid_type or vim.startswith(command.events[1], 'User ')
end

---Create an autocommand
---@param name string
---@param commands Autocommand[]
function as.augroup(name, commands)
  vim.cmd('augroup ' .. name)
  vim.cmd 'autocmd!'
  for _, c in ipairs(commands) do
    if c.command and c.events and is_valid_target(c) then
      local command = c.command
      if type(command) == 'function' then
        local fn_id = as._create(command)
        command = fmt('lua as._execute(%s)', fn_id)
      end
      c.events = type(c.events) == 'string' and { c.events } or c.events
      vim.cmd(
        string.format(
          'autocmd %s %s %s %s',
          table.concat(c.events, ','),
          table.concat(c.targets or {}, ','),
          table.concat(c.modifiers or {}, ' '),
          command
        )
      )
    else
      vim.notify(
        fmt('An autocommand in %s is specified incorrectly: %s', name, vim.inspect(name)),
        L.ERROR
      )
    end
  end
  vim.cmd 'augroup END'
end

---Source a lua or vimscript file
---@param path string path relative to the nvim directory
---@param prefix boolean?
function as.source(path, prefix)
  if not prefix then
    vim.cmd(fmt('source %s', path))
  else
    vim.cmd(fmt('source %s/%s', vim.g.vim_dir, path))
  end
end

---Require a module using [pcall] and report any errors
---@param module string
---@param opts table?
---@return boolean, any
function as.safe_require(module, opts)
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    vim.notify(result, L.ERROR, { title = fmt('Error requiring: %s', module) })
  end
  return ok, result
end

---Check if a cmd is executable
---@param e string
---@return boolean
function as.executable(e)
  return fn.executable(e) > 0
end

-- https://stackoverflow.com/questions/1283388/lua-merge-tables
function as.deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == 'table') and (type(t1[k] or false) == 'table') then
      as.deep_merge(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

---A terser proxy for `nvim_replace_termcodes`
---@param str string
---@return any
function as.replace_termcodes(str)
  return api.nvim_replace_termcodes(str, true, true, true)
end

---Find an item in a list
---@generic T
---@param haystack T[]
---@param matcher fun(arg: T):boolean
---@return T
function as.find(haystack, matcher)
  local found
  for _, needle in ipairs(haystack) do
    if matcher(needle) then
      found = needle
      break
    end
  end
  return found
end

---Create an nvim command
---@param args table
function as.command(args)
  local nargs = args.nargs or 0
  local name = args[1]
  local rhs = args[2]
  local types = (args.types and type(args.types) == 'table') and table.concat(args.types, ' ') or ''

  if type(rhs) == 'function' then
    local fn_id = as._create(rhs)
    rhs = string.format('lua as._execute(%d%s)', fn_id, nargs > 0 and ', <f-args>' or '')
  end

  vim.cmd(string.format('command! -nargs=%s %s %s %s', nargs, types, name, rhs))
end
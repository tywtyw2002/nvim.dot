
-- Don't show any numbers inside terminals
vim.cmd [[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]]

-- Don't show status line on certain windows
vim.cmd [[ autocmd BufEnter,BufRead,BufWinEnter,FileType,WinEnter * lua require("as.utils.core").hide_statusline() ]]

-- hightlight text after yank.
vim.cmd [[  au TextYankPost * silent! lua vim.highlight.on_yank{} ]]

-- File autocmds.
vim.cmd([[
augroup _go
  autocmd FileType go set nolist
  autocmd FileType go set noexpandtab
  autocmd FileType go set tabstop=4
  autocmd FileType go set softtabstop=4
  autocmd FileType go set shiftwidth=4
augroup END
]])


vim.cmd([[
augroup _lua
  autocmd FileType lua set nolist
  autocmd FileType lua set noexpandtab
  autocmd FileType lua set tabstop=4
  autocmd FileType lua set softtabstop=4
  autocmd FileType lua set shiftwidth=4
augroup END
]])

vim.cmd([[
augroup _python
  autocmd FileType python set tabstop=4
  autocmd FileType python set shiftwidth=4
  autocmd FileType python set softtabstop=4
  autocmd FileType python set textwidth=79
]])

vim.cmd([[
augroup _sh
  autocmd FileType sh set expandtab
  autocmd FileType sh set tabstop=2
  autocmd FileType sh set shiftwidth=2
augroup END
]])

vim.cmd([[
augroup _toml
  autocmd FileType toml set expandtab
  autocmd FileType toml set shiftwidth=2
  autocmd FileType toml set softtabstop=2
  autocmd FileType toml set tabstop=2
augroup END
]])

vim.cmd([[
augroup _yaml
  autocmd FileType yaml set expandtab
  autocmd FileType yaml set tabstop=2
  autocmd FileType yaml set shiftwidth=2
  autocmd FileType yaml set softtabstop=2
augroup END
]])

--vim.cmd [[ autocmd CursorHold * echon '' ]]
local function clear_commandline()
  --- Track the timer object and stop any previous timers before setting
  --- a new one so that each change waits for 10secs and that 10secs is
  --- deferred each time
  local timer
  return function()
    if timer then
      timer:stop()
    end
    timer = vim.defer_fn(function()
      if vim.fn.mode() == 'n' then
        vim.cmd [[echon '']]
      end
    end, 5000)
  end
end

as.augroup('ClearCommandMessages', {
  {
    events = { 'CmdlineLeave', 'CmdlineChanged' },
    targets = { ':' },
    command = clear_commandline(),
  },
})

-- Reload VIM RC
--vim.api.nvim_add_user_command(
as.command{
  "ReloadConfig",
  function ()
    local ok, msg = pcall(vim.cmd, 'source $MYVIMRC | redraw | silent doautocmd ColorScheme')
    msg = ok and 'sourced ' .. vim.fn.fnamemodify(vim.env.MYVIMRC, ':t') or msg
    vim.notify(msg)
  end
}

as.command{
  "FontSize",
  function (size)
    if size == nil then
        return nil
    end

    local msg = ""
    local e = ""
    local psize = tonumber(size, 10)
    if psize == nil or psize < 8 or psize > 32 then
        msg = "Unable to set font size to <".. size ..">. (8 - 32)"
        e = 'error'
    else
        local font_string = string.match(vim.api.nvim_get_option('guifont'), "[^:]+:h") .. size
        vim.api.nvim_set_option("guifont", font_string)
        msg = "Done. Font Size: " .. size
    end
    vim.notify(msg, e)
  end,
  nargs = 1
}

-- Mapping
require('as.mappings').do_misc_mapping()

-- Don't show any numbers inside terminals
vim.cmd [[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]]

-- Don't show status line on certain windows
vim.cmd [[ autocmd BufEnter,BufRead,BufWinEnter,FileType,WinEnter * lua require("as.utils.core").hide_statusline() ]]


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


-- Mapping
require('as.mappings').do_misc_mapping()
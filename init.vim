set runtimepath+=~/.nvim

scriptencoding utf-8

let s:sourceList = [
  \ 'disabled',
  \ 'plugins',
  \ 'general',
  \ 'autocmds',
  \ 'mapping',
  \ 'plugins.config',
  \ 'style',
  \ 'neovide',
  \]
for s:item in s:sourceList
  exec 'source ' . '~/.nvim/conf/' . s:item . '.vim'
endfor

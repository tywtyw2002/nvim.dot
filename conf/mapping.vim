cmap w!! %!sudo tee >/dev/null %

nnoremap <silent> ;i :set paste!<CR>
" nnoremap <F5> :w<CR>:!/usr/bin/env python % <CR>
" nnoremap <F6> :w<CR>:exe "1,$!" "autopep8 -a -a %"<CR> :w <CR>
"nnoremap <F6> :w<CR>:!autopep8 -i % <CR>
"nnoremap <buffer> <F7> :w<CR>:!aspell -c %<CR>
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
nnoremap <F3> :set noautoindent!<CR>:set nosmartindent!<CR>

let mapleader=','
let maplocalleader='\'

" map <C-z> :Pydoc
"map <C-x> za
imap <C-f> <Right>
imap <C-e> <C-o>$

" Use system clipboard
noremap yp "*y
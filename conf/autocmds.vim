au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.md set filetype=markdown
au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.md set syntax=markdown

""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class


""""""""""""""""""""""""""""""
" => Mini program
""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.acss set syntax=css ft=css
au BufNewFile,BufRead *.axml set syntax=html ft=html
au BufNewFile,BufRead *.wxss set syntax=css ft=css
au BufNewFile,BufRead *.wxml set syntax=html ft=html
au BufNewFile,BufRead *.tmpl set syntax=go ft=go
au BufNewFile,BufRead *.gop set syntax=go ft=go
au BufNewFile,BufRead *.gotmpl set syntax=go ft=go


autocmd! bufwritepost ~/.nvim/init.vim source ~/.nvim/init.vim
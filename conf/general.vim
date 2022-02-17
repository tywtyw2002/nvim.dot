syntax on
set history=700
set tabstop=4
set shiftwidth=4
set expandtab
set fencs=utf-8,gbk
set fileencoding=utf-8
set number
set autoindent
set smartindent
set vb t_vb=
set fileencodings=utf-8,gb18030,utf-16,big5
set backspace=2
set foldmethod=syntax
set foldlevel=99
"set hlsearch
set incsearch
set showmatch
set foldmethod=indent
set laststatus=2
set nocompatible
set nocp

autocmd FileType php setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=79
autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=79
autocmd FileType coffee,javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=79
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=79
autocmd FileType html,htmldjango,xhtml,haml setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=0
autocmd FileType sass,scss,css setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=79

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7
set wildmenu

set wildignore+=.git\*,.hg\*,.svn\*,*/.DS_Store

set ruler

set hid

filetype on
filetype plugin on
filetype indent on
filetype plugin indent on

set autoread
au FocusGained,BufEnter * checktime

set mouse=a

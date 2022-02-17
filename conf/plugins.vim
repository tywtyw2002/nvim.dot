scriptencoding utf-8

call plug#begin()

" File Explorer
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

" Code Completions
Plug 'ms-jpq/coq_nvim'
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'

Plug 'akinsho/bufferline.nvim'  "Tab

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'easymotion/vim-easymotion'
"ggandor/lightspeed.nvim
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'bronson/vim-trailing-whitespace'

"Git
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

Plug 'machakann/vim-highlightedyank'

Plug 'rking/ag.vim'

Plug 'nvim-lualine/lualine.nvim'

Plug 'michaeljsmith/vim-indent-object'

" Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'elzr/vim-json'
Plug 'cespare/vim-toml'
Plug 'plasticboy/vim-markdown'
Plug 'uarun/vim-protobuf'
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

Plug 'vim-scripts/hybrid.vim'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'morhetz/gruvbox'

call plug#end()
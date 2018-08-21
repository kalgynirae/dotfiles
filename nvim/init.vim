set nocompatible
set runtimepath+=/usr/share/vim/vimfiles
runtime bundle/vim-pathogen/autoload/pathogen.vim
if exists("g:loaded_pathogen")
    execute pathogen#infect()
endif
" Syntax highlighting
filetype plugin indent on
syntax enable
let g:molokai_original=1
silent! colo molokai
" Indentation
set shiftwidth=4 softtabstop=-1 expandtab smarttab
" General view settings
set autoindent
set background=dark
set backupcopy=yes
set colorcolumn=81
set cursorline
set display=lastline
set encoding=utf-8
set exrc secure
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
set hlsearch incsearch
set inccommand=nosplit
set laststatus=2
set list listchars=tab:‣\ ,extends:»,precedes:«,nbsp:‧,trail:░
set mouse=
set nowrap
set number
set ruler
set scrolloff=3
set shada='50,h
set showcmd
set spell spelllang=en_us
set splitbelow splitright
set undofile
set wildignore+=*/node_modules/*
set wildmode=list:longest
" Custom shortcuts
nmap <Leader>n :noh<CR>
nmap <Leader>p :setlocal invpaste paste?<CR>
nmap <Leader>m :setlocal invnumber number?<CR>
nmap <Leader>s :setlocal invspell spell?<CR>
nmap <Leader>c :setlocal colorcolumn=<CR>
nmap <Leader>f :setlocal foldmethod=indent<CR>
nmap <Leader>o :colo default<CR>
cmap w!! silent w !sudo tee >/dev/null %
map Q gq
xnoremap p pgvy
" Consistent behavior for Y, D, and C
nmap Y y$
" Emacs shortcuts
cmap <c-a> <Home>
cmap <c-e> <End>
cmap <c-f> <Right>
cmap <c-b> <Left>
imap <c-a> <Home>
imap <c-e> <End>
imap <c-f> <Right>
imap <c-b> <Left>
" Load last cursor position
autocmd BufReadPost * silent! normal! g'"
" Specific language settings
autocmd syntax css setlocal shiftwidth=2
autocmd syntax gitcommit setlocal textwidth=72
autocmd syntax html setlocal shiftwidth=2
autocmd syntax htmldjango setlocal shiftwidth=2
autocmd syntax javascript setlocal shiftwidth=2
autocmd syntax lilypond setlocal shiftwidth=2
autocmd syntax lisp setlocal shiftwidth=2
autocmd syntax markdown setlocal textwidth=80
autocmd syntax pandoc setlocal textwidth=80
autocmd syntax sh setlocal iskeyword+=- shiftwidth=2
autocmd syntax text setlocal iskeyword+=- textwidth=80
autocmd syntax xml setlocal shiftwidth=2
autocmd syntax yaml setlocal shiftwidth=2
" Specific plugin settings
let g:pandoc#syntax#conceal#use=0
let html_no_rendering=1
let python_highlight_string_format=1
let python_highlight_string_formatting=1

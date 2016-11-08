set nocompatible
set encoding=utf-8
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
set autoindent
set softtabstop=4 shiftwidth=4 expandtab smarttab
" Wrapping
set nowrap
set colorcolumn=81
" Backspace operation
set backspace=indent,eol,start
" General view settings
set background=dark
set display=lastline
set hlsearch incsearch
set laststatus=2
set list listchars=tab:‣\ ,extends:»,precedes:«,nbsp:‧,trail:░
set mouse=
set number
set ruler
set scrolloff=3
set shada='50,<1000,h
set showcmd
set splitbelow splitright
" Custom shortcuts
nmap <Leader>n :noh<CR>
nmap <Leader>p :setlocal invpaste paste?<CR>
nmap <Leader>m :setlocal invnumber number?<CR>
nmap <Leader>s :setlocal invspell spell?<CR>
nmap <Leader>c :setlocal colorcolumn=<CR>
nmap <Leader>f :setlocal foldmethod=indent<CR>
cmap w!! silent w !sudo tee >/dev/null %
noremap U <c-r>
" Consistent behavior for Y, D, and C
nmap Y y$
" Emacs shortcuts in insert mode
imap <c-a> <Home>
imap <c-e> <End>
imap <c-f> <Right>
imap <c-b> <Left>
" Emacs shortcuts in commandline mode
cmap <c-a> <Home>
" Spell check
set spelllang=en_us
" Tab completion in commands
set wildmenu wildmode=longest,list
" Project-specific configuration files
set exrc secure
" Count hyphen as a word character
set iskeyword+=-
" Specific language settings
autocmd syntax gitcommit setlocal textwidth=72
autocmd syntax html setlocal sts=2 sw=2
autocmd syntax htmldjango setlocal sts=2 sw=2
autocmd syntax lilypond setlocal sts=2 sw=2
autocmd syntax lisp setlocal sts=2 sw=2
autocmd syntax markdown setlocal textwidth=80
autocmd syntax pandoc setlocal textwidth=80
autocmd syntax text setlocal textwidth=80
autocmd syntax xml setlocal sts=2 sw=2
autocmd syntax yaml setlocal sts=2 sw=2
" Specific plugin settings
let g:pandoc#syntax#conceal#use=0
let python_highlight_string_format=1
let python_highlight_string_formatting=1
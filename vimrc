set nocompatible
set encoding=utf-8
" Syntax highlighting
filetype plugin indent on
syntax enable
" Indentation
set autoindent
set softtabstop=4 shiftwidth=4 expandtab smarttab
" Wrapping
set nowrap
set colorcolumn=81
highlight ColorColumn ctermbg=0
" Backspace operation
set backspace=indent,eol,start
" General view settings
set display=lastline
set hlsearch incsearch
set laststatus=2
set list listchars=tab:‣\ ,extends:»,precedes:«,nbsp:‧,trail:░
set number
set ruler
set scrolloff=3
set showcmd
set viminfo='20,<50,s10,h
" Custom shortcuts
nmap <Leader>n :noh<CR>
nmap <Leader>p :setlocal invpaste paste?<CR>
nmap <Leader>m :setlocal invnumber number?<CR>
nmap <Leader>s :setlocal invspell spell?<CR>
nmap <Leader>c :setlocal colorcolumn= colorcolumn?<CR>
cmap w!! %!sudo tee >/dev/null %
" Consistent behavior for Y, D, and C
nmap Y y$
" Spell check
set spelllang=en_us
" Tab completion in commands
set wildmenu wildmode=longest,list
" Python syntax highlighting options
let g:python_highlight_all = 1
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
autocmd syntax tex setlocal sts=2 sw=2
autocmd syntax text setlocal textwidth=80
autocmd syntax xhtml setlocal sts=2 sw=2
autocmd syntax xml setlocal sts=2 sw=2
autocmd syntax yaml setlocal sts=2 sw=2

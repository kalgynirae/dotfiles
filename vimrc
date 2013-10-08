set nocompatible
set encoding=utf-8
" Syntax highlighting
filetype plugin indent on
syntax enable
" Indentation
set autoindent
set softtabstop=4 shiftwidth=4 expandtab smarttab
autocmd Syntax html,xhtml,htmldjango,tex,lilypond,yaml setlocal ts=2 sts=2 sw=2
" Wrapping
set nowrap
set textwidth=79
autocmd Syntax gitcommit,markdown,pandoc,txt setlocal textwidth=72
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
nmap Y y$
cmap w!! %!sudo tee > /dev/null %
" Spell check
set spelllang=en
" Tab completion in commands
set wildmenu wildmode=longest,list
" Python syntax highlighting options
let g:python_highlight_all = 1
" Project specific configuration files
set exrc secure

set nocompatible
set encoding=utf-8
" Syntax highlighting
filetype plugin indent on
syntax enable
" Indentation
set autoindent
set softtabstop=4 shiftwidth=4 expandtab smarttab
autocmd Syntax html,htmldjango,lilypond,tex,xhtml,xml,yaml setlocal sts=2 sw=2
" Wrapping
set nowrap
set colorcolumn=81
highlight ColorColumn ctermbg=0
autocmd filetype markdown,pandoc,text setlocal textwidth=80
autocmd filetype gitcommit setlocal textwidth=72
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

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
" Backspace operation
set backspace=indent,eol,start
" General view settings
set display=lastline
set hlsearch incsearch
set list listchars=tab:‣\ ,extends:»,precedes:«,nbsp:‧
set number
set ruler
set scrolloff=3
set showcmd
" Custom shortcuts
nmap <Leader>n :noh<CR>
nmap <Leader>p :setlocal invpaste paste?<CR>
nmap <Leader>m :setlocal invnumber number?<CR>
nmap <Leader>s :setlocal invspell spell?<CR>
nmap Y y$
cmap w!! %!sudo tee > /dev/null %
" Spell check
set spelllang=en
" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
" Tab completion in commands
set wildmenu wildmode=longest,list
" vim-python from the AUR
autocmd FileType python set omnifunc=pythoncomplete#Complete
" Project specific configuration files
set exrc secure

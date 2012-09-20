set runtimepath+=/usr/share/lilypond/2.16.0/vim/
filetype plugin indent on
syntax on
" indentation
set expandtab
set tabstop=4 softtabstop=4 shiftwidth=4
set autoindent
autocmd Syntax html setlocal ts=2 sts=2 sw=2
autocmd Syntax htmldjango setlocal ts=2 sts=2 sw=2
autocmd Syntax css setlocal ts=2 sts=2 sw=2
autocmd Syntax tex setlocal ts=2 sts=2 sw=2
" Don't wrap lines
set nowrap
" line numbers
set number
" search highlighting as you type
set hlsearch incsearch
" Use \n to turn off search highlighting
nmap <Leader>n :noh<CR>
" highlighting bad whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
set list listchars=tab:‣\ ,extends:»,precedes:«
" syntax block folding ...
"autocmd Syntax java setlocal foldmethod=syntax
" ... but open files with all blocks unfolded
"autocmd Syntax java normal zR
" scroll before the cursor is all the way at a screen edge
set scrolloff=3
" tab completion of file names in commands
set wildmode=longest,list,full
set wildmenu
" Use tabs for java code
autocmd Syntax java setlocal noexpandtab
" Show partially typed commands
set showcmd
" vim-python from the AUR
autocmd FileType python set omnifunc=pythoncomplete#Complete
" Map command for swapping words separated by a comma
"nmap gt :set opfunc=SwapWords<CR>g@
"function! SwapWords(type, ...)
"    silent exe "normal! `[\"ayt,f,\"cyww\"by`]"

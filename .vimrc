filetype plugin indent on
syntax on
" indentation
set expandtab autoindent
set tabstop=4
set softtabstop=4 shiftwidth=4
" Unusual indentation for specific types
autocmd Syntax html setlocal ts=2 sts=2 sw=2
autocmd Syntax htmldjango setlocal ts=2 sts=2 sw=2
autocmd Syntax css setlocal ts=2 sts=2 sw=2
autocmd Syntax tex setlocal ts=2 sts=2 sw=2
autocmd Syntax markdown setlocal tw=72
autocmd Syntax java setlocal noexpandtab
" General view settings
set hlsearch incsearch
set list listchars=tab:‣\ ,extends:»,precedes:«
set nowrap
set number
set ruler
set scrolloff=3
set showcmd
set textwidth=80
" Custom shortcuts
nmap <Leader>n :noh<CR>
nmap <Leader>p :set invpaste paste?<CR>
nmap <Leader>m :set invnumber<CR>
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

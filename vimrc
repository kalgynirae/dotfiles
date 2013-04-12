filetype plugin indent on
syntax on
" Formatting and indentation
set autoindent
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set textwidth=79
" Backspace operation
set backspace=2
" Unusual formatting for specific types
autocmd Syntax html,xhtml,htmldjango,tex,lilypond,yaml setlocal ts=2 sts=2 sw=2
" General view settings
set hlsearch incsearch
set list listchars=tab:‣\ ,extends:»,precedes:«
set nowrap
set number
set ruler
set scrolloff=3
set showcmd
" Custom shortcuts
nmap <Leader>n :noh<CR>
nmap <Leader>p :setlocal invpaste paste?<CR>
nmap <Leader>m :setlocal invnumber number?<CR>
nmap <Leader>s :setlocal invspell spell?<CR>
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
" Sudo write
cmap w!! %!sudo tee > /dev/null %

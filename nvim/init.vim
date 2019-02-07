set nocompatible
set runtimepath+=/usr/share/vim/vimfiles
colorscheme kalgykai

set autoindent
set backupcopy=yes
set colorcolumn=81
set cursorline
set display=lastline
set encoding=utf-8
set exrc secure
set guicursor=n-v-c-sm:block,i-ci-ve:ver10,r-cr-o:hor20
set hlsearch incsearch
set ignorecase
set inccommand=nosplit
set laststatus=2
set list listchars=tab:‣\ ,extends:»,precedes:«,nbsp:‧,trail:░
set mouse=
set nowrap
set number
set ruler
set scrolloff=3 sidescrolloff=5
set shada='50,h
set shiftwidth=4 softtabstop=-1 expandtab smarttab
set showcmd
set signcolumn=yes
set spell spelllang=en_us
set splitbelow splitright
set termguicolors
set undofile
set wildignore+=*/node_modules/*
set wildmode=list:longest
" Custom shortcuts
nmap \c :setlocal colorcolumn=<CR>
nmap \C :call hexcolor#toggle()<CR>
nmap \f :setlocal foldmethod=indent<CR>
nmap \i :call ShowSyntaxNames()<CR>
nmap \m :setlocal invnumber number?<CR>
nmap \n :noh<CR>
nmap \o :colo default<CR>:set bg=dark<CR>
nmap \p :setlocal invpaste paste?<CR>
nmap \s :setlocal invspell spell?<CR>
cmap w!! silent w !sudo tee >/dev/null %
map Q :ALEFix<CR>
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
" Specific plugin settings
let html_no_rendering=1
let python_highlight_string_format=1
let python_highlight_string_formatting=1
" For debugging color scheme and syntax definitions
function ShowSyntaxNames()
  for id in synstack(line("."), col("."))
    echo synIDattr(id, "name")
  endfor
  echo synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name")
endfunction

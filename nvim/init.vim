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
set inccommand=nosplit
set laststatus=2
set list listchars=tab:‣\ ,extends:»,precedes:«,nbsp:‧,trail:░
set mouse=a
set nowrap
set number
set ruler
set scrolloff=3 sidescrolloff=5
set shada='50,h
set shiftwidth=4 softtabstop=-1 expandtab smarttab
set showcmd
set signcolumn=yes
set smartcase
set spelllang=en_us
set splitbelow splitright
set termguicolors
set undofile
set wildignore+=*/node_modules/*
set wildmode=list:longest

" Custom shortcuts
nmap <Leader>c :setlocal colorcolumn=<CR>
nmap <Leader>C :call hexcolor#toggle()<CR>
nmap <Leader>f :setlocal foldmethod=indent<CR>
nmap <Leader>i :call ShowSyntaxNames()<CR>
nmap <Leader>m :setlocal invnumber number?<CR>
nmap <Leader>n :noh<CR>
nmap <Leader>o :colorscheme default<CR>
nmap <Leader>p :setlocal invpaste paste?<CR>
nmap <Leader>r :call wordhighlight#highlight_under_cursor()<CR>
nmap <Leader>s :setlocal invspell spell?<CR>
nmap <F5> :make<CR>
nmap Q :ALEFix<CR>
nmap gh :ALEPreviousWrap<CR>
nmap gl :ALENextWrap<CR>
cmap w!! silent w !sudo tee >/dev/null %
" Automatically re-yank pasted stuff after pasting
xnoremap p pgvy
" Consistent behavior for Y, D, and C
nmap Y y$
" Emacs editing shortcuts
cmap <c-a> <Home>
cmap <c-e> <End>
cmap <c-f> <Right>
cmap <c-b> <Left>
imap <c-a> <Home>
imap <c-e> <End>
imap <c-f> <Right>
imap <c-b> <Left>

" Plugins
let g:ale_echo_msg_format="[%linter%]%[code]% %s"
let g:ale_lint_on_text_changed="normal"
let g:ale_python_auto_pipenv=1
let g:ctrlp_max_files=2000
let g:ctrlp_root_markers = ['BUCK', 'TARGETS']
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

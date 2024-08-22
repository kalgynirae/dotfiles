set autoindent
set autoread
if $DARK_THEME == "yes"
  set background=dark
else
  set background=light
endif
set backupcopy=yes
set colorcolumn=89
set completeopt=menu
set cursorline
set display=lastline
set encoding=utf-8
set exrc secure
set guicursor=n-v-sm:block-Cursor,i-c-ci-ve:ver20-CursorInsert,o-r-cr:hor20-CursorReplace
set hlsearch incsearch
set inccommand=nosplit
set laststatus=2
set linebreak
set list listchars=tab:‣\ ,extends:»,precedes:«,nbsp:‧,trail:░
set mouse=a
set nowrap
set number
set ruler
set scrolloff=3 sidescrolloff=5
set shada='50,h
set shiftwidth=4 softtabstop=-1 expandtab smarttab
set showcmd
set signcolumn=no
set smartcase
set spelllang=en_us
set splitbelow splitright
set termguicolors
set updatetime=100
set undofile
set wildignore+=*/node_modules/*
set wildignorecase
set wildmode=list:longest

colorscheme kalgykai

" Custom shortcuts
let mapleader = ' '
let maplocalleader = '\'
nnoremap <Leader>l <c-l>
nmap <LocalLeader>c <Cmd>setlocal colorcolumn=<CR>
nmap <LocalLeader>C <Cmd>call hexcolor#toggle()<CR>
nmap <LocalLeader>i <Cmd>call ShowSyntaxNames()<CR>
nmap <LocalLeader>m <Cmd>setlocal invnumber number?<CR>
nmap <LocalLeader>n <Cmd>noh<CR>
nmap <LocalLeader>p <Cmd>setlocal invpaste paste?<CR>
nmap <LocalLeader>r <Cmd>call wordhighlight#highlight_under_cursor()<CR>
nmap <LocalLeader>s <Cmd>setlocal invspell spell?<CR>
nmap <LocalLeader>v <Cmd>setlocal virtualedit=all<CR>
nmap <F5> <Cmd>make<CR>
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
cnoremap <c-p> <Up>
cnoremap <c-n> <Down>
imap <c-a> <Home>
imap <c-e> <End>
imap <c-f> <Right>
imap <c-b> <Left>

" Splits
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
tmap <c-h> <c-\><c-n><c-h>
tmap <c-j> <c-\><c-n><c-j>
tmap <c-k> <c-\><c-n><c-k>
tmap <c-l> <c-\><c-n><c-l>

" Tabs
nmap <c-n> <Cmd>tabnext<CR>
nmap <c-p> <Cmd>tabprevious<CR>
nmap <c-s-n> <Cmd>tabmove +<CR>
nmap <c-s-p> <Cmd>tabmove -<CR>

" Status line
lua require("kalgystatus")
set statusline=%!v:lua.kalgystatus()
set noshowmode

" Terminal
nnoremap <Leader>t <Cmd>terminal<CR><Cmd>let b:overlay_terminal = 1<CR><Cmd>startinsert<CR>
nnoremap <Leader>" <Cmd>split +terminal<CR><Cmd>startinsert<CR>
nnoremap <Leader>% <Cmd>vsplit +terminal<CR><Cmd>startinsert<CR>
tnoremap <c-\><c-h> <c-h>
tnoremap <c-\><c-j> <c-j>
tnoremap <c-\><c-k> <c-k>
tnoremap <c-\><c-l> <c-l>
tnoremap <c-\>p <c-\><c-n>"+pi
tnoremap <c-\>] <c-\><c-n>pi
autocmd TermOpen * setlocal nonumber signcolumn=no
autocmd TermClose * if exists('b:overlay_terminal') | call feedkeys('') | else | exe bufwinnr(str2nr(expand('<abuf>')))..'q' | endif

" Neovide
set guifont=Iosevka\ Term:h18
let g:neovide_cursor_vfx_mode = "pixiedust"
let g:neovide_cursor_animation_length = 0.03
let g:neovide_cursor_vfx_particle_density = 30.0
let g:neovide_cursor_vfx_particle_lifetime = 2.0
let g:neovide_cursor_vfx_particle_speed = 5.0
lua require("kalgyutil")
nmap <C-+> <Cmd>call v:lua.change_guifont_size(1)<CR>
nmap <C--> <Cmd>call v:lua.change_guifont_size(-1)<CR>

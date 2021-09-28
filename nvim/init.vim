colorscheme kalgykai

set autoindent
set autoread
set backupcopy=yes
set colorcolumn=89
set completeopt=menu
set cursorline
set display=lastline
set encoding=utf-8
set exrc secure
set guicursor=n-v-c-sm:block,i-ci-ve:ver10,r-cr-o:hor20
set guifont=Iosevka\ Term:h20
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
set signcolumn=yes:1
set smartcase
set spelllang=en_us
set splitbelow splitright
set termguicolors
set updatetime=100
set undofile
set wildignore+=*/node_modules/*
set wildignorecase
set wildmode=list:longest

" Custom shortcuts
let mapleader = ' '
let maplocalleader = '\'
nnoremap <Leader>l <c-l>
nmap <LocalLeader>c :setlocal colorcolumn=<CR>
nmap <LocalLeader>C :call hexcolor#toggle()<CR>
nmap <LocalLeader>i :call ShowSyntaxNames()<CR>
nmap <LocalLeader>m :setlocal invnumber number?<CR>
nmap <LocalLeader>n :noh<CR>
nmap <LocalLeader>p :setlocal invpaste paste?<CR>
nmap <LocalLeader>r :call wordhighlight#highlight_under_cursor()<CR>
nmap <LocalLeader>s :setlocal invspell spell?<CR>
nmap <LocalLeader>v :setlocal virtualedit=all<CR>
nmap <F5> :make<CR>
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

" For debugging color scheme and syntax definitions
function ShowSyntaxNames()
  for id in synstack(line("."), col("."))
    echo synIDattr(id, "name")
  endfor
  echo synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name")
endfunction

" Plugins
call plug#begin(stdpath('data') . '/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'farmergreg/vim-lastplace'
Plug 'mhartington/formatter.nvim'

" nvim-treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'branch': '0.5-compat', 'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" telescope.nvim
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

call plug#end()

" vim-gitgutter
let g:gitgutter_signs = 0
let g:gitgutter_highlight_linenrs = 1

" vim-tmux-navigator
let g:tmux_navigator_disable_when_zoomed = 1
let g:tmux_navigator_no_mappings = 1
if !empty($TMUX)
  noremap <silent> <c-_>h <cmd>TmuxNavigateLeft<cr>
  noremap <silent> <c-_>j <cmd>TmuxNavigateDown<cr>
  noremap <silent> <c-_>k <cmd>TmuxNavigateUp<cr>
  noremap <silent> <c-_>l <cmd>TmuxNavigateRight<cr>
else
  nmap <c-h> <c-w>h
  nmap <c-j> <c-w>j
  nmap <c-k> <c-w>k
  nmap <c-l> <c-w>l
endif

" formatter.nvim
lua <<EOF
require('formatter').setup {
  filetype = {
    python = {
      function()
        return {
          exe = "isort",
          args = {"--profile=black", '-'},
          stdin = true,
        }
      end,
      function()
        return {
          exe = "black",
          args = {"--quiet", "-"},
          stdin = true,
        }
      end
    },
    rust = {
      function()
        return {
          exe = "rustfmt",
          args = {"-q"},
          stdin = true,
        }
      end
    },
  },
}
EOF
nnoremap Q :Format<CR>

" nvim-treesitter
lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed ={
    "bash",
    "c",
    "cpp",
    "css",
    "html",
    "javascript",
    "json",
    "lua",
    "php",
    "python",
    "regex",
    "rst",
    "ruby",
    "rust",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "yaml",
  },
  highlight = { enable = true },
  incremental_selection = { enable = true },
}
EOF
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99

" telescope.nvim
lua <<EOF
local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
}
EOF
nnoremap <Leader>f <cmd>Telescope find_files theme=get_dropdown<cr>
nnoremap <Leader>g <cmd>Telescope live_grep theme=get_dropdown<cr>

" Neovide
let g:neovide_cursor_vfx_mode = "pixiedust"
let g:neovide_cursor_animation_length = 0.03

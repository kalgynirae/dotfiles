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
noremap <c-h> <c-w>h
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k
noremap <c-l> <c-w>l
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

" Diagnostic
lua <<EOF
vim.diagnostic.config({
  severity_sort = true,
  signs = false,
})
EOF
nmap dn <Cmd>lua vim.diagnostic.goto_next()<CR>
nmap dp <Cmd>lua vim.diagnostic.goto_prev()<CR>

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

" For debugging color scheme and syntax definitions
function ShowSyntaxNames()
  for id in synstack(line("."), col("."))
    echo synIDattr(id, "name")
  endfor
  echo synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name")
endfunction

" Clipboard
let g:clipboard = {
\   'name': 'osc52copy',
\   'copy': {
\     '+': ['copy', '-'],
\   },
\   'paste': {
\     '+': ['cat', '/dev/null'],
\   },
\ }

" Plugins
call plug#begin(stdpath('data') . '/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'farmergreg/vim-lastplace'
Plug 'mhartington/formatter.nvim'
Plug 'neovim/nvim-lspconfig'

" nvim-treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdateSync'}
Plug 'nvim-treesitter/playground'

" telescope.nvim
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

call plug#end()

" nvim-lspconfig
lua <<EOF
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
local util = require('lspconfig.util')

local lsp_attach = function(client)
  vim.api.nvim_buf_set_keymap(0, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", {})
  vim.api.nvim_buf_set_keymap(0, "n", "gD", "<Cmd>lua vim.lsp.buf.implementation()<CR>", {})
  vim.api.nvim_buf_set_keymap(0, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", {})
  vim.api.nvim_buf_set_keymap(0, "n", "Q", "<Cmd>lua vim.lsp.buf.formatting()<CR>", {})
  vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")
  vim.api.nvim_buf_set_option(0, "omnifunc", "v:lua.vim.lsp.omnifunc")
end
lspconfig.rust_analyzer.setup{
  on_attach = lsp_attach,
  handlers = {
    ['window/showStatus'] = vim.lsp.handlers['window/showMessage'],
  },
}
lspconfig.pylsp.setup{
  cmd = { "pipenv", "run", "pylsp" },
  on_attach = lsp_attach,
  handlers = {
    ['window/showStatus'] = vim.lsp.handlers['window/showMessage'],
  },
}
EOF

" vim-gitgutter
let g:gitgutter_signs = 0
let g:gitgutter_highlight_linenrs = 1

" vim-tmux-navigator
let g:tmux_navigator_disable_when_zoomed = 1
let g:tmux_navigator_no_mappings = 1
if !empty($TMUX)
  noremap <silent> <c-_>h <Cmd>TmuxNavigateLeft<CR>
  noremap <silent> <c-_>j <Cmd>TmuxNavigateDown<CR>
  noremap <silent> <c-_>k <Cmd>TmuxNavigateUp<CR>
  noremap <silent> <c-_>l <Cmd>TmuxNavigateRight<CR>
endif

" formatter.nvim
lua <<EOF
require('formatter').setup {
  filetype = {
    javascript = {
      function()
        return {
          exe = "prettier",
          args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
          stdin = true,
        }
      end,
    },
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
  ensure_installed = {
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
nnoremap <Leader>d <Cmd>Telescope diagnostics<CR>
nnoremap <Leader>f <Cmd>Telescope find_files theme=get_dropdown<CR>
nnoremap <Leader>g <Cmd>Telescope live_grep theme=get_dropdown<CR>
nnoremap <Leader>r <Cmd>Telescope lsp_references<CR>
nnoremap <Leader>s <Cmd>Telescope lsp_document_symbols<CR>

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

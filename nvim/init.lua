vim.o.background = vim.env.DARK_THEME == "yes" and "dark" or "light"
vim.o.colorcolumn = "89"
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = -1
vim.o.guicursor = "n-v-sm:block-Cursor,i-c-ci-ve:ver20-CursorInsert,o-r-cr:hor20-CursorReplace,t:block"
vim.o.guifont = "Berkeley Mono Variable"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.breakindentopt = "shift:2,min:40,sbr"
vim.o.showbreak = "↪ "
vim.o.list = true
vim.opt.listchars = { tab = "‣ ", extends = "»", precedes = "«", nbsp = "‧", trail = "░" }
vim.o.number = true
vim.o.scrolloff = 3
vim.o.sidescrolloff = 5
vim.o.spell = true
vim.o.spelllang = "en_us"
vim.o.spelloptions = "camel"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.undofile = true
vim.o.updatetime = 500
vim.opt.wildignore:append("*/node_modules/*")
vim.o.wildignorecase = true
vim.o.wildmode = "list:longest"

vim.cmd.colorscheme("kalgykai")

-- Custom shortcuts #123456
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
local map = vim.keymap.set
map("n", "<Leader>l", "<c-l>")
map("n", "<LocalLeader>c", "<Cmd>setlocal colorcolumn=<CR>")
map("n", "<LocalLeader>C", "<Cmd>call hexcolor#toggle()<CR>")
map("n", "<LocalLeader>m", "<Cmd>setlocal number! number?<CR>")
map("n", "<LocalLeader>n", "<Cmd>noh<CR>")
map("n", "<LocalLeader>p", "<Cmd>setlocal paste! paste?<CR>")
map("n", "<LocalLeader>r", "<Cmd>call wordhighlight#highlight_under_cursor()<CR>")
map("n", "<LocalLeader>s", "<Cmd>setlocal spell! spell?<CR>")
map("n", "<LocalLeader>v", "<Cmd>setlocal virtualedit=all<CR>")
map("n", "<F5>", "<Cmd>make<CR>")
-- Automatically re-yank pasted stuff after pasting
map("x", "p", "pgvy")
-- Emacs editing shortcuts
map({ "c", "i" }, "<c-a>", "<Home>")
map({ "c", "i" }, "<c-e>", "<End>")
map({ "c", "i" }, "<c-f>", "<Right>")
map({ "c", "i" }, "<c-b>", "<Left>")
map("c", "<c-p>", "<Up>")
map("c", "<c-n>", "<Down>")

-- Splits
map("n", "<c-h>", "<c-w>h")
map("n", "<c-j>", "<c-w>j")
map("n", "<c-k>", "<c-w>k")
map("n", "<c-l>", "<c-w>l")
map("t", "<c-h>", [[<c-\><c-n><c-h>]], { remap = true })
map("t", "<c-j>", [[<c-\><c-n><c-j>]], { remap = true })
map("t", "<c-k>", [[<c-\><c-n><c-k>]], { remap = true })
map("t", "<c-l>", [[<c-\><c-n><c-l>]], { remap = true })

-- Tabs
map("n", "<c-n>", "<Cmd>tabnext<CR>")
map("n", "<c-p>", "<Cmd>tabprevious<CR>")
map("n", "<c-s-n>", "<Cmd>tabmove +<CR>")
map("n", "<c-s-p>", "<Cmd>tabmove -<CR>")

-- Status line
require("kalgystatus")
vim.o.statusline = "%!v:lua.kalgystatus()"
vim.o.showmode = false

-- Terminal
map("n", "<Leader>t", function()
  vim.cmd.terminal()
  vim.cmd.startinsert()
end)
map("n", '<Leader>"', "<Cmd>split +terminal<CR><Cmd>startinsert<CR>")
map("n", "<Leader>%", "<Cmd>vsplit +terminal<CR><Cmd>startinsert<CR>")
map("t", [[<c-\><c-h>]], "<c-h>")
map("t", [[<c-\><c-j>]], "<c-j>")
map("t", [[<c-\><c-k>]], "<c-k>")
map("t", [[<c-\><c-l>]], "<c-l>")
map("t", [[<c-\>p]], [[<c-\><c-n>"+pi]])
map("t", "<c-\\>]", [[<c-\><c-n>pi]])

if vim.g.neovide then
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_animation_length = 0.03
  vim.g.neovide_cursor_vfx_particle_density = 30.0
  vim.g.neovide_cursor_vfx_particle_lifetime = 2.0
  vim.g.neovide_cursor_vfx_particle_speed = 5.0
  require("kalgyutil")
  map("n", "<C-+>", function() change_guifont_size(1) end)
  map("n", "<C-->", function() change_guifont_size(-1) end)
end

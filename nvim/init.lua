vim.o.background = vim.env.DARK_THEME == "yes" and "dark" or "light"
vim.o.colorcolumn = "89"
vim.o.cursorline = true
vim.o.guicursor = "n-v-sm:block-Cursor,i-c-ci-ve:ver20-CursorInsert,o-r-cr:hor20-CursorReplace,t:block"
vim.o.guifont = "Berkeley Mono Variable"
vim.o.ignorecase = true
vim.o.number = true
vim.o.scrolloff = 3
vim.o.sidescrolloff = 5
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.undofile = true
vim.o.updatetime = 500

vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = -1

vim.o.linebreak = true
vim.o.breakindent = true
vim.o.breakindentopt = "shift:2,min:40,sbr"
vim.o.showbreak = "↪ "

vim.o.list = true
vim.opt.listchars = { tab = "‣ ", extends = "»", precedes = "«", nbsp = "‧", trail = "░" }

vim.o.spell = true
vim.o.spelllang = "en_us"
vim.o.spelloptions = "camel"

vim.o.wildmode = "list:longest"
vim.o.wildignorecase = true
vim.opt.wildignore:append("*/node_modules/*")

vim.cmd.colorscheme("kalgykai")

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("init-textyankpost", { clear = true }),
  callback = function() vim.hl.on_yank{ timeout = 500 } end,
})

-- Custom shortcuts
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set("n", "<LocalLeader>c", "<Cmd>setlocal colorcolumn=<CR>")
vim.keymap.set("n", "<LocalLeader>C", "<Cmd>call hexcolor#toggle()<CR>")
vim.keymap.set("n", "<LocalLeader>m", "<Cmd>setlocal number! number?<CR>")
vim.keymap.set("n", "<LocalLeader>n", "<Cmd>noh<CR>")
vim.keymap.set("n", "<LocalLeader>p", "<Cmd>setlocal paste! paste?<CR>")
vim.keymap.set("n", "<LocalLeader>r", "<Cmd>call wordhighlight#highlight_under_cursor()<CR>")
vim.keymap.set("n", "<LocalLeader>s", "<Cmd>setlocal spell! spell?<CR>")
vim.keymap.set("n", "<LocalLeader>v", "<Cmd>setlocal virtualedit=all<CR>")
vim.keymap.set("n", "<F5>", "<Cmd>make<CR>")
-- Emacs editing shortcuts
vim.keymap.set({ "c", "i" }, "<c-a>", "<Home>")
vim.keymap.set({ "c", "i" }, "<c-e>", "<End>")
vim.keymap.set({ "c", "i" }, "<c-f>", "<Right>")
vim.keymap.set({ "c", "i" }, "<c-b>", "<Left>")
vim.keymap.set("c", "<c-p>", "<Up>")
vim.keymap.set("c", "<c-n>", "<Down>")

-- Splits
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-l>", "<c-w>l")
vim.keymap.set("t", "<c-h>", [[<c-\><c-n><c-h>]], { remap = true })
vim.keymap.set("t", "<c-j>", [[<c-\><c-n><c-j>]], { remap = true })
vim.keymap.set("t", "<c-k>", [[<c-\><c-n><c-k>]], { remap = true })
vim.keymap.set("t", "<c-l>", [[<c-\><c-n><c-l>]], { remap = true })

-- Tabs
vim.keymap.set("n", "<c-n>", "<Cmd>tabnext<CR>")
vim.keymap.set("n", "<c-p>", "<Cmd>tabprevious<CR>")
vim.keymap.set("n", "<c-s-n>", "<Cmd>tabmove +<CR>")
vim.keymap.set("n", "<c-s-p>", "<Cmd>tabmove -<CR>")

-- Status line
require("kalgystatus")
vim.o.statusline = "%!v:lua.kalgystatus()"
vim.o.showmode = false

-- Diagnostics
vim.diagnostic.config{
  underline = false,
}

-- Terminal
vim.keymap.set("t", [[<c-\><c-h>]], "<c-h>")
vim.keymap.set("t", [[<c-\><c-j>]], "<c-j>")
vim.keymap.set("t", [[<c-\><c-k>]], "<c-k>")
vim.keymap.set("t", [[<c-\><c-l>]], "<c-l>")
vim.keymap.set("t", [[<c-\>p]], [[<c-\><c-n>"+pi]])
vim.keymap.set("t", "<c-\\>]", [[<c-\><c-n>pi]])

-- Neovide
if vim.g.neovide then
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_animation_length = 0.03
  vim.g.neovide_cursor_vfx_particle_density = 30.0
  vim.g.neovide_cursor_vfx_particle_lifetime = 2.0
  vim.g.neovide_cursor_vfx_particle_speed = 5.0
  require("kalgyutil")
  vim.keymap.set("n", "<C-+>", function() change_guifont_size(1) end)
  vim.keymap.set("n", "<C-->", function() change_guifont_size(-1) end)
end

-- Plugins
vim.pack.add{
  { src = "https://github.com/nvim-mini/mini.nvim", version = "stable" },
}
require("mini.surround").setup{
  custom_surroundings = {
    ["("] = { output = { left = "(", right = ")" } },
    ["["] = { output = { left = "[", right = "]" } },
    ["{"] = { output = { left = "{", right = "}" } },
    ["<"] = { output = { left = "<", right = ">" } },
  },
  highlight_duration = 1000,
}

vim.pack.add{
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
}
require("telescope").setup{
}
local builtin = require("telescope.builtin")
local utils = require("telescope.utils")

vim.pack.add{
  { src = "https://github.com/neovim/nvim-lspconfig" },
}
-- TODO: lspconfig stuff?

vim.pack.add{
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
}
require("nvim-treesitter").install{
  "bash",
  "comment",
  "css",
  "desktop",
  "diff",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "html",
  "htmldjango",
  "javascript",
  "jinja",
  "jjdescription",
  "jq",
  "json",
  "lua",
  "markdown",
  "python",
  "rust",
  "starlark",
  "toml",
  "typescript",
  "yaml",
  "zig",
}
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("init-filetype", { clear = true }),
  pattern = { "<filetype>" },
  callback = function(args)
    local buf, filetype = args.buf, args.match
    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end
    if not vim.api.nvim_buf_is_valid(buf) then return end
    if not vim.treesitter.language.add(language) then return end
    vim.treesitter.start(buf, language)
    local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end,
})

-- Leader shortcuts
vim.keymap.set("n", "<Leader>b", builtin.buffers)
vim.keymap.set("n", "<Leader>d", vim.diagnostic.setloclist)
vim.keymap.set("n", "<Leader>f", function() builtin.git_files{ hidden = true } end)
vim.keymap.set("n", "<Leader>F", function() builtin.find_files{ hidden = true, no_ignore = true } end)
vim.keymap.set("n", "<Leader>l", "<c-l>")
vim.keymap.set("n", "<Leader>/", builtin.live_grep)
vim.keymap.set("n", '<Leader>"', "<Cmd>split +terminal<CR><Cmd>startinsert<CR>")
vim.keymap.set("n", "<Leader>%", "<Cmd>vsplit +terminal<CR><Cmd>startinsert<CR>")
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("init-lspattach", { clear = true }),
  callback = function(event)
    vim.keymap.set("n", "<Leader>a", vim.lsp.buf.code_action)
    vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename)

    vim.keymap.set("n", "gd", vim.lsp.buf.definition)
  end,
})


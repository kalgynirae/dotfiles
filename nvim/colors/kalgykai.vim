" kalgynirae's colorscheme
hi clear
let g:colors_name="kalgykai"
set background=dark

function! s:hi(group, guifg, guibg, gui)
  execute "hi" a:group "guifg=".a:guifg "guibg=".a:guibg "gui=".a:gui
endfunction

let s:none = "NONE"
let s:normalbg = "#1c2022"
let s:slightbg = "#232729"
let s:black = "#000000"
let s:darkgrey = "#303436"
let s:darkred = "#4c1713"
let s:darkyellow = "#3a3200"
let s:grey = "#505050"
let s:brightgrey = "#707070"
let s:normalfg = "#a7a7a7"
let s:red = "#b44738"
let s:brightred = "#d2614f"
let s:orange = "#af6423"
let s:brightorange = "#cd7e3c"
let s:yellow = "#a79026"
let s:brightyellow = "#c9b047"
let s:green = "#518921"
let s:brightgreen = "#6ea63f"
let s:cyan = "#008f89"
let s:brightcyan = "#00b2ab"
let s:blue = "#3982ce"
let s:brightblue = "#5799e7"
let s:violet = "#806acc"
let s:brightviolet = "#957fe3"
let s:magenta = "#ae4fa3"
let s:brightmagenta = "#c866bb"
let s:white = "#c0c0c0"
let s:brightwhite = "#e0e0e0"

call s:hi("Normal",         s:normalfg,       s:normalbg,       s:none)
call s:hi("NormalFg",       s:normalfg,       s:none,           s:none)
call s:hi("ColorColumn",    s:none,           s:slightbg,       s:none)
call s:hi("CursorColumn",   s:none,           s:slightbg,       s:none)
call s:hi("CursorLine",     s:none,           s:slightbg,       s:none)
call s:hi("CursorLineNr",   s:grey,           s:slightbg,       "bold")
call s:hi("GitGutterAddLineNr", s:green,      s:none,           s:none)
call s:hi("GitGutterChangeLineNr", s:yellow,  s:none,           s:none)
call s:hi("GitGutterChangeDeleteLineNr", s:orange, s:none,      s:none)
call s:hi("GitGutterDeleteLineNr", s:red,     s:none,           s:none)
call s:hi("LineNr",         s:grey,           s:none,           s:none)
call s:hi("SpellBad",       s:none,           s:darkred,        s:none)
call s:hi("SpellCap",       s:none,           s:darkyellow,     s:none)
call s:hi("SpellLocal",     s:none,           s:darkyellow,     s:none)
call s:hi("SpellRare",      s:none,           s:darkyellow,     s:none)
call s:hi("StatusLine",     s:none,           s:grey,           "bold")
call s:hi("StatusLineNC",   s:brightgrey,     s:darkgrey,       s:none)
call s:hi("Visual",         s:normalfg,       s:normalbg,       "reverse")
call s:hi("VisualNOS",      s:none,           s:none,           "reverse")

call s:hi("Boolean",        s:blue,           s:none,           s:none)
call s:hi("Character",      s:yellow,         s:none,           s:none)
call s:hi("Comment",        s:grey,           s:none,           "italic")
call s:hi("Conditional",    s:brightgrey,     s:none,           "bold")
call s:hi("Constant",       s:violet,         s:none,           s:none)
call s:hi("Debug",          s:brightmagenta,  s:none,           "bold")
call s:hi("Define",         s:cyan,           s:none,           s:none)
call s:hi("Delimiter",      s:brightgrey,     s:none,           s:none)
call s:hi("DiffAdd",        s:green,          s:none,           s:none)
call s:hi("DiffChange",     s:orange,         s:none,           s:none)
call s:hi("DiffDelete",     s:red,            s:none,           s:none)
call s:hi("DiffText",       s:brightgrey,     s:none,           "bold")
call s:hi("Directory",      s:blue,           s:none,           "bold")
call s:hi("Error",          s:red,            s:none,           "italic")
call s:hi("ErrorMsg",       s:red,            s:none,           "bold")
call s:hi("Exception",      s:orange,         s:none,           "bold")
call s:hi("Float",          s:blue,           s:none,           s:none)
call s:hi("FoldColumn",     s:grey,           s:none,           s:none)
call s:hi("Folded",         s:grey,           s:none,           s:none)
call s:hi("Function",       s:green,          s:none,           s:none)
call s:hi("Identifier",     s:none,           s:none,           s:none)
call s:hi("Ignore",         s:brightgrey,     s:none,           s:none)
call s:hi("Include",        s:brightgrey,     s:none,           "bold")
call s:hi("IncSearch",      s:grey,           s:brightyellow,   s:none)
call s:hi("Keyword",        s:brightgrey,     s:none,           "bold")
call s:hi("Label",          s:brightyellow,   s:none,           s:none)
call s:hi("Macro",          s:magenta,        s:none,           "italic")
call s:hi("MatchParen",     s:brightorange,   s:none,           s:none)
call s:hi("ModeMsg",        s:brightyellow,   s:none,           s:none)
call s:hi("MoreMsg",        s:brightyellow,   s:none,           s:none)
call s:hi("NonText",        s:grey,           s:none,           s:none)
call s:hi("Number",         s:blue,           s:none,           s:none)
call s:hi("Operator",       s:brightgrey,     s:none,           s:none)
call s:hi("Pmenu",          s:blue,           s:black,          s:none)
call s:hi("PmenuSbar",      s:blue,           s:black,          s:none)
call s:hi("PmenuSel",       s:blue,           s:grey,           s:none)
call s:hi("PmenuThumb",     s:blue,           s:none,           s:none)
call s:hi("PreCondit",      s:green,          s:none,           "bold")
call s:hi("PreProc",        s:violet,         s:none,           "italic")
call s:hi("Question",       s:cyan,           s:none,           s:none)
call s:hi("Repeat",         s:brightgrey,     s:none,           "bold")
call s:hi("Search",         s:grey,           s:yellow,         s:none)
call s:hi("SignColumn",     s:blue,           s:none,           s:none)
call s:hi("Special",        s:orange,         s:none,           "italic")
call s:hi("SpecialChar",    s:orange,         s:none,           "italic")
call s:hi("SpecialComment", s:brightgrey,     s:none,           s:none)
call s:hi("SpecialKey",     s:cyan,           s:none,           "italic")
call s:hi("Statement",      s:brightgrey,     s:none,           "bold")
call s:hi("StorageClass",   s:brightorange,   s:none,           "italic")
call s:hi("String",         s:yellow,         s:none,           s:none)
call s:hi("Structure",      s:cyan,           s:none,           s:none)
call s:hi("Tag",            s:red,            s:none,           "italic")
call s:hi("Title",          s:brightorange,   s:none,           s:none)
call s:hi("Todo",           s:red,            s:none,           s:none)
call s:hi("Type",           s:cyan,           s:none,           s:none)
call s:hi("Typedef",        s:cyan,           s:none,           s:none)
call s:hi("Underlined",     s:none,           s:none,           "underline")
call s:hi("VertSplit",      s:grey,           s:none,           "bold")
call s:hi("WarningMsg",     s:brightwhite,    s:none,           "bold")
call s:hi("WildMenu",       s:blue,           s:black,          s:none)
call s:hi("diffAdded",      s:green,          s:none,           s:none)
call s:hi("diffFile",       s:white,          s:none,           "bold")
call s:hi("diffIndexLine",  s:white,          s:none,           "bold")
call s:hi("diffLine",       s:cyan,           s:none,           s:none)
call s:hi("diffNewFile",    s:white,          s:none,           "bold")
call s:hi("diffRemoved",    s:red,            s:none,           s:none)
call s:hi("diffSubname",    s:white,          s:none,           "bold")

call s:hi("TSConstBuiltin", s:blue,           s:none,           s:none)
call s:hi("TSFuncBuiltin",  s:green,          s:none,           s:none)
call s:hi("TSParameter",    s:brightgrey,     s:none,           s:none)

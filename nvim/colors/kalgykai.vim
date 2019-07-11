" kalgynirae's colorscheme
hi clear
let g:colors_name="kalgykai"
set background=dark

function! s:hi(group, guifg, guibg, gui)
  execute "hi" a:group "guifg=".a:guifg "guibg=".a:guibg "gui=".a:gui
endfunction

let s:none = "NONE"
let s:normalfg = "#d1d2d0"
let s:normalbg = "#1c2022"
let s:slightbg = "#232729"
let s:black = "#000000"
let s:darkgrey = "#303436"
let s:darkred = "#500c09"
let s:darkyellow = "#4a4800"
let s:grey = "#52595c"
let s:red = "#c81f1f"
let s:orange = "#c8742a"
let s:yellow = "#c4a800"
let s:green = "#4e9a06"
let s:cyan = "#069e98"
let s:blue = "#3c74c0"
let s:violet = "#6050b0"
let s:magenta = "#80487f"
let s:white = "#d1d2d0"
let s:brightgrey = "#6f6f6b"
let s:brightred = "#ef4529"
let s:brightorange = "#f08438"
let s:brightyellow = "#f6db4a"
let s:brightgreen = "#8ad834"
let s:brightcyan = "#34e2c2"
let s:brightblue = "#6492f4"
let s:brightviolet = "#8a71e8"
let s:brightmagenta = "#ad70a4"
let s:brightwhite = "#f8f8f4"

call s:hi("Normal",         s:normalfg,       s:normalbg,       s:none)
call s:hi("ColorColumn",    s:none,           s:slightbg,       s:none)
call s:hi("CursorColumn",   s:none,           s:slightbg,       s:none)
call s:hi("CursorLine",     s:none,           s:slightbg,       s:none)
call s:hi("CursorLineNr",   s:orange,         s:slightbg,       s:none)
call s:hi("SpellBad",       s:none,           s:darkred,        s:none)
call s:hi("SpellCap",       s:none,           s:darkyellow,     s:none)
call s:hi("SpellLocal",     s:none,           s:darkyellow,     s:none)
call s:hi("SpellRare",      s:none,           s:darkyellow,     s:none)
call s:hi("StatusLine",     s:none,           s:grey,           "bold")
call s:hi("StatusLineNC",   s:brightgrey,     s:darkgrey,       s:none)
call s:hi("Visual",         s:none,           s:none,           "reverse")
call s:hi("VisualNOS",      s:none,           s:none,           "reverse")

call s:hi("Boolean",        s:blue,           s:none,           s:none)
call s:hi("Character",      s:yellow,         s:none,           s:none)
call s:hi("Comment",        s:brightgrey,     s:none,           s:none)
call s:hi("Conditional",    s:red,            s:none,           "bold")
call s:hi("Constant",       s:violet,         s:none,           "bold")
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
call s:hi("Identifier",     s:orange,         s:none,           s:none)
call s:hi("Ignore",         s:brightgrey,     s:none,           s:none)
call s:hi("IncSearch",      s:grey,           s:brightyellow,   s:none)
call s:hi("Keyword",        s:brightred,      s:none,           s:none)
call s:hi("Label",          s:brightyellow,   s:none,           s:none)
call s:hi("LineNr",         s:grey,           s:none,           s:none)
call s:hi("Macro",          s:magenta,        s:none,           "italic")
call s:hi("MatchParen",     s:brightorange,   s:none,           s:none)
call s:hi("ModeMsg",        s:brightyellow,   s:none,           s:none)
call s:hi("MoreMsg",        s:brightyellow,   s:none,           s:none)
call s:hi("NonText",        s:grey,           s:none,           s:none)
call s:hi("Number",         s:brightviolet,   s:none,           s:none)
call s:hi("Operator",       s:red,            s:none,           s:none)
call s:hi("Pmenu",          s:blue,           s:black,          s:none)
call s:hi("PmenuSbar",      s:blue,           s:black,          s:none)
call s:hi("PmenuSel",       s:blue,           s:grey,           s:none)
call s:hi("PmenuThumb",     s:blue,           s:none,           s:none)
call s:hi("PreCondit",      s:green,          s:none,           "bold")
call s:hi("PreProc",        s:green,          s:none,           s:none)
call s:hi("Question",       s:cyan,           s:none,           s:none)
call s:hi("Repeat",         s:red,            s:none,           "bold")
call s:hi("Search",         s:grey,           s:yellow,         s:none)
call s:hi("SignColumn",     s:green,          s:none,           s:none)
call s:hi("Special",        s:orange,         s:none,           "italic")
call s:hi("SpecialChar",    s:red,            s:none,           "bold")
call s:hi("SpecialComment", s:brightgrey,     s:none,           s:none)
call s:hi("SpecialKey",     s:grey,           s:none,           s:none)
call s:hi("SpecialKey",     s:cyan,           s:none,           "italic")
call s:hi("Statement",      s:red,            s:none,           "bold")
call s:hi("StorageClass",   s:brightorange,   s:none,           "italic")
call s:hi("String",         s:yellow,         s:none,           s:none)
call s:hi("Structure",      s:cyan,           s:none,           s:none)
call s:hi("Tag",            s:red,            s:none,           "italic")
call s:hi("Title",          s:brightorange,   s:none,           s:none)
call s:hi("Todo",           s:brightwhite,    s:none,           "bold")
call s:hi("Type",           s:cyan,           s:none,           s:none)
call s:hi("Typedef",        s:cyan,           s:none,           s:none)
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

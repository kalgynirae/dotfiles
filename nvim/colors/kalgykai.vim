" kalgynirae's colorscheme
hi clear
let g:colors_name="kalgykai"

function! s:hi(group, guifg, guibg, guisp, gui)
  let args = ""
  if a:guifg != ""
    let args = args." guifg=".a:guifg
  endif
  if a:guibg != ""
    let args = args." guibg=".a:guibg
  endif
  if a:guisp != ""
    let args = args." guisp=".a:guisp
  endif
  if a:gui != ""
    let args = args." gui=".a:gui
  endif
  if args == ""
    let args = "NONE"
  endif
  execute "hi" a:group args
endfunction

let s:none = ""
let s:reset = "NONE"
let s:normalbg = "#1c2022"
let s:slightbg = "#232729"
let s:black = "#000000"
let s:darkgrey = "#303436"
let s:darkred = "#390c00"
let s:darkorange = "#351b00"
let s:darkyellow = "#2e2600"
let s:darkcyan = "#002b29"
let s:darkblue = "#002444"
let s:grey = "#505050"
let s:brightgrey = "#707070"
let s:normalfg = "#a0a0a0"
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

" Note: use "nocombine" in the gui arg to override instead of combining

call s:hi("Normal",         s:normalfg,       s:normalbg,       s:none,           s:none)
call s:hi("NormalFg",       s:normalfg,       s:reset,          s:none,           s:none)
call s:hi("ColorColumn",    s:reset,          s:slightbg,       s:none,           s:none)
call s:hi("Cursor",         s:none,           s:none,           s:none,           "reverse")
call s:hi("CursorInsert",   "bg",             s:brightmagenta,  s:none,           s:reset)
call s:hi("CursorReplace",  "bg",             s:brightmagenta,  s:none,           s:reset)
call s:hi("CursorColumn",   s:reset,          s:slightbg,       s:none,           s:none)
call s:hi("CursorLine",     s:reset,          s:slightbg,       s:none,           s:none)
call s:hi("CursorLineNr",   s:grey,           s:reset,          s:none,           "bold")
call s:hi("GitGutterAddLineNr", s:green,      s:reset,          s:none,           s:none)
call s:hi("GitGutterChangeLineNr", s:yellow,  s:reset,          s:none,           s:none)
call s:hi("GitGutterChangeDeleteLineNr", s:orange, s:reset,     s:none,           s:none)
call s:hi("GitGutterDeleteLineNr", s:red,     s:reset,          s:none,           s:none)
call s:hi("LineNr",         s:grey,           s:reset,          s:none,           s:none)
call s:hi("SpellBad",       s:reset,          s:darkred,        s:red,            s:none)
call s:hi("SpellCap",       s:reset,          s:darkyellow,     s:yellow,         s:none)
call s:hi("SpellLocal",     s:reset,          s:darkyellow,     s:yellow,         s:none)
call s:hi("SpellRare",      s:reset,          s:darkyellow,     s:yellow,         s:none)
call s:hi("TabLine",        s:brightgrey,     s:darkgrey,       s:none,           s:none)
call s:hi("TabLineFill",    s:reset,          s:darkgrey,       s:none,           s:reset)
call s:hi("TabLineSel",     s:reset,          s:grey,           s:none,           "bold")
call s:hi("TermCursor",     "bg",             s:brightviolet,  s:none,           s:reset)
call s:hi("Visual",         s:white,          s:normalbg,       s:none,           "reverse")
call s:hi("VisualNOS",      s:reset,          s:reset,          s:none,           "reverse")

call s:hi("DiagnosticError", s:brightred,     s:reset,          s:none,           "italic")
call s:hi("DiagnosticWarn",  s:brightorange,  s:reset,          s:none,           "italic")
call s:hi("DiagnosticInfo", s:brightblue,     s:reset,          s:none,           "italic")
call s:hi("DiagnosticHint", s:brightcyan,     s:reset,          s:none,           "italic")
call s:hi("DiagnosticUnderlineError", s:none, s:darkred,        s:none,           s:reset)
call s:hi("DiagnosticUnderlineWarn", s:none,  s:darkorange,     s:none,           s:reset)
call s:hi("DiagnosticUnderlineInfo", s:none,  s:darkblue,       s:none,           s:reset)
call s:hi("DiagnosticUnderlineHint", s:none,  s:darkcyan,       s:none,           s:reset)

call s:hi("StatusLine",     s:reset,          s:grey,           s:none,           "bold")
call s:hi("StatusLineNC",   s:brightgrey,     s:darkgrey,       s:none,           s:reset)
call s:hi("User1",          s:normalbg,       s:yellow,         s:none,           "bold")   " replace mode
call s:hi("User2",          s:normalbg,       s:green,          s:none,           "bold")   " insert mode
call s:hi("User3",          s:normalbg,       s:cyan,           s:none,           "bold")   " visual mode
call s:hi("User4",          s:normalbg,       s:blue,           s:none,           "bold")   " (unused)
call s:hi("User5",          s:normalbg,       s:violet,         s:none,           "bold")   " terminal mode
call s:hi("User6",          s:brightred,      s:grey,           s:none,           "bold")   " error count
call s:hi("User7",          s:brightorange,   s:grey,           s:none,           "bold")   " warning count
call s:hi("User8",          s:brightcyan,     s:grey,           s:none,           "bold")   " (unused)
call s:hi("User9",          s:brightblue,     s:grey,           s:none,           "bold")   " (unused)

call s:hi("Boolean",        s:blue,           s:reset,          s:none,           s:none)
call s:hi("Character",      s:yellow,         s:reset,          s:none,           s:none)
call s:hi("Comment",        s:brightgrey,     s:reset,          s:none,           s:none)
call s:hi("Conditional",    s:brightgrey,     s:reset,          s:none,           "bold")
call s:hi("Constant",       s:violet,         s:reset,          s:none,           s:none)
call s:hi("Debug",          s:brightmagenta,  s:reset,          s:none,           "bold")
call s:hi("Define",         s:cyan,           s:reset,          s:none,           s:none)
call s:hi("Delimiter",      s:brightgrey,     s:reset,          s:none,           s:none)
call s:hi("DiffAdd",        s:green,          s:reset,          s:none,           s:none)
call s:hi("DiffChange",     s:orange,         s:reset,          s:none,           s:none)
call s:hi("DiffDelete",     s:red,            s:reset,          s:none,           s:none)
call s:hi("DiffText",       s:brightgrey,     s:reset,          s:none,           "bold")
call s:hi("Directory",      s:blue,           s:reset,          s:none,           "bold")
call s:hi("Error",          s:reset,          s:darkred,        s:none,           s:none)
call s:hi("ErrorMsg",       s:brightred,      s:reset,          s:none,           "italic")
call s:hi("Exception",      s:brightgrey,     s:reset,          s:none,           "bold")
call s:hi("Float",          s:blue,           s:reset,          s:none,           s:none)
call s:hi("FoldColumn",     s:grey,           s:reset,          s:none,           s:none)
call s:hi("Folded",         s:grey,           s:reset,          s:none,           s:none)
call s:hi("Function",       s:green,          s:reset,          s:none,           s:none)
call s:hi("Identifier",     s:reset,          s:reset,          s:none,           s:none)
call s:hi("Ignore",         s:brightgrey,     s:reset,          s:none,           s:none)
call s:hi("Include",        s:brightgrey,     s:reset,          s:none,           "bold")
call s:hi("IncSearch",      s:grey,           s:brightyellow,   s:none,           s:reset)
call s:hi("Keyword",        s:brightgrey,     s:reset,          s:none,           "bold")
call s:hi("Label",          s:brightgrey,     s:reset,          s:none,           "bold")
call s:hi("Macro",          s:magenta,        s:reset,          s:none,           "italic")
call s:hi("MatchParen",     s:brightorange,   s:reset,          s:none,           s:none)
call s:hi("ModeMsg",        s:brightyellow,   s:reset,          s:none,           s:none)
call s:hi("MoreMsg",        s:brightyellow,   s:reset,          s:none,           s:none)
call s:hi("NonText",        s:grey,           s:reset,          s:none,           s:none)
call s:hi("Number",         s:blue,           s:reset,          s:none,           s:none)
call s:hi("Operator",       s:brightgrey,     s:reset,          s:none,           s:none)
call s:hi("Pmenu",          s:reset,          s:black,          s:none,           s:none)
call s:hi("PmenuSel",       s:reset,          s:grey,           s:none,           "bold")
call s:hi("PmenuSbar",      s:reset,          s:darkgrey,       s:none,           s:none)
call s:hi("PmenuThumb",     s:reset,          s:green,          s:none,           s:none)
call s:hi("PreCondit",      s:green,          s:reset,          s:none,           "bold")
call s:hi("PreProc",        s:violet,         s:reset,          s:none,           "italic")
call s:hi("Question",       s:cyan,           s:reset,          s:none,           s:none)
call s:hi("Repeat",         s:brightgrey,     s:reset,          s:none,           "bold")
call s:hi("Search",         s:darkgrey,       s:yellow,         s:none,           s:none)
call s:hi("SignColumn",     s:blue,           s:reset,          s:none,           s:none)
call s:hi("Special",        s:orange,         s:reset,          s:none,           "italic")
call s:hi("SpecialChar",    s:orange,         s:reset,          s:none,           "italic")
call s:hi("SpecialComment", s:green,          s:reset,          s:none,           s:none)
call s:hi("SpecialKey",     s:cyan,           s:reset,          s:none,           "italic")
call s:hi("Statement",      s:brightgrey,     s:reset,          s:none,           "bold")
call s:hi("StorageClass",   s:brightorange,   s:reset,          s:none,           "italic")
call s:hi("String",         s:yellow,         s:reset,          s:none,           s:none)
call s:hi("Structure",      s:cyan,           s:reset,          s:none,           s:none)
call s:hi("Tag",            s:blue,           s:reset,          s:none,           "italic")
call s:hi("Title",          s:brightorange,   s:reset,          s:none,           s:none)
call s:hi("Todo",           s:red,            s:reset,          s:none,           s:none)
call s:hi("Type",           s:cyan,           s:reset,          s:none,           s:reset)
call s:hi("Typedef",        s:cyan,           s:reset,          s:none,           s:none)
call s:hi("Underlined",     s:reset,          s:reset,          s:none,           "underline")
call s:hi("VertSplit",      s:grey,           s:reset,          s:none,           "bold")
call s:hi("WarningMsg",     s:brightwhite,    s:reset,          s:none,           "bold")
call s:hi("WildMenu",       s:blue,           s:black,          s:none,           s:none)
call s:hi("diffAdded",      s:green,          s:reset,          s:none,           s:none)
call s:hi("diffFile",       s:white,          s:reset,          s:none,           "bold")
call s:hi("diffIndexLine",  s:white,          s:reset,          s:none,           "bold")
call s:hi("diffLine",       s:cyan,           s:reset,          s:none,           s:none)
call s:hi("diffNewFile",    s:white,          s:reset,          s:none,           "bold")
call s:hi("diffRemoved",    s:red,            s:reset,          s:none,           s:none)
call s:hi("diffSubname",    s:white,          s:reset,          s:none,           "bold")

call s:hi("htmlLink",       s:reset,          s:reset,          "fg",             "underline")

call s:hi("TSConstBuiltin", s:blue,           s:none,           s:none,           s:none)
call s:hi("TSFuncBuiltin",  s:green,          s:none,           s:none,           s:none)
call s:hi("TSFuncMacro",    s:violet,         s:none,           s:none,           s:none)
call s:hi("TSFunction",     s:green,          s:none,           s:none,           s:none)
call s:hi("TSMethod",       s:green,          s:none,           s:none,           s:none)
call s:hi("TSParameter",    s:brightgrey,     s:none,           s:none,           s:none)
call s:hi("TSType",         s:cyan,           s:none,           s:none,           s:none)
call s:hi("TSVariable",     s:normalfg,       s:reset,          s:none,           s:none)

hi link commentTSConstant TSStrong

hi link docstring Comment
hi link pythonTSNone TSParameter
hi link pythonTSVariableBuiltin TSParameter

hi link rustTSField TSParameter

hi link helpNote SpecialComment
hi link vimCommentTitle SpecialComment

" Note: TS highlight groups get linked to standard nvim groups by default, but
" this seems to happen at some point after the colorscheme is loaded.
" Sometimes I want to remove one of those links (so that highlighting can be
" determined by *other* groups that the item may be in simultaneously). This
" is the only way I've found that successfully gets rid of the link.
augroup kalgykai
  autocmd!
  au BufEnter * hi link TSConstructor NONE
  au BufEnter * hi link TSLiteral NONE
  au BufEnter * hi link TSNamespace NONE
augroup END

let g:terminal_color_0 = s:grey
let g:terminal_color_1 = s:red
let g:terminal_color_2 = s:green
let g:terminal_color_3 = s:yellow
let g:terminal_color_4 = s:blue
let g:terminal_color_5 = s:magenta
let g:terminal_color_6 = s:cyan
let g:terminal_color_7 = s:white
let g:terminal_color_8 = s:brightgrey
let g:terminal_color_9 = s:brightred
let g:terminal_color_10 = s:brightgreen
let g:terminal_color_11 = s:brightyellow
let g:terminal_color_12 = s:brightblue
let g:terminal_color_13 = s:brightmagenta
let g:terminal_color_14 = s:brightcyan
let g:terminal_color_15 = s:brightwhite

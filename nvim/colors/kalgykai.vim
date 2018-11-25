" #d1d2d0 #232729
" #52595c #6b6d68
" #c81f1f #ef2929
" #c8742a #f08438
" #c4a000 #fce94f
" #4e9a06 #8ae234
" #06989a #34e2e2
" #386cb0 #729fcf
" #6050b0 #8e71e0
" #80487f #ad7fa8
" #d1d2d0 #f5f5f0

hi clear
let g:colors_name="kalgykai"

hi Boolean         guifg=#3465a4
hi Character       guifg=#c4a000
hi Number          guifg=#8e71e0
hi String          guifg=#c4a000
hi Conditional     guifg=#c81f1f               gui=bold
hi Constant        guifg=#6050b0               gui=bold
hi Cursor          guifg=#000000 guibg=#F8F8F0
hi iCursor         guifg=#000000 guibg=#F8F8F0
hi Debug           guifg=#BCA3A3               gui=bold
hi Define          guifg=#06989a
hi Delimiter       guifg=#8F8F8F
hi DiffAdd                       guibg=#13354A
hi DiffChange      guifg=#89807D guibg=#4C4745
hi DiffDelete      guifg=#960050 guibg=#1E0010
hi DiffText                      guibg=#4C4745 gui=italic,bold

hi Directory       guifg=#4e9a06               gui=bold
hi Error           guifg=#E6DB74 guibg=#1E0010
hi ErrorMsg        guifg=#c81f1f guibg=#232526 gui=bold
hi Exception       guifg=#c81f1f               gui=bold
hi Float           guifg=#3465a4
hi FoldColumn      guifg=#52595c guibg=#000000
hi Folded          guifg=#52595c guibg=#000000
hi Function        guifg=#4e9a06
hi Identifier      guifg=#c8742a
hi Ignore          guifg=#808080 guibg=none
hi Search          guifg=bg      guibg=fg
hi IncSearch       guifg=bg      guibg=#8ae234 gui=none

hi Keyword         guifg=#ef2929               gui=bold
hi Label           guifg=#E6DB74               gui=none
hi Macro           guifg=#C4BE89               gui=italic
hi SpecialKey      guifg=#06989a               gui=italic

hi MatchParen      guifg=#f08438 guibg=#000000 gui=bold
hi ModeMsg         guifg=#E6DB74
hi MoreMsg         guifg=#E6DB74
hi Operator        guifg=#c81f1f

" complete menu
hi Pmenu           guifg=#06989a guibg=#000000
hi PmenuSel                      guibg=#808080
hi PmenuSbar                     guibg=#080808
hi PmenuThumb      guifg=#06989a

hi PreCondit       guifg=#4e9a06               gui=bold
hi PreProc         guifg=#4e9a06
hi Question        guifg=#06989a
hi Repeat          guifg=#c81f1f               gui=bold
" marks
hi SignColumn      guifg=#4e9a06 guibg=#1c2022
hi SpecialChar     guifg=#c81f1f               gui=bold
hi SpecialComment  guifg=#7E8E91               gui=bold
hi Special         guifg=#c8742a guibg=none      gui=italic
hi SpellBad                      guibg=#540d0d gui=undercurl
hi SpellCap                                    gui=undercurl
hi SpellLocal                                  gui=undercurl
hi SpellRare                                   gui=undercurl
hi Statement       guifg=#c81f1f               gui=bold
hi StatusLine      guifg=#d1d2d0 guibg=#52565c gui=bold
hi StatusLineNC    guifg=#6b6d68 guibg=#303436 gui=none
hi StorageClass    guifg=#FD971F               gui=italic
hi Structure       guifg=#06989a
hi Tag             guifg=#c81f1f               gui=italic
hi Title           guifg=#ef5939
hi Todo            guifg=#FFFFFF guibg=none      gui=bold

hi Typedef         guifg=#06989a
hi Type            guifg=#06989a               gui=none
hi Underlined      guifg=#808080               gui=underline

hi VertSplit       guifg=#808080 guibg=#080808 gui=bold
hi VisualNOS       guifg=none    guibg=none    gui=reverse
hi Visual          guifg=none    guibg=none    gui=reverse
hi WarningMsg      guifg=#FFFFFF guibg=#333333 gui=bold
hi WildMenu        guifg=#06989a guibg=#000000

hi TabLineFill     guifg=#1B1D1E guibg=#1B1D1E
hi TabLine         guibg=#1B1D1E guifg=#808080 gui=none

hi Normal          guifg=#d1d2d0 guibg=#1c2022
hi Comment         guifg=#6b6d68
hi CursorLine                    guibg=#232729
hi CursorLineNr    guifg=#c8742a guibg=#232729 gui=none
hi CursorColumn                  guibg=#232729
hi ColorColumn                   guibg=#232729
hi LineNr          guifg=#52595c
hi NonText         guifg=#52595c
hi SpecialKey      guifg=#52595c

set background=dark

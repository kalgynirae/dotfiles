" Highlights words with different colors!
let s:colors = [
  \ '#4e9a06',
  \ '#386cb0',
  \ '#c4a800',
  \ '#c81f1f',
  \ '#06989a',
  \ '#c8742a',
  \ '#80487f',
  \ '#52595c',
  \ '#6050b0',
  \ '#8ae234',
  \ '#729fcf',
  \ '#fce94f',
  \ '#ef2929',
  \ '#34e2e2',
  \ '#f08438',
  \ '#ad7fa8',
  \ '#6b6d68',
  \ '#8e71e0',
  \ ]

let i = 0
for color in s:colors
  exe 'hi def semantic'.i.' guifg='.color
  let i += 1
endfor

let s:currentColor = 0

set nospell
syntax off

function wordhighlight#highlight_under_cursor()
  let word = expand("<cword>")
  exe 'syn keyword semantic'.s:currentColor.' '.word
  let s:currentColor = (s:currentColor + 1) % len(s:colors)
endfunction

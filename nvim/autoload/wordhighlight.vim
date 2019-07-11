" Highlights words with different colors!
let s:colors = [
  \ '#4e9a06',
  \ '#3c74c0',
  \ '#c4a800',
  \ '#c81f1f',
  \ '#069e98',
  \ '#c8742a',
  \ '#80487f',
  \ '#52595c',
  \ '#6050b0',
  \ '#8ad834',
  \ '#6492f4',
  \ '#f6db4a',
  \ '#ef4529',
  \ '#34e2c2',
  \ '#f08438',
  \ '#ad70a4',
  \ '#6f6f6b',
  \ '#8a71e8',
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

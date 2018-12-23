function! s:create_highlight(color)
  exe 'hi color'.a:color.' guifg=#'.a:color
endfunction

function! s:create_match()
  let fullmatch = submatch(0)
  if has_key(b:hexcolor_syntax_matches, fullmatch)
    return
  endif
  let b:hexcolor_syntax_matches[fullmatch] = 1

  let color = tolower(submatch(1))
  if ! has_key(b:hexcolor_highlight_groups, color)
    let b:hexcolor_highlight_groups[color] = 1
    call s:create_highlight(color)
  endif

  exe 'syn match color'.color.' /'.escape(fullmatch.'\>', '/').'/ contained containedin=@colorableGroups'
  return ''
endfunction

function! s:parse_lines(lines)
  for line in a:lines
    " substitute() seems to be the best way to call a function on every match
    call substitute(line, s:hexcolor_pattern, '\=s:create_match()', 'g')
  endfor
endfunction

function! hexcolor#enable()
  let b:hexcolor_enabled = 1
  if len(b:hexcolor_groups)
    exe 'syn cluster colorableGroups add='.join(b:hexcolor_groups, ',')
  endif
  autocmd Hexcolor TextChanged,TextChangedI <buffer> call s:parse_lines(getline("'[", "']"))
  call s:parse_lines(getline(1, '$'))
endfunction

function! hexcolor#disable()
  let b:hexcolor_enabled = 0
  if len(b:hexcolor_groups)
    exe 'syn cluster colorableGroups remove='.join(b:hexcolor_groups, ',')
  endif
  autocmd! Hexcolor TextChanged,TextChangedI <buffer>
endfunction

function! hexcolor#toggle()
  if ! exists('b:hexcolor_enabled')
    echo "call hexcolor#init() with a list of colorable groups first"
    return
  endif
  if b:hexcolor_enabled
    call hexcolor#disable()
  else
    call hexcolor#enable()
  endif
endfunction

function! hexcolor#recreate_highlights()
  for color in keys(b:hexcolor_highlight_groups)
    call s:create_highlight(color)
  endfor
endfunction

let s:hexcolor_pattern = '\%(0x\|#\)\(\x\{6}\)\>'

function! hexcolor#init(groups)
  let b:hexcolor_groups = extend(get(b:, 'hexcolor_groups', []), split(a:groups, ','), 0)

  if ! exists('b:hexcolor_enabled')
    let b:hexcolor_highlight_groups = {}
    let b:hexcolor_syntax_matches = {}
    augroup Hexcolor
      autocmd ColorScheme <buffer> call s:recreate_highlights()
    augroup END

    call hexcolor#enable()
  endif
endfunction

let b:ale_fixers = ['isort', 'black']
setlocal makeprg=python3\ %

hi link TSConstructor Type
hi link TSMethod Identifier
hi link TSVariable Normal
hi link TSVariableBuiltin TSIdentifier

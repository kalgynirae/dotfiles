; Mark docstrings so they can be highlighted like comments
((module . (expression_statement (string) @docstring)))
((class_definition
  body: (block . (expression_statement (string) @docstring))))
((function_definition
  body: (block . (expression_statement (string) @docstring))))
(((expression_statement (assignment)) . (expression_statement (string) @docstring)))

; Upstream marks these as @constructor; override that
((class_definition
  (block
    (function_definition
      name: (identifier) @method)))
 (#any-of? @method "__new__" "__init__"))

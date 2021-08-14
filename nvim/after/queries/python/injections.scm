; Docstrings
((module . (expression_statement (string) @comment)))
((class_definition
  body: (block . (expression_statement (string) @comment))))
((function_definition
  body: (block . (expression_statement (string) @comment))))
(((expression_statement (assignment)) . (expression_statement (string) @comment)))

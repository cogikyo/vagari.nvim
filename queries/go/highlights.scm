; extends

(source_file
  (_)*
  (comment)+ @comment.documentation.godoc
  .
  (function_declaration
    name: (identifier) @_godoc_name)
  (#go-doc-comment? @comment.documentation.godoc @_godoc_name)
  (#set! "priority" 110))

(source_file
  (_)*
  (comment)+ @comment.documentation.godoc
  .
  (method_declaration
    name: (field_identifier) @_godoc_name)
  (#go-doc-comment? @comment.documentation.godoc @_godoc_name)
  (#set! "priority" 110))

(source_file
  (_)*
  (comment)+ @comment.documentation.godoc
  .
  (type_declaration
    (type_spec
      name: (type_identifier) @_godoc_name))
  (#go-doc-comment? @comment.documentation.godoc @_godoc_name)
  (#set! "priority" 110))

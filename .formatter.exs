# Used by "mix format"
locals_without_parens = [
  ensure_value: 2, ensure_value: 3,
  ensure_bool: 1, ensure_bool: 2, ensure_bool: 3,
  ensure_package: 1, ensure_package: 2,
  ensure_value_match: 2, ensure_value_match: 3,
  ensure_module: 2, ensure_module: 3,
  refute_trystate: 1, refute_trystate: 2
]
[
  inputs: ["mix.exs", "{config,lib,rules,test}/**/*.{ex,exs}"],
  locals_without_parens: locals_without_parens,
  export: [
    locals_without_parens: locals_without_parens
  ]
]

-- https://developer.gnome.org/glib/stable/glib-regex-syntax.html
class ElixirMode
  new: =>
    @lexer = bundle_load 'elixir_lexer'
    @completers = { 'elixir_completer', 'in_buffer' }

  comment_syntax: '#'
  word_pattern: '[%w?_!]+'

  auto_pairs: {
    '(': ')'
    '[': ']'
    '{': '}'
    '"': '"'
    "'": "'"
  }

  default_config: {
    complete: 'manual' -- manually activate completions
    inspectors_on_save: { 'format' }
  }

  indentation: {
    more_after: { -- indentation increase
      r'[({=]\\s*(#.*|)$' -- braces
      r'\\b(do)\\b\\s*(#.*|)$' -- blocks
      r'->\\s*(#.*|)$' -- after arrow
      r'^\\s*else\\b'
    }

    less_for: { -- indentation decrease
      r'^\\s*end\\b'
      '^%s*}'
      r'^\\s*else\\b'
      r'^\\s*\\}\\b'
    }
  }

  code_blocks:
    multiline: {
      { r'(^\\s*|\\s+)do\\s*$', '^%s*end', 'end' },
    }

  structure: (editor) => -- show anything that starts with 'def' and is preceded with possible spaces
    b = editor.buffer
    l = {}
    for line in *b.lines
      if line\match "^%s*def"
        table.insert(l, line)
    l

mode = howl.mode

lexers = {}

{
  lexer: (text, buffer) ->
    base = 'html'
    if buffer
      target_ext = buffer.title\match '%.(%w+)%.eex'
      if target_ext
        m = mode.for_extension target_ext
        base = m.name if m

    l = lexers[base]
    unless l
      l = bundle_load('eex_lexer') base
      lexers[base] = l

    l text

  comment_syntax: { '<%-#', '-%>' }
  auto_pairs: {
    '(': ')'
    '[': ']'
    '{': '}'
    '"': '"'
    "'": "'"
    '<': '>'
  }
}

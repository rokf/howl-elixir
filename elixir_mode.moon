
-- https://developer.gnome.org/glib/stable/glib-regex-syntax.html
-- https://github.com/pkulchenko/serpent

-- serpent = require 'serpent'
pattern_utils = bundle_load 'pattern_utils'

class ElixirMode
  new: =>
    @api = bundle_load 'api'
    @lexer = bundle_load 'elixir_lexer'
    @completers = { 'api','in_buffer' } -- , 'elixir_completer'

  comment_syntax: '#'

  resolve_type: (context) => -- (mode, context) ~ a method
    scope_changes = pattern_utils.find_scope_changers(howl.app.editor.buffer.text)
    pfx = context.prefix
    parts = {}
    all_parts = {}
    all_parts = [p for p in pfx\gmatch '[%w%?_%!]+']
    fname = all_parts[#all_parts]
    leading = pfx\umatch r'((?:\\w+[.:])*\\w+)[.:]\\w*[\\!\\?]?$'
    parts = [p for p in leading\gmatch '[%w%?_%!]+'] if leading
    -- print(leading, serpent.block(parts, {comment: false}), fname)
    for entry in *scope_changes
      if entry.tag == 'import'
        current_scope = @api
        for v in *entry.root_name
          current_scope = current_scope[v]
          if current_scope == nil -- FIX?
            return leading, parts
        if entry.wrapped
          for ve in *entry.wrapped
            w = ve[1]
            if current_scope[w][fname] ~= nil
              t = {}
              for re in *entry.root_name
                table.insert(t,re)
              table.insert(t,w)
              return table.concat(entry.root_name, '.') .. '.' .. w, t
            else
              for k,_ in pairs current_scope[w]
                if string.match(k,fname)
                  t = {}
                  for re in *entry.root_name
                    table.insert(t,re)
                  table.insert(t,w)
                  return table.concat(entry.root_name, '.') .. '.' .. w, t
        else
          if current_scope[fname] ~= nil
            t = {}
            for re in *entry.root_name
              table.insert(t,re)
            return table.concat(entry.root_name, '.'), t
          else
            for k,_ in pairs current_scope
              if string.match(k,fname)
                t = {}
                for re in *entry.root_name
                  table.insert(t,re)
                return table.concat(entry.root_name, '.'), t
      elseif entry.tag == "alias"
        if entry.as
          if leading == table.concat(entry.as,".")
            t = {}
            for re in *entry.root_name
              table.insert(t,re)
            return table.concat(entry.root_name, '.'), t
        else
          if entry.wrapped
            for ve in *entry.wrapped
              w = ve[1]
              if leading == w
                t = {}
                for re in *entry.root_name
                  table.insert(t,re)
                table.insert(t,w)
                return table.concat(entry.root_name, '.') .. '.' .. w, t
          else
            if leading == entry.root_name[#entry.root_name]
              t = {}
              for re in *entry.root_name
                table.insert(t,re)
              return table.concat(entry.root_name, '.'), t

    leading, parts

  auto_pairs: {
    '(': ')'
    '[': ']'
    '{': '}'
    '"': '"'
    "'": "'"
  }

  default_config: {
    complete: 'manual'
    word_pattern: '[%w?_!]+' -- add %d?
    inspectors: { 'elixir' }
    auto_inspect: 'save'
  }

  indentation: {
    more_after: {
      r'[({=]\\s*(--.*|)$' -- hanging operators
      r'\\bdo\\b\\s*(#.*|)$', -- block starters
      { '^%s*if%s+', '%s+end$' }
      r'^\\s*else\\b',
    }

    less_for: {
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

  structure: (editor) =>
    b = editor.buffer
    l = {}
    for line in *b.lines
      if line\match "^%s*def"
        table.insert(l, line)
    l

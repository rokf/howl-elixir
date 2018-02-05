
resolve_type: (context) =>
  scope_changes = pattern_utils.find_scope_changers(howl.app.editor.buffer.text)
  pfx = context.prefix
  parts,all_parts = {},{}
  all_parts = [p for p in pfx\gmatch '[%w%?_%!]+']
  fname = all_parts[#all_parts]
  leading = pfx\umatch r'((?:\\w+[.:])*\\w+)[.:]\\w*[\\!\\?]?$'
  parts = [p for p in leading\gmatch '[%w%?_%!]+'] if leading
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

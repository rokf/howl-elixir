import Process from howl.io
import BufferPopup from howl.ui
import activities from howl

register_modes = () ->
  howl.mode.register
    name: 'elixir'
    extensions: { 'ex', 'exs' }
    create: bundle_load('elixir_mode')
  howl.mode.register
    name: 'eex'
    extensions: { 'eex' }
    create: -> bundle_load('eex_mode')

register_inspectors = () ->
  howl.inspection.register
    name: 'format'
    factory: ->
      c = howl.app.editor.cursor.line
      {
        cmd: 'mix format --check-equivalent <file>'
        parse: (o) ->
          howl.app.editor.buffer\reload true
          howl.app.editor.cursor.line = c
          if #o != 0
            { { line: 1, message: o, type: 'error' } }
          else
            {}
      }
  howl.inspection.register
    name: 'credo'
    factory: (buffer) -> { cmd: "cat <file> | mix credo --format=flycheck --read-from-stdin" }

register_modes!
register_inspectors!

alias_str = () ->
  buf = howl.app.editor.buffer.text
  pat = '(alias[^\n\r;]+)'
  usable = [m for m in string.gmatch(buf,pat)]
  if #usable > 0
    return table.concat(usable,'; ') .. ';'
  else
    return ''

-- CUSTOM COMPLETION
class ElixirCompleter
  complete: (ctx) =>
    oldwp = howl.app.editor.buffer.config.word_pattern
    howl.app.editor.buffer.config.word_pattern = "[.%w?_!]+"
    parts = [p for p in string.gmatch(tostring(ctx.word),"%a+")]
    last = parts[#parts]
    if not string.match(last,"[A-Z]%a*")
      table.remove(parts) -- last is not part of module string
    else
      last = nil -- last is also part of module string
    module = table.concat(parts,'.')
    process = Process {
      cmd: 'elixir -e "import IEx.Helpers; ' .. alias_str! .. ' exports ' .. module .. '"'
      read_stdout: true
      read_stderr: true
    }
    stdout, _ = activities.run_process {title: 'getting completion options with elixir'}, process
    howl.app.editor.buffer.config.word_pattern = oldwp
    if #stdout ~= 0
      exports = [e for e in string.gmatch(stdout, "[?!_%a]+")]
      if last == nil then return exports
      filtered = {}
      for v in *exports
        if string.match(v,last) then table.insert filtered, v
      return filtered
    return {}

howl.completion.register
  name: 'elixir_completer'
  factory: ElixirCompleter

-- COMMANDS
howl.command.register {
  name: 'elixir-doc'
  description: 'Show documentation for the current context'
  input: () ->
    oldwp = howl.app.editor.buffer.config.word_pattern
    howl.app.editor.buffer.config.word_pattern = "[.%w?_!]+"
    ctx = tostring(howl.app.editor.current_context.word)
    process = Process {
      cmd: 'elixir -e "import IEx.Helpers; ' .. alias_str! .. ' h ' .. ctx .. '"'
      read_stdout: true
      read_stderr: true
    }
    stdout, _ = activities.run_process {title: 'fetching docs with elixir'}, process
    howl.app.editor.buffer.config.word_pattern = oldwp
    if #stdout ~= 0
      return stdout
    return nil
  handler: (v) ->
    if not v then return nil
    buf = howl.Buffer howl.mode.by_name('default')
    buf.text = v
    howl.app.editor\show_popup BufferPopup(buf), { position:1 }
}

unload = ->
  howl.mode.unregister 'elixir'
  howl.mode.unregister 'eex'
  howl.inspection.unregister 'format'
  howl.inspection.unregister 'credo'
  howl.completion.unregister 'elixir_completer'
  howl.command.unregister 'elixir-doc'

return {
  info:
    author: 'Rok Fajfar',
    description: 'Elixir bundle for Howl',
    license: 'MIT',
  :unload
}

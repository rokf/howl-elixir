import Process from howl.io
import BufferPopup from howl.ui

serpent = require 'serpent'

-- MODES
mode_reg =
  name: 'elixir'
  extensions: { 'ex', 'exs' }
  create: bundle_load('elixir_mode')

howl.mode.register(mode_reg)

mode_reg_eex =
  name: 'eex'
  extensions: { 'eex' }
  create: -> bundle_load('eex_mode')

howl.mode.register(mode_reg_eex)

-- INSPECTION
howl.inspection.register {
  name: 'elixir'
  factory: ->
    bundle_load 'elixir_inspector'
}

-- CONFIGURATION
howl.config.define({
  name: 'elixir_inspector'
  description: 'Which Elixir inspector to use'
  type_of: 'string'
  options: {
    'credo',
    'format'
  }
})

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
    cmd = 'elixir -e "import IEx.Helpers; ' .. alias_str! .. ' exports ' .. module .. '"'
    process = Process {
      cmd: cmd
      read_stdout: true
    }
    howl.app.editor.buffer.config.word_pattern = oldwp
    process\wait!
    if process.successful
      exports = [e for e in string.gmatch(process.stdout\read_all!, "[?!_%a]+")]
      if last == nil then return exports
      filtered = {}
      for v in *exports
        if string.match(v,last) then table.insert filtered, v
      return filtered
    return {}

howl.completion.register name: 'elixir_completer', factory: ElixirCompleter

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
    }
    howl.app.editor.buffer.config.word_pattern = oldwp
    process\wait!
    if process.successful
      return process.stdout\read_all!
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
  howl.inspection.unregister 'elixir'
  howl.completion.unregister 'elixir_completer'
  howl.command.unregister 'elixir-doc'

return {
  info:
    author: 'Rok Fajfar',
    description: 'Elixir bundle for Howl',
    license: 'MIT',
  :unload
}

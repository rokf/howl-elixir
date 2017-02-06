
mode_reg =
  name: 'elixir'
  extensions: { 'ex', 'exs' }
  create: bundle_load('elixir_mode')

howl.inspection.register {
  name: 'elixir'
  factory: ->
    bundle_load 'elixir_inspector'
}

howl.mode.register(mode_reg)

unload = ->
  howl.mode.unregister 'elixir'
  howl.inspection.unregister 'elixir'

howl.config.define({
  name: 'elixir_linter'
  description: 'The linter which Elixir should use'
  type_of: 'string'
  options: {
    'dogma',
    'credo',
    'none'
  }
})

howl.config.define({
  name: 'elixir_path'
  description: 'Location of Elixir, mix, ...'
  type_of: 'string'
})

return {
  info:
    author: 'Rok Fajfar',
    description: 'Elixir bundle for Howl',
    license: 'MIT',
  :unload
}

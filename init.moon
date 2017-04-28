
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

howl.inspection.register {
  name: 'elixir'
  factory: ->
    bundle_load 'elixir_inspector'
}

unload = ->
  howl.mode.unregister 'elixir'
  howl.mode.unregister 'eex'
  howl.inspection.unregister 'elixir'

howl.config.define({
  name: 'elixir_linter'
  description: 'Chosen Elixir linter'
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

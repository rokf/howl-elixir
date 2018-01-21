credo = bundle_load 'credo_oneline'

import Process from howl.io

general_path = Process.execute('echo $PATH')
home_path = Process.execute('echo $HOME')

insp = (buffer) ->
  proj = howl.Project.for_file(howl.app.editor.buffer.file)
  if proj == nil then return nil
  output = ""
  combined_path = howl.config.elixir_path .. ':' .. general_path
  outp = {}

  if howl.config.elixir_linter == 'credo'
    output = Process.execute('mix credo --format=oneline', {
      working_directory: proj.root.path
      env: {
        HOME: home_path
        PATH: combined_path
        LC_ALL: 'en_US.UTF-8'
      }
    })
    outp = credo.parse(output, howl.app.editor.buffer.file, proj.root.path)
  else
    return nil

  if #outp == 0 then return nil
  return outp

return insp

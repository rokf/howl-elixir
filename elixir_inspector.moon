
dogma = bundle_load 'dogma_parser'
credo = bundle_load 'credo_parser'

import Process from howl.io

general_path = Process.execute('echo $PATH')
home_path = Process.execute('echo $HOME')

insp = (buffer) ->
  proj = howl.Project.for_file(howl.app.editor.buffer.file)
  if proj == nil then return nil
  output = ""
  combined_path = howl.config.elixir_path .. ':' .. general_path
  print(combined_path)
  outp = {}
  if howl.config.elixir_linter == 'credo'
    output, err = Process.execute('mix credo', {
      working_directory: proj.root.path
      env: {
        HOME: home_path
        PATH: combined_path
        LC_ALL: 'en_US.UTF-8'
      }
    })
    print('ERR',err)
    outp = credo.parse(output, howl.app.editor.buffer.file, proj.root.path)
  elseif howl.config.elixir_linter == 'dogma'
    output, err = Process.execute('mix dogma', {
      working_directory: proj.root.path
      env: {
        HOME: home_path
        PATH: combined_path
        LC_ALL: 'en_US.UTF-8'
      }
    })
    print('ERR',err)
    outp = dogma.parse(output, howl.app.editor.buffer.file, proj.root.path)
  else -- 'none'
    return nil

  if #outp == 0 then return nil
  return outp

return insp

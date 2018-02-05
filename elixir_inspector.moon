credo = bundle_load 'credo_oneline'

import Process from howl.io

insp = (buffer) ->
  proj = howl.Project.for_file(howl.app.editor.buffer.file)
  if not proj then return nil
  if not howl.config.elixir_inspector then return nil
  file_only_path = string.match(string.format('%s',howl.app.editor.buffer.file),
    proj.root.path .. '/' .. '(.+)'
  )

  outp = {}

  if howl.config.elixir_inspector == 'credo'
    output = Process.execute('mix credo --format=oneline', {
      working_directory: proj.root.path
    })
    outp = credo.parse(output, howl.app.editor.buffer.file, proj.root.path)
  elseif howl.config.elixir_inspector == 'format'
    process = Process {
      cmd: "mix format --dry-run --check-equivalent #{file_only_path}"
      working_directory: proj.root.path
      read_stderr: true
    }

    -- show all the messages inside one inspection
    stderr = process.stderr\read_all!
    if stderr == "" or nil then return nil
    outp = { { line: 1, message: stderr, type: 'error' } }

  if #outp == 0 then return nil
  return outp

return insp

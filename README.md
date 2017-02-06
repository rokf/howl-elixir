#### Elixir bundle for Howl

**Includes**:
- API **completion** and **docs** with respect for imports and aliases
- static source checks via **dogma** or **credo**
- syntax highlighting
- structure view

**Configuration variables:**
- elixir_linter : either `dogma`, `credo` or `none`
- elixir_path : a string, example: `/home/rokf/.asdf/bin:/home/rokf/.asdf/shims`

The path is prepended to the `PATH` env variable used by Howl so that `mix` and other
needed executables for Elixir can be found.

**Installation:**
`git clone` into `~/.howl/bundles`

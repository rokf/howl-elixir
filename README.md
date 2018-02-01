<p align="center"> <img width="150" src="elixir.png"> </p>

**Includes**:
- API **completion** and **docs** with respect for imports and aliases
- static source checks/formating via **credo** or **mix format**
- syntax highlighting

**Configuration variables:**
- elixir_inspector : either `credo`, `format` or `none`
- elixir_path : a string, example: `/home/rokf/.asdf/bin:/home/rokf/.asdf/shims`

The path is prepended to the `PATH` env variable used by Howl so that `mix` and other
needed executables for Elixir can be found.

**Installation:**
- `git clone` into `~/.howl/bundles`

**Dependencies:**
- `lpeg` (@**luarocks**)
- `serpent` (@**luarocks**)
- `lfs` (@**luarocks**)
- `elixir` and `mix` ofc

**API generation:**
To generate your own `api.lua` file you have to
- write a gsources.lua file next to `apigen.moon`
- it has to return a table with strings, those are paths the script should use to generate the API
- call `moon apigen.moon` and the new `api.lua` file will be generated

**Notes:**
- The **project path** in Howl has to point to the root of your **mix** project.

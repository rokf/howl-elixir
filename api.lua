return {
  A = {
    __before_compile__ = {
      description = "@spec`\n    * `@typep` - defines a private type to be used in `@spec`\n    * `@opaque` - defines an opaque type to be used in `@spec`\n    * `@spec` - provides a specification for a function\n    * `@callback` - provides a specification for a behaviour callback\n    * `@macrocallback` - provides a specification for a macro behaviour callback\n    * `@optional_callbacks` - specifies which behaviour callbacks and macro\n      behaviour callbacks are optional\n\n  ### Custom attributes\n\n  In addition to the built-in attributes outlined above, custom attributes may\n  also be added. A custom attribute is any valid identifier prefixed with an\n  `@` and followed by a valid Elixir value:\n\n      defmodule M do\n        @custom_attr [some: \"stuff\"]\n      end\n\n  For more advanced options available when defining custom attributes, see\n  `register_attribute/3`.\n\n  ## Compile callbacks\n\n  There are three callbacks that are invoked when functions are defined,\n  as well as before and immediately after the module bytecode is generated.\n\n  ### @after_compile\n\n  A hook that will be invoked right after the current module is compiled.\n\n  Accepts a module or a tuple `{<module>, <function atom>}`. The function\n  must take two arguments: the module environment and its bytecode.\n  When just a module is provided, the function is assumed to be\n  `__after_compile__/2`.\n\n  #### Example\n\n      defmodule M do\n        @after_compile __MODULE__\n\n        \n__before_compile__(_env)\n"
    },
    hello = {
      description = "\nhello\n"
    }
  },
  Access = {
    at = {
      description = "\nat(index) when index >= 0 \n\n  Returns a function that accesses the element at `index` (zero based) of a list.\n\n  The returned function is typically passed as an accessor to `Kernel.get_in/2`,\n  `Kernel.get_and_update_in/3`, and friends.\n\n  ## Examples\n\n      iex> list = [%{name: \"john\"}, %{name: \"mary\"}]\n      iex> get_in(list, [Access.at(1), :name])\n      \"mary\"\n      iex> get_and_update_in(list, [Access.at(0), :name], fn\n      ...>   prev -> {prev, String.upcase(prev)}\n      ...> end)\n      {\"john\", [%{name: \"JOHN\"}, %{name: \"mary\"}]}\n\n  `at/1` can also be used to pop elements out of a list or\n  a key inside of a list:\n\n      iex> list = [%{name: \"john\"}, %{name: \"mary\"}]\n      iex> pop_in(list, [Access.at(0)])\n      {%{name: \"john\"}, [%{name: \"mary\"}]}\n      iex> pop_in(list, [Access.at(0), :name])\n      {\"john\", [%{}, %{name: \"mary\"}]}\n\n  When the index is out of bounds, `nil` is returned and the update function is never called:\n\n      iex> list = [%{name: \"john\"}, %{name: \"mary\"}]\n      iex> get_in(list, [Access.at(10), :name])\n      nil\n      iex> get_and_update_in(list, [Access.at(10), :name], fn\n      ...>   prev -> {prev, String.upcase(prev)}\n      ...> end)\n      {nil, [%{name: \"john\"}, %{name: \"mary\"}]}\n\n  An error is raised for negative indexes:\n\n      iex> get_in([], [Access.at(-1)])\n      ** (FunctionClauseError) no function clause matching in Access.at/1\n\n  An error is raised if the accessed structure is not a list:\n\n      iex> get_in(%{}, [Access.at(1)])\n      ** (RuntimeError) Access.at/1 expected a list, got: %{}\n  "
    },
    description = "\n  Key-based access to data structures using the `data[key]` syntax.\n\n  Elixir provides two syntaxes for accessing values. `user[:name]`\n  is used by dynamic structures, like maps and keywords, while\n  `user.name` is used by structs. The main difference is that\n  `user[:name]` won't raise if the key `:name` is missing but\n  `user.name` will raise if there is no `:name` key.\n\n  Besides the cases above, this module provides convenience\n  functions for accessing other structures, like `at/1` for\n  lists and `elem/1` for tuples. Those functions can be used\n  by the nested update functions in `Kernel`, such as\n  `Kernel.get_in/2`, `Kernel.put_in/3`, `Kernel.update_in/3`,\n  `Kernel.get_and_update_in/3` and friends.\n\n  ## Dynamic lookups\n\n  Out of the box, `Access` works with `Keyword` and `Map`:\n\n      iex> keywords = [a: 1, b: 2]\n      iex> keywords[:a]\n      1\n\n      iex> map = %{a: 1, b: 2}\n      iex> map[:a]\n      1\n\n      iex> star_ratings = %{1.0 => \"★\", 1.5 => \"★☆\", 2.0 => \"★★\"}\n      iex> star_ratings[1.5]\n      \"★☆\"\n\n  Note that the dynamic lookup syntax (`term[key]`) roughly translates to\n  `Access.get(term, key, nil)`.\n\n  `Access` can be combined with `Kernel.put_in/3` to put a value\n  in a given key:\n\n      iex> map = %{a: 1, b: 2}\n      iex> put_in map[:a], 3\n      %{a: 3, b: 2}\n\n  This syntax is very convenient as it can be nested arbitrarily:\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> put_in users[\"john\"][:age], 28\n      %{\"john\" => %{age: 28}, \"meg\" => %{age: 23}}\n\n  Furthermore, `Access` transparently ignores `nil` values:\n\n      iex> keywords = [a: 1, b: 2]\n      iex> keywords[:c][:unknown]\n      nil\n\n  Since `Access` is a behaviour, it can be implemented for key-value\n  data structures. The implementation should be added to the\n  module that defines the struct being accessed. `Access` requires the\n  key comparison to be implemented using the `===` operator.\n\n  ## Static lookups\n\n  The `Access` syntax (`foo[bar]`) cannot be used to access fields in\n  structs, since structs do not implement the `Access` behaviour by\n  default. It is also a design decision: the dynamic access lookup\n  is meant to be used for dynamic key-value structures, like maps\n  and keywords, and not by static ones like structs (where fields are\n  known and not dynamic).\n\n  Therefore Elixir provides a static lookup for struct fields and for atom\n  fields in maps. Imagine a struct named `User` with a `:name` field.\n  The following would raise:\n\n      user = %User{name: \"John\"}\n      user[:name]\n      # ** (UndefinedFunctionError) undefined function User.fetch/2\n      #    (User does not implement the Access behaviour)\n\n  Structs instead use the `user.name` syntax to access fields:\n\n      user.name\n      #=> \"John\"\n\n  The same `user.name` syntax can also be used by `Kernel.put_in/2`\n  for updating structs fields:\n\n      put_in user.name, \"Mary\"\n      #=> %User{name: \"Mary\"}\n\n  Differently from `user[:name]`, `user.name` is not extensible via\n  a behaviour and is restricted only to structs and atom keys in maps.\n\n  As mentioned above, this works for atom keys in maps as well. Refer to the\n  `Map` module for more information on this.\n\n  Summing up:\n\n    * `user[:name]` is used by dynamic structures, is extensible and\n      does not raise on missing keys\n    * `user.name` is used by static structures, it is not extensible\n      and it will raise on missing keys\n\n  ## Accessors\n\n  While Elixir provides built-in syntax only for traversing dynamic\n  and static key-value structures, this module provides convenience\n  functions for traversing other structures, like tuples and lists,\n  to be used alongside `Kernel.put_in/2` in others.\n\n  For instance, given a user with a list of languages, here is how to\n  deeply traverse the map and convert all language names to uppercase:\n\n      iex> user = %{name: \"john\",\n      ...>          languages: [%{name: \"elixir\", type: :functional},\n      ...>                      %{name: \"c\", type: :procedural}]}\n      iex> update_in user, [:languages, Access.all(), :name], &String.upcase/1\n      %{name: \"john\",\n        languages: [%{name: \"ELIXIR\", type: :functional},\n                    %{name: \"C\", type: :procedural}]}\n\n  See the functions `key/1`, `key!/1`, `elem/1`, and `all/0` for some of the\n  available accessors.\n\n  ## Implementing the Access behaviour for custom data structures\n\n  In order to be able to use the `Access` protocol with custom data structures\n  (which have to be structs), such structures have to implement the `Access`\n  behaviour. For example, for a `User` struct, this would have to be done:\n\n      defmodule User do\n        defstruct [:name, :email]\n\n        @behaviour Access\n        # Implementation of the Access callbacks...\n      end\n\n  ",
    elem = {
      description = "\nelem(index) when is_integer(index) \n\n  Returns a function that accesses the element at the given index in a tuple.\n\n  The returned function is typically passed as an accessor to `Kernel.get_in/2`,\n  `Kernel.get_and_update_in/3`, and friends.\n\n  Raises if the index is out of bounds.\n\n  ## Examples\n\n      iex> map = %{user: {\"john\", 27}}\n      iex> get_in(map, [:user, Access.elem(0)])\n      \"john\"\n      iex> get_and_update_in(map, [:user, Access.elem(0)], fn\n      ...>   prev -> {prev, String.upcase(prev)}\n      ...> end)\n      {\"john\", %{user: {\"JOHN\", 27}}}\n      iex> pop_in(map, [:user, Access.elem(0)])\n      ** (RuntimeError) cannot pop data from a tuple\n\n  An error is raised if the accessed structure is not a tuple:\n\n      iex> get_in(%{}, [Access.elem(0)])\n      ** (RuntimeError) Access.elem/1 expected a tuple, got: %{}\n\n  "
    },
    fetch = {
      description = "\nfetch(nil, _key)\n\nfetch(list, key) when is_list(list) \n\nfetch(list, key) when is_list(list) and is_atom(key) \n\nfetch(map, key) when is_map(map) \n@spec fetch(t, term) :: {:ok, term} | :error\n  \nfetch(%{__struct__: struct} = container, key)\n\n  Fetches the value for the given key in a container (a map, keyword\n  list, or struct that implements the `Access` behaviour).\n  "
    },
    get_and_update = {
      description = "\nget_and_update(nil, key, _fun)\n\nget_and_update(list, key, fun) when is_list(list) \n\nget_and_update(map, key, fun) when is_map(map) \n@spec get_and_update(container :: t, key, (value -> {get_value, update_value} | :pop)) ::\n        {get_value, container :: t} when get_value: var, update_value: value\n  \nget_and_update(%{__struct__: struct} = container, key, fun)\n\n  Gets and updates the given key in a container (a map, keyword\n  list, or struct that implements the `Access` behaviour).\n\n  This `fun` argument receives the value of `key` (or `nil` if `key`\n  is not present) and must return a two-element tuple: the \"get\" value\n  (the retrieved value, which can be operated on before being returned)\n  and the new value to be stored under `key`. The `fun` may also\n  return `:pop`, implying the current value shall be removed\n  from the container and returned.\n\n  The returned value is a two-element tuple with the \"get\" value returned by\n  `fun` and a new container with the updated value under `key`.\n  "
    },
    key = {
      description = "\nkey(key, default \\\\ nil)\n  Returns a function that accesses the given key in a map/struct.\n\n  The returned function is typically passed as an accessor to `Kernel.get_in/2`,\n  `Kernel.get_and_update_in/3`, and friends.\n\n  The returned function uses the default value if the key does not exist.\n  This can be used to specify defaults and safely traverse missing keys:\n\n      iex> get_in(%{}, [Access.key(:user, %{}), Access.key(:name)])\n      nil\n\n  Such is also useful when using update functions, allowing us to introduce\n  values as we traverse the data-structure for updates:\n\n      iex> put_in(%{}, [Access.key(:user, %{}), Access.key(:name)], \"Mary\")\n      %{user: %{name: \"Mary\"}}\n\n  ## Examples\n\n      iex> map = %{user: %{name: \"john\"}}\n      iex> get_in(map, [Access.key(:unknown, %{}), Access.key(:name, \"john\")])\n      \"john\"\n      iex> get_and_update_in(map, [Access.key(:user), Access.key(:name)], fn\n      ...>   prev -> {prev, String.upcase(prev)}\n      ...> end)\n      {\"john\", %{user: %{name: \"JOHN\"}}}\n      iex> pop_in(map, [Access.key(:user), Access.key(:name)])\n      {\"john\", %{user: %{}}}\n\n  An error is raised if the accessed structure is not a map or a struct:\n\n      iex> get_in(nil, [Access.key(:foo)])\n      ** (BadMapError) expected a map, got: nil\n\n      iex> get_in([], [Access.key(:foo)])\n      ** (BadMapError) expected a map, got: []\n\n  \nkey :: any\n"
    },
    ["key!"] = {
      description = "\nkey!(key)\n\n  Returns a function that accesses the given key in a map/struct.\n\n  The returned function is typically passed as an accessor to `Kernel.get_in/2`,\n  `Kernel.get_and_update_in/3`, and friends.\n\n  Raises if the key does not exist.\n\n  ## Examples\n\n      iex> map = %{user: %{name: \"john\"}}\n      iex> get_in(map, [Access.key!(:user), Access.key!(:name)])\n      \"john\"\n      iex> get_and_update_in(map, [Access.key!(:user), Access.key!(:name)], fn\n      ...>   prev -> {prev, String.upcase(prev)}\n      ...> end)\n      {\"john\", %{user: %{name: \"JOHN\"}}}\n      iex> pop_in(map, [Access.key!(:user), Access.key!(:name)])\n      {\"john\", %{user: %{}}}\n      iex> get_in(map, [Access.key!(:user), Access.key!(:unknown)])\n      ** (KeyError) key :unknown not found in: %{name: \\\"john\\\"}\n\n  An error is raised if the accessed structure is not a map/struct:\n\n      iex> get_in([], [Access.key!(:foo)])\n      ** (RuntimeError) Access.key!/1 expected a map/struct, got: []\n\n  "
    },
    pop = {
      description = "\npop(nil, key)\n\npop(list, key) when is_list(list) \n\npop(map, key) when is_map(map) \n\npop(%{__struct__: struct} = container, key)\n\n  Removes the entry with a given key from a container (a map, keyword\n  list, or struct that implements the `Access` behaviour).\n\n  Returns a tuple containing the value associated with the key and the\n  updated container. `nil` is returned for the value if the key isn't\n  in the container.\n\n  ## Examples\n\n  With a map:\n\n      iex> Access.pop(%{name: \"Elixir\", creator: \"Valim\"}, :name)\n      {\"Elixir\", %{creator: \"Valim\"}}\n\n  A keyword list:\n\n      iex> Access.pop([name: \"Elixir\", creator: \"Valim\"], :name)\n      {\"Elixir\", [creator: \"Valim\"]}\n\n  An unknown key:\n\n      iex> Access.pop(%{name: \"Elixir\", creator: \"Valim\"}, :year)\n      {nil, %{creator: \"Valim\", name: \"Elixir\"}}\n\n  "
    },
    t = {
      description = "t :: list | map | nil | any\n"
    },
    value = {
      description = "value :: any\n"
    }
  },
  Agent = {
    Server = {
      code_change = {
        description = "\ncode_change(_old, state, fun)\n"
      },
      description = "false",
      handle_call = {
        description = "\nhandle_call(msg, from, state)\n\nhandle_call({:update, fun}, _from, state)\n\nhandle_call({:get_and_update, fun}, _from, state)\n\nhandle_call({:get, fun}, _from, state)\n"
      },
      handle_cast = {
        description = "\nhandle_cast(msg, state)\n\nhandle_cast({:cast, fun}, state)\n"
      },
      init = {
        description = "\ninit(fun)\n"
      }
    },
    agent = {
      description = "agent :: pid | {atom, node} | name\n"
    },
    description = "\n  Agents are a simple abstraction around state.\n\n  Often in Elixir there is a need to share or store state that\n  must be accessed from different processes or by the same process\n  at different points in time.\n\n  The Agent module provides a basic server implementation that\n  allows state to be retrieved and updated via a simple API.\n\n  ## Examples\n\n  For example, in the Mix tool that ships with Elixir, we need\n  to keep a set of all tasks executed by a given project. Since\n  this set is shared, we can implement it with an Agent:\n\n      defmodule Mix.TasksServer do\n        def start_link do\n          Agent.start_link(fn -> MapSet.new end, name: __MODULE__)\n        end\n\n        @doc \"Checks if the task has already executed\"\n        def executed?(task, project) do\n          item = {task, project}\n          Agent.get(__MODULE__, fn set ->\n            item in set\n          end)\n        end\n\n        @doc \"Marks a task as executed\"\n        def put_task(task, project) do\n          item = {task, project}\n          Agent.update(__MODULE__, &MapSet.put(&1, item))\n        end\n\n        @doc \"Resets the executed tasks and returns the previous list of tasks\"\n        def take_all() do\n          Agent.get_and_update(__MODULE__, fn set ->\n            {Enum.into(set, []), MapSet.new}\n          end)\n        end\n      end\n\n  Note that agents still provide a segregation between the\n  client and server APIs, as seen in GenServers. In particular,\n  all code inside the function passed to the agent is executed\n  by the agent. This distinction is important because you may\n  want to avoid expensive operations inside the agent, as it will\n  effectively block the agent until the request is fulfilled.\n\n  Consider these two examples:\n\n      # Compute in the agent/server\n      def get_something(agent) do\n        Agent.get(agent, fn state -> do_something_expensive(state) end)\n      end\n\n      # Compute in the agent/client\n      def get_something(agent) do\n        Agent.get(agent, &(&1)) |> do_something_expensive()\n      end\n\n  The first function blocks the agent. The second function copies\n  all the state to the client and then executes the operation in the\n  client. The difference is whether the data is large enough to require\n  processing in the server, at least initially, or small enough to be\n  sent to the client cheaply.\n\n  ## Name Registration\n\n  An Agent is bound to the same name registration rules as GenServers.\n  Read more about it in the `GenServer` docs.\n\n  ## A word on distributed agents\n\n  It is important to consider the limitations of distributed agents. Agents\n  provide two APIs, one that works with anonymous functions and another\n  that expects an explicit module, function, and arguments.\n\n  In a distributed setup with multiple nodes, the API that accepts anonymous\n  functions only works if the caller (client) and the agent have the same\n  version of the caller module.\n\n  Keep in mind this issue also shows up when performing \"rolling upgrades\"\n  with agents. By rolling upgrades we mean the following situation: you wish\n  to deploy a new version of your software by *shutting down* some of your\n  nodes and replacing them with nodes running a new version of the software.\n  In this setup, part of your environment will have one version of a given\n  module and the other part another version (the newer one) of the same module.\n\n  The best solution is to simply use the explicit module, function, and arguments\n  APIs when working with distributed agents.\n\n  ## Hot code swapping\n\n  An agent can have its code hot swapped live by simply passing a module,\n  function, and args tuple to the update instruction. For example, imagine\n  you have an agent named `:sample` and you want to convert its inner state\n  from some dict structure to a map. It can be done with the following\n  instruction:\n\n      {:update, :sample, {:advanced, {Enum, :into, [%{}]}}}\n\n  The agent's state will be added to the given list as the first argument.\n  ",
    name = {
      description = "name :: atom | {:global, term} | {:via, module, term}\n"
    },
    on_start = {
      description = "on_start :: {:ok, pid} | {:error, {:already_started, pid} | term}\n"
    },
    state = {
      description = "state :: term\n"
    }
  },
  Application = {
    __using__ = {
      description = "\n__using__(_)\nfalse"
    },
    app = {
      description = "app :: atom\n"
    },
    app_dir = {
      description = "@spec app_dir(app, String.t | [String.t]) :: String.t\n  \napp_dir(app, path) when is_list(path) \n\n  Returns the given path inside `app_dir/1`.\n  "
    },
    description = "\n  A module for working with applications and defining application callbacks.\n\n  In Elixir (actually, in Erlang/OTP), an application is a component\n  implementing some specific functionality, that can be started and stopped\n  as a unit, and which can be re-used in other systems.\n\n  Applications are defined with an application file named `APP.app` where\n  `APP` is the application name, usually in `underscore_case`. The application\n  file must reside in the same `ebin` directory as the compiled modules of the\n  application.\n\n  In Elixir, Mix is responsible for compiling your source code and\n  generating your application `.app` file. Furthermore, Mix is also\n  responsible for configuring, starting and stopping your application\n  and its dependencies. For this reason, this documentation will focus\n  on the remaining aspects of your application: the application environment\n  and the application callback module.\n\n  You can learn more about Mix generation of `.app` files by typing\n  `mix help compile.app`.\n\n  ## Application environment\n\n  Once an application is started, OTP provides an application environment\n  that can be used to configure the application.\n\n  Assuming you are inside a Mix project, you can edit the `application/0`\n  function in the `mix.exs` file to the following:\n\n      def application do\n        [env: [hello: :world]]\n      end\n\n  In the application function, we can define the default environment values\n  for our application. By starting your application with `iex -S mix`, you\n  can access the default value:\n\n      Application.get_env(:APP_NAME, :hello)\n      #=> :world\n\n  It is also possible to put and delete values from the application value,\n  including new values that are not defined in the environment file (although\n  this should be avoided).\n\n  Keep in mind that each application is responsible for its environment.\n  Do not use the functions in this module for directly accessing or modifying\n  the environment of other applications (as it may lead to inconsistent\n  data in the application environment).\n\n  ## Application module callback\n\n  Often times, an application defines a supervision tree that must be started\n  and stopped when the application starts and stops. For such, we need to\n  define an application module callback. The first step is to define the\n  module callback in the application definition in the `mix.exs` file:\n\n      def application do\n        [mod: {MyApp, []}]\n      end\n\n  Our application now requires the `MyApp` module to provide an application\n  callback. This can be done by invoking `use Application` in that module and\n  defining a `start/2` callback, for example:\n\n      defmodule MyApp do\n        use Application\n\n        def start(_type, _args) do\n          MyApp.Supervisor.start_link()\n        end\n      end\n\n  `start/2` typically returns `{:ok, pid}` or `{:ok, pid, state}` where\n  `pid` identifies the supervision tree and `state` is the application state.\n  `args` is the second element of the tuple given to the `:mod` option.\n\n  The `type` argument passed to `start/2` is usually `:normal` unless in a\n  distributed setup where application takeovers and failovers are configured.\n  This particular aspect of applications is explained in more detail in the\n  OTP documentation:\n\n    * [`:application` module](http://www.erlang.org/doc/man/application.html)\n    * [Applications – OTP Design Principles](http://www.erlang.org/doc/design_principles/applications.html)\n\n  A developer may also implement the `stop/1` callback (automatically defined\n  by `use Application`) which does any application cleanup. It receives the\n  application state and can return any value. Note that shutting down the\n  supervisor is automatically handled by the VM.\n  ",
    key = {
      description = "key :: atom\n"
    },
    start_type = {
      description = "start_type :: :permanent | :transient | :temporary\n"
    },
    state = {
      description = "state :: term\n"
    },
    stop = {
      description = "\nstop(_state)\nfalse"
    },
    value = {
      description = "value :: term\n"
    }
  },
  ArgumentError = {},
  ArithmeticError = {},
  Atom = {
    description = "\n  Convenience functions for working with atoms.\n\n  See also `Kernel.is_atom/1`.\n  "
  },
  B = {},
  BadArityError = {
    message = {
      description = "\nmessage(exception)\n"
    }
  },
  BadBooleanError = {
    message = {
      description = "\nmessage(exception)\n"
    }
  },
  BadFunctionError = {
    message = {
      description = "\nmessage(exception)\n"
    }
  },
  BadMapError = {
    message = {
      description = "\nmessage(exception)\n"
    }
  },
  BadStructError = {
    message = {
      description = "\nmessage(exception)\n"
    }
  },
  Base = {
    ["decode16!"] = {
      description = "\ndecode16!(string, _opts) when is_binary(string) \n@spec decode16!(binary) :: binary\n  @spec decode16!(binary, Keyword.t) :: binary\n  \ndecode16!(string, opts) when is_binary(string) and rem(byte_size(string), 2) == 0 \n\n  Decodes a base 16 encoded string into a binary string.\n\n  ## Options\n\n  The accepted options are:\n\n    * `:case` - specifies the character case to accept when decoding\n\n  The values for `:case` can be:\n\n    * `:upper` - only allows upper case characters (default)\n    * `:lower` - only allows lower case characters\n    * `:mixed` - allows mixed case characters\n\n  An `ArgumentError` exception is raised if the padding is incorrect or\n  a non-alphabet character is present in the string.\n\n  ## Examples\n\n      iex> Base.decode16!(\"666F6F626172\")\n      \"foobar\"\n\n      iex> Base.decode16!(\"666f6f626172\", case: :lower)\n      \"foobar\"\n\n      iex> Base.decode16!(\"666f6F626172\", case: :mixed)\n      \"foobar\"\n\n  "
    },
    description = "\n  This module provides data encoding and decoding functions\n  according to [RFC 4648](https://tools.ietf.org/html/rfc4648).\n\n  This document defines the commonly used base 16, base 32, and base\n  64 encoding schemes.\n\n  ## Base 16 alphabet\n\n      | Value | Encoding | Value | Encoding | Value | Encoding | Value | Encoding |\n      |------:|---------:|------:|---------:|------:|---------:|------:|---------:|\n      |      0|         0|      4|         4|      8|         8|     12|         C|\n      |      1|         1|      5|         5|      9|         9|     13|         D|\n      |      2|         2|      6|         6|     10|         A|     14|         E|\n      |      3|         3|      7|         7|     11|         B|     15|         F|\n\n  ## Base 32 alphabet\n\n      | Value | Encoding | Value | Encoding | Value | Encoding | Value | Encoding |\n      |------:|---------:|------:|---------:|------:|---------:|------:|---------:|\n      |      0|         A|      9|         J|     18|         S|     27|         3|\n      |      1|         B|     10|         K|     19|         T|     28|         4|\n      |      2|         C|     11|         L|     20|         U|     29|         5|\n      |      3|         D|     12|         M|     21|         V|     30|         6|\n      |      4|         E|     13|         N|     22|         W|     31|         7|\n      |      5|         F|     14|         O|     23|         X|       |          |\n      |      6|         G|     15|         P|     24|         Y|  (pad)|         =|\n      |      7|         H|     16|         Q|     25|         Z|       |          |\n      |      8|         I|     17|         R|     26|         2|       |          |\n\n\n  ## Base 32 (extended hex) alphabet\n\n      | Value | Encoding | Value | Encoding | Value | Encoding | Value | Encoding |\n      |------:|---------:|------:|---------:|------:|---------:|------:|---------:|\n      |      0|         0|      9|         9|     18|         I|     27|         R|\n      |      1|         1|     10|         A|     19|         J|     28|         S|\n      |      2|         2|     11|         B|     20|         K|     29|         T|\n      |      3|         3|     12|         C|     21|         L|     30|         U|\n      |      4|         4|     13|         D|     22|         M|     31|         V|\n      |      5|         5|     14|         E|     23|         N|       |          |\n      |      6|         6|     15|         F|     24|         O|  (pad)|         =|\n      |      7|         7|     16|         G|     25|         P|       |          |\n      |      8|         8|     17|         H|     26|         Q|       |          |\n\n  ## Base 64 alphabet\n\n      | Value | Encoding | Value | Encoding | Value | Encoding | Value | Encoding |\n      |------:|---------:|------:|---------:|------:|---------:|------:|---------:|\n      |      0|         A|     17|         R|     34|         i|     51|         z|\n      |      1|         B|     18|         S|     35|         j|     52|         0|\n      |      2|         C|     19|         T|     36|         k|     53|         1|\n      |      3|         D|     20|         U|     37|         l|     54|         2|\n      |      4|         E|     21|         V|     38|         m|     55|         3|\n      |      5|         F|     22|         W|     39|         n|     56|         4|\n      |      6|         G|     23|         X|     40|         o|     57|         5|\n      |      7|         H|     24|         Y|     41|         p|     58|         6|\n      |      8|         I|     25|         Z|     42|         q|     59|         7|\n      |      9|         J|     26|         a|     43|         r|     60|         8|\n      |     10|         K|     27|         b|     44|         s|     61|         9|\n      |     11|         L|     28|         c|     45|         t|     62|         +|\n      |     12|         M|     29|         d|     46|         u|     63|         /|\n      |     13|         N|     30|         e|     47|         v|       |          |\n      |     14|         O|     31|         f|     48|         w|  (pad)|         =|\n      |     15|         P|     32|         g|     49|         x|       |          |\n      |     16|         Q|     33|         h|     50|         y|       |          |\n\n  ## Base 64 (URL and filename safe) alphabet\n\n      | Value | Encoding | Value | Encoding | Value | Encoding | Value | Encoding |\n      |------:|---------:|------:|---------:|------:|---------:|------:|---------:|\n      |      0|         A|     17|         R|     34|         i|     51|         z|\n      |      1|         B|     18|         S|     35|         j|     52|         0|\n      |      2|         C|     19|         T|     36|         k|     53|         1|\n      |      3|         D|     20|         U|     37|         l|     54|         2|\n      |      4|         E|     21|         V|     38|         m|     55|         3|\n      |      5|         F|     22|         W|     39|         n|     56|         4|\n      |      6|         G|     23|         X|     40|         o|     57|         5|\n      |      7|         H|     24|         Y|     41|         p|     58|         6|\n      |      8|         I|     25|         Z|     42|         q|     59|         7|\n      |      9|         J|     26|         a|     43|         r|     60|         8|\n      |     10|         K|     27|         b|     44|         s|     61|         9|\n      |     11|         L|     28|         c|     45|         t|     62|         -|\n      |     12|         M|     29|         d|     46|         u|     63|         _|\n      |     13|         N|     30|         e|     47|         v|       |          |\n      |     14|         O|     31|         f|     48|         w|  (pad)|         =|\n      |     15|         P|     32|         g|     49|         x|       |          |\n      |     16|         Q|     33|         h|     50|         y|       |          |\n\n  "
  },
  Behaviour = {
    __behaviour__ = {
      description = "\n__behaviour__(:docs)\n\n__behaviour__(:callbacks)\nfalse"
    },
    __using__ = {
      description = "\n__using__(_)\nfalse"
    },
    defcallback = {
      description = "\ndefcallback(spec)\n\n  Defines a function callback according to the given type specification.\n  "
    },
    defmacrocallback = {
      description = "\ndefmacrocallback(spec)\n\n  Defines a macro callback according to the given type specification.\n  "
    },
    description = "\n  This module has been deprecated.\n\n  Instead of `defcallback/1` and `defmacrocallback/1`, the `@callback` and\n  `@macrocallback` module attributes can be used (respectively). See the\n  documentation for `Module` for more information on these attributes.\n\n  Instead of `MyModule.__behaviour__(:callbacks)`,\n  `MyModule.behaviour_info(:callbacks)` can be used.\n  "
  },
  Bitwise = {
    __using__ = {
      description = "\n__using__(options)\nfalse"
    },
    band = {
      description = "\nband(left, right)\n\n  Calculates the bitwise AND of its arguments.\n\n      iex> band(9, 3)\n      1\n\n  "
    },
    bnot = {
      description = "\nbnot(expr)\n\n  Calculates the bitwise NOT of its argument.\n\n      iex> bnot(2)\n      -3\n      iex> bnot(2) &&& 3\n      1\n\n  "
    },
    bor = {
      description = "\nbor(left, right)\n\n  Calculates the bitwise OR of its arguments.\n\n      iex> bor(9, 3)\n      11\n\n  "
    },
    bsl = {
      description = "\nbsl(left, right)\n\n  Calculates the result of an arithmetic left bitshift.\n\n      iex> bsl(1, 2)\n      4\n      iex> bsl(1, -2)\n      0\n      iex> bsl(-1, 2)\n      -4\n      iex> bsl(-1, -2)\n      -1\n\n  "
    },
    bsr = {
      description = "\nbsr(left, right)\n\n  Calculates the result of an arithmetic right bitshift.\n\n      iex> bsr(1, 2)\n      0\n      iex> bsr(1, -2)\n      4\n      iex> bsr(-1, 2)\n      -1\n      iex> bsr(-1, -2)\n      -4\n\n  "
    },
    bxor = {
      description = "\nbxor(left, right)\n\n  Calculates the bitwise XOR of its arguments.\n\n      iex> bxor(9, 3)\n      10\n\n  "
    },
    description = "\n  A set of macros that perform calculations on bits.\n\n  The macros in this module come in two flavors: named or\n  operators. For example:\n\n      iex> use Bitwise\n      iex> bnot 1   # named\n      -2\n      iex> 1 &&& 1  # operator\n      1\n\n  If you prefer to use only operators or skip them, you can\n  pass the following options:\n\n    * `:only_operators` - includes only operators\n    * `:skip_operators` - skips operators\n\n  For example:\n\n      iex> use Bitwise, only_operators: true\n      iex> 1 &&& 1\n      1\n\n  When invoked with no options, `use Bitwise` is equivalent\n  to `import Bitwise`.\n\n  All bitwise macros can be used in guards:\n\n      iex> use Bitwise\n      iex> odd? = fn int when band(int, 1) == 1 -> true; _ -> false end\n      iex> odd?.(1)\n      true\n\n  "
  },
  CLI = {
    description = "false",
    main = {
      description = "\nmain(argv)\n\n  This is the API invoked by Elixir boot process.\n  "
    },
    parse_argv = {
      description = "\nparse_argv(argv)\nfalse"
    },
    process_commands = {
      description = "\nprocess_commands(config)\nfalse"
    },
    run = {
      description = "\nrun(fun, halt \\\\ true)\n\n  Runs the given function by catching any failure\n  and printing them to stdout. `at_exit` hooks are\n  also invoked before exiting.\n\n  This function is used by Elixir's CLI and also\n  by escripts generated by Elixir.\n  "
    }
  },
  Calendar = {
    ISO = {
      date = {
        description = "\ndate(year, month, day) when is_integer(year) and is_integer(month) and is_integer(day) \nfalse"
      },
      date_to_iso8601 = {
        description = "\ndate_to_iso8601(year, month, day)\nfalse"
      },
      date_to_string = {
        description = "@spec day_of_week(year, month, day) :: 1..7\n  \ndate_to_string(year, month, day)\n\n  Converts the given date into a string.\n  "
      },
      datetime_to_iso8601 = {
        description = "\ndatetime_to_iso8601(year, month, day, hour, minute, second, microsecond,\n                          time_zone, _zone_abbr, utc_offset, std_offset)\nfalse"
      },
      datetime_to_string = {
        description = "\ndatetime_to_string(year, month, day, hour, minute, second, microsecond,\n                         time_zone, zone_abbr, utc_offset, std_offset)\n\n  Convers the datetime (with time zone) into a string.\n  "
      },
      day = {
        description = "day :: 1..31\n"
      },
      days_in_month = {
        description = "\ndays_in_month(_, month) when month in 1..12, \n\ndays_in_month(_, month) when month in [4, 6, 9, 11], \n@spec days_in_month(year, month) :: 28..31\n  \ndays_in_month(year, 2)\n\n  Returns how many days there are in the given year-month.\n\n  ## Examples\n\n      iex> Calendar.ISO.days_in_month(1900, 1)\n      31\n      iex> Calendar.ISO.days_in_month(1900, 2)\n      28\n      iex> Calendar.ISO.days_in_month(2000, 2)\n      29\n      iex> Calendar.ISO.days_in_month(2001, 2)\n      28\n      iex> Calendar.ISO.days_in_month(2004, 2)\n      29\n      iex> Calendar.ISO.days_in_month(2004, 4)\n      30\n\n  "
      },
      description = "\n  A calendar implementation that follows to ISO8601.\n\n  This calendar implements the proleptic Gregorian calendar and\n  is therefore compatible with the calendar used in most countries\n  today. The proleptic means the Gregorian rules for leap years are\n  applied for all time, consequently the dates give different results\n  before the year 1583 from when the Gregorian calendar was adopted.\n  ",
      from_unix = {
        description = "\nfrom_unix(integer, unit) when is_integer(integer) \nfalse"
      },
      month = {
        description = "month :: 1..12\n"
      },
      naive_datetime_to_iso8601 = {
        description = "\nnaive_datetime_to_iso8601(year, month, day, hour, minute, second, microsecond)\nfalse"
      },
      naive_datetime_to_string = {
        description = "\nnaive_datetime_to_string(year, month, day, hour, minute, second, microsecond)\n\n  Converts the datetime (without time zone) into a string.\n  "
      },
      parse_microsecond = {
        description = "\nparse_microsecond(rest)\n\nparse_microsecond(\".\" <> rest)\nfalse"
      },
      parse_offset = {
        description = "\nparse_offset(_)\n\nparse_offset(<<?-, hour::2-bytes, ?:, min::2-bytes, rest::binary>>)\n\nparse_offset(<<?+, hour::2-bytes, ?:, min::2-bytes, rest::binary>>)\n\nparse_offset(\"-00:00\")\n\nparse_offset(\"Z\")\n\nparse_offset(\"\")\nfalse"
      },
      time_to_iso8601 = {
        description = "\ntime_to_iso8601(hour, minute, second, microsecond)\nfalse"
      },
      time_to_string = {
        description = "\ntime_to_string(hour, minute, second, {microsecond, precision})\n\ntime_to_string(hour, minute, second, {_, 0})\nfalse"
      },
      year = {
        description = "year :: 0..9999\n"
      }
    },
    calendar = {
      description = "calendar :: module\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    date = {
      description = "date :: %{optional(any) => any, calendar: calendar, year: year, month: month, day: day}\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    datetime = {
      description = "datetime :: %{optional(any) => any, calendar: calendar, year: year, month: month, day: day,\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    day = {
      description = "day :: integer\n"
    },
    description = "\n  This module defines the responsibilities for working with\n  calendars, dates, times and datetimes in Elixir.\n\n  Currently it defines types and the minimal implementation\n  for a calendar behaviour in Elixir. The goal of the Calendar\n  features in Elixir is to provide a base for interoperability\n  instead of full-featured datetime API.\n\n  For the actual date, time and datetime structures, see `Date`,\n  `Time`, `NaiveDateTime` and `DateTime`.\n\n  Note the year, month, day, etc designations are overspecified\n  (i.e. an integer instead of `1..12` for months) because different\n  calendars may have a different number of days per month, months per year and so on.\n  ",
    hour = {
      description = "hour :: 0..23\n"
    },
    microsecond = {
      description = "microsecond :: {0..999_999, 0..6}\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    minute = {
      description = "minute :: 0..59\n"
    },
    month = {
      description = "month :: integer\n"
    },
    naive_datetime = {
      description = "naive_datetime :: %{optional(any) => any, calendar: calendar, year: year, month: month, day: day,\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    second = {
      description = "second :: 0..60\n"
    },
    std_offset = {
      description = "std_offset :: integer\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    time = {
      description = "time :: %{optional(any) => any, hour: hour, minute: minute, second: second, microsecond: microsecond}\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    time_zone = {
      description = "time_zone :: String.t\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    utc_offset = {
      description = "utc_offset :: integer\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    year = {
      description = "year :: integer\n"
    },
    zone_abbr = {
      description = "zone_abbr :: String.t\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    }
  },
  CaseClauseError = {
    message = {
      description = "\nmessage(exception)\n"
    }
  },
  Code = {
    LoadError = {
      exception = {
        description = "\nexception(opts)\n"
      }
    },
    append_path = {
      description = "\nappend_path(path)\n\n  Appends a path to the end of the Erlang VM code path list.\n\n  This is the list of directories the Erlang VM uses for\n  finding module code.\n\n  The path is expanded with `Path.expand/1` before being appended.\n  If this path does not exist, an error is returned.\n\n  ## Examples\n\n      Code.append_path(\".\") #=> true\n\n      Code.append_path(\"/does_not_exist\") #=> {:error, :bad_directory}\n\n  "
    },
    available_compiler_options = {
      description = "\navailable_compiler_options\n\n  Returns a list with the available compiler options.\n\n  See `Code.compiler_options/1` for more info.\n\n  ## Examples\n\n      iex> Code.available_compiler_options\n      [:docs, :debug_info, :ignore_module_conflict, :relative_paths, :warnings_as_errors]\n\n  "
    },
    compile_quoted = {
      description = "\ncompile_quoted(quoted, file \\\\ \"nofile\") when is_binary(file) \n\n  Compiles the quoted expression.\n\n  Returns a list of tuples where the first element is the module name and\n  the second one is its byte code (as a binary).\n  "
    },
    compile_string = {
      description = "\ncompile_string(string, file \\\\ \"nofile\") when is_binary(file) \n\n  Compiles the given string.\n\n  Returns a list of tuples where the first element is the module name\n  and the second one is its byte code (as a binary).\n\n  For compiling many files at once, check `Kernel.ParallelCompiler.files/2`.\n  "
    },
    compiler_options = {
      description = "\ncompiler_options(opts)\n  Sets compilation options.\n\n  These options are global since they are stored by Elixir's Code Server.\n\n  Available options are:\n\n    * `:docs` - when `true`, retain documentation in the compiled module,\n      `true` by default\n\n    * `:debug_info` - when `true`, retain debug information in the compiled\n      module; this allows a developer to reconstruct the original source\n      code, `false` by default\n\n    * `:ignore_module_conflict` - when `true`, override modules that were\n      already defined without raising errors, `false` by default\n\n    * `:relative_paths` - when `true`, use relative paths in quoted nodes,\n      warnings and errors generated by the compiler, `true` by default.\n      Note disabling this option won't affect runtime warnings and errors.\n\n    * `:warnings_as_errors` - causes compilation to fail when warnings are\n      generated\n\n  It returns the new list of compiler options.\n\n  ## Examples\n\n      Code.compiler_options(debug_info: true)\n      #=> %{debug_info: true, docs: true,\n            warnings_as_errors: false, ignore_module_conflict: false}\n\n  \n\ncompiler_options\n\n  Gets the compilation options from the code server.\n\n  Check `compiler_options/1` for more information.\n\n  ## Examples\n\n      Code.compiler_options\n      #=> %{debug_info: true, docs: true,\n            warnings_as_errors: false, ignore_module_conflict: false}\n\n  "
    },
    delete_path = {
      description = "\ndelete_path(path)\n\n  Deletes a path from the Erlang VM code path list. This is the list of\n  directories the Erlang VM uses for finding module code.\n\n  The path is expanded with `Path.expand/1` before being deleted. If the\n  path does not exist it returns `false`.\n\n  ## Examples\n\n      Code.prepend_path(\".\")\n      Code.delete_path(\".\") #=> true\n\n      Code.delete_path(\"/does_not_exist\") #=> false\n\n  "
    },
    description = "\n  Utilities for managing code compilation, code evaluation and code loading.\n\n  This module complements Erlang's [`:code` module](http://www.erlang.org/doc/man/code.html)\n  to add behaviour which is specific to Elixir. Almost all of the functions in this module\n  have global side effects on the behaviour of Elixir.\n  ",
    ["ensure_loaded?"] = {
      description = "@spec ensure_loaded(module) ::\n        {:module, module} | {:error, :embedded | :badfile | :nofile | :on_load_failure}\n  \nensure_loaded?(module) when is_atom(module) \n\n  Ensures the given module is loaded.\n\n  Similar to `ensure_loaded/1`, but returns `true` if the module\n  is already loaded or was successfully loaded. Returns `false`\n  otherwise.\n\n  ## Examples\n\n      iex> Code.ensure_loaded?(Atom)\n      true\n\n  "
    },
    eval_file = {
      description = "\neval_file(file, relative_to \\\\ nil)\n\n  Evals the given file.\n\n  Accepts `relative_to` as an argument to tell where the file is located.\n\n  While `load_file` loads a file and returns the loaded modules and their\n  byte code, `eval_file` simply evaluates the file contents and returns the\n  evaluation result and its bindings.\n  "
    },
    eval_quoted = {
      description = "\neval_quoted(quoted, binding, opts) when is_list(opts) \n\neval_quoted(quoted, binding, %Macro.Env{} = env)\n\neval_quoted(quoted, binding \\\\ [], opts \\\\ [])\n\n  Evaluates the quoted contents.\n\n  **Warning**: Calling this function inside a macro is considered bad\n  practice as it will attempt to evaluate runtime values at compile time.\n  Macro arguments are typically transformed by unquoting them into the\n  returned quoted expressions (instead of evaluated).\n\n  See `eval_string/3` for a description of bindings and options.\n\n  ## Examples\n\n      iex> contents = quote(do: var!(a) + var!(b))\n      iex> Code.eval_quoted(contents, [a: 1, b: 2], file: __ENV__.file, line: __ENV__.line)\n      {3, [a: 1, b: 2]}\n\n  For convenience, you can pass `__ENV__/0` as the `opts` argument and\n  all options will be automatically extracted from the current environment:\n\n      iex> contents = quote(do: var!(a) + var!(b))\n      iex> Code.eval_quoted(contents, [a: 1, b: 2], __ENV__)\n      {3, [a: 1, b: 2]}\n\n  "
    },
    eval_string = {
      description = "\neval_string(string, binding, opts) when is_list(opts) \n\neval_string(string, binding, %Macro.Env{} = env)\n\neval_string(string, binding \\\\ [], opts \\\\ [])\n\n  Evaluates the contents given by `string`.\n\n  The `binding` argument is a keyword list of variable bindings.\n  The `opts` argument is a keyword list of environment options.\n\n  ## Options\n\n  Options can be:\n\n    * `:file` - the file to be considered in the evaluation\n    * `:line` - the line on which the script starts\n\n  Additionally, the following scope values can be configured:\n\n    * `:aliases` - a list of tuples with the alias and its target\n\n    * `:requires` - a list of modules required\n\n    * `:functions` - a list of tuples where the first element is a module\n      and the second a list of imported function names and arity; the list\n      of function names and arity must be sorted\n\n    * `:macros` - a list of tuples where the first element is a module\n      and the second a list of imported macro names and arity; the list\n      of function names and arity must be sorted\n\n  Notice that setting any of the values above overrides Elixir's default\n  values. For example, setting `:requires` to `[]`, will no longer\n  automatically require the `Kernel` module; in the same way setting\n  `:macros` will no longer auto-import `Kernel` macros like `if/2`, `case/2`,\n  etc.\n\n  Returns a tuple of the form `{value, binding}`,\n  where `value` is the value returned from evaluating `string`.\n  If an error occurs while evaluating `string` an exception will be raised.\n\n  `binding` is a keyword list with the value of all variable bindings\n  after evaluating `string`. The binding key is usually an atom, but it\n  may be a tuple for variables defined in a different context.\n\n  ## Examples\n\n      iex> Code.eval_string(\"a + b\", [a: 1, b: 2], file: __ENV__.file, line: __ENV__.line)\n      {3, [a: 1, b: 2]}\n\n      iex> Code.eval_string(\"c = a + b\", [a: 1, b: 2], __ENV__)\n      {3, [a: 1, b: 2, c: 3]}\n\n      iex> Code.eval_string(\"a = a + b\", [a: 1, b: 2])\n      {3, [a: 3, b: 2]}\n\n  For convenience, you can pass `__ENV__/0` as the `opts` argument and\n  all imports, requires and aliases defined in the current environment\n  will be automatically carried over:\n\n      iex> Code.eval_string(\"a + b\", [a: 1, b: 2], __ENV__)\n      {3, [a: 1, b: 2]}\n\n  "
    },
    get_docs = {
      description = "\nget_docs(binpath, kind) when is_binary(binpath) and kind in @\n@spec ensure_compiled?(module) :: boolean\n  \nget_docs(module, kind) when is_atom(module) and kind in @\n\n  Returns the docs for the given module.\n\n  When given a module name, it finds its BEAM code and reads the docs from it.\n\n  When given a path to a .beam file, it will load the docs directly from that\n  file.\n\n  The return value depends on the `kind` value:\n\n    * `:docs` - list of all docstrings attached to functions and macros\n      using the `@doc` attribute\n\n    * `:moduledoc` - tuple `{<line>, <doc>}` where `line` is the line on\n      which module definition starts and `doc` is the string\n      attached to the module using the `@moduledoc` attribute\n\n    * `:callback_docs` - list of all docstrings attached to\n      `@callbacks` using the `@doc` attribute\n\n    * `:type_docs` - list of all docstrings attached to\n      `@type` callbacks using the `@typedoc` attribute\n\n    * `:all` - a keyword list with `:docs` and `:moduledoc`, `:callback_docs`,\n      and `:type_docs`.\n\n  If the module cannot be found, it returns `nil`.\n\n  ## Examples\n\n      # Get the module documentation\n      iex> {_line, text} = Code.get_docs(Atom, :moduledoc)\n      iex> String.split(text, \"\\n\") |> Enum.at(0)\n      \"Convenience functions for working with atoms.\"\n\n      # Module doesn't exist\n      iex> Code.get_docs(ModuleNotGood, :all)\n      nil\n\n  "
    },
    load_file = {
      description = "\nload_file(file, relative_to \\\\ nil) when is_binary(file) \n\n  Loads the given file.\n\n  Accepts `relative_to` as an argument to tell where the file is located.\n  If the file was already required/loaded, loads it again.\n\n  It returns a list of tuples `{ModuleName, <<byte_code>>}`, one tuple for\n  each module defined in the file.\n\n  Notice that if `load_file` is invoked by different processes concurrently,\n  the target file will be loaded concurrently many times. Check `require_file/2`\n  if you don't want a file to be loaded concurrently.\n\n  ## Examples\n\n      Code.load_file(\"eex_test.exs\", \"../eex/test\") |> List.first\n      #=> {EExTest.Compiled, <<70, 79, 82, 49, ...>>}\n\n  "
    },
    loaded_files = {
      description = "\nloaded_files\n\n  Lists all loaded files.\n\n  ## Examples\n\n      Code.require_file(\"../eex/test/eex_test.exs\")\n      List.first(Code.loaded_files) =~ \"eex_test.exs\" #=> true\n\n  "
    },
    prepend_path = {
      description = "\nprepend_path(path)\n\n  Prepends a path to the beginning of the Erlang VM code path list.\n\n  This is the list of directories the Erlang VM uses for finding\n  module code.\n\n  The path is expanded with `Path.expand/1` before being prepended.\n  If this path does not exist, an error is returned.\n\n  ## Examples\n\n      Code.prepend_path(\".\") #=> true\n\n      Code.prepend_path(\"/does_not_exist\") #=> {:error, :bad_directory}\n\n  "
    },
    require_file = {
      description = "\nrequire_file(file, relative_to \\\\ nil) when is_binary(file) \n\n  Requires the given `file`.\n\n  Accepts `relative_to` as an argument to tell where the file is located.\n  The return value is the same as that of `load_file/2`. If the file was already\n  required/loaded, doesn't do anything and returns `nil`.\n\n  Notice that if `require_file` is invoked by different processes concurrently,\n  the first process to invoke `require_file` acquires a lock and the remaining\n  ones will block until the file is available. I.e. if `require_file` is called\n  N times with a given file, it will be loaded only once. The first process to\n  call `require_file` will get the list of loaded modules, others will get `nil`.\n\n  Check `load_file/2` if you want a file to be loaded multiple times. See also\n  `unload_files/1`\n\n  ## Examples\n\n  If the code is already loaded, it returns `nil`:\n\n      Code.require_file(\"eex_test.exs\", \"../eex/test\") #=> nil\n\n  If the code is not loaded yet, it returns the same as `load_file/2`:\n\n      Code.require_file(\"eex_test.exs\", \"../eex/test\") |> List.first\n      #=> {EExTest.Compiled, <<70, 79, 82, 49, ...>>}\n\n  "
    },
    string_to_quoted = {
      description = "\nstring_to_quoted(string, opts \\\\ []) when is_list(opts) \n\n  Converts the given string to its quoted form.\n\n  Returns `{:ok, quoted_form}`\n  if it succeeds, `{:error, {line, error, token}}` otherwise.\n\n  ## Options\n\n    * `:file` - the filename to be used in stacktraces\n      and the file reported in the `__ENV__/0` macro\n\n    * `:line` - the line reported in the `__ENV__/0` macro\n\n    * `:existing_atoms_only` - when `true`, raises an error\n      when non-existing atoms are found by the tokenizer\n\n  ## Macro.to_string/2\n\n  The opposite of converting a string to its quoted form is\n  `Macro.to_string/2`, which converts a quoted form to a string/binary\n  representation.\n  "
    },
    ["string_to_quoted!"] = {
      description = "\nstring_to_quoted!(string, opts \\\\ []) when is_list(opts) \n\n  Converts the given string to its quoted form.\n\n  It returns the ast if it succeeds,\n  raises an exception otherwise. The exception is a `TokenMissingError`\n  in case a token is missing (usually because the expression is incomplete),\n  `SyntaxError` otherwise.\n\n  Check `string_to_quoted/2` for options information.\n  "
    },
    unload_files = {
      description = "\nunload_files(files)\n\n  Removes files from the loaded files list.\n\n  The modules defined in the file are not removed;\n  calling this function only removes them from the list,\n  allowing them to be required again.\n\n  ## Examples\n\n      # Load EEx test code, unload file, check for functions still available\n      Code.load_file(\"../eex/test/eex_test.exs\")\n      Code.unload_files(Code.loaded_files)\n      function_exported?(EExTest.Compiled, :before_compile, 0) #=> true\n\n  "
    }
  },
  Collectable = {
    command = {
      description = "command :: {:cont, term} | :done | :halt\n"
    },
    description = "\n  A protocol to traverse data structures.\n\n  The `Enum.into/2` function uses this protocol to insert an\n  enumerable into a collection:\n\n      iex> Enum.into([a: 1, b: 2], %{})\n      %{a: 1, b: 2}\n\n  ## Why Collectable?\n\n  The `Enumerable` protocol is useful to take values out of a collection.\n  In order to support a wide range of values, the functions provided by\n  the `Enumerable` protocol do not keep shape. For example, passing a\n  map to `Enum.map/2` always returns a list.\n\n  This design is intentional. `Enumerable` was designed to support infinite\n  collections, resources and other structures with fixed shape. For example,\n  it doesn't make sense to insert values into a range, as it has a fixed\n  shape where just the range limits are stored.\n\n  The `Collectable` module was designed to fill the gap left by the\n  `Enumerable` protocol. `into/1` can be seen as the opposite of\n  `Enumerable.reduce/3`. If `Enumerable` is about taking values out,\n  `Collectable.into/1` is about collecting those values into a structure.\n\n  ## Examples\n\n  To show how to manually use the `Collectable` protocol, let's play with its\n  implementation for `MapSet`.\n\n      iex> {initial_acc, collector_fun} = Collectable.into(MapSet.new())\n      iex> updated_acc = Enum.reduce([1, 2, 3], initial_acc, fn elem, acc ->\n      ...>   collector_fun.(acc, {:cont, elem})\n      ...> end)\n      iex> collector_fun.(updated_acc, :done)\n      #MapSet<[1, 2, 3]>\n\n  To show how the protocol can be implemented, we can take again a look at the\n  implementation for `MapSet`. In this implementation \"collecting\" elements\n  simply means inserting them in the set through `MapSet.put/2`.\n\n      defimpl Collectable do\n        def into(original) do\n          collector_fun = fn\n            set, {:cont, elem} -> MapSet.put(set, elem)\n            set, :done -> set\n            _set, :halt -> :ok\n          end\n\n          {original, collector_fun}\n        end\n      end\n\n  ",
    into = {
      description = "\ninto(original)\n\ninto(original)\n@spec into(t) :: {term, (term, command -> t | term)}\n  \ninto(original)\n\n  Returns an initial accumulator and a \"collector\" function.\n\n  The returned function receives a term and a command and injects the term into\n  the collectable on every `{:cont, term}` command.\n\n  `:done` is passed as a command when no further values will be injected. This\n  is useful when there's a need to close resources or normalizing values. A\n  collectable must be returned when the command is `:done`.\n\n  If injection is suddenly interrupted, `:halt` is passed and the function\n  can return any value as it won't be used.\n\n  For examples on how to use the `Collectable` protocol and `into/1` see the\n  module documentation.\n  "
    }
  },
  CompileError = {
    compile = {
      description = "\ncompile(source, options) when is_list(options) \n@spec compile(binary, binary | [term]) :: {:ok, t} | {:error, any}\n  \ncompile(source, options) when is_binary(options) \n\n  Compiles the regular expression.\n\n  The given options can either be a binary with the characters\n  representing the same regex options given to the `~r` sigil,\n  or a list of options, as expected by the Erlang's [`:re` module](http://www.erlang.org/doc/man/re.html).\n\n  It returns `{:ok, regex}` in case of success,\n  `{:error, reason}` otherwise.\n\n  ## Examples\n\n      iex> Regex.compile(\"foo\")\n      {:ok, ~r\"foo\"}\n\n      iex> Regex.compile(\"*foo\")\n      {:error, {'nothing to repeat', 0}}\n\n  "
    },
    message = {
      description = "\nmessage(%{file: file, line: line, description: description})\n"
    },
    ["regex?"] = {
      description = "\nregex?(_)\n@spec regex?(any) :: boolean\n  \nregex?(%Regex{})\n\n  Returns `true` if the given `term` is a regex.\n  Otherwise returns `false`.\n\n  ## Examples\n\n      iex> Regex.regex?(~r/foo/)\n      true\n\n      iex> Regex.regex?(0)\n      false\n\n  "
    },
    replace = {
      description = "\nreplace(regex, string, replacement, options)\n      when is_binary(string) and is_function(replacement) and is_list(options)  \n@spec replace(t, String.t, String.t | (... -> String.t), [term]) :: String.t\n  \nreplace(regex, string, replacement, options)\n      when is_binary(string) and is_binary(replacement) and is_list(options) \n\n  Receives a regex, a binary and a replacement, returns a new\n  binary where all matches are replaced by the replacement.\n\n  The replacement can be either a string or a function. The string\n  is used as a replacement for every match and it allows specific\n  captures to be accessed via `\\N` or `\\g{N}`, where `N` is the\n  capture. In case `\\0` is used, the whole match is inserted. Note\n  that in regexes the backslash needs to be escaped, hence in practice\n  you'll need to use `\\\\N` and `\\\\g{N}`.\n\n  When the replacement is a function, the function may have arity\n  N where each argument maps to a capture, with the first argument\n  being the whole match. If the function expects more arguments\n  than captures found, the remaining arguments will receive `\"\"`.\n\n  ## Options\n\n    * `:global` - when `false`, replaces only the first occurrence\n      (defaults to `true`)\n\n  ## Examples\n\n      iex> Regex.replace(~r/d/, \"abc\", \"d\")\n      \"abc\"\n\n      iex> Regex.replace(~r/b/, \"abc\", \"d\")\n      \"adc\"\n\n      iex> Regex.replace(~r/b/, \"abc\", \"[\\\\0]\")\n      \"a[b]c\"\n\n      iex> Regex.replace(~r/a(b|d)c/, \"abcadc\", \"[\\\\1]\")\n      \"[b][d]\"\n\n      iex> Regex.replace(~r/\\.(\\d)$/, \"500.5\", \".\\\\g{1}0\")\n      \"500.50\"\n\n      iex> Regex.replace(~r/a(b|d)c/, \"abcadc\", fn _, x -> \"[#{x}]\" end)\n      \"[b][d]\"\n\n      iex> Regex.replace(~r/a/, \"abcadc\", \"A\", global: false)\n      \"Abcadc\"\n\n  "
    },
    run = {
      description = "@spec run(t, binary, [term]) :: nil | [binary] | [{integer, integer}]\n  \nrun(%Regex{re_pattern: compiled}, string, options) when is_binary(string) \n\n  Runs the regular expression against the given string until the first match.\n  It returns a list with all captures or `nil` if no match occurred.\n\n  ## Options\n\n    * `:return`  - sets to `:index` to return indexes. Defaults to `:binary`.\n    * `:capture` - what to capture in the result. Check the moduledoc for `Regex`\n      to see the possible capture values.\n\n  ## Examples\n\n      iex> Regex.run(~r/c(d)/, \"abcd\")\n      [\"cd\", \"d\"]\n\n      iex> Regex.run(~r/e/, \"abcd\")\n      nil\n\n      iex> Regex.run(~r/c(d)/, \"abcd\", return: :index)\n      [{2, 2}, {3, 1}]\n\n  "
    },
    scan = {
      description = "@spec scan(t, String.t, [term]) :: [[String.t]]\n  \nscan(%Regex{re_pattern: compiled}, string, options) when is_binary(string) \n\n  Same as `run/3`, but scans the target several times collecting all\n  matches of the regular expression.\n\n  A list of lists is returned, where each entry in the primary list represents a\n  match and each entry in the secondary list represents the captured contents.\n\n  ## Options\n\n    * `:return`  - sets to `:index` to return indexes. Defaults to `:binary`.\n    * `:capture` - what to capture in the result. Check the moduledoc for `Regex`\n      to see the possible capture values.\n\n  ## Examples\n\n      iex> Regex.scan(~r/c(d|e)/, \"abcd abce\")\n      [[\"cd\", \"d\"], [\"ce\", \"e\"]]\n\n      iex> Regex.scan(~r/c(?:d|e)/, \"abcd abce\")\n      [[\"cd\"], [\"ce\"]]\n\n      iex> Regex.scan(~r/e/, \"abcd\")\n      []\n\n      iex> Regex.scan(~r/\\p{Sc}/u, \"$, £, and €\")\n      [[\"$\"], [\"£\"], [\"€\"]]\n\n  "
    },
    split = {
      description = "\nsplit(%Regex{re_pattern: compiled}, string, opts) when is_binary(string) and is_list(opts) \n@spec split(t, String.t, [term]) :: [String.t]\n  \nsplit(%Regex{}, \"\", opts)\n\n  Splits the given target based on the given pattern and in the given number of\n  parts.\n\n  ## Options\n\n    * `:parts` - when specified, splits the string into the given number of\n      parts. If not specified, `:parts` defaults to `:infinity`, which will\n      split the string into the maximum number of parts possible based on the\n      given pattern.\n\n    * `:trim` - when `true`, removes empty strings (`\"\"`) from the result.\n\n    * `:on` - specifies which captures to split the string on, and in what\n      order. Defaults to `:first` which means captures inside the regex do not\n      affect the splitting process.\n\n    * `:include_captures` - when `true`, includes in the result the matches of\n      the regular expression. Defaults to `false`.\n\n  ## Examples\n\n      iex> Regex.split(~r{-}, \"a-b-c\")\n      [\"a\", \"b\", \"c\"]\n\n      iex> Regex.split(~r{-}, \"a-b-c\", [parts: 2])\n      [\"a\", \"b-c\"]\n\n      iex> Regex.split(~r{-}, \"abc\")\n      [\"abc\"]\n\n      iex> Regex.split(~r{}, \"abc\")\n      [\"a\", \"b\", \"c\", \"\"]\n\n      iex> Regex.split(~r{a(?<second>b)c}, \"abc\")\n      [\"\", \"\"]\n\n      iex> Regex.split(~r{a(?<second>b)c}, \"abc\", on: [:second])\n      [\"a\", \"c\"]\n\n      iex> Regex.split(~r{(x)}, \"Elixir\", include_captures: true)\n      [\"Eli\", \"x\", \"ir\"]\n\n      iex> Regex.split(~r{a(?<second>b)c}, \"abc\", on: [:second], include_captures: true)\n      [\"a\", \"b\", \"c\"]\n\n  "
    },
    unescape_map = {
      description = "\nunescape_map(_)\n\nunescape_map(?a)\n\nunescape_map(?v)\n\nunescape_map(?t)\n\nunescape_map(?r)\n\nunescape_map(?n)\n@spec escape(String.t) :: String.t\n  \nunescape_map(?f)\nfalse"
    }
  },
  CondClauseError = {
    message = {
      description = "\nmessage(_exception)\n"
    }
  },
  Date = {
    day_of_week = {
      description = "@spec day_of_week(Calendar.date) :: non_neg_integer()\n  \nday_of_week(%{calendar: calendar, year: year, month: month, day: day})\n\n  Calculates the day of the week of a given `Date` struct.\n\n  Returns the day of the week as an integer. For the ISO 8601\n  calendar (the default), it is an integer from 1 to 7, where\n  1 is Monday and 7 is Sunday.\n\n  ## Examples\n\n      iex> Date.day_of_week(~D[2016-10-31])\n      1\n      iex> Date.day_of_week(~D[2016-11-01])\n      2\n      iex> Date.day_of_week(~N[2016-11-01 01:23:45])\n      2\n  "
    },
    days_in_month = {
      description = "@spec days_in_month(Calendar.date) :: Calendar.day\n  \ndays_in_month(%{calendar: calendar, year: year, month: month})\n\n  Returns the number of days in the given date month.\n\n  ## Examples\n\n      iex> Date.days_in_month(~D[1900-01-13])\n      31\n      iex> Date.days_in_month(~D[1900-02-09])\n      28\n      iex> Date.days_in_month(~N[2000-02-20 01:23:45])\n      29\n\n  "
    },
    description = "\n  A Date struct and functions.\n\n  The Date struct contains the fields year, month, day and calendar.\n  New dates can be built with the `new/3` function or using the `~D`\n  sigil:\n\n      iex> ~D[2000-01-01]\n      ~D[2000-01-01]\n\n  Both `new/3` and sigil return a struct where the date fields can\n  be accessed directly:\n\n      iex> date = ~D[2000-01-01]\n      iex> date.year\n      2000\n      iex> date.month\n      1\n\n  The functions on this module work with the `Date` struct as well\n  as any struct that contains the same fields as the `Date` struct,\n  such as `NaiveDateTime` and `DateTime`. Such functions expect\n  `t:Calendar.date/0` in their typespecs (instead of `t:t/0`).\n\n  Remember, comparisons in Elixir using `==`, `>`, `<` and friends\n  are structural and based on the Date struct fields. For proper\n  comparison between dates, use the `compare/2` function.\n\n  Developers should avoid creating the Date struct directly and\n  instead rely on the functions provided by this module as well as\n  the ones in 3rd party calendar libraries.\n  ",
    from_erl = {
      description = "@spec from_erl(:calendar.date) :: {:ok, t} | {:error, atom}\n  \nfrom_erl({year, month, day})\n\n  Converts an Erlang date tuple to a `Date` struct.\n\n  Attempting to convert an invalid ISO calendar date will produce an error tuple.\n\n  ## Examples\n\n      iex> Date.from_erl({2000, 1, 1})\n      {:ok, ~D[2000-01-01]}\n      iex> Date.from_erl({2000, 13, 1})\n      {:error, :invalid_date}\n  "
    },
    from_iso8601 = {
      description = "\nfrom_iso8601(<<_::binary>>)\n@spec from_iso8601(String.t) :: {:ok, t} | {:error, atom}\n  \nfrom_iso8601(<<year::4-bytes, ?-, month::2-bytes, ?-, day::2-bytes>>)\n\n  Parses the extended \"Date and time of day\" format described by\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  Timezone offset may be included in the string but they will be\n  simply discarded as such information is not included in naive date\n  times.\n\n  Time representations with reduced accuracy are not supported.\n\n  ## Examples\n\n      iex> Date.from_iso8601(\"2015-01-23\")\n      {:ok, ~D[2015-01-23]}\n\n      iex> Date.from_iso8601(\"2015:01:23\")\n      {:error, :invalid_format}\n      iex> Date.from_iso8601(\"2015-01-32\")\n      {:error, :invalid_date}\n\n  "
    },
    inspect = {
      description = "\ninspect(date, opts)\n\ninspect(%{calendar: Calendar.ISO, year: year, month: month, day: day}, _)\n"
    },
    ["leap_year?"] = {
      description = "@spec leap_year?(Calendar.date) :: boolean()\n  \nleap_year?(%{calendar: calendar, year: year})\n\n  Returns true if the year in `date` is a leap year.\n\n  ## Examples\n\n      iex> Date.leap_year?(~D[2000-01-01])\n      true\n      iex> Date.leap_year?(~D[2001-01-01])\n      false\n      iex> Date.leap_year?(~D[2004-01-01])\n      true\n      iex> Date.leap_year?(~D[1900-01-01])\n      false\n      iex> Date.leap_year?(~N[2004-01-01 01:23:45])\n      true\n\n  "
    },
    t = {
      description = "t :: %Date{year: Calendar.year, month: Calendar.month,\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    to_erl = {
      description = "@spec to_erl(Calendar.date) :: :calendar.date\n  \nto_erl(%{calendar: Calendar.ISO, year: year, month: month, day: day})\n\n  Converts a `Date` struct to an Erlang date tuple.\n\n  Only supports converting dates which are in the ISO calendar,\n  attempting to convert dates from other calendars will raise.\n\n  ## Examples\n\n      iex> Date.to_erl(~D[2000-01-01])\n      {2000, 1, 1}\n      iex> Date.to_erl(~N[2000-01-01 01:23:45])\n      {2000, 1, 1}\n\n  "
    },
    to_iso8601 = {
      description = "@spec to_iso8601(Calendar.date) :: String.t\n  \nto_iso8601(%{calendar: Calendar.ISO, year: year, month: month, day: day})\n\n  Converts the given datetime to\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  Only supports converting datetimes which are in the ISO calendar,\n  attempting to convert datetimes from other calendars will raise.\n\n  ### Examples\n\n      iex> Date.to_iso8601(~D[2000-02-28])\n      \"2000-02-28\"\n      iex> Date.to_iso8601(~N[2000-02-28 01:23:45])\n      \"2000-02-28\"\n\n  "
    },
    to_string = {
      description = "\nto_string(%{calendar: calendar, year: year, month: month, day: day})\n@spec to_string(Calendar.date) :: String.t\n  \nto_string(%{calendar: calendar, year: year, month: month, day: day})\n\n  Converts the given date to a string according to its calendar.\n\n  ### Examples\n\n      iex> Date.to_string(~D[2000-02-28])\n      \"2000-02-28\"\n      iex> Date.to_string(~N[2000-02-28 01:23:45])\n      \"2000-02-28\"\n\n  "
    }
  },
  DateTime = {
    description = "\n  A datetime implementation with a time zone.\n\n  This datetime can be seen as an ephemeral snapshot\n  of a datetime at a given time zone. For such purposes,\n  it also includes both UTC and Standard offsets, as\n  well as the zone abbreviation field used exclusively\n  for formatting purposes.\n\n  Remember, comparisons in Elixir using `==`, `>`, `<` and friends\n  are structural and based on the DateTime struct fields. For proper\n  comparison between datetimes, use the `compare/2` function.\n\n  Developers should avoid creating the DateTime struct directly\n  and instead rely on the functions provided by this module as\n  well as the ones in 3rd party calendar libraries.\n\n  ## Where are my functions?\n\n  You will notice this module only contains conversion\n  functions as well as functions that work on UTC. This\n  is because a proper DateTime implementation requires a\n  TimeZone database which currently is not provided as part\n  of Elixir.\n\n  Such may be addressed in upcoming versions, meanwhile,\n  use 3rd party packages to provide DateTime building and\n  similar functionality with time zone backing.\n  ",
    from_iso8601 = {
      description = "\nfrom_iso8601(_)\n@spec from_iso8601(String.t) :: {:ok, t, Calendar.utc_offset} | {:error, atom}\n  \nfrom_iso8601(<<year::4-bytes, ?-, month::2-bytes, ?-, day::2-bytes, sep,\n                     hour::2-bytes, ?:, min::2-bytes, ?:, sec::2-bytes, rest::binary>>) when sep in [?\\s, ?T] \n\n  Parses the extended \"Date and time of day\" format described by\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  Since ISO8601 does not include the proper time zone, the given\n  string will be converted to UTC and its offset in seconds will be\n  returned as part of this function. Therefore offset information\n  must be present in the string.\n\n  As specified in the standard, the separator \"T\" may be omitted if\n  desired as there is no ambiguity within this function.\n\n  Time representations with reduced accuracy are not supported.\n\n  ## Examples\n\n      iex> DateTime.from_iso8601(\"2015-01-23T23:50:07Z\")\n      {:ok, %DateTime{calendar: Calendar.ISO, day: 23, hour: 23, microsecond: {0, 0}, minute: 50, month: 1, second: 7, std_offset: 0,\n                      time_zone: \"Etc/UTC\", utc_offset: 0, year: 2015, zone_abbr: \"UTC\"}, 0}\n      iex> DateTime.from_iso8601(\"2015-01-23T23:50:07.123+02:30\")\n      {:ok, %DateTime{calendar: Calendar.ISO, day: 23, hour: 21, microsecond: {123000, 3}, minute: 20, month: 1, second: 7, std_offset: 0,\n                      time_zone: \"Etc/UTC\", utc_offset: 0, year: 2015, zone_abbr: \"UTC\"}, 9000}\n\n      iex> DateTime.from_iso8601(\"2015-01-23P23:50:07\")\n      {:error, :invalid_format}\n      iex> DateTime.from_iso8601(\"2015-01-23 23:50:07A\")\n      {:error, :invalid_format}\n      iex> DateTime.from_iso8601(\"2015-01-23T23:50:07\")\n      {:error, :missing_offset}\n      iex> DateTime.from_iso8601(\"2015-01-23 23:50:61\")\n      {:error, :invalid_time}\n      iex> DateTime.from_iso8601(\"2015-01-32 23:50:07\")\n      {:error, :invalid_date}\n\n      iex> DateTime.from_iso8601(\"2015-01-23T23:50:07.123-00:00\")\n      {:error, :invalid_format}\n      iex> DateTime.from_iso8601(\"2015-01-23T23:50:07.123-00:60\")\n      {:error, :invalid_format}\n\n  "
    },
    from_naive = {
      description = "@spec from_naive(NaiveDateTime.t, Calendar.time_zone) :: {:ok, DateTime.t}\n  \nfrom_naive(%NaiveDateTime{hour: hour, minute: minute, second: second, microsecond: microsecond,\n                                year: year, month: month, day: day}, \"Etc/UTC\")\n\n  Converts the given NaiveDateTime to DateTime.\n\n  It expects a time zone to put the NaiveDateTime in.\n  Currently it only supports \"Etc/UTC\" as time zone.\n\n  ## Examples\n\n      iex> DateTime.from_naive(~N[2016-05-24 13:26:08.003], \"Etc/UTC\")\n      {:ok, %DateTime{calendar: Calendar.ISO, day: 24, hour: 13, microsecond: {3000, 3}, minute: 26,\n                      month: 5, second: 8, std_offset: 0, time_zone: \"Etc/UTC\", utc_offset: 0,\n                      year: 2016, zone_abbr: \"UTC\"}}\n\n  "
    },
    t = {
      description = "t :: %__MODULE__{year: Calendar.year, month: Calendar.month, day: Calendar.day,\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    to_date = {
      description = "\nto_date(%DateTime{year: year, month: month, day: day, calendar: calendar})\n\n  Converts a `DateTime` into a `Date`.\n\n  Because `Date` does not hold time nor time zone information,\n  data will be lost during the conversion.\n\n  ## Examples\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> DateTime.to_date(dt)\n      ~D[2000-02-29]\n\n  "
    },
    to_iso8601 = {
      description = "@spec to_iso8601(Calendar.datetime) :: String.t\n  \nto_iso8601(%{calendar: Calendar.ISO, year: year, month: month, day: day,\n                  hour: hour, minute: minute, second: second, microsecond: microsecond,\n                  time_zone: time_zone, zone_abbr: zone_abbr, utc_offset: utc_offset, std_offset: std_offset})\n\n  Converts the given datetime to\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601) format.\n\n  Only supports converting datetimes which are in the ISO calendar,\n  attempting to convert datetimes from other calendars will raise.\n\n  WARNING: the ISO 8601 datetime format does not contain the time zone nor\n  its abbreviation, which means information is lost when converting to such\n  format.\n\n  ### Examples\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> DateTime.to_iso8601(dt)\n      \"2000-02-29T23:00:07+01:00\"\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"UTC\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 0, std_offset: 0, time_zone: \"Etc/UTC\"}\n      iex> DateTime.to_iso8601(dt)\n      \"2000-02-29T23:00:07Z\"\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"AMT\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: -14400, std_offset: 0, time_zone: \"America/Manaus\"}\n      iex> DateTime.to_iso8601(dt)\n      \"2000-02-29T23:00:07-04:00\"\n  "
    },
    to_naive = {
      description = "\nto_naive(%DateTime{year: year, month: month, day: day, calendar: calendar,\n                         hour: hour, minute: minute, second: second, microsecond: microsecond})\n\n  Converts a `DateTime` into a `NaiveDateTime`.\n\n  Because `NaiveDateTime` does not hold time zone information,\n  any time zone related data will be lost during the conversion.\n\n  ## Examples\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 1},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> DateTime.to_naive(dt)\n      ~N[2000-02-29 23:00:07.0]\n\n  "
    },
    to_string = {
      description = "\nto_string(%{calendar: calendar, year: year, month: month, day: day,\n                    hour: hour, minute: minute, second: second, microsecond: microsecond,\n                    time_zone: time_zone, zone_abbr: zone_abbr, utc_offset: utc_offset, std_offset: std_offset})\n@spec to_string(Calendar.datetime) :: String.t\n  \nto_string(%{calendar: calendar, year: year, month: month, day: day,\n                  hour: hour, minute: minute, second: second, microsecond: microsecond,\n                  time_zone: time_zone, zone_abbr: zone_abbr, utc_offset: utc_offset, std_offset: std_offset})\n\n  Converts the given datetime to a string according to its calendar.\n\n  ### Examples\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> DateTime.to_string(dt)\n      \"2000-02-29 23:00:07+01:00 CET Europe/Warsaw\"\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"UTC\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 0, std_offset: 0, time_zone: \"Etc/UTC\"}\n      iex> DateTime.to_string(dt)\n      \"2000-02-29 23:00:07Z\"\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"AMT\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: -14400, std_offset: 0, time_zone: \"America/Manaus\"}\n      iex> DateTime.to_string(dt)\n      \"2000-02-29 23:00:07-04:00 AMT America/Manaus\"\n  "
    },
    to_time = {
      description = "\nto_time(%DateTime{hour: hour, minute: minute, second: second, microsecond: microsecond})\n\n  Converts a `DateTime` into `Time`.\n\n  Because `Time` does not hold date nor time zone information,\n  data will be lost during the conversion.\n\n  ## Examples\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 1},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> DateTime.to_time(dt)\n      ~T[23:00:07.0]\n\n  "
    },
    to_unix = {
      description = "@spec to_unix(DateTime.t, System.time_unit) :: non_neg_integer\n  \nto_unix(%DateTime{calendar: Calendar.ISO, std_offset: std_offset, utc_offset: utc_offset,\n                        hour: hour, minute: minute, second: second, microsecond: {microsecond, _},\n                        year: year, month: month, day: day}, unit) when year >= 0 \n\n  Converts the given DateTime to Unix time.\n\n  The DateTime is expected to be using the ISO calendar\n  with a year greater than or equal to 0.\n\n  It will return the integer with the given unit,\n  according to `System.convert_time_unit/3`.\n\n  ## Examples\n\n      iex> 1464096368 |> DateTime.from_unix!() |> DateTime.to_unix()\n      1464096368\n\n      iex> dt = %DateTime{calendar: Calendar.ISO, day: 20, hour: 18, microsecond: {273806, 6},\n      ...>                minute: 58, month: 11, second: 19, time_zone: \"America/Montevideo\",\n      ...>                utc_offset: -10800, std_offset: 3600, year: 2014, zone_abbr: \"UYST\"}\n      iex> DateTime.to_unix(dt)\n      1416517099\n\n      iex> flamel = %DateTime{calendar: Calendar.ISO, day: 22, hour: 8, microsecond: {527771, 6},\n      ...>                minute: 2, month: 3, second: 25, std_offset: 0, time_zone: \"Etc/UTC\",\n      ...>                utc_offset: 0, year: 1418, zone_abbr: \"UTC\"}\n      iex> DateTime.to_unix(flamel)\n      -17412508655\n\n  "
    }
  },
  Dict = {
    __using__ = {
      description = "\n__using__(_)\n"
    },
    description = "\n  WARNING: this module is deprecated.\n\n  If you need a general dictionary, use the `Map` module.\n  If you need to manipulate keyword lists, use `Keyword`.\n\n  To convert maps into keywords and vice-versa, use the\n  `new` function in the respective modules.\n  ",
    drop = {
      description = "\ndrop(dict, keys)\n"
    },
    ["equal?"] = {
      description = "\nequal?(dict1, dict2)\n"
    },
    ["fetch!"] = {
      description = "\nfetch!(dict, key)\n"
    },
    get = {
      description = "\nget(dict, key, default \\\\ nil)\n"
    },
    get_and_update = {
      description = "\nget_and_update(dict, key, fun)\n"
    },
    get_lazy = {
      description = "\nget_lazy(dict, key, fun) when is_function(fun, 0) \n"
    },
    ["has_key?"] = {
      description = "\nhas_key?(dict, key)\n"
    },
    key = {
      description = "key :: any\n"
    },
    keys = {
      description = "\nkeys(dict)\n"
    },
    pop = {
      description = "\npop(dict, key, default \\\\ nil)\n"
    },
    pop_lazy = {
      description = "\npop_lazy(dict, key, fun) when is_function(fun, 0) \n"
    },
    put_new = {
      description = "\nput_new(dict, key, value)\n"
    },
    put_new_lazy = {
      description = "\nput_new_lazy(dict, key, fun) when is_function(fun, 0) \n"
    },
    split = {
      description = "\nsplit(dict, keys)\n"
    },
    t = {
      description = "t :: list | map\n"
    },
    take = {
      description = "\ntake(dict, keys)\n"
    },
    to_list = {
      description = "\nto_list(dict)\n"
    },
    update = {
      description = "\nupdate(dict, key, initial, fun)\n"
    },
    ["update!"] = {
      description = "\nupdate!(dict, key, fun)\n"
    },
    value = {
      description = "value :: any\n"
    },
    values = {
      description = "\nvalues(dict)\n"
    }
  },
  EEx = {
    Compiler = {
      description = "false"
    },
    Engine = {
      __using__ = {
        description = "\n__using__(_)\nfalse"
      },
      description = "\n  Basic EEx engine that ships with Elixir.\n\n  An engine needs to implement four functions:\n\n    * `init(opts)` - returns the initial buffer\n\n    * `handle_body(quoted)` - receives the final built quoted\n      expression, should do final post-processing and return a\n      quoted expression.\n\n    * `handle_text(buffer, text)` - it receives the buffer,\n      the text and must return a new quoted expression.\n\n    * `handle_expr(buffer, marker, expr)` - it receives the buffer,\n      the marker, the expr and must return a new quoted expression.\n\n      The marker is what follows exactly after `<%`. For example,\n      `<% foo %>` has an empty marker, but `<%= foo %>` has `\"=\"`\n      as marker. The allowed markers so far are: `\"\"` and `\"=\"`.\n\n      Read `handle_expr/3` below for more information about the markers\n      implemented by default by this engine.\n\n  `EEx.Engine` can be used directly if one desires to use the\n  default implementations for the functions above.\n  ",
      handle_assign = {
        description = "@spec handle_assign(Macro.t) :: Macro.t\n  \nhandle_assign(arg)\n\n  Handles assigns in quoted expressions.\n\n  A warning will be printed on missing assigns.\n  Future versions will raise.\n\n  This can be added to any custom engine by invoking\n  `handle_assign/1` with `Macro.prewalk/2`:\n\n      def handle_expr(buffer, token, expr) do\n        expr = Macro.prewalk(expr, &EEx.Engine.handle_assign/1)\n        EEx.Engine.handle_expr(buffer, token, expr)\n      end\n\n  "
      },
      handle_body = {
        description = "\nhandle_body(quoted)\n  The default implementation simply returns the given expression.\n  \n\nhandle_body(quoted)\n"
      },
      handle_expr = {
        description = "\nhandle_expr(buffer, \"\", expr)\n\nhandle_expr(buffer, \"=\", expr)\n  Implements expressions according to the markers.\n\n      <% Elixir expression - inline with output %>\n      <%= Elixir expression - replace with result %>\n\n  All other markers are not implemented by this engine.\n  \n\nhandle_expr(buffer, marker, expr)\n"
      },
      handle_text = {
        description = "\nhandle_text(buffer, text)\n  The default implementation simply concatenates text to the buffer.\n  \n\nhandle_text(buffer, text)\n"
      },
      init = {
        description = "@spec fetch_assign!(map, Map.key) :: term | nil\n  \ninit(_opts)\n  Returns an empty string as initial buffer.\n  \n\ninit(opts)\n"
      }
    },
    SmartEngine = {
      description = "\n  The default engine used by EEx.\n\n  It includes assigns (like `@foo`) and possibly other\n  conveniences in the future.\n\n  ## Examples\n\n      iex> EEx.eval_string(\"<%= @foo %>\", assigns: [foo: 1])\n      \"1\"\n\n  In the example above, we can access the value `foo` under\n  the binding `assigns` using `@foo`. This is useful because\n  a template, after being compiled, can receive different\n  assigns and would not require recompilation for each\n  variable set.\n\n  Assigns can also be used when compiled to a function:\n\n      # sample.eex\n      <%= @a + @b %>\n\n      # sample.ex\n      defmodule Sample do\n        require EEx\n        EEx.function_from_file :def, :sample, \"sample.eex\", [:assigns]\n      end\n\n      # iex\n      Sample.sample(a: 1, b: 2) #=> \"3\"\n\n  ",
      handle_expr = {
        description = "\nhandle_expr(buffer, mark, expr)\n"
      }
    },
    SyntaxError = {
      message = {
        description = "\nmessage(exception)\n"
      }
    },
    Tokenizer = {
      content = {
        description = "content :: IO.chardata\n"
      },
      description = "false",
      line = {
        description = "line :: non_neg_integer\n"
      },
      token = {
        description = "token :: {:text, content} |\n"
      },
      tokenize = {
        description = "\ntokenize(list, line, opts)\n      when is_list(list) and is_integer(line) and line >= 0 and is_list(opts) \n@spec tokenize(binary | charlist, line, Keyword.t) :: {:ok, [token]} | {:error, line, String.t}\n  \ntokenize(bin, line, opts)\n      when is_binary(bin) and is_integer(line) and line >= 0 and is_list(opts) \n\n  Tokenizes the given charlist or binary.\n\n  It returns {:ok, list} with the following tokens:\n\n    * `{:text, content}`\n    * `{:expr, line, marker, content}`\n    * `{:start_expr, line, marker, content}`\n    * `{:middle_expr, line, marker, content}`\n    * `{:end_expr, line, marker, content}`\n\n  Or `{:error, line, error}` in case of errors.\n  "
      }
    },
    description = "\n  EEx stands for Embedded Elixir. It allows you to embed\n  Elixir code inside a string in a robust way.\n\n      iex> EEx.eval_string \"foo <%= bar %>\", [bar: \"baz\"]\n      \"foo baz\"\n\n  ## API\n\n  This module provides 3 main APIs for you to use:\n\n    1. Evaluate a string (`eval_string`) or a file (`eval_file`)\n       directly. This is the simplest API to use but also the\n       slowest, since the code is evaluated and not compiled before.\n\n    2. Define a function from a string (`function_from_string`)\n       or a file (`function_from_file`). This allows you to embed\n       the template as a function inside a module which will then\n       be compiled. This is the preferred API if you have access\n       to the template at compilation time.\n\n    3. Compile a string (`compile_string`) or a file (`compile_file`)\n       into Elixir syntax tree. This is the API used by both functions\n       above and is available to you if you want to provide your own\n       ways of handling the compiled template.\n\n  ## Options\n\n  All functions in this module accept EEx-related options.\n  They are:\n\n    * `:line` - the line to be used as the template start. Defaults to 1.\n    * `:file` - the file to be used in the template. Defaults to the given\n      file the template is read from or to \"nofile\" when compiling from a string.\n    * `:engine` - the EEx engine to be used for compilation.\n    * `:trim` - trims whitespace left/right of quotation tags\n\n  ## Engine\n\n  EEx has the concept of engines which allows you to modify or\n  transform the code extracted from the given string or file.\n\n  By default, `EEx` uses the `EEx.SmartEngine` that provides some\n  conveniences on top of the simple `EEx.Engine`.\n\n  ### Tags\n\n  `EEx.SmartEngine` supports the following tags:\n\n      <% Elixir expression - inline with output %>\n      <%= Elixir expression - replace with result %>\n      <%% EEx quotation - returns the contents inside %>\n      <%# Comments - they are discarded from source %>\n\n  All expressions that output something to the template\n  **must** use the equals sign (`=`). Since everything in\n  Elixir is an expression, there are no exceptions for this rule.\n  For example, while some template languages would special-case\n  `if/2` clauses, they are treated the same in EEx and\n  also require `=` in order to have their result printed:\n\n      <%= if true do %>\n        It is obviously true\n      <% else %>\n        This will never appear\n      <% end %>\n\n  Notice that different engines may have different rules\n  for each tag. Other tags may be added in future versions.\n\n  ### Macros\n\n  `EEx.SmartEngine` also adds some macros to your template.\n  An example is the `@` macro which allows easy data access\n  in a template:\n\n      iex> EEx.eval_string \"<%= @foo %>\", assigns: [foo: 1]\n      \"1\"\n\n  In other words, `<%= @foo %>` translates to:\n\n      <%= {:ok, v} = Access.fetch(assigns, :foo); v %>\n\n  The `assigns` extension is useful when the number of variables\n  required by the template is not specified at compilation time.\n  ",
    function_from_file = {
      description = "\nfunction_from_file(kind, name, file, args \\\\ [], options \\\\ [])\n\n  Generates a function definition from the file contents.\n\n  The kind (`:def` or `:defp`) must be given, the\n  function name, its arguments and the compilation options.\n\n  This function is useful in case you have templates but\n  you want to precompile inside a module for speed.\n\n  ## Examples\n\n      # sample.eex\n      <%= a + b %>\n\n      # sample.ex\n      defmodule Sample do\n        require EEx\n        EEx.function_from_file :def, :sample, \"sample.eex\", [:a, :b]\n      end\n\n      # iex\n      Sample.sample(1, 2) #=> \"3\"\n\n  "
    },
    function_from_string = {
      description = "\nfunction_from_string(kind, name, source, args \\\\ [], options \\\\ [])\n\n  Generates a function definition from the string.\n\n  The kind (`:def` or `:defp`) must be given, the\n  function name, its arguments and the compilation options.\n\n  ## Examples\n\n      iex> defmodule Sample do\n      ...>   require EEx\n      ...>   EEx.function_from_string :def, :sample, \"<%= a + b %>\", [:a, :b]\n      ...> end\n      iex> Sample.sample(1, 2)\n      \"3\"\n\n  "
    }
  },
  Enum = {
    EmptyError = {},
    OutOfBoundsError = {},
    ["all?"] = {
      description = "\nall?(enumerable, fun) when is_function(fun, 1) \n@spec all?(t) :: boolean\n  @spec all?(t, (element -> as_boolean(term))) :: boolean\n\n  \nall?(enumerable, fun) when is_list(enumerable) and is_function(fun, 1) \n\n  Returns true if the given `fun` evaluates to true on all of the items in the enumerable.\n\n  It stops the iteration at the first invocation that returns `false` or `nil`.\n\n  ## Examples\n\n      iex> Enum.all?([2, 4, 6], fn(x) -> rem(x, 2) == 0 end)\n      true\n\n      iex> Enum.all?([2, 3, 4], fn(x) -> rem(x, 2) == 0 end)\n      false\n\n  If no function is given, it defaults to checking if\n  all items in the enumerable are truthy values.\n\n      iex> Enum.all?([1, 2, 3])\n      true\n\n      iex> Enum.all?([1, nil, 3])\n      false\n\n  "
    },
    ["any?"] = {
      description = "\nany?(enumerable, fun) when is_function(fun, 1) \n@spec any?(t) :: boolean\n  @spec any?(t, (element -> as_boolean(term))) :: boolean\n\n  \nany?(enumerable, fun) when is_list(enumerable) and is_function(fun, 1) \n\n  Returns true if the given `fun` evaluates to true on any of the items in the enumerable.\n\n  It stops the iteration at the first invocation that returns a truthy value (not `false` or `nil`).\n\n  ## Examples\n\n      iex> Enum.any?([2, 4, 6], fn(x) -> rem(x, 2) == 1 end)\n      false\n\n      iex> Enum.any?([2, 3, 4], fn(x) -> rem(x, 2) == 1 end)\n      true\n\n  If no function is given, it defaults to checking if at least one item\n  in the enumerable is a truthy value.\n\n      iex> Enum.any?([false, false, false])\n      false\n\n      iex> Enum.any?([false, true, false])\n      true\n\n  "
    },
    concat = {
      description = "@spec concat(t, t) :: t\n  \nconcat(left, right)\n\n  Concatenates the enumerable on the right with the enumerable on the\n  left.\n\n  This function produces the same result as the `Kernel.++/2` operator\n  for lists.\n\n  ## Examples\n\n      iex> Enum.concat(1..3, 4..6)\n      [1, 2, 3, 4, 5, 6]\n\n      iex> Enum.concat([1, 2, 3], [4, 5, 6])\n      [1, 2, 3, 4, 5, 6]\n\n  "
    },
    count = {
      description = "\ncount(_function)\n\ncount(map)\n\ncount(_list)\n@spec count(t) :: non_neg_integer\n  \ncount(enumerable)\n\n  Returns the size of the enumerable.\n\n  ## Examples\n\n      iex> Enum.count([1, 2, 3])\n      3\n\n  "
    },
    default = {
      description = "default :: any\n\n  A partially applied reduce function.\n\n  The continuation is the closure returned as a result when\n  the enumeration is suspended. When invoked, it expects\n  a new accumulator and it returns the result.\n\n  A continuation is easily implemented as long as the reduce\n  function is defined in a tail recursive fashion. If the function\n  is tail recursive, all the state is passed as arguments, so\n  the continuation would simply be the reducing function partially\n  applied.\n  "
    },
    description = "\n  Provides a set of algorithms that enumerate over enumerables according\n  to the `Enumerable` protocol.\n\n      iex> Enum.map([1, 2, 3], fn(x) -> x * 2 end)\n      [2, 4, 6]\n\n  Some particular types, like maps, yield a specific format on enumeration.\n  For example, the argument is always a `{key, value}` tuple for maps:\n\n      iex> map = %{a: 1, b: 2}\n      iex> Enum.map(map, fn {k, v} -> {k, v * 2} end)\n      [a: 2, b: 4]\n\n  Note that the functions in the `Enum` module are eager: they always\n  start the enumeration of the given enumerable. The `Stream` module\n  allows lazy enumeration of enumerables and provides infinite streams.\n\n  Since the majority of the functions in `Enum` enumerate the whole\n  enumerable and return a list as result, infinite streams need to\n  be carefully used with such functions, as they can potentially run\n  forever. For example:\n\n      Enum.each Stream.cycle([1, 2, 3]), &IO.puts(&1)\n\n  ",
    drop = {
      description = "\ndrop(enumerable, amount) when is_integer(amount) and amount < 0 \n@spec drop(t, integer) :: list\n  \ndrop(enumerable, amount) when is_integer(amount) and amount >= 0 \n\n  Drops the `amount` of items from the enumerable.\n\n  If a negative `amount` is given, the `amount` of last values will be dropped.\n\n  The `enumerable` is enumerated once to retrieve the proper index and\n  the remaining calculation is performed from the end.\n\n  ## Examples\n\n      iex> Enum.drop([1, 2, 3], 2)\n      [3]\n\n      iex> Enum.drop([1, 2, 3], 10)\n      []\n\n      iex> Enum.drop([1, 2, 3], 0)\n      [1, 2, 3]\n\n      iex> Enum.drop([1, 2, 3], -1)\n      [1, 2]\n\n  "
    },
    drop_every = {
      description = "\ndrop_every(enumerable, nth) when is_integer(nth) and nth > 1 \n\ndrop_every([], nth) when is_integer(nth), \n\ndrop_every(enumerable, 0)\n@spec drop_every(t, non_neg_integer) :: list\n  \ndrop_every(_enumerable, 1)\n\n  Returns a list of every `nth` item in the enumerable dropped,\n  starting with the first element.\n\n  The first item is always dropped, unless `nth` is 0.\n\n  The second argument specifying every `nth` item must be a non-negative\n  integer.\n\n  ## Examples\n\n      iex> Enum.drop_every(1..10, 2)\n      [2, 4, 6, 8, 10]\n\n      iex> Enum.drop_every(1..10, 0)\n      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]\n\n      iex> Enum.drop_every([1, 2, 3], 1)\n      []\n\n  "
    },
    drop_while = {
      description = "@spec drop_while(t, (element -> as_boolean(term))) :: list\n  \ndrop_while(enumerable, fun)\n\n  Drops items at the beginning of the enumerable while `fun` returns a\n  truthy value.\n\n  ## Examples\n\n      iex> Enum.drop_while([1, 2, 3, 2, 1], fn(x) -> x < 3 end)\n      [3, 2, 1]\n\n  "
    },
    each = {
      description = "@spec each(t, (element -> any)) :: :ok\n  \neach(enumerable, fun) when is_function(fun, 1) \n\n  Invokes the given `fun` for each item in the enumerable.\n\n  Returns `:ok`.\n\n  ## Examples\n\n      Enum.each([\"some\", \"example\"], fn(x) -> IO.puts x end)\n      \"some\"\n      \"example\"\n      #=> :ok\n\n  "
    },
    element = {
      description = "element :: any\n\n  A partially applied reduce function.\n\n  The continuation is the closure returned as a result when\n  the enumeration is suspended. When invoked, it expects\n  a new accumulator and it returns the result.\n\n  A continuation is easily implemented as long as the reduce\n  function is defined in a tail recursive fashion. If the function\n  is tail recursive, all the state is passed as arguments, so\n  the continuation would simply be the reducing function partially\n  applied.\n  "
    },
    ["empty?"] = {
      description = "@spec empty?(t) :: boolean\n  \nempty?(enumerable)\n\n  Determines if the enumerable is empty.\n\n  Returns `true` if `enumerable` is empty, otherwise `false`.\n\n  ## Examples\n\n      iex> Enum.empty?([])\n      true\n\n      iex> Enum.empty?([1, 2, 3])\n      false\n\n  "
    },
    fetch = {
      description = "\nfetch(enumerable, index) when is_integer(index) \n\nfetch(enumerable, index) when is_integer(index) and index < 0 \n\nfetch(first..last, index) when is_integer(index) \n@spec fetch(t, index) :: {:ok, element} | :error\n  \nfetch(enumerable, index) when is_list(enumerable) and is_integer(index) \n\n  Finds the element at the given `index` (zero-based).\n\n  Returns `{:ok, element}` if found, otherwise `:error`.\n\n  A negative `index` can be passed, which means the `enumerable` is\n  enumerated once and the `index` is counted from the end (e.g.\n  `-1` fetches the last element).\n\n  Note this operation takes linear time. In order to access\n  the element at index `index`, it will need to traverse `index`\n  previous elements.\n\n  ## Examples\n\n      iex> Enum.fetch([2, 4, 6], 0)\n      {:ok, 2}\n\n      iex> Enum.fetch([2, 4, 6], -3)\n      {:ok, 2}\n\n      iex> Enum.fetch([2, 4, 6], 2)\n      {:ok, 6}\n\n      iex> Enum.fetch([2, 4, 6], 4)\n      :error\n\n  "
    },
    filter = {
      description = "@spec filter(t, (element -> as_boolean(term))) :: list\n  \nfilter(enumerable, fun) when is_function(fun, 1) \n\n  Filters the enumerable, i.e. returns only those elements\n  for which `fun` returns a truthy value.\n\n  See also `reject/2`.\n\n  ## Examples\n\n      iex> Enum.filter([1, 2, 3], fn(x) -> rem(x, 2) == 0 end)\n      [2]\n\n  "
    },
    filter_map = {
      description = "@spec filter_map(t, (element -> as_boolean(term)),\n    (element -> element)) :: list\n\n  \nfilter_map(enumerable, filter, mapper)\n      when is_function(filter, 1) and is_function(mapper, 1) \n\n  Filters the enumerable and maps its elements in one pass.\n\n  ## Examples\n\n      iex> Enum.filter_map([1, 2, 3], fn(x) -> rem(x, 2) == 0 end, &(&1 * 2))\n      [4]\n\n  "
    },
    find = {
      description = "\nfind(enumerable, default, fun) when is_function(fun, 1) \n@spec find(t, default, (element -> any)) :: element | default\n  \nfind(enumerable, default, fun) when is_list(enumerable) and is_function(fun, 1) \n\n  Returns the first item for which `fun` returns a truthy value.\n  If no such item is found, returns `default`.\n\n  ## Examples\n\n      iex> Enum.find([2, 4, 6], fn(x) -> rem(x, 2) == 1 end)\n      nil\n\n      iex> Enum.find([2, 4, 6], 0, fn(x) -> rem(x, 2) == 1 end)\n      0\n\n      iex> Enum.find([2, 3, 4], fn(x) -> rem(x, 2) == 1 end)\n      3\n\n  "
    },
    find_index = {
      description = "@spec find_index(t, (element -> any)) :: non_neg_integer | nil\n  \nfind_index(enumerable, fun) when is_function(fun, 1) \n\n  Similar to `find/3`, but returns the index (zero-based)\n  of the element instead of the element itself.\n\n  ## Examples\n\n      iex> Enum.find_index([2, 4, 6], fn(x) -> rem(x, 2) == 1 end)\n      nil\n\n      iex> Enum.find_index([2, 3, 4], fn(x) -> rem(x, 2) == 1 end)\n      1\n\n  "
    },
    find_value = {
      description = "\nfind_value(enumerable, default, fun) when is_function(fun, 1) \n@spec find_value(t, any, (element -> any)) :: any | nil\n  \nfind_value(enumerable, default, fun) when is_list(enumerable) and is_function(fun, 1) \n\n  Similar to `find/3`, but returns the value of the function\n  invocation instead of the element itself.\n\n  ## Examples\n\n      iex> Enum.find_value([2, 4, 6], fn(x) -> rem(x, 2) == 1 end)\n      nil\n\n      iex> Enum.find_value([2, 3, 4], fn(x) -> rem(x, 2) == 1 end)\n      true\n\n      iex> Enum.find_value([1, 2, 3], \"no bools!\", &is_boolean/1)\n      \"no bools!\"\n\n  "
    },
    flat_map = {
      description = "@spec flat_map(t, (element -> t)) :: list\n  \nflat_map(enumerable, fun) when is_function(fun, 1) \n\n  Maps the given `fun` over `enumerable` and flattens the result.\n\n  This function returns a new enumerable built by appending the result of invoking `fun`\n  on each element of `enumerable` together; conceptually, this is similar to a\n  combination of `map/2` and `concat/1`.\n\n  ## Examples\n\n      iex> Enum.flat_map([:a, :b, :c], fn(x) -> [x, x] end)\n      [:a, :a, :b, :b, :c, :c]\n\n      iex> Enum.flat_map([{1, 3}, {4, 6}], fn({x, y}) -> x..y end)\n      [1, 2, 3, 4, 5, 6]\n\n      iex> Enum.flat_map([:a, :b, :c], fn(x) -> [[x]] end)\n      [[:a], [:b], [:c]]\n\n  "
    },
    group_by = {
      description = "\ngroup_by(enumerable, dict, fun) when is_function(fun, 1) \n@spec group_by(t, (element -> any), (element -> any)) :: map\n  \ngroup_by(enumerable, key_fun, value_fun)\n      when is_function(key_fun, 1) and is_function(value_fun, 1) \n\n  Splits the enumerable into groups based on `key_fun`.\n\n  The result is a map where each key is given by `key_fun` and each\n  value is a list of elements given by `value_fun`. Ordering is preserved.\n\n  ## Examples\n\n      iex> Enum.group_by(~w{ant buffalo cat dingo}, &String.length/1)\n      %{3 => [\"ant\", \"cat\"], 7 => [\"buffalo\"], 5 => [\"dingo\"]}\n\n      iex> Enum.group_by(~w{ant buffalo cat dingo}, &String.length/1, &String.first/1)\n      %{3 => [\"a\", \"c\"], 7 => [\"b\"], 5 => [\"d\"]}\n\n  "
    },
    index = {
      description = "index :: integer\n\n  A partially applied reduce function.\n\n  The continuation is the closure returned as a result when\n  the enumeration is suspended. When invoked, it expects\n  a new accumulator and it returns the result.\n\n  A continuation is easily implemented as long as the reduce\n  function is defined in a tail recursive fashion. If the function\n  is tail recursive, all the state is passed as arguments, so\n  the continuation would simply be the reducing function partially\n  applied.\n  "
    },
    into = {
      description = "@spec into(Enumerable.t, Collectable.t, (term -> term)) :: Collectable.t\n\n  \ninto(enumerable, collectable, transform)\n      when is_function(transform, 1) \n  Inserts the given `enumerable` into a `collectable` according to the\n  transformation function.\n\n  ## Examples\n\n      iex> Enum.into([2, 3], [3], fn x -> x * 3 end)\n      [3, 6, 9]\n\n  \n\ninto(enumerable, collectable)\n\ninto(enumerable, %{} = collectable)\n\ninto(enumerable, %{} = collectable) when is_list(enumerable) \n\ninto(%{} = enumerable, %{} = collectable)\n\ninto(enumerable, %_{} = collectable)\n@spec into(Enumerable.t, Collectable.t) :: Collectable.t\n  \ninto(%_{} = enumerable, collectable)\n\n  Inserts the given `enumerable` into a `collectable`.\n\n  ## Examples\n\n      iex> Enum.into([1, 2], [0])\n      [0, 1, 2]\n\n      iex> Enum.into([a: 1, b: 2], %{})\n      %{a: 1, b: 2}\n\n      iex> Enum.into(%{a: 1}, %{b: 2})\n      %{a: 1, b: 2}\n\n      iex> Enum.into([a: 1, a: 2], %{})\n      %{a: 2}\n\n  "
    },
    join = {
      description = "@spec join(t, String.t) :: String.t\n  \njoin(enumerable, joiner) when is_binary(joiner) \n\n  Joins the given enumerable into a binary using `joiner` as a\n  separator.\n\n  If `joiner` is not passed at all, it defaults to the empty binary.\n\n  All items in the enumerable must be convertible to a binary,\n  otherwise an error is raised.\n\n  ## Examples\n\n      iex> Enum.join([1, 2, 3])\n      \"123\"\n\n      iex> Enum.join([1, 2, 3], \" = \")\n      \"1 = 2 = 3\"\n\n  "
    },
    map = {
      description = "\nmap(enumerable, fun) when is_function(fun, 1) \n@spec map(t, (element -> any)) :: list\n  \nmap(enumerable, fun) when is_list(enumerable) and is_function(fun, 1) \n\n  Returns a list where each item is the result of invoking\n  `fun` on each corresponding item of `enumerable`.\n\n  For maps, the function expects a key-value tuple.\n\n  ## Examples\n\n      iex> Enum.map([1, 2, 3], fn(x) -> x * 2 end)\n      [2, 4, 6]\n\n      iex> Enum.map([a: 1, b: 2], fn({k, v}) -> {k, -v} end)\n      [a: -1, b: -2]\n\n  "
    },
    map_every = {
      description = "\nmap_every(enumerable, nth, fun) when is_integer(nth) and nth > 1 \n\nmap_every([], nth, _fun) when is_integer(nth) and nth > 1, \n\nmap_every(enumerable, 0, _fun)\n@spec map_every(t, non_neg_integer, (element -> any)) :: list\n  \nmap_every(enumerable, 1, fun)\n\n  Returns a list of results of invoking `fun` on every `nth`\n  item of `enumerable`, starting with the first element.\n\n  The first item is always passed to the given function.\n\n  The second argument specifying every `nth` item must be a non-negative\n  integer.\n\n  ## Examples\n\n      iex> Enum.map_every(1..10, 2, fn(x) -> x * 2 end)\n      [2, 2, 6, 4, 10, 6, 14, 8, 18, 10]\n\n      iex> Enum.map_every(1..5, 0, fn(x) -> x * 2 end)\n      [1, 2, 3, 4, 5]\n\n      iex> Enum.map_every([1, 2, 3], 1, fn(x) -> x * 2 end)\n      [2, 4, 6]\n\n  "
    },
    map_join = {
      description = "@spec map_join(t, String.t, (element -> any)) :: String.t\n  \nmap_join(enumerable, joiner, mapper) when is_binary(joiner) and is_function(mapper, 1) \n\n  Maps and joins the given enumerable in one pass.\n\n  `joiner` can be either a binary or a list and the result will be of\n  the same type as `joiner`.\n  If `joiner` is not passed at all, it defaults to an empty binary.\n\n  All items in the enumerable must be convertible to a binary,\n  otherwise an error is raised.\n\n  ## Examples\n\n      iex> Enum.map_join([1, 2, 3], &(&1 * 2))\n      \"246\"\n\n      iex> Enum.map_join([1, 2, 3], \" = \", &(&1 * 2))\n      \"2 = 4 = 6\"\n\n  "
    },
    map_reduce = {
      description = "@spec map_reduce(t, any, (element, any -> {any, any})) :: {any, any}\n  \nmap_reduce(enumerable, acc, fun) when is_function(fun, 2) \n\n  Invokes the given function to each item in the enumerable to reduce\n  it to a single element, while keeping an accumulator.\n\n  Returns a tuple where the first element is the mapped enumerable and\n  the second one is the final accumulator.\n\n  The function, `fun`, receives two arguments: the first one is the\n  element, and the second one is the accumulator. `fun` must return\n  a tuple with two elements in the form of `{result, accumulator}`.\n\n  For maps, the first tuple element must be a `{key, value}` tuple.\n\n  ## Examples\n\n      iex> Enum.map_reduce([1, 2, 3], 0, fn(x, acc) -> {x * 2, x + acc} end)\n      {[2, 4, 6], 6}\n\n  "
    },
    max = {
      description = "@spec max(t, (() -> empty_result)) :: element | empty_result | no_return when empty_result: any\n  \nmax(enumerable, empty_fallback) when is_function(empty_fallback, 0) \n\n  Returns the maximal element in the enumerable according\n  to Erlang's term ordering.\n\n  If multiple elements are considered maximal, the first one that was found\n  is returned.\n\n  Calls the provided `empty_fallback` function and returns its value if\n  `enumerable` is empty. The default `empty_fallback` raises `Enum.EmptyError`.\n\n  ## Examples\n\n      iex> Enum.max([1, 2, 3])\n      3\n\n      iex> Enum.max([], fn -> 0 end)\n      0\n\n  "
    },
    max_by = {
      description = "@spec max_by(t, (element -> any), (() -> empty_result)) :: element | empty_result | no_return when empty_result: any\n  \nmax_by(enumerable, fun, empty_fallback) when is_function(fun, 1) and is_function(empty_fallback, 0) \n\n  Returns the maximal element in the enumerable as calculated\n  by the given function.\n\n  If multiple elements are considered maximal, the first one that was found\n  is returned.\n\n  Calls the provided `empty_fallback` function and returns its value if\n  `enumerable` is empty. The default `empty_fallback` raises `Enum.EmptyError`.\n\n  ## Examples\n\n      iex> Enum.max_by([\"a\", \"aa\", \"aaa\"], fn(x) -> String.length(x) end)\n      \"aaa\"\n\n      iex> Enum.max_by([\"a\", \"aa\", \"aaa\", \"b\", \"bbb\"], &String.length/1)\n      \"aaa\"\n\n      iex> Enum.max_by([], &String.length/1, fn -> nil end)\n      nil\n\n  "
    },
    ["member?"] = {
      description = "\nmember?(_function, _value)\n\nmember?(_map, _other)\n\nmember?(map, {key, value})\n\nmember?(_list, _value)\n@spec member?(t, element) :: boolean\n  \nmember?(enumerable, element)\n\n  Checks if `element` exists within the enumerable.\n\n  Membership is tested with the match (`===`) operator.\n\n  ## Examples\n\n      iex> Enum.member?(1..10, 5)\n      true\n      iex> Enum.member?(1..10, 5.0)\n      false\n\n      iex> Enum.member?([1.0, 2.0, 3.0], 2)\n      false\n      iex> Enum.member?([1.0, 2.0, 3.0], 2.000)\n      true\n\n      iex> Enum.member?([:a, :b, :c], :d)\n      false\n\n  "
    },
    min = {
      description = "@spec min(t, (() -> empty_result)) :: element | empty_result | no_return when empty_result: any\n  \nmin(enumerable, empty_fallback) when is_function(empty_fallback, 0) \n\n  Returns the minimal element in the enumerable according\n  to Erlang's term ordering.\n\n  If multiple elements are considered minimal, the first one that was found\n  is returned.\n\n  Calls the provided `empty_fallback` function and returns its value if\n  `enumerable` is empty. The default `empty_fallback` raises `Enum.EmptyError`.\n\n  ## Examples\n\n      iex> Enum.min([1, 2, 3])\n      1\n\n      iex> Enum.min([], fn -> 0 end)\n      0\n\n  "
    },
    min_by = {
      description = "@spec min_by(t, (element -> any), (() -> empty_result)) :: element | empty_result | no_return when empty_result: any\n  \nmin_by(enumerable, fun, empty_fallback) when is_function(fun, 1) and is_function(empty_fallback, 0) \n\n  Returns the minimal element in the enumerable as calculated\n  by the given function.\n\n  If multiple elements are considered minimal, the first one that was found\n  is returned.\n\n  Calls the provided `empty_fallback` function and returns its value if\n  `enumerable` is empty. The default `empty_fallback` raises `Enum.EmptyError`.\n\n  ## Examples\n\n      iex> Enum.min_by([\"a\", \"aa\", \"aaa\"], fn(x) -> String.length(x) end)\n      \"a\"\n\n      iex> Enum.min_by([\"a\", \"aa\", \"aaa\", \"b\", \"bbb\"], &String.length/1)\n      \"a\"\n\n      iex> Enum.min_by([], &String.length/1, fn -> nil end)\n      nil\n\n  "
    },
    min_max = {
      description = "@spec min_max(t, (() -> empty_result)) :: {element, element} | empty_result | no_return when empty_result: any\n  \nmin_max(enumerable, empty_fallback) when is_function(empty_fallback, 0) \n\n  Returns a tuple with the minimal and the maximal elements in the\n  enumerable according to Erlang's term ordering.\n\n  If multiple elements are considered maximal or minimal, the first one\n  that was found is returned.\n\n  Calls the provided `empty_fallback` function and returns its value if\n  `enumerable` is empty. The default `empty_fallback` raises `Enum.EmptyError`.\n\n  ## Examples\n\n      iex> Enum.min_max([2, 3, 1])\n      {1, 3}\n\n      iex> Enum.min_max([], fn -> {nil, nil} end)\n      {nil, nil}\n\n  "
    },
    min_max_by = {
      description = "@spec min_max_by(t, (element -> any), (() -> empty_result)) :: {element, element} | empty_result | no_return when empty_result: any\n  \nmin_max_by(enumerable, fun, empty_fallback) when is_function(fun, 1) and is_function(empty_fallback, 0) \n\n  Returns a tuple with the minimal and the maximal elements in the\n  enumerable as calculated by the given function.\n\n  If multiple elements are considered maximal or minimal, the first one\n  that was found is returned.\n\n  Calls the provided `empty_fallback` function and returns its value if\n  `enumerable` is empty. The default `empty_fallback` raises `Enum.EmptyError`.\n\n  ## Examples\n\n      iex> Enum.min_max_by([\"aaa\", \"bb\", \"c\"], fn(x) -> String.length(x) end)\n      {\"c\", \"aaa\"}\n\n      iex> Enum.min_max_by([\"aaa\", \"a\", \"bb\", \"c\", \"ccc\"], &String.length/1)\n      {\"a\", \"aaa\"}\n\n      iex> Enum.min_max_by([], &String.lenth/1, fn -> {nil, nil} end)\n      {nil, nil}\n\n  "
    },
    random = {
      description = "\nrandom(enumerable)\n@spec random(t) :: element | no_return\n  \nrandom(first..last)\n\n  Returns a random element of an enumerable.\n\n  Raises `Enum.EmptyError` if `enumerable` is empty.\n\n  This function uses Erlang's [`:rand` module](http://www.erlang.org/doc/man/rand.html) to calculate\n  the random value. Check its documentation for setting a\n  different random algorithm or a different seed.\n\n  The implementation is based on the\n  [reservoir sampling](https://en.wikipedia.org/wiki/Reservoir_sampling#Relation_to_Fisher-Yates_shuffle)\n  algorithm.\n  It assumes that the sample being returned can fit into memory;\n  the input `enumerable` doesn't have to, as it is traversed just once.\n\n  If a range is passed into the function, this function will pick a\n  random value between the range limits, without traversing the whole\n  range (thus executing in constant time and constant memory).\n\n  ## Examples\n\n      # Although not necessary, let's seed the random algorithm\n      iex> :rand.seed(:exsplus, {101, 102, 103})\n      iex> Enum.random([1, 2, 3])\n      2\n      iex> Enum.random([1, 2, 3])\n      1\n      iex> Enum.random(1..1_000)\n      776\n\n  "
    },
    reduce = {
      description = "\nreduce(function, acc, fun) when is_function(function, 2),\n    \n\nreduce(map, acc, fun)\n\nreduce([h | t], {:cont, acc}, fun)\n\nreduce([],      {:cont, acc}, _fun)\n\nreduce(list,    {:suspend, acc}, fun)\n\nreduce(_,       {:halt, acc}, _fun)\n\nreduce(enumerable, acc, fun) when is_function(fun, 2) \n\nreduce(%{} = enumerable, acc, fun) when is_function(fun, 2) \n\nreduce(%{__struct__: _} = enumerable, acc, fun) when is_function(fun, 2) \n@spec reduce(t, any, (element, any -> any)) :: any\n  \nreduce(first..last, acc, fun) when is_function(fun, 2) \n  Invokes `fun` for each element in the `enumerable`, passing that\n  element and the accumulator `acc` as arguments. `fun`'s return value\n  is stored in `acc`.\n\n  Returns the accumulator.\n\n  ## Examples\n\n      iex> Enum.reduce([1, 2, 3], 0, fn(x, acc) -> x + acc end)\n      6\n\n  \n\nreduce(enumerable, fun) when is_function(fun, 2) \n\nreduce([], _fun)\n@spec reduce(t, (element, any -> any)) :: any\n  \nreduce([h | t], fun) when is_function(fun, 2) \n\n  Invokes `fun` for each element in the `enumerable`, passing that\n  element and the accumulator as arguments. `fun`'s return value\n  is stored in the accumulator.\n\n  The first element of the enumerable is used as the initial value of\n  the accumulator.\n  If you wish to use another value for the accumulator, use\n  `Enumerable.reduce/3`.\n  This function won't call the specified function for enumerables that\n  are one-element long.\n\n  Returns the accumulator.\n\n  Note that since the first element of the enumerable is used as the\n  initial value of the accumulator, `fun` will only be executed `n - 1`\n  times where `n` is the length of the enumerable.\n\n  ## Examples\n\n      iex> Enum.reduce([1, 2, 3, 4], fn(x, acc) -> x * acc end)\n      24\n\n  "
    },
    reject = {
      description = "@spec reject(t, (element -> as_boolean(term))) :: list\n  \nreject(enumerable, fun) when is_function(fun, 1) \n\n  Returns elements of `enumerable` for which the function `fun` returns\n  `false` or `nil`.\n\n  See also `filter/2`.\n\n  ## Examples\n\n      iex> Enum.reject([1, 2, 3], fn(x) -> rem(x, 2) == 0 end)\n      [1, 3]\n\n  "
    },
    reverse = {
      description = "@spec reverse(t, t) :: list\n  \nreverse(enumerable, tail)\n\n  Reverses the elements in `enumerable`, appends the tail, and returns\n  it as a list.\n\n  This is an optimization for\n  `Enum.concat(Enum.reverse(enumerable), tail)`.\n\n  ## Examples\n\n      iex> Enum.reverse([1, 2, 3], [4, 5, 6])\n      [3, 2, 1, 4, 5, 6]\n\n  "
    },
    slice = {
      description = "\nslice(enumerable, start, amount)\n      when is_integer(start) and start >= 0 and is_integer(amount) and amount > 0 \n\nslice(enumerable, start, amount)\n      when is_list(enumerable) and\n           is_integer(start) and start >= 0 and is_integer(amount) and amount > 0 \n\nslice(first..last, start, amount)\n      when is_integer(start) and start >= 0 and is_integer(amount) and amount > 0 \n@spec slice(t, index, non_neg_integer) :: list\n  \nslice(enumerable, start, amount)\n      when is_integer(start) and start < 0 and is_integer(amount) and amount >= 0 \n  Returns a subset list of the given enumerable, from `start` position with `amount` of elements if available.\n\n  Given `enumerable`, it drops elements until element position `start`,\n  then takes `amount` of elements until the end of the enumerable.\n\n  If `start` is out of bounds, it returns `[]`.\n\n  If `amount` is greater than `enumerable` length, it returns as many elements as possible.\n  If `amount` is zero, then `[]` is returned.\n\n  ## Examples\n\n      iex> Enum.slice(1..100, 5, 10)\n      [6, 7, 8, 9, 10, 11, 12, 13, 14, 15]\n\n      # amount to take is greater than the number of elements\n      iex> Enum.slice(1..10, 5, 100)\n      [6, 7, 8, 9, 10]\n\n      iex> Enum.slice(1..10, 5, 0)\n      []\n\n      # out of bound start position\n      iex> Enum.slice(1..10, 10, 5)\n      []\n\n      # out of bound start position (negative)\n      iex> Enum.slice(1..10, -11, 5)\n      []\n\n  \n@spec slice(t, Range.t) :: list\n  \nslice(enumerable, first..last)\n\n  Returns a subset list of the given enumerable, from `range.first` to `range.last` positions.\n\n  Given `enumerable`, it drops elements until element position `range.first`,\n  then takes elements until element position `range.last` (inclusive).\n\n  Positions are normalized, meaning that negative positions will be counted from the end\n  (e.g. `-1` means the last element of the enumerable).\n  If `range.last` is out of bounds, then it is assigned as the position of the last element.\n\n  If the normalized `range.first` position is out of bounds of the given enumerable,\n  or this one is greater than the normalized `range.last` position, then `[]` is returned.\n\n  ## Examples\n\n      iex> Enum.slice(1..100, 5..10)\n      [6, 7, 8, 9, 10, 11]\n\n      iex> Enum.slice(1..10, 5..20)\n      [6, 7, 8, 9, 10]\n\n      # last five elements (negative positions)\n      iex> Enum.slice(1..30, -5..-1)\n      [26, 27, 28, 29, 30]\n\n      # last five elements (mixed positive and negative positions)\n      iex> Enum.slice(1..30, 25..-1)\n      [26, 27, 28, 29, 30]\n\n      # out of bounds\n      iex> Enum.slice(1..10, 11..20)\n      []\n\n      # range.first is greater than range.last\n      iex> Enum.slice(1..10, 6..5)\n      []\n\n  "
    },
    sort = {
      description = "@spec sort(t, (element, element -> boolean)) :: list\n  \nsort(enumerable, fun) when is_function(fun, 2) \n  Sorts the enumerable by the given function.\n\n  This function uses the merge sort algorithm. The given function should compare\n  two arguments, and return `true` if the first argument precedes the second one.\n\n  ## Examples\n\n      iex> Enum.sort([1, 2, 3], &(&1 >= &2))\n      [3, 2, 1]\n\n  The sorting algorithm will be stable as long as the given function\n  returns `true` for values considered equal:\n\n      iex> Enum.sort [\"some\", \"kind\", \"of\", \"monster\"], &(byte_size(&1) <= byte_size(&2))\n      [\"of\", \"some\", \"kind\", \"monster\"]\n\n  If the function does not return `true` for equal values, the sorting\n  is not stable and the order of equal terms may be shuffled.\n  For example:\n\n      iex> Enum.sort [\"some\", \"kind\", \"of\", \"monster\"], &(byte_size(&1) < byte_size(&2))\n      [\"of\", \"kind\", \"some\", \"monster\"]\n\n  \n@spec sort(t) :: list\n  \nsort(enumerable)\n\n  Sorts the enumerable according to Erlang's term ordering.\n\n  Uses the merge sort algorithm.\n\n  ## Examples\n\n      iex> Enum.sort([3, 2, 1])\n      [1, 2, 3]\n\n  "
    },
    split = {
      description = "\nsplit(enumerable, count) when count < 0 \n@spec split(t, integer) :: {list, list}\n  \nsplit(enumerable, count) when count >= 0 \n\n  Splits the `enumerable` into two enumerables, leaving `count`\n  elements in the first one.\n\n  If `count` is a negative number, it starts counting from the\n  back to the beginning of the enumerable.\n\n  Be aware that a negative `count` implies the `enumerable`\n  will be enumerated twice: once to calculate the position, and\n  a second time to do the actual splitting.\n\n  ## Examples\n\n      iex> Enum.split([1, 2, 3], 2)\n      {[1, 2], [3]}\n\n      iex> Enum.split([1, 2, 3], 10)\n      {[1, 2, 3], []}\n\n      iex> Enum.split([1, 2, 3], 0)\n      {[], [1, 2, 3]}\n\n      iex> Enum.split([1, 2, 3], -1)\n      {[1, 2], [3]}\n\n      iex> Enum.split([1, 2, 3], -5)\n      {[], [1, 2, 3]}\n\n  "
    },
    split_while = {
      description = "@spec split_while(t, (element -> as_boolean(term))) :: {list, list}\n  \nsplit_while(enumerable, fun) when is_function(fun, 1) \n\n  Splits enumerable in two at the position of the element for which\n  `fun` returns `false` for the first time.\n\n  ## Examples\n\n      iex> Enum.split_while([1, 2, 3, 4], fn(x) -> x < 3 end)\n      {[1, 2], [3, 4]}\n\n  "
    },
    sum = {
      description = "\nsum(enumerable)\n\nsum(first..last) when last > first \n\nsum(first..last) when last < first,\n    \n@spec sum(t) :: number\n  \nsum(first..first)\n\n  Returns the sum of all elements.\n\n  Raises `ArithmeticError` if `enumerable` contains a non-numeric value.\n\n  ## Examples\n\n      iex> Enum.sum([1, 2, 3])\n      6\n\n  "
    },
    t = {
      description = "t :: Enumerable.t\n\n  A partially applied reduce function.\n\n  The continuation is the closure returned as a result when\n  the enumeration is suspended. When invoked, it expects\n  a new accumulator and it returns the result.\n\n  A continuation is easily implemented as long as the reduce\n  function is defined in a tail recursive fashion. If the function\n  is tail recursive, all the state is passed as arguments, so\n  the continuation would simply be the reducing function partially\n  applied.\n  "
    },
    take = {
      description = "\ntake(enumerable, count) when is_integer(count) and count < 0 \n\ntake(enumerable, count) when is_integer(count) and count > 0 \n\ntake(enumerable, count)\n      when is_list(enumerable) and is_integer(count) and count > 0 \n\ntake([], _count)\n@spec take(t, integer) :: list\n  \ntake(_enumerable, 0)\n\n  Takes the first `count` items from the enumerable.\n\n  `count` must be an integer. If a negative `count` is given, the last\n  `count` values will be taken.\n  For such, the enumerable is fully enumerated keeping up\n  to `2 * count` elements in memory. Once the end of the enumerable is\n  reached, the last `count` elements are returned.\n\n  ## Examples\n\n      iex> Enum.take([1, 2, 3], 2)\n      [1, 2]\n\n      iex> Enum.take([1, 2, 3], 10)\n      [1, 2, 3]\n\n      iex> Enum.take([1, 2, 3], 0)\n      []\n\n      iex> Enum.take([1, 2, 3], -1)\n      [3]\n\n  "
    },
    take_every = {
      description = "\ntake_every(enumerable, nth) when is_integer(nth) and nth > 1 \n\ntake_every([], nth) when is_integer(nth) and nth > 1, \n\ntake_every(_enumerable, 0)\n@spec take_every(t, non_neg_integer) :: list\n  \ntake_every(enumerable, 1)\n\n  Returns a list of every `nth` item in the enumerable,\n  starting with the first element.\n\n  The first item is always included, unless `nth` is 0.\n\n  The second argument specifying every `nth` item must be a non-negative\n  integer.\n\n  ## Examples\n\n      iex> Enum.take_every(1..10, 2)\n      [1, 3, 5, 7, 9]\n\n      iex> Enum.take_every(1..10, 0)\n      []\n\n      iex> Enum.take_every([1, 2, 3], 1)\n      [1, 2, 3]\n\n  "
    },
    take_random = {
      description = "\ntake_random(enumerable, count) when is_integer(count) and count > 0 \n\ntake_random(enumerable, count) when is_integer(count) and count > 128 \n\ntake_random(first..first, count) when is_integer(count) and count >= 1,\n    \n@spec take_random(t, non_neg_integer) :: list\n  \ntake_random(_enumerable, 0)\n\n  Takes `count` random items from `enumerable`.\n\n  Notice this function will traverse the whole `enumerable` to\n  get the random sublist.\n\n  See `random/1` for notes on implementation and random seed.\n\n  ## Examples\n\n      # Although not necessary, let's seed the random algorithm\n      iex> :rand.seed(:exsplus, {1, 2, 3})\n      iex> Enum.take_random(1..10, 2)\n      [5, 4]\n      iex> Enum.take_random(?a..?z, 5)\n      'ipybz'\n\n  "
    },
    take_while = {
      description = "@spec take_while(t, (element -> as_boolean(term))) :: list\n  \ntake_while(enumerable, fun) when is_function(fun, 1) \n\n  Takes the items from the beginning of the enumerable while `fun` returns\n  a truthy value.\n\n  ## Examples\n\n      iex> Enum.take_while([1, 2, 3], fn(x) -> x < 3 end)\n      [1, 2]\n\n  "
    },
    to_list = {
      description = "@spec to_list(t) :: [element]\n  \nto_list(enumerable)\n\n  Converts `enumerable` to a list.\n\n  ## Examples\n\n      iex> Enum.to_list(1..3)\n      [1, 2, 3]\n\n  "
    },
    uniq = {
      description = "@spec uniq(t) :: list\n  \nuniq(enumerable, fun)\nfalse"
    },
    uniq_by = {
      description = "@spec uniq_by(t, (element -> term)) :: list\n\n  \nuniq_by(enumerable, fun) when is_function(fun, 1) \n\n  Enumerates the `enumerable`, by removing the elements for which\n  function `fun` returned duplicate items.\n\n  The function `fun` maps every element to a term which is used to\n  determine if two elements are duplicates.\n\n  The first occurrence of each element is kept.\n\n  ## Example\n\n      iex> Enum.uniq_by([{1, :x}, {2, :y}, {1, :z}], fn {x, _} -> x end)\n      [{1, :x}, {2, :y}]\n\n      iex> Enum.uniq_by([a: {:tea, 2}, b: {:tea, 2}, c: {:coffee, 1}], fn {_, y} -> y end)\n      [a: {:tea, 2}, c: {:coffee, 1}]\n\n  "
    },
    zip = {
      description = "@spec zip([t]) :: t\n\n  \nzip(enumerables)\n  Zips corresponding elements from a collection of enumerables\n  into one list of tuples.\n\n  The zipping finishes as soon as any enumerable completes.\n\n  ## Examples\n\n      iex> Enum.zip([[1, 2, 3], [:a, :b, :c], [\"foo\", \"bar\", \"baz\"]])\n      [{1, :a, \"foo\"}, {2, :b, \"bar\"}, {3, :c, \"baz\"}]\n\n      iex> Enum.zip([[1, 2, 3, 4, 5], [:a, :b, :c]])\n      [{1, :a}, {2, :b}, {3, :c}]\n\n  \n@spec zip(t, t) :: [{any, any}]\n  \nzip(enumerable1, enumerable2)\n\n  Zips corresponding elements from two enumerables into one list\n  of tuples.\n\n  The zipping finishes as soon as any enumerable completes.\n\n  ## Examples\n\n      iex> Enum.zip([1, 2, 3], [:a, :b, :c])\n      [{1, :a}, {2, :b}, {3, :c}]\n\n      iex> Enum.zip([1, 2, 3, 4, 5], [:a, :b, :c])\n      [{1, :a}, {2, :b}, {3, :c}]\n\n  "
    }
  },
  Enumerable = {
    acc = {
      description = "acc :: {:cont, term} | {:halt, term} | {:suspend, term}\n\n  The accumulator value for each step.\n\n  It must be a tagged tuple with one of the following \"tags\":\n\n    * `:cont`    - the enumeration should continue\n    * `:halt`    - the enumeration should halt immediately\n    * `:suspend` - the enumeration should be suspended immediately\n\n  Depending on the accumulator value, the result returned by\n  `Enumerable.reduce/3` will change. Please check the `t:result/0`\n  type documentation for more information.\n\n  In case a `t:reducer/0` function returns a `:suspend` accumulator,\n  it must be explicitly handled by the caller and never leak.\n  "
    },
    continuation = {
      description = "continuation :: (acc -> result)\n\n  A partially applied reduce function.\n\n  The continuation is the closure returned as a result when\n  the enumeration is suspended. When invoked, it expects\n  a new accumulator and it returns the result.\n\n  A continuation is easily implemented as long as the reduce\n  function is defined in a tail recursive fashion. If the function\n  is tail recursive, all the state is passed as arguments, so\n  the continuation would simply be the reducing function partially\n  applied.\n  "
    },
    description = "\n  Enumerable protocol used by `Enum` and `Stream` modules.\n\n  When you invoke a function in the `Enum` module, the first argument\n  is usually a collection that must implement this protocol.\n  For example, the expression:\n\n      Enum.map([1, 2, 3], &(&1 * 2))\n\n  invokes `Enumerable.reduce/3` to perform the reducing\n  operation that builds a mapped list by calling the mapping function\n  `&(&1 * 2)` on every element in the collection and consuming the\n  element with an accumulated list.\n\n  Internally, `Enum.map/2` is implemented as follows:\n\n      def map(enum, fun) do\n        reducer = fn x, acc -> {:cont, [fun.(x) | acc]} end\n        Enumerable.reduce(enum, {:cont, []}, reducer) |> elem(1) |> :lists.reverse()\n      end\n\n  Notice the user-supplied function is wrapped into a `t:reducer/0` function.\n  The `t:reducer/0` function must return a tagged tuple after each step,\n  as described in the `t:acc/0` type.\n\n  The reason the accumulator requires a tagged tuple is to allow the\n  `t:reducer/0` function to communicate the end of enumeration to the underlying\n  enumerable, allowing any open resources to be properly closed.\n  It also allows suspension of the enumeration, which is useful when\n  interleaving between many enumerables is required (as in zip).\n\n  Finally, `Enumerable.reduce/3` will return another tagged tuple,\n  as represented by the `t:result/0` type.\n  ",
    reducer = {
      description = "reducer :: (term, term -> acc)\n\n  The reducer function.\n\n  Should be called with the enumerable element and the\n  accumulator contents.\n\n  Returns the accumulator for the next enumeration step.\n  "
    },
    result = {
      description = "result :: {:done, term} |\n\n  The result of the reduce operation.\n\n  It may be *done* when the enumeration is finished by reaching\n  its end, or *halted*/*suspended* when the enumeration was halted\n  or suspended by the `t:reducer/0` function.\n\n  In case a `t:reducer/0` function returns the `:suspend` accumulator, the\n  `:suspended` tuple must be explicitly handled by the caller and\n  never leak. In practice, this means regular enumeration functions\n  just need to be concerned about `:done` and `:halted` results.\n\n  Furthermore, a `:suspend` call must always be followed by another call,\n  eventually halting or continuing until the end.\n  "
    }
  },
  ErlangError = {
    message = {
      description = "\nmessage(exception)\n"
    },
    normalize = {
      description = "\nnormalize(other, _stacktrace)\n\nnormalize({:badarg, payload}, _stacktrace)\n\nnormalize(:function_clause, stacktrace)\n\nnormalize(:undef, stacktrace)\n\nnormalize({:try_clause, term}, _stacktrace)\n\nnormalize({:with_clause, term}, _stacktrace)\n\nnormalize({:case_clause, term}, _stacktrace)\n\nnormalize({:badkey, key, map}, _stacktrace)\n\nnormalize({:badkey, key}, stacktrace)\n\nnormalize({:badbool, op, term}, _stacktrace)\n\nnormalize({:badmap, term}, _stacktrace)\n\nnormalize({:badmatch, term}, _stacktrace)\n\nnormalize({:badstruct, struct, term}, _stacktrace)\n\nnormalize({:badfun, term}, _stacktrace)\n\nnormalize({:badarity, {fun, args}}, _stacktrace)\n\nnormalize(:cond_clause, _stacktrace)\n\nnormalize(:system_limit, _stacktrace)\n\nnormalize(:badarith, _stacktrace)\n\nnormalize(:badarg, _stacktrace)\nfalse"
    }
  },
  Error = {
    __doctests__ = {
      description = "\n__doctests__(module, opts)\nfalse"
    },
    doctest = {
      description = "\ndoctest(mod, opts \\\\ [])\n\n  This macro is used to generate ExUnit test cases for doctests.\n\n  Calling `doctest(Module)` will generate tests for all doctests found\n  in the module `Module`\n\n  Options can also be given:\n\n    * `:except` - generates tests for all functions except those listed\n      (list of `{function, arity}` tuples, and/or `:moduledoc`).\n\n    * `:only` - generates tests only for functions listed\n      (list of `{function, arity}` tuples, and/or `:moduledoc`).\n\n    * `:import` - when `true`, one can test a function defined in the module\n      without referring to the module name. However, this is not feasible when\n      there is a clash with a module like Kernel. In these cases, `:import`\n      should be set to `false` and a full `M.f` construct should be used.\n\n  ## Examples\n\n      doctest MyModule, except: [:moduledoc, trick_fun: 1]\n\n  This macro is auto-imported with every `ExUnit.Case`.\n  "
    },
    exception = {
      description = "\nexception(opts)\n"
    }
  },
  ErrorHandler = {
    description = "false",
    ensure_compiled = {
      description = "@spec ensure_compiled(module, atom) :: boolean\n  # Never wait on nil because it should never be defined.\n  \nensure_compiled(module, kind)\n"
    }
  },
  ExUnit = {
    AssertionError = {
      description = "\n  Raised to signal an assertion error.\n  ",
      message = {
        description = "\nmessage(exception)\n"
      },
      no_value = {
        description = "\nno_value\n\n  Indicates no meaningful value for a field.\n  "
      }
    },
    Assertions = {
      ["__equal__?"] = {
        description = "\n__equal__?(left, right)\nfalse"
      },
      __mailbox__ = {
        description = "\n__mailbox__(messages)\nfalse"
      },
      __pins__ = {
        description = "\n__pins__(pins)\n\n__pins__([])\nfalse"
      },
      assert = {
        description = "\nassert(value, opts) when is_list(opts) \n\nassert(value, message) when is_binary(message) \n  Asserts `value` is `true`, displaying the given `message` otherwise.\n\n  ## Examples\n\n      assert false, \"it will never be true\"\n\n  \n\nassert(assertion)\n\nassert({:match?, meta, [left, right]} = assertion)\n\nassert({:=, _, [left, right]} = assertion)\n\n  Asserts its argument is a truthy value.\n\n  `assert` introspects the underlying expression and provides\n  good reporting whenever there is a failure. For example,\n  if the expression uses the comparison operator, the message\n  will show the values of the two sides. The assertion\n\n      assert 1+2+3+4 > 15\n\n   will fail with the message:\n\n      Assertion with > failed\n      code: 1+2+3+4 > 15\n      lhs:  10\n      rhs:  15\n\n  Similarly, if a match expression is given, it will report\n  any failure in terms of that match. Given\n\n      assert [one] = [two]\n\n  you'll see:\n\n      match (=) failed\n      code: [one] = [two]\n      rhs:  [2]\n\n  Keep in mind that `assert` does not change its semantics\n  based on the expression. In other words, the expression\n  is still required to return a truthy value. For example,\n  the following will fail:\n\n      assert nil = some_function_that_returns_nil()\n\n  Even though the match works, `assert` still expects a truth\n  value. In such cases, simply use `Kernel.==/2` or\n  `Kernel.match?/2`.\n  "
      },
      assert_in_delta = {
        description = "\nassert_in_delta(value1, value2, delta, message \\\\ nil)\n\n  Asserts that `value1` and `value2` differ by no more than `delta`.\n\n\n  ## Examples\n\n      assert_in_delta 1.1, 1.5, 0.2\n      assert_in_delta 10, 15, 4\n\n  "
      },
      assert_raise = {
        description = "\nassert_raise(exception, function) when is_function(function) \n  Asserts the `exception` is raised during `function` execution.\n  Returns the rescued exception, fails otherwise.\n\n  ## Examples\n\n      assert_raise ArithmeticError, fn ->\n        1 + \"test\"\n      end\n\n  \n\nassert_raise(exception, message, function) when is_function(function) \n\n  Asserts the `exception` is raised during `function` execution with\n  the expected `message`, which can be a `Regex` or an exact `String`.\n  Returns the rescued exception, fails otherwise.\n\n  ## Examples\n\n      assert_raise ArithmeticError, \"bad argument in arithmetic expression\", fn ->\n        1 + \"test\"\n      end\n\n      assert_raise RuntimeError, ~r/^today's lucky number is 0\\.\\d+!$/, fn ->\n        raise \"today's lucky number is #{:rand.uniform}!\"\n      end\n  "
      },
      assert_received = {
        description = "\nassert_received(pattern, failure_message \\\\ nil)\n\n  Asserts that a message matching `pattern` was received and is in the\n  current process' mailbox.\n\n  The `pattern` argument must be a match pattern. Flunks with `failure_message`\n  if a message matching `pattern` was not received.\n\n  Timeout is set to 0, so there is no waiting time.\n\n  ## Examples\n\n      send self(), :hello\n      assert_received :hello\n\n      send self(), :bye\n      assert_received :hello, \"Oh No!\"\n      ** (ExUnit.AssertionError) Oh No!\n      Process mailbox:\n        :bye\n\n  You can also match against specific patterns:\n\n      send self(), {:hello, \"world\"}\n      assert_received {:hello, _}\n\n  "
      },
      catch_error = {
        description = "\ncatch_error(expression)\n\n  Asserts `expression` will cause an error.\n  Returns the error or fails otherwise.\n\n  ## Examples\n\n      assert catch_error(error 1) == 1\n\n  "
      },
      catch_exit = {
        description = "\ncatch_exit(expression)\n\n  Asserts `expression` will exit.\n  Returns the exit status/message or fails otherwise.\n\n  ## Examples\n\n      assert catch_exit(exit 1) == 1\n\n  "
      },
      catch_throw = {
        description = "\ncatch_throw(expression)\n\n  Asserts `expression` will throw a value.\n  Returns the thrown value or fails otherwise.\n\n  ## Examples\n\n      assert catch_throw(throw 1) == 1\n\n  "
      },
      description = "\n  This module contains a set of assertion functions that are\n  imported by default into your test cases.\n\n  In general, a developer will want to use the general\n  `assert` macro in tests. This macro introspects your code\n  and provides good reporting whenever there is a failure.\n  For example, `assert some_fun() == 10` will fail (assuming\n  `some_fun()` returns `13`):\n\n      Comparison (using ==) failed in:\n      code: some_fun() == 10\n      lhs:  13\n      rhs:  10\n\n  This module also provides other convenience functions\n  like `assert_in_delta` and `assert_raise` to easily handle\n  other common cases such as checking a floating point number\n  or handling exceptions.\n  ",
      refute = {
        description = "\nrefute(value, message)\n  Asserts `value` is `nil` or `false` (that is, `value` is not truthy).\n\n  ## Examples\n\n      refute true, \"This will obviously fail\"\n\n  \n\nrefute(assertion)\n\nrefute({:match?, meta, [left, right]} = assertion)\n\n  A negative assertion, expects the expression to be `false` or `nil`.\n\n  Keep in mind that `refute` does not change the semantics of\n  the given expression. In other words, the following will fail:\n\n      refute {:ok, _} = some_function_that_returns_error_tuple()\n\n  The code above will fail because the `=` operator always fails\n  when the sides do not match and `refute/2` does not change it.\n\n  The correct way to write the refutation above is to use\n  `Kernel.match?/2`:\n\n      refute match? {:ok, _}, some_function_that_returns_error_tuple()\n\n  ## Examples\n\n      refute age < 0\n\n  "
      },
      refute_in_delta = {
        description = "\nrefute_in_delta(value1, value2, delta, message \\\\ nil)\n\n  Asserts `value1` and `value2` are not within `delta`.\n\n  If you supply `message`, information about the values will\n  automatically be appended to it.\n\n  ## Examples\n\n      refute_in_delta 1.1, 1.2, 0.2\n      refute_in_delta 10, 11, 2\n\n  "
      },
      refute_received = {
        description = "\nrefute_received(pattern, failure_message \\\\ nil)\n\n  Asserts a message matching `pattern` was not received (i.e. it is not in the\n  current process' mailbox).\n\n  The `pattern` argument must be a match pattern. Flunks with `failure_message`\n  if a message matching `pattern` was received.\n\n  Timeout is set to 0, so there is no waiting time.\n\n  ## Examples\n\n      send self(), :hello\n      refute_received :bye\n\n      send self(), :hello\n      refute_received :hello, \"Oh No!\"\n      ** (ExUnit.AssertionError) Oh No!\n      Process mailbox:\n        :bye\n\n  "
      }
    },
    CLIFormatter = {
      description = "false",
      handle_cast = {
        description = "\nhandle_cast({:case_finished, %ExUnit.TestCase{state: {:failed, failures}} = test_case}, config)\n\nhandle_cast({:case_finished, %ExUnit.TestCase{state: nil}}, config)\n\nhandle_cast({:case_started, %ExUnit.TestCase{name: name}}, config)\n\nhandle_cast({:test_finished, %ExUnit.Test{state: {:failed, failures}} = test}, config)\n\nhandle_cast({:test_finished, %ExUnit.Test{state: {:invalid, _}} = test}, config)\n\nhandle_cast({:test_finished, %ExUnit.Test{state: {:skip, _}} = test}, config)\n\nhandle_cast({:test_finished, %ExUnit.Test{state: nil} = test}, config)\n\nhandle_cast({:test_started, %ExUnit.Test{} = test}, config)\n\nhandle_cast({:suite_finished, run_us, load_us}, config)\n\nhandle_cast({:suite_started, _opts}, config)\n"
      },
      init = {
        description = "\ninit(opts)\n"
      }
    },
    Callbacks = {
      __before_compile__ = {
        description = "\n__before_compile__(env)\nfalse"
      },
      __callback__ = {
        description = "@spec on_exit(term, (() -> term)) :: :ok | no_return\n  \n__callback__(callback, describe)\nfalse"
      },
      __merge__ = {
        description = "\n__merge__(mod, _, return_value)\n\n__merge__(mod, context, data) when is_map(data) \n\n__merge__(mod, context, data) when is_list(data) \n\n__merge__(mod, _context, %{__struct__: _} = return_value)\n\n__merge__(mod, context, {:ok, value})\n\n__merge__(_mod, context, :ok)\nfalse"
      },
      __using__ = {
        description = "\n__using__(_)\nfalse"
      },
      description = "\n  Defines ExUnit callbacks.\n\n  This module defines both `setup_all` and `setup` callbacks, as well as\n  the `on_exit/2` function.\n\n  The setup callbacks are defined via macros and each one can optionally\n  receive a map with metadata, usually referred to as `context`. The\n  callback may optionally put extra data into the `context` to be used in\n  the tests.\n\n  The `setup_all` callbacks are invoked only once to setup the test case before any\n  test is run and all `setup` callbacks are run before each test. No callback\n  runs if the test case has no tests or all tests have been filtered out.\n\n  `on_exit/2` callbacks are registered on demand, usually to undo an action\n  performed by a setup callback. `on_exit/2` may also take a reference,\n  allowing callback to be overridden in the future. A registered `on_exit/2`\n  callback always runs, while failures in `setup` and `setup_all` will stop\n  all remaining setup callbacks from executing.\n\n  Finally, `setup_all` callbacks run in the test case process, while all\n  `setup` callbacks run in the same process as the test itself. `on_exit/2`\n  callbacks always run in a separate process than the test case or the\n  test itself. Since the test process exits with reason `:shutdown`, most\n  of times `on_exit/2` can be avoided as processes are going to clean\n  up on their own.\n\n  ## Context\n\n  If you return a keyword list, a map, or `{:ok, keywords | map}` from\n  `setup_all`, the keyword list/map will be merged into the current context and\n  be available in all subsequent `setup_all`, `setup`, and the test itself.\n\n  Similarly, returning a keyword list, map, or `{:ok, keywords | map}` from\n  `setup` means that the returned keyword list/map will be merged into the\n  current context and be available in all subsequent `setup` and the `test`\n  itself.\n\n  Returning `:ok` leaves the context unchanged (both in `setup` and `setup_all`\n  callbacks).\n\n  Returning anything else from `setup_all` will force all tests to fail,\n  while a bad response from `setup` causes the current test to fail.\n\n  ## Examples\n\n      defmodule AssertionTest do\n        use ExUnit.Case, async: true\n\n        # \"setup_all\" is called once to setup the case before any test is run\n        setup_all do\n          IO.puts \"Starting AssertionTest\"\n\n          # No context is returned here\n          :ok\n        end\n\n        # \"setup\" is called before each test is run\n        setup do\n          IO.puts \"This is a setup callback\"\n\n          on_exit fn ->\n            IO.puts \"This is invoked once the test is done\"\n          end\n\n          # Returns extra metadata to be merged into context\n          [hello: \"world\"]\n        end\n\n        # Same as \"setup\", but receives the context\n        # for the current test\n        setup context do\n          IO.puts \"Setting up: #{context[:test]}\"\n          :ok\n        end\n\n        # Setups can also invoke a local or imported function that can return a context\n        setup :invoke_local_or_imported_function\n\n        test \"always pass\" do\n          assert true\n        end\n\n        test \"another one\", context do\n          assert context[:hello] == \"world\"\n        end\n\n        defp invoke_local_or_imported_function(context) do\n          [from_named_setup: true]\n        end\n      end\n\n  ",
      setup = {
        description = "\nsetup(var, block)\n  Defines a callback to be run before each test in a case.\n\n  ## Examples\n\n      setup context do\n        [conn: Plug.Conn.build_conn()]\n      end\n\n  \n\nsetup(block)\n\n  Defines a callback to be run before each test in a case.\n\n  ## Examples\n\n      setup :clean_up_tmp_directory\n\n  "
      },
      setup_all = {
        description = "\nsetup_all(var, block)\n  Defines a callback to be run before all tests in a case.\n\n  ## Examples\n\n      setup_all context do\n        [conn: Plug.Conn.build_conn()]\n      end\n\n  \n\nsetup_all(block)\n\n  Defines a callback to be run before all tests in a case.\n\n  ## Examples\n\n      setup_all :clean_up_tmp_directory\n\n  "
      }
    },
    CaptureIO = {
      capture_io = {
        description = "\ncapture_io(device, options, fun) when is_list(options) \n\ncapture_io(device, input, fun) when is_binary(input) \n\ncapture_io(options, fun) when is_list(options) \n\ncapture_io(input, fun) when is_binary(input) \n\ncapture_io(device, fun) when is_atom(device) \n\ncapture_io(fun)\n\n  Captures IO generated when evaluating `fun`.\n\n  Returns the binary which is the captured output.\n\n  By default, `capture_io` replaces the `group_leader` (`:stdio`)\n  for the current process. However, the capturing of any other\n  named device, such as `:stderr`, is also possible globally by\n  giving the registered device name explicitly as an argument.\n\n  Note that when capturing something other than `:stdio`,\n  the test should run with async false.\n\n  When capturing `:stdio`, if the `:capture_prompt` option is `false`,\n  prompts (specified as arguments to `IO.get*` functions) are not\n  captured.\n\n  A developer can set a string as an input. The default input is `:eof`.\n\n  ## Examples\n\n      iex> capture_io(fn -> IO.write \"john\" end) == \"john\"\n      true\n\n      iex> capture_io(:stderr, fn -> IO.write(:stderr, \"john\") end) == \"john\"\n      true\n\n      iex> capture_io(\"this is input\", fn ->\n      ...>   input = IO.gets \">\"\n      ...>   IO.write input\n      ...> end) == \">this is input\"\n      true\n\n      iex> capture_io([input: \"this is input\", capture_prompt: false], fn ->\n      ...>   input = IO.gets \">\"\n      ...>   IO.write input\n      ...> end) == \"this is input\"\n      true\n\n  ## Returning values\n\n  As seen in the examples above, `capture_io` returns the captured output.\n  If you want to also capture the result of the function executed inside\n  the `capture_io`, you can use `Kernel.send/2` to send yourself a message\n  and use `ExUnit.Assertions.assert_received/2` to match on the results:\n\n      capture_io([input: \"this is input\", capture_prompt: false], fn ->\n        send self(), {:block_result, 42}\n        # ...\n      end)\n\n      assert_received {:block_result, 42}\n\n  "
      },
      description = "\n  Functionality to capture IO for testing.\n\n  ## Examples\n\n      defmodule AssertionTest do\n        use ExUnit.Case\n\n        import ExUnit.CaptureIO\n\n        test \"example\" do\n          assert capture_io(fn ->\n            IO.puts \"a\"\n          end) == \"a\\n\"\n        end\n\n        test \"checking the return value and the IO output\" do\n          fun = fn ->\n            assert Enum.each([\"some\", \"example\"], &(IO.puts &1)) == :ok\n          end\n          assert capture_io(fun) == \"some\\nexample\\n\"\n          # tip: or use only: \"capture_io(fun)\" to silence the IO output (so only assert the return value)\n        end\n      end\n\n  "
    },
    CaptureLog = {
      description = "\n  Functionality to capture logs for testing.\n\n  ## Examples\n\n      defmodule AssertionTest do\n        use ExUnit.Case\n\n        import ExUnit.CaptureLog\n\n        test \"example\" do\n          assert capture_log(fn ->\n            Logger.error \"log msg\"\n          end) =~ \"log msg\"\n        end\n\n        test \"check multiple captures concurrently\" do\n          fun = fn ->\n            for msg <- [\"hello\", \"hi\"] do\n              assert capture_log(fn -> Logger.error msg end) =~ msg\n            end\n            Logger.debug \"testing\"\n          end\n          assert capture_log(fun) =~ \"hello\"\n          assert capture_log(fun) =~ \"testing\"\n        end\n      end\n\n  ",
      init_proxy = {
        description = "@spec capture_log(Keyword.t, (() -> any)) :: String.t\n  \ninit_proxy(pid, opts, parent)\nfalse"
      }
    },
    CaptureServer = {
      description = "false",
      device_capture_off = {
        description = "\ndevice_capture_off(ref)\n"
      },
      device_capture_on = {
        description = "\ndevice_capture_on(device, pid)\n"
      },
      handle_call = {
        description = "\nhandle_call({:log_capture_off, ref}, _from, config)\n\nhandle_call({:log_capture_on, pid}, _from, config)\n\nhandle_call({:device_capture_off, ref}, _from, config)\n\nhandle_call({:device_capture_on, name, pid}, _from, config)\n"
      },
      handle_info = {
        description = "\nhandle_info(msg, state)\n\nhandle_info({:DOWN, ref, _, _, _}, config)\n"
      },
      init = {
        description = "\ninit(:ok)\n"
      },
      log_capture_off = {
        description = "\nlog_capture_off(ref)\n"
      },
      log_capture_on = {
        description = "\nlog_capture_on(pid)\n"
      }
    },
    Case = {
      __after_compile__ = {
        description = "\n__after_compile__(%{module: module}, _)\nfalse"
      },
      __before_compile__ = {
        description = "\n__before_compile__(_)\nfalse"
      },
      __ex_unit__ = {
        description = "\n__ex_unit__(:case)\n"
      },
      __using__ = {
        description = "\n__using__(opts)\nfalse"
      },
      describe = {
        description = "\ndescribe(message, do: block)\n\n  Describes tests together.\n\n  Every describe block receives a name which is used as prefix for\n  upcoming tests. Inside a block, `ExUnit.Callbacks.setup/1` may be\n  invoked and it will define a setup callback to run only for the\n  current block. The describe name is also added as a tag, allowing\n  developers to run tests for specific blocks.\n\n  ## Examples\n\n      defmodule StringTest do\n        use ExUnit.Case, async: true\n\n        describe \"String.capitalize/1\" do\n          test \"first grapheme is in uppercase\" do\n            assert String.capitalize(\"hello\") == \"Hello\"\n          end\n\n          test \"converts remaining graphemes to lowercase\" do\n            assert String.capitalize(\"HELLO\") == \"Hello\"\n          end\n        end\n      end\n\n  When using Mix, you can run all tests in a describe block as:\n\n      mix test --only describe:\"String.capitalize/1\"\n\n  Note describe blocks cannot be nested. Instead of relying on hierarchy\n  for composition, developers should build on top of named setups. For\n  example:\n\n      defmodule UserManagementTest do\n        use ExUnit.Case, async: true\n\n        describe \"when user is logged in and is an admin\" do\n          setup [:log_user_in, :set_type_to_admin]\n\n          test ...\n        end\n\n        describe \"when user is logged in and is a manager\" do\n          setup [:log_user_in, :set_type_to_manager]\n\n          test ...\n        end\n\n        defp log_user_in(context) do\n          # ...\n        end\n      end\n\n  By forbidding hierarchies in favor of named setups, it is straight-forward\n  for the developer to glance at each describe block and know exactly the\n  setup steps involved.\n  "
      },
      description = "\n  Sets up an ExUnit test case.\n\n  This module must be used in other modules as a way to configure\n  and prepare them for testing.\n\n  When used, it accepts the following options:\n\n    * `:async` - configure this specific test case to run in parallel\n      with other test cases. May be used for performance when this test case\n      does not change any global state. Defaults to `false`.\n\n  This module automatically includes all callbacks defined in\n  `ExUnit.Callbacks`. See that module's documentation for more\n  information.\n\n  ## Examples\n\n       defmodule AssertionTest do\n         # Use the module\n         use ExUnit.Case, async: true\n\n         # The \"test\" macro is imported by ExUnit.Case\n         test \"always pass\" do\n           assert true\n         end\n       end\n\n  ## Context\n\n  All tests receive a context as an argument. The context is particularly\n  useful for sharing information between callbacks and tests:\n\n      defmodule KVTest do\n        use ExUnit.Case\n\n        setup do\n          {:ok, pid} = KV.start_link\n          {:ok, [pid: pid]}\n        end\n\n        test \"stores key-value pairs\", context do\n          assert KV.put(context[:pid], :hello, :world) == :ok\n          assert KV.get(context[:pid], :hello) == :world\n        end\n      end\n\n  As the context is a map, it can be pattern matched on to extract\n  information:\n\n      test \"stores key-value pairs\", %{pid: pid} do\n        assert KV.put(pid, :hello, :world) == :ok\n        assert KV.get(pid, :hello) == :world\n      end\n\n  ## Tags\n\n  The context is used to pass information from the callbacks to\n  the test. In order to pass information from the test to the\n  callback, ExUnit provides tags.\n\n  By tagging a test, the tag value can be accessed in the context,\n  allowing the developer to customize the test. Let's see an\n  example:\n\n      defmodule FileTest do\n        # Changing directory cannot be async\n        use ExUnit.Case, async: false\n\n        setup context do\n          # Read the :cd tag value\n          if cd = context[:cd] do\n            prev_cd = File.cwd!\n            File.cd!(cd)\n            on_exit fn -> File.cd!(prev_cd) end\n          end\n\n          :ok\n        end\n\n        @tag cd: \"fixtures\"\n        test \"reads UTF-8 fixtures\" do\n          File.read(\"hello\")\n        end\n      end\n\n  In the example above, we have defined a tag called `:cd` that is\n  read in the setup callback to configure the working directory the\n  test is going to run on.\n\n  Tags are also very effective when used with case templates\n  (`ExUnit.CaseTemplate`) allowing callbacks in the case template\n  to customize the test behaviour.\n\n  Note a tag can be set in two different ways:\n\n      @tag key: value\n      @tag :key       # equivalent to setting @tag key: true\n\n  If a tag is given more than once, the last value wins.\n\n  ### Module tags\n\n  A tag can be set for all tests in a module by setting `@moduletag`:\n\n      @moduletag :external\n\n  If the same key is set via `@tag`, the `@tag` value has higher\n  precedence.\n\n  ### Known tags\n\n  The following tags are set automatically by ExUnit and are\n  therefore reserved:\n\n    * `:case`       - the test case module\n    * `:file`       - the file on which the test was defined\n    * `:line`       - the line on which the test was defined\n    * `:test`       - the test name\n    * `:async`      - if the test case is in async mode\n    * `:type`       - the type of the test (`:test`, `:property`, etc)\n    * `:registered` - used for `ExUnit.Case.register_attribute/3` values\n    * `:describe`   - the describe block the test belongs to\n\n  The following tags customize how tests behaves:\n\n    * `:capture_log` - see the \"Log Capture\" section below\n    * `:skip` - skips the test with the given reason\n    * `:timeout` - customizes the test timeout in milliseconds (defaults to 60000)\n    * `:report` - includes the given tags and context keys on error reports,\n      see the \"Reporting tags\" section\n\n  ### Reporting tags\n\n  ExUnit also allows tags or any other key in your context to be included\n  in error reports, making it easy for developers to see under which circumstances\n  a test was evaluated. To do so, you use the `:report` tag:\n\n      @moduletag report: [:user_id]\n\n  ## Filters\n\n  Tags can also be used to identify specific tests, which can then\n  be included or excluded using filters. The most common functionality\n  is to exclude some particular tests from running, which can be done\n  via `ExUnit.configure/1`:\n\n      # Exclude all external tests from running\n      ExUnit.configure(exclude: [external: true])\n\n  From now on, ExUnit will not run any test that has the `external` flag\n  set to `true`. This behaviour can be reversed with the `:include` option\n  which is usually passed through the command line:\n\n      mix test --include external:true\n\n  Run `mix help test` for more information on how to run filters via Mix.\n\n  Another use case for tags and filters is to exclude all tests that have\n  a particular tag by default, regardless of its value, and include only\n  a certain subset:\n\n      ExUnit.configure(exclude: :os, include: [os: :unix])\n\n  Keep in mind that all tests are included by default, so unless they are\n  excluded first, the `include` option has no effect.\n\n  ## Log Capture\n\n  ExUnit can optionally suppress printing of log messages that are generated during a test. Log\n  messages generated while running a test are captured and only if the test fails are they printed\n  to aid with debugging.\n\n  You can opt into this behaviour for individual tests by tagging them with `:capture_log` or enable\n  log capture for all tests in the ExUnit configuration:\n\n      ExUnit.start(capture_log: true)\n\n  This default can be overridden by `@tag capture_log: false` or `@moduletag capture_log: false`.\n\n  Since `setup_all` blocks don't belong to a specific test, log messages generated in them (or\n  between tests) are never captured. If you want to suppress these messages as well, remove the\n  console backend globally:\n\n      config :logger, backends: []\n  ",
      register_attribute = {
        description = "\nregister_attribute(mod, name, opts) when is_atom(mod) and is_atom(name) and is_list(opts) \n\nregister_attribute(%{module: module}, name, opts)\n\nregister_attribute(env, name, opts \\\\ [])\n\n  Registers a new attribute to be used during `ExUnit.Case` tests.\n\n  The attribute values will be available as a key/value pair in\n  `context.registered`. The key/value pairs will be cleared\n  after each `ExUnit.Case.test/3` similar to `@tag`.\n\n  `Module.register_attribute/3` is used to register the attribute,\n  this function takes the same options.\n\n  ## Examples\n\n      defmodule MyTest do\n        use ExUnit.Case\n        ExUnit.Case.register_attribute __ENV__, :foobar\n\n        @foobar hello: \"world\"\n        test \"using custom test attribute\", context do\n          assert context.registered.hello == \"world\"\n        end\n      end\n  "
      },
      register_test = {
        description = "\nregister_test(%{module: mod, file: file, line: line}, type, name, tags)\n\n  Registers a function to run as part of this case.\n\n  This is used by 3rd party projects, like QuickCheck, to\n  implement macros like `property/3` that works like `test`\n  but instead defines a property. See `test/3` implementation\n  for an example of invoking this function.\n\n  The test type will be converted to a string and pluralized for\n  display. You can use `ExUnit.plural_rule/2` to set a custom\n  pluralization.\n  "
      },
      test = {
        description = "\ntest(message)\n\n  Defines a not implemented test with a string.\n\n  Provides a convenient macro that allows a test to be defined\n  with a string, but not yet implemented. The resulting test will\n  always fail and print \"Not implemented\" error message. The\n  resulting test case is also tagged with `:not_implemented`.\n\n  ## Examples\n\n      test \"this will be a test in future\"\n\n  "
      }
    },
    CaseTemplate = {
      __proxy__ = {
        description = "\n__proxy__(module, opts)\nfalse"
      },
      __using__ = {
        description = "\n__using__(opts)\n\n__using__(_)\nfalse"
      },
      description = "\n  This module allows a developer to define a test case\n  template to be used throughout their tests. This is useful\n  when there are a set of functions that should be shared\n  between tests or a set of setup callbacks.\n\n  By using this module, the callbacks and assertions\n  available for regular test cases will also be available.\n\n  ## Example\n\n      defmodule MyCase do\n        use ExUnit.CaseTemplate\n\n        setup do\n          IO.puts \"This will run before each test that uses this case\"\n        end\n      end\n\n      defmodule MyTest do\n        use MyCase, async: true\n\n        test \"truth\" do\n          assert true\n        end\n      end\n\n  ",
      using = {
        description = "\nusing(var \\\\ quote(do: _)\n\n  Allows a developer to customize the using block\n  when the case template is used.\n\n  ## Example\n\n      using do\n        quote do\n          alias MyApp.FunModule\n        end\n      end\n\n  "
      }
    },
    Diff = {
      description = "false",
      script = {
        description = "\nscript(_left, _right)\n\nscript(left, right)\n      when is_tuple(left) and is_tuple(right) \n\nscript(left, right)\n      when is_integer(left) and is_integer(right)\n      when is_float(left) and is_float(right) \n\nscript(left, right) when is_list(left) and is_list(right) \n\nscript(%{} = left, %{} = right)\n\nscript(%name{} = left, %name{} = right)\n\nscript(left, right) when is_binary(left) and is_binary(right) \n\nscript(term, term)\n      when is_binary(term) or is_number(term)\n      when is_map(term) or is_list(term) or is_tuple(term) \n\nscript(left, right)\n\n  Returns an edit script representing the difference between `left` and `right`.\n\n  Returns `nil` if they are not the same data type,\n  or if the given data type is not supported.\n  "
      }
    },
    DocTest = {
      description = "\n  ExUnit.DocTest implements functionality similar to [Python's\n  doctest](https://docs.python.org/2/library/doctest.html).\n\n  It allows us to generate tests from the code\n  examples in a module/function/macro's documentation.\n  To do this, invoke the `doctest/1` macro from within\n  your test case and ensure your code examples are written\n  according to the syntax and guidelines below.\n\n  ## Syntax\n\n  Every new test starts on a new line, with an `iex>` prefix.\n  Multiline expressions can be used by prefixing subsequent lines with either\n  `...>` (recommended) or `iex>`.\n\n  The expected result should start at the next line after the `iex>`\n  or `...>` line(s) and is terminated either by a newline, new\n  `iex>` prefix or the end of the string literal.\n\n  ## Examples\n\n  To run doctests include them in an ExUnit case with a `doctest` macro:\n\n      defmodule MyModule.Test do\n        use ExUnit.Case, async: true\n        doctest MyModule\n      end\n\n  The `doctest` macro loops through all functions and\n  macros defined in `MyModule`, parsing their documentation in\n  search of code examples.\n\n  A very basic example is:\n\n      iex> 1+1\n      2\n\n  Expressions on multiple lines are also supported:\n\n      iex> Enum.map [1, 2, 3], fn(x) ->\n      ...>   x * 2\n      ...> end\n      [2, 4, 6]\n\n  Multiple results can be checked within the same test:\n\n      iex> a = 1\n      1\n      iex> a + 1\n      2\n\n  If you want to keep any two tests separate,\n  add an empty line between them:\n\n      iex> a = 1\n      1\n\n      iex> a + 1  # will fail with a \"undefined function a/0\" error\n      2\n\n  If you don't want to assert for every result in a doctest, you can omit\n  the result:\n\n      iex> pid = spawn fn -> :ok end\n      iex> is_pid(pid)\n      true\n\n  This is useful when the result is something variable (like a PID in the\n  example above) or when the result is a complicated data structure and you\n  don't want to show it all, but just parts of it or some of its properties.\n\n  Similarly to IEx you can use numbers in your \"prompts\":\n\n      iex(1)> [1 + 2,\n      ...(1)>  3]\n      [3, 3]\n\n  This is useful in two cases:\n\n    * being able to refer to specific numbered scenarios\n    * copy-pasting examples from an actual IEx session\n\n  You can also select or skip functions when calling\n  `doctest`. See the documentation on the `:except` and `:only` options below\n  for more info.\n\n  ## Opaque types\n\n  Some types' internal structures are kept hidden and instead show a\n  user-friendly structure when inspected. The idiom in\n  Elixir is to print those data types in the format `#Name<...>`. Because those\n  values are treated as comments in Elixir code due to the leading\n  `#` sign, they require special care when being used in doctests.\n\n  Imagine you have a map that contains a MapSet and is printed as:\n\n      %{users: #MapSet<[:foo, :bar]>}\n\n  If you try to match on such an expression, `doctest` will fail to compile.\n  There are two ways to resolve this.\n\n  The first is to rely on the fact that doctest can compare internal\n  structures as long as they are at the root. So one could write:\n\n      iex> map = %{users: Enum.into([:foo, :bar], MapSet.new)}\n      iex> map.users\n      #MapSet<[:foo, :bar]>\n\n  Whenever a doctest starts with \"#Name<\", `doctest` will perform a string\n  comparison. For example, the above test will perform the following match:\n\n      inspect(map.users) == \"#MapSet<[:foo, :bar]>\"\n\n  Alternatively, since doctest results are actually evaluated, you can have\n  the MapSet building expression as the doctest result:\n\n      iex> %{users: Enum.into([:foo, :bar], MapSet.new)}\n      %{users: Enum.into([:foo, :bar], MapSet.new)}\n\n  The downside of this approach is that the doctest result is not really\n  what users would see in the terminal.\n\n  ## Exceptions\n\n  You can also showcase expressions raising an exception, for example:\n\n      iex(1)> String.to_atom((fn() -> 1 end).())\n      ** (ArgumentError) argument error\n\n  What DocTest will be looking for is a line starting with `** (` and it\n  will parse it accordingly to extract the exception name and message.\n  At this moment, the exception parser would make the parser treat the next\n  line as a start of a completely new expression (if it is prefixed with `iex>`)\n  or a no-op line with documentation. Thus, multiline messages are not\n  supported.\n\n  ## When not to use doctest\n\n  In general, doctests are not recommended when your code examples contain\n  side effects. For example, if a doctest prints to standard output, doctest\n  will not try to capture the output.\n\n  Similarly, doctests do not run in any kind of sandbox. So any module\n  defined in a code example is going to linger throughout the whole test\n  suite run.\n  "
    },
    DuplicateTestError = {},
    EventManager = {
      add_handler = {
        description = "\nadd_handler({sup, event}, handler, opts)\n"
      },
      case_finished = {
        description = "\ncase_finished(ref, test_case)\n"
      },
      case_started = {
        description = "\ncase_started(ref, test_case)\n"
      },
      description = "false",
      stop = {
        description = "\nstop({sup, event})\n\n  Starts an event manager that publishes events during the suite run.\n\n  This is what power formatters as well as the\n  internal statistics server for ExUnit.\n  "
      },
      suite_finished = {
        description = "\nsuite_finished(ref, run_us, load_us)\n"
      },
      suite_started = {
        description = "\nsuite_started(ref, opts)\n"
      },
      test_finished = {
        description = "\ntest_finished(ref, test)\n"
      },
      test_started = {
        description = "\ntest_started(ref, test)\n"
      }
    },
    Filters = {
      description = "\n  Conveniences for parsing and evaluating filters.\n  ",
      t = {
        description = "t :: list({atom, Regex.t | String.Chars.t} | atom)\n"
      }
    },
    Formatter = {
      description = "\n  Helper functions for formatting and the formatting protocols.\n\n  Formatters are `GenServer`s specified during ExUnit configuration\n  that receives a series of events as cast messages.\n\n  The following events are possible:\n\n    * `{:suite_started, opts}` -\n      the suite has started with the specified options to the runner.\n\n    * `{:suite_finished, run_us, load_us}` -\n      the suite has finished. `run_us` and `load_us` are the run and load\n      times in microseconds respectively.\n\n    * `{:case_started, test_case}` -\n      a test case has started. See `ExUnit.TestCase` for details.\n\n    * `{:case_finished, test_case}` -\n      a test case has finished. See `ExUnit.TestCase` for details.\n\n    * `{:test_started, test}` -\n      a test has started. See `ExUnit.Test` for details.\n\n    * `{:test_finished, test}` -\n      a test has finished. See `ExUnit.Test` for details.\n\n  ",
      format_assertion_error = {
        description = "\nformat_assertion_error(%ExUnit.AssertionError{} = struct, width, formatter, counter_padding)\nfalse"
      },
      format_test_case_failure = {
        description = "\nformat_test_case_failure(test_case, failures, counter, width, formatter)\n\n  Receives a test case and formats its failure.\n  "
      },
      format_test_failure = {
        description = "@spec format_filters(Keyword.t, atom) :: String.t\n  \nformat_test_failure(test, failures, counter, width, formatter)\n\n  Receives a test and formats its failure.\n  "
      },
      format_time = {
        description = "@spec format_time(run_us, load_us) :: String.t\n  \nformat_time(run_us, load_us)\n\n  Formats time taken running the test suite.\n\n  It receives the time spent running the tests and\n  optionally the time spent loading the test suite.\n\n  ## Examples\n\n      iex> format_time(10000, nil)\n      \"Finished in 0.01 seconds\"\n\n      iex> format_time(10000, 20000)\n      \"Finished in 0.03 seconds (0.02s on load, 0.01s on tests)\"\n\n      iex> format_time(10000, 200000)\n      \"Finished in 0.2 seconds (0.2s on load, 0.01s on tests)\"\n\n  "
      },
      id = {
        description = "id :: term\n"
      },
      load_us = {
        description = "load_us :: pos_integer | nil\n"
      },
      run_us = {
        description = "run_us :: pos_integer\n"
      },
      test = {
        description = "test :: ExUnit.Test.t\n"
      },
      test_case = {
        description = "test_case :: ExUnit.TestCase.t\n"
      }
    },
    MultiError = {
      description = "\n  Raised to signal multiple errors happened in a test case.\n  ",
      message = {
        description = "\nmessage(exception)\n"
      }
    },
    OnExitHandler = {
      description = "false",
      on_exit_runner_loop = {
        description = "@spec run(pid, timeout) :: :ok | {Exception.kind, term, Exception.stacktrace}\n  \non_exit_runner_loop\nfalse"
      },
      start_link = {
        description = "\nstart_link\n"
      }
    },
    Runner = {
      configure = {
        description = "\nconfigure(opts)\n"
      },
      description = "false",
      run = {
        description = "\nrun(opts, load_us)\n"
      }
    },
    RunnerStats = {
      description = "false",
      handle_call = {
        description = "\nhandle_call(:stats, _from, map)\n"
      },
      handle_cast = {
        description = "\nhandle_cast(_, map)\n\nhandle_cast({:test_finished, _}, %{total: total} = map)\n\nhandle_cast({:test_finished, %ExUnit.Test{state: {:skip, _}}},\n                   %{total: total, skipped: skipped} = map)\n\nhandle_cast({:test_finished, %ExUnit.Test{state: {tag, _}}},\n                   %{total: total, failures: failures} = map) when tag in [:failed, :invalid] \n"
      },
      init = {
        description = "\ninit(_opts)\n"
      },
      stats = {
        description = "\nstats(pid)\n"
      }
    },
    Server = {
      add_async_case = {
        description = "\nadd_async_case(name)\n"
      },
      add_sync_case = {
        description = "\nadd_sync_case(name)\n"
      },
      cases_loaded = {
        description = "\ncases_loaded\n"
      },
      description = "false",
      handle_call = {
        description = "\nhandle_call(:cases_loaded, _from, %{loaded: loaded} = state) when is_integer(loaded) \n\nhandle_call(:take_sync_cases, _from, %{waiting: nil, loaded: :done, async_cases: []} = state)\n\nhandle_call({:take_async_cases, count}, from, %{waiting: nil} = state)\n"
      },
      handle_cast = {
        description = "\nhandle_cast({:add_sync_case, name}, %{sync_cases: cases, loaded: loaded} = state)\n      when is_integer(loaded) \n\nhandle_cast({:add_async_case, name}, %{async_cases: cases, loaded: loaded} = state)\n      when is_integer(loaded) \n"
      },
      init = {
        description = "\ninit(:ok)\n"
      },
      take_async_cases = {
        description = "\ntake_async_cases(count)\n"
      }
    },
    description = "\n  Unit testing framework for Elixir.\n\n  ## Example\n\n  A basic setup for ExUnit is shown below:\n\n      # File: assertion_test.exs\n\n      # 1) Start ExUnit.\n      ExUnit.start\n\n      # 2) Create a new test module (test case) and use \"ExUnit.Case\".\n      defmodule AssertionTest do\n        # 3) Notice we pass \"async: true\", this runs the test case\n        #    concurrently with other test cases. The individual tests\n        #    within each test case are still run serially.\n        use ExUnit.Case, async: true\n\n        # 4) Use the \"test\" macro instead of \"def\" for clarity.\n        test \"the truth\" do\n          assert true\n        end\n      end\n\n  To run the tests above, run the file using `elixir` from the\n  command line. Assuming you named the file `assertion_test.exs`,\n  you can run it as:\n\n      elixir assertion_test.exs\n\n  ## Case, Callbacks and Assertions\n\n  See `ExUnit.Case` and `ExUnit.Callbacks` for more information\n  about defining test cases and setting up callbacks.\n\n  The `ExUnit.Assertions` module contains a set of macros to\n  generate assertions with appropriate error messages.\n\n  ## Integration with Mix\n\n  Mix is the project management and build tool for Elixir. Invoking `mix test`\n  from the command line will run the tests in each file matching the pattern\n  `*_test.exs` found in the `test` directory of your project.\n\n  You must create a `test_helper.exs` file inside the\n  `test` directory and put the code common to all tests there.\n\n  The minimum example of a `test_helper.exs` file would be:\n\n      # test/test_helper.exs\n      ExUnit.start\n\n  Mix will load the `test_helper.exs` file before executing the tests.\n  It is not necessary to `require` the `test_helper.exs` file in your test\n  files. See `Mix.Tasks.Test` for more information.\n  ",
    failed = {
      description = "failed :: [{Exception.kind, reason :: term, stacktrace :: [tuple]}]\n"
    },
    state = {
      description = "state :: nil | {:failed, failed} | {:skip, binary} | {:invalid, module}\n"
    }
  },
  Exception = {
    description = "\n  Functions to format throw/catch/exit and exceptions.\n\n  Note that stacktraces in Elixir are updated on throw,\n  errors and exits. For example, at any given moment,\n  `System.stacktrace/0` will return the stacktrace for the\n  last throw/error/exit that occurred in the current process.\n\n  Do not rely on the particular format returned by the `format*`\n  functions in this module. They may be changed in future releases\n  in order to better suit Elixir's tool chain. In other words,\n  by using the functions in this module it is guaranteed you will\n  format exceptions as in the current Elixir version being used.\n  ",
    ["exception?"] = {
      description = "\nexception?(_)\n\nexception?(%{__struct__: struct, __exception__: true}) when is_atom(struct),\n    \n\nexception?(term)\n\n  Returns `true` if the given `term` is an exception.\n  "
    },
    format = {
      description = "\nformat(kind, payload, stacktrace)\n@spec format(kind, any, stacktrace | nil) :: String.t\n\n  \nformat({:EXIT, _} = kind, any, _)\n\n  Normalizes and formats throw/errors/exits and stacktraces.\n\n  It relies on `format_banner/3` and `format_stacktrace/1`\n  to generate the final format.\n\n  Note that `{:EXIT, pid}` do not generate a stacktrace though\n  (as they are retrieved as messages without stacktraces).\n  "
    },
    format_banner = {
      description = "\nformat_banner({:EXIT, pid}, reason, _stacktrace)\n\nformat_banner(:exit, reason, _stacktrace)\n\nformat_banner(:throw, reason, _stacktrace)\n@spec format_banner(kind, any, stacktrace | nil) :: String.t\n  \nformat_banner(:error, exception, stacktrace)\n\n  Normalizes and formats any throw/error/exit.\n\n  The message is formatted and displayed in the same\n  format as used by Elixir's CLI.\n\n  The third argument, a stacktrace, is optional. If it is\n  not supplied `System.stacktrace/0` will sometimes be used\n  to get additional information for the `kind` `:error`. If\n  the stacktrace is unknown and `System.stacktrace/0` would\n  not return the stacktrace corresponding to the exception\n  an empty stacktrace, `[]`, must be used.\n  "
    },
    format_fa = {
      description = "\nformat_fa(fun, arity) when is_function(fun) \n\n  Receives an anonymous function and arity and formats it as\n  shown in stacktraces. The arity may also be a list of arguments.\n\n  ## Examples\n\n      Exception.format_fa(fn -> nil end, 1)\n      #=> \"#Function<...>/1\"\n\n  "
    },
    format_file_line = {
      description = "\nformat_file_line(file, line, suffix \\\\ \"\")\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    },
    format_mfa = {
      description = "\nformat_mfa(module, fun, arity) when is_atom(module) and is_atom(fun) \n\n  Receives a module, fun and arity and formats it\n  as shown in stacktraces. The arity may also be a list\n  of arguments.\n\n  ## Examples\n\n      iex> Exception.format_mfa Foo, :bar, 1\n      \"Foo.bar/1\"\n\n      iex> Exception.format_mfa Foo, :bar, []\n      \"Foo.bar()\"\n\n      iex> Exception.format_mfa nil, :bar, []\n      \"nil.bar()\"\n\n  Anonymous functions are reported as -func/arity-anonfn-count-,\n  where func is the name of the enclosing function. Convert to\n  \"anonymous fn in func/arity\"\n  "
    },
    format_stacktrace = {
      description = "\nformat_stacktrace(trace \\\\ nil)\n\n  Formats the stacktrace.\n\n  A stacktrace must be given as an argument. If not, the stacktrace\n  is retrieved from `Process.info/2`.\n  "
    },
    format_stacktrace_entry = {
      description = "\nformat_stacktrace_entry({fun, arity, location})\n\nformat_stacktrace_entry({module, fun, arity, location})\n\nformat_stacktrace_entry({_module, :__FILE__, 1, location})\n\nformat_stacktrace_entry({_module, :__MODULE__, 1, location})\n@spec format_stacktrace_entry(stacktrace_entry) :: String.t\n  \nformat_stacktrace_entry({module, :__MODULE__, 0, location})\n\n  Receives a stacktrace entry and formats it into a string.\n  "
    },
    kind = {
      description = "kind :: :error | :exit | :throw | {:EXIT, pid}\n"
    },
    message = {
      description = "\nmessage(%{__struct__: module, __exception__: true} = exception) when is_atom(module) \n\n  Gets the message for an `exception`.\n  "
    },
    normalize = {
      description = "\nnormalize(_kind, payload, _stacktrace)\n@spec normalize(:error, any, stacktrace) :: t\n  @spec normalize(kind, payload, stacktrace) :: payload when payload: var\n\n  # Generating a stacktrace is expensive, default to nil\n  # to only fetch it when needed.\n  \nnormalize(:error, exception, stacktrace)\n\n  Normalizes an exception, converting Erlang exceptions\n  to Elixir exceptions.\n\n  It takes the `kind` spilled by `catch` as an argument and\n  normalizes only `:error`, returning the untouched payload\n  for others.\n\n  The third argument, a stacktrace, is optional. If it is\n  not supplied `System.stacktrace/0` will sometimes be used\n  to get additional information for the `kind` `:error`. If\n  the stacktrace is unknown and `System.stacktrace/0` would\n  not return the stacktrace corresponding to the exception\n  an empty stacktrace, `[]`, must be used.\n  "
    },
    stacktrace = {
      description = "stacktrace :: [stacktrace_entry]\n"
    },
    stacktrace_entry = {
      description = "stacktrace_entry :: {module, atom, arity_or_args, location} |\n"
    },
    t = {
      description = "t :: %{\n"
    }
  },
  File = {
    CopyError = {
      message = {
        description = "\nmessage(exception)\n"
      }
    },
    Error = {
      message = {
        description = "\nmessage(%{action: action, reason: reason, path: path})\n"
      }
    },
    Stat = {
      description = "\n  A struct that holds file information.\n\n  In Erlang, this struct is represented by a `:file_info` record.\n  Therefore this module also provides functions for converting\n  between the Erlang record and the Elixir struct.\n\n  Its fields are:\n\n    * `size` - size of file in bytes.\n\n    * `type` - `:device | :directory | :regular | :other`; the type of the\n      file.\n\n    * `access` - `:read | :write | :read_write | :none`; the current system\n      access to the file.\n\n    * `atime` - the last time the file was read.\n\n    * `mtime` - the last time the file was written.\n\n    * `ctime` - the interpretation of this time field depends on the operating\n      system. On Unix, it is the last time the file or the inode was changed.\n      In Windows, it is the time of creation.\n\n    * `mode` - the file permissions.\n\n    * `links` - the number of links to this file. This is always 1 for file\n      systems which have no concept of links.\n\n    * `major_device` - identifies the file system where the file is located.\n      In Windows, the number indicates a drive as follows: 0 means A:, 1 means\n      B:, and so on.\n\n    * `minor_device` - only valid for character devices on Unix. In all other\n      cases, this field is zero.\n\n    * `inode` - gives the inode number. On non-Unix file systems, this field\n      will be zero.\n\n    * `uid` - indicates the owner of the file. Will be zero for non-Unix file\n      systems.\n\n    * `gid` - indicates the group that owns the file. Will be zero for\n      non-Unix file systems.\n\n  The time type returned in `atime`, `mtime`, and `ctime` is dependent on the\n  time type set in options. `{:time, type}` where type can be `:local`,\n  `:universal`, or `:posix`. Default is `:universal`.\n  ",
      from_record = {
        description = "\nfrom_record(file_info)\n\n  Converts a `:file_info` record into a `File.Stat`.\n  "
      },
      t = {
        description = "t :: %__MODULE__{}\n"
      }
    },
    Stream = {
      __build__ = {
        description = "\n__build__(path, modes, line_or_bytes)\nfalse"
      },
      count = {
        description = "\ncount(%{path: path, line_or_bytes: bytes})\n\ncount(%{path: path, modes: modes, line_or_bytes: :line} = stream)\n"
      },
      description = "\n  Defines a `File.Stream` struct returned by `File.stream!/3`.\n\n  The following fields are public:\n\n    * `path`          - the file path\n    * `modes`         - the file modes\n    * `raw`           - a boolean indicating if bin functions should be used\n    * `line_or_bytes` - if reading should read lines or a given amount of bytes\n\n  ",
      into = {
        description = "\ninto(%{path: path, modes: modes, raw: raw} = stream)\n"
      },
      ["member?"] = {
        description = "\nmember?(_stream, _term)\n"
      },
      reduce = {
        description = "\nreduce(%{path: path, modes: modes, line_or_bytes: line_or_bytes, raw: raw}, acc, fun)\n"
      },
      t = {
        description = "t :: %__MODULE__{}\n"
      }
    },
    description = "\n  This module contains functions to manipulate files.\n\n  Some of those functions are low-level, allowing the user\n  to interact with files or IO devices, like `open/2`,\n  `copy/3` and others. This module also provides higher\n  level functions that work with filenames and have their naming\n  based on UNIX variants. For example, one can copy a file\n  via `cp/3` and remove files and directories recursively\n  via `rm_rf/1`.\n\n  Paths given to functions in this module can be either relative to the\n  current working directory (as returned by `File.cwd/0`), or absolute\n  paths. Shell conventions like `~` are not expanded automatically.\n  To use paths like `~/Downloads`, you can use `Path.expand/1` or\n  `Path.expand/2` to expand your path to an absolute path.\n\n  ## Encoding\n\n  In order to write and read files, one must use the functions\n  in the `IO` module. By default, a file is opened in binary mode,\n  which requires the functions `IO.binread/2` and `IO.binwrite/2`\n  to interact with the file. A developer may pass `:utf8` as an\n  option when opening the file, then the slower `IO.read/2` and\n  `IO.write/2` functions must be used as they are responsible for\n  doing the proper conversions and providing the proper data guarantees.\n\n  Note that filenames when given as charlists in Elixir are\n  always treated as UTF-8. In particular, we expect that the\n  shell and the operating system are configured to use UTF-8\n  encoding. Binary filenames are considered raw and passed\n  to the OS as is.\n\n  ## API\n\n  Most of the functions in this module return `:ok` or\n  `{:ok, result}` in case of success, `{:error, reason}`\n  otherwise. Those functions also have a variant\n  that ends with `!` which returns the result (instead of the\n  `{:ok, result}` tuple) in case of success or raises an\n  exception in case it fails. For example:\n\n      File.read(\"hello.txt\")\n      #=> {:ok, \"World\"}\n\n      File.read(\"invalid.txt\")\n      #=> {:error, :enoent}\n\n      File.read!(\"hello.txt\")\n      #=> \"World\"\n\n      File.read!(\"invalid.txt\")\n      #=> raises File.Error\n\n  In general, a developer should use the former in case they want\n  to react if the file does not exist. The latter should be used\n  when the developer expects their software to fail in case the\n  file cannot be read (i.e. it is literally an exception).\n\n  ## Processes and raw files\n\n  Every time a file is opened, Elixir spawns a new process. Writing\n  to a file is equivalent to sending messages to the process that\n  writes to the file descriptor.\n\n  This means files can be passed between nodes and message passing\n  guarantees they can write to the same file in a network.\n\n  However, you may not always want to pay the price for this abstraction.\n  In such cases, a file can be opened in `:raw` mode. The options `:read_ahead`\n  and `:delayed_write` are also useful when operating on large files or\n  working with files in tight loops.\n\n  Check [`:file.open/2`](http://www.erlang.org/doc/man/file.html#open-2) for more information\n  about such options and other performance considerations.\n  ",
    io_device = {
      description = "io_device :: :file.io_device()\n"
    },
    ln_s = {
      description = "@spec touch!(Path.t, :calendar.datetime) :: :ok | no_return\n  \nln_s(existing, new)\n\n  Creates a symbolic link `new` to the file or directory `existing`.\n\n  Returns `:ok` if successful, `{:error, reason}` otherwise.\n  If the operating system does not support symlinks, returns\n  `{:error, :enotsup}`.\n  "
    },
    mode = {
      description = "mode :: :append | :binary | :charlist | :compressed | :delayed_write | :exclusive |\n"
    },
    open = {
      description = "\nopen(path, function) when is_function(function, 1) \n@spec open(Path.t, [mode | :ram]) :: {:ok, io_device} | {:error, posix}\n  @spec open(Path.t, (io_device -> res)) :: {:ok, res} | {:error, posix} when res: var\n  \nopen(path, modes) when is_list(modes) \n\n  Opens the given `path`.\n\n  In order to write and read files, one must use the functions\n  in the `IO` module. By default, a file is opened in `:binary` mode,\n  which requires the functions `IO.binread/2` and `IO.binwrite/2`\n  to interact with the file. A developer may pass `:utf8` as an\n  option when opening the file and then all other functions from\n  `IO` are available, since they work directly with Unicode data.\n\n  `modes_or_function` can either be a list of modes or a function. If it's a\n  list, it's considered to be a list of modes (that are documented below). If\n  it's a function, then it's equivalent to calling `open(path, [],\n  modes_or_function)`. See the documentation for `open/3` for more information\n  on this function.\n\n  The allowed modes:\n\n    * `:binary` - opens the file in binary mode, disabling special handling of unicode sequences\n      (default mode).\n\n    * `:read` - the file, which must exist, is opened for reading.\n\n    * `:write` - the file is opened for writing. It is created if it does not\n      exist.\n\n      If the file does exists, and if write is not combined with read, the file\n      will be truncated.\n\n    * `:append` - the file will be opened for writing, and it will be created\n      if it does not exist. Every write operation to a file opened with append\n      will take place at the end of the file.\n\n    * `:exclusive` - the file, when opened for writing, is created if it does\n      not exist. If the file exists, open will return `{:error, :eexist}`.\n\n    * `:charlist` - when this term is given, read operations on the file will\n      return charlists rather than binaries.\n\n    * `:compressed` - makes it possible to read or write gzip compressed files.\n\n      The compressed option must be combined with either read or write, but not\n      both. Note that the file size obtained with `stat/1` will most probably\n      not match the number of bytes that can be read from a compressed file.\n\n    * `:utf8` - this option denotes how data is actually stored in the disk\n      file and makes the file perform automatic translation of characters to\n      and from UTF-8.\n\n      If data is sent to a file in a format that cannot be converted to the\n      UTF-8 or if data is read by a function that returns data in a format that\n      cannot cope with the character range of the data, an error occurs and the\n      file will be closed.\n\n    * `:delayed_write`, `:raw`, `:ram`, `:read_ahead`, `:sync`, `{:encoding, ...}`,\n      `{:read_ahead, pos_integer}`, `{:delayed_write, non_neg_integer, non_neg_integer}` -\n      for more information about these options see [`:file.open/2`](http://www.erlang.org/doc/man/file.html#open-2).\n\n  This function returns:\n\n    * `{:ok, io_device}` - the file has been opened in the requested mode.\n\n      `io_device` is actually the PID of the process which handles the file.\n      This process is linked to the process which originally opened the file.\n      If any process to which the `io_device` is linked terminates, the file\n      will be closed and the process itself will be terminated.\n\n      An `io_device` returned from this call can be used as an argument to the\n      `IO` module functions.\n\n    * `{:error, reason}` - the file could not be opened.\n\n  ## Examples\n\n      {:ok, file} = File.open(\"foo.tar.gz\", [:read, :compressed])\n      IO.read(file, :line)\n      File.close(file)\n\n  "
    },
    posix = {
      description = "posix :: :file.posix()\n"
    },
    stat_options = {
      description = "stat_options :: [time: :local | :universal | :posix]\n"
    },
    ["stream!"] = {
      description = "@spec close(io_device) :: :ok | {:error, posix | :badarg | :terminated}\n  \nstream!(path, modes \\\\ [], line_or_bytes \\\\ :line)\n\n  Returns a `File.Stream` for the given `path` with the given `modes`.\n\n  The stream implements both `Enumerable` and `Collectable` protocols,\n  which means it can be used both for read and write.\n\n  The `line_or_bytes` argument configures how the file is read when\n  streaming, by `:line` (default) or by a given number of bytes.\n\n  Operating the stream can fail on open for the same reasons as\n  `File.open!/2`. Note that the file is automatically opened each time streaming\n  begins. There is no need to pass `:read` and `:write` modes, as those are\n  automatically set by Elixir.\n\n  ## Raw files\n\n  Since Elixir controls when the streamed file is opened, the underlying\n  device cannot be shared and as such it is convenient to open the file\n  in raw mode for performance reasons. Therefore, Elixir **will** open\n  streams in `:raw` mode with the `:read_ahead` option unless an encoding\n  is specified. This means any data streamed into the file must be\n  converted to `t:iodata/0` type. If you pass `[:utf8]` in the modes parameter,\n  the underlying stream will use `IO.write/2` and the `String.Chars` protocol\n  to convert the data. See `IO.binwrite/2` and `IO.write/2` .\n\n  One may also consider passing the `:delayed_write` option if the stream\n  is meant to be written to under a tight loop.\n\n  ## Byte order marks\n\n  If you pass `:trim_bom` in the modes parameter, the stream will\n  trim UTF-8, UTF-16 and UTF-32 byte order marks when reading from file.\n\n  ## Examples\n\n      # Read in 2048 byte chunks rather than lines\n      File.stream!(\"./test/test.data\", [], 2048)\n      #=> %File.Stream{line_or_bytes: 2048, modes: [:raw, :read_ahead, :binary],\n      #=> path: \"./test/test.data\", raw: true}\n\n  See `Stream.run/1` for an example of streaming into a file.\n\n  "
    }
  },
  Float = {
    description = "\n  Functions for working with floating point numbers.\n  ",
    parse = {
      description = "\nparse(binary)\n@spec parse(binary) :: {float, binary} | :error\n  \nparse(\"+\" <> binary)\n\n  Parses a binary into a float.\n\n  If successful, returns a tuple in the form of `{float, remainder_of_binary}`;\n  when the binary cannot be coerced into a valid float, the atom `:error` is\n  returned.\n\n  If the size of float exceeds the maximum size of `1.7976931348623157e+308`,\n  the `ArgumentError` exception is raised.\n\n  If you want to convert a string-formatted float directly to a float,\n  `String.to_float/1` can be used instead.\n\n  ## Examples\n\n      iex> Float.parse(\"34\")\n      {34.0, \"\"}\n      iex> Float.parse(\"34.25\")\n      {34.25, \"\"}\n      iex> Float.parse(\"56.5xyz\")\n      {56.5, \"xyz\"}\n\n      iex> Float.parse(\"pi\")\n      :error\n\n  "
    },
    ratio = {
      description = "@spec round(float, 0..15) :: float\n\n  # This implementation is slow since it relies on big integers.\n  # Faster implementations are available on more recent papers\n  # and could be implemented in the future.\n  \nratio(float) when is_float(float) \n\n  Returns a pair of integers whose ratio is exactly equal\n  to the original float and with a positive denominator.\n\n  ## Examples\n\n      iex> Float.ratio(3.14)\n      {7070651414971679, 2251799813685248}\n      iex> Float.ratio(-3.14)\n      {-7070651414971679, 2251799813685248}\n      iex> Float.ratio(1.5)\n      {3, 2}\n      iex> Float.ratio(-1.5)\n      {-3, 2}\n      iex> Float.ratio(16.0)\n      {16, 1}\n      iex> Float.ratio(-16.0)\n      {-16, 1}\n\n  "
    },
    to_char_list = {
      description = "\nto_char_list(float, options)false\n@spec to_string(float) :: String.t\n  \nto_char_list(float)\nfalse"
    },
    to_string = {
      description = "\nto_string(float, options)\nfalse"
    }
  },
  FunctionClauseError = {
    message = {
      description = "\nmessage(exception)\n"
    }
  },
  GenEvent = {
    Stream = {
      code_change = {
        description = "\ncode_change(_old, state, _extra)\nfalse"
      },
      count = {
        description = "\ncount(_stream)\n"
      },
      description = "false",
      handle_call = {
        description = "\nhandle_call(msg, _state)\nfalse"
      },
      handle_event = {
        description = "\nhandle_event(event, _state)\nfalse"
      },
      handle_info = {
        description = "\nhandle_info(_msg, state)\nfalse"
      },
      init = {
        description = "\ninit({_pid, _ref} = state)\nfalse"
      },
      ["member?"] = {
        description = "\nmember?(_stream, _item)\n"
      },
      reduce = {
        description = "\nreduce(stream, acc, fun)\n"
      },
      t = {
        description = "t :: %__MODULE__{\n"
      },
      terminate = {
        description = "\nterminate(_reason, _state)\nfalse"
      }
    },
    __using__ = {
      description = "\n__using__(_)\nfalse"
    },
    code_change = {
      description = "\ncode_change(_old, state, _extra)\nfalse"
    },
    description = "\n  WARNING: this module is deprecated.\n\n  If you are interested in implementing an event manager, please read the\n  \"Alternatives\" section below. If you have to implement an event handler to\n  integrate with an existing system, such as Elixir's Logger, please use\n  `:gen_event` instead.\n\n  ## Alternatives\n\n  There are a few suitable alternatives to replace GenEvent. Each of them can be\n  the most beneficial based on the use case.\n\n  ### Supervisor and GenServers\n\n  One alternative to GenEvent is a very minimal solution consisting of using a\n  supervisor and multiple GenServers started under it. The supervisor acts as\n  the \"event manager\" and the children GenServers act as the \"event handlers\".\n  This approach has some shortcomings (it provides no backpressure for example)\n  but can still replace GenEvent for low-profile usages of it. [This blog post\n  by José\n  Valim](http://blog.plataformatec.com.br/2016/11/replacing-genevent-by-a-supervisor-genserver/)\n  has more detailed information on this approach.\n\n  ### GenStage\n\n  If the use case where you were using GenEvent requires more complex logic,\n  [GenStage](https://github.com/elixir-lang/gen_stage) provides a great\n  alternative. GenStage is an external Elixir library maintained by the Elixir\n  team; it provides tool to implement systems that exchange events in a\n  demand-driven way with built-in support for backpressure. See the [GenStage\n  documentation](https://hexdocs.pm/gen_stage) for more information.\n\n  ### `:gen_event`\n\n  If your use case requires exactly what GenEvent provided, or you have to\n  integrate with an existing `:gen_event`-based system, you can still use the\n  [`:gen_event`](http://erlang.org/doc/man/gen_event.html) Erlang module.\n  ",
    format_status = {
      description = "\nformat_status(opt, status_data)\nfalse"
    },
    handle_call = {
      description = "\nhandle_call(msg, state)\nfalse"
    },
    handle_event = {
      description = "\nhandle_event(_event, state)\nfalse"
    },
    handle_info = {
      description = "\nhandle_info(_msg, state)\nfalse"
    },
    handler = {
      description = "handler :: atom | {atom, term}\n"
    },
    init = {
      description = "\ninit(args)\nfalse"
    },
    init_hib = {
      description = "\ninit_hib(parent, name, handlers, debug)\nfalse"
    },
    init_it = {
      description = "\ninit_it(starter, parent, name, _mod, _args, options)\n@spec stop(manager, reason :: term, timeout) :: :ok\n  \ninit_it(starter, :self, name, mod, args, options)\nfalse"
    },
    manager = {
      description = "manager :: pid | name | {atom, node}\n"
    },
    name = {
      description = "name :: atom | {:global, term} | {:via, module, term}\n"
    },
    notify = {
      description = "\nnotify(manager, msg)\n      when is_pid(manager)\n      when is_atom(manager)\n      when tuple_size(manager) == 2 and\n        is_atom(elem(manager, 0)) and is_atom(elem(manager, 1)) \n\nnotify({:via, mod, name}, msg) when is_atom(mod) \n@spec notify(manager, term) :: :ok\n  \nnotify({:global, name}, msg)\nfalse"
    },
    on_start = {
      description = "on_start :: {:ok, pid} | {:error, {:already_started, pid}}\n"
    },
    options = {
      description = "options :: [name: name]\n"
    },
    system_code_change = {
      description = "\nsystem_code_change([name, handlers, hib], module, old_vsn, extra)\nfalse"
    },
    system_continue = {
      description = "\nsystem_continue(parent, debug, [name, handlers, hib])\nfalse"
    },
    system_get_state = {
      description = "\nsystem_get_state([_name, handlers, _hib])\nfalse"
    },
    system_replace_state = {
      description = "\nsystem_replace_state(fun, [name, handlers, hib])\nfalse"
    },
    system_terminate = {
      description = "\nsystem_terminate(reason, parent, _debug, [name, handlers, _hib])\nfalse"
    },
    terminate = {
      description = "\nterminate(_reason, _state)\nfalse"
    }
  },
  GenServer = {
    __using__ = {
      description = "\n__using__(_)\nfalse"
    },
    cast = {
      description = "\ncast(dest, request) when is_atom(dest) or is_pid(dest),\n    \n\ncast({name, node}, request) when is_atom(name) and is_atom(node),\n    \n\ncast({:via, mod, name}, request)\n@spec cast(server, term) :: :ok\n  \ncast({:global, name}, request)\n\n  Sends an asynchronous request to the `server`.\n\n  This function always returns `:ok` regardless of whether\n  the destination `server` (or node) exists. Therefore it\n  is unknown whether the destination `server` successfully\n  handled the message.\n\n  `c:handle_cast/2` will be called on the server to handle\n  the request. In case the `server` is on a node which is\n  not yet connected to the caller one, the call is going to\n  block until a connection happens. This is different than\n  the behaviour in OTP's `:gen_server` where the message\n  is sent by another process in this case, which could cause\n  messages to other nodes to arrive out of order.\n  "
    },
    code_change = {
      description = "\ncode_change(_old, state, _extra)\nfalse"
    },
    debug = {
      description = "debug :: [:trace | :log | :statistics | {:log_to_file, Path.t}]\n"
    },
    description = "\n  A behaviour module for implementing the server of a client-server relation.\n\n  A GenServer is a process like any other Elixir process and it can be used\n  to keep state, execute code asynchronously and so on. The advantage of using\n  a generic server process (GenServer) implemented using this module is that it\n  will have a standard set of interface functions and include functionality for\n  tracing and error reporting. It will also fit into a supervision tree.\n\n  ## Example\n\n  The GenServer behaviour abstracts the common client-server interaction.\n  Developers are only required to implement the callbacks and functionality they are\n  interested in.\n\n  Let's start with a code example and then explore the available callbacks.\n  Imagine we want a GenServer that works like a stack, allowing us to push\n  and pop items:\n\n      defmodule Stack do\n        use GenServer\n\n        # Callbacks\n\n        def handle_call(:pop, _from, [h | t]) do\n          {:reply, h, t}\n        end\n\n        def handle_cast({:push, item}, state) do\n          {:noreply, [item | state]}\n        end\n      end\n\n      # Start the server\n      {:ok, pid} = GenServer.start_link(Stack, [:hello])\n\n      # This is the client\n      GenServer.call(pid, :pop)\n      #=> :hello\n\n      GenServer.cast(pid, {:push, :world})\n      #=> :ok\n\n      GenServer.call(pid, :pop)\n      #=> :world\n\n  We start our `Stack` by calling `start_link/3`, passing the module\n  with the server implementation and its initial argument (a list\n  representing the stack containing the item `:hello`). We can primarily\n  interact with the server by sending two types of messages. **call**\n  messages expect a reply from the server (and are therefore synchronous)\n  while **cast** messages do not.\n\n  Every time you do a `GenServer.call/3`, the client will send a message\n  that must be handled by the `c:handle_call/3` callback in the GenServer.\n  A `cast/2` message must be handled by `c:handle_cast/2`.\n\n  ## Callbacks\n\n  There are 6 callbacks required to be implemented in a `GenServer`. By\n  adding `use GenServer` to your module, Elixir will automatically define\n  all 6 callbacks for you, leaving it up to you to implement the ones\n  you want to customize.\n\n  ## Name Registration\n\n  Both `start_link/3` and `start/3` support the `GenServer` to register\n  a name on start via the `:name` option. Registered names are also\n  automatically cleaned up on termination. The supported values are:\n\n    * an atom - the GenServer is registered locally with the given name\n      using `Process.register/2`.\n\n    * `{:global, term}`- the GenServer is registered globally with the given\n      term using the functions in the [`:global` module](http://www.erlang.org/doc/man/global.html).\n\n    * `{:via, module, term}` - the GenServer is registered with the given\n      mechanism and name. The `:via` option expects a module that exports\n      `register_name/2`, `unregister_name/1`, `whereis_name/1` and `send/2`.\n      One such example is the [`:global` module](http://www.erlang.org/doc/man/global.html) which uses these functions\n      for keeping the list of names of processes and their associated PIDs\n      that are available globally for a network of Elixir nodes. Elixir also\n      ships with a local, decentralized and scalable registry called `Registry`\n      for locally storing names that are generated dynamically.\n\n  For example, we could start and register our `Stack` server locally as follows:\n\n      # Start the server and register it locally with name MyStack\n      {:ok, _} = GenServer.start_link(Stack, [:hello], name: MyStack)\n\n      # Now messages can be sent directly to MyStack\n      GenServer.call(MyStack, :pop) #=> :hello\n\n  Once the server is started, the remaining functions in this module (`call/3`,\n  `cast/2`, and friends) will also accept an atom, or any `:global` or `:via`\n  tuples. In general, the following formats are supported:\n\n    * a `pid`\n    * an `atom` if the server is locally registered\n    * `{atom, node}` if the server is locally registered at another node\n    * `{:global, term}` if the server is globally registered\n    * `{:via, module, name}` if the server is registered through an alternative\n      registry\n\n  If there is an interest to register dynamic names locally, do not use\n  atoms, as atoms are never garbage collected and therefore dynamically\n  generated atoms won't be garbage collected. For such cases, you can\n  set up your own local registry by using the `Registry` module.\n\n  ## Client / Server APIs\n\n  Although in the example above we have used `GenServer.start_link/3` and\n  friends to directly start and communicate with the server, most of the\n  time we don't call the `GenServer` functions directly. Instead, we wrap\n  the calls in new functions representing the public API of the server.\n\n  Here is a better implementation of our Stack module:\n\n      defmodule Stack do\n        use GenServer\n\n        # Client\n\n        def start_link(default) do\n          GenServer.start_link(__MODULE__, default)\n        end\n\n        def push(pid, item) do\n          GenServer.cast(pid, {:push, item})\n        end\n\n        def pop(pid) do\n          GenServer.call(pid, :pop)\n        end\n\n        # Server (callbacks)\n\n        def handle_call(:pop, _from, [h | t]) do\n          {:reply, h, t}\n        end\n\n        def handle_call(request, from, state) do\n          # Call the default implementation from GenServer\n          super(request, from, state)\n        end\n\n        def handle_cast({:push, item}, state) do\n          {:noreply, [item | state]}\n        end\n\n        def handle_cast(request, state) do\n          super(request, state)\n        end\n      end\n\n  In practice, it is common to have both server and client functions in\n  the same module. If the server and/or client implementations are growing\n  complex, you may want to have them in different modules.\n\n  ## Receiving \"regular\" messages\n\n  The goal of a `GenServer` is to abstract the \"receive\" loop for developers,\n  automatically handling system messages, support code change, synchronous\n  calls and more. Therefore, you should never call your own \"receive\" inside\n  the GenServer callbacks as doing so will cause the GenServer to misbehave.\n\n  Besides the synchronous and asynchronous communication provided by `call/3`\n  and `cast/2`, \"regular\" messages sent by functions such `Kernel.send/2`,\n  `Process.send_after/4` and similar, can be handled inside the `c:handle_info/2`\n  callback.\n\n  `c:handle_info/2` can be used in many situations, such as handling monitor\n  DOWN messages sent by `Process.monitor/1`. Another use case for `c:handle_info/2`\n  is to perform periodic work, with the help of `Process.send_after/4`:\n\n      defmodule MyApp.Periodically do\n        use GenServer\n\n        def start_link do\n          GenServer.start_link(__MODULE__, %{})\n        end\n\n        def init(state) do\n          schedule_work() # Schedule work to be performed on start\n          {:ok, state}\n        end\n\n        def handle_info(:work, state) do\n          # Do the desired work here\n          schedule_work() # Reschedule once more\n          {:noreply, state}\n        end\n\n        defp schedule_work() do\n          Process.send_after(self(), :work, 2 * 60 * 60 * 1000) # In 2 hours\n        end\n      end\n\n  ## Debugging with the :sys module\n\n  GenServers, as [special processes](http://erlang.org/doc/design_principles/spec_proc.html),\n  can be debugged using the [`:sys` module](http://www.erlang.org/doc/man/sys.html). Through various hooks, this module\n  allows developers to introspect the state of the process and trace\n  system events that happen during its execution, such as received messages,\n  sent replies and state changes.\n\n  Let's explore the basic functions from the [`:sys` module](http://www.erlang.org/doc/man/sys.html) used for debugging:\n\n    * [`:sys.get_state/2`](http://erlang.org/doc/man/sys.html#get_state-2) -\n      allows retrieval of the state of the process. In the case of\n      a GenServer process, it will be the callback module state, as\n      passed into the callback functions as last argument.\n    * [`:sys.get_status/2`](http://erlang.org/doc/man/sys.html#get_status-2) -\n      allows retrieval of the status of the process. This status includes\n      the process dictionary, if the process is running or is suspended,\n      the parent PID, the debugger state, and the state of the behaviour module,\n      which includes the callback module state (as returned by `:sys.get_state/2`).\n      It's possible to change how this status is represented by defining\n      the optional `c:GenServer.format_status/2` callback.\n    * [`:sys.trace/3`](http://erlang.org/doc/man/sys.html#trace-3) -\n      prints all the system events to `:stdio`.\n    * [`:sys.statistics/3`](http://erlang.org/doc/man/sys.html#statistics-3) -\n      manages collection of process statistics.\n    * [`:sys.no_debug/2`](http://erlang.org/doc/man/sys.html#no_debug-2) -\n      turns off all debug handlers for the given process. It is very important\n      to switch off debugging once we're done. Excessive debug handlers or\n      those that should be turned off, but weren't, can seriously damage\n      the performance of the system.\n\n  Let's see how we could use those functions for debugging the stack server\n  we defined earlier.\n\n      iex> {:ok, pid} = Stack.start_link([])\n      iex> :sys.statistics(pid, true) # turn on collecting process statistics\n      iex> :sys.trace(pid, true) # turn on event printing\n      iex> Stack.push(pid, 1)\n      *DBG* <0.122.0> got cast {push,1}\n      *DBG* <0.122.0> new state [1]\n      :ok\n      iex> :sys.get_state(pid)\n      [1]\n      iex> Stack.pop(pid)\n      *DBG* <0.122.0> got call pop from <0.80.0>\n      *DBG* <0.122.0> sent 1 to <0.80.0>, new state []\n      1\n      iex> :sys.statistics(pid, :get)\n      {:ok,\n       [start_time: {{2016, 7, 16}, {12, 29, 41}},\n        current_time: {{2016, 7, 16}, {12, 29, 50}},\n        reductions: 117, messages_in: 2, messages_out: 0]}\n      iex> :sys.no_debug(pid) # turn off all debug handlers\n      :ok\n      iex> :sys.get_status(pid)\n      {:status, #PID<0.122.0>, {:module, :gen_server},\n       [[\"$initial_call\": {Stack, :init, 1},            # pdict\n         \"$ancestors\": [#PID<0.80.0>, #PID<0.51.0>]],\n        :running,                                       # :running | :suspended\n        #PID<0.80.0>,                                   # parent\n        [],                                             # debugger state\n        [header: 'Status for generic server <0.122.0>', # module status\n         data: [{'Status', :running}, {'Parent', #PID<0.80.0>},\n           {'Logged events', []}], data: [{'State', [1]}]]]}\n\n  ## Learn more\n\n  If you wish to find out more about gen servers, the Elixir Getting Started\n  guide provides a tutorial-like introduction. The documentation and links\n  in Erlang can also provide extra insight.\n\n    * [GenServer – Elixir's Getting Started Guide](http://elixir-lang.org/getting-started/mix-otp/genserver.html)\n    * [`:gen_server` module documentation](http://www.erlang.org/doc/man/gen_server.html)\n    * [gen_server Behaviour – OTP Design Principles](http://www.erlang.org/doc/design_principles/gen_server_concepts.html)\n    * [Clients and Servers – Learn You Some Erlang for Great Good!](http://learnyousomeerlang.com/clients-and-servers)\n  ",
    from = {
      description = "from :: {pid, tag :: term}\n\n  Tuple describing the client of a call request.\n\n  `pid` is the PID of the caller and `tag` is a unique term used to identify the\n  call.\n  "
    },
    handle_call = {
      description = "\nhandle_call(msg, _from, state)\nfalse"
    },
    handle_cast = {
      description = "\nhandle_cast(msg, state)\nfalse"
    },
    handle_info = {
      description = "\nhandle_info(msg, state)\nfalse"
    },
    init = {
      description = "\ninit(args)\nfalse"
    },
    name = {
      description = "name :: atom | {:global, term} | {:via, module, term}\n"
    },
    on_start = {
      description = "on_start :: {:ok, pid} | :ignore | {:error, {:already_started, pid} | term}\n"
    },
    option = {
      description = "option :: {:debug, debug} |\n"
    },
    options = {
      description = "options :: [option]\n"
    },
    reply = {
      description = "@spec reply(from, term) :: :ok\n  \nreply({to, tag}, reply) when is_pid(to) \n\n  Replies to a client.\n\n  This function can be used to explicitly send a reply to a client that called\n  `call/3` or `multi_call/4` when the reply cannot be specified in the return\n  value of `c:handle_call/3`.\n\n  `client` must be the `from` argument (the second argument) accepted by\n  `c:handle_call/3` callbacks. `reply` is an arbitrary term which will be given\n  back to the client as the return value of the call.\n\n  Note that `reply/2` can be called from any process, not just the GenServer\n  that originally received the call (as long as that GenServer communicated the\n  `from` argument somehow).\n\n  This function always returns `:ok`.\n\n  ## Examples\n\n      def handle_call(:reply_in_one_second, from, state) do\n        Process.send_after(self(), {:reply, from}, 1_000)\n        {:noreply, state}\n      end\n\n      def handle_info({:reply, from}, state) do\n        GenServer.reply(from, :one_second_has_passed)\n        {:noreply, state}\n      end\n\n  "
    },
    server = {
      description = "server :: pid | name | {atom, node}\n"
    },
    terminate = {
      description = "\nterminate(_reason, _state)\nfalse"
    },
    whereis = {
      description = "\nwhereis({name, node} = server) when is_atom(name) and is_atom(node) \n\nwhereis({name, local}) when is_atom(name) and local == node() \n\nwhereis({:via, mod, name})\n\nwhereis({:global, name})\n@spec whereis(server) :: pid | {atom, node} | nil\n  \nwhereis(name) when is_atom(name) \n\n  Returns the `pid` or `{name, node}` of a GenServer process, or `nil` if\n  no process is associated with the given name.\n\n  ## Examples\n\n  For example, to lookup a server process, monitor it and send a cast to it:\n\n      process = GenServer.whereis(server)\n      monitor = Process.monitor(process)\n      GenServer.cast(process, :hello)\n\n  "
    }
  },
  H = {
    on_def = {
      description = "\non_def(_env, kind, name, args, guards, body)\n"
    }
  },
  HashDict = {
    count = {
      description = "\ncount(dict)\n"
    },
    delete = {
      description = "\ndelete(dict, key)\n"
    },
    description = "\n  WARNING: this module is deprecated.\n\n  Use the `Map` module instead.\n  ",
    dict_delete = {
      description = "\ndict_delete(%HashDict{root: root, size: size}, key)\nfalse"
    },
    fetch = {
      description = "\nfetch(%HashDict{root: root}, key)\n"
    },
    inspect = {
      description = "\ninspect(dict, opts)\n"
    },
    into = {
      description = "\ninto(original)\n"
    },
    ["member?"] = {
      description = "\nmember?(_dict, _)\n\nmember?(dict, {k, v})\n"
    },
    pop = {
      description = "\npop(dict, key, default \\\\ nil)\n"
    },
    put = {
      description = "@spec new :: Dict.t\n  \nput(%HashDict{root: root, size: size}, key, value)\n\n  Creates a new empty dict.\n  "
    },
    reduce = {
      description = "\nreduce(dict, acc, fun)\n\nreduce(%HashDict{root: root}, acc, fun)\nfalse"
    },
    size = {
      description = "\nsize(%HashDict{size: size})\n"
    },
    update = {
      description = "\nupdate(%HashDict{root: root, size: size}, key, initial, fun) when is_function(fun, 1) \n"
    },
    ["update!"] = {
      description = "\nupdate!(%HashDict{root: root, size: size} = dict, key, fun) when is_function(fun, 1) \n"
    }
  },
  HashSet = {
    count = {
      description = "\ncount(set)\n"
    },
    delete = {
      description = "\ndelete(%HashSet{root: root, size: size} = set, term)\n"
    },
    description = "\n  WARNING: this module is deprecated.\n\n  Use the `MapSet` module instead.\n  ",
    difference = {
      description = "\ndifference(%HashSet{} = set1, %HashSet{} = set2)\n"
    },
    ["disjoint?"] = {
      description = "\ndisjoint?(%HashSet{} = set1, %HashSet{} = set2)\n"
    },
    ["equal?"] = {
      description = "\nequal?(%HashSet{size: size1} = set1, %HashSet{size: size2} = set2)\n"
    },
    inspect = {
      description = "\ninspect(set, opts)\n"
    },
    intersection = {
      description = "\nintersection(%HashSet{} = set1, %HashSet{} = set2)\n"
    },
    into = {
      description = "\ninto(original)\n"
    },
    ["member?"] = {
      description = "\nmember?(set, v)\n\nmember?(%HashSet{root: root}, term)\n"
    },
    put = {
      description = "\nput(%HashSet{root: root, size: size}, term)\n"
    },
    reduce = {
      description = "\nreduce(set, acc, fun)\n\nreduce(%HashSet{root: root}, acc, fun)\nfalse"
    },
    size = {
      description = "\nsize(%HashSet{size: size})\n"
    },
    ["subset?"] = {
      description = "\nsubset?(%HashSet{} = set1, %HashSet{} = set2)\n"
    },
    to_list = {
      description = "\nto_list(set)\n"
    },
    union = {
      description = "\nunion(%HashSet{} = set1, %HashSet{} = set2)\n@spec new :: Set.t\n  \nunion(%HashSet{size: size1} = set1, %HashSet{size: size2} = set2) when size1 <= size2 \nfalse"
    }
  },
  IO = {
    ANSI = {
      Docs = {
        default_options = {
          description = "\ndefault_options\n\n  The default options used by this module.\n\n  The supported values are:\n\n    * `:enabled`           - toggles coloring on and off (true)\n    * `:doc_bold`          - bold text (bright)\n    * `:doc_code`          - code blocks (cyan)\n    * `:doc_headings`      - h1, h2, h3, h4, h5, h6 headings (yellow)\n    * `:doc_inline_code`   - inline code (cyan)\n    * `:doc_table_heading` - style for table headings\n    * `:doc_title`         - top level heading (reverse, yellow)\n    * `:doc_underline`     - underlined text (underline)\n    * `:width`             - the width to format the text (80)\n\n  Values for the color settings are strings with\n  comma-separated ANSI values.\n  "
        },
        description = "false",
        print = {
          description = "\nprint(doc, options \\\\ [])\n\n  Prints the documentation body.\n\n  In addition to the printing string, takes a set of options\n  defined in `default_options/1`.\n  "
        },
        print_heading = {
          description = "\nprint_heading(heading, options \\\\ [])\n\n  Prints the head of the documentation (i.e. the function signature).\n\n  See `default_options/0` for docs on the supported options.\n  "
        }
      },
      Sequence = {
        defsequence = {
          description = "\ndefsequence(name, code, terminator \\\\ \"m\")\n"
        },
        description = "false"
      },
      ansicode = {
        description = "ansicode :: atom\n"
      },
      ansidata = {
        description = "ansidata :: ansilist | ansicode | binary\n"
      },
      ansilist = {
        description = "ansilist :: maybe_improper_list(char | ansicode | binary | ansilist, binary | ansicode | [])\n"
      },
      description = "\n  Functionality to render ANSI escape sequences.\n\n  [ANSI escape sequences](https://en.wikipedia.org/wiki/ANSI_escape_code)\n  are characters embedded in text used to control formatting, color, and\n  other output options on video text terminals.\n  "
    },
    Stream = {
      __build__ = {
        description = "\n__build__(device, raw, line_or_bytes)\nfalse"
      },
      count = {
        description = "\ncount(_stream)\n"
      },
      description = "\n  Defines an `IO.Stream` struct returned by `IO.stream/2` and `IO.binstream/2`.\n\n  The following fields are public:\n\n    * `device`        - the IO device\n    * `raw`           - a boolean indicating if bin functions should be used\n    * `line_or_bytes` - if reading should read lines or a given amount of bytes\n\n  It is worth noting that an IO stream has side effects and every time you go\n  over the stream you may get different results.\n\n  ",
      into = {
        description = "\ninto(%{device: device, raw: raw} = stream)\n"
      },
      ["member?"] = {
        description = "\nmember?(_stream, _term)\n"
      },
      reduce = {
        description = "\nreduce(%{device: device, raw: raw, line_or_bytes: line_or_bytes}, acc, fun)\n"
      },
      t = {
        description = "t :: %__MODULE__{}\n"
      }
    },
    StreamError = {
      exception = {
        description = "\nexception(opts)\n"
      }
    },
    binread = {
      description = "\nbinread(device, count) when is_integer(count) and count >= 0 \n\nbinread(device, :line)\n@spec binread(device, :all | :line | non_neg_integer) :: iodata | nodata\n  \nbinread(device, :all)\n\n  Reads from the IO `device`. The operation is Unicode unsafe.\n\n  The `device` is iterated by the given number of bytes or line by line if\n  `:line` is given.\n  Alternatively, if `:all` is given, then whole `device` is returned.\n\n  It returns:\n\n    * `data` - the output bytes\n\n    * `:eof` - end of file was encountered\n\n    * `{:error, reason}` - other (rare) error condition;\n      for instance, `{:error, :estale}` if reading from an\n      NFS volume\n\n  If `:all` is given, `:eof` is never returned, but an\n  empty string in case the device has reached EOF.\n\n  Note: do not use this function on IO devices in Unicode mode\n  as it will return the wrong result.\n  "
    },
    chardata_to_string = {
      description = "@spec chardata_to_string(chardata) :: String.t | no_return\n  \nchardata_to_string(list) when is_list(list) \n\n  Converts chardata (a list of integers representing codepoints,\n  lists and strings) into a string.\n\n  In case the conversion fails, it raises an `UnicodeConversionError`.\n  If a string is given, it returns the string itself.\n\n  ## Examples\n\n      iex> IO.chardata_to_string([0x00E6, 0x00DF])\n      \"æß\"\n\n      iex> IO.chardata_to_string([0x0061, \"bc\"])\n      \"abc\"\n\n      iex> IO.chardata_to_string(\"string\")\n      \"string\"\n\n  "
    },
    description = "\n  Functions handling input/output (IO).\n\n  Many functions in this module expect an IO device as an argument.\n  An IO device must be a PID or an atom representing a process.\n  For convenience, Elixir provides `:stdio` and `:stderr` as\n  shortcuts to Erlang's `:standard_io` and `:standard_error`.\n\n  The majority of the functions expect chardata, i.e. strings or\n  lists of characters and strings. In case another type is given,\n  functions will convert to string via the `String.Chars` protocol\n  (as shown in typespecs).\n\n  The functions starting with `bin` expect iodata as an argument,\n  i.e. binaries or lists of bytes and binaries.\n\n  ## IO devices\n\n  An IO device may be an atom or a PID. In case it is an atom,\n  the atom must be the name of a registered process. In addition,\n  Elixir provides two shortcuts:\n\n    * `:stdio` - a shortcut for `:standard_io`, which maps to\n      the current `Process.group_leader/0` in Erlang\n\n    * `:stderr` - a shortcut for the named process `:standard_error`\n      provided in Erlang\n\n  IO devices maintain their position, that means subsequent calls to any\n  reading or writing functions will start from the place when the device\n  was last accessed. Position of files can be changed using the\n  `:file.position/2` function.\n\n  ",
    device = {
      description = "device :: atom | pid\n"
    },
    each_binstream = {
      description = "\neach_binstream(device, line_or_chars)\nfalse"
    },
    each_stream = {
      description = "@spec iodata_length(iodata) :: non_neg_integer\n  \neach_stream(device, line_or_codepoints)\nfalse"
    },
    getn = {
      description = "\ngetn(device, prompt) when not is_integer(prompt) \n@spec getn(chardata | String.Chars.t, pos_integer) :: chardata | nodata\n  @spec getn(device, chardata | String.Chars.t) :: chardata | nodata\n  \ngetn(prompt, count) when is_integer(count) and count > 0 \n\n  Gets a number of bytes from IO device `:stdio`.\n\n  If `:stdio` is a Unicode device, `count` implies\n  the number of Unicode codepoints to be retrieved.\n  Otherwise, `count` is the number of raw bytes to be retrieved.\n\n  See `IO.getn/3` for a description of return values.\n\n  "
    },
    nodata = {
      description = "nodata :: {:error, term} | :eof\n"
    },
    read = {
      description = "\nread(device, count) when is_integer(count) and count >= 0 \n\nread(device, :line)\n@spec read(device, :all | :line | non_neg_integer) :: chardata | nodata\n  \nread(device, :all)\n\n  Reads from the IO `device`.\n\n  The `device` is iterated by the given number of characters or line by line if\n  `:line` is given.\n  Alternatively, if `:all` is given, then whole `device` is returned.\n\n  It returns:\n\n    * `data` - the output characters\n\n    * `:eof` - end of file was encountered\n\n    * `{:error, reason}` - other (rare) error condition;\n      for instance, `{:error, :estale}` if reading from an\n      NFS volume\n\n  If `:all` is given, `:eof` is never returned, but an\n  empty string in case the device has reached EOF.\n  "
    },
    warn = {
      description = "@spec warn(chardata | String.Chars.t, Exception.stacktrace) :: :ok\n  \nwarn(message, stacktrace) when is_list(stacktrace) \n\n  Writes a `message` to stderr, along with the given `stacktrace`.\n\n  This function also notifies the compiler a warning was printed\n  (in case --warnings-as-errors was enabled). It returns `:ok`\n  if it succeeds.\n\n  An empty list can be passed to avoid stacktrace printing.\n\n  ## Examples\n\n      stacktrace = [{MyApp, :main, 1, [file: 'my_app.ex', line: 4]}]\n      IO.warn \"variable bar is unused\", stacktrace\n      #=> warning: variable bar is unused\n      #=>   my_app.ex:4: MyApp.main/1\n\n  "
    }
  },
  Inspect = {
    Algebra = {
      description = "\n  A set of functions for creating and manipulating algebra\n  documents.\n\n  This module implements the functionality described in\n  [\"Strictly Pretty\" (2000) by Christian Lindig][0] with small\n  additions, like support for String nodes, and a custom\n  rendering function that maximises horizontal space use.\n\n      iex> Inspect.Algebra.empty\n      :doc_nil\n\n      iex> \"foo\"\n      \"foo\"\n\n  With the functions in this module, we can concatenate different\n  elements together and render them:\n\n      iex> doc = Inspect.Algebra.concat(Inspect.Algebra.empty, \"foo\")\n      iex> Inspect.Algebra.format(doc, 80)\n      [\"foo\"]\n\n  The functions `nest/2`, `space/2` and `line/2` help you put the\n  document together into a rigid structure. However, the document\n  algebra gets interesting when using functions like `break/1`, which\n  converts the given string into a line break depending on how much space\n  there is to print. Let's glue two docs together with a break and then\n  render it:\n\n      iex> doc = Inspect.Algebra.glue(\"a\", \" \", \"b\")\n      iex> Inspect.Algebra.format(doc, 80)\n      [\"a\", \" \", \"b\"]\n\n  Notice the break was represented as is, because we haven't reached\n  a line limit. Once we do, it is replaced by a newline:\n\n      iex> doc = Inspect.Algebra.glue(String.duplicate(\"a\", 20), \" \", \"b\")\n      iex> Inspect.Algebra.format(doc, 10)\n      [\"aaaaaaaaaaaaaaaaaaaa\", \"\\n\", \"b\"]\n\n  Finally, this module also contains Elixir related functions, a bit\n  tied to Elixir formatting, namely `surround/3` and `surround_many/5`.\n\n  ## Implementation details\n\n  The original Haskell implementation of the algorithm by [Wadler][1]\n  relies on lazy evaluation to unfold document groups on two alternatives:\n  `:flat` (breaks as spaces) and `:break` (breaks as newlines).\n  Implementing the same logic in a strict language such as Elixir leads\n  to an exponential growth of possible documents, unless document groups\n  are encoded explicitly as `:flat` or `:break`. Those groups are then reduced\n  to a simple document, where the layout is already decided, per [Lindig][0].\n\n  This implementation slightly changes the semantic of Lindig's algorithm\n  to allow elements that belong to the same group to be printed together\n  in the same line, even if they do not fit the line fully. This was achieved\n  by changing `:break` to mean a possible break and `:flat` to force a flat\n  structure. Then deciding if a break works as a newline is just a matter\n  of checking if we have enough space until the next break that is not\n  inside a group (which is still flat).\n\n  Custom pretty printers can be implemented using the documents returned\n  by this module and by providing their own rendering functions.\n\n    [0]: http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.34.2200\n    [1]: http://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf\n\n  ",
      fold_doc = {
        description = "\nfold_doc([doc | docs], folder_fun) when is_function(folder_fun, 2),\n    \n\nfold_doc([doc], _folder_fun)\n@spec fold_doc([t], ((t, t) -> t)) :: t\n  \nfold_doc([], _folder_fun)\n\n  Folds a list of documents into a document using the given folder function.\n\n  The list of documents is folded \"from the right\"; in that, this function is\n  similar to `List.foldr/3`, except that it doesn't expect an initial\n  accumulator and uses the last element of `docs` as the initial accumulator.\n\n  ## Examples\n\n      iex> docs = [\"A\", \"B\", \"C\"]\n      iex> docs = Inspect.Algebra.fold_doc(docs, fn(doc, acc) ->\n      ...>   Inspect.Algebra.concat([doc, \"!\", acc])\n      ...> end)\n      iex> Inspect.Algebra.format(docs, 80)\n      [\"A\", \"!\", \"B\", \"!\", \"C\"]\n\n  "
      },
      nest = {
        description = "\nnest(doc, level) when is_\n@spec nest(t, non_neg_integer) :: doc_nest\n  \nnest(doc, 0) when is_\n\n  Nests the given document at the given `level`.\n\n  Nesting will be appended to the line breaks.\n\n  ## Examples\n\n      iex> doc = Inspect.Algebra.nest(Inspect.Algebra.glue(\"hello\", \"world\"), 5)\n      iex> Inspect.Algebra.format(doc, 5)\n      [\"hello\", \"\\n     \", \"world\"]\n\n  "
      },
      t = {
        description = "t :: :doc_nil | :doc_line | doc_cons | doc_nest | doc_break | doc_group | doc_color | binary\n"
      },
      to_doc = {
        description = "\nto_doc(arg, %Inspect.Opts{} = opts)\n@spec to_doc(any, Inspect.Opts.t) :: t\n  \nto_doc(%{__struct__: struct} = map, %Inspect.Opts{} = opts) when is_atom(struct) \n\n  Converts an Elixir term to an algebra document\n  according to the `Inspect` protocol.\n  "
      }
    },
    Error = {
      description = "\n  Raised when a struct cannot be inspected.\n  "
    },
    Opts = {
      color_key = {
        description = "color_key :: atom\n"
      },
      description = "\n  Defines the Inspect.Opts used by the Inspect protocol.\n\n  The following fields are available:\n\n    * `:structs` - when `false`, structs are not formatted by the inspect\n      protocol, they are instead printed as maps, defaults to `true`.\n\n    * `:binaries` - when `:as_strings` all binaries will be printed as strings,\n      non-printable bytes will be escaped.\n\n      When `:as_binaries` all binaries will be printed in bit syntax.\n\n      When the default `:infer`, the binary will be printed as a string if it\n      is printable, otherwise in bit syntax.\n\n    * `:charlists` - when `:as_charlists` all lists will be printed as char\n      lists, non-printable elements will be escaped.\n\n      When `:as_lists` all lists will be printed as lists.\n\n      When the default `:infer`, the list will be printed as a charlist if it\n      is printable, otherwise as list.\n\n    * `:limit` - limits the number of items that are printed for tuples,\n      bitstrings, maps, lists and any other collection of items. It does not\n      apply to strings nor charlists and defaults to 50.\n\n    * `:pretty` - if set to `true` enables pretty printing, defaults to `false`.\n\n    * `:width` - defaults to 80 characters, used when pretty is `true` or when\n      printing to IO devices. Set to 0 to force each item to be printed on its\n      own line.\n\n    * `:base` - prints integers as `:binary`, `:octal`, `:decimal`, or `:hex`, defaults\n      to `:decimal`. When inspecting binaries any `:base` other than `:decimal`\n      implies `binaries: :as_binaries`.\n\n    * `:safe` - when `false`, failures while inspecting structs will be raised\n      as errors instead of being wrapped in the `Inspect.Error` exception. This\n      is useful when debugging failures and crashes for custom inspect\n      implementations\n\n    * `:syntax_colors` - when set to a keyword list of colors the output will\n      be colorized. The keys are types and the values are the colors to use for\n      each type. e.g. `[number: :red, atom: :blue]`. Types can include\n      `:number`, `:atom`, `regex`, `:tuple`, `:map`, `:list`, and `:reset`.\n      Colors can be any `t:IO.ANSI.ansidata/0` as accepted by `IO.ANSI.format/1`.\n  ",
      t = {
        description = "t :: %__MODULE__{\n"
      }
    },
    description = "\n  The `Inspect` protocol is responsible for converting any Elixir\n  data structure into an algebra document. This document is then\n  formatted, either in pretty printing format or a regular one.\n\n  The `inspect/2` function receives the entity to be inspected\n  followed by the inspecting options, represented by the struct\n  `Inspect.Opts`.\n\n  Inspection is done using the functions available in `Inspect.Algebra`.\n\n  ## Examples\n\n  Many times, inspecting a structure can be implemented in function\n  of existing entities. For example, here is `MapSet`'s `inspect`\n  implementation:\n\n      defimpl Inspect, for: MapSet do\n        import Inspect.Algebra\n\n        def inspect(dict, opts) do\n          concat [\"#MapSet<\", to_doc(MapSet.to_list(dict), opts), \">\"]\n        end\n      end\n\n  The `concat/1` function comes from `Inspect.Algebra` and it\n  concatenates algebra documents together. In the example above,\n  it is concatenating the string `\"MapSet<\"` (all strings are\n  valid algebra documents that keep their formatting when pretty\n  printed), the document returned by `Inspect.Algebra.to_doc/2` and the\n  other string `\">\"`.\n\n  Since regular strings are valid entities in an algebra document,\n  an implementation of inspect may simply return a string,\n  although that will devoid it of any pretty-printing.\n\n  ## Error handling\n\n  In case there is an error while your structure is being inspected,\n  Elixir will raise an `ArgumentError` error and will automatically fall back\n  to a raw representation for printing the structure.\n\n  You can however access the underlying error by invoking the Inspect\n  implementation directly. For example, to test Inspect.MapSet above,\n  you can invoke it as:\n\n      Inspect.MapSet.inspect(MapSet.new, %Inspect.Opts{})\n\n  ",
    escape = {
      description = "\nescape(other, char)false\n\nescape(binary)\n"
    },
    escape_char = {
      description = "\nescape_char(char) when char < 0x1000000 \n\nescape_char(char) when char < 0x10000 \n\nescape_char(char) when char < 0x100 \n\nescape_char(0)\nfalse"
    },
    escape_name = {
      description = "\nescape_name(name) when is_binary(name) \n\nescape_name(name) when is_atom(name) \n"
    },
    extract_anonymous_fun_parent = {
      description = "\nextract_anonymous_fun_parent(other) when is_binary(other), \n\nextract_anonymous_fun_parent(\"-\" <> rest)\n"
    },
    inspect = {
      description = "\ninspect(%{__struct__: struct} = map, opts)\n\ninspect(ref, _opts)\n\ninspect(port, _opts)\n\ninspect(pid, _opts)\n\ninspect(function, _opts)\n\ninspect(regex, opts)\n\ninspect(term, opts)\n\ninspect(term, %Inspect.Opts{base: base} = opts)\n\ninspect(map, name, opts)\n\ninspect(map, opts)\n\ninspect(tuple, opts)\n\ninspect(term, %Inspect.Opts{charlists: lists, char_lists: lists_deprecated} = opts)\n\ninspect([], opts)\n\ninspect(term, opts)\n\ninspect(term, %Inspect.Opts{binaries: bins, base: base} = opts) when is_binary(term) \n\ninspect(atom)\n\ninspect(atom) when is_nil(atom) or is_boolean(atom) \n\ninspect(atom, opts)\n\ninspect(term, opts)\n"
    },
    keyword = {
      description = "\nkeyword({key, value}, opts)\nfalse"
    },
    ["keyword?"] = {
      description = "\nkeyword?(_other)\n\nkeyword?([])\n\nkeyword?([{key, _value} | rest]) when is_atom(key) \nfalse"
    },
    ["printable?"] = {
      description = "\nprintable?(_)\n\nprintable?([])\n\nprintable?([?\\a | rest])\n\nprintable?([?\\e | rest])\n\nprintable?([?\\f | rest])\n\nprintable?([?\\b | rest])\n\nprintable?([?\\v | rest])\n\nprintable?([?\\t | rest])\n\nprintable?([?\\r | rest])\n\nprintable?([?\\n | rest])\n\nprintable?([char | rest]) when char in 32..126, \nfalse"
    }
  },
  Integer = {
    description = "\n  Functions for working with integers.\n  ",
    is_even = {
      description = "\nis_even(integer)\n\n  Determines if an `integer` is even.\n\n  Returns `true` if the given `integer` is an even number,\n  otherwise it returns `false`.\n\n  Allowed in guard clauses.\n\n  ## Examples\n\n      iex> Integer.is_even(10)\n      true\n\n      iex> Integer.is_even(5)\n      false\n\n      iex> Integer.is_even(-10)\n      true\n\n      iex> Integer.is_even(0)\n      true\n\n  "
    },
    is_odd = {
      description = "\nis_odd(integer)\n\n  Determines if `integer` is odd.\n\n  Returns `true` if the given `integer` is an odd number,\n  otherwise it returns `false`.\n\n  Allowed in guard clauses.\n\n  ## Examples\n\n      iex> Integer.is_odd(5)\n      true\n\n      iex> Integer.is_odd(6)\n      false\n\n      iex> Integer.is_odd(-5)\n      true\n\n      iex> Integer.is_odd(0)\n      false\n\n  "
    },
    parse = {
      description = "\nparse(binary, base) when is_binary(binary) \n\nparse(binary, base) when is_binary(binary) and base in 2..36 \n@spec parse(binary, 2..36) :: {integer, binary} | :error | no_return\n  \nparse(\"\", base) when base in 2..36,\n    \n\n  Parses a text representation of an integer.\n\n  An optional `base` to the corresponding integer can be provided.\n  If `base` is not given, 10 will be used.\n\n  If successful, returns a tuple in the form of `{integer, remainder_of_binary}`.\n  Otherwise `:error`.\n\n  Raises an error if `base` is less than 2 or more than 36.\n\n  If you want to convert a string-formatted integer directly to a integer,\n  `String.to_integer/1` or `String.to_integer/2` can be used instead.\n\n  ## Examples\n\n      iex> Integer.parse(\"34\")\n      {34, \"\"}\n\n      iex> Integer.parse(\"34.5\")\n      {34, \".5\"}\n\n      iex> Integer.parse(\"three\")\n      :error\n\n      iex> Integer.parse(\"34\", 10)\n      {34, \"\"}\n\n      iex> Integer.parse(\"f4\", 16)\n      {244, \"\"}\n\n      iex> Integer.parse(\"Awww++\", 36)\n      {509216, \"++\"}\n\n      iex> Integer.parse(\"fab\", 10)\n      :error\n\n      iex> Integer.parse(\"a2\", 38)\n      ** (ArgumentError) invalid base 38\n\n  "
    }
  },
  InvalidRequirementError = {},
  InvalidVersionError = {
    ["match?"] = {
      description = "\nmatch?(version, %Requirement{matchspec: spec, compiled: true}, opts)\n\nmatch?(version, %Requirement{matchspec: spec, compiled: false}, opts)\n@spec match?(version, requirement, Keyword.t) :: boolean\n  \nmatch?(version, requirement, opts) when is_binary(requirement) \n\n  Checks if the given version matches the specification.\n\n  Returns `true` if `version` satisfies `requirement`, `false` otherwise.\n  Raises a `Version.InvalidRequirementError` exception if `requirement` is not\n  parsable, or `Version.InvalidVersionError` if `version` is not parsable.\n  If given an already parsed version and requirement this function won't\n  raise.\n\n  ## Options\n\n    * `:allow_pre` - when `false` pre-release versions will not match\n      unless the operand is a pre-release version, see the table above\n      for examples  (default: `true`);\n\n  ## Examples\n\n      iex> Version.match?(\"2.0.0\", \">1.0.0\")\n      true\n\n      iex> Version.match?(\"2.0.0\", \"==1.0.0\")\n      false\n\n      iex> Version.match?(\"foo\", \"==1.0.0\")\n      ** (Version.InvalidVersionError) foo\n\n      iex> Version.match?(\"2.0.0\", \"== ==1.0.0\")\n      ** (Version.InvalidRequirementError) == ==1.0.0\n\n  "
    }
  },
  Kernel = {
    CLI = nil,
    ErrorHandler = nil,
    LexicalTracker = {
      add_alias = {
        description = "\nadd_alias(pid, module, line, warn) when is_atom(module) \nfalse"
      },
      add_import = {
        description = "\nadd_import(pid, module, fas, line, warn) when is_atom(module) \nfalse"
      },
      alias_dispatch = {
        description = "\nalias_dispatch(pid, module) when is_atom(module) \nfalse"
      },
      code_change = {
        description = "\ncode_change(_old, state, _extra)\nfalse"
      },
      collect_unused_aliases = {
        description = "\ncollect_unused_aliases(pid)\nfalse"
      },
      collect_unused_imports = {
        description = "\ncollect_unused_imports(pid)\nfalse"
      },
      description = "false",
      dest = {
        description = "\ndest(arg)\n\n  Gets the destination the lexical scope is meant to\n  compile to.\n  "
      },
      handle_call = {
        description = "\nhandle_call(:dest, _from, state)\n\nhandle_call(:remote_dispatches, _from, state)\n\nhandle_call(:remote_references, _from, state)\n\nhandle_call({:unused, tag}, _from, state)\nfalse"
      },
      handle_cast = {
        description = "\nhandle_cast(:stop, state)\n\nhandle_cast({:add_alias, module, line, warn}, state)\n\nhandle_cast({:add_import, module, fas, line, warn}, state)\n\nhandle_cast({:alias_dispatch, module}, state)\n\nhandle_cast({:import_dispatch, module, {function, arity} = fa, line, mode}, state)\n\nhandle_cast({:remote_dispatch, module, fa, line, mode}, state)\n\nhandle_cast({:remote_reference, module, mode}, state)\n"
      },
      handle_info = {
        description = "\nhandle_info(_msg, state)\nfalse"
      },
      import_dispatch = {
        description = "\nimport_dispatch(pid, module, fa, line, mode) when is_atom(module) \nfalse"
      },
      init = {
        description = "\ninit(dest)\n"
      },
      remote_dispatch = {
        description = "\nremote_dispatch(pid, module, fa, line, mode) when is_atom(module) \nfalse"
      },
      remote_dispatches = {
        description = "\nremote_dispatches(arg)\n\n  Returns all remote dispatches in this lexical scope.\n  "
      },
      remote_reference = {
        description = "\nremote_reference(pid, module, mode) when is_atom(module) \nfalse"
      },
      remote_references = {
        description = "\nremote_references(arg)\n\n  Returns all remotes referenced in this lexical scope.\n  "
      },
      start_link = {
        description = "\nstart_link(dest)\nfalse"
      },
      stop = {
        description = "\nstop(pid)\nfalse"
      },
      terminate = {
        description = "\nterminate(_reason, _state)\nfalse"
      }
    },
    ParallelCompiler = {
      description = "\n  A module responsible for compiling files in parallel.\n  ",
      files = {
        description = "\nfiles(files, options) when is_list(options) \n\nfiles(files, options \\\\ [])\n\n  Compiles the given files.\n\n  Those files are compiled in parallel and can automatically\n  detect dependencies between them. Once a dependency is found,\n  the current file stops being compiled until the dependency is\n  resolved.\n\n  If there is an error during compilation or if `warnings_as_errors`\n  is set to `true` and there is a warning, this function will fail\n  with an exception.\n\n  This function accepts the following options:\n\n    * `:each_file` - for each file compiled, invokes the callback passing the\n      file\n\n    * `:each_long_compilation` - for each file that takes more than a given\n      timeout (see the `:long_compilation_threshold` option) to compile, invoke\n      this callback passing the file as its argument\n\n    * `:long_compilation_threshold` - the timeout (in seconds) after the\n      `:each_long_compilation` callback is invoked; defaults to `10`\n\n    * `:each_module` - for each module compiled, invokes the callback passing\n      the file, module and the module bytecode\n\n    * `:dest` - the destination directory for the BEAM files. When using `files/2`,\n      this information is only used to properly annotate the BEAM files before\n      they are loaded into memory. If you want a file to actually be written to\n      `dest`, use `files_to_path/3` instead.\n\n  Returns the modules generated by each compiled file.\n  "
      },
      files_to_path = {
        description = "\nfiles_to_path(files, path, options) when is_binary(path) and is_list(options) \n\nfiles_to_path(files, path, options \\\\ [])\n\n  Compiles the given files to the given path.\n  Read `files/2` for more information.\n  "
      }
    },
    ParallelRequire = {
      description = "\n  A module responsible for requiring files in parallel.\n  ",
      files = {
        description = "\nfiles(files, callbacks) when is_list(callbacks) \n\nfiles(files, callback) when is_function(callback, 1) \n\nfiles(files, callbacks \\\\ [])\n\n  Requires the given files.\n\n  A callback that will be invoked with each file, or a keyword list of `callbacks` can be provided:\n\n    * `:each_file` - invoked with each file\n\n    * `:each_module` - invoked with file, module name, and binary code\n\n  Returns the modules generated by each required file.\n  "
      }
    },
    SpecialForms = {
      __CALLER__ = {
        description = "\n__CALLER__\n\n  Returns the current calling environment as a `Macro.Env` struct.\n\n  In the environment you can access the filename, line numbers,\n  set up aliases, the function and others.\n  "
      },
      __DIR__ = {
        description = "\n__DIR__\n\n  Returns the absolute path of the directory of the current file as a binary.\n\n  Although the directory can be accessed as `Path.dirname(__ENV__.file)`,\n  this macro is a convenient shortcut.\n  "
      },
      __ENV__ = {
        description = "\n__ENV__\n\n  Returns the current environment information as a `Macro.Env` struct.\n\n  In the environment you can access the current filename,\n  line numbers, set up aliases, the current function and others.\n  "
      },
      __MODULE__ = {
        description = "\n__MODULE__\n\n  Returns the current module name as an atom or `nil` otherwise.\n\n  Although the module can be accessed in the `__ENV__/0`, this macro\n  is a convenient shortcut.\n  "
      },
      __aliases__ = {
        description = "\n__aliases__(args)\n\n  Internal special form to hold aliases information.\n\n  It is usually compiled to an atom:\n\n      iex> quote do\n      ...>   Foo.Bar\n      ...> end\n      {:__aliases__, [alias: false], [:Foo, :Bar]}\n\n  Elixir represents `Foo.Bar` as `__aliases__` so calls can be\n  unambiguously identified by the operator `:.`. For example:\n\n      iex> quote do\n      ...>   Foo.bar\n      ...> end\n      {{:., [], [{:__aliases__, [alias: false], [:Foo]}, :bar]}, [], []}\n\n  Whenever an expression iterator sees a `:.` as the tuple key,\n  it can be sure that it represents a call and the second argument\n  in the list is an atom.\n\n  On the other hand, aliases holds some properties:\n\n    1. The head element of aliases can be any term that must expand to\n       an atom at compilation time.\n\n    2. The tail elements of aliases are guaranteed to always be atoms.\n\n    3. When the head element of aliases is the atom `:Elixir`, no expansion happens.\n\n  "
      },
      __block__ = {
        description = "\n__block__(args)\n\n  Internal special form for block expressions.\n\n  This is the special form used whenever we have a block\n  of expressions in Elixir. This special form is private\n  and should not be invoked directly:\n\n      iex> quote do\n      ...>   1\n      ...>   2\n      ...>   3\n      ...> end\n      {:__block__, [], [1, 2, 3]}\n\n  "
      },
      alias = {
        description = "\nalias(module, opts)\n\n  `alias/2` is used to setup aliases, often useful with modules names.\n\n  ## Examples\n\n  `alias/2` can be used to setup an alias for any module:\n\n      defmodule Math do\n        alias MyKeyword, as: Keyword\n      end\n\n  In the example above, we have set up `MyKeyword` to be aliased\n  as `Keyword`. So now, any reference to `Keyword` will be\n  automatically replaced by `MyKeyword`.\n\n  In case one wants to access the original `Keyword`, it can be done\n  by accessing `Elixir`:\n\n      Keyword.values   #=> uses MyKeyword.values\n      Elixir.Keyword.values #=> uses Keyword.values\n\n  Notice that calling `alias` without the `as:` option automatically\n  sets an alias based on the last part of the module. For example:\n\n      alias Foo.Bar.Baz\n\n  Is the same as:\n\n      alias Foo.Bar.Baz, as: Baz\n\n  We can also alias multiple modules in one line:\n\n      alias Foo.{Bar, Baz, Biz}\n\n  Is the same as:\n\n      alias Foo.Bar\n      alias Foo.Baz\n      alias Foo.Biz\n\n  ## Lexical scope\n\n  `import/2`, `require/2` and `alias/2` are called directives and all\n  have lexical scope. This means you can set up aliases inside\n  specific functions and it won't affect the overall scope.\n\n  ## Warnings\n\n  If you alias a module and you don't use the alias, Elixir is\n  going to issue a warning implying the alias is not being used.\n\n  In case the alias is generated automatically by a macro,\n  Elixir won't emit any warnings though, since the alias\n  was not explicitly defined.\n\n  Both warning behaviours could be changed by explicitly\n  setting the `:warn` option to `true` or `false`.\n  "
      },
      case = {
        description = "\ncase(condition, clauses)\n\n  Matches the given expression against the given clauses.\n\n  ## Examples\n\n      case thing do\n        {:selector, i, value} when is_integer(i) ->\n          value\n        value ->\n          value\n      end\n\n  In the example above, we match `thing` against each clause \"head\"\n  and execute the clause \"body\" corresponding to the first clause\n  that matches.\n\n  If no clause matches, an error is raised.\n  For this reason, it may be necessary to add a final catch-all clause (like `_`)\n  which will always match.\n\n      x = 10\n\n      case x do\n        0 ->\n          \"This clause won't match\"\n        _ ->\n          \"This clause would match any value (x = #{x})\"\n      end\n      #=> \"This clause would match any value (x = 10)\"\n\n  ## Variables handling\n\n  Notice that variables bound in a clause \"head\" do not leak to the\n  outer context:\n\n      case data do\n        {:ok, value} -> value\n        :error -> nil\n      end\n\n      value #=> unbound variable value\n\n  However, variables explicitly bound in the clause \"body\" are\n  accessible from the outer context:\n\n      value = 7\n\n      case lucky? do\n        false -> value = 13\n        true  -> true\n      end\n\n      value #=> 7 or 13\n\n  In the example above, value is going to be `7` or `13` depending on\n  the value of `lucky?`. In case `value` has no previous value before\n  case, clauses that do not explicitly bind a value have the variable\n  bound to `nil`.\n\n  If you want to pattern match against an existing variable,\n  you need to use the `^/1` operator:\n\n      x = 1\n\n      case 10 do\n        ^x -> \"Won't match\"\n        _  -> \"Will match\"\n      end\n      #=> \"Will match\"\n\n  "
      },
      cond = {
        description = "\ncond(clauses)\n\n  Evaluates the expression corresponding to the first clause that\n  evaluates to a truthy value.\n\n      cond do\n        hd([1, 2, 3]) ->\n          \"1 is considered as true\"\n      end\n      #=> \"1 is considered as true\"\n\n  Raises an error if all conditions evaluate to `nil` or `false`.\n  For this reason, it may be necessary to add a final always-truthy condition\n  (anything non-`false` and non-`nil`), which will always match.\n\n  ## Examples\n\n      cond do\n        1 + 1 == 1 ->\n          \"This will never match\"\n        2 * 2 != 4 ->\n          \"Nor this\"\n        true ->\n          \"This will\"\n      end\n      #=> \"This will\"\n\n  "
      },
      description = "\n  Special forms are the basic building blocks of Elixir, and therefore\n  cannot be overridden by the developer.\n\n  We define them in this module. Some of these forms are lexical (like\n  `alias/2`, `case/2`, etc). The macros `{}` and `<<>>` are also special\n  forms used to define tuple and binary data structures respectively.\n\n  This module also documents macros that return information about Elixir's\n  compilation environment, such as (`__ENV__/0`, `__MODULE__/0`, `__DIR__/0` and `__CALLER__/0`).\n\n  Finally, it also documents two special forms, `__block__/1` and\n  `__aliases__/1`, which are not intended to be called directly by the\n  developer but they appear in quoted contents since they are essential\n  in Elixir's constructs.\n  ",
      ["for"] = {
        description = "\nfor(args)\n\n  Comprehensions allow you to quickly build a data structure from\n  an enumerable or a bitstring.\n\n  Let's start with an example:\n\n      iex> for n <- [1, 2, 3, 4], do: n * 2\n      [2, 4, 6, 8]\n\n  A comprehension accepts many generators and filters. Enumerable\n  generators are defined using `<-`:\n\n      # A list generator:\n      iex> for n <- [1, 2, 3, 4], do: n * 2\n      [2, 4, 6, 8]\n\n      # A comprehension with two generators\n      iex> for x <- [1, 2], y <- [2, 3], do: x * y\n      [2, 3, 4, 6]\n\n  Filters can also be given:\n\n      # A comprehension with a generator and a filter\n      iex> for n <- [1, 2, 3, 4, 5, 6], rem(n, 2) == 0, do: n\n      [2, 4, 6]\n\n  Note generators can also be used to filter as it removes any value\n  that doesn't match the pattern on the left side of `<-`:\n\n      iex> users = [user: \"john\", admin: \"meg\", guest: \"barbara\"]\n      iex> for {type, name} when type != :guest <- users do\n      ...>   String.upcase(name)\n      ...> end\n      [\"JOHN\", \"MEG\"]\n\n  Bitstring generators are also supported and are very useful when you\n  need to organize bitstring streams:\n\n      iex> pixels = <<213, 45, 132, 64, 76, 32, 76, 0, 0, 234, 32, 15>>\n      iex> for <<r::8, g::8, b::8 <- pixels>>, do: {r, g, b}\n      [{213, 45, 132}, {64, 76, 32}, {76, 0, 0}, {234, 32, 15}]\n\n  Variable assignments inside the comprehension, be it in generators,\n  filters or inside the block, are not reflected outside of the\n  comprehension.\n\n  ## Into\n\n  In the examples above, the result returned by the comprehension was\n  always a list. The returned result can be configured by passing an\n  `:into` option, that accepts any structure as long as it implements\n  the `Collectable` protocol.\n\n  For example, we can use bitstring generators with the `:into` option\n  to easily remove all spaces in a string:\n\n      iex> for <<c <- \" hello world \">>, c != ?\\s, into: \"\", do: <<c>>\n      \"helloworld\"\n\n  The `IO` module provides streams, that are both `Enumerable` and\n  `Collectable`, here is an upcase echo server using comprehensions:\n\n      for line <- IO.stream(:stdio, :line), into: IO.stream(:stdio, :line) do\n        String.upcase(line)\n      end\n\n  "
      },
      import = {
        description = "\nimport(module, opts)\n\n  Imports functions and macros from other modules.\n\n  `import/2` allows one to easily access functions or macros from\n  others modules without using the qualified name.\n\n  ## Examples\n\n  If you are using several functions from a given module, you can\n  import those functions and reference them as local functions,\n  for example:\n\n      iex> import List\n      iex> flatten([1, [2], 3])\n      [1, 2, 3]\n\n  ## Selector\n\n  By default, Elixir imports functions and macros from the given\n  module, except the ones starting with underscore (which are\n  usually callbacks):\n\n      import List\n\n  A developer can filter to import only macros or functions via\n  the only option:\n\n      import List, only: :functions\n      import List, only: :macros\n\n  Alternatively, Elixir allows a developer to pass pairs of\n  name/arities to `:only` or `:except` as a fine grained control\n  on what to import (or not):\n\n      import List, only: [flatten: 1]\n      import String, except: [split: 2]\n\n  Notice that calling `except` for a previously declared `import/2`\n  simply filters the previously imported elements. For example:\n\n      import List, only: [flatten: 1, keyfind: 4]\n      import List, except: [flatten: 1]\n\n  After the two import calls above, only `List.keyfind/4` will be\n  imported.\n\n  ## Underscore functions\n\n  By default functions starting with `_` are not imported. If you really want\n  to import a function starting with `_` you must explicitly include it in the\n  `:only` selector.\n\n      import File.Stream, only: [__build__: 3]\n\n  ## Lexical scope\n\n  It is important to notice that `import/2` is lexical. This means you\n  can import specific macros inside specific functions:\n\n      defmodule Math do\n        def some_function do\n          # 1) Disable \"if/2\" from Kernel\n          import Kernel, except: [if: 2]\n\n          # 2) Require the new \"if/2\" macro from MyMacros\n          import MyMacros\n\n          # 3) Use the new macro\n          if do_something, it_works\n        end\n      end\n\n  In the example above, we imported macros from `MyMacros`,\n  replacing the original `if/2` implementation by our own\n  within that specific function. All other functions in that\n  module will still be able to use the original one.\n\n  ## Warnings\n\n  If you import a module and you don't use any of the imported\n  functions or macros from this module, Elixir is going to issue\n  a warning implying the import is not being used.\n\n  In case the import is generated automatically by a macro,\n  Elixir won't emit any warnings though, since the import\n  was not explicitly defined.\n\n  Both warning behaviours could be changed by explicitly\n  setting the `:warn` option to `true` or `false`.\n\n  ## Ambiguous function/macro names\n\n  If two modules `A` and `B` are imported and they both contain\n  a `foo` function with an arity of `1`, an error is only emitted\n  if an ambiguous call to `foo/1` is actually made; that is, the\n  errors are emitted lazily, not eagerly.\n  "
      },
      quote = {
        description = "\nquote(opts, block)\n\n  Gets the representation of any expression.\n\n  ## Examples\n\n      iex> quote do\n      ...>   sum(1, 2, 3)\n      ...> end\n      {:sum, [], [1, 2, 3]}\n\n  ## Explanation\n\n  Any Elixir code can be represented using Elixir data structures.\n  The building block of Elixir macros is a tuple with three elements,\n  for example:\n\n      {:sum, [], [1, 2, 3]}\n\n  The tuple above represents a function call to `sum` passing 1, 2 and\n  3 as arguments. The tuple elements are:\n\n    * The first element of the tuple is always an atom or\n      another tuple in the same representation.\n\n    * The second element of the tuple represents metadata.\n\n    * The third element of the tuple are the arguments for the\n      function call. The third argument may be an atom, which is\n      usually a variable (or a local call).\n\n  ## Options\n\n    * `:unquote` - when `false`, disables unquoting. Useful when you have a quote\n      inside another quote and want to control what quote is able to unquote.\n\n    * `:location` - when set to `:keep`, keeps the current line and file from\n      quote. Read the Stacktrace information section below for more\n      information.\n\n    * `:generated` - marks the given chunk as generated so it does not emit warnings.\n      Currently it only works on special forms (for example, you can annotate a `case`\n      but not an `if`).\n\n    * `:context` - sets the resolution context.\n\n    * `:bind_quoted` - passes a binding to the macro. Whenever a binding is\n      given, `unquote/1` is automatically disabled.\n\n  ## Quote literals\n\n  Besides the tuple described above, Elixir has a few literals that\n  when quoted return themselves. They are:\n\n      :sum         #=> Atoms\n      1            #=> Integers\n      2.0          #=> Floats\n      [1, 2]       #=> Lists\n      \"strings\"    #=> Strings\n      {key, value} #=> Tuples with two elements\n\n  ## Quote and macros\n\n  `quote/2` is commonly used with macros for code generation. As an exercise,\n  let's define a macro that multiplies a number by itself (squared). Note\n  there is no reason to define such as a macro (and it would actually be\n  seen as a bad practice), but it is simple enough that it allows us to focus\n  on the important aspects of quotes and macros:\n\n      defmodule Math do\n        defmacro squared(x) do\n          quote do\n            unquote(x) * unquote(x)\n          end\n        end\n      end\n\n  We can invoke it as:\n\n      import Math\n      IO.puts \"Got #{squared(5)}\"\n\n  At first, there is nothing in this example that actually reveals it is a\n  macro. But what is happening is that, at compilation time, `squared(5)`\n  becomes `5 * 5`. The argument `5` is duplicated in the produced code, we\n  can see this behaviour in practice though because our macro actually has\n  a bug:\n\n      import Math\n      my_number = fn ->\n        IO.puts \"Returning 5\"\n        5\n      end\n      IO.puts \"Got #{squared(my_number.())}\"\n\n  The example above will print:\n\n      Returning 5\n      Returning 5\n      Got 25\n\n  Notice how \"Returning 5\" was printed twice, instead of just once. This is\n  because a macro receives an expression and not a value (which is what we\n  would expect in a regular function). This means that:\n\n      squared(my_number.())\n\n  Actually expands to:\n\n      my_number.() * my_number.()\n\n  Which invokes the function twice, explaining why we get the printed value\n  twice! In the majority of the cases, this is actually unexpected behaviour,\n  and that's why one of the first things you need to keep in mind when it\n  comes to macros is to **not unquote the same value more than once**.\n\n  Let's fix our macro:\n\n      defmodule Math do\n        defmacro squared(x) do\n          quote do\n            x = unquote(x)\n            x * x\n          end\n        end\n      end\n\n  Now invoking `square(my_number.())` as before will print the value just\n  once.\n\n  In fact, this pattern is so common that most of the times you will want\n  to use the `bind_quoted` option with `quote/2`:\n\n      defmodule Math do\n        defmacro squared(x) do\n          quote bind_quoted: [x: x] do\n            x * x\n          end\n        end\n      end\n\n  `:bind_quoted` will translate to the same code as the example above.\n  `:bind_quoted` can be used in many cases and is seen as good practice,\n  not only because it helps us from running into common mistakes but also\n  because it allows us to leverage other tools exposed by macros, such as\n  unquote fragments discussed in some sections below.\n\n  Before we finish this brief introduction, you will notice that, even though\n  we defined a variable `x` inside our quote:\n\n      quote do\n        x = unquote(x)\n        x * x\n      end\n\n  When we call:\n\n      import Math\n      squared(5)\n      x #=> ** (CompileError) undefined variable x or undefined function x/0\n\n  We can see that `x` did not leak to the user context. This happens\n  because Elixir macros are hygienic, a topic we will discuss at length\n  in the next sections as well.\n\n  ## Hygiene in variables\n\n  Consider the following example:\n\n      defmodule Hygiene do\n        defmacro no_interference do\n          quote do\n            a = 1\n          end\n        end\n      end\n\n      require Hygiene\n\n      a = 10\n      Hygiene.no_interference\n      a #=> 10\n\n  In the example above, `a` returns 10 even if the macro\n  is apparently setting it to 1 because variables defined\n  in the macro do not affect the context the macro is executed in.\n  If you want to set or get a variable in the caller's context, you\n  can do it with the help of the `var!` macro:\n\n      defmodule NoHygiene do\n        defmacro interference do\n          quote do\n            var!(a) = 1\n          end\n        end\n      end\n\n      require NoHygiene\n\n      a = 10\n      NoHygiene.interference\n      a #=> 1\n\n  Note that you cannot even access variables defined in the same\n  module unless you explicitly give it a context:\n\n      defmodule Hygiene do\n        defmacro write do\n          quote do\n            a = 1\n          end\n        end\n\n        defmacro read do\n          quote do\n            a\n          end\n        end\n      end\n\n      Hygiene.write\n      Hygiene.read\n      #=> ** (RuntimeError) undefined variable a or undefined function a/0\n\n  For such, you can explicitly pass the current module scope as\n  argument:\n\n      defmodule ContextHygiene do\n        defmacro write do\n          quote do\n            var!(a, ContextHygiene) = 1\n          end\n        end\n\n        defmacro read do\n          quote do\n            var!(a, ContextHygiene)\n          end\n        end\n      end\n\n      ContextHygiene.write\n      ContextHygiene.read\n      #=> 1\n\n  ## Hygiene in aliases\n\n  Aliases inside quote are hygienic by default.\n  Consider the following example:\n\n      defmodule Hygiene do\n        alias Map, as: M\n\n        defmacro no_interference do\n          quote do\n            M.new\n          end\n        end\n      end\n\n      require Hygiene\n      Hygiene.no_interference #=> %{}\n\n  Notice that, even though the alias `M` is not available\n  in the context the macro is expanded, the code above works\n  because `M` still expands to `Map`.\n\n  Similarly, even if we defined an alias with the same name\n  before invoking a macro, it won't affect the macro's result:\n\n      defmodule Hygiene do\n        alias Map, as: M\n\n        defmacro no_interference do\n          quote do\n            M.new\n          end\n        end\n      end\n\n      require Hygiene\n      alias SomethingElse, as: M\n      Hygiene.no_interference #=> %{}\n\n  In some cases, you want to access an alias or a module defined\n  in the caller. For such, you can use the `alias!` macro:\n\n      defmodule Hygiene do\n        # This will expand to Elixir.Nested.hello\n        defmacro no_interference do\n          quote do\n            Nested.hello\n          end\n        end\n\n        # This will expand to Nested.hello for\n        # whatever is Nested in the caller\n        defmacro interference do\n          quote do\n            alias!(Nested).hello\n          end\n        end\n      end\n\n      defmodule Parent do\n        defmodule Nested do\n          def hello, do: \"world\"\n        end\n\n        require Hygiene\n        Hygiene.no_interference\n        #=> ** (UndefinedFunctionError) ...\n\n        Hygiene.interference\n        #=> \"world\"\n      end\n\n  ## Hygiene in imports\n\n  Similar to aliases, imports in Elixir are hygienic. Consider the\n  following code:\n\n      defmodule Hygiene do\n        defmacrop get_length do\n          quote do\n            length([1, 2, 3])\n          end\n        end\n\n        def return_length do\n          import Kernel, except: [length: 1]\n          get_length\n        end\n      end\n\n      Hygiene.return_length #=> 3\n\n  Notice how `Hygiene.return_length/0` returns `3` even though the `Kernel.length/1`\n  function is not imported. In fact, even if `return_length/0`\n  imported a function with the same name and arity from another\n  module, it wouldn't affect the function result:\n\n      def return_length do\n        import String, only: [length: 1]\n        get_length\n      end\n\n  Calling this new `return_length/0` will still return `3` as result.\n\n  Elixir is smart enough to delay the resolution to the latest\n  possible moment. So, if you call `length([1, 2, 3])` inside quote,\n  but no `length/1` function is available, it is then expanded in\n  the caller:\n\n      defmodule Lazy do\n        defmacrop get_length do\n          import Kernel, except: [length: 1]\n\n          quote do\n            length(\"hello\")\n          end\n        end\n\n        def return_length do\n          import Kernel, except: [length: 1]\n          import String, only: [length: 1]\n          get_length\n        end\n      end\n\n      Lazy.return_length #=> 5\n\n  ## Stacktrace information\n\n  When defining functions via macros, developers have the option of\n  choosing if runtime errors will be reported from the caller or from\n  inside the quote. Let's see an example:\n\n      # adder.ex\n      defmodule Adder do\n        @doc \"Defines a function that adds two numbers\"\n        defmacro defadd do\n          quote location: :keep do\n            def add(a, b), do: a + b\n          end\n        end\n      end\n\n      # sample.ex\n      defmodule Sample do\n        import Adder\n        defadd\n      end\n\n      require Sample\n      Sample.add(:one, :two)\n      #=> ** (ArithmeticError) bad argument in arithmetic expression\n      #=>     adder.ex:5: Sample.add/2\n\n  When using `location: :keep` and invalid arguments are given to\n  `Sample.add/2`, the stacktrace information will point to the file\n  and line inside the quote. Without `location: :keep`, the error is\n  reported to where `defadd` was invoked. Note `location: :keep` affects\n  only definitions inside the quote.\n\n  ## Binding and unquote fragments\n\n  Elixir quote/unquote mechanisms provides a functionality called\n  unquote fragments. Unquote fragments provide an easy way to generate\n  functions on the fly. Consider this example:\n\n      kv = [foo: 1, bar: 2]\n      Enum.each kv, fn {k, v} ->\n        def unquote(k)(), do: unquote(v)\n      end\n\n  In the example above, we have generated the functions `foo/0` and\n  `bar/0` dynamically. Now, imagine that, we want to convert this\n  functionality into a macro:\n\n      defmacro defkv(kv) do\n        Enum.map kv, fn {k, v} ->\n          quote do\n            def unquote(k)(), do: unquote(v)\n          end\n        end\n      end\n\n  We can invoke this macro as:\n\n      defkv [foo: 1, bar: 2]\n\n  However, we can't invoke it as follows:\n\n      kv = [foo: 1, bar: 2]\n      defkv kv\n\n  This is because the macro is expecting its arguments to be a\n  keyword list at **compilation** time. Since in the example above\n  we are passing the representation of the variable `kv`, our\n  code fails.\n\n  This is actually a common pitfall when developing macros. We are\n  assuming a particular shape in the macro. We can work around it\n  by unquoting the variable inside the quoted expression:\n\n      defmacro defkv(kv) do\n        quote do\n          Enum.each unquote(kv), fn {k, v} ->\n            def unquote(k)(), do: unquote(v)\n          end\n        end\n      end\n\n  If you try to run our new macro, you will notice it won't\n  even compile, complaining that the variables `k` and `v`\n  do not exist. This is because of the ambiguity: `unquote(k)`\n  can either be an unquote fragment, as previously, or a regular\n  unquote as in `unquote(kv)`.\n\n  One solution to this problem is to disable unquoting in the\n  macro, however, doing that would make it impossible to inject the\n  `kv` representation into the tree. That's when the `:bind_quoted`\n  option comes to the rescue (again!). By using `:bind_quoted`, we\n  can automatically disable unquoting while still injecting the\n  desired variables into the tree:\n\n      defmacro defkv(kv) do\n        quote bind_quoted: [kv: kv] do\n          Enum.each kv, fn {k, v} ->\n            def unquote(k)(), do: unquote(v)\n          end\n        end\n      end\n\n  In fact, the `:bind_quoted` option is recommended every time\n  one desires to inject a value into the quote.\n  "
      },
      receive = {
        description = "\nreceive(args)\n\n  Checks if there is a message matching the given clauses\n  in the current process mailbox.\n\n  In case there is no such message, the current process hangs\n  until a message arrives or waits until a given timeout value.\n\n  ## Examples\n\n      receive do\n        {:selector, i, value} when is_integer(i) ->\n          value\n        value when is_atom(value) ->\n          value\n        _ ->\n          IO.puts :stderr, \"Unexpected message received\"\n      end\n\n  An optional `after` clause can be given in case the message was not\n  received after the given timeout period, specified in milliseconds:\n\n      receive do\n        {:selector, i, value} when is_integer(i) ->\n          value\n        value when is_atom(value) ->\n          value\n        _ ->\n          IO.puts :stderr, \"Unexpected message received\"\n      after\n        5000 ->\n          IO.puts :stderr, \"No message in 5 seconds\"\n      end\n\n  The `after` clause can be specified even if there are no match clauses.\n  The timeout value given to `after` can be a variable; two special\n  values are allowed:\n\n    * `:infinity` - the process should wait indefinitely for a matching\n      message, this is the same as not using a timeout\n\n    * `0` - if there is no matching message in the mailbox, the timeout\n      will occur immediately\n\n  ## Variables handling\n\n  The `receive/1` special form handles variables exactly as the `case/2`\n  special macro. For more information, check the docs for `case/2`.\n  "
      },
      require = {
        description = "\nrequire(module, opts)\n\n  Requires a given module to be compiled and loaded.\n\n  ## Examples\n\n  Notice that usually modules should not be required before usage,\n  the only exception is if you want to use the macros from a module.\n  In such cases, you need to explicitly require them.\n\n  Let's suppose you created your own `if/2` implementation in the module\n  `MyMacros`. If you want to invoke it, you need to first explicitly\n  require the `MyMacros`:\n\n      defmodule Math do\n        require MyMacros\n        MyMacros.if do_something, it_works\n      end\n\n  An attempt to call a macro that was not loaded will raise an error.\n\n  ## Alias shortcut\n\n  `require/2` also accepts `as:` as an option so it automatically sets\n  up an alias. Please check `alias/2` for more information.\n\n  "
      },
      super = {
        description = "\nsuper(args)\n\n  Calls the overridden function when overriding it with `Kernel.defoverridable/1`.\n\n  See `Kernel.defoverridable/1` for more information and documentation.\n  "
      },
      try = {
        description = "\ntry(args)\n\n  Evaluates the given expressions and handles any error, exit,\n  or throw that may have happened.\n\n  ## Examples\n\n      try do\n        do_something_that_may_fail(some_arg)\n      rescue\n        ArgumentError ->\n          IO.puts \"Invalid argument given\"\n      catch\n        value ->\n          IO.puts \"Caught #{inspect(value)}\"\n      else\n        value ->\n          IO.puts \"Success! The result was #{inspect(value)}\"\n      after\n        IO.puts \"This is printed regardless if it failed or succeed\"\n      end\n\n  The `rescue` clause is used to handle exceptions, while the `catch`\n  clause can be used to catch thrown values and exits.\n  The `else` clause can be used to control flow based on the result of\n  the expression. `catch`, `rescue`, and `else` clauses work based on\n  pattern matching (similar to the `case` special form).\n\n  Note that calls inside `try/1` are not tail recursive since the VM\n  needs to keep the stacktrace in case an exception happens.\n\n  ## `rescue` clauses\n\n  Besides relying on pattern matching, `rescue` clauses provide some\n  conveniences around exceptions that allow one to rescue an\n  exception by its name. All the following formats are valid patterns\n  in `rescue` clauses:\n\n      try do\n        UndefinedModule.undefined_function\n      rescue\n        UndefinedFunctionError -> nil\n      end\n\n      try do\n        UndefinedModule.undefined_function\n      rescue\n        [UndefinedFunctionError] -> nil\n      end\n\n      # rescue and bind to x\n      try do\n        UndefinedModule.undefined_function\n      rescue\n        x in [UndefinedFunctionError] -> nil\n      end\n\n      # rescue all and bind to x\n      try do\n        UndefinedModule.undefined_function\n      rescue\n        x -> nil\n      end\n\n  ## Erlang errors\n\n  Erlang errors are transformed into Elixir ones when rescuing:\n\n      try do\n        :erlang.error(:badarg)\n      rescue\n        ArgumentError -> :ok\n      end\n\n  The most common Erlang errors will be transformed into their\n  Elixir counter-part. Those which are not will be transformed\n  into `ErlangError`:\n\n      try do\n        :erlang.error(:unknown)\n      rescue\n        ErlangError -> :ok\n      end\n\n  In fact, `ErlangError` can be used to rescue any error that is\n  not a proper Elixir error. For example, it can be used to rescue\n  the earlier `:badarg` error too, prior to transformation:\n\n      try do\n        :erlang.error(:badarg)\n      rescue\n        ErlangError -> :ok\n      end\n\n  ## Catching throws and exits\n\n  The `catch` clause can be used to catch thrown values and exits.\n\n      try do\n        exit(:shutdown)\n      catch\n        :exit, :shutdown ->\n          IO.puts \"Exited with shutdown reason\"\n      end\n\n      try do\n        throw(:sample)\n      catch\n        :throw, :sample ->\n          IO.puts \":sample was thrown\"\n      end\n\n  The `catch` clause also supports `:error` alongside `:exit` and `:throw`, as\n  in Erlang, although it is commonly avoided in favor of `raise`/`rescue` control\n  mechanisms. One reason for this is that when catching `:error`, the error is\n  not automatically transformed into an Elixir error:\n\n      try do\n        :erlang.error(:badarg)\n      catch\n        :error, :badarg ->\n          :ok\n      end\n\n  Note that it is possible to match both on the caught value as well as the *kind*\n  of such value:\n\n      try do\n        exit(:shutdown)\n      catch\n        kind, value when kind in [:exit, :throw] ->\n          IO.puts \"Exited with or thrown value #{inspect(value)}\"\n      end\n\n  ## `after` clauses\n\n  An `after` clause allows you to define cleanup logic that will be invoked both\n  when the tried block of code succeeds and also when an error is raised. Note\n  that the process will exit as usually when receiving an exit signal that causes\n  it to exit abruptly and so the `after` clause is not guaranteed to be executed.\n  Luckily, most resources in Elixir (such as open files, ETS tables, ports, sockets,\n  etc.) are linked to or monitor the owning process and will automatically clean\n  themselves up if that process exits.\n\n      File.write!(\"tmp/story.txt\", \"Hello, World\")\n      try do\n        do_something_with(\"tmp/story.txt\")\n      after\n        File.rm(\"tmp/story.txt\")\n      end\n\n  ## `else` clauses\n\n  `else` clauses allow the result of the tried expression to be pattern\n  matched on:\n\n      x = 2\n      try do\n        1 / x\n      rescue\n        ArithmeticError ->\n          :infinity\n      else\n        y when y < 1 and y > -1 ->\n          :small\n        _ ->\n          :large\n      end\n\n  If an `else` clause is not present and no exceptions are raised,\n  the result of the expression will be returned:\n\n      x = 1\n      ^x =\n        try do\n          1 / x\n        rescue\n          ArithmeticError ->\n            :infinity\n        end\n\n  However, when an `else` clause is present but the result of the expression\n  does not match any of the patterns then an exception will be raised. This\n  exception will not be caught by a `catch` or `rescue` in the same `try`:\n\n      x = 1\n      try do\n        try do\n          1 / x\n        rescue\n          # The TryClauseError can not be rescued here:\n          TryClauseError ->\n            :error_a\n        else\n          0 ->\n            :small\n        end\n      rescue\n        # The TryClauseError is rescued here:\n        TryClauseError ->\n          :error_b\n      end\n\n  Similarly, an exception inside an `else` clause is not caught or rescued\n  inside the same `try`:\n\n      try do\n        try do\n          nil\n        catch\n          # The exit(1) call below can not be caught here:\n          :exit, _ ->\n            :exit_a\n        else\n          _ ->\n            exit(1)\n        end\n      catch\n        # The exit is caught here:\n        :exit, _ ->\n          :exit_b\n      end\n\n  This means the VM no longer needs to keep the stacktrace once inside\n  an `else` clause and so tail recursion is possible when using a `try`\n  with a tail call as the final call inside an `else` clause. The same\n  is true for `rescue` and `catch` clauses.\n\n  Only the result of the tried expression falls down to the `else` clause.\n  If the `try` ends up in the `rescue` or `catch` clauses, their result\n  will not fall down to `else`:\n\n      try do\n        throw(:catch_this)\n      catch\n        :throw, :catch_this ->\n          :it_was_caught\n      else\n        # :it_was_caught will not fall down to this \"else\" clause.\n        other ->\n          {:else, other}\n      end\n\n  ## Variable handling\n\n  Since an expression inside `try` may not have been evaluated\n  due to an exception, any variable created inside `try` cannot\n  be accessed externally. For instance:\n\n      try do\n        x = 1\n        do_something_that_may_fail(same_arg)\n        :ok\n      catch\n        _, _ -> :failed\n      end\n\n      x #=> unbound variable \"x\"\n\n  In the example above, `x` cannot be accessed since it was defined\n  inside the `try` clause. A common practice to address this issue\n  is to return the variables defined inside `try`:\n\n      x =\n        try do\n          x = 1\n          do_something_that_may_fail(same_arg)\n          x\n        catch\n          _, _ -> :failed\n        end\n\n  "
      },
      with = {
        description = "\nwith(args)\n\n  Used to combine matching clauses.\n\n  Let's start with an example:\n\n      iex> opts = %{width: 10, height: 15}\n      iex> with {:ok, width} <- Map.fetch(opts, :width),\n      ...>      {:ok, height} <- Map.fetch(opts, :height),\n      ...>      do: {:ok, width * height}\n      {:ok, 150}\n\n  If all clauses match, the `do` block is executed, returning its result.\n  Otherwise the chain is aborted and the non-matched value is returned:\n\n      iex> opts = %{width: 10}\n      iex> with {:ok, width} <- Map.fetch(opts, :width),\n      ...>      {:ok, height} <- Map.fetch(opts, :height),\n      ...>      do: {:ok, width * height}\n      :error\n\n  Guards can be used in patterns as well:\n\n      iex> users = %{\"melany\" => \"guest\", \"bob\" => :admin}\n      iex> with {:ok, role} when not is_binary(role) <- Map.fetch(users, \"bob\"),\n      ...>      do: {:ok, to_string(role)}\n      {:ok, \"admin\"}\n\n  As in `for/1`, variables bound inside `with/1` won't leak;\n  \"bare expressions\" may also be inserted between the clauses:\n\n      iex> width = nil\n      iex> opts = %{width: 10, height: 15}\n      iex> with {:ok, width} <- Map.fetch(opts, :width),\n      ...>      double_width = width * 2,\n      ...>      {:ok, height} <- Map.fetch(opts, :height),\n      ...>      do: {:ok, double_width * height}\n      {:ok, 300}\n      iex> width\n      nil\n\n  An `else` option can be given to modify what is being returned from\n  `with` in the case of a failed match:\n\n      iex> opts = %{width: 10}\n      iex> with {:ok, width} <- Map.fetch(opts, :width),\n      ...>      {:ok, height} <- Map.fetch(opts, :height) do\n      ...>   {:ok, width * height}\n      ...> else\n      ...>   :error ->\n      ...>     {:error, :wrong_data}\n      ...> end\n      {:error, :wrong_data}\n\n  If there is no matching `else` condition, then a `WithClauseError` exception is raised.\n\n  "
      }
    },
    Typespec = {
      beam_typedocs = {
        description = "\nbeam_typedocs(module) when is_atom(module) or is_binary(module) \nfalse"
      },
      defcallback = {
        description = "\ndefcallback(spec)\n\n  Defines a callback.\n  This macro is responsible for handling the attribute `@callback`.\n\n  ## Examples\n\n      @callback add(number, number) :: number\n\n  "
      },
      define_type = {
        description = "\ndefine_type(kind, expr, doc \\\\ nil, env)\n\n  Defines a `type`, `typep` or `opaque` by receiving a typespec expression.\n  "
      },
      defmacrocallback = {
        description = "\ndefmacrocallback(spec)\n\n  Defines a macro callback.\n  This macro is responsible for handling the attribute `@macrocallback`.\n\n  ## Examples\n\n      @macrocallback add(number, number) :: Macro.t\n\n  "
      },
      defopaque = {
        description = "\ndefopaque(type)\n\n  Defines an opaque type.\n  This macro is responsible for handling the attribute `@opaque`.\n\n  ## Examples\n\n      @opaque my_type :: atom\n\n  "
      },
      defoptional_callbacks = {
        description = "\ndefoptional_callbacks(callbacks)\n"
      },
      defspec = {
        description = "\ndefspec(kind, expr, caller)false\n\ndefspec(kind, expr, caller) when kind in [:callback, :macrocallback] false\n\ndefspec(spec)\n\n  Defines a spec.\n  This macro is responsible for handling the attribute `@spec`.\n\n  ## Examples\n\n      @spec add(number, number) :: number\n\n  "
      },
      deftype = {
        description = "\ndeftype(kind, expr, caller)false\n\ndeftype(type)\n\n  Defines a type.\n  This macro is responsible for handling the attribute `@type`.\n\n  ## Examples\n\n      @type my_type :: atom\n\n  "
      },
      deftypep = {
        description = "\ndeftypep(type)\n\n  Defines a private type.\n  This macro is responsible for handling the attribute `@typep`.\n\n  ## Examples\n\n      @typep my_type :: atom\n\n  "
      },
      description = "false",
      spec_to_ast = {
        description = "\nspec_to_ast(name, {:type, line, :bounded_fun, [{:type, _, :fun, [{:type, _, :product, args}, result]}, constraints]})\n      when is_atom(name) \n\nspec_to_ast(name, {:type, line, :fun, []}) when is_atom(name) \n@spec spec_to_ast(atom, tuple) :: {atom, Keyword.t, [Macro.t]}\n  \nspec_to_ast(name, {:type, line, :fun, [{:type, _, :product, args}, result]})\n      when is_atom(name) \n\n  Converts a spec clause back to Elixir AST.\n  "
      },
      spec_to_signature = {
        description = "\nspec_to_signature(other)\n@spec beam_callbacks(module | binary) :: [tuple] | nil\n  \nspec_to_signature({:when, _, [spec, _]})\nfalse"
      },
      translate_spec = {
        description = "\ntranslate_spec(kind, spec, caller)\n\ntranslate_spec(kind, {:when, _meta, [spec, guard]}, caller)\nfalse"
      },
      translate_type = {
        description = "\ntranslate_type(_kind, other, caller)\n\ntranslate_type(kind, {:::, _, [{name, _, args}, definition]}, caller) when is_atom(name) and name != ::: \nfalse"
      },
      type_to_ast = {
        description = "\ntype_to_ast({name, type, args}) when is_atom(name) \n\ntype_to_ast({{:record, record}, fields, args}) when is_atom(record) \n\ntype_to_ast(type)\n\n  Converts a type clause back to Elixir AST.\n  "
      },
      type_to_signature = {
        description = "\ntype_to_signature(_)\n\ntype_to_signature({:::, _, [{name, _, args}, _]}) when is_atom(name),\n    \n\ntype_to_signature({:::, _, [{name, _, context}, _]}) when is_atom(name) and is_atom(context),\n    \nfalse"
      }
    },
    Utils = {
      announce_struct = {
        description = "\nannounce_struct(module)\n\n  Announcing callback for defstruct.\n  "
      },
      defdelegate = {
        description = "\ndefdelegate(fun, opts) when is_list(opts) \n\n  Callback for defdelegate.\n  "
      },
      defstruct = {
        description = "\ndefstruct(module, fields)\n\n  Callback for defstruct.\n  "
      },
      description = "false",
      destructure = {
        description = "\ndestructure(nil, count) when is_integer(count) and count >= 0,\n    \n\ndestructure(list, count) when is_list(list) and is_integer(count) and count >= 0,\n    \n\n  Callback for destructure.\n  "
      },
      raise = {
        description = "\nraise(other)\n\nraise(%{__struct__: struct, __exception__: true} = exception) when is_atom(struct) \n\nraise(atom) when is_atom(atom) \n\nraise(msg) when is_binary(msg) \n\n  Callback for raise.\n  "
      }
    },
    __struct__ = {
      description = "\n__struct__(kv)\n\n__struct__(kv)\n"
    },
    ["alias!"] = {
      description = "\nalias!({:__aliases__, meta, args})\n\nalias!(alias) when is_atom(alias) \n\n  When used inside quoting, marks that the given alias should not\n  be hygienized. This means the alias will be expanded when\n  the macro is expanded.\n\n  Check `Kernel.SpecialForms.quote/2` for more information.\n  "
    },
    binding = {
      description = "\nbinding(context \\\\ nil)\n\n  Returns the binding for the given context as a keyword list.\n\n  In the returned result, keys are variable names and values are the\n  corresponding variable values.\n\n  If the given `context` is `nil` (by default it is), the binding for the\n  current context is returned.\n\n  ## Examples\n\n      iex> x = 1\n      iex> binding()\n      [x: 1]\n      iex> x = 2\n      iex> binding()\n      [x: 2]\n\n      iex> binding(:foo)\n      []\n      iex> var!(x, :foo) = 1\n      1\n      iex> binding(:foo)\n      [x: 1]\n\n  "
    },
    def = {
      description = "\ndef(call, expr \\\\ nil)\n\n  Defines a function with the given name and body.\n\n  ## Examples\n\n      defmodule Foo do\n        def bar, do: :baz\n      end\n\n      Foo.bar #=> :baz\n\n  A function that expects arguments can be defined as follows:\n\n      defmodule Foo do\n        def sum(a, b) do\n          a + b\n        end\n      end\n\n  In the example above, a `sum/2` function is defined; this function receives\n  two arguments and returns their sum.\n\n  ## Function and variable names\n\n  Function and variable names have the following syntax:\n  A _lowercase ASCII letter_ or an _underscore_, followed by any number of\n  _lowercase or uppercase ASCII letters_, _numbers_, or _underscores_.\n  Optionally they can end in either an _exclamation mark_ or a _question mark_.\n\n  For variables, any identifier starting with an underscore should indicate an\n  unused variable. For example:\n\n      def foo(bar) do\n        []\n      end\n      #=> warning: variable bar is unused\n\n      def foo(_bar) do\n        []\n      end\n      #=> no warning\n\n      def foo(_bar) do\n        _bar\n      end\n      #=> warning: the underscored variable \"_bar\" is used after being set\n\n  ## rescue/catch/after\n\n  Function bodies support `rescue`, `catch` and `after` as `SpecialForms.try/1`\n  does. The following two functions are equivalent:\n\n      def format(value) do\n        try do\n          format!(value)\n        catch\n          :exit, reason -> {:error, reason}\n        end\n      end\n\n      def format(value) do\n        format!(value)\n      catch\n        :exit, reason -> {:error, reason}\n      end\n\n  "
    },
    defdelegate = {
      description = "\ndefdelegate(funs, opts)\n\n  Defines a function that delegates to another module.\n\n  Functions defined with `defdelegate/2` are public and can be invoked from\n  outside the module they're defined in (like if they were defined using\n  `def/2`). When the desire is to delegate as private functions, `import/2` should\n  be used.\n\n  Delegation only works with functions; delegating macros is not supported.\n\n  ## Options\n\n    * `:to` - the module to dispatch to.\n\n    * `:as` - the function to call on the target given in `:to`.\n      This parameter is optional and defaults to the name being\n      delegated (`funs`).\n\n  ## Examples\n\n      defmodule MyList do\n        defdelegate reverse(list), to: :lists\n        defdelegate other_reverse(list), to: :lists, as: :reverse\n      end\n\n      MyList.reverse([1, 2, 3])\n      #=> [3, 2, 1]\n\n      MyList.other_reverse([1, 2, 3])\n      #=> [3, 2, 1]\n\n  "
    },
    defexception = {
      description = "\ndefexception(fields)\n\n  Defines an exception.\n\n  Exceptions are structs backed by a module that implements\n  the `Exception` behaviour. The `Exception` behaviour requires\n  two functions to be implemented:\n\n    * `exception/1` - receives the arguments given to `raise/2`\n      and returns the exception struct. The default implementation\n      accepts either a set of keyword arguments that is merged into\n      the struct or a string to be used as the exception's message.\n\n    * `message/1` - receives the exception struct and must return its\n      message. Most commonly exceptions have a message field which\n      by default is accessed by this function. However, if an exception\n      does not have a message field, this function must be explicitly\n      implemented.\n\n  Since exceptions are structs, the API supported by `defstruct/1`\n  is also available in `defexception/1`.\n\n  ## Raising exceptions\n\n  The most common way to raise an exception is via `raise/2`:\n\n      defmodule MyAppError do\n        defexception [:message]\n      end\n\n      value = [:hello]\n\n      raise MyAppError,\n        message: \"did not get what was expected, got: #{inspect value}\"\n\n  In many cases it is more convenient to pass the expected value to\n  `raise/2` and generate the message in the `c:Exception.exception/1` callback:\n\n      defmodule MyAppError do\n        defexception [:message]\n\n        def exception(value) do\n          msg = \"did not get what was expected, got: #{inspect value}\"\n          %MyAppError{message: msg}\n        end\n      end\n\n      raise MyAppError, value\n\n  The example above shows the preferred strategy for customizing\n  exception messages.\n  "
    },
    defimpl = {
      description = "\ndefimpl(name, opts, do_block \\\\ [])\n\n  Defines an implementation for the given protocol.\n\n  See `defprotocol/2` for more information and examples on protocols.\n\n  Inside an implementation, the name of the protocol can be accessed\n  via `@protocol` and the current target as `@for`.\n  "
    },
    defmacro = {
      description = "\ndefmacro(call, expr \\\\ nil)\n\n  Defines a macro with the given name and body.\n\n  ## Examples\n\n      defmodule MyLogic do\n        defmacro unless(expr, opts) do\n          quote do\n            if !unquote(expr), unquote(opts)\n          end\n        end\n      end\n\n      require MyLogic\n      MyLogic.unless false do\n        IO.puts \"It works\"\n      end\n\n  "
    },
    defmacrop = {
      description = "\ndefmacrop(call, expr \\\\ nil)\n\n  Defines a private macro with the given name and body.\n\n  Private macros are only accessible from the same module in which they are\n  defined.\n\n  Check `defmacro/2` for more information.\n\n  "
    },
    defmodule = {
      description = "\ndefmodule(alias, do: block)\n\ndefmodule(alias, do_block)\n\n  Defines a module given by name with the given contents.\n\n  This macro defines a module with the given `alias` as its name and with the\n  given contents. It returns a tuple with four elements:\n\n    * `:module`\n    * the module name\n    * the binary contents of the module\n    * the result of evaluating the contents block\n\n  ## Examples\n\n      iex> defmodule Foo do\n      ...>   def bar, do: :baz\n      ...> end\n      iex> Foo.bar\n      :baz\n\n  ## Nesting\n\n  Nesting a module inside another module affects the name of the nested module:\n\n      defmodule Foo do\n        defmodule Bar do\n        end\n      end\n\n  In the example above, two modules - `Foo` and `Foo.Bar` - are created.\n  When nesting, Elixir automatically creates an alias to the inner module,\n  allowing the second module `Foo.Bar` to be accessed as `Bar` in the same\n  lexical scope where it's defined (the `Foo` module).\n\n  If the `Foo.Bar` module is moved somewhere else, the references to `Bar` in\n  the `Foo` module need to be updated to the fully-qualified name (`Foo.Bar`) or\n  an alias has to be explicitly set in the `Foo` module with the help of\n  `Kernel.SpecialForms.alias/2`.\n\n      defmodule Foo.Bar do\n        # code\n      end\n\n      defmodule Foo do\n        alias Foo.Bar\n        # code here can refer to \"Foo.Bar\" as just \"Bar\"\n      end\n\n  ## Module names\n\n  A module name can be any atom, but Elixir provides a special syntax which is\n  usually used for module names. What is called a module name is an\n  _uppercase ASCII letter_ followed by any number of _lowercase or\n  uppercase ASCII letters_, _numbers_, or _underscores_.\n  This identifier is equivalent to an atom prefixed by `Elixir.`. So in the\n  `defmodule Foo` example `Foo` is equivalent to `:\"Elixir.Foo\"`\n\n  ## Dynamic names\n\n  Elixir module names can be dynamically generated. This is very\n  useful when working with macros. For instance, one could write:\n\n      defmodule String.to_atom(\"Foo#{1}\") do\n        # contents ...\n      end\n\n  Elixir will accept any module name as long as the expression passed as the\n  first argument to `defmodule/2` evaluates to an atom.\n  Note that, when a dynamic name is used, Elixir won't nest the name under the\n  current module nor automatically set up an alias.\n\n  "
    },
    defoverridable = {
      description = "\ndefoverridable(keywords)\n\n  Makes the given functions in the current module overridable.\n\n  An overridable function is lazily defined, allowing a developer to override\n  it.\n\n  ## Example\n\n      defmodule DefaultMod do\n        defmacro __using__(_opts) do\n          quote do\n            def test(x, y) do\n              x + y\n            end\n\n            defoverridable [test: 2]\n          end\n        end\n      end\n\n      defmodule InheritMod do\n        use DefaultMod\n\n        def test(x, y) do\n          x * y + super(x, y)\n        end\n      end\n\n  As seen as in the example above, `super` can be used to call the default\n  implementation.\n\n  "
    },
    defp = {
      description = "\ndefp(call, expr \\\\ nil)\n\n  Defines a private function with the given name and body.\n\n  Private functions are only accessible from within the module in which they are\n  defined. Trying to access a private function from outside the module it's\n  defined in results in an `UndefinedFunctionError` exception.\n\n  Check `def/2` for more information.\n\n  ## Examples\n\n      defmodule Foo do\n        def bar do\n          sum(1, 2)\n        end\n\n        defp sum(a, b), do: a + b\n      end\n\n      Foo.bar #=> 3\n      Foo.sum(1, 2) #=> ** (UndefinedFunctionError) undefined function Foo.sum/2\n\n  "
    },
    defprotocol = {
      description = "\ndefprotocol(name, do: block)\n@spec exception(Keyword.t) :: Exception.t\n      # TODO: Only call Kernel.struct! by Elixir v1.5\n      \ndefprotocol(name, do_block)\n\n  Defines a protocol.\n\n  A protocol specifies an API that should be defined by its\n  implementations.\n\n  ## Examples\n\n  In Elixir, we have two verbs for checking how many items there\n  are in a data structure: `length` and `size`.  `length` means the\n  information must be computed. For example, `length(list)` needs to\n  traverse the whole list to calculate its length. On the other hand,\n  `tuple_size(tuple)` and `byte_size(binary)` do not depend on the\n  tuple and binary size as the size information is precomputed in\n  the data structure.\n\n  Although Elixir includes specific functions such as `tuple_size`,\n  `binary_size` and `map_size`, sometimes we want to be able to\n  retrieve the size of a data structure regardless of its type.\n  In Elixir we can write polymorphic code, i.e. code that works\n  with different shapes/types, by using protocols. A size protocol\n  could be implemented as follows:\n\n      defprotocol Size do\n        @doc \"Calculates the size (and not the length!) of a data structure\"\n        def size(data)\n      end\n\n  Now that the protocol can be implemented for every data structure\n  the protocol may have a compliant implementation for:\n\n      defimpl Size, for: BitString do\n        def size(binary), do: byte_size(binary)\n      end\n\n      defimpl Size, for: Map do\n        def size(map), do: map_size(map)\n      end\n\n      defimpl Size, for: Tuple do\n        def size(tuple), do: tuple_size(tuple)\n      end\n\n  Notice we didn't implement it for lists as we don't have the\n  `size` information on lists, rather its value needs to be\n  computed with `length`.\n\n  It is possible to implement protocols for all Elixir types:\n\n    * Structs (see below)\n    * `Tuple`\n    * `Atom`\n    * `List`\n    * `BitString`\n    * `Integer`\n    * `Float`\n    * `Function`\n    * `PID`\n    * `Map`\n    * `Port`\n    * `Reference`\n    * `Any` (see below)\n\n  ## Protocols and Structs\n\n  The real benefit of protocols comes when mixed with structs.\n  For instance, Elixir ships with many data types implemented as\n  structs, like `MapSet`. We can implement the `Size` protocol\n  for those types as well:\n\n      defimpl Size, for: MapSet do\n        def size(map_set), do: MapSet.size(map_set)\n      end\n\n  When implementing a protocol for a struct, the `:for` option can\n  be omitted if the `defimpl` call is inside the module that defines\n  the struct:\n\n      defmodule User do\n        defstruct [:email, :name]\n\n        defimpl Size do\n          def size(%User{}), do: 2 # two fields\n        end\n      end\n\n  If a protocol implementation is not found for a given type,\n  invoking the protocol will raise unless it is configured to\n  fallback to `Any`. Conveniences for building implementations\n  on top of existing ones are also available, look at `defstruct/1`\n  for more information about deriving\n  protocols.\n\n  ## Fallback to any\n\n  In some cases, it may be convenient to provide a default\n  implementation for all types. This can be achieved by setting\n  the `@fallback_to_any` attribute to `true` in the protocol\n  definition:\n\n      defprotocol Size do\n        @fallback_to_any true\n        def size(data)\n      end\n\n  The `Size` protocol can now be implemented for `Any`:\n\n      defimpl Size, for: Any do\n        def size(_), do: 0\n      end\n\n  Although the implementation above is arguably not a reasonable\n  one. For example, it makes no sense to say a PID or an Integer\n  have a size of 0. That's one of the reasons why `@fallback_to_any`\n  is an opt-in behaviour. For the majority of protocols, raising\n  an error when a protocol is not implemented is the proper behaviour.\n\n  ## Types\n\n  Defining a protocol automatically defines a type named `t`, which\n  can be used as follows:\n\n      @spec print_size(Size.t) :: :ok\n      def print_size(data) do\n        IO.puts(case Size.size(data) do\n          0 -> \"data has no items\"\n          1 -> \"data has one item\"\n          n -> \"data has #{n} items\"\n        end)\n      end\n\n  The `@spec` above expresses that all types allowed to implement the\n  given protocol are valid argument types for the given function.\n\n  ## Reflection\n\n  Any protocol module contains three extra functions:\n\n    * `__protocol__/1` - returns the protocol name when `:name` is given, and a\n      keyword list with the protocol functions and their arities when\n      `:functions` is given\n\n    * `impl_for/1` - receives a structure and returns the module that\n      implements the protocol for the structure, `nil` otherwise\n\n    * `impl_for!/1` - same as above but raises an error if an implementation is\n      not found\n\n          Enumerable.__protocol__(:functions)\n          #=> [count: 1, member?: 2, reduce: 3]\n\n          Enumerable.impl_for([])\n          #=> Enumerable.List\n\n          Enumerable.impl_for(42)\n          #=> nil\n\n  ## Consolidation\n\n  In order to cope with code loading in development, protocols in\n  Elixir provide a slow implementation of protocol dispatching specific\n  to development.\n\n  In order to speed up dispatching in production environments, where\n  all implementations are known up-front, Elixir provides a feature\n  called protocol consolidation. For this reason, all protocols are\n  compiled with `debug_info` set to `true`, regardless of the option\n  set by `elixirc` compiler. The debug info though may be removed after\n  consolidation.\n\n  Protocol consolidation is applied by default to all Mix projects.\n  For applying consolidation manually, please check the functions in\n  the `Protocol` module or the `mix compile.protocols` task.\n  "
    },
    defstruct = {
      description = "\ndefstruct(fields)\n\n  Defines a struct.\n\n  A struct is a tagged map that allows developers to provide\n  default values for keys, tags to be used in polymorphic\n  dispatches and compile time assertions.\n\n  To define a struct, a developer must define both `__struct__/0` and\n  `__struct__/1` functions. `defstruct/1` is a convenience macro which\n  defines such functions with some conveniences.\n\n  For more information about structs, please check `Kernel.SpecialForms.%/2`.\n\n  ## Examples\n\n      defmodule User do\n        defstruct name: nil, age: nil\n      end\n\n  Struct fields are evaluated at compile-time, which allows\n  them to be dynamic. In the example below, `10 + 11` is\n  evaluated at compile-time and the age field is stored\n  with value `21`:\n\n      defmodule User do\n        defstruct name: nil, age: 10 + 11\n      end\n\n  The `fields` argument is usually a keyword list with field names\n  as atom keys and default values as corresponding values. `defstruct/1`\n  also supports a list of atoms as its argument: in that case, the atoms\n  in the list will be used as the struct's field names and they will all\n  default to `nil`.\n\n      defmodule Post do\n        defstruct [:title, :content, :author]\n      end\n\n  ## Deriving\n\n  Although structs are maps, by default structs do not implement\n  any of the protocols implemented for maps. For example, attempting\n  to use a protocol with the `User` struct leads to an error:\n\n      john = %User{name: \"John\"}\n      MyProtocol.call(john)\n      ** (Protocol.UndefinedError) protocol MyProtocol not implemented for %User{...}\n\n  `defstruct/1`, however, allows protocol implementations to be\n  *derived*. This can be done by defining a `@derive` attribute as a\n  list before invoking `defstruct/1`:\n\n      defmodule User do\n        @derive [MyProtocol]\n        defstruct name: nil, age: 10 + 11\n      end\n\n      MyProtocol.call(john) #=> works\n\n  For each protocol in the `@derive` list, Elixir will assert there is an\n  implementation of that protocol for any (regardless if fallback to any\n  is `true`) and check if the any implementation defines a `__deriving__/3`\n  callback. If so, the callback is invoked, otherwise an implementation\n  that simply points to the any implementation is automatically derived.\n\n  ## Enforcing keys\n\n  When building a struct, Elixir will automatically guarantee all keys\n  belongs to the struct:\n\n      %User{name: \"john\", unknown: :key}\n      ** (KeyError) key :unknown not found in: %User{age: 21, name: nil}\n\n  Elixir also allows developers to enforce certain keys must always be\n  given when building the struct:\n\n      defmodule User do\n        @enforce_keys [:name]\n        defstruct name: nil, age: 10 + 11\n      end\n\n  Now trying to build a struct without the name key will fail:\n\n      %User{age: 21}\n      ** (ArgumentError) the following keys must also be given when building struct User: [:name]\n\n  Keep in mind `@enforce_keys` is a simple compile-time guarantee\n  to aid developers when building structs. It is not enforced on\n  updates and it does not provide any sort of value-validation.\n\n  ## Types\n\n  It is recommended to define types for structs. By convention such type\n  is called `t`. To define a struct inside a type, the struct literal syntax\n  is used:\n\n      defmodule User do\n        defstruct name: \"John\", age: 25\n        @type t :: %User{name: String.t, age: non_neg_integer}\n      end\n\n  It is recommended to only use the struct syntax when defining the struct's\n  type. When referring to another struct it's better to use `User.t` instead of\n  `%User{}`.\n\n  The types of the struct fields that are not included in `%User{}` default to\n  `term`.\n\n  Structs whose internal structure is private to the local module (pattern\n  matching them or directly accessing their fields should not be allowed) should\n  use the `@opaque` attribute. Structs whose internal structure is public should\n  use `@type`.\n  "
    },
    description = "\n  Provides the default macros and functions Elixir imports into your\n  environment.\n\n  These macros and functions can be skipped or cherry-picked via the\n  `import/2` macro. For instance, if you want to tell Elixir not to\n  import the `if/2` macro, you can do:\n\n      import Kernel, except: [if: 2]\n\n  Elixir also has special forms that are always imported and\n  cannot be skipped. These are described in `Kernel.SpecialForms`.\n\n  Some of the functions described in this module are inlined by\n  the Elixir compiler into their Erlang counterparts in the\n  [`:erlang` module](http://www.erlang.org/doc/man/erlang.html).\n  Those functions are called BIFs (built-in internal functions)\n  in Erlang-land and they exhibit interesting properties, as some of\n  them are allowed in guards and others are used for compiler\n  optimizations.\n\n  Most of the inlined functions can be seen in effect when capturing\n  the function:\n\n      iex> &Kernel.is_atom/1\n      &:erlang.is_atom/1\n\n  Those functions will be explicitly marked in their docs as\n  \"inlined by the compiler\".\n  ",
    destructure = {
      description = "\ndestructure(left, right) when is_list(left) \n\n  Destructures two lists, assigning each term in the\n  right one to the matching term in the left one.\n\n  Unlike pattern matching via `=`, if the sizes of the left\n  and right lists don't match, destructuring simply stops\n  instead of raising an error.\n\n  ## Examples\n\n      iex> destructure([x, y, z], [1, 2, 3, 4, 5])\n      iex> {x, y, z}\n      {1, 2, 3}\n\n  In the example above, even though the right list has more entries than the\n  left one, destructuring works fine. If the right list is smaller, the\n  remaining items are simply set to `nil`:\n\n      iex> destructure([x, y, z], [1])\n      iex> {x, y, z}\n      {1, nil, nil}\n\n  The left-hand side supports any expression you would use\n  on the left-hand side of a match:\n\n      x = 1\n      destructure([^x, y, z], [1, 2, 3])\n\n  The example above will only work if `x` matches the first value in the right\n  list. Otherwise, it will raise a `MatchError` (like the `=` operator would\n  do).\n  "
    },
    get_and_update_in = {
      description = "\nget_and_update_in(path, fun)\n  Gets a value and updates a nested data structure via the given `path`.\n\n  This is similar to `get_and_update_in/3`, except the path is extracted\n  via a macro rather than passing a list. For example:\n\n      get_and_update_in(opts[:foo][:bar], &{&1, &1 + 1})\n\n  Is equivalent to:\n\n      get_and_update_in(opts, [:foo, :bar], &{&1, &1 + 1})\n\n  Note that in order for this macro to work, the complete path must always\n  be visible by this macro. See the Paths section below.\n\n  ## Examples\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> get_and_update_in(users[\"john\"].age, &{&1, &1 + 1})\n      {27, %{\"john\" => %{age: 28}, \"meg\" => %{age: 23}}}\n\n  ## Paths\n\n  A path may start with a variable, local or remote call, and must be\n  followed by one or more:\n\n    * `foo[bar]` - accesses the key `bar` in `foo`; in case `foo` is nil,\n      `nil` is returned\n\n    * `foo.bar` - accesses a map/struct field; in case the field is not\n      present, an error is raised\n\n  Here are some valid paths:\n\n      users[\"john\"][:age]\n      users[\"john\"].age\n      User.all[\"john\"].age\n      all_users()[\"john\"].age\n\n  Here are some invalid ones:\n\n      # Does a remote call after the initial value\n      users[\"john\"].do_something(arg1, arg2)\n\n      # Does not access any key or field\n      users\n\n  \n\nget_and_update_in(data, [head | tail], fun) when is_function(fun, 1),\n    \n\nget_and_update_in(data, [head], fun) when is_function(fun, 1),\n    \n\nget_and_update_in(data, [head | tail], fun) when is_function(head, 3),\n    \n@spec get_and_update_in(structure :: Access.t, keys, (term -> {get_value, update_value} | :pop)) ::\n        {get_value, structure :: Access.t} when keys: nonempty_list(any), get_value: var, update_value: term\n  \nget_and_update_in(data, [head], fun) when is_function(head, 3),\n    \n\n  Gets a value and updates a nested structure.\n\n  `data` is a nested structure (ie. a map, keyword\n  list, or struct that implements the `Access` behaviour).\n\n  The `fun` argument receives the value of `key` (or `nil` if `key`\n  is not present) and must return a two-element tuple: the \"get\" value\n  (the retrieved value, which can be operated on before being returned)\n  and the new value to be stored under `key`. The `fun` may also\n  return `:pop`, implying the current value shall be removed\n  from the structure and returned.\n\n  It uses the `Access` module to traverse the structures\n  according to the given `keys`, unless the `key` is a\n  function.\n\n  If a key is a function, the function will be invoked\n  passing three arguments, the operation (`:get_and_update`),\n  the data to be accessed, and a function to be invoked next.\n\n  This means `get_and_update_in/3` can be extended to provide\n  custom lookups. The downside is that functions cannot be stored\n  as keys in the accessed data structures.\n\n  ## Examples\n\n  This function is useful when there is a need to retrieve the current\n  value (or something calculated in function of the current value) and\n  update it at the same time. For example, it could be used to increase\n  the age of a user by one and return the previous age in one pass:\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> get_and_update_in(users, [\"john\", :age], &{&1, &1 + 1})\n      {27, %{\"john\" => %{age: 28}, \"meg\" => %{age: 23}}}\n\n  When one of the keys is a function, the function is invoked.\n  In the example below, we use a function to get and increment all\n  ages inside a list:\n\n      iex> users = [%{name: \"john\", age: 27}, %{name: \"meg\", age: 23}]\n      iex> all = fn :get_and_update, data, next ->\n      ...>   Enum.map(data, next) |> :lists.unzip\n      ...> end\n      iex> get_and_update_in(users, [all, :age], &{&1, &1 + 1})\n      {[27, 23], [%{name: \"john\", age: 28}, %{name: \"meg\", age: 24}]}\n\n  If the previous value before invoking the function is `nil`,\n  the function *will* receive `nil` as a value and must handle it\n  accordingly (be it by failing or providing a sane default).\n\n  The `Access` module ships with many convenience accessor functions,\n  like the `all` anonymous function defined above. See `Access.all/0`,\n  `Access.key/2` and others as examples.\n  "
    },
    get_in = {
      description = "\nget_in(data, [h | t])\n\nget_in(data, [h])\n\nget_in(nil, [_ | t])\n\nget_in(nil, [_])\n\nget_in(data, [h | t]) when is_function(h),\n    \n@spec get_in(Access.t, nonempty_list(term)) :: term\n  \nget_in(data, [h]) when is_function(h),\n    \n\n  Gets a value from a nested structure.\n\n  Uses the `Access` module to traverse the structures\n  according to the given `keys`, unless the `key` is a\n  function.\n\n  If a key is a function, the function will be invoked\n  passing three arguments, the operation (`:get`), the\n  data to be accessed, and a function to be invoked next.\n\n  This means `get_in/2` can be extended to provide\n  custom lookups. The downside is that functions cannot be\n  stored as keys in the accessed data structures.\n\n  ## Examples\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> get_in(users, [\"john\", :age])\n      27\n\n  In case any of entries in the middle returns `nil`, `nil` will be returned\n  as per the Access module:\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> get_in(users, [\"unknown\", :age])\n      nil\n\n  When one of the keys is a function, the function is invoked.\n  In the example below, we use a function to get all the maps\n  inside a list:\n\n      iex> users = [%{name: \"john\", age: 27}, %{name: \"meg\", age: 23}]\n      iex> all = fn :get, data, next -> Enum.map(data, next) end\n      iex> get_in(users, [all, :age])\n      [27, 23]\n\n  If the previous value before invoking the function is `nil`,\n  the function *will* receive nil as a value and must handle it\n  accordingly.\n  "
    },
    ["if"] = {
      description = "\nif(condition, clauses)\n\n  Provides an `if/2` macro.\n\n  This macro expects the first argument to be a condition and the second\n  argument to be a keyword list.\n\n  ## One-liner examples\n\n      if(foo, do: bar)\n\n  In the example above, `bar` will be returned if `foo` evaluates to\n  `true` (i.e., it is neither `false` nor `nil`). Otherwise, `nil` will be\n  returned.\n\n  An `else` option can be given to specify the opposite:\n\n      if(foo, do: bar, else: baz)\n\n  ## Blocks examples\n\n  It's also possible to pass a block to the `if/2` macro. The first\n  example above would be translated to:\n\n      if foo do\n        bar\n      end\n\n  Note that `do/end` become delimiters. The second example would\n  translate to:\n\n      if foo do\n        bar\n      else\n        baz\n      end\n\n  In order to compare more than two clauses, the `cond/1` macro has to be used.\n  "
    },
    is_nil = {
      description = "\nis_nil(term)\n\n  Returns `true` if `term` is `nil`, `false` otherwise.\n\n  Allowed in guard clauses.\n\n  ## Examples\n\n      iex> is_nil(1)\n      false\n\n      iex> is_nil(nil)\n      true\n\n  "
    },
    ["match?"] = {
      description = "\nmatch?(pattern, expr)\n\n  A convenience macro that checks if the right side (an expression) matches the\n  left side (a pattern).\n\n  ## Examples\n\n      iex> match?(1, 1)\n      true\n\n      iex> match?(1, 2)\n      false\n\n      iex> match?({1, _}, {1, 2})\n      true\n\n      iex> map = %{a: 1, b: 2}\n      iex> match?(%{a: _}, map)\n      true\n\n      iex> a = 1\n      iex> match?(^a, 1)\n      true\n\n  `match?/2` is very useful when filtering of finding a value in an enumerable:\n\n      list = [{:a, 1}, {:b, 2}, {:a, 3}]\n      Enum.filter list, &match?({:a, _}, &1)\n      #=> [{:a, 1}, {:a, 3}]\n\n  Guard clauses can also be given to the match:\n\n      list = [{:a, 1}, {:b, 2}, {:a, 3}]\n      Enum.filter list, &match?({:a, x} when x < 2, &1)\n      #=> [{:a, 1}]\n\n  However, variables assigned in the match will not be available\n  outside of the function call (unlike regular pattern matching with the `=`\n  operator):\n\n      iex> match?(_x, 1)\n      true\n      iex> binding()\n      []\n\n  "
    },
    pop_in = {
      description = "\npop_in(path)\n  Pops a key from the nested structure via the given `path`.\n\n  This is similar to `pop_in/2`, except the path is extracted via\n  a macro rather than passing a list. For example:\n\n      pop_in(opts[:foo][:bar])\n\n  Is equivalent to:\n\n      pop_in(opts, [:foo, :bar])\n\n  Note that in order for this macro to work, the complete path must always\n  be visible by this macro. For more information about the supported path\n  expressions, please check `get_and_update_in/2` docs.\n\n  ## Examples\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> pop_in(users[\"john\"][:age])\n      {27, %{\"john\" => %{}, \"meg\" => %{age: 23}}}\n\n      iex> users = %{john: %{age: 27}, meg: %{age: 23}}\n      iex> pop_in(users.john[:age])\n      {27, %{john: %{}, meg: %{age: 23}}}\n\n  In case any entry returns `nil`, its key will be removed\n  and the deletion will be considered a success.\n  \n\npop_in(data, keys)\n@spec pop_in(Access.t, nonempty_list(term)) :: {term, Access.t}\n  \npop_in(nil, [h | _])\n\n  Pops a key from the given nested structure.\n\n  Uses the `Access` protocol to traverse the structures\n  according to the given `keys`, unless the `key` is a\n  function. If the key is a function, it will be invoked\n  as specified in `get_and_update_in/3`.\n\n  ## Examples\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> pop_in(users, [\"john\", :age])\n      {27, %{\"john\" => %{}, \"meg\" => %{age: 23}}}\n\n  In case any entry returns `nil`, its key will be removed\n  and the deletion will be considered a success.\n  "
    },
    put_in = {
      description = "\nput_in(path, value)\n\n  Puts a value in a nested structure via the given `path`.\n\n  This is similar to `put_in/3`, except the path is extracted via\n  a macro rather than passing a list. For example:\n\n      put_in(opts[:foo][:bar], :baz)\n\n  Is equivalent to:\n\n      put_in(opts, [:foo, :bar], :baz)\n\n  Note that in order for this macro to work, the complete path must always\n  be visible by this macro. For more information about the supported path\n  expressions, please check `get_and_update_in/2` docs.\n\n  ## Examples\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> put_in(users[\"john\"][:age], 28)\n      %{\"john\" => %{age: 28}, \"meg\" => %{age: 23}}\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> put_in(users[\"john\"].age, 28)\n      %{\"john\" => %{age: 28}, \"meg\" => %{age: 23}}\n\n  "
    },
    raise = {
      description = "\nraise(exception, attrs)\n  Raises an exception.\n\n  Calls the `exception/1` function on the given argument (which has to be a\n  module name like `ArgumentError` or `RuntimeError`) passing `attrs` as the\n  attributes in order to retrieve the exception struct.\n\n  Any module that contains a call to the `defexception/1` macro automatically\n  implements the `c:Exception.exception/1` callback expected by `raise/2`.\n  For more information, see `defexception/1`.\n\n  ## Examples\n\n      iex> raise(ArgumentError, message: \"Sample\")\n      ** (ArgumentError) Sample\n\n  \n@spec put_elem(tuple, non_neg_integer, term) :: tuple\n  \nraise(msg)\n\n  Raises an exception.\n\n  If the argument `msg` is a binary, it raises a `RuntimeError` exception\n  using the given argument as message.\n\n  If `msg` is an atom, it just calls `raise/2` with the atom as the first\n  argument and `[]` as the second argument.\n\n  If `msg` is anything else, raises an `ArgumentError` exception.\n\n  ## Examples\n\n      iex> raise \"oops\"\n      ** (RuntimeError) oops\n\n      try do\n        1 + :foo\n      rescue\n        x in [ArithmeticError] ->\n          IO.puts \"that was expected\"\n          raise x\n      end\n\n  "
    },
    reraise = {
      description = "\nreraise(exception, attrs, stacktrace)\n  Raises an exception preserving a previous stacktrace.\n\n  `reraise/3` works like `reraise/2`, except it passes arguments to the\n  `exception/1` function as explained in `raise/2`.\n\n  ## Examples\n\n      try do\n        raise \"oops\"\n      rescue\n        exception ->\n          stacktrace = System.stacktrace\n          reraise WrapperError, [exception: exception], stacktrace\n      end\n  \n\nreraise(msg, stacktrace)\n\n  Raises an exception preserving a previous stacktrace.\n\n  Works like `raise/1` but does not generate a new stacktrace.\n\n  Notice that `System.stacktrace/0` returns the stacktrace\n  of the last exception. That said, it is common to assign\n  the stacktrace as the first expression inside a `rescue`\n  clause as any other exception potentially raised (and\n  rescued) between the rescue clause and the raise call\n  may change the `System.stacktrace/0` value.\n\n  ## Examples\n\n      try do\n        raise \"oops\"\n      rescue\n        exception ->\n          stacktrace = System.stacktrace\n          if Exception.message(exception) == \"oops\" do\n            reraise exception, stacktrace\n          end\n      end\n  "
    },
    sigil_C = {
      description = "\nsigil_C({:<<>>, _meta, [string]}, []) when is_binary(string) \n\nsigil_C(term, modifiers)\n\n  Handles the sigil `~C`.\n\n  It simply returns a charlist without escaping characters and without\n  interpolations.\n\n  ## Examples\n\n      iex> ~C(foo)\n      'foo'\n\n      iex> ~C(f#{o}o)\n      'f\\#{o}o'\n\n  "
    },
    sigil_D = {
      description = "\nsigil_D({:<<>>, _, [string]}, [])\n\nsigil_D(date, modifiers)\n\n  Handles the sigil `~D` for dates.\n\n  The lower case `~d` variant does not exist as interpolation\n  and escape characters are not useful for date sigils.\n\n  ## Examples\n\n      iex> ~D[2015-01-13]\n      ~D[2015-01-13]\n  "
    },
    sigil_N = {
      description = "\nsigil_N({:<<>>, _, [string]}, [])\n\nsigil_N(date, modifiers)\n\n  Handles the sigil `~N` for naive date times.\n\n  The lower case `~n` variant does not exist as interpolation\n  and escape characters are not useful for datetime sigils.\n\n  ## Examples\n\n      iex> ~N[2015-01-13 13:00:07]\n      ~N[2015-01-13 13:00:07]\n      iex> ~N[2015-01-13T13:00:07.001]\n      ~N[2015-01-13 13:00:07.001]\n\n  "
    },
    sigil_R = {
      description = "\nsigil_R({:<<>>, _meta, [string]}, options) when is_binary(string) \n\nsigil_R(term, modifiers)\n\n  Handles the sigil `~R`.\n\n  It returns a regular expression pattern without escaping\n  nor interpreting interpolations.\n\n  More information on regexes can be found in the `Regex` module.\n\n  ## Examples\n\n      iex> Regex.match?(~R(f#{1,3}o), \"f#o\")\n      true\n\n  "
    },
    sigil_S = {
      description = "\nsigil_S({:<<>>, _, [binary]}, []) when is_binary(binary), \n\nsigil_S(term, modifiers)\n\n  Handles the sigil `~S`.\n\n  It simply returns a string without escaping characters and without\n  interpolations.\n\n  ## Examples\n\n      iex> ~S(foo)\n      \"foo\"\n\n      iex> ~S(f#{o}o)\n      \"f\\#{o}o\"\n\n  "
    },
    sigil_T = {
      description = "\nsigil_T({:<<>>, _, [string]}, [])\n\nsigil_T(date, modifiers)\n\n  Handles the sigil `~T` for times.\n\n  The lower case `~t` variant does not exist as interpolation\n  and escape characters are not useful for time sigils.\n\n  ## Examples\n\n      iex> ~T[13:00:07]\n      ~T[13:00:07]\n      iex> ~T[13:00:07.001]\n      ~T[13:00:07.001]\n\n  "
    },
    sigil_W = {
      description = "\nsigil_W({:<<>>, _meta, [string]}, modifiers) when is_binary(string) \n\nsigil_W(term, modifiers)\n\n  Handles the sigil `~W`.\n\n  It returns a list of \"words\" split by whitespace without escaping nor\n  interpreting interpolations.\n\n  ## Modifiers\n\n    * `s`: words in the list are strings (default)\n    * `a`: words in the list are atoms\n    * `c`: words in the list are charlists\n\n  ## Examples\n\n      iex> ~W(foo #{bar} baz)\n      [\"foo\", \"\\#{bar}\", \"baz\"]\n\n  "
    },
    sigil_c = {
      description = "\nsigil_c({:<<>>, meta, pieces}, [])\n\nsigil_c({:<<>>, _meta, [string]}, []) when is_binary(string) \n\nsigil_c(term, modifiers)\n\n  Handles the sigil `~c`.\n\n  It returns a charlist as if it were a single quoted string, unescaping\n  characters and replacing interpolations.\n\n  ## Examples\n\n      iex> ~c(foo)\n      'foo'\n\n      iex> ~c(f#{:o}o)\n      'foo'\n\n      iex> ~c(f\\#{:o}o)\n      'f\\#{:o}o'\n\n  "
    },
    sigil_r = {
      description = "\nsigil_r({:<<>>, meta, pieces}, options)\n\nsigil_r({:<<>>, _meta, [string]}, options) when is_binary(string) \n\nsigil_r(term, modifiers)\n\n  Handles the sigil `~r`.\n\n  It returns a regular expression pattern, unescaping characters and replacing\n  interpolations.\n\n  More information on regexes can be found in the `Regex` module.\n\n  ## Examples\n\n      iex> Regex.match?(~r(foo), \"foo\")\n      true\n\n      iex> Regex.match?(~r/a#{:b}c/, \"abc\")\n      true\n\n  "
    },
    sigil_s = {
      description = "\nsigil_s({:<<>>, line, pieces}, [])\n\nsigil_s({:<<>>, _, [piece]}, []) when is_binary(piece) \n\nsigil_s(term, modifiers)\n\n  Handles the sigil `~s`.\n\n  It returns a string as if it was a double quoted string, unescaping characters\n  and replacing interpolations.\n\n  ## Examples\n\n      iex> ~s(foo)\n      \"foo\"\n\n      iex> ~s(f#{:o}o)\n      \"foo\"\n\n      iex> ~s(f\\#{:o}o)\n      \"f\\#{:o}o\"\n\n  "
    },
    sigil_w = {
      description = "\nsigil_w({:<<>>, meta, pieces}, modifiers)\n\nsigil_w({:<<>>, _meta, [string]}, modifiers) when is_binary(string) \n\nsigil_w(term, modifiers)\n\n  Handles the sigil `~w`.\n\n  It returns a list of \"words\" split by whitespace. Character unescaping and\n  interpolation happens for each word.\n\n  ## Modifiers\n\n    * `s`: words in the list are strings (default)\n    * `a`: words in the list are atoms\n    * `c`: words in the list are charlists\n\n  ## Examples\n\n      iex> ~w(foo #{:bar} baz)\n      [\"foo\", \"bar\", \"baz\"]\n\n      iex> ~w(foo #{\" bar baz \"})\n      [\"foo\", \"bar\", \"baz\"]\n\n      iex> ~w(--source test/enum_test.exs)\n      [\"--source\", \"test/enum_test.exs\"]\n\n      iex> ~w(foo bar baz)a\n      [:foo, :bar, :baz]\n\n  "
    },
    ["struct!"] = {
      description = "\nstruct!(struct, kv) when is_map(struct) \n@spec struct!(module | struct, Enum.t) :: struct | no_return\n  \nstruct!(struct, kv) when is_atom(struct) \n\n  Similar to `struct/2` but checks for key validity.\n\n  The function `struct!/2` emulates the compile time behaviour\n  of structs. This means that:\n\n    * when building a struct, as in `struct!(SomeStruct, key: :value)`,\n      it is equivalent to `%SomeStruct{key: :value}` and therefore this\n      function will check if every given key-value belongs to the struct.\n      If the struct is enforcing any key via `@enforce_keys`, those will\n      be enforced as well;\n\n    * when updating a struct, as in `struct!(%SomeStruct{}, key: :value)`,\n      it is equivalent to `%SomeStruct{struct | key: :value}` and therefore this\n      function will check if every given key-value belongs to the struct.\n      However, updating structs does not enforce keys, as keys are enforced\n      only when building;\n\n  "
    },
    to_char_list = {
      description = "\nto_char_list(arg)\nfalse"
    },
    to_charlist = {
      description = "\nto_charlist(arg)\n\n  Converts the argument to a charlist according to the `List.Chars` protocol.\n\n  ## Examples\n\n      iex> to_charlist(:foo)\n      'foo'\n\n  "
    },
    to_string = {
      description = "\nto_string(arg)\n\n  Converts the argument to a string according to the\n  `String.Chars` protocol.\n\n  This is the function invoked when there is string interpolation.\n\n  ## Examples\n\n      iex> to_string(:foo)\n      \"foo\"\n\n  "
    },
    unless = {
      description = "\nunless(condition, clauses)\n\n  Provides an `unless` macro.\n\n  This macro evaluates and returns the `do` block passed in as the second\n  argument unless `clause` evaluates to `true`. Otherwise, it returns the value\n  of the `else` block if present or `nil` if not.\n\n  See also `if/2`.\n\n  ## Examples\n\n      iex> unless(Enum.empty?([]), do: \"Hello\")\n      nil\n\n      iex> unless(Enum.empty?([1, 2, 3]), do: \"Hello\")\n      \"Hello\"\n\n      iex> unless Enum.sum([2, 2]) == 5 do\n      ...>   \"Math still works\"\n      ...> else\n      ...>   \"Math is broken\"\n      ...> end\n      \"Math still works\"\n\n  "
    },
    update_in = {
      description = "\nupdate_in(path, fun)\n\n  Updates a nested structure via the given `path`.\n\n  This is similar to `update_in/3`, except the path is extracted via\n  a macro rather than passing a list. For example:\n\n      update_in(opts[:foo][:bar], &(&1 + 1))\n\n  Is equivalent to:\n\n      update_in(opts, [:foo, :bar], &(&1 + 1))\n\n  Note that in order for this macro to work, the complete path must always\n  be visible by this macro. For more information about the supported path\n  expressions, please check `get_and_update_in/2` docs.\n\n  ## Examples\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> update_in(users[\"john\"][:age], &(&1 + 1))\n      %{\"john\" => %{age: 28}, \"meg\" => %{age: 23}}\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> update_in(users[\"john\"].age, &(&1 + 1))\n      %{\"john\" => %{age: 28}, \"meg\" => %{age: 23}}\n\n  "
    },
    use = {
      description = "\nuse(module, opts \\\\ [])\n\n  Uses the given module in the current context.\n\n  When calling:\n\n      use MyModule, some: :options\n\n  the `__using__/1` macro from the `MyModule` module is invoked with the second\n  argument passed to `use` as its argument. Since `__using__/1` is a macro, all\n  the usual macro rules apply, and its return value should be quoted code\n  that is then inserted where `use/2` is called.\n\n  ## Examples\n\n  For example, in order to write test cases using the `ExUnit` framework\n  provided with Elixir, a developer should `use` the `ExUnit.Case` module:\n\n      defmodule AssertionTest do\n        use ExUnit.Case, async: true\n\n        test \"always pass\" do\n          assert true\n        end\n      end\n\n  In this example, `ExUnit.Case.__using__/1` is called with the keyword list\n  `[async: true]` as its argument; `use/2` translates to:\n\n      defmodule AssertionTest do\n        require ExUnit.Case\n        ExUnit.Case.__using__([async: true])\n\n        test \"always pass\" do\n          assert true\n        end\n      end\n\n  `ExUnit.Case` will then define the `__using__/1` macro:\n\n      defmodule ExUnit.Case do\n        defmacro __using__(opts) do\n          # do something with opts\n          quote do\n            # return some code to inject in the caller\n          end\n        end\n      end\n\n  ## Best practices\n\n  `__using__/1` is typically used when there is a need to set some state (via\n  module attributes) or callbacks (like `@before_compile`, see the documentation\n  for `Module` for more information) into the caller.\n\n  `__using__/1` may also be used to alias, require, or import functionality\n  from different modules:\n\n      defmodule MyModule do\n        defmacro __using__(opts) do\n          quote do\n            import MyModule.Foo\n            import MyModule.Bar\n            import MyModule.Baz\n\n            alias MyModule.Repo\n          end\n        end\n      end\n\n  However, do not provide `__using__/1` if all it does is to import,\n  alias or require the module itself. For example, avoid this:\n\n      defmodule MyModule do\n        defmacro __using__(_opts) do\n          quote do\n            import MyModule\n          end\n        end\n      end\n\n  In such cases, developers should instead import or alias the module\n  directly, so that they can customize those as they wish,\n  without the indirection behind `use/2`.\n\n  Finally, developers should also avoid defining functions inside\n  the `__using__/1` callback, unless those functions are the default\n  implementation of a previously defined `@callback` or are functions\n  meant to be overridden (see `defoverridable/1`). Even in these cases,\n  defining functions should be seen as a \"last resource\".\n\n  In case you want to provide some existing functionality to the user module,\n  please define it in a module which will be imported accordingly; for example,\n  `ExUnit.Case` doesn't define the `test/3` macro in the module that calls\n  `use ExUnit.Case`, but it defines `ExUnit.Case.test/3` and just imports that\n  into the caller when used.\n  "
    },
    ["var!"] = {
      description = "\nvar!(other, _context)\n\nvar!({name, meta, atom}, context) when is_atom(name) and is_atom(atom) \n@spec macro_exported?(module, atom, arity) :: boolean\n  \nvar!(var, context \\\\ nil)\n\n  When used inside quoting, marks that the given variable should\n  not be hygienized.\n\n  The argument can be either a variable unquoted or in standard tuple form\n  `{name, meta, context}`.\n\n  Check `Kernel.SpecialForms.quote/2` for more information.\n  "
    }
  },
  KeyError = {
    message = {
      description = "\nmessage(exception)\n"
    }
  },
  Keyword = {
    description = "\n  A set of functions for working with keywords.\n\n  A keyword is a list of two-element tuples where the first\n  element of the tuple is an atom and the second element\n  can be any value.\n\n  For example, the following is a keyword list:\n\n      [{:exit_on_close, true}, {:active, :once}, {:packet_size, 1024}]\n\n  Elixir provides a special and more concise syntax for keyword lists\n  that looks like this:\n\n      [exit_on_close: true, active: :once, packet_size: 1024]\n\n  This is also the syntax that Elixir uses to inspect keyword lists:\n\n      iex> [{:active, :once}]\n      [active: :once]\n\n  The two syntaxes are completely equivalent. Note that when keyword\n  lists are passed as the last argument to a function, if the short-hand\n  syntax is used then the square brackets around the keyword list can\n  be omitted as well. For example, the following:\n\n      String.split(\"1-0\", \"-\", trim: true, parts: 2)\n\n  is equivalent to:\n\n      String.split(\"1-0\", \"-\", [trim: true, parts: 2])\n\n  A keyword may have duplicated keys so it is not strictly\n  a key-value store. However most of the functions in this module\n  behave exactly as a dictionary so they work similarly to\n  the functions you would find in the `Map` module.\n\n  For example, `Keyword.get/3` will get the first entry matching\n  the given key, regardless if duplicated entries exist.\n  Similarly, `Keyword.put/3` and `Keyword.delete/3` ensure all\n  duplicated entries for a given key are removed when invoked.\n  Note that operations that require keys to be found in the keyword\n  list (like `Keyword.get/3`) need to traverse the list in order\n  to find keys, so these operations may be slower than their map\n  counterparts.\n\n  A handful of functions exist to handle duplicated keys, in\n  particular, `Enum.into/2` allows creating new keywords without\n  removing duplicated keys, `get_values/2` returns all values for\n  a given key and `delete_first/2` deletes just one of the existing\n  entries.\n\n  The functions in `Keyword` do not guarantee any property when\n  it comes to ordering. However, since a keyword list is simply a\n  list, all the operations defined in `Enum` and `List` can be\n  applied too, especially when ordering is required.\n  ",
    key = {
      description = "key :: atom\n"
    },
    ["keyword?"] = {
      description = "\nkeyword?(_other)\n\nkeyword?([])\n@spec keyword?(term) :: boolean\n  \nkeyword?([{key, _value} | rest]) when is_atom(key), \n\n  Returns `true` if `term` is a keyword list; otherwise returns `false`.\n\n  ## Examples\n\n      iex> Keyword.keyword?([])\n      true\n      iex> Keyword.keyword?([a: 1])\n      true\n      iex> Keyword.keyword?([{Foo, 1}])\n      true\n      iex> Keyword.keyword?([{}])\n      false\n      iex> Keyword.keyword?([:key])\n      false\n      iex> Keyword.keyword?(%{})\n      false\n\n  "
    },
    size = {
      description = "@spec to_list(t) :: t\n  \nsize(keyword)\nfalse"
    },
    t = {
      description = "t :: [{key, value}]\n"
    },
    update = {
      description = "\nupdate([], key, initial, _fun) when is_atom(key) \n\nupdate([{_, _} = e | keywords], key, initial, fun)\n@spec update(t, key, value, (value -> value)) :: t\n  \nupdate([{key, value} | keywords], key, _initial, fun)\n\n  Updates the `key` in `keywords` with the given function.\n\n  If the `key` does not exist, inserts the given `initial` value.\n\n  If there are duplicated keys, they are all removed and only the first one\n  is updated.\n\n  ## Examples\n\n      iex> Keyword.update([a: 1], :a, 13, &(&1 * 2))\n      [a: 2]\n      iex> Keyword.update([a: 1, a: 2], :a, 13, &(&1 * 2))\n      [a: 2]\n      iex> Keyword.update([a: 1], :b, 11, &(&1 * 2))\n      [a: 1, b: 11]\n\n  "
    },
    value = {
      description = "value :: any\n"
    }
  },
  LexicalTracker = nil,
  List = {
    Chars = {
      description = "\n  The List.Chars protocol is responsible for\n  converting a structure to a list (only if applicable).\n  The only function required to be implemented is\n  `to_charlist` which does the conversion.\n\n  The `to_charlist/1` function automatically imported\n  by `Kernel` invokes this protocol.\n  ",
      to_charlist = {
        description = "\nto_charlist(term)\n\nto_charlist(term)\n\nto_charlist(list)\n\nto_charlist(term)\n\nto_charlist(term) when is_binary(term) \n  Returns the given binary `term` converted to a charlist.\n  \n\nto_charlist(atom)false\n\nto_charlist(term)\n"
      }
    },
    description = "\n  Functions that work on (linked) lists.\n\n  Lists in Elixir are specified between square brackets:\n\n      iex> [1, \"two\", 3, :four]\n      [1, \"two\", 3, :four]\n\n  Two lists can be concatenated and subtracted using the\n  `Kernel.++/2` and `Kernel.--/2` operators:\n\n      iex> [1, 2, 3] ++ [4, 5, 6]\n      [1, 2, 3, 4, 5, 6]\n      iex> [1, true, 2, false, 3, true] -- [true, false]\n      [1, 2, 3, true]\n\n  Lists in Elixir are effectively linked lists, which means\n  they are internally represented in pairs containing the\n  head and the tail of a list:\n\n      iex> [head | tail] = [1, 2, 3]\n      iex> head\n      1\n      iex> tail\n      [2, 3]\n\n  Similarly, we could write the list `[1, 2, 3]` using only\n  such pairs (called cons cells):\n\n      iex> [1 | [2 | [3 | []]]]\n      [1, 2, 3]\n\n  Some lists, called improper lists, do not have an empty list as\n  the second element in the last cons cell:\n\n      iex> [1 | [2 | [3 | 4]]]\n      [1, 2, 3 | 4]\n\n  Although improper lists are generally avoided, they are used in some\n  special circumstances like iodata and chardata entities (see the `IO` module).\n\n  Due to their cons cell based representation, prepending an element\n  to a list is always fast (constant time), while appending becomes\n  slower as the list grows in size (linear time):\n\n      iex> list = [1, 2, 3]\n      iex> [0 | list]   # fast\n      [0, 1, 2, 3]\n      iex> list ++ [4]  # slow\n      [1, 2, 3, 4]\n\n  The `Kernel` module contains many functions to manipulate lists\n  and that are allowed in guards. For example, `Kernel.hd/1` to\n  retrieve the head, `Kernel.tl/1` to fetch the tail and\n  `Kernel.length/1` for calculating the length. Keep in mind that,\n  similar to appending to a list, calculating the length needs to\n  traverse the whole list.\n\n  ## Charlists\n\n  If a list is made of non-negative integers, it can also be called\n  a charlist. Elixir uses single quotes to define charlists:\n\n      iex> 'héllo'\n      [104, 233, 108, 108, 111]\n\n  In particular, charlists may be printed back in single\n  quotes if they contain only ASCII-printable codepoints:\n\n      iex> 'abc'\n      'abc'\n\n  The rationale behind this behaviour is to better support\n  Erlang libraries which may return text as charlists\n  instead of Elixir strings. One example of such functions\n  is `Application.loaded_applications/0`:\n\n      Application.loaded_applications\n      #=>  [{:stdlib, 'ERTS  CXC 138 10', '2.6'},\n            {:compiler, 'ERTS  CXC 138 10', '6.0.1'},\n            {:elixir, 'elixir', '1.0.0'},\n            {:kernel, 'ERTS  CXC 138 10', '4.1'},\n            {:logger, 'logger', '1.0.0'}]\n\n  ## List and Enum modules\n\n  This module aims to provide operations that are specific\n  to lists, like conversion between data types, updates,\n  deletions and key lookups (for lists of tuples). For traversing\n  lists in general, developers should use the functions in the\n  `Enum` module that work across a variety of data types.\n\n  In both `Enum` and `List` modules, any kind of index access\n  on a list is linear. Negative indexes are also supported but\n  they imply the list will be iterated twice, one to calculate\n  the proper index and another to perform the operation.\n  ",
    first = {
      description = "@spec first([elem]) :: nil | elem when elem: var\n  \nfirst([head | _])\n\n  Returns the first element in `list` or `nil` if `list` is empty.\n\n  ## Examples\n\n      iex> List.first([])\n      nil\n\n      iex> List.first([1])\n      1\n\n      iex> List.first([1, 2, 3])\n      1\n\n  "
    },
    last = {
      description = "\nlast([_ | tail])\n@spec last([elem]) :: nil | elem when elem: var\n  \nlast([head])\n\n  Returns the last element in `list` or `nil` if `list` is empty.\n\n  ## Examples\n\n      iex> List.last([])\n      nil\n\n      iex> List.last([1])\n      1\n\n      iex> List.last([1, 2, 3])\n      3\n\n  "
    },
    wrap = {
      description = "\nwrap(other)\n@spec wrap(list | any) :: list\n  \nwrap(nil)\n\n  Wraps the argument in a list.\n\n  If the argument is already a list, returns the list.\n  If the argument is `nil`, returns an empty list.\n\n  ## Examples\n\n      iex> List.wrap(\"hello\")\n      [\"hello\"]\n\n      iex> List.wrap([1, 2, 3])\n      [1, 2, 3]\n\n      iex> List.wrap(nil)\n      []\n\n  "
    },
    zip = {
      description = "@spec zip([list]) :: [tuple]\n  \nzip(list_of_lists) when is_list(list_of_lists) \n\n  Zips corresponding elements from each list in `list_of_lists`.\n\n  The zipping finishes as soon as any list terminates.\n\n  ## Examples\n\n      iex> List.zip([[1, 2], [3, 4], [5, 6]])\n      [{1, 3, 5}, {2, 4, 6}]\n\n      iex> List.zip([[1, 2], [3], [5, 6]])\n      [{1, 3, 5}]\n\n  "
    }
  },
  Logger = {
    App = {
      config_change = {
        description = "\nconfig_change(_changed, _new, _removed)\nfalse"
      },
      description = "false",
      start = {
        description = "\nstartfalse\n\nstart(_type, _args)\nfalse"
      },
      stop = {
        description = "\nstop(config)\nfalse"
      }
    },
    Backends = {
      Console = {
        code_change = {
          description = "\ncode_change(_old_vsn, state, _extra)\n"
        },
        description = "false",
        handle_call = {
          description = "\nhandle_call({:configure, options}, state)\n"
        },
        handle_event = {
          description = "\nhandle_event(_, state)\n\nhandle_event(:flush, state)\n\nhandle_event({level, _gl, {Logger, msg, ts, md}}, state)\n\nhandle_event({_level, gl, _event}, state) when node(gl) != node() \n"
        },
        handle_info = {
          description = "\nhandle_info(_, state)\n\nhandle_info({:DOWN, ref, _, pid, reason}, %{ref: ref})\n\nhandle_info({:io_reply, ref, msg}, %{ref: ref} = state)\n"
        },
        init = {
          description = "\ninit({__MODULE__, opts}) when is_list(opts) \n\ninit(:console)\n"
        },
        terminate = {
          description = "\nterminate(_reason, _state)\n"
        }
      }
    },
    Config = {
      add_backend = {
        description = "\nadd_backend(backend)\n"
      },
      add_translator = {
        description = "\nadd_translator(translator)\n"
      },
      code_change = {
        description = "\ncode_change(_old, state, _extra)\n"
      },
      configure = {
        description = "\nconfigure(options)\n"
      },
      delete = {
        description = "\ndelete(@table)\n"
      },
      deleted_handlers = {
        description = "\ndeleted_handlers(handlers)\n"
      },
      description = "false",
      handle_call = {
        description = "\nhandle_call({:deleted_handlers, new}, state)\n\nhandle_call({:remove_backend, backend}, state)\n\nhandle_call({:add_backend, backend}, state)\n\nhandle_call({:remove_translator, translator}, state)\n\nhandle_call({:add_translator, translator}, state)\n\nhandle_call({:configure, options}, state)\n\nhandle_call(:backends, state)\n"
      },
      handle_event = {
        description = "\nhandle_event(_event, %{mode: mode} = state)\n\nhandle_event({_type, gl, _msg} = event, state) when node(gl) != node() \n"
      },
      handle_info = {
        description = "\nhandle_info(_msg, state)\n"
      },
      init = {
        description = "\ninit(_)\n"
      },
      remove_backend = {
        description = "\nremove_backend(backend)\n"
      },
      remove_translator = {
        description = "\nremove_translator(translator)\n"
      },
      start_link = {
        description = "\nstart_link\n"
      },
      terminate = {
        description = "\nterminate(_reason, _state)\n"
      },
      translate_backend = {
        description = "\ntranslate_backend(other)\n\ntranslate_backend(:console)\n"
      }
    },
    ErrorHandler = {
      code_change = {
        description = "\ncode_change(_old_vsn, state, _extra)\n"
      },
      description = "false",
      handle_call = {
        description = "\nhandle_call(request, _state)\n"
      },
      handle_event = {
        description = "\nhandle_event(event, state)\n\nhandle_event({_type, gl, _msg}, state) when node(gl) != node() \n"
      },
      handle_info = {
        description = "\nhandle_info(_msg, state)\n"
      },
      init = {
        description = "\ninit({otp?, sasl?, threshold})\n"
      },
      terminate = {
        description = "\nterminate(_reason, _state)\n"
      }
    },
    Formatter = {
      compile = {
        description = "\ncompile(str)\n@spec compile(binary | nil) :: [pattern | binary]\n  @spec compile({atom, atom}) :: {atom, atom}\n\n  \ncompile({mod, fun}) when is_atom(mod) and is_atom(fun), \n\n  Compiles a format string into a data structure that the `format/5` can handle.\n\n  Check the module doc for documentation on the valid parameters. If you\n  pass `nil`, it defaults to: `$time $metadata [$level] $levelpad$message\\n`\n\n  If you would like to make your own custom formatter simply pass\n  `{module, function}` to `compile/1` and the rest is handled.\n\n      iex> Logger.Formatter.compile(\"$time $metadata [$level] $message\\n\")\n      [:time, \" \", :metadata, \" [\", :level, \"] \", :message, \"\\n\"]\n  "
      },
      description = "\n  Conveniences for formatting data for logs.\n\n  This module allows developers to specify a string that\n  serves as template for log messages, for example:\n\n      $time $metadata[$level] $message\\n\n\n  Will print error messages as:\n\n      18:43:12.439 user_id=13 [error] Hello\\n\n\n  The valid parameters you can use are:\n\n    * `$time`     - time the log message was sent\n    * `$date`     - date the log message was sent\n    * `$message`  - the log message\n    * `$level`    - the log level\n    * `$node`     - the node that prints the message\n    * `$metadata` - user controlled data presented in `\"key=val key2=val2\"` format\n    * `$levelpad` - sets to a single space if level is 4 characters long,\n      otherwise set to the empty space. Used to align the message after level.\n\n  Backends typically allow developers to supply such control\n  strings via configuration files. This module provides `compile/1`,\n  which compiles the string into a format for fast operations at\n  runtime and `format/5` to format the compiled pattern into an\n  actual IO data.\n\n  ## Metadata\n\n  Metadata to be sent to the logger can be read and written with\n  the `Logger.metadata/0` and `Logger.metadata/1` functions. For example,\n  you can set `Logger.metadata([user_id: 13])` to add user_id metadata\n  to the current process. The user can configure the backend to chose\n  which metadata it wants to print and it will replace the `$metadata`\n  value.\n  ",
      format = {
        description = "@spec format({atom, atom} | [pattern | binary], Logger.level, Logger.message, time, Keyword.t) ::\n    IO.chardata\n  \nformat(config, level, msg, ts, md)\n\n  Takes a compiled format and injects the, level, timestamp, message and\n  metadata listdict and returns a properly formatted string.\n  "
      },
      pattern = {
        description = "pattern :: :date | :level | :levelpad | :message | :metadata | :node | :time\n"
      },
      prune = {
        description = "\nprune(_)\n\nprune([])\n\nprune([h | t])\n@spec prune(IO.chardata) :: IO.chardata\n  \nprune([h | t]) when h in 0..1114111, \n\n  Prunes non-valid UTF-8 codepoints.\n\n  Typically called after formatting when the data cannot be printed.\n  "
      },
      time = {
        description = "time :: {{1970..10000, 1..12, 1..31}, {0..23, 0..59, 0..59, 0..999}}\n"
      }
    },
    Translator = {
      description = "\n  Default translation for Erlang log messages.\n\n  Logger allows developers to rewrite log messages provided by\n  Erlang applications into a format more compatible with Elixir\n  log messages by providing a translator.\n\n  A translator is simply a tuple containing a module and a function\n  that can be added and removed via the `Logger.add_translator/1` and\n  `Logger.remove_translator/1` functions and is invoked for every Erlang\n  message above the minimum log level with four arguments:\n\n    * `min_level` - the current Logger level\n    * `level` - the level of the message being translated\n    * `kind` - if the message is a report or a format\n    * `message` - the message to format. If it is a report, it is a tuple\n      with `{report_type, report_data}`, if it is a format, it is a\n      tuple with `{format_message, format_args}`\n\n  The function must return:\n\n    * `{:ok, chardata}` - if the message was translated with its translation\n    * `:skip` - if the message is not meant to be translated nor logged\n    * `:none` - if there is no translation, which triggers the next translator\n\n  See the function `translate/4` in this module for an example implementation\n  and the default messages translated by Logger.\n  ",
      translate = {
        description = "\ntranslate(_min_level, _level, _kind, _message)\n\ntranslate(min_level, :info, :report, {:progress, data})\n\ntranslate(min_level, :error, :report, {:crash_report, data})\n\ntranslate(min_level, :error, :report, {:supervisor_report, data})\n\ntranslate(_min_level, :info, :report,\n                {:std_info, [application: app, exited: reason, type: _type]})\n\ntranslate(min_level, :error, :format, message)\n\ntranslate(min_level, level, kind, message)\n"
      }
    },
    Utils = {
      description = "false",
      format_date = {
        description = "\nformat_date({yy, mm, dd})\n\n  Formats date as chardata.\n  "
      },
      format_time = {
        description = "\nformat_time({hh, mi, ss, ms})\n\n  Formats time as chardata.\n  "
      },
      inspect = {
        description = "\ninspect(format, args, truncate, opts) when is_list(format) \n\ninspect(format, args, truncate, opts) when is_binary(format) \n\ninspect(format, args, truncate, opts) when is_atom(format) \n\ninspect(format, args, truncate, opts \\\\ %Inspect.Opts{})\n\n  Receives a format string and arguments and replace `~p`,\n  `~P`, `~w` and `~W` by its inspected variants.\n  "
      },
      timestamp = {
        description = "\ntimestamp(utc_log?)\n\n  Returns a timestamp that includes milliseconds.\n  "
      },
      truncate = {
        description = "@spec truncate(IO.chardata, non_neg_integer) :: IO.chardata\n  \ntruncate(chardata, n) when n >= 0 \n\n  Truncates a `chardata` into `n` bytes.\n\n  There is a chance we truncate in the middle of a grapheme\n  cluster but we never truncate in the middle of a binary\n  codepoint. For this reason, truncation is not exact.\n  "
      }
    },
    Watcher = {
      description = "false",
      handle_info = {
        description = "\nhandle_info(_msg, state)\n\nhandle_info({:gen_event_EXIT, handler, reason}, {mod, handler} = state)\n\nhandle_info({:gen_event_EXIT, handler, reason}, {_, handler} = state)\n      when reason in [:normal, :shut\nfalse"
      },
      init = {
        description = "\ninit({mod, handler, args})\nfalse"
      },
      start_link = {
        description = "\nstart_link(m, f, a)\n\n  Starts the watcher supervisor.\n  "
      },
      unwatch = {
        description = "\nunwatch(mod, handler)\n\n  Removes the given handler.\n  "
      },
      watch = {
        description = "\nwatch(mod, handler, args)\n\n  Watches the given handler as part of the watcher supervision tree.\n  "
      },
      watcher = {
        description = "\nwatcher(mod, handler, args)\n\n  Starts a watcher server.\n\n  This is useful when there is a need to start a handler\n  outside of the handler supervision tree.\n  "
      }
    },
    backend = {
      description = "backend :: :gen_event.handler\n"
    },
    compare_levels = {
      description = "@spec compare_levels(level, level) :: :lt | :eq | :gt\n  \ncompare_levels(left, right)\n\n  Compares log levels.\n\n  Receives two log levels and compares the `left`\n  against `right` and returns `:lt`, `:eq` or `:gt`.\n  "
    },
    debug = {
      description = "\ndebug(chardata_or_fun, metadata \\\\ [])\n\n  Logs a debug message.\n\n  Returns the atom `:ok` or an `{:error, reason}` tuple.\n\n  ## Examples\n\n      Logger.debug \"hello?\"\n      Logger.debug fn -> \"expensive to calculate debug\" end\n      Logger.debug fn -> {\"expensive to calculate debug\", [additional: :metadata]} end\n\n  "
    },
    description = "\n  A logger for Elixir applications.\n\n  It includes many features:\n\n    * Provides debug, info, warn and error levels.\n\n    * Supports multiple backends which are automatically\n      supervised when plugged into `Logger`.\n\n    * Formats and truncates messages on the client\n      to avoid clogging `Logger` backends.\n\n    * Alternates between sync and async modes to remain\n      performant when required but also apply backpressure\n      when under stress.\n\n    * Wraps OTP's `error_logger` to prevent it from\n      overflowing.\n\n  Logging is useful for tracking when an event of interest happens in your\n  system. For example, it may be helpful to log whenever a user is deleted.\n\n      def delete_user(user) do\n        Logger.info fn ->\n          \"Deleting user from the system: #{inspect(user)}\"\n        end\n        # ...\n      end\n\n  The `Logger.info/2` macro emits the provided message at the `:info`\n  level. There are additional macros for other levels. Notice the argument\n  passed to `Logger.info` in the above example is a zero argument function.\n\n  Although the Logger macros accept messages as strings as well as functions,\n  it's recommended to use functions whenever the message is expensive to\n  compute. In the example above, the message will be evaluated (and thus the\n  interpolation inside it) whatever the level is, even if the message will not\n  be actually logged at runtime; the only way of avoiding evaluation of such\n  message is purging the log call at compile-time through the\n  `:compile_time_purge_level` option (see below), or using a function that is\n  evaluated to generate the message only if the message needs to be logged\n  according to the runtime level.\n\n  ## Levels\n\n  The supported levels are:\n\n    * `:debug` - for debug-related messages\n    * `:info` - for information of any kind\n    * `:warn` - for warnings\n    * `:error` - for errors\n\n  ## Configuration\n\n  `Logger` supports a wide range of configurations.\n\n  This configuration is split in three categories:\n\n    * Application configuration - must be set before the `:logger`\n      application is started\n\n    * Runtime configuration - can be set before the `:logger`\n      application is started, but may be changed during runtime\n\n    * Error logger configuration - configuration for the\n      wrapper around OTP's `error_logger`\n\n  ### Application configuration\n\n  The following configuration must be set via config files (e.g.,\n  `config/config.exs`) before the `:logger` application is started.\n\n    * `:backends` - the backends to be used. Defaults to `[:console]`.\n      See the \"Backends\" section for more information.\n\n    * `:compile_time_purge_level` - purges *at compilation time* all calls that\n      have log level lower than the value of this option. This means that\n      `Logger` calls with level lower than this option will be completely\n      removed at compile time, accruing no overhead at runtime. Defaults to\n      `:debug` and only applies to the `Logger.debug/2`, `Logger.info/2`,\n      `Logger.warn/2`, and `Logger.error/2` macros (e.g., it doesn't apply to\n      `Logger.log/3`). Note that arguments passed to `Logger` calls that are\n      removed from the AST at compilation time are never evaluated, thus any\n      function call that occurs in these arguments is never executed. As a\n      consequence, avoid code that looks like `Logger.debug(\"Cleanup:\n      #{perform_cleanup()}\")` as in the example `perform_cleanup/0` won't be\n      executed if the `:compile_time_purge_level` is `:info` or higher.\n\n    * `:compile_time_application` - sets the `:application` metadata value\n      to the configured value at compilation time. This configuration is\n      usually only useful for build tools to automatically add the\n      application to the metadata for `Logger.debug/2`, `Logger.info/2`, etc.\n      style of calls.\n\n  For example, to configure the `:backends` and `compile_time_purge_level`\n  options in a `config/config.exs` file:\n\n      config :logger,\n        backends: [:console],\n        compile_time_purge_level: :info\n\n  ### Runtime Configuration\n\n  All configuration below can be set via config files (e.g.,\n  `config/config.exs`) but also changed dynamically during runtime via\n  `Logger.configure/1`.\n\n    * `:level` - the logging level. Attempting to log any message\n      with severity less than the configured level will simply\n      cause the message to be ignored. Keep in mind that each backend\n      may have its specific level, too. Note that, unlike what happens with the\n      `:compile_time_purge_level` option, the argument passed to `Logger` calls\n      is evaluated even if the level of the call is lower than\n      `:level`. For this reason, messages that are expensive to\n      compute should be wrapped in 0-arity anonymous functions that are\n      evaluated only when the `:label` option demands it.\n\n    * `:utc_log` - when `true`, uses UTC in logs. By default it uses\n      local time (i.e., it defaults to `false`).\n\n    * `:truncate` - the maximum message size to be logged (in bytes). Defaults\n      to 8192 bytes. Note this configuration is approximate. Truncated messages\n      will have `\" (truncated)\"` at the end.  The atom `:infinity` can be passed\n      to disable this behavior.\n\n    * `:sync_threshold` - if the `Logger` manager has more than\n      `:sync_threshold` messages in its queue, `Logger` will change\n      to *sync mode*, to apply backpressure to the clients.\n      `Logger` will return to *async mode* once the number of messages\n      in the queue is reduced to `sync_threshold * 0.75` messages.\n      Defaults to 20 messages.\n\n    * `:translator_inspect_opts` - when translating OTP reports and\n      errors, the last message and state must be inspected in the\n      error reports. This configuration allow developers to change\n      how much and how the data should be inspected.\n\n  For example, to configure the `:level` and `:truncate` options in a\n  `config/config.exs` file:\n\n      config :logger,\n        level: :warn,\n        truncate: 4096\n\n  ### Error logger configuration\n\n  The following configuration applies to `Logger`'s wrapper around\n  Erlang's `error_logger`. All the configurations below must be set\n  before the `:logger` application starts.\n\n    * `:handle_otp_reports` - redirects OTP reports to `Logger` so\n      they are formatted in Elixir terms. This uninstalls Erlang's\n      logger that prints terms to terminal. Defaults to `true`.\n\n    * `:handle_sasl_reports` - redirects supervisor, crash and\n      progress reports to `Logger` so they are formatted in Elixir\n      terms. This uninstalls `sasl`'s logger that prints these\n      reports to the terminal. Defaults to `false`.\n\n    * `:discard_threshold_for_error_logger` - a value that, when\n      reached, triggers the error logger to discard messages. This\n      value must be a positive number that represents the maximum\n      number of messages accepted per second. Once above this\n      threshold, the `error_logger` enters discard mode for the\n      remainder of that second. Defaults to 500 messages.\n\n  For example, to configure `Logger` to redirect all `error_logger` messages\n  using a `config/config.exs` file:\n\n      config :logger,\n        handle_otp_reports: true,\n        handle_sasl_reports: true\n\n  Furthermore, `Logger` allows messages sent by Erlang's `error_logger`\n  to be translated into an Elixir format via translators. Translators\n  can be dynamically added at any time with the `add_translator/1`\n  and `remove_translator/1` APIs. Check `Logger.Translator` for more\n  information.\n\n  ## Backends\n\n  `Logger` supports different backends where log messages are written to.\n\n  The available backends by default are:\n\n    * `:console` - logs messages to the console (enabled by default)\n\n  Developers may also implement their own backends, an option that\n  is explored in more detail below.\n\n  The initial backends are loaded via the `:backends` configuration,\n  which must be set before the `:logger` application is started.\n\n  ### Console backend\n\n  The console backend logs messages by printing them to the console. It supports\n  the following options:\n\n    * `:level` - the level to be logged by this backend.\n      Note that messages are filtered by the general\n      `:level` configuration for the `:logger` application first.\n\n    * `:format` - the format message used to print logs.\n      Defaults to: `\"$time $metadata[$level] $levelpad$message\\n\"`.\n\n    * `:metadata` - the metadata to be printed by `$metadata`.\n      Defaults to an empty list (no metadata).\n\n    * `:colors` - a keyword list of coloring options.\n\n    * `:device` - the device to log error messages to. Defaults to\n      `:user` but can be changed to something else such as `:standard_error`.\n\n    * `:max_buffer` - maximum events to buffer while waiting\n      for a confirmation from the IO device (default: 32).\n      Once the buffer is full, the backend will block until\n      a confirmation is received.\n\n  In addition to the keys provided by the user via `Logger.metadata/1`,\n  the following extra keys are available to the `:metadata` list:\n\n    * `:application` - the current application\n\n    * `:module` - the current module\n\n    * `:function` - the current function\n\n    * `:file` - the current file\n\n    * `:line` - the current line\n\n  The supported keys in the `:colors` keyword list are:\n\n    * `:enabled` - boolean value that allows for switching the\n      coloring on and off. Defaults to: `IO.ANSI.enabled?/0`\n\n    * `:debug` - color for debug messages. Defaults to: `:cyan`\n\n    * `:info` - color for info messages. Defaults to: `:normal`\n\n    * `:warn` - color for warn messages. Defaults to: `:yellow`\n\n    * `:error` - color for error messages. Defaults to: `:red`\n\n  See the `IO.ANSI` module for a list of colors and attributes.\n\n  Here is an example of how to configure the `:console` backend in a\n  `config/config.exs` file:\n\n      config :logger, :console,\n        format: \"\\n$time $metadata[$level] $levelpad$message\\n\"\n        metadata: [:user_id]\n\n  You can read more about formatting in `Logger.Formatter`.\n\n  ### Custom backends\n\n  Any developer can create their own `Logger` backend.\n  Since `Logger` is an event manager powered by `:gen_event`,\n  writing a new backend is a matter of creating an event\n  handler, as described in the [`:gen_event`](http://erlang.org/doc/man/gen_event.html)\n  documentation.\n\n  From now on, we will be using the term \"event handler\" to refer\n  to your custom backend, as we head into implementation details.\n\n  Once the `:logger` application starts, it installs all event handlers listed under\n  the `:backends` configuration into the `Logger` event manager. The event\n  manager and all added event handlers are automatically supervised by `Logger`.\n\n  Once initialized, the handler should be designed to handle events\n  in the following format:\n\n      {level, group_leader, {Logger, message, timestamp, metadata}} | :flush\n\n  where:\n\n    * `level` is one of `:debug`, `:info`, `:warn`, or `:error`, as previously\n      described\n    * `group_leader` is the group leader of the process which logged the message\n    * `{Logger, message, timestamp, metadata}` is a tuple containing information\n      about the logged message:\n      * the first element is always the atom `Logger`\n      * `message` is the actual message (as chardata)\n      * `timestamp` is the timestamp for when the message was logged, as a\n        `{{year, month, day}, {hour, minute, second, millisecond}}` tuple\n      * `metadata` is a keyword list of metadata used when logging the message\n\n  It is recommended that handlers ignore messages where\n  the group leader is in a different node than the one where\n  the handler is installed. For example:\n\n      def handle_event({_level, gl, {Logger, _, _, _}}, state)\n          when node(gl) != node() do\n        {:ok, state}\n      end\n\n  In the case of the event `:flush` handlers should flush any pending data. This\n  event is triggered by `flush/0`.\n\n  Furthermore, backends can be configured via the\n  `configure_backend/2` function which requires event handlers\n  to handle calls of the following format:\n\n      {:configure, options}\n\n  where `options` is a keyword list. The result of the call is\n  the result returned by `configure_backend/2`. The recommended\n  return value for successful configuration is `:ok`.\n\n  It is recommended that backends support at least the following\n  configuration options:\n\n    * `:level` - the logging level for that backend\n    * `:format` - the logging format for that backend\n    * `:metadata` - the metadata to include in that backend\n\n  Check the implementation for `Logger.Backends.Console`, for\n  examples on how to handle the recommendations in this section\n  and how to process the existing options.\n  ",
    error = {
      description = "\nerror(chardata_or_fun, metadata \\\\ [])\n\n  Logs an error.\n\n  Returns the atom `:ok` or an `{:error, reason}` tuple.\n\n  ## Examples\n\n      Logger.error \"oops\"\n      Logger.error fn -> \"expensive to calculate error\" end\n      Logger.error fn -> {\"expensive to calculate error\", [additional: :metadata]} end\n\n  "
    },
    info = {
      description = "\ninfo(chardata_or_fun, metadata \\\\ [])\n\n  Logs some info.\n\n  Returns the atom `:ok` or an `{:error, reason}` tuple.\n\n  ## Examples\n\n      Logger.info \"mission accomplished\"\n      Logger.info fn -> \"expensive to calculate info\" end\n      Logger.info fn -> {\"expensive to calculate info\", [additional: :metadata]} end\n\n  "
    },
    level = {
      description = "level :: :error | :info | :warn | :debug\n"
    },
    log = {
      description = "\nlog(level, chardata_or_fun, metadata \\\\ [])\n\n  Logs a message.\n\n  Returns the atom `:ok` or an `{:error, reason}` tuple.\n\n  Developers should use the macros `Logger.debug/2`,\n  `Logger.warn/2`, `Logger.info/2` or `Logger.error/2` instead\n  of this macro as they can automatically eliminate\n  the Logger call altogether at compile time if desired.\n  "
    },
    message = {
      description = "message :: IO.chardata | String.Chars.t\n"
    },
    metadata = {
      description = "metadata :: Keyword.t(String.Chars.t)\n"
    },
    warn = {
      description = "@spec bare_log(level, message | (() -> message | {message, Keyword.t}), Keyword.t) ::\n        :ok | {:error, :noproc} | {:error, term}\n  \nwarn(chardata_or_fun, metadata \\\\ [])\n\n  Logs a warning.\n\n  Returns the atom `:ok` or an `{:error, reason}` tuple.\n\n  ## Examples\n\n      Logger.warn \"knob turned too far to the right\"\n      Logger.warn fn -> \"expensive to calculate warning\" end\n      Logger.warn fn -> {\"expensive to calculate warning\", [additional: :metadata]} end\n\n  "
    }
  },
  M = {
    __info__ = {
      description = "\n__info__(kind)\n\n  Provides runtime information about functions and macros defined by the\n  module, enables docstring extraction, etc.\n\n  Each module gets an `__info__/1` function when it's compiled. The function\n  takes one of the following atoms:\n\n    * `:functions`  - keyword list of public functions along with their arities\n\n    * `:macros`     - keyword list of public macros along with their arities\n\n    * `:module`     - module name (`Module == Module.__info__(:module)`)\n\n  In addition to the above, you may also pass to `__info__/1` any atom supported\n  by `:erlang.module_info/0` which also gets defined for each compiled module.\n\n  For a list of supported attributes and more information, see [Modules – Erlang Reference Manual](http://www.erlang.org/doc/reference_manual/modules.html#id77056).\n  "
    },
    add_doc = {
      description = "\nadd_doc(module, line, kind, tuple, signature, doc) when\n      kind in [:def, :defmacro, :type, :opaque] and (is_binary(\n\nadd_doc(_module, _line, kind, _tuple, _signature, doc) when kind in [:defp, :defmacrop, :typep] \n@spec safe_concat(binary | atom, binary | atom) :: atom | no_return\n  \nadd_doc(module, line, kind, tuple, signature \\\\ [], doc)\n\n  Attaches documentation to a given function or type.\n\n  It expects the module the function/type belongs to, the line (a non\n  negative integer), the kind (`def` or `defmacro`), a tuple representing\n  the function and its arity, the function signature (the signature\n  should be omitted for types) and the documentation, which should\n  be either a binary or a boolean.\n\n  ## Examples\n\n      defmodule MyModule do\n        Module.add_doc(__MODULE__, __ENV__.line + 1, :def, {:version, 0}, [], \"Manually added docs\")\n        def version, do: 1\n      end\n\n  "
    },
    compile_doc = {
      description = "\ncompile_doc(env, kind, name, args, _guards, _body)\nfalse"
    },
    create = {
      description = "\ncreate(module, quoted, opts) when is_atom(module) and is_list(opts) \n\ncreate(module, quoted, %Macro.Env{} = env)\n\ncreate(module, quoted, opts)\n\n  Creates a module with the given name and defined by\n  the given quoted expressions.\n\n  The line where the module is defined and its file **must**\n  be passed as options.\n\n  ## Examples\n\n      contents =\n        quote do\n          def world, do: true\n        end\n\n      Module.create(Hello, contents, Macro.Env.location(__ENV__))\n\n      Hello.world #=> true\n\n  ## Differences from `defmodule`\n\n  `Module.create/3` works similarly to `defmodule` and\n  return the same results. While one could also use\n  `defmodule` to define modules dynamically, this\n  function is preferred when the module body is given\n  by a quoted expression.\n\n  Another important distinction is that `Module.create/3`\n  allows you to control the environment variables used\n  when defining the module, while `defmodule` automatically\n  shares the same environment.\n  "
    },
    ["defines?"] = {
      description = "\ndefines?(module, tuple, kind)\n  Checks if the module defines a function or macro of the\n  given `kind`.\n\n  `kind` can be any of `:def`, `:defp`, `:defmacro` or `:defmacrop`.\n\n  This function can only be used on modules that have not yet been compiled.\n  Use `Kernel.function_exported?/3` to check compiled modules.\n\n  ## Examples\n\n      defmodule Example do\n        Module.defines? __MODULE__, {:version, 0}, :defp #=> false\n        def version, do: 1\n        Module.defines? __MODULE__, {:version, 0}, :defp #=> false\n      end\n\n  \n\ndefines?(module, tuple) when is_tuple(tuple) \n\n  Checks if the module defines the given function or macro.\n\n  Use `defines?/3` to assert for a specific type.\n\n  This function can only be used on modules that have not yet been compiled.\n  Use `Kernel.function_exported?/3` to check compiled modules.\n\n  ## Examples\n\n      defmodule Example do\n        Module.defines? __MODULE__, {:version, 0} #=> false\n        def version, do: 1\n        Module.defines? __MODULE__, {:version, 0} #=> true\n      end\n\n  "
    },
    definitions_in = {
      description = "\ndefinitions_in(module, kind)\n  Returns all functions defined in `module`, according\n  to its kind.\n\n  ## Examples\n\n      defmodule Example do\n        def version, do: 1\n        Module.definitions_in __MODULE__, :def  #=> [{:version, 0}]\n        Module.definitions_in __MODULE__, :defp #=> []\n      end\n\n  \n\ndefinitions_in(module)\n\n  Returns all functions defined in `module`.\n\n  ## Examples\n\n      defmodule Example do\n        def version, do: 1\n        Module.definitions_in __MODULE__ #=> [{:version, 0}]\n      end\n\n  "
    },
    description = "\n        A very useful module\n        ",
    eval_quoted = {
      description = "\neval_quoted(module, quoted, binding, opts)\n\neval_quoted(module, quoted, binding, %Macro.Env{} = env)\n\neval_quoted(%Macro.Env{} = env, quoted, binding, opts)\n\neval_quoted(module_or_env, quoted, binding \\\\ [], opts \\\\ [])\n\n  Evaluates the quoted contents in the given module's context.\n\n  A list of environment options can also be given as argument.\n  See `Code.eval_string/3` for more information.\n\n  Raises an error if the module was already compiled.\n\n  ## Examples\n\n      defmodule Foo do\n        contents = quote do: (def sum(a, b), do: a + b)\n        Module.eval_quoted __MODULE__, contents\n      end\n\n      Foo.sum(1, 2) #=> 3\n\n  For convenience, you can pass any `Macro.Env` struct, such\n  as  `__ENV__/0`, as the first argument or as options. Both\n  the module and all options will be automatically extracted\n  from the environment:\n\n      defmodule Foo do\n        contents = quote do: (def sum(a, b), do: a + b)\n        Module.eval_quoted __ENV__, contents\n      end\n\n      Foo.sum(1, 2) #=> 3\n\n  Note that if you pass a `Macro.Env` struct as first argument\n  while also passing `opts`, they will be merged with `opts`\n  having precedence.\n  "
    },
    get_attribute = {
      description = "\nget_attribute(module, key, stack) when is_atom(key) \nfalse"
    },
    hello = {
      description = "\nhello(_)\n\nhello(arg) when is_binary(arg) or is_list(arg) \n\nhello\n\nhello\nfalse"
    },
    load_check = {
      description = "\nload_check\n"
    },
    make_overridable = {
      description = "\nmake_overridable(module, tuples)\n\n  Makes the given functions in `module` overridable.\n\n  An overridable function is lazily defined, allowing a\n  developer to customize it. See `Kernel.defoverridable/1` for\n  more information and documentation.\n  "
    },
    my_fun = {
      description = "\nmy_fun(arg)\n\nmy_fun(arg)\n"
    },
    ["open?"] = {
      description = "\nopen?(module)\n\n  Checks if a module is open, i.e. it is currently being defined\n  and its attributes and functions can be modified.\n  "
    },
    ["overridable?"] = {
      description = "\noverridable?(module, tuple)\n\n  Returns `true` if `tuple` in `module` is marked as overridable.\n  "
    },
    put_attribute = {
      description = "\nput_attribute(module, key, value, stack, unread_line) when is_atom(key) \nfalse"
    },
    register_attribute = {
      description = "@spec delete_attribute(module, key :: atom) :: (value :: term)\n  \nregister_attribute(module, new, opts) when is_atom(new) \n\n  Registers an attribute.\n\n  By registering an attribute, a developer is able to customize\n  how Elixir will store and accumulate the attribute values.\n\n  ## Options\n\n  When registering an attribute, two options can be given:\n\n    * `:accumulate` - several calls to the same attribute will\n      accumulate instead of override the previous one. New attributes\n      are always added to the top of the accumulated list.\n\n    * `:persist` - the attribute will be persisted in the Erlang\n      Abstract Format. Useful when interfacing with Erlang libraries.\n\n  By default, both options are `false`.\n\n  ## Examples\n\n      defmodule MyModule do\n        Module.register_attribute __MODULE__,\n          :custom_threshold_for_lib,\n          accumulate: true, persist: false\n\n        @custom_threshold_for_lib 10\n        @custom_threshold_for_lib 20\n        @custom_threshold_for_lib #=> [20, 10]\n      end\n\n  "
    },
    some_condition = {
      description = "\nsome_condition\n"
    },
    split = {
      description = "\nsplit(\"Elixir.\" <> name)\n\nsplit(module) when is_atom(module) \n\n  Splits the given module name into binary parts.\n\n  ## Examples\n\n      iex> Module.split Very.Long.Module.Name.And.Even.Longer\n      [\"Very\", \"Long\", \"Module\", \"Name\", \"And\", \"Even\", \"Longer\"]\n\n  "
    },
    store_typespec = {
      description = "\nstore_typespec(module, key, value) when is_atom(key) \nfalse"
    },
    sum = {
      description = "\nsum(a, b)\n\n        Sums `a` to `b`.\n        "
    }
  },
  Macro = {
    Env = {
      __struct__ = {
        description = "\n__struct__(kv)\n\n__struct__\n"
      },
      aliases = {
        description = "aliases :: [{module, module}]\n"
      },
      context = {
        description = "context :: :match | :guard | nil\n"
      },
      context_modules = {
        description = "context_modules :: [module]\n"
      },
      description = "\n  A struct that holds compile time environment information.\n\n  The current environment can be accessed at any time as\n  `__ENV__/0`. Inside macros, the caller environment can be\n  accessed as `__CALLER__/0`.\n\n  An instance of `Macro.Env` must not be modified by hand. If you need to\n  create a custom environment to pass to `Code.eval_quoted/3`, use the\n  following trick:\n\n      def make_custom_env do\n        import SomeModule, only: [some_function: 2]\n        alias A.B.C\n        __ENV__\n      end\n\n  You may then call `make_custom_env()` to get a struct with the desired\n  imports and aliases included.\n\n  It contains the following fields:\n\n    * `module` - the current module name\n    * `file` - the current file name as a binary\n    * `line` - the current line as an integer\n    * `function` - a tuple as `{atom, integer}`, where the first\n      element is the function name and the second its arity; returns\n      `nil` if not inside a function\n    * `context` - the context of the environment; it can be `nil`\n      (default context), inside a guard or inside a match\n    * `aliases` -  a list of two-element tuples, where the first\n      element is the aliased name and the second one the actual name\n    * `requires` - the list of required modules\n    * `functions` - a list of functions imported from each module\n    * `macros` - a list of macros imported from each module\n    * `macro_aliases` - a list of aliases defined inside the current macro\n    * `context_modules` - a list of modules defined in the current context\n    * `vars` - a list keeping all defined variables as `{var, context}`\n    * `export_vars` - a list keeping all variables to be exported in a\n      construct (may be `nil`)\n    * `lexical_tracker` - PID of the lexical tracker which is responsible for\n      keeping user info\n  ",
      export_vars = {
        description = "export_vars :: vars | nil\n"
      },
      file = {
        description = "file :: binary\n"
      },
      functions = {
        description = "functions :: [{module, [name_arity]}]\n"
      },
      ["in_guard?"] = {
        description = "@spec in_guard?(t) :: boolean\n  \nin_guard?(%{__struct__: Macro.Env, context: context})\n\n  Returns whether the compilation environment is currently\n  inside a guard.\n  "
      },
      ["in_match?"] = {
        description = "@spec in_match?(t) :: boolean\n  \nin_match?(%{__struct__: Macro.Env, context: context})\n\n  Returns whether the compilation environment is currently\n  inside a match clause.\n  "
      },
      lexical_tracker = {
        description = "lexical_tracker :: pid\n"
      },
      line = {
        description = "line :: non_neg_integer\n"
      },
      ["local"] = {
        description = "local :: atom | nil\n"
      },
      location = {
        description = "@spec location(t) :: Keyword.t\n  \nlocation(%{__struct__: Macro.Env, file: file, line: line})\n\n  Returns a keyword list containing the file and line\n  information as keys.\n  "
      },
      macro_aliases = {
        description = "macro_aliases :: [{module, {integer, module}}]\n"
      },
      macros = {
        description = "macros :: [{module, [name_arity]}]\n"
      },
      name_arity = {
        description = "name_arity :: {atom, arity}\n"
      },
      requires = {
        description = "requires :: [module]\n"
      },
      t = {
        description = "t :: %{__struct__: __MODULE__,\n"
      },
      vars = {
        description = "vars :: [{atom, atom | non_neg_integer}]\n"
      }
    },
    binary_ops = {
      description = "\nbinary_ops\nfalse"
    },
    camelize = {
      description = "\ncamelize(<<h, t::binary>>)\n\ncamelize(<<?_, t::binary>>)\n@spec camelize(String.t) :: String.t\n  \ncamelize(\"\")\n\n  Converts the given string to CamelCase format.\n\n  This function was designed to camelize language identifiers/tokens,\n  that's why it belongs to the `Macro` module. Do not use it as a general\n  mechanism for camelizing strings as it does not support Unicode or\n  characters that are not valid in Elixir identifiers.\n\n  ## Examples\n\n      iex> Macro.camelize \"foo_bar\"\n      \"FooBar\"\n\n  "
    },
    classify_identifier = {
      description = "\nclassify_identifier(string) when is_binary(string) \n@spec binary_op_props(atom) :: {:left | :right, precedence :: integer}\n  defp binary_op_props(o) do\n    case o do\n      o when o in [:<-, :\\\\]                  -> {:left,  40}\n      :when                                   -> {:right, 50}\n      :::                                     -> {:right, 60}\n      :|                                      -> {:right, 70}\n      :=                                      -> {:right, 90}\n      o when o in [:||, :|||, :or]            -> {:left, 130}\n      o when o in [:&&, :&&&, :and]           -> {:left, 140}\n      o when o in [:==, :!=, :=~, :===, :!==] -> {:left, 150}\n      o when o in [:<, :<=, :>=, :>]          -> {:left, 160}\n      o when o in [:|>, :<<<, :>>>, :<~, :~>,\n                :<<~, :~>>, :<~>, :<|>, :^^^] -> {:left, 170}\n      :in                                     -> {:left, 180}\n      o when o in [:++, :--, :.., :<>]        -> {:right, 200}\n      o when o in [:+, :-]                    -> {:left, 210}\n      o when o in [:*, :/]                    -> {:left, 220}\n      :.                                      -> {:left, 310}\n    end\n  end\n\n  # Classifies the given atom or string into one of the following categories:\n  #\n  #   * :alias - a valid Elixir alias, like Foo, Foo.Bar and so on\n  #\n  #   * :callable - an atom that can be used as a function call after the\n  #     . operator (for example, :<> is callable because Foo.<>(1, 2, 3) is valid\n  #     syntax); this category includes identifiers like :foo\n  #\n  #   * :not_callable - an atom that cannot be used as a function call after the\n  #     . operator (for example, :<<>> is not callable because Foo.<<>> is a\n  #     syntax error); this category includes atoms like :Foo, since they are\n  #     valid identifiers but they need quotes to be used in function calls\n  #     (Foo.\"Bar\")\n  #\n  #   * :atom - any other atom (these are usually escaped when inspected, like\n  #     :\"foo and bar\")\n  @doc false\n  \nclassify_identifier(atom) when is_atom(atom) \n"
    },
    decompose_call = {
      description = "\ndecompose_call(_)\n\ndecompose_call({name, _, args}) when is_atom(name) and is_list(args),\n    \n\ndecompose_call({name, _, args}) when is_atom(name) and is_atom(args),\n    \n@spec decompose_call(Macro.t) :: {atom, [Macro.t]} | {Macro.t, atom, [Macro.t]} | :error\n  \ndecompose_call({{:., _, [remote, function]}, _, args}) when is_tuple(remote) or is_atom(remote),\n    \n\n  Decomposes a local or remote call into its remote part (when provided),\n  function name and argument list.\n\n  Returns `:error` when an invalid call syntax is provided.\n\n  ## Examples\n\n      iex> Macro.decompose_call(quote(do: foo))\n      {:foo, []}\n\n      iex> Macro.decompose_call(quote(do: foo()))\n      {:foo, []}\n\n      iex> Macro.decompose_call(quote(do: foo(1, 2, 3)))\n      {:foo, [1, 2, 3]}\n\n      iex> Macro.decompose_call(quote(do: Elixir.M.foo(1, 2, 3)))\n      {{:__aliases__, [], [:Elixir, :M]}, :foo, [1, 2, 3]}\n\n      iex> Macro.decompose_call(quote(do: 42))\n      :error\n\n  "
    },
    description = "\n  Conveniences for working with macros.\n\n  ## Custom Sigils\n\n  To create a custom sigil, define a function with the name\n  `sigil_{identifier}` that takes two arguments. The first argument will be\n  the string, the second will be a charlist containing any modifiers. If the\n  sigil is lower case (such as `sigil_x`) then the string argument will allow\n  interpolation. If the sigil is upper case (such as `sigil_X`) then the string\n  will not be interpolated.\n\n  Valid modifiers include only lower and upper case letters. Other characters\n  will cause a syntax error.\n\n  The module containing the custom sigil must be imported before the sigil\n  syntax can be used.\n\n  ### Examples\n\n      defmodule MySigils do\n        defmacro sigil_x(term, [?r]) do\n          quote do\n            unquote(term) |> String.reverse()\n          end\n        end\n        defmacro sigil_x(term, _modifiers) do\n          term\n        end\n        defmacro sigil_X(term, [?r]) do\n          quote do\n            unquote(term) |> String.reverse()\n          end\n        end\n        defmacro sigil_X(term, _modifiers) do\n          term\n        end\n      end\n\n      import MySigils\n\n      ~x(with #{\"inter\" <> \"polation\"})\n      #=>\"with interpolation\"\n\n      ~x(with #{\"inter\" <> \"polation\"})r\n      #=>\"noitalopretni htiw\"\n\n      ~X(without #{\"interpolation\"})\n      #=>\"without \\#{\"interpolation\"}\"\n\n      ~X(without #{\"interpolation\"})r\n      #=>\"}\\\"noitalopretni\\\"{# tuohtiw\"\n  ",
    expand = {
      description = "\nexpand(tree, env)\n\n  Receives an AST node and expands it until it can no longer\n  be expanded.\n\n  This function uses `expand_once/2` under the hood. Check\n  it out for more information and examples.\n  "
    },
    expand_once = {
      description = "\nexpand_once(ast, env)\n\n  Receives an AST node and expands it once.\n\n  The following contents are expanded:\n\n    * Macros (local or remote)\n    * Aliases are expanded (if possible) and return atoms\n    * Compilation environment macros (`__ENV__/0`, `__MODULE__/0` and `__DIR__/0`)\n    * Module attributes reader (`@foo`)\n\n  If the expression cannot be expanded, it returns the expression\n  itself. Notice that `expand_once/2` performs the expansion just\n  once and it is not recursive. Check `expand/2` for expansion\n  until the node can no longer be expanded.\n\n  ## Examples\n\n  In the example below, we have a macro that generates a module\n  with a function named `name_length` that returns the length\n  of the module name. The value of this function will be calculated\n  at compilation time and not at runtime.\n\n  Consider the implementation below:\n\n      defmacro defmodule_with_length(name, do: block) do\n        length = length(Atom.to_charlist(name))\n\n        quote do\n          defmodule unquote(name) do\n            def name_length, do: unquote(length)\n            unquote(block)\n          end\n        end\n      end\n\n  When invoked like this:\n\n      defmodule_with_length My.Module do\n        def other_function, do: ...\n      end\n\n  The compilation will fail because `My.Module` when quoted\n  is not an atom, but a syntax tree as follow:\n\n      {:__aliases__, [], [:My, :Module]}\n\n  That said, we need to expand the aliases node above to an\n  atom, so we can retrieve its length. Expanding the node is\n  not straight-forward because we also need to expand the\n  caller aliases. For example:\n\n      alias MyHelpers, as: My\n\n      defmodule_with_length My.Module do\n        def other_function, do: ...\n      end\n\n  The final module name will be `MyHelpers.Module` and not\n  `My.Module`. With `Macro.expand/2`, such aliases are taken\n  into consideration. Local and remote macros are also\n  expanded. We could rewrite our macro above to use this\n  function as:\n\n      defmacro defmodule_with_length(name, do: block) do\n        expanded = Macro.expand(name, __CALLER__)\n        length   = length(Atom.to_charlist(expanded))\n\n        quote do\n          defmodule unquote(name) do\n            def name_length, do: unquote(length)\n            unquote(block)\n          end\n        end\n      end\n\n  "
    },
    expr = {
      description = "expr :: {expr | atom, Keyword.t, atom | [t]}\n"
    },
    generate_arguments = {
      description = "\ngenerate_arguments(amount, context) when is_integer(amount) and amount > 0 and is_atom(context) \n\ngenerate_arguments(0, _)\n\n  Generates AST nodes for a given number of required argument variables using\n  `Macro.var/2`.\n\n  ## Examples\n\n      iex> Macro.generate_arguments(2, __MODULE__)\n      [{:var1, [], __MODULE__}, {:var2, [], __MODULE__}]\n\n  "
    },
    pipe = {
      description = "\npipe(expr, call_args, _integer)\n\npipe(expr, {call, line, args}, integer) when is_list(args) \n\npipe(expr, {call, line, atom}, integer) when is_atom(atom) \n\npipe(expr, {:fn, _, _}, _integer)\n\npipe(expr, {call, _, [_, _]} = call_args, _integer)\n      when call in unquote(@binary_ops) \n\npipe(expr, {:__aliases__, _, _} = call_args, _integer)\n\npipe(expr, {tuple_or_map, _, _} = call_args, _integer) when tuple_or_map in [:{}, :%{}] \n@spec pipe(Macro.t, Macro.t, integer) :: Macro.t | no_return\n  \npipe(expr, {:&, _, _} = call_args, _integer)\n\n  Pipes `expr` into the `call_args` at the given `position`.\n  "
    },
    pipe_warning = {
      description = "\npipe_warning(_)\n\npipe_warning({call, _, _}) when call in unquote(@unary_ops) \nfalse"
    },
    t = {
      description = "t :: expr | {t, t} | atom | number | binary | pid | fun | [t]\n"
    },
    to_string = {
      description = "\nto_string(other, fun)\n\nto_string(list, fun) when is_list(list) \n\nto_string({left, right}, fun)\n\nto_string({target, _, args} = ast, fun) when is_list(args) \n\nto_string({{:., _, [Access, :get]}, _, [left, right]} = ast, fun)\n\nto_string({{:., _, [Access, :get]}, _, [{op, _, _} = left, right]} = ast, fun)\n      when op in unquote(@binary_ops) \n\nto_string({op, _, [arg]} = ast, fun) when op in unquote(@unary_ops) \n\nto_string({:not, _, [arg]} = ast, fun)\n\nto_string({unary, _, [{binary, _, [_, _]} = arg]} = ast, fun)\n      when unary in unquote(@unary_ops) and binary in unquote(@binary_ops) \n\nto_string({:not, _, [{:in, _, [left, right]}]} = ast, fun)\n\nto_string({:&, _, [arg]} = ast, fun) when not is_integer(arg) \n\nto_string({:&, _, [{:/, _, [{{:., _, [mod, name]}, _, []}, arity]}]} = ast, fun)\n      when is_atom(name) and is_integer(arity) \n\nto_string({:&, _, [{:/, _, [{name, _, ctx}, arity]}]} = ast, fun)\n      when is_atom(name) and is_atom(ctx) and is_integer(arity) \n\nto_string({:when, _, args} = ast, fun)\n\nto_string({op, _, [left, right]} = ast, fun) when op in unquote(@binary_ops) \n\nto_string({:when, _, [left, right]} = ast, fun)\n\nto_string([{:->, _, _} | _] = ast, fun)\n\nto_string({:.., _, args} = ast, fun)\n\nto_string({:fn, _, block} = ast, fun)\n\nto_string({:fn, _, [{:->, _, _}] = block} = ast, fun)\n\nto_string({:fn, _, [{:->, _, [_, tuple]}] = arrow} = ast, fun)\n      when not is_tuple(tuple) or elem(tuple, 0) != :__block__ \n\nto_string({:%, _, [structname, map]} = ast, fun)\n\nto_string({:%{}, _, args} = ast, fun)\n\nto_string({:{}, _, args} = ast, fun)\n\nto_string({:<<>>, _, parts} = ast, fun)\n\nto_string({:__block__, _, _} = ast, fun)\n\nto_string({:__block__, _, [expr]} = ast, fun)\n\nto_string({:__aliases__, _, refs} = ast, fun)\n@spec to_string(Macro.t) :: String.t\n  @spec to_string(Macro.t, (Macro.t, String.t -> String.t)) :: String.t\n  \nto_string({var, _, atom} = ast, fun) when is_atom(atom) \n\n  Converts the given expression to a binary.\n\n  The given `fun` is called for every node in the AST with two arguments: the\n  AST of the node being printed and the string representation of that same\n  node. The return value of this function is used as the final string\n  representation for that AST node.\n\n  ## Examples\n\n      iex> Macro.to_string(quote(do: foo.bar(1, 2, 3)))\n      \"foo.bar(1, 2, 3)\"\n\n      iex> Macro.to_string(quote(do: 1 + 2), fn\n      ...>   1, _string -> \"one\"\n      ...>   2, _string -> \"two\"\n      ...>   _ast, string -> string\n      ...> end)\n      \"one + two\"\n\n  "
    },
    unary_ops = {
      description = "\nunary_ops\nfalse"
    },
    underscore = {
      description = "\nunderscore(<<h, t::binary>>)\n\nunderscore(\"\")\n\nunderscore(atom) when is_atom(atom) \n\n  Converts the given atom or binary to underscore format.\n\n  If an atom is given, it is assumed to be an Elixir module,\n  so it is converted to a binary and then processed.\n\n  This function was designed to underscore language identifiers/tokens,\n  that's why it belongs to the `Macro` module. Do not use it as a general\n  mechanism for underscoring strings as it does not support Unicode or\n  characters that are not valid in Elixir identifiers.\n\n  ## Examples\n\n      iex> Macro.underscore \"FooBar\"\n      \"foo_bar\"\n\n      iex> Macro.underscore \"Foo.Bar\"\n      \"foo/bar\"\n\n      iex> Macro.underscore Foo.Bar\n      \"foo/bar\"\n\n  In general, `underscore` can be thought of as the reverse of\n  `camelize`, however, in some cases formatting may be lost:\n\n      iex> Macro.underscore \"SAPExample\"\n      \"sap_example\"\n\n      iex> Macro.camelize \"sap_example\"\n      \"SapExample\"\n\n      iex> Macro.camelize \"hello_10\"\n      \"Hello10\"\n\n  "
    },
    update_meta = {
      description = "\nupdate_meta(other, _fun)\n@spec update_meta(t, (Keyword.t -> Keyword.t)) :: t\n  \nupdate_meta({left, meta, right}, fun) when is_list(meta) \n\n  Applies the given function to the node metadata if it contains one.\n\n  This is often useful when used with `Macro.prewalk/2` to remove\n  information like lines and hygienic counters from the expression\n  for either storage or comparison.\n\n  ## Examples\n\n      iex> quoted = quote line: 10, do: sample()\n      {:sample, [line: 10], []}\n      iex> Macro.update_meta(quoted, &Keyword.delete(&1, :line))\n      {:sample, [], []}\n\n  "
    }
  },
  Map = {
    description = "\n  A set of functions for working with maps.\n\n  Maps are the \"go to\" key-value data structure in Elixir. Maps can be created\n  with the `%{}` syntax, and key-value pairs can be expressed as `key => value`:\n\n      iex> %{}\n      %{}\n      iex> %{\"one\" => :two, 3 => \"four\"}\n      %{3 => \"four\", \"one\" => :two}\n\n  Key-value pairs in a map do not follow any order (that's why the printed map\n  in the example above has a different order than the map that was created).\n\n  Maps do not impose any restriction on the key type: anything can be a key in a\n  map. As a key-value structure, maps do not allow duplicated keys. Keys are\n  compared using the exact-equality operator (`===`). If colliding keys are defined\n  in a map literal, the last one prevails.\n\n  When the key in a key-value pair is an atom, the `key: value` shorthand syntax\n  can be used (as in many other special forms), provided key-value pairs are put at\n  the end:\n\n      iex> %{\"hello\" => \"world\", a: 1, b: 2}\n      %{:a => 1, :b => 2, \"hello\" => \"world\"}\n\n  Keys in maps can be accessed through some of the functions in this module\n  (such as `Map.get/3` or `Map.fetch/2`) or through the `[]` syntax provided by\n  the `Access` module:\n\n      iex> map = %{a: 1, b: 2}\n      iex> Map.fetch(map, :a)\n      {:ok, 1}\n      iex> map[:b]\n      2\n      iex> map[\"non_existing_key\"]\n      nil\n\n  The alternative access syntax `map.key` is provided alongside `[]` when the\n  map has a `:key` key; note that while `map[key]` will return `nil` if `map`\n  doesn't contain the key `key`, `map.key` will raise if `map` doesn't contain\n  the key `:key`.\n\n      iex> map = %{foo: \"bar\", baz: \"bong\"}\n      iex> map.foo\n      \"bar\"\n      iex> map.non_existing_key\n      ** (KeyError) key :non_existing_key not found in: %{baz: \"bong\", foo: \"bar\"}\n\n  Maps can be pattern matched on; when a map is on the left-hand side of a\n  pattern match, it will match if the map on the right-hand side contains the\n  keys on the left-hand side and their values match the ones on the left-hand\n  side. This means that an empty map matches every map.\n\n      iex> %{} = %{foo: \"bar\"}\n      %{foo: \"bar\"}\n      iex> %{a: a} = %{:a => 1, \"b\" => 2, [:c, :e, :e] => 3}\n      iex> a\n      1\n      iex> %{:c => 3} = %{:a => 1, 2 => :b}\n      ** (MatchError) no match of right hand side value: %{2 => :b, :a => 1}\n\n  Variables can be used as map keys both when writing map literals as well as\n  when matching:\n\n      iex> n = 1\n      1\n      iex> %{n => :one}\n      %{1 => :one}\n      iex> %{^n => :one} = %{1 => :one, 2 => :two, 3 => :three}\n      %{1 => :one, 2 => :two, 3 => :three}\n\n  Maps also support a specific update syntax to update the value stored under\n  *existing* atom keys:\n\n      iex> map = %{one: 1, two: 2}\n      iex> %{map | one: \"one\"}\n      %{one: \"one\", two: 2}\n      iex> %{map | three: 3}\n      ** (KeyError) key :three not found\n\n  ## Modules to work with maps\n\n  This module aims to provide functions that perform operations specific to maps\n  (like accessing keys, updating values, and so on). For traversing maps as\n  collections, developers should use the `Enum` module that works across a\n  variety of data types.\n\n  The `Kernel` module also provides a few functions to work with maps: for\n  example, `Kernel.map_size/1` to know the number of key-value pairs in a map or\n  `Kernel.is_map/1` to know if a term is a map.\n  ",
    drop = {
      description = "\ndrop(non_map, _keys)\n@spec drop(map, Enumerable.t) :: map\n  \ndrop(map, keys) when is_map(map) \n\n  Drops the given `keys` from `map`.\n\n  If `keys` contains keys that are not in `map`, they're simply ignored.\n\n  ## Examples\n\n      iex> Map.drop(%{a: 1, b: 2, c: 3}, [:b, :d])\n      %{a: 1, c: 3}\n\n  "
    },
    from_struct = {
      description = "@spec from_struct(atom | struct) :: map\n  \nfrom_struct(%{__struct__: _} = struct)\n\n  Converts a `struct` to map.\n\n  It accepts the struct module or a struct itself and\n  simply removes the `__struct__` field from the given struct\n  or from a new struct generated from the given module.\n\n  ## Example\n\n      defmodule User do\n        defstruct [:name]\n      end\n\n      Map.from_struct(User)\n      #=> %{name: nil}\n\n      Map.from_struct(%User{name: \"john\"})\n      #=> %{name: \"john\"}\n\n  "
    },
    get_and_update = {
      description = "@spec get_and_update(map, key, (value -> {get, value} | :pop)) :: {get, map} when get: term\n  \nget_and_update(map, _key, _fun)\n\n  Gets the value from `key` and updates it, all in one pass.\n\n  `fun` is called with the current value under `key` in `map` (or `nil` if `key`\n  is not present in `map`) and must return a two-element tuple: the \"get\" value\n  (the retrieved value, which can be operated on before being returned) and the\n  new value to be stored under `key` in the resulting new map. `fun` may also\n  return `:pop`, which means the current value shall be removed from `map` and\n  returned (making this function behave like `Map.pop(map, key)`.\n\n  The returned value is a tuple with the \"get\" value returned by\n  `fun` and a new map with the updated value under `key`.\n\n  ## Examples\n\n      iex> Map.get_and_update(%{a: 1}, :a, fn current_value ->\n      ...>   {current_value, \"new value!\"}\n      ...> end)\n      {1, %{a: \"new value!\"}}\n\n      iex> Map.get_and_update(%{a: 1}, :b, fn current_value ->\n      ...>   {current_value, \"new value!\"}\n      ...> end)\n      {nil, %{b: \"new value!\", a: 1}}\n\n      iex> Map.get_and_update(%{a: 1}, :a, fn _ -> :pop end)\n      {1, %{}}\n\n      iex> Map.get_and_update(%{a: 1}, :b, fn _ -> :pop end)\n      {nil, %{a: 1}}\n\n  "
    },
    ["get_and_update!"] = {
      description = "@spec get_and_update!(map, key, (value -> {get, value})) :: {get, map} | no_return when get: term\n  \nget_and_update!(map, _key, _fun)\n\n  Gets the value from `key` and updates it. Raises if there is no `key`.\n\n  Behaves exactly like `get_and_update/3`, but raises a `KeyError` exception if\n  `key` is not present in `map`.\n\n  ## Examples\n\n      iex> Map.get_and_update!(%{a: 1}, :a, fn current_value ->\n      ...>   {current_value, \"new value!\"}\n      ...> end)\n      {1, %{a: \"new value!\"}}\n\n      iex> Map.get_and_update!(%{a: 1}, :b, fn current_value ->\n      ...>   {current_value, \"new value!\"}\n      ...> end)\n      ** (KeyError) key :b not found in: %{a: 1}\n\n      iex> Map.get_and_update!(%{a: 1}, :a, fn _ ->\n      ...>   :pop\n      ...> end)\n      {1, %{}}\n\n  "
    },
    key = {
      description = "key :: any\n"
    },
    new = {
      description = "\nnew(enum)\n\nnew(%{} = map)\n@spec new(Enumerable.t) :: map\n  \nnew(%{__struct__: _} = struct)\n\n  Creates a map from an `enumerable`.\n\n  Duplicated keys are removed; the latest one prevails.\n\n  ## Examples\n\n      iex> Map.new([{:b, 1}, {:a, 2}])\n      %{a: 2, b: 1}\n      iex> Map.new([a: 1, a: 2, a: 3])\n      %{a: 3}\n\n  "
    },
    size = {
      description = "@spec equal?(map, map) :: boolean\n  \nsize(map)\nfalse"
    },
    split = {
      description = "\nsplit(non_map, _keys)\n@spec split(map, Enumerable.t) :: {map, map}\n  \nsplit(map, keys) when is_map(map) \n\n  Takes all entries corresponding to the given `keys` in `map` and extracts\n  them into a separate map.\n\n  Returns a tuple with the new map and the old map with removed keys.\n\n  Keys for which there are no entries in `map` are ignored.\n\n  ## Examples\n\n      iex> Map.split(%{a: 1, b: 2, c: 3}, [:a, :c, :e])\n      {%{a: 1, c: 3}, %{b: 2}}\n\n  "
    },
    take = {
      description = "\ntake(non_map, _keys)\n@spec take(map, Enumerable.t) :: map\n  \ntake(map, keys) when is_map(map) \n\n  Returns a new map with all the key-value pairs in `map` where the key\n  is in `keys`.\n\n  If `keys` contains keys that are not in `map`, they're simply ignored.\n\n  ## Examples\n\n      iex> Map.take(%{a: 1, b: 2, c: 3}, [:a, :c, :e])\n      %{a: 1, c: 3}\n\n  "
    },
    ["update!"] = {
      description = "@spec update!(map, key, (value -> value)) :: map | no_return\n  \nupdate!(map, _key, _fun)\n\n  Updates `key` with the given function.\n\n  If `key` is present in `map` with value `value`, `fun` is invoked with\n  argument `value` and its result is used as the new value of `key`. If `key` is\n  not present in `map`, a `KeyError` exception is raised.\n\n  ## Examples\n\n      iex> Map.update!(%{a: 1}, :a, &(&1 * 2))\n      %{a: 2}\n\n      iex> Map.update!(%{a: 1}, :b, &(&1 * 2))\n      ** (KeyError) key :b not found in: %{a: 1}\n\n  "
    },
    value = {
      description = "value :: any\n"
    }
  },
  MapSet = {
    count = {
      description = "\ncount(map_set)\n"
    },
    description = "\n  Functions that work on sets.\n\n  `MapSet` is the \"go to\" set data structure in Elixir. A set can be constructed\n  using `MapSet.new/0`:\n\n      iex> MapSet.new\n      #MapSet<[]>\n\n  A set can contain any kind of elements, and elements in a set don't have to be\n  of the same type. By definition, sets can't contain duplicate elements: when\n  inserting an element in a set where it's already present, the insertion is\n  simply a no-op.\n\n      iex> map_set = MapSet.new\n      iex> MapSet.put(map_set, \"foo\")\n      #MapSet<[\"foo\"]>\n      iex> map_set |> MapSet.put(\"foo\") |> MapSet.put(\"foo\")\n      #MapSet<[\"foo\"]>\n\n  A `MapSet` is represented internally using the `%MapSet{}` struct. This struct\n  can be used whenever there's a need to pattern match on something being a `MapSet`:\n\n      iex> match?(%MapSet{}, MapSet.new())\n      true\n\n  Note that, however, the struct fields are private and must not be accessed\n  directly; use the functions in this module to perform operations on sets.\n\n  `MapSet`s can also be constructed starting from other collection-type data\n  structures: for example, see `MapSet.new/1` or `Enum.into/2`.\n  ",
    difference = {
      description = "\ndifference(%MapSet{map: map1}, %MapSet{map: map2})\n@spec difference(t(val1), t(val2)) :: t(val1) when val1: value, val2: value\n  \ndifference(%MapSet{map: map1}, %MapSet{map: map2})\n      when map_size(map1) < map_size(map2) * 2 \n\n  Returns a set that is `map_set1` without the members of `map_set2`.\n\n  ## Examples\n\n      iex> MapSet.difference(MapSet.new([1, 2]), MapSet.new([2, 3, 4]))\n      #MapSet<[1]>\n\n  "
    },
    inspect = {
      description = "\ninspect(map_set, opts)\n"
    },
    into = {
      description = "\ninto(original)\n"
    },
    ["member?"] = {
      description = "\nmember?(map_set, val)\n"
    },
    new = {
      description = "\nnew(enumerable)\n@spec new(Enum.t) :: t\n  \nnew(%__MODULE__{} = map_set)\n\n  Creates a set from an enumerable.\n\n  ## Examples\n\n      iex> MapSet.new([:b, :a, 3])\n      #MapSet<[3, :a, :b]>\n      iex> MapSet.new([3, 3, 3, 2, 2, 1])\n      #MapSet<[1, 2, 3]>\n\n  "
    },
    reduce = {
      description = "@spec union(t(val1), t(val2)) :: t(val1 | val2) when val1: value, val2: value\n  \nreduce(map_set, acc, fun)\n\n  Returns a set containing all members of `map_set1` and `map_set2`.\n\n  ## Examples\n\n      iex> MapSet.union(MapSet.new([1, 2]), MapSet.new([2, 3, 4]))\n      #MapSet<[1, 2, 3, 4]>\n\n  "
    },
    t = {
      description = "t :: t(term)\n"
    },
    value = {
      description = "value :: term\n"
    }
  },
  MatchError = {
    message = {
      description = "\nmessage(exception)\n"
    }
  },
  Module = {
    LocalsTracker = {
      add_defaults = {
        description = "\nadd_defaults(pid, kind, tuple, defaults) when kind in [:def, :defp, :defmacro, :defmacrop] \nfalse"
      },
      add_definition = {
        description = "\nadd_definition(pid, kind, tuple) when kind in [:def, :defp, :defmacro, :defmacrop] \nfalse"
      },
      add_import = {
        description = "\nadd_import(pid, function, module, target) when is_atom(module) and is_tuple(target) \nfalse"
      },
      add_local = {
        description = "\nadd_local(pid, from, to) when is_tuple(from) and is_tuple(to) false\n\nadd_local(pid, to) when is_tuple(to) \n"
      },
      cache_env = {
        description = "\ncache_env(pid, env)\nfalse"
      },
      code_change = {
        description = "\ncode_change(_old, state, _extra)\nfalse"
      },
      collect_imports_conflicts = {
        description = "\ncollect_imports_conflicts(pid, all_defined)\nfalse"
      },
      collect_unused_locals = {
        description = "\ncollect_unused_locals(ref, private)\nfalse"
      },
      description = "false",
      get_cached_env = {
        description = "\nget_cached_env(pid, ref)\nfalse"
      },
      handle_call = {
        description = "\nhandle_call(:digraph, _from, {d, _} = state)\n\nhandle_call({:yank, local}, _from, {d, _} = state)\n\nhandle_call({:get_cached_env, ref}, _from, {_, cache} = state)\n\nhandle_call({:cache_env, env}, _from, {d, cache})\nfalse"
      },
      handle_cast = {
        description = "\nhandle_cast(:stop, state)\n\nhandle_cast({:reattach, _kind, tuple, {in_neigh, out_neigh}}, {d, _} = state)\n\nhandle_cast({:add_defaults, kind, {name, arity}, defaults}, {d, _} = state)\n\nhandle_cast({:add_definition, kind, tuple}, {d, _} = state)\n\nhandle_cast({:add_import, function, module, {name, arity}}, {d, _} = state)\n\nhandle_cast({:add_local, from, to}, {d, _} = state)\n"
      },
      handle_info = {
        description = "\nhandle_info(_msg, state)\nfalse"
      },
      import = {
        description = "import :: {:import, name, arity}\n"
      },
      init = {
        description = "\ninit([])\n"
      },
      ["local"] = {
        description = "local :: {name, arity}\n"
      },
      name = {
        description = "name :: atom\n"
      },
      name_arity = {
        description = "name_arity :: {name, arity}\n"
      },
      reattach = {
        description = "\nreattach(pid, kind, tuple, neighbours)\nfalse"
      },
      ref = {
        description = "ref :: pid | module\n"
      },
      start_link = {
        description = "@spec reachable(ref) :: [local]\n  \nstart_link\nfalse"
      },
      stop = {
        description = "\nstop(pid)\nfalse"
      },
      terminate = {
        description = "\nterminate(_reason, _state)\nfalse"
      },
      yank = {
        description = "\nyank(pid, local)\nfalse"
      }
    }
  },
  NaiveDateTime = {
    description = "\n  A NaiveDateTime struct (without a time zone) and functions.\n\n  The NaiveDateTime struct contains the fields year, month, day, hour,\n  minute, second, microsecond and calendar. New naive datetimes can be\n  built with the `new/7` function or using the `~N` sigil:\n\n      iex> ~N[2000-01-01 23:00:07]\n      ~N[2000-01-01 23:00:07]\n\n  Both `new/7` and sigil return a struct where the date fields can\n  be accessed directly:\n\n      iex> naive = ~N[2000-01-01 23:00:07]\n      iex> naive.year\n      2000\n      iex> naive.second\n      7\n\n  The naive bit implies this datetime representation does\n  not have a time zone. This means the datetime may not\n  actually exist in certain areas in the world even though\n  it is valid.\n\n  For example, when daylight saving changes are applied\n  by a region, the clock typically moves forward or backward\n  by one hour. This means certain datetimes never occur or\n  may occur more than once. Since `NaiveDateTime` is not\n  validated against a time zone, such errors would go unnoticed.\n\n  Remember, comparisons in Elixir using `==`, `>`, `<` and friends\n  are structural and based on the NaiveDateTime struct fields. For\n  proper comparison between naive datetimes, use the `compare/2`\n  function.\n\n  Developers should avoid creating the NaiveDateTime struct directly\n  and instead rely on the functions provided by this module as well\n  as the ones in 3rd party calendar libraries.\n  ",
    from_erl = {
      description = "@spec from_erl(:calendar.datetime, Calendar.microsecond) :: {:ok, t} | {:error, atom}\n  \nfrom_erl({{year, month, day}, {hour, minute, second}}, microsecond)\n\n  Converts an Erlang datetime tuple to a `NaiveDateTime` struct.\n\n  Attempting to convert an invalid ISO calendar date will produce an error tuple.\n\n  ## Examples\n\n      iex> NaiveDateTime.from_erl({{2000, 1, 1}, {13, 30, 15}})\n      {:ok, ~N[2000-01-01 13:30:15]}\n      iex> NaiveDateTime.from_erl({{2000, 1, 1}, {13, 30, 15}}, {5000, 3})\n      {:ok, ~N[2000-01-01 13:30:15.005]}\n      iex> NaiveDateTime.from_erl({{2000, 13, 1}, {13, 30, 15}})\n      {:error, :invalid_date}\n      iex> NaiveDateTime.from_erl({{2000, 13, 1},{13, 30, 15}})\n      {:error, :invalid_date}\n  "
    },
    from_iso8601 = {
      description = "\nfrom_iso8601(<<_::binary>>)\n@spec from_iso8601(String.t) :: {:ok, t} | {:error, atom}\n  \nfrom_iso8601(<<year::4-bytes, ?-, month::2-bytes, ?-, day::2-bytes, sep,\n                     hour::2-bytes, ?:, min::2-bytes, ?:, sec::2-bytes, rest::binary>>) when sep in [?\\s, ?T] \n\n  Parses the extended \"Date and time of day\" format described by\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  Timezone offset may be included in the string but they will be\n  simply discarded as such information is not included in naive date\n  times.\n\n  As specified in the standard, the separator \"T\" may be omitted if\n  desired as there is no ambiguity within this function.\n\n  Time representations with reduced accuracy are not supported.\n\n  ## Examples\n\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23 23:50:07\")\n      {:ok, ~N[2015-01-23 23:50:07]}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07\")\n      {:ok, ~N[2015-01-23 23:50:07]}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07Z\")\n      {:ok, ~N[2015-01-23 23:50:07]}\n\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23 23:50:07.0\")\n      {:ok, ~N[2015-01-23 23:50:07.0]}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23 23:50:07.0123456\")\n      {:ok, ~N[2015-01-23 23:50:07.012345]}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07.123Z\")\n      {:ok, ~N[2015-01-23 23:50:07.123]}\n\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23P23:50:07\")\n      {:error, :invalid_format}\n      iex> NaiveDateTime.from_iso8601(\"2015:01:23 23-50-07\")\n      {:error, :invalid_format}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23 23:50:07A\")\n      {:error, :invalid_format}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23 23:50:61\")\n      {:error, :invalid_time}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-32 23:50:07\")\n      {:error, :invalid_date}\n\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07.123+02:30\")\n      {:ok, ~N[2015-01-23 23:50:07.123]}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07.123+00:00\")\n      {:ok, ~N[2015-01-23 23:50:07.123]}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07.123-02:30\")\n      {:ok, ~N[2015-01-23 23:50:07.123]}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07.123-00:00\")\n      {:error, :invalid_format}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07.123-00:60\")\n      {:error, :invalid_format}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07.123-24:00\")\n      {:error, :invalid_format}\n\n  "
    },
    inspect = {
      description = "\ninspect(naive, opts)\n\ninspect(%{calendar: Calendar.ISO, year: year, month: month, day: day,\n                  hour: hour, minute: minute, second: second, microsecond: microsecond}, _)\n"
    },
    new = {
      description = "@spec new(Date.t, Time.t) :: {:ok, t}\n  \nnew(%Date{calendar: calendar, year: year, month: month, day: day},\n          %Time{hour: hour, minute: minute, second: second, microsecond: microsecond})\n\n  Builds a naive datetime from date and time structs.\n\n  ## Examples\n\n      iex> NaiveDateTime.new(~D[2010-01-13], ~T[23:00:07.005])\n      {:ok, ~N[2010-01-13 23:00:07.005]}\n\n  "
    },
    t = {
      description = "t :: %NaiveDateTime{year: Calendar.year, month: Calendar.month, day: Calendar.day,\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    to_erl = {
      description = "@spec to_erl(t) :: :calendar.datetime\n  \nto_erl(%{calendar: Calendar.ISO, year: year, month: month, day: day,\n               hour: hour, minute: minute, second: second})\n\n  Converts a `NaiveDateTime` struct to an Erlang datetime tuple.\n\n  Only supports converting naive datetimes which are in the ISO calendar,\n  attempting to convert naive datetimes from other calendars will raise.\n\n  WARNING: Loss of precision may occur, as Erlang time tuples only store\n  hour/minute/second.\n\n  ## Examples\n\n      iex> NaiveDateTime.to_erl(~N[2000-01-01 13:30:15])\n      {{2000, 1, 1}, {13, 30, 15}}\n\n  This function can also be used to convert a DateTime to a erl format\n  without the time zone information:\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> NaiveDateTime.to_erl(dt)\n      {{2000, 2, 29}, {23, 00, 07}}\n\n  "
    },
    to_iso8601 = {
      description = "@spec to_iso8601(Calendar.naive_datetime) :: String.t\n  \nto_iso8601(%{year: year, month: month, day: day,\n                   hour: hour, minute: minute, second: second, microsecond: microsecond})\n\n  Converts the given naive datetime to\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  Only supports converting naive datetimes which are in the ISO calendar,\n  attempting to convert naive datetimes from other calendars will raise.\n\n  ### Examples\n\n      iex> NaiveDateTime.to_iso8601(~N[2000-02-28 23:00:13])\n      \"2000-02-28T23:00:13\"\n\n      iex> NaiveDateTime.to_iso8601(~N[2000-02-28 23:00:13.001])\n      \"2000-02-28T23:00:13.001\"\n\n  This function can also be used to convert a DateTime to ISO8601 without\n  the time zone information:\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> NaiveDateTime.to_iso8601(dt)\n      \"2000-02-29T23:00:07\"\n\n  "
    },
    to_string = {
      description = "@spec compare(Calendar.naive_datetime, Calendar.naive_datetime) :: :lt | :eq | :gt\n  \nto_string(%{calendar: calendar, year: year, month: month, day: day,\n                     hour: hour, minute: minute, second: second, microsecond: microsecond})\n  Compares two `NaiveDateTime` structs.\n\n  Returns `:gt` if first is later than the second\n  and `:lt` for vice versa. If the two NaiveDateTime\n  are equal `:eq` is returned\n\n  ## Examples\n\n      iex> NaiveDateTime.compare(~N[2016-04-16 13:30:15], ~N[2016-04-28 16:19:25])\n      :lt\n      iex> NaiveDateTime.compare(~N[2016-04-16 13:30:15.1], ~N[2016-04-16 13:30:15.01])\n      :gt\n\n  This function can also be used to compare a DateTime without\n  the time zone information:\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> NaiveDateTime.compare(dt, ~N[2000-02-29 23:00:07])\n      :eq\n      iex> NaiveDateTime.compare(dt, ~N[2000-01-29 23:00:07])\n      :gt\n      iex> NaiveDateTime.compare(dt, ~N[2000-03-29 23:00:07])\n      :lt\n\n  \n@spec to_string(Calendar.naive_datetime) :: String.t\n  \nto_string(%{calendar: calendar, year: year, month: month, day: day,\n                  hour: hour, minute: minute, second: second, microsecond: microsecond})\n\n  Converts the given naive datetime to a string according to its calendar.\n\n  ### Examples\n\n      iex> NaiveDateTime.to_string(~N[2000-02-28 23:00:13])\n      \"2000-02-28 23:00:13\"\n      iex> NaiveDateTime.to_string(~N[2000-02-28 23:00:13.001])\n      \"2000-02-28 23:00:13.001\"\n\n  This function can also be used to convert a DateTime to a string without\n  the time zone information:\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> NaiveDateTime.to_string(dt)\n      \"2000-02-29 23:00:07\"\n\n  "
    }
  },
  Node = {
    description = "\n  Functions related to VM nodes.\n\n  Some of the functions in this module are inlined by the compiler,\n  similar to functions in the `Kernel` module and they are explicitly\n  marked in their docs as \"inlined by the compiler\". For more information\n  about inlined functions, check out the `Kernel` module.\n  ",
    set_cookie = {
      description = "@spec spawn_link(t, module, atom, [any]) :: pid\n  \nset_cookie(node \\\\ Node.self, cookie) when is_atom(cookie) \n\n  Sets the magic cookie of `node` to the atom `cookie`.\n\n  The default node is `Node.self/0`, the local node. If `node` is the local node,\n  the function also sets the cookie of all other unknown nodes to `cookie`.\n\n  This function will raise `FunctionClauseError` if the given `node` is not alive.\n  "
    },
    t = {
      description = "t :: node\n"
    }
  },
  OptionParser = {
    argv = {
      description = "argv :: [String.t]\n"
    },
    description = "\n  This module contains functions to parse command line options.\n  ",
    errors = {
      description = "errors :: [{String.t, String.t | nil}]\n"
    },
    options = {
      description = "options :: [switches: Keyword.t, strict: Keyword.t, aliases: Keyword.t]\n"
    },
    parsed = {
      description = "parsed :: Keyword.t\n"
    }
  },
  ParallelCompiler = nil,
  ParallelRequire = nil,
  ParseError = {
    get_option_key = {
      description = "@spec split(String.t) :: argv\n  \nget_option_key(option, allow_nonexistent_atoms?)\n\n  Splits a string into `t:argv/0` chunks.\n\n  This function splits the given `string` into a list of strings in a similar\n  way to many shells.\n\n  ## Examples\n\n      iex> OptionParser.split(\"foo bar\")\n      [\"foo\", \"bar\"]\n\n      iex> OptionParser.split(\"foo \\\"bar baz\\\"\")\n      [\"foo\", \"bar baz\"]\n\n  "
    }
  },
  Parser = {
    DSL = {
      deflexer = {
        description = "\ndeflexer(char, acc, do: body)\n\ndeflexer(acc, do: body)\n@spec compile_requirement(Requirement.t) :: Requirement.t\n  \ndeflexer(match, do: body) when is_binary(match) \n\n  Compiles a requirement to its internal representation with\n  `:ets.match_spec_compile/1` for faster matching.\n\n  The internal representation is opaque and can not be converted to external\n  term format and then back again without losing its properties (meaning it\n  can not be sent to a process on another node and still remain a valid\n  compiled match_spec, nor can it be stored on disk).\n  "
      },
      description = "false"
    },
    description = "false",
    inspect = {
      description = "\ninspect(%Version.Requirement{source: source}, _opts)\n\ninspect(self, _opts)\n"
    },
    to_string = {
      description = "\nto_string(%Version.Requirement{source: source})\n@spec parse_version(String.t) :: {:ok, Version.matchable} | :error\n    \nto_string(version)\n"
    }
  },
  Path = {
    description = "\n  This module provides conveniences for manipulating or\n  retrieving file system paths.\n\n  The functions in this module may receive a chardata as\n  argument (i.e. a string or a list of characters / string)\n  and will always return a string (encoded in UTF-8).\n\n  The majority of the functions in this module do not\n  interact with the file system, except for a few functions\n  that require it (like `wildcard/2` and `expand/1`).\n  ",
    join = {
      description = "@spec join(nonempty_list(t)) :: binary\n  \njoin([name])\n\n  Joins a list of paths.\n\n  This function should be used to convert a list of paths to a path.\n  Note that any trailing slash is removed when joining.\n\n  ## Examples\n\n      iex> Path.join([\"~\", \"foo\"])\n      \"~/foo\"\n\n      iex> Path.join([\"foo\"])\n      \"foo\"\n\n      iex> Path.join([\"/\", \"foo\", \"bar/\"])\n      \"/foo/bar\"\n\n  "
    },
    split = {
      description = "@spec split(t) :: [binary]\n\n  # Work around a bug in Erlang on UNIX\n  \nsplit(path)\n\n  Splits the path into a list at the path separator.\n\n  If an empty string is given, returns an empty list.\n\n  On Windows, path is split on both \"\\\" and \"/\" separators\n  and the driver letter, if there is one, is always returned\n  in lowercase.\n\n  ## Examples\n\n      iex> Path.split(\"\")\n      []\n\n      iex> Path.split(\"foo\")\n      [\"foo\"]\n\n      iex> Path.split(\"/foo/bar\")\n      [\"/\", \"foo\", \"bar\"]\n\n  "
    },
    t = {
      description = "t :: :unicode.chardata()\n"
    }
  },
  Port = {
    description = "\n  Functions for interacting with the external world through ports.\n\n  Ports provide a mechanism to start operating system processes external\n  to the Erlang VM and communicate with them via message passing.\n\n  ## Example\n\n      iex> port = Port.open({:spawn, \"cat\"}, [:binary])\n      iex> send port, {self(), {:command, \"hello\"}}\n      iex> send port, {self(), {:command, \"world\"}}\n      iex> flush()\n      {#Port<0.1444>, {:data, \"hello\"}}\n      {#Port<0.1444>, {:data, \"world\"}}\n      iex> send port, {self(), :close}\n      :ok\n      iex> flush()\n      {#Port<0.1464>, :closed}\n      :ok\n\n  In the example above, we have created a new port that executes the\n  program `cat`. `cat` is a program available on UNIX systems that\n  receives data from multiple inputs and concatenates them in the output.\n\n  After the port was created, we sent it two commands in the form of\n  messages using `Kernel.send/2`. The first command has the binary payload\n  of \"hello\" and the second has \"world\".\n\n  After sending those two messages, we invoked the IEx helper `flush()`,\n  which printed all messages received from the port, in this case we got\n  \"hello\" and \"world\" back. Notice the messages are in binary because we\n  passed the `:binary` option when opening the port in `Port.open/2`. Without\n  such option, it would have yielded a list of bytes.\n\n  Once everything was done, we closed the port.\n\n  Elixir provides many conveniences for working with ports and some drawbacks.\n  We will explore those below.\n\n  ## Message and function APIs\n\n  There are two APIs for working with ports. It can be either asynchronous via\n  message passing, as in the example above, or by calling the functions on this\n  module.\n\n  The messages supported by ports and their counterpart function APIs are\n  listed below:\n\n    * `{pid, {:command, binary}}` - sends the given data to the port.\n      See `command/3`.\n\n    * `{pid, :close}` - closes the port. Unless the port is already closed,\n      the port will reply with `{port, :closed}` message once it has flushed\n      its buffers and effectively closed. See `close/1`.\n\n    * `{pid, {:connect, new_pid}}` - sets the `new_pid` as the new owner of\n      the port. Once a port is opened, the port is linked and connected to the\n      caller process and communication to the port only happens through the\n      connected process. This message makes `new_pid` the new connected processes.\n      Unless the port is dead, the port will reply to the old owner with\n      `{port, :connected}`. See `connect/2`.\n\n  On its turn, the port will send the connected process the following messages:\n\n    * `{port, {:data, data}}` - data sent by the port\n    * `{port, :closed}` - reply to the `{pid, :close}` message\n    * `{port, :connected}` - reply to the `{pid, {:connect, new_pid}}` message\n    * `{:EXIT, port, reason}` - exit signals in case the port crashes and the\n      owner process is trapping exits\n\n  ## Open mechanisms\n\n  The port can be opened through four main mechanisms.\n\n  As a short summary, prefer to using the `:spawn` and `:spawn_executable`\n  options mentioned below. The other two options, `:spawn_driver` and `:fd`\n  are for advanced usage within the VM. Also consider using `System.cmd/3`\n  if all you want is to execute a program and retrieve its return value.\n\n  ### spawn\n\n  The `:spawn` tuple receives a binary that is going to be executed as a\n  full invocation. For example, we can use it to invoke \"echo hello\" directly:\n\n      iex> port = Port.open({:spawn, \"echo oops\"}, [:binary])\n      iex> flush()\n      {#Port<0.1444>, {:data, \"oops\\n\"}}\n\n  `:spawn` will retrieve the program name from the argument and traverse your\n  OS `$PATH` environment variable looking for a matching program.\n\n  Although the above is handy, it means it is impossible to invoke an executable\n  that has whitespaces on its name or in any of its arguments. For those reasons,\n  most times it is preferrable to execute `:spawn_executable`.\n\n  ### spawn_executable\n\n  Spawn executable is a more restricted and explicit version of spawn. It expects\n  full file paths to the executable you want to execute. If they are in your `$PATH`,\n  they can be retrieved by calling `System.find_executable/1`:\n\n      iex> path = System.find_executable(\"echo\")\n      iex> port = Port.open({:spawn_executable, path}, [:binary, args: [\"hello world\"]])\n      iex> flush()\n      {#Port<0.1380>, {:data, \"hello world\\n\"}}\n\n  When using `:spawn_executable`, the list of arguments can be passed via\n  the `:args` option as done above. For the full list of options, see the\n  documentation for the Erlang function `:erlang.open_port/2`.\n\n  ### spawn_driver\n\n  Spawn driver is used to start Port Drivers, which are programs written in\n  C that implements a specific communication protocols and are dynamically\n  linked to the Erlang VM. Port drivers are an advanced topic and one of the\n  mechanisms for integrating C code, alongside NIFs. For more information,\n  [please check the Erlang docs](http://erlang.org/doc/reference_manual/ports.html).\n\n  ### fd\n\n  The `:fd` name option allows developers to access `in` and `out` file\n  descriptors used by the Erlang VM. You would use those only if you are\n  reimplementing core part of the Runtime System, such as the `:user` and\n  `:shell` processes.\n\n  ## Zombie processes\n\n  A port can be closed via the `close/1` function or by sending a `{pid, :close}`\n  message. However, if the VM crashes, a long-running program started by the port\n  will have its stdin and stdout channels closed but **it won't be automatically\n  terminated**.\n\n  While most UNIX command line tools will exit once its communication channels\n  are closed, not all command line applications will do so. While we encourage\n  graceful termination by detecting if stdin/stdout has been closed, we do not\n  always have control over how 3rd party software terminates. In those cases,\n  you can wrap the application in a script that checks for stdin. Here is such\n  script in bash:\n\n      #!/bin/sh\n      \"$@\"\n      pid=$!\n      while read line ; do\n        :\n      done\n      kill -KILL $pid\n\n\n  Now instead of:\n\n      Port.open({:spawn_executable, \"/path/to/program\"},\n                [args: [\"a\", \"b\", \"c\"]])\n\n  You may invoke:\n\n      Port.open({:spawn_executable, \"/path/to/wrapper\"},\n                [args: [\"/path/to/program\", \"a\", \"b\", \"c\"]])\n\n  ",
    info = {
      description = "\ninfo(port, item)\n@spec info(port, atom) :: {atom, term} | nil\n  \ninfo(port, :registered_name)\n  Returns information about the `port` or `nil` if the port is closed.\n\n  For more information, see [`:erlang.port_info/2`](http://www.erlang.org/doc/man/erlang.html#port_info-2).\n  \n@spec connect(port, pid) :: true\n  \ninfo(port)\n\n  Returns information about the `port` or `nil` if the port is closed.\n\n  For more information, see [`:erlang.port_info/1`](http://www.erlang.org/doc/man/erlang.html#port_info-1).\n  "
    },
    name = {
      description = "name :: {:spawn, charlist | binary} |\n"
    }
  },
  Process = {
    description = "\n  Conveniences for working with processes and the process dictionary.\n\n  Besides the functions available in this module, the `Kernel` module\n  exposes and auto-imports some basic functionality related to processes\n  available through the following functions:\n\n    * `Kernel.spawn/1` and `Kernel.spawn/3`\n    * `Kernel.spawn_link/1` and `Kernel.spawn_link/3`\n    * `Kernel.spawn_monitor/1` and `Kernel.spawn_monitor/3`\n    * `Kernel.self/0`\n    * `Kernel.send/2`\n\n  ",
    info = {
      description = "\ninfo(pid, spec) when is_atom(spec) or is_list(spec) \n@spec info(pid, atom | [atom]) :: {atom, term} | [{atom, term}]  | nil\n  \ninfo(pid, :registered_name)\n\n  Returns information about the process identified by `pid`,\n  or returns `nil` if the process is not alive.\n\n  See [`:erlang.process_info/2`](http://www.erlang.org/doc/man/erlang.html#process_info-2) for more info.\n  "
    },
    sleep = {
      description = "@spec exit(pid, term) :: true\n  \nsleep(timeout)\n      when is_integer(timeout) and timeout >= 0\n      when timeout == :infinity \n\n  Sleeps the current process for the given `timeout`.\n\n  `timeout` is either the number of milliseconds to sleep as an\n  integer or the atom `:infinity`. When `:infinity` is given,\n  the current process will suspend forever.\n\n  **Use this function with extreme care**. For almost all situations\n  where you would use `sleep/1` in Elixir, there is likely a\n  more correct, faster and precise way of achieving the same with\n  message passing.\n\n  For example, if you are waiting a process to perform some\n  action, it is better to communicate the progress of such action\n  with messages.\n\n  In other words, **do not**:\n\n      Task.start_link fn ->\n        do_something()\n        ...\n      end\n\n      # Wait until work is done\n      Process.sleep(2000)\n\n  But **do**:\n\n      parent = self()\n      Task.start_link fn ->\n        do_something()\n        send parent, :work_is_done\n        ...\n      end\n\n      receive do\n        :work_is_done -> :ok\n      after\n        30_000 -> :timeout # Optional timeout\n      end\n\n  For cases like the one above, `Task.async/1` and `Task.await/2` are\n  preferred.\n\n  Similarly, if you are waiting for a process to terminate,\n  monitor that process instead of sleeping. **Do not**:\n\n      Task.start_link fn ->\n        ...\n      end\n\n      # Wait until task terminates\n      Process.sleep(2000)\n\n  Instead **do**:\n\n      {:ok, pid} =\n        Task.start_link fn ->\n          ...\n        end\n\n      ref = Process.monitor(pid)\n      receive do\n        {:DOWN, ^ref, _, _, _} -> :task_is_down\n      after\n        30_000 -> :timeout # Optional timeout\n      end\n\n  "
    },
    spawn_opt = {
      description = "spawn_opt :: :link | :monitor | {:priority, :low | :normal | :high} |\n"
    },
    spawn_opts = {
      description = "spawn_opts :: [spawn_opt]\n"
    }
  },
  Protocol = {
    UndefinedError = {
      message = {
        description = "\nmessage(exception)\n"
      }
    },
    __builtin__ = {
      description = "\n__builtin__\nfalse"
    },
    __derive__ = {
      description = "\n__derive__(derives, for, %Macro.Env{} = env) when is_atom(for) \nfalse"
    },
    __ensure_defimpl__ = {
      description = "\n__ensure_defimpl__(protocol, for, env)\nfalse"
    },
    __functions_spec__ = {
      description = "\n__functions_spec__([head | tail])\n@spec __protocol__(:module) :: __MODULE__\n      @spec __protocol__(:functions) :: unquote(Protocol.__functions_spec__(@functions))\n      @spec __protocol__(:consolidated?) :: false\n      Kernel.\n__functions_spec__([])\nfalse"
    },
    __impl__ = {
      description = "\n__impl__(:for)\n@spec __impl__(:target) :: unquote(impl)\n            @spec __impl__(:protocol) :: unquote(protocol)\n            @spec __impl__(:for) :: unquote(for)\n            \n__impl__(:protocol)false\n\n__impl__(:protocol)\n@spec __impl__(:for) :: unquote(for)\n        @spec __impl__(:target) :: __MODULE__\n        @spec __impl__(:protocol) :: unquote(protocol)\n        \n__impl__(:target)false\n\n__impl__(protocol, opts)\nfalse"
    },
    __protocol__ = {
      description = "@spec consolidate(module, [module]) ::\n    {:ok, binary} |\n    {:error, :not_a_protocol} |\n    {:error, :no_beam_info}\n  \n__protocol__(name, [do: block])\nfalse"
    },
    ["__spec__?"] = {
      description = "\n__spec__?(module, name, arity)\nfalse"
    },
    def = {
      description = "\ndef(_)\n\ndef({name, _, args}) when is_atom(name) and is_list(args) \n\ndef({_, _, args}) when args == [] or is_atom(args) \n\ndef(signature)\n\n  Defines a new protocol function.\n\n  Protocols do not allow functions to be defined directly, instead, the\n  regular `Kernel.def/*` macros are replaced by this macro which\n  defines the protocol functions with the appropriate callbacks.\n  "
    },
    derive = {
      description = "@spec assert_impl!(module, module) :: :ok | no_return\n  \nderive(protocol, module, options \\\\ [])\n\n  Derives the `protocol` for `module` with the given options.\n  "
    },
    description = "\n  Functions for working with protocols.\n  ",
    t = {
      description = "t :: term\n"
    }
  },
  Range = {
    count = {
      description = "\ncount(first..last)\n"
    },
    description = "\n  Defines a range.\n\n  A range represents a discrete number of values where\n  the first and last values are integers.\n\n  Ranges can be either increasing (first <= last) or\n  decreasing (first > last). Ranges are also always\n  inclusive.\n\n  A Range is represented internally as a struct. However,\n  the most common form of creating and matching on ranges\n  is via the `../2` macro, auto-imported from `Kernel`:\n\n      iex> range = 1..3\n      1..3\n      iex> first..last = range\n      iex> first\n      1\n      iex> last\n      3\n\n  A Range implements the Enumerable protocol, which means\n  all of the functions in the Enum module is available:\n\n      iex> range = 1..10\n      1..10\n      iex> Enum.reduce(range, 0, fn i, acc -> i * i + acc end)\n      385\n      iex> Enum.count(range)\n      10\n      iex> Enum.member?(range, 11)\n      false\n      iex> Enum.member?(range, 8)\n      true\n\n  ",
    inspect = {
      description = "\ninspect(first..last, opts)\n"
    },
    ["member?"] = {
      description = "\nmember?(_.._, _value)\n\nmember?(first..last, value) when is_integer(value) \n"
    },
    new = {
      description = "@spec new(integer, integer) :: t\n  \nnew(first, last)\n\n  Creates a new range.\n  "
    },
    ["range?"] = {
      description = "\nrange?(_)\n@spec range?(term) :: boolean\n  \nrange?(first..last) when is_integer(first) and is_integer(last), \n\n  Returns `true` if the given `term` is a valid range.\n\n  ## Examples\n\n      iex> Range.range?(1..3)\n      true\n\n      iex> Range.range?(0)\n      false\n\n  "
    },
    reduce = {
      description = "\nreduce(first..last, acc, fun)\n"
    },
    t = {
      description = "t :: %Range{first: integer, last: integer}\n"
    }
  },
  Record = {
    Extractor = {
      description = "false",
      extract = {
        description = "\nextract(name, from_lib: file) when is_binary(file) \n\nextract(name, from: file) when is_binary(file) \n"
      },
      extract_all = {
        description = "\nextract_all(from_lib: file) when is_binary(file) \n\nextract_all(from: file) when is_binary(file) \n"
      }
    },
    __access__ = {
      description = "\n__access__(atom, fields, record, args, caller)false\n\n__access__(atom, fields, args, caller)\nfalse"
    },
    __fields__ = {
      description = "\n__fields__(type, fields)\nfalse"
    },
    __keyword__ = {
      description = "\n__keyword__(atom, fields, record)\nfalse"
    },
    defrecord = {
      description = "\ndefrecord(name, tag \\\\ nil, kv)\n\n  Defines a set of macros to create, access, and pattern match\n  on a record.\n\n  The name of the generated macros will be `name` (which has to be an\n  atom). `tag` is also an atom and is used as the \"tag\" for the record (i.e.,\n  the first element of the record tuple); by default (if `nil`), it's the same\n  as `name`. `kv` is a keyword list of `name: default_value` fields for the\n  new record.\n\n  The following macros are generated:\n\n    * `name/0` to create a new record with default values for all fields\n    * `name/1` to create a new record with the given fields and values,\n      to get the zero-based index of the given field in a record or to\n      convert the given record to a keyword list\n    * `name/2` to update an existing record with the given fields and values\n      or to access a given field in a given record\n\n  All these macros are public macros (as defined by `defmacro`).\n\n  See the \"Examples\" section for examples on how to use these macros.\n\n  ## Examples\n\n      defmodule User do\n        require Record\n        Record.defrecord :user, [name: \"meg\", age: \"25\"]\n      end\n\n  In the example above, a set of macros named `user` but with different\n  arities will be defined to manipulate the underlying record.\n\n      # Import the module to make the user macros locally available\n      import User\n\n      # To create records\n      record = user()        #=> {:user, \"meg\", 25}\n      record = user(age: 26) #=> {:user, \"meg\", 26}\n\n      # To get a field from the record\n      user(record, :name) #=> \"meg\"\n\n      # To update the record\n      user(record, age: 26) #=> {:user, \"meg\", 26}\n\n      # To get the zero-based index of the field in record tuple\n      # (index 0 is occupied by the record \"tag\")\n      user(:name) #=> 1\n\n      # Convert a record to a keyword list\n      user(record) #=> [name: \"meg\", age: 26]\n\n  The generated macros can also be used in order to pattern match on records and\n  to bind variables during the match:\n\n      record = user() #=> {:user, \"meg\", 25}\n\n      user(name: name) = record\n      name #=> \"meg\"\n\n  By default, Elixir uses the record name as the first element of the tuple (the\n  \"tag\"). However, a different tag can be specified when defining a record:\n\n      defmodule User do\n        require Record\n        Record.defrecord :user, User, name: nil\n      end\n\n      require User\n      User.user() #=> {User, nil}\n\n  ## Defining extracted records with anonymous functions in the values\n\n  If a record defines an anonymous function in the default values, an\n  `ArgumentError` will be raised. This can happen unintentionally when defining\n  a record after extracting it from an Erlang library that uses anonymous\n  functions for defaults.\n\n      Record.defrecord :my_rec, Record.extract(...)\n      #=> ** (ArgumentError) invalid value for record field fun_field,\n      cannot escape #Function<12.90072148/2 in :erl_eval.expr/5>.\n\n  To work around this error, redefine the field with your own &M.f/a function,\n  like so:\n\n      defmodule MyRec do\n        require Record\n        Record.defrecord :my_rec, Record.extract(...) |> Keyword.merge(fun_field: &__MODULE__.foo/2)\n        def foo(bar, baz), do: IO.inspect({bar, baz})\n      end\n\n  "
    },
    defrecordp = {
      description = "\ndefrecordp(name, tag \\\\ nil, kv)\n\n  Same as `defrecord/3` but generates private macros.\n  "
    },
    description = "\n  Module to work with, define, and import records.\n\n  Records are simply tuples where the first element is an atom:\n\n      iex> Record.is_record {User, \"john\", 27}\n      true\n\n  This module provides conveniences for working with records at\n  compilation time, where compile-time field names are used to\n  manipulate the tuples, providing fast operations on top of\n  the tuples' compact structure.\n\n  In Elixir, records are used mostly in two situations:\n\n    1. to work with short, internal data\n    2. to interface with Erlang records\n\n  The macros `defrecord/3` and `defrecordp/3` can be used to create records\n  while `extract/2` and `extract_all/1` can be used to extract records from\n  Erlang files.\n\n  ## Types\n\n  Types can be defined for tuples with the `record/2` macro (only available in\n  typespecs). This macro will expand to a tuple as seen in the example below:\n\n      defmodule MyModule do\n        require Record\n        Record.defrecord :user, name: \"john\", age: 25\n\n        @type user :: record(:user, name: String.t, age: integer)\n        # expands to: \"@type user :: {:user, String.t, integer}\"\n      end\n\n  ",
    extract = {
      description = "\nextract(name, opts) when is_atom(name) and is_list(opts) \n\n  Extracts record information from an Erlang file.\n\n  Returns a quoted expression containing the fields as a list\n  of tuples.\n\n  `name`, which is the name of the extracted record, is expected to be an atom\n  *at compile time*.\n\n  ## Options\n\n  This function accepts the following options, which are exclusive to each other\n  (i.e., only one of them can be used in the same call):\n\n    * `:from` - (binary representing a path to a file) path to the Erlang file\n      that contains the record definition to extract; with this option, this\n      function uses the same path lookup used by the `-include` attribute used in\n      Erlang modules.\n    * `:from_lib` - (binary representing a path to a file) path to the Erlang\n      file that contains the record definition to extract; with this option,\n      this function uses the same path lookup used by the `-include_lib`\n      attribute used in Erlang modules.\n\n  These options are expected to be literals (including the binary values) at\n  compile time.\n\n  ## Examples\n\n      iex> Record.extract(:file_info, from_lib: \"kernel/include/file.hrl\")\n      [size: :undefined, type: :undefined, access: :undefined, atime: :undefined,\n       mtime: :undefined, ctime: :undefined, mode: :undefined, links: :undefined,\n       major_device: :undefined, minor_device: :undefined, inode: :undefined,\n       uid: :undefined, gid: :undefined]\n\n  "
    },
    extract_all = {
      description = "\nextract_all(opts) when is_list(opts) \n\n  Extracts all records information from an Erlang file.\n\n  Returns a keyword list of `{record_name, fields}` tuples where `record_name`\n  is the name of an extracted record and `fields` is a list of `{field, value}`\n  tuples representing the fields for that record.\n\n  ## Options\n\n  This function accepts the following options, which are exclusive to each other\n  (i.e., only one of them can be used in the same call):\n\n    * `:from` - (binary representing a path to a file) path to the Erlang file\n      that contains the record definitions to extract; with this option, this\n      function uses the same path lookup used by the `-include` attribute used in\n      Erlang modules.\n    * `:from_lib` - (binary representing a path to a file) path to the Erlang\n      file that contains the record definitions to extract; with this option,\n      this function uses the same path lookup used by the `-include_lib`\n      attribute used in Erlang modules.\n\n  These options are expected to be literals (including the binary values) at\n  compile time.\n  "
    },
    is_record = {
      description = "\nis_record(data)\n  Checks if the given `data` is a record.\n\n  This is implemented as a macro so it can be used in guard clauses.\n\n  ## Examples\n\n      iex> record = {User, \"john\", 27}\n      iex> Record.is_record(record)\n      true\n      iex> tuple = {}\n      iex> Record.is_record(tuple)\n      false\n\n  \n\nis_record(data, kind)\n\n  Checks if the given `data` is a record of kind `kind`.\n\n  This is implemented as a macro so it can be used in guard clauses.\n\n  ## Examples\n\n      iex> record = {User, \"john\", 27}\n      iex> Record.is_record(record, User)\n      true\n\n  "
    }
  },
  Regex = {
    description = "\n  Provides regular expressions for Elixir. Built on top of Erlang's `:re`\n  module.\n\n  As the [`:re` module](http://www.erlang.org/doc/man/re.html), Regex is based\n  on PCRE (Perl Compatible Regular Expressions). More information can be\n  found in the [`:re` module documentation](http://www.erlang.org/doc/man/re.html).\n\n  Regular expressions in Elixir can be created using `Regex.compile!/2`\n  or using the special form with [`~r`](Kernel.html#sigil_r/2) or [`~R`](Kernel.html#sigil_R/2):\n\n      # A simple regular expressions that matches foo anywhere in the string\n      ~r/foo/\n\n      # A regular expression with case insensitive and Unicode options\n      ~r/foo/iu\n\n  A Regex is represented internally as the `Regex` struct. Therefore,\n  `%Regex{}` can be used whenever there is a need to match on them.\n  Keep in mind it is not guaranteed two regular expressions from the\n  same source are equal, for example:\n\n      ~r/(?<foo>.)(?<bar>.)/ == ~r/(?<foo>.)(?<bar>.)/\n\n  may return `true` or `false` depending on your machine, endianess, available\n  optimizations and others. You can, however, retrieve the source of a\n  compiled regular expression by accessing the `source` field, and then\n  compare those directly:\n\n      ~r/(?<foo>.)(?<bar>.)/.source == ~r/(?<foo>.)(?<bar>.)/.source\n\n  ## Modifiers\n\n  The modifiers available when creating a Regex are:\n\n    * `unicode` (u) - enables Unicode specific patterns like `\\p` and change\n      modifiers like `\\w`, `\\W`, `\\s` and friends to also match on Unicode.\n      It expects valid Unicode strings to be given on match\n\n    * `caseless` (i) - adds case insensitivity\n\n    * `dotall` (s) - causes dot to match newlines and also set newline to\n      anycrlf; the new line setting can be overridden by setting `(*CR)` or\n      `(*LF)` or `(*CRLF)` or `(*ANY)` according to re documentation\n\n    * `multiline` (m) - causes `^` and `$` to mark the beginning and end of\n      each line; use `\\A` and `\\z` to match the end or beginning of the string\n\n    * `extended` (x) - whitespace characters are ignored except when escaped\n      and allow `#` to delimit comments\n\n    * `firstline` (f) - forces the unanchored pattern to match before or at the\n      first newline, though the matched text may continue over the newline\n\n    * `ungreedy` (U) - inverts the \"greediness\" of the regexp\n      (the previous `r` option is deprecated in favor of `U`)\n\n  The options not available are:\n\n    * `anchored` - not available, use `^` or `\\A` instead\n    * `dollar_endonly` - not available, use `\\z` instead\n    * `no_auto_capture` - not available, use `?:` instead\n    * `newline` - not available, use `(*CR)` or `(*LF)` or `(*CRLF)` or\n      `(*ANYCRLF)` or `(*ANY)` at the beginning of the regexp according to the\n      re documentation\n\n  ## Captures\n\n  Many functions in this module handle what to capture in a regex\n  match via the `:capture` option. The supported values are:\n\n    * `:all` - all captured subpatterns including the complete matching string\n      (this is the default)\n\n    * `:first` - only the first captured subpattern, which is always the\n      complete matching part of the string; all explicitly captured subpatterns\n      are discarded\n\n    * `:all_but_first`- all but the first matching subpattern, i.e. all\n      explicitly captured subpatterns, but not the complete matching part of\n      the string\n\n    * `:none` - does not return matching subpatterns at all\n\n    * `:all_names` - captures all names in the Regex\n\n    * `list(binary)` - a list of named captures to capture\n\n  ",
    t = {
      description = "t :: %__MODULE__{re_pattern: term, source: binary, opts: binary}\n"
    }
  },
  Registry = {
    Partition = {
      description = "false",
      handle_call = {
        description = "\nhandle_call(:sync, _, state)\n"
      },
      handle_info = {
        description = "\nhandle_info(msg, state)\n\nhandle_info({:EXIT, pid, _reason}, ets)\n"
      },
      init = {
        description = "\ninit({kind, registry, i, partitions, key_partition, pid_partition, listeners})\n"
      },
      start_link = {
        description = "@spec pid_name(atom, non_neg_integer) :: atom\n  \nstart_link(registry, arg)\n\n  Starts the registry partition.\n\n  The process is only responsible for monitoring, demonitoring\n  and cleaning up when monitored processes crash.\n  "
      }
    },
    Supervisor = {
      description = "false",
      init = {
        description = "\ninit({kind, registry, partitions, listeners, entries})\n"
      },
      start_link = {
        description = "@spec put_meta(registry, meta_key, meta_value) :: :ok\n  \nstart_link(kind, registry, partitions, listeners, entries)\n\n  Stores registry metadata.\n\n  Atoms and tuples are allowed as keys.\n\n  ## Examples\n\n      iex> Registry.start_link(:unique, Registry.PutMetaTest)\n      iex> Registry.put_meta(Registry.PutMetaTest, :custom_key, \"custom_value\")\n      :ok\n      iex> Registry.meta(Registry.PutMetaTest, :custom_key)\n      {:ok, \"custom_value\"}\n      iex> Registry.put_meta(Registry.PutMetaTest, {:tuple, :key}, \"tuple_value\")\n      :ok\n      iex> Registry.meta(Registry.PutMetaTest, {:tuple, :key})\n      {:ok, \"tuple_value\"}\n\n  "
      }
    },
    description = "\n  A local, decentralized and scalable key-value process storage.\n\n  It allows developers to lookup one or more processes with a given key.\n  If the registry has `:unique` keys, a key points to 0 or 1 processes.\n  If the registry allows `:duplicate` keys, a single key may point to any\n  number of processes. In both cases, different keys could identify the\n  same process.\n\n  Each entry in the registry is associated to the process that has\n  registered the key. If the process crashes, the keys associated to that\n  process are automatically removed. All key comparisons in the registry\n  are done using the match operation (`===`).\n\n  The registry can be used for different purposes, such as name lookups (using\n  the `:via` option), storing properties, custom dispatching rules, or a pubsub\n  implementation. We explore some of those use cases below.\n\n  The registry may also be transparently partitioned, which provides\n  more scalable behaviour for running registries on highly concurrent\n  environments with thousands or millions of entries.\n\n  ## Using in `:via`\n\n  Once the registry is started with a given name using\n  `Registry.start_link/2`, it can be used to register and access named\n  processes using the `{:via, Registry, {registry, key}}` tuple:\n\n      {:ok, _} = Registry.start_link(:unique, Registry.ViaTest)\n      name = {:via, Registry, {Registry.ViaTest, \"agent\"}}\n      {:ok, _} = Agent.start_link(fn -> 0 end, name: name)\n      Agent.get(name, & &1)\n      #=> 0\n      Agent.update(name, & &1 + 1)\n      Agent.get(name, & &1)\n      #=> 1\n\n  Typically the registry is started as part of a supervision tree though:\n\n      supervisor(Registry, [:unique, Registry.ViaTest])\n\n  Only registries with unique keys can be used in `:via`. If the name is\n  already taken, the case-specific `start_link` function (`Agent.start_link/2`\n  in the example above) will return `{:error, {:already_started, current_pid}}`.\n\n  ## Using as a dispatcher\n\n  `Registry` has a dispatch mechanism that allows developers to implement custom\n  dispatch logic triggered from the caller. For example, let's say we have a\n  duplicate registry started as so:\n\n      {:ok, _} = Registry.start_link(:duplicate, Registry.DispatcherTest)\n\n  By calling `register/3`, different processes can register under a given key\n  and associate any value under that key. In this case, let's register the\n  current process under the key `\"hello\"` and attach the `{IO, :inspect}` tuple\n  to it:\n\n      {:ok, _} = Registry.register(Registry.DispatcherTest, \"hello\", {IO, :inspect})\n\n  Now, an entity interested in dispatching events for a given key may call\n  `dispatch/3` passing in the key and a callback. This callback will be invoked\n  with a list of all the values registered under the requested key, alongside\n  the pid of the process that registered each value, in the form of `{pid,\n  value}` tuples. In our example, `value` will be the `{module, function}` tuple\n  in the code above:\n\n      Registry.dispatch(Registry.DispatcherTest, \"hello\", fn entries ->\n        for {pid, {module, function}} <- entries, do: apply(module, function, [pid])\n      end)\n      # Prints #PID<...> where the pid is for the process that called register/3 above\n      #=> :ok\n\n  Dispatching happens in the process that calls `dispatch/3` either serially or\n  concurrently in case of multiple partitions (via spawned tasks). The\n  registered processes are not involved in dispatching unless involving them is\n  done explicitly (for example, by sending them a message in the callback).\n\n  Furthermore, if there is a failure when dispatching, due to a bad\n  registration, dispatching will always fail and the registered process will not\n  be notified. Therefore let's make sure we at least wrap and report those\n  errors:\n\n      require Logger\n      Registry.dispatch(Registry.DispatcherTest, \"hello\", fn entries ->\n        for {pid, {module, function}} <- entries do\n          try do\n            apply(module, function, [pid])\n          catch\n            kind, reason ->\n              formatted = Exception.format(kind, reason, System.stacktrace)\n              Logger.error \"Registry.dispatch/3 failed with #{formatted}\"\n          end\n        end\n      end)\n      # Prints #PID<...>\n      #=> :ok\n\n  You could also replace the whole `apply` system by explicitly sending\n  messages. That's the example we will see next.\n\n  ## Using as a PubSub\n\n  Registries can also be used to implement a local, non-distributed, scalable\n  PubSub by relying on the `dispatch/3` function, similarly to the previous\n  section: in this case, however, we will send messages to each associated\n  process, instead of invoking a given module-function.\n\n  In this example, we will also set the number of partitions to the number of\n  schedulers online, which will make the registry more performant on highly\n  concurrent environments as each partition will spawn a new process, allowing\n  dispatching to happen in parallel:\n\n      {:ok, _} = Registry.start_link(:duplicate, Registry.PubSubTest,\n                                     partitions: System.schedulers_online)\n      {:ok, _} = Registry.register(Registry.PubSubTest, \"hello\", [])\n      Registry.dispatch(Registry.PubSubTest, \"hello\", fn entries ->\n        for {pid, _} <- entries, do: send(pid, {:broadcast, \"world\"})\n      end)\n      #=> :ok\n\n  The example above broadcasted the message `{:broadcast, \"world\"}` to all\n  processes registered under the \"topic\" (or \"key\" as we called it until now)\n  `\"hello\"`.\n\n  The third argument given to `register/3` is a value associated to the\n  current process. While in the previous section we used it when dispatching,\n  in this particular example we are not interested in it, so we have set it\n  to an empty list. You could store a more meaningful value if necessary.\n\n  ## Registrations\n\n  Looking up, dispatching and registering are efficient and immediate at\n  the cost of delayed unsubscription. For example, if a process crashes,\n  its keys are automatically removed from the registry but the change may\n  not propagate immediately. This means certain operations may return processes\n  that are already dead. When such may happen, it will be explicitly stated\n  in the function documentation.\n\n  However, keep in mind those cases are typically not an issue. After all, a\n  process referenced by a pid may crash at any time, including between getting\n  the value from the registry and sending it a message. Many parts of the standard\n  library are designed to cope with that, such as `Process.monitor/1` which will\n  deliver the `:DOWN` message immediately if the monitored process is already dead\n  and `Kernel.send/2` which acts as a no-op for dead processes.\n\n  ## ETS\n\n  Note that the registry uses one ETS table plus two ETS tables per partition.\n  ",
    key = {
      description = "key :: term\n"
    },
    kind = {
      description = "kind :: :unique | :duplicate\n"
    },
    meta_key = {
      description = "meta_key :: atom | tuple\n"
    },
    meta_value = {
      description = "meta_value :: term\n"
    },
    register_name = {
      description = "\nregister_name({registry, key}, pid) when pid == self() \nfalse"
    },
    registry = {
      description = "registry :: atom\n"
    },
    send = {
      description = "\nsend({registry, key}, msg)\nfalse"
    },
    unregister_name = {
      description = "\nunregister_name({registry, key})\nfalse"
    },
    value = {
      description = "value :: term\n"
    },
    whereis_name = {
      description = "\nwhereis_name({registry, key})\nfalse"
    }
  },
  Requirement = {
    t = {
      description = "t :: %__MODULE__{}\n"
    }
  },
  RuntimeError = {},
  Set = {
    delete = {
      description = "\ndelete(set, value)\n"
    },
    description = "\n  WARNING: this module is deprecated.\n\n  Use the `MapSet` module instead.\n  ",
    difference = {
      description = "\ndifference(set1, set2)\n"
    },
    ["disjoint?"] = {
      description = "\ndisjoint?(set1, set2)\n"
    },
    empty = {
      description = "\nempty(set)\nfalse"
    },
    ["equal?"] = {
      description = "\nequal?(set1, set2)\n"
    },
    intersection = {
      description = "\nintersection(set1, set2)\n"
    },
    ["member?"] = {
      description = "\nmember?(set, value)\n"
    },
    put = {
      description = "\nput(set, value)\n"
    },
    size = {
      description = "\nsize(set)\n"
    },
    ["subset?"] = {
      description = "\nsubset?(set1, set2)\n"
    },
    t = {
      description = "t :: map\n"
    },
    to_list = {
      description = "\nto_list(set)\n"
    },
    union = {
      description = "\nunion(set1, set2)\n"
    },
    value = {
      description = "value :: any\n"
    },
    values = {
      description = "values :: [value]\n"
    }
  },
  SpecialForms = nil,
  Stream = {
    Reducers = {
      chunk = {
        description = "\nchunk(amount, step, limit, fun \\\\ nil)\n"
      },
      chunk_by = {
        description = "\nchunk_by(callback, fun \\\\ nil)\n"
      },
      dedup = {
        description = "\ndedup(callback, fun \\\\ nil)\n"
      },
      description = "false",
      drop = {
        description = "\ndrop(fun \\\\ nil)\n"
      },
      drop_every = {
        description = "\ndrop_every(nth, fun \\\\ nil)\n"
      },
      drop_while = {
        description = "\ndrop_while(callback, fun \\\\ nil)\n"
      },
      filter = {
        description = "\nfilter(callback, fun \\\\ nil)\n"
      },
      filter_map = {
        description = "\nfilter_map(filter, mapper, fun \\\\ nil)\n"
      },
      map = {
        description = "\nmap(callback, fun \\\\ nil)\n"
      },
      map_every = {
        description = "\nmap_every(nth, mapper, fun \\\\ nil)\n"
      },
      reject = {
        description = "\nreject(callback, fun \\\\ nil)\n"
      },
      scan2 = {
        description = "\nscan2(callback, fun \\\\ nil)\n"
      },
      scan3 = {
        description = "\nscan3(callback, fun \\\\ nil)\n"
      },
      take = {
        description = "\ntake(fun \\\\ nil)\n"
      },
      take_every = {
        description = "\ntake_every(nth, fun \\\\ nil)\n"
      },
      take_while = {
        description = "\ntake_while(callback, fun \\\\ nil)\n"
      },
      uniq_by = {
        description = "\nuniq_by(callback, fun \\\\ nil)\n"
      },
      with_index = {
        description = "\nwith_index(fun \\\\ nil)\n"
      }
    },
    acc = {
      description = "acc :: any\n"
    },
    count = {
      description = "\ncount(_lazy)\n"
    },
    cycle = {
      description = "\ncycle(enumerable)\n@spec cycle(Enumerable.t) :: Enumerable.t\n  \ncycle(enumerable) when is_list(enumerable) \n\n  Creates a stream that cycles through the given enumerable,\n  infinitely.\n\n  ## Examples\n\n      iex> stream = Stream.cycle([1, 2, 3])\n      iex> Enum.take(stream, 5)\n      [1, 2, 3, 1, 2]\n\n  "
    },
    default = {
      description = "default :: any\n"
    },
    description = "\n  Module for creating and composing streams.\n\n  Streams are composable, lazy enumerables. Any enumerable that generates\n  items one by one during enumeration is called a stream. For example,\n  Elixir's `Range` is a stream:\n\n      iex> range = 1..5\n      1..5\n      iex> Enum.map range, &(&1 * 2)\n      [2, 4, 6, 8, 10]\n\n  In the example above, as we mapped over the range, the elements being\n  enumerated were created one by one, during enumeration. The `Stream`\n  module allows us to map the range, without triggering its enumeration:\n\n      iex> range = 1..3\n      iex> stream = Stream.map(range, &(&1 * 2))\n      iex> Enum.map(stream, &(&1 + 1))\n      [3, 5, 7]\n\n  Notice we started with a range and then we created a stream that is\n  meant to multiply each item in the range by 2. At this point, no\n  computation was done. Only when `Enum.map/2` is called we actually\n  enumerate over each item in the range, multiplying it by 2 and adding 1.\n  We say the functions in `Stream` are *lazy* and the functions in `Enum`\n  are *eager*.\n\n  Due to their laziness, streams are useful when working with large\n  (or even infinite) collections. When chaining many operations with `Enum`,\n  intermediate lists are created, while `Stream` creates a recipe of\n  computations that are executed at a later moment. Let's see another\n  example:\n\n      1..3\n      |> Enum.map(&IO.inspect(&1))\n      |> Enum.map(&(&1 * 2))\n      |> Enum.map(&IO.inspect(&1))\n      1\n      2\n      3\n      2\n      4\n      6\n      #=> [2, 4, 6]\n\n  Notice that we first printed each item in the list, then multiplied each\n  element by 2 and finally printed each new value. In this example, the list\n  was enumerated three times. Let's see an example with streams:\n\n      stream = 1..3\n      |> Stream.map(&IO.inspect(&1))\n      |> Stream.map(&(&1 * 2))\n      |> Stream.map(&IO.inspect(&1))\n      Enum.to_list(stream)\n      1\n      2\n      2\n      4\n      3\n      6\n      #=> [2, 4, 6]\n\n  Although the end result is the same, the order in which the items were\n  printed changed! With streams, we print the first item and then print\n  its double. In this example, the list was enumerated just once!\n\n  That's what we meant when we said earlier that streams are composable,\n  lazy enumerables. Notice we could call `Stream.map/2` multiple times,\n  effectively composing the streams and keeping them lazy. The computations\n  are only performed when you call a function from the `Enum` module.\n\n  ## Creating Streams\n\n  There are many functions in Elixir's standard library that return\n  streams, some examples are:\n\n    * `IO.stream/2`         - streams input lines, one by one\n    * `URI.query_decoder/1` - decodes a query string, pair by pair\n\n  This module also provides many convenience functions for creating streams,\n  like `Stream.cycle/1`, `Stream.unfold/2`, `Stream.resource/3` and more.\n\n  Note the functions in this module are guaranteed to return enumerables.\n  Since enumerables can have different shapes (structs, anonymous functions,\n  and so on), the functions in this module may return any of those shapes\n  and that this may change at any time. For example, a function that today\n  returns an anonymous function may return a struct in future releases.\n  ",
    drop = {
      description = "@spec drop(Enumerable.t, non_neg_integer) :: Enumerable.t\n  \ndrop(enum, n) when n < 0 \n\n  Lazily drops the next `n` items from the enumerable.\n\n  If a negative `n` is given, it will drop the last `n` items from\n  the collection. Note that the mechanism by which this is implemented\n  will delay the emission of any item until `n` additional items have\n  been emitted by the enum.\n\n  ## Examples\n\n      iex> stream = Stream.drop(1..10, 5)\n      iex> Enum.to_list(stream)\n      [6, 7, 8, 9, 10]\n\n      iex> stream = Stream.drop(1..10, -5)\n      iex> Enum.to_list(stream)\n      [1, 2, 3, 4, 5]\n\n  "
    },
    drop_every = {
      description = "\ndrop_every(enum, nth) when is_integer(nth) and nth > 0 \n\ndrop_every([], _nth)\n@spec drop_every(Enumerable.t, non_neg_integer) :: Enumerable.t\n  \ndrop_every(enum, 0)\n\n  Creates a stream that drops every `nth` item from the enumerable.\n\n  The first item is always dropped, unless `nth` is 0.\n\n  `nth` must be a non-negative integer.\n\n  ## Examples\n\n      iex> stream = Stream.drop_every(1..10, 2)\n      iex> Enum.to_list(stream)\n      [2, 4, 6, 8, 10]\n\n      iex> stream = Stream.drop_every(1..1000, 1)\n      iex> Enum.to_list(stream)\n      []\n\n      iex> stream = Stream.drop_every([1, 2, 3, 4, 5], 0)\n      iex> Enum.to_list(stream)\n      [1, 2, 3, 4, 5]\n\n  "
    },
    element = {
      description = "element :: any\n"
    },
    index = {
      description = "index :: non_neg_integer\n"
    },
    inspect = {
      description = "\ninspect(%{enum: enum, funs: funs}, opts)\n"
    },
    map_every = {
      description = "\nmap_every(enum, nth, fun) when is_integer(nth) and nth > 0 \n\nmap_every([], _nth, _fun)\n\nmap_every(enum, 0, _fun)\n@spec map_every(Enumerable.t, non_neg_integer, (element -> any)) :: Enumerable.t\n  \nmap_every(enum, 1, fun)\n\n  Creates a stream that will apply the given function on\n  every `nth` item from the enumerable.\n\n  The first item is always passed to the given function.\n\n  `nth` must be a non-negative integer.\n\n  ## Examples\n\n      iex> stream = Stream.map_every(1..10, 2, fn(x) -> x * 2 end)\n      iex> Enum.to_list(stream)\n      [2, 2, 6, 4, 10, 6, 14, 8, 18, 10]\n\n      iex> stream = Stream.map_every([1, 2, 3, 4, 5], 1, fn(x) -> x * 2 end)\n      iex> Enum.to_list(stream)\n      [2, 4, 6, 8, 10]\n\n      iex> stream = Stream.map_every(1..5, 0, fn(x) -> x * 2 end)\n      iex> Enum.to_list(stream)\n      [1, 2, 3, 4, 5]\n\n  "
    },
    ["member?"] = {
      description = "\nmember?(_lazy, _value)\n"
    },
    reduce = {
      description = "@spec unfold(acc, (acc -> {element, acc} | nil)) :: Enumerable.t\n  \nreduce(lazy, acc, fun)\n\n  Emits a sequence of values for the given accumulator.\n\n  Successive values are generated by calling `next_fun` with the previous\n  accumulator and it must return a tuple with the current value and next\n  accumulator. The enumeration finishes if it returns `nil`.\n\n  ## Examples\n\n      iex> Stream.unfold(5, fn 0 -> nil; n -> {n, n-1} end) |> Enum.to_list()\n      [5, 4, 3, 2, 1]\n\n  "
    },
    take = {
      description = "\ntake(enum, count) when is_integer(count) and count < 0 \n\ntake(enum, count) when is_integer(count) and count > 0 \n@spec take(Enumerable.t, integer) :: Enumerable.t\n  \ntake([], _count)\n\n  Lazily takes the next `count` items from the enumerable and stops\n  enumeration.\n\n  If a negative `count` is given, the last `count` values will be taken.\n  For such, the collection is fully enumerated keeping up to `2 * count`\n  elements in memory. Once the end of the collection is reached,\n  the last `count` elements will be executed. Therefore, using\n  a negative `count` on an infinite collection will never return.\n\n  ## Examples\n\n      iex> stream = Stream.take(1..100, 5)\n      iex> Enum.to_list(stream)\n      [1, 2, 3, 4, 5]\n\n      iex> stream = Stream.take(1..100, -5)\n      iex> Enum.to_list(stream)\n      [96, 97, 98, 99, 100]\n\n      iex> stream = Stream.cycle([1, 2, 3]) |> Stream.take(5)\n      iex> Enum.to_list(stream)\n      [1, 2, 3, 1, 2]\n\n  "
    },
    take_every = {
      description = "\ntake_every(enum, nth) when is_integer(nth) and nth > 0 \n\ntake_every([], _nth)\n@spec take_every(Enumerable.t, non_neg_integer) :: Enumerable.t\n  \ntake_every(_enum, 0)\n\n  Creates a stream that takes every `nth` item from the enumerable.\n\n  The first item is always included, unless `nth` is 0.\n\n  `nth` must be a non-negative integer.\n\n  ## Examples\n\n      iex> stream = Stream.take_every(1..10, 2)\n      iex> Enum.to_list(stream)\n      [1, 3, 5, 7, 9]\n\n      iex> stream = Stream.take_every([1, 2, 3, 4, 5], 1)\n      iex> Enum.to_list(stream)\n      [1, 2, 3, 4, 5]\n\n      iex> stream = Stream.take_every(1..1000, 0)\n      iex> Enum.to_list(stream)\n      []\n\n  "
    },
    uniq = {
      description = "@spec uniq(Enumerable.t) :: Enumerable.t\n  \nuniq(enum, fun)\nfalse"
    }
  },
  String = {
    Chars = {
      description = "\n  The `String.Chars` protocol is responsible for\n  converting a structure to a binary (only if applicable).\n  The only function required to be implemented is\n  `to_string` which does the conversion.\n\n  The `to_string/1` function automatically imported\n  by `Kernel` invokes this protocol. String\n  interpolation also invokes `to_string` in its\n  arguments. For example, `\"foo#{bar}\"` is the same\n  as `\"foo\" <> to_string(bar)`.\n  ",
      to_string = {
        description = "\nto_string(term)\n\nto_string(term)\n\nto_string(charlist)\n\nto_string(term)\n\nto_string(term) when is_binary(term) \n\nto_string(atom)\n\nto_string(nil)\n\nto_string(term)\n"
      }
    },
    at = {
      description = "@spec length(t) :: non_neg_integer\n  defdelegate length(string), to: String.Unicode\n\n  @doc \"\"\"\n  Returns the grapheme at the `position` of the given UTF-8 `string`.\n  If `position` is greater than `string` length, then it returns `nil`.\n\n  ## Examples\n\n      iex> String.at(\"elixir\", 0)\n      \"e\"\n\n      iex> String.at(\"elixir\", 1)\n      \"l\"\n\n      iex> String.at(\"elixir\", 10)\n      nil\n\n      iex> String.at(\"elixir\", -1)\n      \"r\"\n\n      iex> String.at(\"elixir\", -10)\n      nil\n\n  \"\"\"\n  @spec at(t, integer) :: grapheme | nil\n\n  \nat(string, position) when is_integer(position) and position < 0 \n\n  Returns the number of Unicode graphemes in a UTF-8 string.\n\n  ## Examples\n\n      iex> String.length(\"elixir\")\n      6\n\n      iex> String.length(\"եոգլի\")\n      5\n\n  "
    },
    chunk = {
      description = "\nchunk(string, trait) when trait in [:valid, :printable] \n@spec chunk(t, :valid | :printable) :: [t]\n\n  \nchunk(\"\", _)\n\n  Splits the string into chunks of characters that share a common trait.\n\n  The trait can be one of two options:\n\n    * `:valid` - the string is split into chunks of valid and invalid\n      character sequences\n\n    * `:printable` - the string is split into chunks of printable and\n      non-printable character sequences\n\n  Returns a list of binaries each of which contains only one kind of\n  characters.\n\n  If the given string is empty, an empty list is returned.\n\n  ## Examples\n\n      iex> String.chunk(<<?a, ?b, ?c, 0>>, :valid)\n      [\"abc\\0\"]\n\n      iex> String.chunk(<<?a, ?b, ?c, 0, 0x0FFFF::utf8>>, :valid)\n      [\"abc\\0\", <<0x0FFFF::utf8>>]\n\n      iex> String.chunk(<<?a, ?b, ?c, 0, 0x0FFFF::utf8>>, :printable)\n      [\"abc\", <<0, 0x0FFFF::utf8>>]\n\n  "
    },
    codepoint = {
      description = "codepoint :: t\n"
    },
    ["contains?"] = {
      description = "\ncontains?(string, contents) when is_binary(string) \n@spec contains?(t, pattern) :: boolean\n  \ncontains?(string, contents) when is_binary(string) and is_list(contents) \n\n  Checks if `string` contains any of the given `contents`.\n\n  `contents` can be either a single string or a list of strings.\n\n  ## Examples\n\n      iex> String.contains? \"elixir of life\", \"of\"\n      true\n      iex> String.contains? \"elixir of life\", [\"life\", \"death\"]\n      true\n      iex> String.contains? \"elixir of life\", [\"death\", \"mercury\"]\n      false\n\n  An empty string will always match:\n\n      iex> String.contains? \"elixir of life\", \"\"\n      true\n      iex> String.contains? \"elixir of life\", [\"\", \"other\"]\n      true\n\n  The argument can also be a precompiled pattern:\n\n      iex> pattern = :binary.compile_pattern([\"life\", \"death\"])\n      iex> String.contains? \"elixir of life\", pattern\n      true\n\n  "
    },
    description = "\n  A String in Elixir is a UTF-8 encoded binary.\n\n  ## Codepoints and grapheme cluster\n\n  The functions in this module act according to the Unicode\n  Standard, version 9.0.0.\n\n  As per the standard, a codepoint is a single Unicode Character,\n  which may be represented by one or more bytes.\n\n  For example, the codepoint \"é\" is two bytes:\n\n      iex> byte_size(\"é\")\n      2\n\n  However, this module returns the proper length:\n\n      iex> String.length(\"é\")\n      1\n\n  Furthermore, this module also presents the concept of grapheme cluster\n  (from now on referenced as graphemes). Graphemes can consist of multiple\n  codepoints that may be perceived as a single character by readers. For\n  example, \"é\" can be represented either as a single \"e with acute\" codepoint\n  or as the letter \"e\" followed by a \"combining acute accent\" (two codepoints):\n\n      iex> string = \"\\u0065\\u0301\"\n      iex> byte_size(string)\n      3\n      iex> String.length(string)\n      1\n      iex> String.codepoints(string)\n      [\"e\", \"́\"]\n      iex> String.graphemes(string)\n      [\"é\"]\n\n  Although the example above is made of two characters, it is\n  perceived by users as one.\n\n  Graphemes can also be two characters that are interpreted\n  as one by some languages. For example, some languages may\n  consider \"ch\" as a single character. However, since this\n  information depends on the locale, it is not taken into account\n  by this module.\n\n  In general, the functions in this module rely on the Unicode\n  Standard, but do not contain any of the locale specific behaviour.\n\n  More information about graphemes can be found in the [Unicode\n  Standard Annex #29](http://www.unicode.org/reports/tr29/).\n  The current Elixir version implements Extended Grapheme Cluster\n  algorithm.\n\n  ## String and binary operations\n\n  To act according to the Unicode Standard, many functions\n  in this module run in linear time, as they need to traverse\n  the whole string considering the proper Unicode codepoints.\n\n  For example, `String.length/1` will take longer as\n  the input grows. On the other hand, `Kernel.byte_size/1` always runs\n  in constant time (i.e. regardless of the input size).\n\n  This means often there are performance costs in using the\n  functions in this module, compared to the more low-level\n  operations that work directly with binaries:\n\n    * `Kernel.binary_part/3` - retrieves part of the binary\n    * `Kernel.bit_size/1` and `Kernel.byte_size/1` - size related functions\n    * `Kernel.is_bitstring/1` and `Kernel.is_binary/1` - type checking function\n    * Plus a number of functions for working with binaries (bytes)\n      in the [`:binary` module](http://www.erlang.org/doc/man/binary.html)\n\n  There are many situations where using the `String` module can\n  be avoided in favor of binary functions or pattern matching.\n  For example, imagine you have a string `prefix` and you want to\n  remove this prefix from another string named `full`.\n\n  One may be tempted to write:\n\n      iex> take_prefix = fn full, prefix ->\n      ...>   base = String.length(prefix)\n      ...>   String.slice(full, base, String.length(full) - base)\n      ...> end\n      iex> take_prefix.(\"Mr. John\", \"Mr. \")\n      \"John\"\n\n  Although the function above works, it performs poorly. To\n  calculate the length of the string, we need to traverse it\n  fully, so we traverse both `prefix` and `full` strings, then\n  slice the `full` one, traversing it again.\n\n  A first attempt at improving it could be with ranges:\n\n      iex> take_prefix = fn full, prefix ->\n      ...>   base = String.length(prefix)\n      ...>   String.slice(full, base..-1)\n      ...> end\n      iex> take_prefix.(\"Mr. John\", \"Mr. \")\n      \"John\"\n\n  While this is much better (we don't traverse `full` twice),\n  it could still be improved. In this case, since we want to\n  extract a substring from a string, we can use `Kernel.byte_size/1`\n  and `Kernel.binary_part/3` as there is no chance we will slice in\n  the middle of a codepoint made of more than one byte:\n\n      iex> take_prefix = fn full, prefix ->\n      ...>   base = byte_size(prefix)\n      ...>   binary_part(full, base, byte_size(full) - base)\n      ...> end\n      iex> take_prefix.(\"Mr. John\", \"Mr. \")\n      \"John\"\n\n  Or simply use pattern matching:\n\n      iex> take_prefix = fn full, prefix ->\n      ...>   base = byte_size(prefix)\n      ...>   <<_::binary-size(base), rest::binary>> = full\n      ...>   rest\n      ...> end\n      iex> take_prefix.(\"Mr. John\", \"Mr. \")\n      \"John\"\n\n  On the other hand, if you want to dynamically slice a string\n  based on an integer value, then using `String.slice/3` is the\n  best option as it guarantees we won't incorrectly split a valid\n  codepoint into multiple bytes.\n\n  ## Integer codepoints\n\n  Although codepoints could be represented as integers, this\n  module represents all codepoints as strings. For example:\n\n      iex> String.codepoints(\"olá\")\n      [\"o\", \"l\", \"á\"]\n\n  There are a couple of ways to retrieve a character integer\n  codepoint. One may use the `?` construct:\n\n      iex> ?o\n      111\n\n      iex> ?á\n      225\n\n  Or also via pattern matching:\n\n      iex> <<aacute::utf8>> = \"á\"\n      iex> aacute\n      225\n\n  As we have seen above, codepoints can be inserted into\n  a string by their hexadecimal code:\n\n      \"ol\\u0061\\u0301\" #=>\n      \"olá\"\n\n  ## Self-synchronization\n\n  The UTF-8 encoding is self-synchronizing. This means that\n  if malformed data (i.e., data that is not possible according\n  to the definition of the encoding) is encountered, only one\n  codepoint needs to be rejected.\n\n  This module relies on this behaviour to ignore such invalid\n  characters. For example, `length/1` will return\n  a correct result even if an invalid codepoint is fed into it.\n\n  In other words, this module expects invalid data to be detected\n  elsewhere, usually when retrieving data from the external source.\n  For example, a driver that reads strings from a database will be\n  responsible to check the validity of the encoding. `String.chunk/2`\n  can be used for breaking a string into valid and invalid parts.\n\n  ## Patterns\n\n  Many functions in this module work with patterns. For example,\n  `String.split/2` can split a string into multiple patterns given\n  a pattern. This pattern can be a string, a list of strings or\n  a compiled pattern:\n\n      iex> String.split(\"foo bar\", \" \")\n      [\"foo\", \"bar\"]\n\n      iex> String.split(\"foo bar!\", [\" \", \"!\"])\n      [\"foo\", \"bar\", \"\"]\n\n      iex> pattern = :binary.compile_pattern([\" \", \"!\"])\n      iex> String.split(\"foo bar!\", pattern)\n      [\"foo\", \"bar\", \"\"]\n\n  The compiled pattern is useful when the same match will\n  be done over and over again. Note though the compiled\n  pattern cannot be stored in a module attribute as the pattern\n  is generated at runtime and does not survive compile term.\n  ",
    ["ends_with?"] = {
      description = "@spec ends_with?(t, t | [t]) :: boolean\n  \nends_with?(string, suffix) when is_binary(string) \n\n  Returns `true` if `string` ends with any of the suffixes given.\n\n  `suffixes` can be either a single suffix or a list of suffixes.\n\n  ## Examples\n\n      iex> String.ends_with? \"language\", \"age\"\n      true\n      iex> String.ends_with? \"language\", [\"youth\", \"age\"]\n      true\n      iex> String.ends_with? \"language\", [\"youth\", \"elixir\"]\n      false\n\n  An empty suffix will always match:\n\n      iex> String.ends_with? \"language\", \"\"\n      true\n      iex> String.ends_with? \"language\", [\"\", \"other\"]\n      true\n\n  "
    },
    grapheme = {
      description = "grapheme :: t\n"
    },
    jaro_distance = {
      description = "\njaro_distance(string1, string2)\n\njaro_distance(\"\", _string)\n\njaro_distance(_string, \"\")\n@spec jaro_distance(t, t) :: float\n  \njaro_distance(string, string)\n\n  Returns a float value between 0 (equates to no similarity) and 1 (is an exact match)\n  representing [Jaro](https://en.wikipedia.org/wiki/Jaro–Winkler_distance)\n  distance between `string1` and `string2`.\n\n  The Jaro distance metric is designed and best suited for short strings such as person names.\n\n  ## Examples\n\n      iex> String.jaro_distance(\"dwayne\", \"duane\")\n      0.8222222222222223\n      iex> String.jaro_distance(\"even\", \"odd\")\n      0.0\n\n  "
    },
    ljust = {
      description = "\nljust(subject, len, pad \\\\ ?\\s) when is_integer(pad) and is_integer(len) and len >= 0 \nfalse"
    },
    lstrip = {
      description = "@spec replace_suffix(t, t, t) :: t\n  \nlstrip(string, char) when is_integer(char) \nfalse"
    },
    pad_leading = {
      description = "\npad_leading(string, count, [_ | _] = padding)\n      when is_binary(string) and is_integer(count) and count >= 0 \n@spec pad_leading(t, non_neg_integer, t | [t]) :: t\n  \npad_leading(string, count, padding) when is_binary(padding) \n\n  Returns a new string padded with a leading filler\n  which is made of elements from the `padding`.\n\n  Passing a list of strings as `padding` will take one element of the list\n  for every missing entry. If the list is shorter than the number of inserts,\n  the filling will start again from the beginning of the list.\n  Passing a string `padding` is equivalent to passing the list of graphemes in it.\n  If no `padding` is given, it defaults to whitespace.\n\n  When `count` is less than or equal to the length of `string`,\n  given `string` is returned.\n\n  Raises `ArgumentError` if the given `padding` contains non-string element.\n\n  ## Examples\n\n      iex> String.pad_leading(\"abc\", 5)\n      \"  abc\"\n\n      iex> String.pad_leading(\"abc\", 4, \"12\")\n      \"1abc\"\n\n      iex> String.pad_leading(\"abc\", 6, \"12\")\n      \"121abc\"\n\n      iex> String.pad_leading(\"abc\", 5, [\"1\", \"23\"])\n      \"123abc\"\n\n  "
    },
    pad_trailing = {
      description = "\npad_trailing(string, count, [_ | _] = padding)\n      when is_binary(string) and is_integer(count) and count >= 0 \n@spec pad_trailing(t, non_neg_integer, t | [t]) :: t\n  \npad_trailing(string, count, padding) when is_binary(padding) \n\n  Returns a new string padded with a trailing filler\n  which is made of elements from the `padding`.\n\n  Passing a list of strings as `padding` will take one element of the list\n  for every missing entry. If the list is shorter than the number of inserts,\n  the filling will start again from the beginning of the list.\n  Passing a string `padding` is equivalent to passing the list of graphemes in it.\n  If no `padding` is given, it defaults to whitespace.\n\n  When `count` is less than or equal to the length of `string`,\n  given `string` is returned.\n\n  Raises `ArgumentError` if the given `padding` contains non-string element.\n\n  ## Examples\n\n      iex> String.pad_trailing(\"abc\", 5)\n      \"abc  \"\n\n      iex> String.pad_trailing(\"abc\", 4, \"12\")\n      \"abc1\"\n\n      iex> String.pad_trailing(\"abc\", 6, \"12\")\n      \"abc121\"\n\n      iex> String.pad_trailing(\"abc\", 5, [\"1\", \"23\"])\n      \"abc123\"\n\n  "
    },
    pattern = {
      description = "pattern :: t | [t] | :binary.cp\n"
    },
    ["printable?"] = {
      description = "\nprintable?(binary) when is_binary(binary), \n\nprintable?(<<>>)\n\nprintable?(<<char::utf8, rest::binary>>)\n      when char in 0xA0..0xD7FF\n      when char in 0xE000..0xFFFD\n      when char in 0x10000..0x10FFFF \n\nprintable?(<<?\\a, rest::binary>>)\n\nprintable?(<<?\\d, rest::binary>>)\n\nprintable?(<<?\\e, rest::binary>>)\n\nprintable?(<<?\\f, rest::binary>>)\n\nprintable?(<<?\\b, rest::binary>>)\n\nprintable?(<<?\\v, rest::binary>>)\n\nprintable?(<<?\\t, rest::binary>>)\n\nprintable?(<<?\\r, rest::binary>>)\n@spec printable?(t) :: boolean\n  \nprintable?(<<?\\n, rest::binary>>)\n\n  Checks if a string contains only printable characters.\n\n  ## Examples\n\n      iex> String.printable?(\"abc\")\n      true\n\n  "
    },
    rjust = {
      description = "\nrjust(subject, len, pad \\\\ ?\\s) when is_integer(pad) and is_integer(len) and len >= 0 \nfalse"
    },
    rstrip = {
      description = "@spec normalize(t, atom) :: t\n  defdelegate normalize(string, form), to: String.Normalizer\n\n  @doc \"\"\"\n  Converts all characters in the given string to uppercase.\n\n  ## Examples\n\n      iex> String.upcase(\"abcd\")\n      \"ABCD\"\n\n      iex> String.upcase(\"ab 123 xpto\")\n      \"AB 123 XPTO\"\n\n      iex> String.upcase(\"olá\")\n      \"OLÁ\"\n\n  \"\"\"\n  @spec upcase(t) :: t\n  defdelegate upcase(binary), to: String.Casing\n\n  @doc \"\"\"\n  Converts all characters in the given string to lowercase.\n\n  ## Examples\n\n      iex> String.downcase(\"ABCD\")\n      \"abcd\"\n\n      iex> String.downcase(\"AB 123 XPTO\")\n      \"ab 123 xpto\"\n\n      iex> String.downcase(\"OLÁ\")\n      \"olá\"\n\n  \"\"\"\n  @spec downcase(t) :: t\n  defdelegate downcase(binary), to: String.Casing\n\n  @doc \"\"\"\n  Converts the first character in the given string to\n  uppercase and the remainder to lowercase.\n\n  This relies on the titlecase information provided\n  by the Unicode Standard. Note this function makes\n  no attempt to capitalize all words in the string\n  (usually known as titlecase).\n\n  ## Examples\n\n      iex> String.capitalize(\"abcd\")\n      \"Abcd\"\n\n      iex> String.capitalize(\"ﬁn\")\n      \"Fin\"\n\n      iex> String.capitalize(\"olá\")\n      \"Olá\"\n\n  \"\"\"\n  @spec capitalize(t) :: t\n  \nrstrip(string, char) when is_integer(char) \nfalse"
    },
    slice = {
      description = "\nslice(string, first..last)\n\nslice(string, first..last) when first >= 0 and last >= 0 \n\nslice(string, first..-1) when first >= 0 \n@spec slice(t, Range.t) :: t\n\n  \nslice(\"\", _.._)\n  Returns a substring from the offset given by the start of the\n  range to the offset given by the end of the range.\n\n  If the start of the range is not a valid offset for the given\n  string or if the range is in reverse order, returns `\"\"`.\n\n  If the start or end of the range is negative, the whole string\n  is traversed first in order to convert the negative indices into\n  positive ones.\n\n  Remember this function works with Unicode graphemes and considers\n  the slices to represent grapheme offsets. If you want to split\n  on raw bytes, check `Kernel.binary_part/3` instead.\n\n  ## Examples\n\n      iex> String.slice(\"elixir\", 1..3)\n      \"lix\"\n\n      iex> String.slice(\"elixir\", 1..10)\n      \"lixir\"\n\n      iex> String.slice(\"elixir\", 10..3)\n      \"\"\n\n      iex> String.slice(\"elixir\", -4..-1)\n      \"ixir\"\n\n      iex> String.slice(\"elixir\", 2..-1)\n      \"ixir\"\n\n      iex> String.slice(\"elixir\", -4..6)\n      \"ixir\"\n\n      iex> String.slice(\"elixir\", -1..-4)\n      \"\"\n\n      iex> String.slice(\"elixir\", -10..-7)\n      \"\"\n\n      iex> String.slice(\"a\", 0..1500)\n      \"a\"\n\n      iex> String.slice(\"a\", 1..1500)\n      \"\"\n\n  \n\nslice(string, start, len) when start < 0 and len >= 0 \n@spec slice(t, integer, integer) :: grapheme\n\n  \nslice(string, start, len) when start >= 0 and len >= 0 \n\n  Returns a substring starting at the offset `start`, and of\n  length `len`.\n\n  If the offset is greater than string length, then it returns `\"\"`.\n\n  Remember this function works with Unicode graphemes and considers\n  the slices to represent grapheme offsets. If you want to split\n  on raw bytes, check `Kernel.binary_part/3` instead.\n\n  ## Examples\n\n      iex> String.slice(\"elixir\", 1, 3)\n      \"lix\"\n\n      iex> String.slice(\"elixir\", 1, 10)\n      \"lixir\"\n\n      iex> String.slice(\"elixir\", 10, 3)\n      \"\"\n\n      iex> String.slice(\"elixir\", -4, 4)\n      \"ixir\"\n\n      iex> String.slice(\"elixir\", -10, 3)\n      \"\"\n\n      iex> String.slice(\"a\", 0, 1500)\n      \"a\"\n\n      iex> String.slice(\"a\", 1, 1500)\n      \"\"\n\n      iex> String.slice(\"a\", 2, 1500)\n      \"\"\n\n  "
    },
    split = {
      description = "\nsplit(string, pattern, options) when is_binary(string) \n\nsplit(string, pattern, []) when is_binary(string) and pattern != \"\" \n@spec split(t) :: [t]\n  defdelegate split(binary), to: String.Break\n\n  @doc ~S\"\"\"\n  Divides a string into substrings based on a pattern.\n\n  Returns a list of these substrings. The pattern can\n  be a string, a list of strings or a regular expression.\n\n  The string is split into as many parts as possible by\n  default, but can be controlled via the `parts: pos_integer` option.\n  If you pass `parts: :infinity`, it will return all possible parts\n  (`:infinity` is the default).\n\n  Empty strings are only removed from the result if the\n  `trim` option is set to `true` (default is `false`).\n\n  When the pattern used is a regular expression, the string is\n  split using `Regex.split/3`. In that case this function accepts\n  additional options which are documented in `Regex.split/3`.\n\n  ## Examples\n\n  Splitting with a string pattern:\n\n      iex> String.split(\"a,b,c\", \",\")\n      [\"a\", \"b\", \"c\"]\n\n      iex> String.split(\"a,b,c\", \",\", parts: 2)\n      [\"a\", \"b,c\"]\n\n      iex> String.split(\" a b c \", \" \", trim: true)\n      [\"a\", \"b\", \"c\"]\n\n  A list of patterns:\n\n      iex> String.split(\"1,2 3,4\", [\" \", \",\"])\n      [\"1\", \"2\", \"3\", \"4\"]\n\n  A regular expression:\n\n      iex> String.split(\"a,b,c\", ~r{,})\n      [\"a\", \"b\", \"c\"]\n\n      iex> String.split(\"a,b,c\", ~r{,}, parts: 2)\n      [\"a\", \"b,c\"]\n\n      iex> String.split(\" a b c \", ~r{\\s}, trim: true)\n      [\"a\", \"b\", \"c\"]\n\n      iex> String.split(\"abc\", ~r{b}, include_captures: true)\n      [\"a\", \"b\", \"c\"]\n\n  Splitting on empty patterns returns graphemes:\n\n      iex> String.split(\"abc\", ~r{})\n      [\"a\", \"b\", \"c\", \"\"]\n\n      iex> String.split(\"abc\", \"\")\n      [\"a\", \"b\", \"c\", \"\"]\n\n      iex> String.split(\"abc\", \"\", trim: true)\n      [\"a\", \"b\", \"c\"]\n\n      iex> String.split(\"abc\", \"\", parts: 2)\n      [\"a\", \"bc\"]\n\n  A precompiled pattern can also be given:\n\n      iex> pattern = :binary.compile_pattern([\" \", \",\"])\n      iex> String.split(\"1,2 3,4\", pattern)\n      [\"1\", \"2\", \"3\", \"4\"]\n\n  \"\"\"\n  @spec split(t, pattern | Regex.t) :: [t]\n  @spec split(t, pattern | Regex.t, Keyword.t) :: [t]\n  \nsplit(string, %Regex{} = pattern, options) when is_binary(string) \n\n  Divides a string into substrings at each Unicode whitespace\n  occurrence with leading and trailing whitespace ignored. Groups\n  of whitespace are treated as a single occurrence. Divisions do\n  not occur on non-breaking whitespace.\n\n  ## Examples\n\n      iex> String.split(\"foo bar\")\n      [\"foo\", \"bar\"]\n\n      iex> String.split(\"foo\" <> <<194, 133>> <> \"bar\")\n      [\"foo\", \"bar\"]\n\n      iex> String.split(\" foo   bar \")\n      [\"foo\", \"bar\"]\n\n      iex> String.split(\"no\\u00a0break\")\n      [\"no\\u00a0break\"]\n\n  "
    },
    split_at = {
      description = "\nsplit_at(string, position) when is_integer(position) and position < 0 \n@spec split_at(t, integer) :: {t, t}\n  \nsplit_at(string, position) when is_integer(position) and position >= 0 \n\n  Splits a string into two at the specified offset. When the offset given is\n  negative, location is counted from the end of the string.\n\n  The offset is capped to the length of the string. Returns a tuple with\n  two elements.\n\n  Note: keep in mind this function splits on graphemes and for such it\n  has to linearly traverse the string. If you want to split a string or\n  a binary based on the number of bytes, use `Kernel.binary_part/3`\n  instead.\n\n  ## Examples\n\n      iex> String.split_at \"sweetelixir\", 5\n      {\"sweet\", \"elixir\"}\n\n      iex> String.split_at \"sweetelixir\", -6\n      {\"sweet\", \"elixir\"}\n\n      iex> String.split_at \"abc\", 0\n      {\"\", \"abc\"}\n\n      iex> String.split_at \"abc\", 1000\n      {\"abc\", \"\"}\n\n      iex> String.split_at \"abc\", -1000\n      {\"\", \"abc\"}\n\n  "
    },
    ["starts_with?"] = {
      description = "\nstarts_with?(string, prefix) when is_binary(string) \n@spec starts_with?(t, t | [t]) :: boolean\n  \nstarts_with?(string, prefix) when is_binary(string) and is_list(prefix) \n\n  Returns `true` if `string` starts with any of the prefixes given.\n\n  `prefix` can be either a single prefix or a list of prefixes.\n\n  ## Examples\n\n      iex> String.starts_with? \"elixir\", \"eli\"\n      true\n      iex> String.starts_with? \"elixir\", [\"erlang\", \"elixir\"]\n      true\n      iex> String.starts_with? \"elixir\", [\"erlang\", \"ruby\"]\n      false\n\n  An empty string will always match:\n\n      iex> String.starts_with? \"elixir\", \"\"\n      true\n      iex> String.starts_with? \"elixir\", [\"\", \"other\"]\n      true\n\n  "
    },
    strip = {
      description = "\nstrip(string, char)false\n\nstrip(string)\nfalse"
    },
    t = {
      description = "t :: binary\n"
    },
    ["valid?"] = {
      description = "\nvalid?(_)\n\nvalid?(<<>>)\n@spec codepoints(t) :: [codepoint]\n  defdelegate codepoints(string), to: String.Unicode\n\n  @doc \"\"\"\n  Returns the next codepoint in a string.\n\n  The result is a tuple with the codepoint and the\n  remainder of the string or `nil` in case\n  the string reached its end.\n\n  As with other functions in the String module, this\n  function does not check for the validity of the codepoint.\n  That said, if an invalid codepoint is found, it will\n  be returned by this function.\n\n  ## Examples\n\n      iex> String.next_codepoint(\"olá\")\n      {\"o\", \"lá\"}\n\n  \"\"\"\n  @compile {:inline, next_codepoint: 1}\n  @spec next_codepoint(t) :: {codepoint, t} | nil\n  defdelegate next_codepoint(string), to: String.Unicode\n\n  @doc ~S\"\"\"\n  Checks whether `string` contains only valid characters.\n\n  ## Examples\n\n      iex> String.valid?(\"a\")\n      true\n\n      iex> String.valid?(\"ø\")\n      true\n\n      iex> String.valid?(<<0xFFFF :: 16>>)\n      false\n\n      iex> String.valid?(\"asd\" <> <<0xFFFF :: 16>>)\n      false\n\n  \"\"\"\n  @spec valid?(t) :: boolean\n  \nvalid?(<<_::utf8, t::binary>>)\n\n  Returns all codepoints in the string.\n\n  For details about codepoints and graphemes, see the `String` module documentation.\n\n  ## Examples\n\n      iex> String.codepoints(\"olá\")\n      [\"o\", \"l\", \"á\"]\n\n      iex> String.codepoints(\"оптими зации\")\n      [\"о\", \"п\", \"т\", \"и\", \"м\", \"и\", \" \", \"з\", \"а\", \"ц\", \"и\", \"и\"]\n\n      iex> String.codepoints(\"ἅἪῼ\")\n      [\"ἅ\", \"Ἢ\", \"ῼ\"]\n\n      iex> String.codepoints(\"\\u00e9\")\n      [\"é\"]\n\n      iex> String.codepoints(\"\\u0065\\u0301\")\n      [\"e\", \"́\"]\n\n  "
    },
    ["valid_character?"] = {
      description = "\nvalid_character?(string)\nfalse"
    }
  },
  StringIO = {
    description = "\n  Controls an IO device process that wraps a string.\n\n  A `StringIO` IO device can be passed as a \"device\" to\n  most of the functions in the `IO` module.\n\n  ## Examples\n\n      iex> {:ok, pid} = StringIO.open(\"foo\")\n      iex> IO.read(pid, 2)\n      \"fo\"\n\n  ",
    handle_call = {
      description = "\nhandle_call(request, from, s)\n\nhandle_call(:close, _from, %{input: input, output: output} = s)\n\nhandle_call(:flush, _from, %{output: output} = s)\n\nhandle_call(:contents, _from, %{input: input, output: output} = s)\n"
    },
    handle_info = {
      description = "\nhandle_info(msg, s)\n\nhandle_info({:io_request, from, reply_as, req}, s)\n"
    },
    init = {
      description = "@spec close(pid) :: {:ok, {binary, binary}}\n  \ninit({string, options})\n\n  Stops the IO device and returns the remaining input/output\n  buffers.\n\n  ## Examples\n\n      iex> {:ok, pid} = StringIO.open(\"in\")\n      iex> IO.write(pid, \"out\")\n      iex> StringIO.close(pid)\n      {:ok, {\"in\", \"out\"}}\n\n  "
    }
  },
  Supervisor = {
    Default = {
      description = "false",
      init = {
        description = "\ninit(args)\n\n  Supervisor callback that simply returns the given args.\n\n  This is the supervisor used by `Supervisor.start_link/2`\n  and others.\n  "
      }
    },
    Spec = {
      child_id = {
        description = "child_id :: term\n"
      },
      description = "\n  Convenience functions for defining supervisor specifications.\n\n  ## Example\n\n  By using the functions in this module one can specify the children\n  to be used under a supervisor, started with `Supervisor.start_link/2`:\n\n      import Supervisor.Spec\n\n      children = [\n        worker(MyWorker, [arg1, arg2, arg3]),\n        supervisor(MySupervisor, [arg1])\n      ]\n\n      Supervisor.start_link(children, strategy: :one_for_one)\n\n  Sometimes, it may be handy to define supervisors backed\n  by a module:\n\n      defmodule MySupervisor do\n        use Supervisor\n\n        def start_link(arg) do\n          Supervisor.start_link(__MODULE__, arg)\n        end\n\n        def init(arg) do\n          children = [\n            worker(MyWorker, [arg], restart: :temporary)\n          ]\n\n          supervise(children, strategy: :simple_one_for_one)\n        end\n      end\n\n  Notice in this case we don't have to explicitly import\n  `Supervisor.Spec` as `use Supervisor` automatically does so.\n  Defining a module-based supervisor can be useful, for example,\n  to perform initialization tasks in the `c:init/1` callback.\n\n  ## Supervisor and worker options\n\n  In the example above, we defined specs for workers and supervisors.\n  These specs (both for workers as well as supervisors) accept the\n  following options:\n\n    * `:id` - a name used to identify the child specification\n      internally by the supervisor; defaults to the given module\n      name for the child worker/supervisor\n\n    * `:function` - the function to invoke on the child to start it\n\n    * `:restart` - an atom that defines when a terminated child process should\n      be restarted (see the \"Restart values\" section below)\n\n    * `:shutdown` - an atom that defines how a child process should be\n      terminated (see the \"Shutdown values\" section below)\n\n    * `:modules` - it should be a list with one element `[module]`,\n      where module is the name of the callback module only if the\n      child process is a `Supervisor` or `GenServer`; if the child\n      process is a `GenEvent`, `:modules` should be `:dynamic`\n\n  ### Restart values (:restart)\n\n  The following restart values are supported in the `:restart` option:\n\n    * `:permanent` - the child process is always restarted\n\n    * `:temporary` - the child process is never restarted (not even\n      when the supervisor's strategy is `:rest_for_one` or `:one_for_all`)\n\n    * `:transient` - the child process is restarted only if it\n      terminates abnormally, i.e., with an exit reason other than\n      `:normal`, `:shutdown` or `{:shutdown, term}`\n\n  Notice that supervisor that reached maximum restart intensity will exit with `:shutdown` reason.\n  In this case the supervisor will only be restarted if its child specification was defined with\n  the `:restart` option is set to `:permanent` (the default).\n\n  ### Shutdown values (:shutdown)\n\n  The following shutdown values are supported in the `:shutdown` option:\n\n    * `:brutal_kill` - the child process is unconditionally terminated\n      using `Process.exit(child, :kill)`\n\n    * `:infinity` - if the child process is a supervisor, this is a mechanism\n      to give the subtree enough time to shutdown; it can also be used with\n      workers with care\n\n    * any integer - the value of `:shutdown` can also be any integer meaning\n      that the supervisor tells the child process to terminate by calling\n      `Process.exit(child, :shutdown)` and then waits for an exit signal back.\n      If no exit signal is received within the specified time (the value of this\n      option, in milliseconds), the child process is unconditionally terminated\n      using `Process.exit(child, :kill)`\n\n  ",
      modules = {
        description = "modules :: :dynamic | [module]\n"
      },
      restart = {
        description = "restart :: :permanent | :transient | :temporary\n"
      },
      shutdown = {
        description = "shutdown :: :brutal_kill | :infinity | non_neg_integer\n"
      },
      spec = {
        description = "spec :: {child_id,\n"
      },
      strategy = {
        description = "strategy :: :simple_one_for_one | :one_for_one | :one_for_all | :rest_for_one\n"
      },
      worker = {
        description = "worker :: :worker | :supervisor\n"
      }
    },
    __using__ = {
      description = "\n__using__(_)\nfalse"
    },
    child = {
      description = "child :: pid | :undefined\n"
    },
    description = "\n  A behaviour module for implementing supervision functionality.\n\n  A supervisor is a process which supervises other processes, which we refer\n  to as *child processes*. Supervisors are used to build a hierarchical process\n  structure called a *supervision tree*. Supervision trees are a nice way to\n  structure fault-tolerant applications.\n\n  A supervisor implemented using this module has a standard set\n  of interface functions and includes functionality for tracing and error\n  reporting. It also fits into a supervision tree.\n\n  ## Examples\n\n  In order to define a supervisor, we need to first define a child process\n  that is going to be supervised. In order to do so, we will define a GenServer\n  that represents a stack:\n\n      defmodule Stack do\n        use GenServer\n\n        def start_link(state, opts \\\\ []) do\n          GenServer.start_link(__MODULE__, state, opts)\n        end\n\n        def handle_call(:pop, _from, [h | t]) do\n          {:reply, h, t}\n        end\n\n        def handle_cast({:push, h}, t) do\n          {:noreply, [h | t]}\n        end\n      end\n\n  We can now define our supervisor and start it as follows:\n\n      # Import helpers for defining supervisors\n      import Supervisor.Spec\n\n      # Supervise the Stack server which will be started with\n      # two arguments. The initial stack, [:hello], and a\n      # keyword list containing the GenServer options that\n      # set the registered name of the server to MyStack.\n      children = [\n        worker(Stack, [[:hello], [name: MyStack]])\n      ]\n\n      # Start the supervisor with our child\n      {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)\n\n      # There is one child worker started\n      Supervisor.count_children(pid)\n      #=> %{active: 1, specs: 1, supervisors: 0, workers: 1}\n\n  Notice that when starting the GenServer, we are registering it\n  with name `MyStack`, which allows us to call it directly and\n  get what is on the stack:\n\n      GenServer.call(MyStack, :pop)\n      #=> :hello\n\n      GenServer.cast(MyStack, {:push, :world})\n      #=> :ok\n\n      GenServer.call(MyStack, :pop)\n      #=> :world\n\n  However, there is a bug in our stack server. If we call `:pop` and\n  the stack is empty, it is going to crash because no clause matches:\n\n      GenServer.call(MyStack, :pop)\n      ** (exit) exited in: GenServer.call(MyStack, :pop, 5000)\n\n  Luckily, since the server is being supervised by a supervisor, the\n  supervisor will automatically start a new one, with the initial stack\n  of `[:hello]`:\n\n      GenServer.call(MyStack, :pop)\n      #=> :hello\n\n  Supervisors support different strategies; in the example above, we\n  have chosen `:one_for_one`. Furthermore, each supervisor can have many\n  workers and supervisors as children, each of them with their specific\n  configuration, shutdown values, and restart strategies.\n\n  The rest of this documentation will cover supervision strategies; also read\n  the documentation for the `Supervisor.Spec` module to learn about the\n  specification for workers and supervisors.\n\n  ## Module-based supervisors\n\n  In the example above, a supervisor was started by passing the supervision\n  structure to `start_link/2`. However, supervisors can also be created by\n  explicitly defining a supervision module:\n\n      defmodule MyApp.Supervisor do\n        # Automatically imports Supervisor.Spec\n        use Supervisor\n\n        def start_link do\n          Supervisor.start_link(__MODULE__, [])\n        end\n\n        def init([]) do\n          children = [\n            worker(Stack, [[:hello]])\n          ]\n\n          # supervise/2 is imported from Supervisor.Spec\n          supervise(children, strategy: :one_for_one)\n        end\n      end\n\n  You may want to use a module-based supervisor if:\n\n    * You need to perform some particular action on supervisor\n      initialization, like setting up an ETS table.\n\n    * You want to perform partial hot-code swapping of the\n      tree. For example, if you add or remove children,\n      the module-based supervision will add and remove the\n      new children directly, while dynamic supervision\n      requires the whole tree to be restarted in order to\n      perform such swaps.\n\n  ## Strategies\n\n  Supervisors support different supervision strategies (through the `:strategy`\n  option, as seen above):\n\n    * `:one_for_one` - if a child process terminates, only that\n      process is restarted.\n\n    * `:one_for_all` - if a child process terminates, all other child\n      processes are terminated and then all child processes (including\n      the terminated one) are restarted.\n\n    * `:rest_for_one` - if a child process terminates, the \"rest\" of\n      the child processes, i.e., the child processes after the terminated\n      one in start order, are terminated. Then the terminated child\n      process and the rest of the child processes are restarted.\n\n    * `:simple_one_for_one` - similar to `:one_for_one` but suits better\n      when dynamically attaching children. This strategy requires the\n      supervisor specification to contain only one child. Many functions\n      in this module behave slightly differently when this strategy is\n      used.\n\n  ## Simple one for one\n\n  The `:simple_one_for_one` supervisor is useful when you want to dynamically\n  start and stop supervised children. For example, imagine you want to\n  dynamically create multiple stacks. We can do so by defining a `:simple_one_for_one`\n  supervisor:\n\n      # Import helpers for defining supervisors\n      import Supervisor.Spec\n\n      # This time, we don't pass any argument because\n      # the argument will be given when we start the child\n      children = [\n        worker(Stack, [], restart: :transient)\n      ]\n\n      # Start the supervisor with our one child as a template\n      {:ok, sup_pid} = Supervisor.start_link(children, strategy: :simple_one_for_one)\n\n      # No child worker is active yet until start_child is called\n      Supervisor.count_children(sup_pid)\n      #=> %{active: 0, specs: 1, supervisors: 0, workers: 0}\n\n  There are a couple differences here:\n\n    * the simple one for one specification can define only one child which\n      works as a template for when we call `start_child/2`\n\n    * we have defined the child to have a restart strategy of `:transient`. This\n      means that, if the child process exits due to a `:normal`, `:shutdown`,\n      or `{:shutdown, term}` reason, it won't be restarted. This is useful\n      as it allows our workers to politely shutdown and be removed from the\n      `:simple_one_for_one` supervisor, without being restarted. You can find\n      more information about restart strategies in the documentation for the\n      `Supervisor.Spec` module\n\n  With the supervisor defined, let's dynamically start stacks:\n\n      {:ok, pid} = Supervisor.start_child(sup_pid, [[:hello, :world], []])\n      GenServer.call(pid, :pop) #=> :hello\n      GenServer.call(pid, :pop) #=> :world\n\n      {:ok, pid} = Supervisor.start_child(sup_pid, [[:something, :else], []])\n      GenServer.call(pid, :pop) #=> :something\n      GenServer.call(pid, :pop) #=> :else\n\n      Supervisor.count_children(sup_pid)\n      #=> %{active: 2, specs: 1, supervisors: 0, workers: 2}\n\n  ## Exit reasons\n\n  From the example above, you may have noticed that the `:transient` restart\n  strategy for the worker does not restart the child in case it exits with\n  reason `:normal`, `:shutdown` or `{:shutdown, term}`.\n\n  So one may ask: which exit reason should I choose when exiting my worker?\n  There are three options:\n\n    * `:normal` - in such cases, the exit won't be logged, there is no restart\n      in transient mode, and linked processes do not exit\n\n    * `:shutdown` or `{:shutdown, term}` - in such cases, the exit won't be\n      logged, there is no restart in transient mode, and linked processes exit\n      with the same reason unless they're trapping exits\n\n    * any other term - in such cases, the exit will be logged, there are\n      restarts in transient mode, and linked processes exit with the same reason\n      unless they're trapping exits\n\n  ## Name registration\n\n  A supervisor is bound to the same name registration rules as a `GenServer`.\n  Read more about these rules in the documentation for `GenServer`.\n\n  ",
    init = {
      description = "\ninit(arg)\nfalse"
    },
    name = {
      description = "name :: atom | {:global, term} | {:via, module, term}\n"
    },
    on_start = {
      description = "on_start :: {:ok, pid} | :ignore |\n"
    },
    on_start_child = {
      description = "on_start_child :: {:ok, child} | {:ok, child, info :: term} |\n"
    },
    options = {
      description = "options :: [name: name,\n"
    },
    supervisor = {
      description = "supervisor :: pid | name | {atom, node}\n"
    }
  },
  SyntaxError = {
    message = {
      description = "\nmessage(exception)\n"
    }
  },
  System = {
    at_exit = {
      description = "\nat_exit(fun) when is_function(fun, 1) \n\n  Registers a program exit handler function.\n\n  Registers a function that will be invoked at the end of program execution.\n  Useful for invoking a hook in \"script\" mode.\n\n  The handler always executes in a different process from the one it was\n  registered in. As a consequence, any resources managed by the calling process\n  (ETS tables, open files, etc.) won't be available by the time the handler\n  function is invoked.\n\n  The function must receive the exit status code as an argument.\n  "
    },
    compiled_endianness = {
      description = "\ncompiled_endianness\n\n  Returns the endianness the system was compiled with.\n  "
    },
    cwd = {
      description = "@spec argv([String.t]) :: :ok\n  \ncwd\n\n  Current working directory.\n\n  Returns the current working directory or `nil` if one\n  is not available.\n  "
    },
    ["cwd!"] = {
      description = "\ncwd!\n\n  Current working directory, exception on error.\n\n  Returns the current working directory or raises `RuntimeError`.\n  "
    },
    description = "\n  The `System` module provides functions that interact directly\n  with the VM or the host system.\n\n  ## Time\n\n  The `System` module also provides functions that work with time,\n  returning different times kept by the system with support for\n  different time units.\n\n  One of the complexities in relying on system times is that they\n  may be adjusted. For example, when you enter and leave daylight\n  saving time, the system clock will be adjusted, often adding\n  or removing one hour. We call such changes \"time warps\". In\n  order to understand how such changes may be harmful, imagine\n  the following code:\n\n      ## DO NOT DO THIS\n      prev = System.os_time()\n      # ... execute some code ...\n      next = System.os_time()\n      diff = next - prev\n\n  If, while the code is executing, the system clock changes,\n  some code that executed in 1 second may be reported as taking\n  over 1 hour! To address such concerns, the VM provides a\n  monotonic time via `System.monotonic_time/0` which never\n  decreases and does not leap:\n\n      ## DO THIS\n      prev = System.monotonic_time()\n      # ... execute some code ...\n      next = System.monotonic_time()\n      diff = next - prev\n\n  Generally speaking, the VM provides three time measurements:\n\n    * `os_time/0` - the time reported by the OS. This time may be\n      adjusted forwards or backwards in time with no limitation;\n\n    * `system_time/0` - the VM view of the `os_time/0`. The system time and OS\n      time may not match in case of time warps although the VM works towards\n      aligning them. This time is not monotonic (i.e., it may decrease)\n      as its behaviour is configured [by the VM time warp\n      mode](http://www.erlang.org/doc/apps/erts/time_correction.html#Time_Warp_Modes);\n\n    * `monotonic_time/0` - a monotonically increasing time provided\n      by the Erlang VM.\n\n  The time functions in this module work in the `:native` unit\n  (unless specified otherwise), which is OS dependent. Most of\n  the time, all calculations are done in the `:native` unit, to\n  avoid loss of precision, with `convert_time_unit/3` being\n  invoked at the end to convert to a specific time unit like\n  `:millisecond` or `:microsecond`. See the `t:time_unit/0` type for\n  more information.\n\n  For a more complete rundown on the VM support for different\n  times, see the [chapter on time and time\n  correction](http://www.erlang.org/doc/apps/erts/time_correction.html)\n  in the Erlang docs.\n  ",
    endianness = {
      description = "\nendianness\n\n  Returns the endianness.\n  "
    },
    halt = {
      description = "\nhalt(status) when is_binary(status) \n@spec halt() :: no_return\n  @spec halt(non_neg_integer | binary | :abort) :: no_return\n  \nhalt(status) when is_integer(status) or status == :abort \n\n  Immediately halts the Erlang runtime system.\n\n  Terminates the Erlang runtime system without properly shutting down\n  applications and ports. Please see `stop/1` for a careful shutdown of the\n  system.\n\n  `status` must be a non-negative integer, the atom `:abort` or a binary.\n\n    * If an integer, the runtime system exits with the integer value which\n      is returned to the operating system.\n\n    * If `:abort`, the runtime system aborts producing a core dump, if that is\n      enabled in the operating system.\n\n    * If a string, an Erlang crash dump is produced with status as slogan,\n      and then the runtime system exits with status code 1.\n\n  Note that on many platforms, only the status codes 0-255 are supported\n  by the operating system.\n\n  For more information, see [`:erlang.halt/1`](http://www.erlang.org/doc/man/erlang.html#halt-1).\n\n  ## Examples\n\n      System.halt(0)\n      System.halt(1)\n      System.halt(:abort)\n\n  "
    },
    stacktrace = {
      description = "@spec delete_env(String.t) :: :ok\n  \nstacktrace\n\n  Last exception stacktrace.\n\n  Note that the Erlang VM (and therefore this function) does not\n  return the current stacktrace but rather the stacktrace of the\n  latest exception.\n\n  Inlined by the compiler into `:erlang.get_stacktrace/0`.\n  "
    },
    stop = {
      description = "\nstop(status) when is_binary(status) \n@spec stop() :: no_return\n  @spec stop(non_neg_integer | binary) :: no_return\n  \nstop(status) when is_integer(status) \n\n  Carefully stops the Erlang runtime system.\n\n  All applications are taken down smoothly, all code is unloaded, and all ports\n  are closed before the system terminates by calling `halt/1`.\n\n  `status` must be a non-negative integer value which is returned by the\n  runtime system to the operating system.\n\n  Note that on many platforms, only the status codes 0-255 are supported\n  by the operating system.\n\n  For more information, see [`:init.stop/1`](http://erlang.org/doc/man/init.html#stop-1).\n\n  ## Examples\n\n      System.stop(0)\n      System.stop(1)\n\n  "
    },
    time_unit = {
      description = "time_unit :: :second\n\n  The time unit to be passed to functions like `monotonic_time/1` and others.\n\n  The `:second`, `:millisecond`, `:microsecond` and `:nanosecond` time\n  units controls the return value of the functions that accept a time unit.\n\n  A time unit can also be a strictly positive integer. In this case, it\n  represents the \"parts per second\": the time will be returned in `1 /\n  parts_per_second` seconds. For example, using the `:millisecond` time unit\n  is equivalent to using `1000` as the time unit (as the time will be returned\n  in 1/1000 seconds - milliseconds).\n\n  Keep in mind the Erlang API prior to version 19.1 will use `:milli_seconds`,\n  `:micro_seconds` and `:nano_seconds` as time units although Elixir normalizes\n  their spelling to match the SI convention.\n  "
    },
    tmp_dir = {
      description = "\ntmp_dir\n\n  Writable temporary directory.\n\n  Returns a writable temporary directory.\n  Searches for directories in the following order:\n\n    1. the directory named by the TMPDIR environment variable\n    2. the directory named by the TEMP environment variable\n    3. the directory named by the TMP environment variable\n    4. `C:\\TMP` on Windows or `/tmp` on Unix\n    5. as a last resort, the current working directory\n\n  Returns `nil` if none of the above are writable.\n  "
    },
    ["tmp_dir!"] = {
      description = "\ntmp_dir!\n\n  Writable temporary directory, exception on error.\n\n  Same as `tmp_dir/0` but raises `RuntimeError`\n  instead of returning `nil` if no temp dir is set.\n  "
    },
    user_home = {
      description = "\nuser_home\n\n  User home directory.\n\n  Returns the user home directory (platform independent).\n  "
    },
    ["user_home!"] = {
      description = "\nuser_home!\n\n  User home directory, exception on error.\n\n  Same as `user_home/0` but raises `RuntimeError`\n  instead of returning `nil` if no user home is set.\n  "
    }
  },
  SystemLimitError = {
    message = {
      description = "\nmessage(_)\n"
    }
  },
  Task = {
    Supervised = {
      description = "false",
      noreply = {
        description = "\nnoreply(info, mfa)\n"
      },
      reply = {
        description = "\nreply(caller, monitor, info, mfa)\n"
      },
      spawn_link = {
        description = "\nspawn_link(caller, monitor \\\\ :nomonitor, info, fun)\n"
      },
      start = {
        description = "\nstart(info, fun)\n"
      },
      start_link = {
        description = "\nstart_link(caller, monitor, info, fun)\n\nstart_link(info, fun)\n"
      },
      stream = {
        description = "\nstream(enumerable, acc, reducer, mfa, options, spawn)\n"
      }
    },
    Supervisor = {
      description = "\n  A task supervisor.\n\n  This module defines a supervisor which can be used to dynamically\n  supervise tasks. Behind the scenes, this module is implemented as a\n  `:simple_one_for_one` supervisor where the workers are temporary by\n  default (that is, they are not restarted after they die; read the docs\n  for `start_link/1` for more information on choosing the restart\n  strategy).\n\n  See the `Task` module for more information.\n\n  ## Name registration\n\n  A `Task.Supervisor` is bound to the same name registration rules as a\n  `GenServer`. Read more about them in the `GenServer` docs.\n  "
    },
    await = {
      description = "\nawait(%Task{ref: ref} = task, timeout)\n@spec await(t, timeout) :: term | no_return\n  \nawait(%Task{owner: owner} = task, _) when owner != self() \n\n  Awaits a task reply and returns it.\n\n  A timeout, in milliseconds, can be given with default value\n  of `5000`. In case the task process dies, this function will\n  exit with the same reason as the task.\n\n  If the timeout is exceeded, `await` will exit; however,\n  the task will continue to run. When the calling process exits, its\n  exit signal will terminate the task if it is not trapping exits.\n\n  This function assumes the task's monitor is still active or the monitor's\n  `:DOWN` message is in the message queue. If it has been demonitored, or the\n  message already received, this function will wait for the duration of the\n  timeout awaiting the message.\n\n  This function can only be called once for any given task. If you want\n  to be able to check multiple times if a long-running task has finished\n  its computation, use `yield/2` instead.\n\n  ## Compatibility with OTP behaviours\n\n  It is not recommended to `await` a long-running task inside an OTP\n  behaviour such as `GenServer`. Instead, you should match on the message\n  coming from a task inside your `GenServer.handle_info/2` callback.\n\n  ## Examples\n\n      iex> task = Task.async(fn -> 1 + 1 end)\n      iex> Task.await(task)\n      2\n\n  "
    },
    description = "\n  Conveniences for spawning and awaiting tasks.\n\n  Tasks are processes meant to execute one particular\n  action throughout their lifetime, often with little or no\n  communication with other processes. The most common use case\n  for tasks is to convert sequential code into concurrent code\n  by computing a value asynchronously:\n\n      task = Task.async(fn -> do_some_work() end)\n      res  = do_some_other_work()\n      res + Task.await(task)\n\n  Tasks spawned with `async` can be awaited on by their caller\n  process (and only their caller) as shown in the example above.\n  They are implemented by spawning a process that sends a message\n  to the caller once the given computation is performed.\n\n  Besides `async/1` and `await/2`, tasks can also be\n  started as part of a supervision tree and dynamically spawned\n  on remote nodes. We will explore all three scenarios next.\n\n  ## async and await\n\n  One of the common uses of tasks is to convert sequential code\n  into concurrent code with `Task.async/1` while keeping its semantics.\n  When invoked, a new process will be created, linked and monitored\n  by the caller. Once the task action finishes, a message will be sent\n  to the caller with the result.\n\n  `Task.await/2` is used to read the message sent by the task.\n\n  There are two important things to consider when using `async`:\n\n    1. If you are using async tasks, you **must await** a reply\n       as they are *always* sent. If you are not expecting a reply,\n       consider using `Task.start_link/1` detailed below.\n\n    2. async tasks link the caller and the spawned process. This\n       means that, if the caller crashes, the task will crash\n       too and vice-versa. This is on purpose: if the process\n       meant to receive the result no longer exists, there is\n       no purpose in completing the computation.\n\n       If this is not desired, use `Task.start/1` or consider starting\n       the task under a `Task.Supervisor` using `async_nolink` or\n       `start_child`.\n\n  `Task.yield/2` is an alternative to `await/2` where the caller will\n  temporarily block, waiting until the task replies or crashes. If the\n  result does not arrive within the timeout, it can be called again at a\n  later moment. This allows checking for the result of a task multiple\n  times. If a reply does not arrive within the desired time,\n  `Task.shutdown/2` can be used to stop the task.\n\n  ## Supervised tasks\n\n  It is also possible to spawn a task under a supervisor:\n\n      import Supervisor.Spec\n\n      children = [\n        #\n        worker(Task, [fn -> IO.puts \"ok\" end])\n      ]\n\n  Internally the supervisor will invoke `Task.start_link/1`.\n\n  Since these tasks are supervised and not directly linked to\n  the caller, they cannot be awaited on. Note `start_link/1`,\n  unlike `async/1`, returns `{:ok, pid}` (which is\n  the result expected by supervision trees).\n\n  By default, most supervision strategies will try to restart\n  a worker after it exits regardless of the reason. If you design\n  the task to terminate normally (as in the example with `IO.puts/2`\n  above), consider passing `restart: :transient` in the options\n  to `Supervisor.Spec.worker/3`.\n\n  ## Dynamically supervised tasks\n\n  The `Task.Supervisor` module allows developers to dynamically\n  create multiple supervised tasks.\n\n  A short example is:\n\n      {:ok, pid} = Task.Supervisor.start_link()\n      task = Task.Supervisor.async(pid, fn ->\n        # Do something\n      end)\n      Task.await(task)\n\n  However, in the majority of cases, you want to add the task supervisor\n  to your supervision tree:\n\n      import Supervisor.Spec\n\n      children = [\n        supervisor(Task.Supervisor, [[name: MyApp.TaskSupervisor]])\n      ]\n\n  Now you can dynamically start supervised tasks:\n\n      Task.Supervisor.start_child(MyApp.TaskSupervisor, fn ->\n        # Do something\n      end)\n\n  Or even use the async/await pattern:\n\n      Task.Supervisor.async(MyApp.TaskSupervisor, fn ->\n        # Do something\n      end) |> Task.await()\n\n  Finally, check `Task.Supervisor` for other supported operations.\n\n  ## Distributed tasks\n\n  Since Elixir provides a Task supervisor, it is easy to use one\n  to dynamically spawn tasks across nodes:\n\n      # On the remote node\n      Task.Supervisor.start_link(name: MyApp.DistSupervisor)\n\n      # On the client\n      Task.Supervisor.async({MyApp.DistSupervisor, :remote@local},\n                            MyMod, :my_fun, [arg1, arg2, arg3])\n\n  Note that, when working with distributed tasks, one should use the `Task.Supervisor.async/4` function\n  that expects explicit module, function and arguments, instead of `Task.Supervisor.async/2` that\n  works with anonymous functions. That's because anonymous functions expect\n  the same module version to exist on all involved nodes. Check the `Agent` module\n  documentation for more information on distributed processes as the limitations\n  described there apply to the whole ecosystem.\n  ",
    find = {
      description = "\nfind(tasks, msg)\nfalse"
    },
    shutdown = {
      description = "\nshutdown(%Task{pid: pid} = task, timeout)\n\nshutdown(%Task{pid: pid} = task, :brutal_kill)\n\nshutdown(%Task{owner: owner} = task, _) when owner != self() \n@spec shutdown(t, timeout | :brutal_kill) :: {:ok, term} | {:exit, term} | nil\n  \nshutdown(%Task{pid: nil} = task, _)\n\n  Unlinks and shuts down the task, and then checks for a reply.\n\n  Returns `{:ok, reply}` if the reply is received while shutting down the task,\n  `{:exit, reason}` if the task died, otherwise `nil`.\n\n  The shutdown method is either a timeout or `:brutal_kill`. In case\n  of a `timeout`, a `:shutdown` exit signal is sent to the task process\n  and if it does not exit within the timeout, it is killed. With `:brutal_kill`\n  the task is killed straight away. In case the task terminates abnormally\n  (possibly killed by another process), this function will exit with the same reason.\n\n  It is not required to call this function when terminating the caller, unless\n  exiting with reason `:normal` or if the task is trapping exits. If the caller is\n  exiting with a reason other than `:normal` and the task is not trapping exits, the\n  caller's exit signal will stop the task. The caller can exit with reason\n  `:shutdown` to shutdown all of its linked processes, including tasks, that\n  are not trapping exits without generating any log messages.\n\n  If a task's monitor has already been demonitored or received  and there is not\n  a response waiting in the message queue this function will return\n  `{:exit, :noproc}` as the result or exit reason can not be determined.\n  "
    },
    t = {
      description = "t :: %__MODULE__{}\n"
    },
    yield = {
      description = "\nyield(%Task{ref: ref} = task, timeout)\n@spec yield(t, timeout) :: {:ok, term} | {:exit, term} | nil\n  \nyield(%Task{owner: owner} = task, _) when owner != self() \n\n  Temporarily blocks the current process waiting for a task reply.\n\n  Returns `{:ok, reply}` if the reply is received, `nil` if\n  no reply has arrived, or `{:exit, reason}` if the task has already\n  exited. Keep in mind that normally a task failure also causes\n  the process owning the task to exit. Therefore this function can\n  return `{:exit, reason}` only if\n\n    * the task process exited with the reason `:normal`\n    * it isn't linked to the caller\n    * the caller is trapping exits\n\n  A timeout, in milliseconds, can be given with default value\n  of `5000`. If the time runs out before a message from\n  the task is received, this function will return `nil`\n  and the monitor will remain active. Therefore `yield/2` can be\n  called multiple times on the same task.\n\n  This function assumes the task's monitor is still active or the\n  monitor's `:DOWN` message is in the message queue. If it has been\n  demonitored or the message already received, this function will wait\n  for the duration of the timeout awaiting the message.\n\n  If you intend to shut the task down if it has not responded within `timeout`\n  milliseconds, you should chain this together with `shutdown/1`, like so:\n\n      case Task.yield(task, timeout) || Task.shutdown(task) do\n        {:ok, result} ->\n          result\n        nil ->\n          Logger.warn \"Failed to get a result in #{timeout}ms\"\n          nil\n      end\n\n  That ensures that if the task completes after the `timeout` but before `shutdown/1`\n  has been called, you will still get the result, since `shutdown/1` is designed to\n  handle this case and return the result.\n  "
    }
  },
  Test = {
    description = "\n    A struct that keeps information about the test.\n\n    It is received by formatters and contains the following fields:\n\n      * `:name`  - the test name\n      * `:case`  - the test case\n      * `:state` - the test error state (see ExUnit.state)\n      * `:time`  - the time to run the test\n      * `:tags`  - the test tags\n      * `:logs`  - the captured logs\n\n    ",
    t = {
      description = "t :: %__MODULE__{\n"
    }
  },
  TestCase = {
    description = "\n    A struct that keeps information about the test case.\n\n    It is received by formatters and contains the following fields:\n\n      * `:name`  - the test case name\n      * `:state` - the test error state (see ExUnit.state)\n      * `:tests` - all tests for this case\n\n    ",
    t = {
      description = "t :: %__MODULE__{\n"
    }
  },
  Time = {
    description = "\n  A Time struct and functions.\n\n  The Time struct contains the fields hour, minute, second and microseconds.\n  New times can be built with the `new/4` function or using the `~T`\n  sigil:\n\n      iex> ~T[23:00:07.001]\n      ~T[23:00:07.001]\n\n  Both `new/4` and sigil return a struct where the time fields can\n  be accessed directly:\n\n      iex> time = ~T[23:00:07.001]\n      iex> time.hour\n      23\n      iex> time.microsecond\n      {1000, 3}\n\n  The functions on this module work with the `Time` struct as well\n  as any struct that contains the same fields as the `Time` struct,\n  such as `NaiveDateTime` and `DateTime`. Such functions expect\n  `t:Calendar.time/0` in their typespecs (instead of `t:t/0`).\n\n  Remember, comparisons in Elixir using `==`, `>`, `<` and friends\n  are structural and based on the Time struct fields. For proper\n  comparison between times, use the `compare/2` function.\n\n  Developers should avoid creating the Time struct directly and\n  instead rely on the functions provided by this module as well as\n  the ones in 3rd party calendar libraries.\n  ",
    from_erl = {
      description = "@spec from_erl(:calendar.time, Calendar.microsecond) :: {:ok, t} | {:error, atom}\n  \nfrom_erl({hour, minute, second}, microsecond)\n\n  Converts an Erlang time tuple to a `Time` struct.\n\n  ## Examples\n\n      iex> Time.from_erl({23, 30, 15}, {5000, 3})\n      {:ok, ~T[23:30:15.005]}\n      iex> Time.from_erl({24, 30, 15})\n      {:error, :invalid_time}\n  "
    },
    from_iso8601 = {
      description = "\nfrom_iso8601(<<_::binary>>)\n\nfrom_iso8601(<<hour::2-bytes, ?:, min::2-bytes, ?:, sec::2-bytes, rest::binary>>)\n@spec from_iso8601(String.t) :: {:ok, t} | {:error, atom}\n  \nfrom_iso8601(<<?T, h, rest::binary>>) when h in ?0..?9 \n\n  Parses the extended \"Local time\" format described by\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  Timezone offset may be included in the string but they will be\n  simply discarded as such information is not included in times.\n\n  As specified in the standard, the separator \"T\" may be omitted if\n  desired as there is no ambiguity within this function.\n\n  Time representations with reduced accuracy are not supported.\n\n  ## Examples\n\n      iex> Time.from_iso8601(\"23:50:07\")\n      {:ok, ~T[23:50:07]}\n      iex> Time.from_iso8601(\"23:50:07Z\")\n      {:ok, ~T[23:50:07]}\n      iex> Time.from_iso8601(\"T23:50:07Z\")\n      {:ok, ~T[23:50:07]}\n\n      iex> Time.from_iso8601(\"23:50:07.0123456\")\n      {:ok, ~T[23:50:07.012345]}\n      iex> Time.from_iso8601(\"23:50:07.123Z\")\n      {:ok, ~T[23:50:07.123]}\n\n      iex> Time.from_iso8601(\"2015:01:23 23-50-07\")\n      {:error, :invalid_format}\n      iex> Time.from_iso8601(\"23:50:07A\")\n      {:error, :invalid_format}\n      iex> Time.from_iso8601(\"23:50:07.\")\n      {:error, :invalid_format}\n      iex> Time.from_iso8601(\"23:50:61\")\n      {:error, :invalid_time}\n\n  "
    },
    inspect = {
      description = "\ninspect(%{hour: hour, minute: minute, second: second, microsecond: microsecond}, _)\n"
    },
    new = {
      description = "\nnew(hour, minute, second, {microsecond, precision})\n      when is_integer(hour) and is_integer(minute) and is_integer(second) and\n           is_integer(microsecond) and is_integer(precision) \n@spec new(Calendar.hour, Calendar.minute, Calendar.second, Calendar.microsecond) ::\n        {:ok, Time.t} | {:error, atom}\n  \nnew(hour, minute, second, microsecond) when is_integer(microsecond) \n\n  Builds a new time.\n\n  Expects all values to be integers. Returns `{:ok, time}` if each\n  entry fits its appropriate range, returns `{:error, reason}` otherwise.\n\n  Note a time may have 60 seconds in case of leap seconds.\n\n  ## Examples\n\n      iex> Time.new(0, 0, 0, 0)\n      {:ok, ~T[00:00:00.000000]}\n      iex> Time.new(23, 59, 59, 999_999)\n      {:ok, ~T[23:59:59.999999]}\n      iex> Time.new(23, 59, 60, 999_999)\n      {:ok, ~T[23:59:60.999999]}\n\n      # Time with microseconds and their precision\n      iex> Time.new(23, 59, 60, {10_000, 2})\n      {:ok, ~T[23:59:60.01]}\n\n      iex> Time.new(24, 59, 59, 999_999)\n      {:error, :invalid_time}\n      iex> Time.new(23, 60, 59, 999_999)\n      {:error, :invalid_time}\n      iex> Time.new(23, 59, 61, 999_999)\n      {:error, :invalid_time}\n      iex> Time.new(23, 59, 59, 1_000_000)\n      {:error, :invalid_time}\n\n  "
    },
    t = {
      description = "t :: %Time{hour: Calendar.hour, minute: Calendar.minute,\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    to_erl = {
      description = "@spec to_erl(Calendar.time) :: :calendar.time\n  \nto_erl(%{hour: hour, minute: minute, second: second})\n\n  Converts a `Time` struct to an Erlang time tuple.\n\n  WARNING: Loss of precision may occur, as Erlang time tuples\n  only contain hours/minutes/seconds.\n\n  ## Examples\n\n      iex> Time.to_erl(~T[23:30:15.999])\n      {23, 30, 15}\n\n      iex> Time.to_erl(~N[2015-01-01 23:30:15.999])\n      {23, 30, 15}\n\n  "
    },
    to_iso8601 = {
      description = "@spec to_iso8601(Calendar.time) :: String.t\n  \nto_iso8601(%{hour: hour, minute: minute, second: second, microsecond: microsecond})\n\n  Converts the given time to\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  ### Examples\n\n      iex> Time.to_iso8601(~T[23:00:13])\n      \"23:00:13\"\n      iex> Time.to_iso8601(~T[23:00:13.001])\n      \"23:00:13.001\"\n\n      iex> Time.to_iso8601(~N[2015-01-01 23:00:13])\n      \"23:00:13\"\n      iex> Time.to_iso8601(~N[2015-01-01 23:00:13.001])\n      \"23:00:13.001\"\n\n  "
    },
    to_string = {
      description = "@spec compare(Calendar.time, Calendar.time) :: :lt | :eq | :gt\n  \nto_string(%{hour: hour, minute: minute, second: second, microsecond: microsecond})\n  Compares two `Time` structs.\n\n  Returns `:gt` if first time is later than the second\n  and `:lt` for vice versa. If the two times are equal\n  `:eq` is returned\n\n  ## Examples\n\n      iex> Time.compare(~T[16:04:16], ~T[16:04:28])\n      :lt\n      iex> Time.compare(~T[16:04:16.01], ~T[16:04:16.001])\n      :gt\n\n  This function can also be used to compare across more\n  complex calendar types by considering only the time fields:\n\n      iex> Time.compare(~N[2015-01-01 16:04:16], ~N[2015-01-01 16:04:28])\n      :lt\n      iex> Time.compare(~N[2015-01-01 16:04:16.01], ~N[2000-01-01 16:04:16.001])\n      :gt\n\n  \n@spec to_string(Calendar.time) :: String.t\n  \nto_string(%{hour: hour, minute: minute, second: second, microsecond: microsecond})\n\n  Converts the given time to a string.\n\n  ### Examples\n\n      iex> Time.to_string(~T[23:00:00])\n      \"23:00:00\"\n      iex> Time.to_string(~T[23:00:00.001])\n      \"23:00:00.001\"\n      iex> Time.to_string(~T[23:00:00.123456])\n      \"23:00:00.123456\"\n\n      iex> Time.to_string(~N[2015-01-01 23:00:00.001])\n      \"23:00:00.001\"\n      iex> Time.to_string(~N[2015-01-01 23:00:00.123456])\n      \"23:00:00.123456\"\n\n  "
    }
  },
  TimeoutError = {
    configuration = {
      description = "\nconfiguration\n\n  Returns ExUnit configuration.\n  "
    },
    configure = {
      description = "\nconfigure(options)\n\n  Configures ExUnit.\n\n  ## Options\n\n  ExUnit supports the following options:\n\n    * `:assert_receive_timeout` - the timeout to be used on `assert_receive`\n      calls. Defaults to 100ms.\n\n    * `:capture_log` - if ExUnit should default to keeping track of log messages\n      and print them on test failure. Can be overridden for individual tests via\n      `@tag capture_log: false`. Defaults to `false`.\n\n    * `:case_load_timeout` - the timeout to be used when loading a test case.\n      Defaults to `60_000` milliseconds.\n\n    * `:colors` - a keyword list of colors to be used by some formatters.\n      The only option so far is `[enabled: boolean]` which defaults to `IO.ANSI.enabled?/0`\n\n    * `:formatters` - the formatters that will print results;\n      defaults to `[ExUnit.CLIFormatter]`\n\n    * `:max_cases` - maximum number of cases to run in parallel;\n      defaults to `:erlang.system_info(:schedulers_online) * 2` to\n      optimize both CPU-bound and IO-bound tests\n\n    * `:trace` - sets ExUnit into trace mode, this sets `:max_cases` to `1` and\n      prints each test case and test while running\n\n    * `:autorun` - if ExUnit should run by default on exit; defaults to `true`\n\n    * `:include` - specifies which tests are run by skipping tests that do not\n      match the filter. Keep in mind that all tests are included by default, so unless they are\n      excluded first, the `:include` option has no effect.\n\n    * `:exclude` - specifies which tests are run by skipping tests that match the\n      filter\n\n    * `:refute_receive_timeout` - the timeout to be used on `refute_receive`\n      calls (defaults to 100ms)\n\n    * `:seed` - an integer seed value to randomize the test suite\n\n    * `:stacktrace_depth` - configures the stacktrace depth to be used\n      on formatting and reporters (defaults to 20)\n\n    * `:timeout` - sets the timeout for the tests (default 60_000ms)\n\n  "
    },
    message = {
      description = "\nmessage(%{timeout: timeout, type: type})\n"
    },
    run = {
      description = "@spec plural_rule(binary, binary) :: :ok\n  \nrun\n\n  API used to run the tests. It is invoked automatically\n  if ExUnit is started via `ExUnit.start/1`.\n\n  Returns a map containing the total number of tests, the number\n  of failures and the number of skipped tests.\n  "
    },
    start = {
      description = "\nstart(options \\\\ [])\n  Starts ExUnit and automatically runs tests right before the\n  VM terminates. It accepts a set of options to configure `ExUnit`\n  (the same ones accepted by `configure/1`).\n\n  If you want to run tests manually, you can set `:autorun` to `false`.\n  \n\nstart(_type, [])\nfalse"
    }
  },
  TokenMissingError = {
    message = {
      description = "\nmessage(%{file: file, line: line, description: description})\n"
    }
  },
  TryClauseError = {
    message = {
      description = "\nmessage(exception)\n"
    }
  },
  Tuple = {
    description = "\n  Functions for working with tuples.\n\n  Tuples are ordered collections of elements; tuples can contain elements of any\n  type, and a tuple can contain elements of different types. Curly braces can be\n  used to create tuples:\n\n      iex> {}\n      {}\n      iex> {1, :two, \"three\"}\n      {1, :two, \"three\"}\n\n  Tuples store elements contiguously in memory; this means that accessing a\n  tuple element by index (which can be done through the `Kernel.elem/2`\n  function) is a constant-time operation:\n\n      iex> tuple = {1, :two, \"three\"}\n      iex> elem(tuple, 0)\n      1\n      iex> elem(tuple, 2)\n      \"three\"\n\n  Same goes for getting the tuple size (via `Kernel.tuple_size/1`):\n\n      iex> tuple_size({})\n      0\n      iex> tuple_size({1, 2, 3})\n      3\n\n  Tuples being stored contiguously in memory also means that updating a tuple\n  (for example replacing an element with `Kernel.put_elem/3`) will make a copy\n  of the whole tuple.\n\n  Tuples are not meant to be used as a \"collection\" type (which is also\n  suggested by the absence of an implementation of the `Enumerable` protocol for\n  tuples): they're mostly meant to be used as a fixed-size container for\n  multiple elements. For example, tuples are often used to have functions return\n  \"enriched\" values: a common pattern is for functions to return `{:ok, value}`\n  for successful cases and `{:error, reason}` for unsuccessful cases. For\n  example, this is exactly what `File.read/1` does: it returns `{:ok, contents}`\n  if reading the given file is successful, or `{:error, reason}` otherwise\n  (e.g., `{:error, :enoent}` if the file doesn't exist).\n\n  This module provides functions to work with tuples; some more functions to\n  work with tuples can be found in `Kernel` (`Kernel.tuple_size/1`,\n  `Kernel.elem/2`, `Kernel.put_elem/3`, and others).\n  "
  },
  Typespec = nil,
  URI = {
    HTTP = {
      parse = {
        description = "\nparse(info)\n"
      }
    },
    Parser = {},
    decode_query = {
      description = "\ndecode_query(query, dict) when is_binary(query) \n\ndecode_query(query, map) when is_binary(query) and is_map(map) \n@spec decode_query(binary, map) :: map\n  \ndecode_query(query, %{__struct__: _} = dict) when is_binary(query) \n\n  Decodes a query string into a map.\n\n  Given a query string of the form of `key1=value1&key2=value2...`, this\n  function inserts each key-value pair in the query string as one entry in the\n  given `map`. Keys and values in the resulting map will be binaries. Keys and\n  values will be percent-unescaped.\n\n  Use `query_decoder/1` if you want to iterate over each value manually.\n\n  ## Examples\n\n      iex> URI.decode_query(\"foo=1&bar=2\")\n      %{\"bar\" => \"2\", \"foo\" => \"1\"}\n\n      iex> URI.decode_query(\"percent=oh+yes%21\", %{\"starting\" => \"map\"})\n      %{\"percent\" => \"oh yes!\", \"starting\" => \"map\"}\n\n  "
    },
    description = "\n  Utilities for working with URIs.\n\n  This module provides functions for working with URIs (for example, parsing\n  URIs or encoding query strings). For reference, most of the functions in this\n  module refer to [RFC 3986](https://tools.ietf.org/html/rfc3986).\n  ",
    merge = {
      description = "\nmerge(base, rel)\n\nmerge(%URI{} = base, %URI{} = rel)\n\nmerge(%URI{} = base, %URI{path: rel_path} = rel) when rel_path in [\"\", nil] \n\nmerge(_base, %URI{scheme: rel_scheme} = rel) when rel_scheme != nil \n@spec to_string(t) :: binary\n  defdelegate to_string(uri), to: String.Chars.URI\n\n  @doc ~S\"\"\"\n  Merges two URIs.\n\n  This function merges two URIs as per\n  [RFC 3986, section 5.2](https://tools.ietf.org/html/rfc3986#section-5.2).\n\n  ## Examples\n\n      iex> URI.merge(URI.parse(\"http://google.com\"), \"/query\") |> to_string\n      \"http://google.com/query\"\n\n      iex> URI.merge(\"http://example.com\", \"http://google.com\") |> to_string\n      \"http://google.com\"\n\n  \"\"\"\n  @spec merge(t | binary, t | binary) :: t\n  \nmerge(%URI{authority: nil}, _rel)\n\n  Returns the string representation of the given `URI` struct.\n\n      iex> URI.to_string(URI.parse(\"http://google.com\"))\n      \"http://google.com\"\n\n      iex> URI.to_string(%URI{scheme: \"foo\", host: \"bar.baz\"})\n      \"foo://bar.baz\"\n\n  "
    },
    parse = {
      description = "\nparse(string) when is_binary(string) \n@spec parse(t | binary) :: t\n  \nparse(%URI{} = uri)\n\n  Parses a well-formed URI reference into its components.\n\n  Note this function expects a well-formed URI and does not perform\n  any validation. See the \"Examples\" section below for examples of how\n  `URI.parse/1` can be used to parse a wide range of URIs.\n\n  This function uses the parsing regular expression as defined\n  in [RFC 3986, Appendix B](https://tools.ietf.org/html/rfc3986#appendix-B).\n\n  When a URI is given without a port, the value returned by\n  `URI.default_port/1` for the URI's scheme is used for the `:port` field.\n\n  If a `%URI{}` struct is given to this function, this function returns it\n  unmodified.\n\n  ## Examples\n\n      iex> URI.parse(\"http://elixir-lang.org/\")\n      %URI{scheme: \"http\", path: \"/\", query: nil, fragment: nil,\n           authority: \"elixir-lang.org\", userinfo: nil,\n           host: \"elixir-lang.org\", port: 80}\n\n      iex> URI.parse(\"//elixir-lang.org/\")\n      %URI{authority: \"elixir-lang.org\", fragment: nil, host: \"elixir-lang.org\",\n           path: \"/\", port: nil, query: nil, scheme: nil, userinfo: nil}\n\n      iex> URI.parse(\"/foo/bar\")\n      %URI{authority: nil, fragment: nil, host: nil, path: \"/foo/bar\",\n           port: nil, query: nil, scheme: nil, userinfo: nil}\n\n      iex> URI.parse(\"foo/bar\")\n      %URI{authority: nil, fragment: nil, host: nil, path: \"foo/bar\",\n           port: nil, query: nil, scheme: nil, userinfo: nil}\n\n  "
    },
    path_to_segments = {
      description = "\npath_to_segments(path)\n"
    },
    t = {
      description = "t :: %__MODULE__{\n"
    },
    to_string = {
      description = "\nto_string(%{scheme: scheme, port: port, path: path,\n                  query: query, fragment: fragment} = uri)\n"
    }
  },
  UndefinedFunctionError = {
    message = {
      description = "\nmessage(%{reason: reason,  module: module, function: function, arity: arity})\n\nmessage(%{reason: :\"function not available\", module: module, function: function, arity: arity})\n\nmessage(%{reason: :\"function not exported\",  module: module, function: function, arity: arity, exports: exports})\n\nmessage(%{reason: :\"module could not be loaded\", module: module, function: function, arity: arity})\n\nmessage(%{reason: nil, module: module, function: function, arity: arity} = e)\n"
    }
  },
  UnicodeConversionError = {
    exception = {
      description = "\nexception(opts)\n"
    }
  },
  Utils = nil,
  Version = {
    build = {
      description = "build :: String.t | nil\n"
    },
    description = "\n  Functions for parsing and matching versions against requirements.\n\n  A version is a string in a specific format or a `Version`\n  generated after parsing via `Version.parse/1`.\n\n  `Version` parsing and requirements follow\n  [SemVer 2.0 schema](http://semver.org/).\n\n  ## Versions\n\n  In a nutshell, a version is represented by three numbers:\n\n      MAJOR.MINOR.PATCH\n\n  Pre-releases are supported by appending `-[0-9A-Za-z-\\.]`:\n\n      \"1.0.0-alpha.3\"\n\n  Build information can be added by appending `+[0-9A-Za-z-\\.]`:\n\n      \"1.0.0-alpha.3+20130417140000\"\n\n  ## Struct\n\n  The version is represented by the Version struct and fields\n  are named according to SemVer: `:major`, `:minor`, `:patch`,\n  `:pre` and `:build`.\n\n  ## Requirements\n\n  Requirements allow you to specify which versions of a given\n  dependency you are willing to work against. It supports common\n  operators like `>=`, `<=`, `>`, `==` and friends that\n  work as one would expect:\n\n      # Only version 2.0.0\n      \"== 2.0.0\"\n\n      # Anything later than 2.0.0\n      \"> 2.0.0\"\n\n  Requirements also support `and` and `or` for complex conditions:\n\n      # 2.0.0 and later until 2.1.0\n      \">= 2.0.0 and < 2.1.0\"\n\n  Since the example above is such a common requirement, it can\n  be expressed as:\n\n      \"~> 2.0.0\"\n\n  `~>` will never include pre-release versions of its upper bound.\n  It can also be used to set an upper bound on only the major\n  version part. See the table below for `~>` requirements and\n  their corresponding translation.\n\n  `~>`           | Translation\n  :------------- | :---------------------\n  `~> 2.0.0`     | `>= 2.0.0 and < 2.1.0`\n  `~> 2.1.2`     | `>= 2.1.2 and < 2.2.0`\n  `~> 2.1.3-dev` | `>= 2.1.3-dev and < 2.2.0`\n  `~> 2.0`       | `>= 2.0.0 and < 3.0.0`\n  `~> 2.1`       | `>= 2.1.0 and < 3.0.0`\n\n  When `allow_pre: false` is set the requirement will not match a\n  pre-release version unless the operand is a pre-release version.\n  The default is to always allow pre-releases but note that in\n  Hex `:allow_pre` is set to `false.` See the table below for examples.\n\n  Requirement    | Version     | `:allow_pre` | Matches\n  :------------- | :---------- | :----------- | :------\n  `~> 2.0`       | `2.1.0`     | -            | `true`\n  `~> 2.0`       | `3.0.0`     | -            | `false`\n  `~> 2.0.0`     | `2.0.1`     | -            | `true`\n  `~> 2.0.0`     | `2.1.0`     | -            | `false`\n  `~> 2.1.2`     | `2.1.3-dev` | `true`       | `true`\n  `~> 2.1.2`     | `2.1.3-dev` | `false`      | `false`\n  `~> 2.1-dev`   | `2.2.0-dev` | `false`      | `true`\n  `~> 2.1.2-dev` | `2.1.3-dev` | `false`      | `true`\n  `>= 2.1.0`     | `2.2.0-dev` | `false`      | `false`\n  `>= 2.1.0-dev` | `2.2.3-dev` | `true`       | `true`\n\n  ",
    major = {
      description = "major :: String.t | non_neg_integer\n"
    },
    matchable = {
      description = "matchable :: {major :: major,\n"
    },
    minor = {
      description = "minor :: non_neg_integer | nil\n"
    },
    patch = {
      description = "patch :: non_neg_integer | nil\n"
    },
    pre = {
      description = "pre :: [String.t | non_neg_integer]\n"
    },
    requirement = {
      description = "requirement :: String.t | Version.Requirement.t\n"
    },
    t = {
      description = "t :: %__MODULE__{\n"
    },
    version = {
      description = "version :: String.t | t\n"
    }
  },
  Wildcard = {
    description = "false",
    list_dir = {
      description = "\nlist_dir(dir)\n"
    },
    read_link_info = {
      description = "\nread_link_info(file)\n"
    }
  },
  WithClauseError = {
    message = {
      description = "\nmessage(exception)\n"
    }
  },
  __struct__ = nil,
  ["alias!"] = nil,
  binding = nil,
  def = nil,
  defdelegate = nil,
  defexception = nil,
  defimpl = nil,
  defmacro = nil,
  defmacrop = nil,
  defmodule = nil,
  defoverridable = nil,
  defp = nil,
  defprotocol = nil,
  defstruct = nil,
  description = "\n  Provides the default macros and functions Elixir imports into your\n  environment.\n\n  These macros and functions can be skipped or cherry-picked via the\n  `import/2` macro. For instance, if you want to tell Elixir not to\n  import the `if/2` macro, you can do:\n\n      import Kernel, except: [if: 2]\n\n  Elixir also has special forms that are always imported and\n  cannot be skipped. These are described in `Kernel.SpecialForms`.\n\n  Some of the functions described in this module are inlined by\n  the Elixir compiler into their Erlang counterparts in the\n  [`:erlang` module](http://www.erlang.org/doc/man/erlang.html).\n  Those functions are called BIFs (built-in internal functions)\n  in Erlang-land and they exhibit interesting properties, as some of\n  them are allowed in guards and others are used for compiler\n  optimizations.\n\n  Most of the inlined functions can be seen in effect when capturing\n  the function:\n\n      iex> &Kernel.is_atom/1\n      &:erlang.is_atom/1\n\n  Those functions will be explicitly marked in their docs as\n  \"inlined by the compiler\".\n  ",
  destructure = nil,
  get_and_update_in = nil,
  get_in = nil,
  ["if"] = nil,
  is_nil = nil,
  ["match?"] = nil,
  pop_in = nil,
  put_in = nil,
  raise = nil,
  reraise = nil,
  sigil_C = nil,
  sigil_D = nil,
  sigil_N = nil,
  sigil_R = nil,
  sigil_S = nil,
  sigil_T = nil,
  sigil_W = nil,
  sigil_c = nil,
  sigil_r = nil,
  sigil_s = nil,
  sigil_w = nil,
  ["struct!"] = nil,
  to_char_list = nil,
  to_charlist = nil,
  to_string = nil,
  unless = nil,
  update_in = nil,
  use = nil,
  ["var!"] = nil
}

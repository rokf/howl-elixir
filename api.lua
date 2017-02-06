return {
  [""] = {
    description = "(-value)\n(+value)\n\n  Arithmetic unary plus.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> +1\n      1\n\n  "
  },
  A = {
    hello = {
      description = "hello\n\n        Sums `a` to `b`.\n        "
    }
  },
  Access = {
    all = {
      description = "all()\n\n  Returns a function that accesses all the elements in a list.\n\n  The returned function is typically passed as an accessor to `Kernel.get_in/2`,\n  `Kernel.get_and_update_in/3`, and friends.\n\n  ## Examples\n\n      iex> list = [%{name: \"john\"}, %{name: \"mary\"}]\n      iex> get_in(list, [Access.all(), :name])\n      [\"john\", \"mary\"]\n      iex> get_and_update_in(list, [Access.all(), :name], fn\n      ...>   prev -> {prev, String.upcase(prev)}\n      ...> end)\n      {[\"john\", \"mary\"], [%{name: \"JOHN\"}, %{name: \"MARY\"}]}\n      iex> pop_in(list, [Access.all(), :name])\n      {[\"john\", \"mary\"], [%{}, %{}]}\n\n  Here is an example that traverses the list dropping even\n  numbers and multiplying odd numbers by 2:\n\n      iex> require Integer\n      iex> get_and_update_in([1, 2, 3, 4, 5], [Access.all], fn\n      ...>   num -> if Integer.is_even(num), do: :pop, else: {num, num * 2}\n      ...> end)\n      {[1, 2, 3, 4, 5], [2, 6, 10]}\n\n  An error is raised if the accessed structure is not a list:\n\n      iex> get_in(%{}, [Access.all()])\n      ** (RuntimeError) Access.all/0 expected a list, got: %{}\n\n  "
    },
    at = {
      description = "at(index) when index >= 0\n\n  Returns a function that accesses the element at `index` (zero based) of a list.\n\n  The returned function is typically passed as an accessor to `Kernel.get_in/2`,\n  `Kernel.get_and_update_in/3`, and friends.\n\n  ## Examples\n\n      iex> list = [%{name: \"john\"}, %{name: \"mary\"}]\n      iex> get_in(list, [Access.at(1), :name])\n      \"mary\"\n      iex> get_and_update_in(list, [Access.at(0), :name], fn\n      ...>   prev -> {prev, String.upcase(prev)}\n      ...> end)\n      {\"john\", [%{name: \"JOHN\"}, %{name: \"mary\"}]}\n\n  `at/1` can also be used to pop elements out of a list or\n  a key inside of a list:\n\n      iex> list = [%{name: \"john\"}, %{name: \"mary\"}]\n      iex> pop_in(list, [Access.at(0)])\n      {%{name: \"john\"}, [%{name: \"mary\"}]}\n      iex> pop_in(list, [Access.at(0), :name])\n      {\"john\", [%{}, %{name: \"mary\"}]}\n\n  When the index is out of bounds, `nil` is returned and the update function is never called:\n\n      iex> list = [%{name: \"john\"}, %{name: \"mary\"}]\n      iex> get_in(list, [Access.at(10), :name])\n      nil\n      iex> get_and_update_in(list, [Access.at(10), :name], fn\n      ...>   prev -> {prev, String.upcase(prev)}\n      ...> end)\n      {nil, [%{name: \"john\"}, %{name: \"mary\"}]}\n\n  An error is raised for negative indexes:\n\n      iex> get_in([], [Access.at(-1)])\n      ** (FunctionClauseError) no function clause matching in Access.at/1\n\n  An error is raised if the accessed structure is not a list:\n\n      iex> get_in(%{}, [Access.at(1)])\n      ** (RuntimeError) Access.at/1 expected a list, got: %{}\n  "
    },
    description = "\n  Key-based access to data structures using the `data[key]` syntax.\n\n  Elixir provides two syntaxes for accessing values. `user[:name]`\n  is used by dynamic structures, like maps and keywords, while\n  `user.name` is used by structs. The main difference is that\n  `user[:name]` won't raise if the key `:name` is missing but\n  `user.name` will raise if there is no `:name` key.\n\n  Besides the cases above, this module provides convenience\n  functions for accessing other structures, like `at/1` for\n  lists and `elem/1` for tuples. Those functions can be used\n  by the nested update functions in `Kernel`, such as\n  `Kernel.get_in/2`, `Kernel.put_in/3`, `Kernel.update_in/3`,\n  `Kernel.get_and_update_in/3` and friends.\n\n  ## Dynamic lookups\n\n  Out of the box, `Access` works with `Keyword` and `Map`:\n\n      iex> keywords = [a: 1, b: 2]\n      iex> keywords[:a]\n      1\n\n      iex> map = %{a: 1, b: 2}\n      iex> map[:a]\n      1\n\n      iex> star_ratings = %{1.0 => \"★\", 1.5 => \"★☆\", 2.0 => \"★★\"}\n      iex> star_ratings[1.5]\n      \"★☆\"\n\n  Note that the dynamic lookup syntax (`term[key]`) roughly translates to\n  `Access.get(term, key, nil)`.\n\n  `Access` can be combined with `Kernel.put_in/3` to put a value\n  in a given key:\n\n      iex> map = %{a: 1, b: 2}\n      iex> put_in map[:a], 3\n      %{a: 3, b: 2}\n\n  This syntax is very convenient as it can be nested arbitrarily:\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> put_in users[\"john\"][:age], 28\n      %{\"john\" => %{age: 28}, \"meg\" => %{age: 23}}\n\n  Furthermore, `Access` transparently ignores `nil` values:\n\n      iex> keywords = [a: 1, b: 2]\n      iex> keywords[:c][:unknown]\n      nil\n\n  Since `Access` is a behaviour, it can be implemented for key-value\n  data structures. The implementation should be added to the\n  module that defines the struct being accessed. `Access` requires the\n  key comparison to be implemented using the `===` operator.\n\n  ## Static lookups\n\n  The `Access` syntax (`foo[bar]`) cannot be used to access fields in\n  structs, since structs do not implement the `Access` behaviour by\n  default. It is also a design decision: the dynamic access lookup\n  is meant to be used for dynamic key-value structures, like maps\n  and keywords, and not by static ones like structs (where fields are\n  known and not dynamic).\n\n  Therefore Elixir provides a static lookup for struct fields and for atom\n  fields in maps. Imagine a struct named `User` with a `:name` field.\n  The following would raise:\n\n      user = %User{name: \"John\"}\n      user[:name]\n      # ** (UndefinedFunctionError) undefined function User.fetch/2\n      #    (User does not implement the Access behaviour)\n\n  Structs instead use the `user.name` syntax to access fields:\n\n      user.name\n      #=> \"John\"\n\n  The same `user.name` syntax can also be used by `Kernel.put_in/2`\n  for updating structs fields:\n\n      put_in user.name, \"Mary\"\n      #=> %User{name: \"Mary\"}\n\n  Differently from `user[:name]`, `user.name` is not extensible via\n  a behaviour and is restricted only to structs and atom keys in maps.\n\n  As mentioned above, this works for atom keys in maps as well. Refer to the\n  `Map` module for more information on this.\n\n  Summing up:\n\n    * `user[:name]` is used by dynamic structures, is extensible and\n      does not raise on missing keys\n    * `user.name` is used by static structures, it is not extensible\n      and it will raise on missing keys\n\n  ## Accessors\n\n  While Elixir provides built-in syntax only for traversing dynamic\n  and static key-value structures, this module provides convenience\n  functions for traversing other structures, like tuples and lists,\n  to be used alongside `Kernel.put_in/2` in others.\n\n  For instance, given a user with a list of languages, here is how to\n  deeply traverse the map and convert all language names to uppercase:\n\n      iex> user = %{name: \"john\",\n      ...>          languages: [%{name: \"elixir\", type: :functional},\n      ...>                      %{name: \"c\", type: :procedural}]}\n      iex> update_in user, [:languages, Access.all(), :name], &String.upcase/1\n      %{name: \"john\",\n        languages: [%{name: \"ELIXIR\", type: :functional},\n                    %{name: \"C\", type: :procedural}]}\n\n  See the functions `key/1`, `key!/1`, `elem/1`, and `all/0` for some of the\n  available accessors.\n\n  ## Implementing the Access behaviour for custom data structures\n\n  In order to be able to use the `Access` protocol with custom data structures\n  (which have to be structs), such structures have to implement the `Access`\n  behaviour. For example, for a `User` struct, this would have to be done:\n\n      defmodule User do\n        defstruct [:name, :email]\n\n        @behaviour Access\n        # Implementation of the Access callbacks...\n      end\n\n  ",
    elem = {
      description = "elem(index) when is_integer(index)\n\n  Returns a function that accesses the element at the given index in a tuple.\n\n  The returned function is typically passed as an accessor to `Kernel.get_in/2`,\n  `Kernel.get_and_update_in/3`, and friends.\n\n  Raises if the index is out of bounds.\n\n  ## Examples\n\n      iex> map = %{user: {\"john\", 27}}\n      iex> get_in(map, [:user, Access.elem(0)])\n      \"john\"\n      iex> get_and_update_in(map, [:user, Access.elem(0)], fn\n      ...>   prev -> {prev, String.upcase(prev)}\n      ...> end)\n      {\"john\", %{user: {\"JOHN\", 27}}}\n      iex> pop_in(map, [:user, Access.elem(0)])\n      ** (RuntimeError) cannot pop data from a tuple\n\n  An error is raised if the accessed structure is not a tuple:\n\n      iex> get_in(%{}, [Access.elem(0)])\n      ** (RuntimeError) Access.elem/1 expected a tuple, got: %{}\n\n  "
    },
    fetch = {
      description = "fetch(nil, _key)\nfetch(list, key) when is_list(list)\nfetch(list, key) when is_list(list) and is_atom(key)\nfetch(map, key) when is_map(map)\nfetch(%{__struct__: struct} = container, key)\nfetch(t, term) :: {:ok, term} | :error\nfetch(container, key)\n\n  Fetches the value for the given key in a container (a map, keyword\n  list, or struct that implements the `Access` behaviour).\n  "
    },
    get = {
      description = "get(t, term, term) :: term\nget(container, key, default \\\\ nil)\n\n  Gets the value for the given key in a container (a map, keyword\n  list, or struct that implements the `Access` behaviour).\n  "
    },
    get_and_update = {
      description = "get_and_update(nil, key, _fun)\nget_and_update(list, key, fun) when is_list(list)\nget_and_update(map, key, fun) when is_map(map)\nget_and_update(%{__struct__: struct} = container, key, fun)\nget_and_update(container :: t, key, (value -> {get_value, update_value} | :pop)) ::\nget_and_update(container, key, fun)\n\n  Gets and updates the given key in a container (a map, keyword\n  list, or struct that implements the `Access` behaviour).\n\n  This `fun` argument receives the value of `key` (or `nil` if `key`\n  is not present) and must return a two-element tuple: the \"get\" value\n  (the retrieved value, which can be operated on before being returned)\n  and the new value to be stored under `key`. The `fun` may also\n  return `:pop`, implying the current value shall be removed\n  from the container and returned.\n\n  The returned value is a two-element tuple with the \"get\" value returned by\n  `fun` and a new container with the updated value under `key`.\n  "
    },
    key = {
      description = "key(key, default \\\\ nil)\nkey :: any\n"
    },
    ["key!"] = {
      description = "key!(key)\n\n  Returns a function that accesses the given key in a map/struct.\n\n  The returned function is typically passed as an accessor to `Kernel.get_in/2`,\n  `Kernel.get_and_update_in/3`, and friends.\n\n  Raises if the key does not exist.\n\n  ## Examples\n\n      iex> map = %{user: %{name: \"john\"}}\n      iex> get_in(map, [Access.key!(:user), Access.key!(:name)])\n      \"john\"\n      iex> get_and_update_in(map, [Access.key!(:user), Access.key!(:name)], fn\n      ...>   prev -> {prev, String.upcase(prev)}\n      ...> end)\n      {\"john\", %{user: %{name: \"JOHN\"}}}\n      iex> pop_in(map, [Access.key!(:user), Access.key!(:name)])\n      {\"john\", %{user: %{}}}\n      iex> get_in(map, [Access.key!(:user), Access.key!(:unknown)])\n      ** (KeyError) key :unknown not found in: %{name: \\\"john\\\"}\n\n  An error is raised if the accessed structure is not a map/struct:\n\n      iex> get_in([], [Access.key!(:foo)])\n      ** (RuntimeError) Access.key!/1 expected a map/struct, got: []\n\n  "
    },
    pop = {
      description = "pop(nil, key)\npop(list, key) when is_list(list)\npop(map, key) when is_map(map)\npop(%{__struct__: struct} = container, key)\n\n  Removes the entry with a given key from a container (a map, keyword\n  list, or struct that implements the `Access` behaviour).\n\n  Returns a tuple containing the value associated with the key and the\n  updated container. `nil` is returned for the value if the key isn't\n  in the container.\n\n  ## Examples\n\n  With a map:\n\n      iex> Access.pop(%{name: \"Elixir\", creator: \"Valim\"}, :name)\n      {\"Elixir\", %{creator: \"Valim\"}}\n\n  A keyword list:\n\n      iex> Access.pop([name: \"Elixir\", creator: \"Valim\"], :name)\n      {\"Elixir\", [creator: \"Valim\"]}\n\n  An unknown key:\n\n      iex> Access.pop(%{name: \"Elixir\", creator: \"Valim\"}, :year)\n      {nil, %{creator: \"Valim\", name: \"Elixir\"}}\n\n  "
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
        description = "code_change(_old, state, fun)\n"
      },
      description = "false",
      handle_call = {
        description = "handle_call(msg, from, state)\nhandle_call({:update, fun}, _from, state)\nhandle_call({:get_and_update, fun}, _from, state)\nhandle_call({:get, fun}, _from, state)\n"
      },
      handle_cast = {
        description = "handle_cast(msg, state)\nhandle_cast({:cast, fun}, state)\n"
      },
      init = {
        description = "init(fun)\n"
      }
    },
    agent = {
      description = "agent :: pid | {atom, node} | name\n"
    },
    cast = {
      description = "cast(agent, module, atom, [term]) :: :ok\ncast(agent, module, fun, args)\ncast(agent, (state -> state)) :: :ok\ncast(agent, fun) when is_function(fun, 1)\n\n  Performs a cast (fire and forget) operation on the agent state.\n\n  The function `fun` is sent to the `agent` which invokes the function\n  passing the agent state. The function must return the new state.\n\n  Note that `cast` returns `:ok` immediately, regardless of whether the\n  destination node or agent exists.\n  "
    },
    description = "\n  Agents are a simple abstraction around state.\n\n  Often in Elixir there is a need to share or store state that\n  must be accessed from different processes or by the same process\n  at different points in time.\n\n  The Agent module provides a basic server implementation that\n  allows state to be retrieved and updated via a simple API.\n\n  ## Examples\n\n  For example, in the Mix tool that ships with Elixir, we need\n  to keep a set of all tasks executed by a given project. Since\n  this set is shared, we can implement it with an Agent:\n\n      defmodule Mix.TasksServer do\n        def start_link do\n          Agent.start_link(fn -> MapSet.new end, name: __MODULE__)\n        end\n\n        @doc \"Checks if the task has already executed\"\n        def executed?(task, project) do\n          item = {task, project}\n          Agent.get(__MODULE__, fn set ->\n            item in set\n          end)\n        end\n\n        @doc \"Marks a task as executed\"\n        def put_task(task, project) do\n          item = {task, project}\n          Agent.update(__MODULE__, &MapSet.put(&1, item))\n        end\n\n        @doc \"Resets the executed tasks and returns the previous list of tasks\"\n        def take_all() do\n          Agent.get_and_update(__MODULE__, fn set ->\n            {Enum.into(set, []), MapSet.new}\n          end)\n        end\n      end\n\n  Note that agents still provide a segregation between the\n  client and server APIs, as seen in GenServers. In particular,\n  all code inside the function passed to the agent is executed\n  by the agent. This distinction is important because you may\n  want to avoid expensive operations inside the agent, as it will\n  effectively block the agent until the request is fulfilled.\n\n  Consider these two examples:\n\n      # Compute in the agent/server\n      def get_something(agent) do\n        Agent.get(agent, fn state -> do_something_expensive(state) end)\n      end\n\n      # Compute in the agent/client\n      def get_something(agent) do\n        Agent.get(agent, &(&1)) |> do_something_expensive()\n      end\n\n  The first function blocks the agent. The second function copies\n  all the state to the client and then executes the operation in the\n  client. The difference is whether the data is large enough to require\n  processing in the server, at least initially, or small enough to be\n  sent to the client cheaply.\n\n  ## Name Registration\n\n  An Agent is bound to the same name registration rules as GenServers.\n  Read more about it in the `GenServer` docs.\n\n  ## A word on distributed agents\n\n  It is important to consider the limitations of distributed agents. Agents\n  provide two APIs, one that works with anonymous functions and another\n  that expects an explicit module, function, and arguments.\n\n  In a distributed setup with multiple nodes, the API that accepts anonymous\n  functions only works if the caller (client) and the agent have the same\n  version of the caller module.\n\n  Keep in mind this issue also shows up when performing \"rolling upgrades\"\n  with agents. By rolling upgrades we mean the following situation: you wish\n  to deploy a new version of your software by *shutting down* some of your\n  nodes and replacing them with nodes running a new version of the software.\n  In this setup, part of your environment will have one version of a given\n  module and the other part another version (the newer one) of the same module.\n\n  The best solution is to simply use the explicit module, function, and arguments\n  APIs when working with distributed agents.\n\n  ## Hot code swapping\n\n  An agent can have its code hot swapped live by simply passing a module,\n  function, and args tuple to the update instruction. For example, imagine\n  you have an agent named `:sample` and you want to convert its inner state\n  from some dict structure to a map. It can be done with the following\n  instruction:\n\n      {:update, :sample, {:advanced, {Enum, :into, [%{}]}}}\n\n  The agent's state will be added to the given list as the first argument.\n  ",
    get = {
      description = "get(agent, module, atom, [term], timeout) :: any\nget(agent, module, fun, args, timeout \\\\ 5000)\nget(agent, (state -> a), timeout) :: a when a: var\nget(agent, fun, timeout \\\\ 5000) when is_function(fun, 1)\n\n  Gets an agent value via the given function.\n\n  The function `fun` is sent to the `agent` which invokes the function\n  passing the agent state. The result of the function invocation is\n  returned.\n\n  A timeout can also be specified (it has a default value of 5000).\n\n  ## Examples\n\n      iex> {:ok, pid} = Agent.start_link(fn -> 42 end)\n      iex> Agent.get(pid, fn(state) -> state end)\n      42\n\n  "
    },
    get_and_update = {
      description = "get_and_update(agent, module, atom, [term], timeout) :: any\nget_and_update(agent, module, fun, args, timeout \\\\ 5000)\nget_and_update(agent, (state -> {a, state}), timeout) :: a when a: var\nget_and_update(agent, fun, timeout \\\\ 5000) when is_function(fun, 1)\n\n  Gets and updates the agent state in one operation.\n\n  The function `fun` is sent to the `agent` which invokes the function\n  passing the agent state. The function must return a tuple with two\n  elements, the first being the value to return (i.e. the `get` value)\n  and the second one is the new state.\n\n  A timeout can also be specified (it has a default value of 5000).\n\n  ## Examples\n\n      iex> {:ok, pid} = Agent.start_link(fn -> 42 end)\n      iex> Agent.get_and_update(pid, fn(state) -> {state, state + 1} end)\n      42\n      iex> Agent.get(pid, fn(state) -> state end)\n      43\n\n  "
    },
    name = {
      description = "name :: atom | {:global, term} | {:via, module, term}\n"
    },
    on_start = {
      description = "on_start :: {:ok, pid} | {:error, {:already_started, pid} | term}\n"
    },
    start = {
      description = "start(module, atom, [any], GenServer.options) :: on_start\nstart(module, fun, args, options \\\\ [])\nstart((() -> term), GenServer.options) :: on_start\nstart(fun, options \\\\ []) when is_function(fun, 0)\n\n  Starts an agent process without links (outside of a supervision tree).\n\n  See `start_link/2` for more information.\n\n  ## Examples\n\n      iex> {:ok, pid} = Agent.start(fn -> 42 end)\n      iex> Agent.get(pid, fn(state) -> state end)\n      42\n\n  "
    },
    start_link = {
      description = "start_link(module, atom, [any], GenServer.options) :: on_start\nstart_link(module, fun, args, options \\\\ [])\nstart_link((() -> term), GenServer.options) :: on_start\nstart_link(fun, options \\\\ []) when is_function(fun, 0)\n\n  Starts an agent linked to the current process with the given function.\n\n  This is often used to start the agent as part of a supervision tree.\n\n  Once the agent is spawned, the given function is invoked and its return\n  value is used as the agent state. Note that `start_link` does not return\n  until the given function has returned.\n\n  ## Options\n\n  The `:name` option is used for registration as described in the module\n  documentation.\n\n  If the `:timeout` option is present, the agent is allowed to spend at most\n  the given number of milliseconds on initialization or it will be terminated\n  and the start function will return `{:error, :timeout}`.\n\n  If the `:debug` option is present, the corresponding function in the\n  [`:sys` module](http://www.erlang.org/doc/man/sys.html) will be invoked.\n\n  If the `:spawn_opt` option is present, its value will be passed as options\n  to the underlying process as in `Process.spawn/4`.\n\n  ## Return values\n\n  If the server is successfully created and initialized, the function returns\n  `{:ok, pid}`, where `pid` is the PID of the server. If an agent with the\n  specified name already exists, the function returns\n  `{:error, {:already_started, pid}}` with the PID of that process.\n\n  If the given function callback fails with `reason`, the function returns\n  `{:error, reason}`.\n\n  ## Examples\n\n      iex> {:ok, pid} = Agent.start_link(fn -> 42 end)\n      iex> Agent.get(pid, fn(state) -> state end)\n      42\n\n  "
    },
    state = {
      description = "state :: term\n"
    },
    stop = {
      description = "stop(agent, reason :: term, timeout) :: :ok\nstop(agent, reason \\\\ :normal, timeout \\\\ :infinity)\n\n  Synchronously stops the agent with the given `reason`.\n\n  It returns `:ok` if the server terminates with the given\n  reason, if it terminates with another reason, the call will\n  exit.\n\n  This function keeps OTP semantics regarding error reporting.\n  If the reason is any other than `:normal`, `:shutdown` or\n  `{:shutdown, _}`, an error report will be logged.\n\n  ## Examples\n\n      iex> {:ok, pid} = Agent.start_link(fn -> 42 end)\n      iex> Agent.stop(pid)\n      :ok\n\n  "
    },
    update = {
      description = "update(agent, module, atom, [term], timeout) :: :ok\nupdate(agent, module, fun, args, timeout \\\\ 5000)\nupdate(agent, (state -> state), timeout) :: :ok\nupdate(agent, fun, timeout \\\\ 5000) when is_function(fun, 1)\n\n  Updates the agent state.\n\n  The function `fun` is sent to the `agent` which invokes the function\n  passing the agent state. The function must return the new state.\n\n  A timeout can also be specified (it has a default value of 5000).\n  This function always returns `:ok`.\n\n  ## Examples\n\n      iex> {:ok, pid} = Agent.start_link(fn -> 42 end)\n      iex> Agent.update(pid, fn(state) -> state + 1 end)\n      :ok\n      iex> Agent.get(pid, fn(state) -> state end)\n      43\n\n  "
    }
  },
  Application = {
    app = {
      description = "app :: atom\n"
    },
    app_dir = {
      description = "app_dir(app, path) when is_list(path)\napp_dir(app, String.t | [String.t]) :: String.t\napp_dir(app, path) when is_binary(path)\napp_dir(app) :: String.t\napp_dir(app) when is_atom(app)\n\n  Gets the directory for app.\n\n  This information is returned based on the code path. Here is an\n  example:\n\n      File.mkdir_p!(\"foo/ebin\")\n      Code.prepend_path(\"foo/ebin\")\n      Application.app_dir(:foo)\n      #=> \"foo\"\n\n  Even though the directory is empty and there is no `.app` file\n  it is considered the application directory based on the name\n  \"foo/ebin\". The name may contain a dash `-` which is considered\n  to be the app version and it is removed for the lookup purposes:\n\n      File.mkdir_p!(\"bar-123/ebin\")\n      Code.prepend_path(\"bar-123/ebin\")\n      Application.app_dir(:bar)\n      #=> \"bar-123\"\n\n  For more information on code paths, check the `Code` module in\n  Elixir and also Erlang's [`:code` module](http://www.erlang.org/doc/man/code.html).\n  "
    },
    delete_env = {
      description = "delete_env(app, key, [timeout: timeout, persistent: boolean]) :: :ok\ndelete_env(app, key, opts \\\\ [])\n\n  Deletes the `key` from the given `app` environment.\n\n  See `put_env/4` for a description of the options.\n  "
    },
    description = "\n  A module for working with applications and defining application callbacks.\n\n  In Elixir (actually, in Erlang/OTP), an application is a component\n  implementing some specific functionality, that can be started and stopped\n  as a unit, and which can be re-used in other systems.\n\n  Applications are defined with an application file named `APP.app` where\n  `APP` is the application name, usually in `underscore_case`. The application\n  file must reside in the same `ebin` directory as the compiled modules of the\n  application.\n\n  In Elixir, Mix is responsible for compiling your source code and\n  generating your application `.app` file. Furthermore, Mix is also\n  responsible for configuring, starting and stopping your application\n  and its dependencies. For this reason, this documentation will focus\n  on the remaining aspects of your application: the application environment\n  and the application callback module.\n\n  You can learn more about Mix generation of `.app` files by typing\n  `mix help compile.app`.\n\n  ## Application environment\n\n  Once an application is started, OTP provides an application environment\n  that can be used to configure the application.\n\n  Assuming you are inside a Mix project, you can edit the `application/0`\n  function in the `mix.exs` file to the following:\n\n      def application do\n        [env: [hello: :world]]\n      end\n\n  In the application function, we can define the default environment values\n  for our application. By starting your application with `iex -S mix`, you\n  can access the default value:\n\n      Application.get_env(:APP_NAME, :hello)\n      #=> :world\n\n  It is also possible to put and delete values from the application value,\n  including new values that are not defined in the environment file (although\n  this should be avoided).\n\n  Keep in mind that each application is responsible for its environment.\n  Do not use the functions in this module for directly accessing or modifying\n  the environment of other applications (as it may lead to inconsistent\n  data in the application environment).\n\n  ## Application module callback\n\n  Often times, an application defines a supervision tree that must be started\n  and stopped when the application starts and stops. For such, we need to\n  define an application module callback. The first step is to define the\n  module callback in the application definition in the `mix.exs` file:\n\n      def application do\n        [mod: {MyApp, []}]\n      end\n\n  Our application now requires the `MyApp` module to provide an application\n  callback. This can be done by invoking `use Application` in that module and\n  defining a `start/2` callback, for example:\n\n      defmodule MyApp do\n        use Application\n\n        def start(_type, _args) do\n          MyApp.Supervisor.start_link()\n        end\n      end\n\n  `start/2` typically returns `{:ok, pid}` or `{:ok, pid, state}` where\n  `pid` identifies the supervision tree and `state` is the application state.\n  `args` is the second element of the tuple given to the `:mod` option.\n\n  The `type` argument passed to `start/2` is usually `:normal` unless in a\n  distributed setup where application takeovers and failovers are configured.\n  This particular aspect of applications is explained in more detail in the\n  OTP documentation:\n\n    * [`:application` module](http://www.erlang.org/doc/man/application.html)\n    * [Applications – OTP Design Principles](http://www.erlang.org/doc/design_principles/applications.html)\n\n  A developer may also implement the `stop/1` callback (automatically defined\n  by `use Application`) which does any application cleanup. It receives the\n  application state and can return any value. Note that shutting down the\n  supervisor is automatically handled by the VM.\n  ",
    ensure_all_started = {
      description = "ensure_all_started(app, start_type) :: {:ok, [app]} | {:error, {app, term}}\nensure_all_started(app, type \\\\ :temporary) when is_atom(app)\n\n  Ensures the given `app` and its applications are started.\n\n  Same as `start/2` but also starts the applications listed under\n  `:applications` in the `.app` file in case they were not previously\n  started.\n  "
    },
    ensure_started = {
      description = "ensure_started(app, start_type) :: :ok | {:error, term}\nensure_started(app, type \\\\ :temporary) when is_atom(app)\n\n  Ensures the given `app` is started.\n\n  Same as `start/2` but returns `:ok` if the application was already\n  started. This is useful in scripts and in test setup, where test\n  applications need to be explicitly started:\n\n      :ok = Application.ensure_started(:my_test_dep)\n\n  "
    },
    fetch_env = {
      description = "fetch_env(app, key) :: {:ok, value} | :error\nfetch_env(app, key)\n\n  Returns the value for `key` in `app`'s environment in a tuple.\n\n  If the configuration parameter does not exist, the function returns `:error`.\n  "
    },
    ["fetch_env!"] = {
      description = "fetch_env!(app, key) :: value | no_return\nfetch_env!(app, key)\n\n  Returns the value for `key` in `app`'s environment.\n\n  If the configuration parameter does not exist, raises `ArgumentError`.\n  "
    },
    format_error = {
      description = "format_error(any) :: String.t\nformat_error(reason)\n\n  Formats the error reason returned by `start/2`,\n  `ensure_started/2`, `stop/1`, `load/1` and `unload/1`,\n  returns a string.\n  "
    },
    get_all_env = {
      description = "get_all_env(app) :: [{key, value}]\nget_all_env(app)\n\n  Returns all key-value pairs for `app`.\n  "
    },
    get_application = {
      description = "get_application(atom) :: atom | nil\nget_application(module) when is_atom(module)\n\n  Gets the application for the given module.\n\n  The application is located by analyzing the spec\n  of all loaded applications. Returns `nil` if\n  the module is not listed in any application spec.\n  "
    },
    get_env = {
      description = "get_env(app, key, value) :: value\nget_env(app, key, default \\\\ nil)\n\n  Returns the value for `key` in `app`'s environment.\n\n  If the configuration parameter does not exist, the function returns the\n  `default` value.\n  "
    },
    key = {
      description = "key :: atom\n"
    },
    load = {
      description = "load(app) :: :ok | {:error, term}\nload(app) when is_atom(app)\n\n  Loads the given `app`.\n\n  In order to be loaded, an `.app` file must be in the load paths.\n  All `:included_applications` will also be loaded.\n\n  Loading the application does not start it nor load its modules, but\n  it does load its environment.\n  "
    },
    loaded_applications = {
      description = "loaded_applications :: [tuple]\nloaded_applications\n\n  Returns a list with information about the applications which have been loaded.\n  "
    },
    put_env = {
      description = "put_env(app, key, value, [timeout: timeout, persistent: boolean]) :: :ok\nput_env(app, key, value, opts \\\\ [])\n\n  Puts the `value` in `key` for the given `app`.\n\n  ## Options\n\n    * `:timeout`    - the timeout for the change (defaults to 5000ms)\n    * `:persistent` - persists the given value on application load and reloads\n\n  If `put_env/4` is called before the application is loaded, the application\n  environment values specified in the `.app` file will override the ones\n  previously set.\n\n  The persistent option can be set to `true` when there is a need to guarantee\n  parameters set with this function will not be overridden by the ones defined\n  in the application resource file on load. This means persistent values will\n  stick after the application is loaded and also on application reload.\n  "
    },
    spec = {
      description = "spec(app, key) :: value | nil\nspec(app, key) when key in @application_keys\nspec(app) :: [{key, value}] | nil\nspec(app)\n\n  Returns the spec for `app`.\n\n  The following keys are returned:\n\n    * #{Enum.map_join @application_keys, \"\\n  * \", &inspect/1}\n\n  Note the environment is not returned as it can be accessed via\n  `fetch_env/2`. Returns `nil` if the application is not loaded.\n  "
    },
    start = {
      description = "start(app, start_type) :: :ok | {:error, term}\nstart(app, type \\\\ :temporary) when is_atom(app)\n\n  Starts the given `app`.\n\n  If the `app` is not loaded, the application will first be loaded using `load/1`.\n  Any included application, defined in the `:included_applications` key of the\n  `.app` file will also be loaded, but they won't be started.\n\n  Furthermore, all applications listed in the `:applications` key must be explicitly\n  started before this application is. If not, `{:error, {:not_started, app}}` is\n  returned, where `app` is the name of the missing application.\n\n  In case you want to automatically load **and start** all of `app`'s dependencies,\n  see `ensure_all_started/2`.\n\n  The `type` argument specifies the type of the application:\n\n    * `:permanent` - if `app` terminates, all other applications and the entire\n      node are also terminated.\n\n    * `:transient` - if `app` terminates with `:normal` reason, it is reported\n      but no other applications are terminated. If a transient application\n      terminates abnormally, all other applications and the entire node are\n      also terminated.\n\n    * `:temporary` - if `app` terminates, it is reported but no other\n      applications are terminated (the default).\n\n  Note that it is always possible to stop an application explicitly by calling\n  `stop/1`. Regardless of the type of the application, no other applications will\n  be affected.\n\n  Note also that the `:transient` type is of little practical use, since when a\n  supervision tree terminates, the reason is set to `:shutdown`, not `:normal`.\n  "
    },
    start_type = {
      description = "start_type :: :permanent | :transient | :temporary\n"
    },
    started_applications = {
      description = "started_applications(timeout) :: [tuple]\nstarted_applications(timeout \\\\ 5000)\n\n  Returns a list with information about the applications which are currently running.\n  "
    },
    state = {
      description = "state :: term\n"
    },
    stop = {
      description = "stop(app) :: :ok | {:error, term}\nstop(app)\nstop(_state)\nfalse"
    },
    unload = {
      description = "unload(app) :: :ok | {:error, term}\nunload(app) when is_atom(app)\n\n  Unloads the given `app`.\n\n  It will also unload all `:included_applications`.\n  Note that the function does not purge the application modules.\n  "
    },
    value = {
      description = "value :: term\n"
    }
  },
  ArgumentError = {},
  ArithmeticError = {},
  Atom = {
    description = "\n  Convenience functions for working with atoms.\n\n  See also `Kernel.is_atom/1`.\n  ",
    to_char_list = {
      description = "to_char_list(atom) :: charlist\nto_char_list(atom)\nfalse"
    },
    to_charlist = {
      description = "to_charlist(atom) :: charlist\nto_charlist(atom)\n\n  Converts an atom to a charlist.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> Atom.to_charlist(:\"An atom\")\n      'An atom'\n\n  "
    },
    to_string = {
      description = "to_string(atom) :: String.t\nto_string(atom)\n\n  Converts an atom to a string.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> Atom.to_string(:foo)\n      \"foo\"\n\n  "
    }
  },
  B = {},
  BadArityError = {
    message = {
      description = "message(exception)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    }
  },
  BadBooleanError = {
    message = {
      description = "message(exception)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    }
  },
  BadFunctionError = {
    message = {
      description = "message(exception)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    }
  },
  BadMapError = {
    message = {
      description = "message(exception)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    }
  },
  BadStructError = {
    message = {
      description = "message(exception)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    }
  },
  Base = {
    decode16 = {
      description = "decode16(binary, Keyword.t) :: {:ok, binary} | :error\ndecode16(string, opts \\\\ [])\n\n  Decodes a base 16 encoded string into a binary string.\n\n  ## Options\n\n  The accepted options are:\n\n    * `:case` - specifies the character case to accept when decoding\n\n  The values for `:case` can be:\n\n    * `:upper` - only allows upper case characters (default)\n    * `:lower` - only allows lower case characters\n    * `:mixed` - allows mixed case characters\n\n  ## Examples\n\n      iex> Base.decode16(\"666F6F626172\")\n      {:ok, \"foobar\"}\n\n      iex> Base.decode16(\"666f6f626172\", case: :lower)\n      {:ok, \"foobar\"}\n\n      iex> Base.decode16(\"666f6F626172\", case: :mixed)\n      {:ok, \"foobar\"}\n\n  "
    },
    ["decode16!"] = {
      description = "decode16!(string, _opts) when is_binary(string)\ndecode16!(string, opts) when is_binary(string) and rem(byte_size(string), 2) == 0\ndecode16!(binary, Keyword.t) :: binary\ndecode16!(string, opts \\\\ [])\n\n  Decodes a base 16 encoded string into a binary string.\n\n  ## Options\n\n  The accepted options are:\n\n    * `:case` - specifies the character case to accept when decoding\n\n  The values for `:case` can be:\n\n    * `:upper` - only allows upper case characters (default)\n    * `:lower` - only allows lower case characters\n    * `:mixed` - allows mixed case characters\n\n  An `ArgumentError` exception is raised if the padding is incorrect or\n  a non-alphabet character is present in the string.\n\n  ## Examples\n\n      iex> Base.decode16!(\"666F6F626172\")\n      \"foobar\"\n\n      iex> Base.decode16!(\"666f6f626172\", case: :lower)\n      \"foobar\"\n\n      iex> Base.decode16!(\"666f6F626172\", case: :mixed)\n      \"foobar\"\n\n  "
    },
    decode32 = {
      description = "decode32(binary, Keyword.t) :: {:ok, binary} | :error\ndecode32(string, opts \\\\ [])\n\n  Decodes a base 32 encoded string into a binary string.\n\n  ## Options\n\n  The accepted options are:\n\n    * `:case` - specifies the character case to accept when decoding\n    * `:padding` - specifies whether to require padding\n\n  The values for `:case` can be:\n\n    * `:upper` - only allows  upper case characters (default)\n    * `:lower` - only allows lower case characters\n    * `:mixed` - allows mixed case characters\n\n  The values for `:padding` can be:\n\n    * `true` - requires the input string to be padded to the nearest multiple of 8 (default)\n    * `false` - ignores padding from the input string\n\n  ## Examples\n\n      iex> Base.decode32(\"MZXW6YTBOI======\")\n      {:ok, \"foobar\"}\n\n      iex> Base.decode32(\"mzxw6ytboi======\", case: :lower)\n      {:ok, \"foobar\"}\n\n      iex> Base.decode32(\"mzXW6ytBOi======\", case: :mixed)\n      {:ok, \"foobar\"}\n\n      iex> Base.decode32(\"MZXW6YTBOI\", padding: false)\n      {:ok, \"foobar\"}\n\n  "
    },
    ["decode32!"] = {
      description = "decode32!(binary, Keyword.t) :: binary\ndecode32!(string, opts \\\\ []) when is_binary(string)\n\n  Decodes a base 32 encoded string into a binary string.\n\n  An `ArgumentError` exception is raised if the padding is incorrect or\n  a non-alphabet character is present in the string.\n\n  ## Options\n\n  The accepted options are:\n\n    * `:case` - specifies the character case to accept when decoding\n    * `:padding` - specifies whether to require padding\n\n  The values for `:case` can be:\n\n    * `:upper` - only allows upper case characters (default)\n    * `:lower` - only allows lower case characters\n    * `:mixed` - allows mixed case characters\n\n  The values for `:padding` can be:\n\n    * `true` - requires the input string to be padded to the nearest multiple of 8 (default)\n    * `false` - ignores padding from the input string\n\n  ## Examples\n\n      iex> Base.decode32!(\"MZXW6YTBOI======\")\n      \"foobar\"\n\n      iex> Base.decode32!(\"mzxw6ytboi======\", case: :lower)\n      \"foobar\"\n\n      iex> Base.decode32!(\"mzXW6ytBOi======\", case: :mixed)\n      \"foobar\"\n\n      iex> Base.decode32!(\"MZXW6YTBOI\", padding: false)\n      \"foobar\"\n\n  "
    },
    decode64 = {
      description = "decode64(binary, Keyword.t) :: {:ok, binary} | :error\ndecode64(string, opts \\\\ []) when is_binary(string)\n\n  Decodes a base 64 encoded string into a binary string.\n\n  Accepts `ignore: :whitespace` option which will ignore all the\n  whitespace characters in the input string.\n\n  Accepts `padding: false` option which will ignore padding from\n  the input string.\n\n  ## Examples\n\n      iex> Base.decode64(\"Zm9vYmFy\")\n      {:ok, \"foobar\"}\n\n      iex> Base.decode64(\"Zm9vYmFy\\\\n\", ignore: :whitespace)\n      {:ok, \"foobar\"}\n\n      iex> Base.decode64(\"Zm9vYg==\")\n      {:ok, \"foob\"}\n\n      iex> Base.decode64(\"Zm9vYg\", padding: false)\n      {:ok, \"foob\"}\n\n  "
    },
    ["decode64!"] = {
      description = "decode64!(binary, Keyword.t) :: binary\ndecode64!(string, opts \\\\ []) when is_binary(string)\n\n  Decodes a base 64 encoded string into a binary string.\n\n  Accepts `ignore: :whitespace` option which will ignore all the\n  whitespace characters in the input string.\n\n  Accepts `padding: false` option which will ignore padding from\n  the input string.\n\n  An `ArgumentError` exception is raised if the padding is incorrect or\n  a non-alphabet character is present in the string.\n\n  ## Examples\n\n      iex> Base.decode64!(\"Zm9vYmFy\")\n      \"foobar\"\n\n      iex> Base.decode64!(\"Zm9vYmFy\\\\n\", ignore: :whitespace)\n      \"foobar\"\n\n      iex> Base.decode64!(\"Zm9vYg==\")\n      \"foob\"\n\n      iex> Base.decode64!(\"Zm9vYg\", padding: false)\n      \"foob\"\n\n  "
    },
    description = "\n  This module provides data encoding and decoding functions\n  according to [RFC 4648](https://tools.ietf.org/html/rfc4648).\n\n  This document defines the commonly used base 16, base 32, and base\n  64 encoding schemes.\n\n  ## Base 16 alphabet\n\n      | Value | Encoding | Value | Encoding | Value | Encoding | Value | Encoding |\n      |------:|---------:|------:|---------:|------:|---------:|------:|---------:|\n      |      0|         0|      4|         4|      8|         8|     12|         C|\n      |      1|         1|      5|         5|      9|         9|     13|         D|\n      |      2|         2|      6|         6|     10|         A|     14|         E|\n      |      3|         3|      7|         7|     11|         B|     15|         F|\n\n  ## Base 32 alphabet\n\n      | Value | Encoding | Value | Encoding | Value | Encoding | Value | Encoding |\n      |------:|---------:|------:|---------:|------:|---------:|------:|---------:|\n      |      0|         A|      9|         J|     18|         S|     27|         3|\n      |      1|         B|     10|         K|     19|         T|     28|         4|\n      |      2|         C|     11|         L|     20|         U|     29|         5|\n      |      3|         D|     12|         M|     21|         V|     30|         6|\n      |      4|         E|     13|         N|     22|         W|     31|         7|\n      |      5|         F|     14|         O|     23|         X|       |          |\n      |      6|         G|     15|         P|     24|         Y|  (pad)|         =|\n      |      7|         H|     16|         Q|     25|         Z|       |          |\n      |      8|         I|     17|         R|     26|         2|       |          |\n\n\n  ## Base 32 (extended hex) alphabet\n\n      | Value | Encoding | Value | Encoding | Value | Encoding | Value | Encoding |\n      |------:|---------:|------:|---------:|------:|---------:|------:|---------:|\n      |      0|         0|      9|         9|     18|         I|     27|         R|\n      |      1|         1|     10|         A|     19|         J|     28|         S|\n      |      2|         2|     11|         B|     20|         K|     29|         T|\n      |      3|         3|     12|         C|     21|         L|     30|         U|\n      |      4|         4|     13|         D|     22|         M|     31|         V|\n      |      5|         5|     14|         E|     23|         N|       |          |\n      |      6|         6|     15|         F|     24|         O|  (pad)|         =|\n      |      7|         7|     16|         G|     25|         P|       |          |\n      |      8|         8|     17|         H|     26|         Q|       |          |\n\n  ## Base 64 alphabet\n\n      | Value | Encoding | Value | Encoding | Value | Encoding | Value | Encoding |\n      |------:|---------:|------:|---------:|------:|---------:|------:|---------:|\n      |      0|         A|     17|         R|     34|         i|     51|         z|\n      |      1|         B|     18|         S|     35|         j|     52|         0|\n      |      2|         C|     19|         T|     36|         k|     53|         1|\n      |      3|         D|     20|         U|     37|         l|     54|         2|\n      |      4|         E|     21|         V|     38|         m|     55|         3|\n      |      5|         F|     22|         W|     39|         n|     56|         4|\n      |      6|         G|     23|         X|     40|         o|     57|         5|\n      |      7|         H|     24|         Y|     41|         p|     58|         6|\n      |      8|         I|     25|         Z|     42|         q|     59|         7|\n      |      9|         J|     26|         a|     43|         r|     60|         8|\n      |     10|         K|     27|         b|     44|         s|     61|         9|\n      |     11|         L|     28|         c|     45|         t|     62|         +|\n      |     12|         M|     29|         d|     46|         u|     63|         /|\n      |     13|         N|     30|         e|     47|         v|       |          |\n      |     14|         O|     31|         f|     48|         w|  (pad)|         =|\n      |     15|         P|     32|         g|     49|         x|       |          |\n      |     16|         Q|     33|         h|     50|         y|       |          |\n\n  ## Base 64 (URL and filename safe) alphabet\n\n      | Value | Encoding | Value | Encoding | Value | Encoding | Value | Encoding |\n      |------:|---------:|------:|---------:|------:|---------:|------:|---------:|\n      |      0|         A|     17|         R|     34|         i|     51|         z|\n      |      1|         B|     18|         S|     35|         j|     52|         0|\n      |      2|         C|     19|         T|     36|         k|     53|         1|\n      |      3|         D|     20|         U|     37|         l|     54|         2|\n      |      4|         E|     21|         V|     38|         m|     55|         3|\n      |      5|         F|     22|         W|     39|         n|     56|         4|\n      |      6|         G|     23|         X|     40|         o|     57|         5|\n      |      7|         H|     24|         Y|     41|         p|     58|         6|\n      |      8|         I|     25|         Z|     42|         q|     59|         7|\n      |      9|         J|     26|         a|     43|         r|     60|         8|\n      |     10|         K|     27|         b|     44|         s|     61|         9|\n      |     11|         L|     28|         c|     45|         t|     62|         -|\n      |     12|         M|     29|         d|     46|         u|     63|         _|\n      |     13|         N|     30|         e|     47|         v|       |          |\n      |     14|         O|     31|         f|     48|         w|  (pad)|         =|\n      |     15|         P|     32|         g|     49|         x|       |          |\n      |     16|         Q|     33|         h|     50|         y|       |          |\n\n  ",
    encode16 = {
      description = "encode16(binary, Keyword.t) :: binary\nencode16(data, opts \\\\ []) when is_binary(data)\n\n  Encodes a binary string into a base 16 encoded string.\n\n  ## Options\n\n  The accepted options are:\n\n    * `:case` - specifies the character case to use when encoding\n\n  The values for `:case` can be:\n\n    * `:upper` - uses upper case characters (default)\n    * `:lower` - uses lower case characters\n\n  ## Examples\n\n      iex> Base.encode16(\"foobar\")\n      \"666F6F626172\"\n\n      iex> Base.encode16(\"foobar\", case: :lower)\n      \"666f6f626172\"\n\n  "
    },
    encode32 = {
      description = "encode32(binary, Keyword.t) :: binary\nencode32(data, opts \\\\ []) when is_binary(data)\n\n  Encodes a binary string into a base 32 encoded string.\n\n  ## Options\n\n  The accepted options are:\n\n    * `:case` - specifies the character case to use when encoding\n    * `:padding` - specifies whether to apply padding\n\n  The values for `:case` can be:\n\n    * `:upper` - uses upper case characters (default)\n    * `:lower` - uses lower case characters\n\n  The values for `:padding` can be:\n\n    * `true` - pad the output string to the nearest multiple of 8 (default)\n    * `false` - omit padding from the output string\n\n  ## Examples\n\n      iex> Base.encode32(\"foobar\")\n      \"MZXW6YTBOI======\"\n\n      iex> Base.encode32(\"foobar\", case: :lower)\n      \"mzxw6ytboi======\"\n\n      iex> Base.encode32(\"foobar\", padding: false)\n      \"MZXW6YTBOI\"\n\n  "
    },
    encode64 = {
      description = "encode64(binary, Keyword.t) :: binary\nencode64(data, opts \\\\ []) when is_binary(data)\n\n  Encodes a binary string into a base 64 encoded string.\n\n  Accepts `padding: false` option which will omit padding from\n  the output string.\n\n  ## Examples\n\n      iex> Base.encode64(\"foobar\")\n      \"Zm9vYmFy\"\n\n      iex> Base.encode64(\"foob\")\n      \"Zm9vYg==\"\n\n      iex> Base.encode64(\"foob\", padding: false)\n      \"Zm9vYg\"\n\n  "
    },
    hex_decode32 = {
      description = "hex_decode32(binary, Keyword.t) :: {:ok, binary} | :error\nhex_decode32(string, opts \\\\ [])\n\n  Decodes a base 32 encoded string with extended hexadecimal alphabet\n  into a binary string.\n\n  ## Options\n\n  The accepted options are:\n\n    * `:case` - specifies the character case to accept when decoding\n    * `:padding` - specifies whether to require padding\n\n  The values for `:case` can be:\n\n    * `:upper` - only allows upper case characters (default)\n    * `:lower` - only allows lower case characters\n    * `:mixed` - allows mixed case characters\n\n  The values for `:padding` can be:\n\n    * `true` - requires the input string to be padded to the nearest multiple of 8 (default)\n    * `false` - ignores padding from the input string\n\n  ## Examples\n\n      iex> Base.hex_decode32(\"CPNMUOJ1E8======\")\n      {:ok, \"foobar\"}\n\n      iex> Base.hex_decode32(\"cpnmuoj1e8======\", case: :lower)\n      {:ok, \"foobar\"}\n\n      iex> Base.hex_decode32(\"cpnMuOJ1E8======\", case: :mixed)\n      {:ok, \"foobar\"}\n\n      iex> Base.hex_decode32(\"CPNMUOJ1E8\", padding: false)\n      {:ok, \"foobar\"}\n\n  "
    },
    ["hex_decode32!"] = {
      description = "hex_decode32!(binary, Keyword.t) :: binary\nhex_decode32!(string, opts \\\\ []) when is_binary(string)\n\n  Decodes a base 32 encoded string with extended hexadecimal alphabet\n  into a binary string.\n\n  An `ArgumentError` exception is raised if the padding is incorrect or\n  a non-alphabet character is present in the string.\n\n  ## Options\n\n  The accepted options are:\n\n    * `:case` - specifies the character case to accept when decoding\n    * `:padding` - specifies whether to require padding\n\n  The values for `:case` can be:\n\n    * `:upper` - only allows upper case characters (default)\n    * `:lower` - only allows lower case characters\n    * `:mixed` - allows mixed case characters\n\n  The values for `:padding` can be:\n\n    * `true` - requires the input string to be padded to the nearest multiple of 8 (default)\n    * `false` - ignores padding from the input string\n\n  ## Examples\n\n      iex> Base.hex_decode32!(\"CPNMUOJ1E8======\")\n      \"foobar\"\n\n      iex> Base.hex_decode32!(\"cpnmuoj1e8======\", case: :lower)\n      \"foobar\"\n\n      iex> Base.hex_decode32!(\"cpnMuOJ1E8======\", case: :mixed)\n      \"foobar\"\n\n      iex> Base.hex_decode32!(\"CPNMUOJ1E8\", padding: false)\n      \"foobar\"\n\n  "
    },
    hex_encode32 = {
      description = "hex_encode32(binary, Keyword.t) :: binary\nhex_encode32(data, opts \\\\ []) when is_binary(data)\n\n  Encodes a binary string into a base 32 encoded string with an\n  extended hexadecimal alphabet.\n\n  ## Options\n\n  The accepted options are:\n\n    * `:case` - specifies the character case to use when encoding\n    * `:padding` - specifies whether to apply padding\n\n  The values for `:case` can be:\n\n    * `:upper` - uses upper case characters (default)\n    * `:lower` - uses lower case characters\n\n  The values for `:padding` can be:\n\n    * `true` - pad the output string to the nearest multiple of 8 (default)\n    * `false` - omit padding from the output string\n\n  ## Examples\n\n      iex> Base.hex_encode32(\"foobar\")\n      \"CPNMUOJ1E8======\"\n\n      iex> Base.hex_encode32(\"foobar\", case: :lower)\n      \"cpnmuoj1e8======\"\n\n      iex> Base.hex_encode32(\"foobar\", padding: false)\n      \"CPNMUOJ1E8\"\n\n  "
    },
    url_decode64 = {
      description = "url_decode64(binary, Keyword.t) :: {:ok, binary} | :error\nurl_decode64(string, opts \\\\ []) when is_binary(string)\n\n  Decodes a base 64 encoded string with URL and filename safe alphabet\n  into a binary string.\n\n  Accepts `ignore: :whitespace` option which will ignore all the\n  whitespace characters in the input string.\n\n  Accepts `padding: false` option which will ignore padding from\n  the input string.\n\n  ## Examples\n\n      iex> Base.url_decode64(\"_3_-_A==\")\n      {:ok, <<255, 127, 254, 252>>}\n\n      iex> Base.url_decode64(\"_3_-_A==\\\\n\", ignore: :whitespace)\n      {:ok, <<255, 127, 254, 252>>}\n\n      iex> Base.url_decode64(\"_3_-_A\", padding: false)\n      {:ok, <<255, 127, 254, 252>>}\n\n  "
    },
    ["url_decode64!"] = {
      description = "url_decode64!(binary, Keyword.t) :: binary\nurl_decode64!(string, opts \\\\ []) when is_binary(string)\n\n  Decodes a base 64 encoded string with URL and filename safe alphabet\n  into a binary string.\n\n  Accepts `ignore: :whitespace` option which will ignore all the\n  whitespace characters in the input string.\n\n  Accepts `padding: false` option which will ignore padding from\n  the input string.\n\n  An `ArgumentError` exception is raised if the padding is incorrect or\n  a non-alphabet character is present in the string.\n\n  ## Examples\n\n      iex> Base.url_decode64!(\"_3_-_A==\")\n      <<255, 127, 254, 252>>\n\n      iex> Base.url_decode64!(\"_3_-_A==\\\\n\", ignore: :whitespace)\n      <<255, 127, 254, 252>>\n\n      iex> Base.url_decode64!(\"_3_-_A\", padding: false)\n      <<255, 127, 254, 252>>\n\n  "
    },
    url_encode64 = {
      description = "url_encode64(binary, Keyword.t) :: binary\nurl_encode64(data, opts \\\\ []) when is_binary(data)\n\n  Encodes a binary string into a base 64 encoded string with URL and filename\n  safe alphabet.\n\n  Accepts `padding: false` option which will omit padding from\n  the output string.\n\n  ## Examples\n\n      iex> Base.url_encode64(<<255, 127, 254, 252>>)\n      \"_3_-_A==\"\n\n      iex> Base.url_encode64(<<255, 127, 254, 252>>, padding: false)\n      \"_3_-_A\"\n\n  "
    }
  },
  Behaviour = {
    __behaviour__ = {
      description = "__behaviour__(:docs)\n__behaviour__(:callbacks)\nfalse"
    },
    description = "\n  This module has been deprecated.\n\n  Instead of `defcallback/1` and `defmacrocallback/1`, the `@callback` and\n  `@macrocallback` module attributes can be used (respectively). See the\n  documentation for `Module` for more information on these attributes.\n\n  Instead of `MyModule.__behaviour__(:callbacks)`,\n  `MyModule.behaviour_info(:callbacks)` can be used.\n  "
  },
  Bitwise = {
    description = "\n  A set of macros that perform calculations on bits.\n\n  The macros in this module come in two flavors: named or\n  operators. For example:\n\n      iex> use Bitwise\n      iex> bnot 1   # named\n      -2\n      iex> 1 &&& 1  # operator\n      1\n\n  If you prefer to use only operators or skip them, you can\n  pass the following options:\n\n    * `:only_operators` - includes only operators\n    * `:skip_operators` - skips operators\n\n  For example:\n\n      iex> use Bitwise, only_operators: true\n      iex> 1 &&& 1\n      1\n\n  When invoked with no options, `use Bitwise` is equivalent\n  to `import Bitwise`.\n\n  All bitwise macros can be used in guards:\n\n      iex> use Bitwise\n      iex> odd? = fn int when band(int, 1) == 1 -> true; _ -> false end\n      iex> odd?.(1)\n      true\n\n  "
  },
  CLI = {
    description = "false",
    main = {
      description = "main(argv)\n\n  This is the API invoked by Elixir boot process.\n  "
    },
    parse_argv = {
      description = "parse_argv(argv)\nfalse"
    },
    process_commands = {
      description = "process_commands(config)\nfalse"
    },
    run = {
      description = "run(fun, halt \\\\ true)\n\n  Runs the given function by catching any failure\n  and printing them to stdout. `at_exit` hooks are\n  also invoked before exiting.\n\n  This function is used by Elixir's CLI and also\n  by escripts generated by Elixir.\n  "
    }
  },
  Calendar = {
    ISO = {
      date = {
        description = "date(year, month, day) when is_integer(year) and is_integer(month) and is_integer(day)\nfalse"
      },
      date_to_iso8601 = {
        description = "date_to_iso8601(year, month, day)\nfalse"
      },
      date_to_string = {
        description = "date_to_string(year, month, day)\n\n  Converts the given date into a string.\n  "
      },
      datetime_to_iso8601 = {
        description = "datetime_to_iso8601(year, month, day, hour, minute, second, microsecond,\nfalse"
      },
      datetime_to_string = {
        description = "datetime_to_string(year, month, day, hour, minute, second, microsecond,\n\n  Convers the datetime (with time zone) into a string.\n  "
      },
      day = {
        description = "day :: 1..31\n"
      },
      day_of_week = {
        description = "day_of_week(year, month, day) :: 1..7\nday_of_week(year, month, day)\n\n  Calculates the day of the week from the given `year`, `month`, and `day`.\n\n  It is an integer from 1 to 7, where 1 is Monday and 7 is Sunday.\n\n  ## Examples\n\n      iex> Calendar.ISO.day_of_week(2016, 10, 31)\n      1\n      iex> Calendar.ISO.day_of_week(2016, 11, 01)\n      2\n      iex> Calendar.ISO.day_of_week(2016, 11, 02)\n      3\n      iex> Calendar.ISO.day_of_week(2016, 11, 03)\n      4\n      iex> Calendar.ISO.day_of_week(2016, 11, 04)\n      5\n      iex> Calendar.ISO.day_of_week(2016, 11, 05)\n      6\n      iex> Calendar.ISO.day_of_week(2016, 11, 06)\n      7\n  "
      },
      days_in_month = {
        description = "days_in_month(_, month) when month in 1..12\ndays_in_month(_, month) when month in [4, 6, 9, 11]\ndays_in_month(year, 2)\ndays_in_month(year, month) :: 28..31\ndays_in_month(year, month)\n\n  Returns how many days there are in the given year-month.\n\n  ## Examples\n\n      iex> Calendar.ISO.days_in_month(1900, 1)\n      31\n      iex> Calendar.ISO.days_in_month(1900, 2)\n      28\n      iex> Calendar.ISO.days_in_month(2000, 2)\n      29\n      iex> Calendar.ISO.days_in_month(2001, 2)\n      28\n      iex> Calendar.ISO.days_in_month(2004, 2)\n      29\n      iex> Calendar.ISO.days_in_month(2004, 4)\n      30\n\n  "
      },
      description = "\n  A calendar implementation that follows to ISO8601.\n\n  This calendar implements the proleptic Gregorian calendar and\n  is therefore compatible with the calendar used in most countries\n  today. The proleptic means the Gregorian rules for leap years are\n  applied for all time, consequently the dates give different results\n  before the year 1583 from when the Gregorian calendar was adopted.\n  ",
      from_unix = {
        description = "from_unix(integer, unit) when is_integer(integer)\nfalse"
      },
      ["leap_year?"] = {
        description = "leap_year?(year) :: boolean()\nleap_year?(year) when is_integer(year) and year >= 0\n\n  Returns if the given year is a leap year.\n\n  ## Examples\n\n      iex> Calendar.ISO.leap_year?(2000)\n      true\n      iex> Calendar.ISO.leap_year?(2001)\n      false\n      iex> Calendar.ISO.leap_year?(2004)\n      true\n      iex> Calendar.ISO.leap_year?(1900)\n      false\n\n  "
      },
      month = {
        description = "month :: 1..12\n"
      },
      naive_datetime_to_iso8601 = {
        description = "naive_datetime_to_iso8601(year, month, day, hour, minute, second, microsecond)\nfalse"
      },
      naive_datetime_to_string = {
        description = "naive_datetime_to_string(year, month, day, hour, minute, second, microsecond)\n\n  Converts the datetime (without time zone) into a string.\n  "
      },
      parse_microsecond = {
        description = "parse_microsecond(rest)\nparse_microsecond(\".\" <> rest)\nfalse"
      },
      parse_offset = {
        description = "parse_offset(_),\nparse_offset(<<?-, hour::2-bytes, ?:, min::2-bytes, rest::binary>>),\nparse_offset(<<?+, hour::2-bytes, ?:, min::2-bytes, rest::binary>>),\nparse_offset(\"-00:00\"),\nparse_offset(\"Z\"),\nparse_offset(\"\"),\nfalse"
      },
      time_to_iso8601 = {
        description = "time_to_iso8601(hour, minute, second, microsecond)\nfalse"
      },
      time_to_string = {
        description = "time_to_string(hour, minute, second, {microsecond, precision})\ntime_to_string(hour, minute, second, {_, 0})\nfalse"
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
      description = "message(exception)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    }
  },
  Code = {
    LoadError = {
      exception = {
        description = "exception(opts)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
      }
    },
    append_path = {
      description = "append_path(path)\n\n  Appends a path to the end of the Erlang VM code path list.\n\n  This is the list of directories the Erlang VM uses for\n  finding module code.\n\n  The path is expanded with `Path.expand/1` before being appended.\n  If this path does not exist, an error is returned.\n\n  ## Examples\n\n      Code.append_path(\".\") #=> true\n\n      Code.append_path(\"/does_not_exist\") #=> {:error, :bad_directory}\n\n  "
    },
    available_compiler_options = {
      description = "available_compiler_options\n\n  Returns a list with the available compiler options.\n\n  See `Code.compiler_options/1` for more info.\n\n  ## Examples\n\n      iex> Code.available_compiler_options\n      [:docs, :debug_info, :ignore_module_conflict, :relative_paths, :warnings_as_errors]\n\n  "
    },
    compile_quoted = {
      description = "compile_quoted(quoted, file \\\\ \"nofile\") when is_binary(file)\n\n  Compiles the quoted expression.\n\n  Returns a list of tuples where the first element is the module name and\n  the second one is its byte code (as a binary).\n  "
    },
    compile_string = {
      description = "compile_string(string, file \\\\ \"nofile\") when is_binary(file)\n\n  Compiles the given string.\n\n  Returns a list of tuples where the first element is the module name\n  and the second one is its byte code (as a binary).\n\n  For compiling many files at once, check `Kernel.ParallelCompiler.files/2`.\n  "
    },
    compiler_options = {
      description = "compiler_options(opts)\ncompiler_options\n\n  Gets the compilation options from the code server.\n\n  Check `compiler_options/1` for more information.\n\n  ## Examples\n\n      Code.compiler_options\n      #=> %{debug_info: true, docs: true,\n            warnings_as_errors: false, ignore_module_conflict: false}\n\n  "
    },
    delete_path = {
      description = "delete_path(path)\n\n  Deletes a path from the Erlang VM code path list. This is the list of\n  directories the Erlang VM uses for finding module code.\n\n  The path is expanded with `Path.expand/1` before being deleted. If the\n  path does not exist it returns `false`.\n\n  ## Examples\n\n      Code.prepend_path(\".\")\n      Code.delete_path(\".\") #=> true\n\n      Code.delete_path(\"/does_not_exist\") #=> false\n\n  "
    },
    description = "\n  Utilities for managing code compilation, code evaluation and code loading.\n\n  This module complements Erlang's [`:code` module](http://www.erlang.org/doc/man/code.html)\n  to add behaviour which is specific to Elixir. Almost all of the functions in this module\n  have global side effects on the behaviour of Elixir.\n  ",
    ensure_compiled = {
      description = "ensure_compiled(module) ::\nensure_compiled(module) when is_atom(module)\n\n  Ensures the given module is compiled and loaded.\n\n  If the module is already loaded, it works as no-op. If the module was\n  not loaded yet, it checks if it needs to be compiled first and then\n  tries to load it.\n\n  If it succeeds loading the module, it returns `{:module, module}`.\n  If not, returns `{:error, reason}` with the error reason.\n\n  Check `ensure_loaded/1` for more information on module loading\n  and when to use `ensure_loaded/1` or `ensure_compiled/1`.\n  "
    },
    ["ensure_compiled?"] = {
      description = "ensure_compiled?(module) :: boolean\nensure_compiled?(module) when is_atom(module)\n\n  Ensures the given module is compiled and loaded.\n\n  Similar to `ensure_compiled/1`, but returns `true` if the module\n  is already loaded or was successfully loaded and compiled.\n  Returns `false` otherwise.\n  "
    },
    ensure_loaded = {
      description = "ensure_loaded(module) ::\nensure_loaded(module) when is_atom(module)\n\n  Ensures the given module is loaded.\n\n  If the module is already loaded, this works as no-op. If the module\n  was not yet loaded, it tries to load it.\n\n  If it succeeds loading the module, it returns `{:module, module}`.\n  If not, returns `{:error, reason}` with the error reason.\n\n  ## Code loading on the Erlang VM\n\n  Erlang has two modes to load code: interactive and embedded.\n\n  By default, the Erlang VM runs in interactive mode, where modules\n  are loaded as needed. In embedded mode the opposite happens, as all\n  modules need to be loaded upfront or explicitly.\n\n  Therefore, this function is used to check if a module is loaded\n  before using it and allows one to react accordingly. For example, the `URI`\n  module uses this function to check if a specific parser exists for a given\n  URI scheme.\n\n  ## Code.ensure_compiled/1\n\n  Elixir also contains an `ensure_compiled/1` function that is a\n  superset of `ensure_loaded/1`.\n\n  Since Elixir's compilation happens in parallel, in some situations\n  you may need to use a module that was not yet compiled, therefore\n  it can't even be loaded.\n\n  `ensure_compiled/1` halts the current process until the\n  module we are depending on is available.\n\n  In most cases, `ensure_loaded/1` is enough. `ensure_compiled/1`\n  must be used in rare cases, usually involving macros that need to\n  invoke a module for callback information.\n\n  ## Examples\n\n      iex> Code.ensure_loaded(Atom)\n      {:module, Atom}\n\n      iex> Code.ensure_loaded(DoesNotExist)\n      {:error, :nofile}\n\n  "
    },
    ["ensure_loaded?"] = {
      description = "ensure_loaded?(module) when is_atom(module)\n\n  Ensures the given module is loaded.\n\n  Similar to `ensure_loaded/1`, but returns `true` if the module\n  is already loaded or was successfully loaded. Returns `false`\n  otherwise.\n\n  ## Examples\n\n      iex> Code.ensure_loaded?(Atom)\n      true\n\n  "
    },
    eval_file = {
      description = "eval_file(file, relative_to \\\\ nil)\n\n  Evals the given file.\n\n  Accepts `relative_to` as an argument to tell where the file is located.\n\n  While `load_file` loads a file and returns the loaded modules and their\n  byte code, `eval_file` simply evaluates the file contents and returns the\n  evaluation result and its bindings.\n  "
    },
    eval_quoted = {
      description = "eval_quoted(quoted, binding, opts) when is_list(opts)\neval_quoted(quoted, binding, %Macro.Env{} = env)\neval_quoted(quoted, binding \\\\ [], opts \\\\ [])\n\n  Evaluates the quoted contents.\n\n  **Warning**: Calling this function inside a macro is considered bad\n  practice as it will attempt to evaluate runtime values at compile time.\n  Macro arguments are typically transformed by unquoting them into the\n  returned quoted expressions (instead of evaluated).\n\n  See `eval_string/3` for a description of bindings and options.\n\n  ## Examples\n\n      iex> contents = quote(do: var!(a) + var!(b))\n      iex> Code.eval_quoted(contents, [a: 1, b: 2], file: __ENV__.file, line: __ENV__.line)\n      {3, [a: 1, b: 2]}\n\n  For convenience, you can pass `__ENV__/0` as the `opts` argument and\n  all options will be automatically extracted from the current environment:\n\n      iex> contents = quote(do: var!(a) + var!(b))\n      iex> Code.eval_quoted(contents, [a: 1, b: 2], __ENV__)\n      {3, [a: 1, b: 2]}\n\n  "
    },
    eval_string = {
      description = "eval_string(string, binding, opts) when is_list(opts)\neval_string(string, binding, %Macro.Env{} = env)\neval_string(string, binding \\\\ [], opts \\\\ [])\n\n  Evaluates the contents given by `string`.\n\n  The `binding` argument is a keyword list of variable bindings.\n  The `opts` argument is a keyword list of environment options.\n\n  ## Options\n\n  Options can be:\n\n    * `:file` - the file to be considered in the evaluation\n    * `:line` - the line on which the script starts\n\n  Additionally, the following scope values can be configured:\n\n    * `:aliases` - a list of tuples with the alias and its target\n\n    * `:requires` - a list of modules required\n\n    * `:functions` - a list of tuples where the first element is a module\n      and the second a list of imported function names and arity; the list\n      of function names and arity must be sorted\n\n    * `:macros` - a list of tuples where the first element is a module\n      and the second a list of imported macro names and arity; the list\n      of function names and arity must be sorted\n\n  Notice that setting any of the values above overrides Elixir's default\n  values. For example, setting `:requires` to `[]`, will no longer\n  automatically require the `Kernel` module; in the same way setting\n  `:macros` will no longer auto-import `Kernel` macros like `if/2`, `case/2`,\n  etc.\n\n  Returns a tuple of the form `{value, binding}`,\n  where `value` is the value returned from evaluating `string`.\n  If an error occurs while evaluating `string` an exception will be raised.\n\n  `binding` is a keyword list with the value of all variable bindings\n  after evaluating `string`. The binding key is usually an atom, but it\n  may be a tuple for variables defined in a different context.\n\n  ## Examples\n\n      iex> Code.eval_string(\"a + b\", [a: 1, b: 2], file: __ENV__.file, line: __ENV__.line)\n      {3, [a: 1, b: 2]}\n\n      iex> Code.eval_string(\"c = a + b\", [a: 1, b: 2], __ENV__)\n      {3, [a: 1, b: 2, c: 3]}\n\n      iex> Code.eval_string(\"a = a + b\", [a: 1, b: 2])\n      {3, [a: 3, b: 2]}\n\n  For convenience, you can pass `__ENV__/0` as the `opts` argument and\n  all imports, requires and aliases defined in the current environment\n  will be automatically carried over:\n\n      iex> Code.eval_string(\"a + b\", [a: 1, b: 2], __ENV__)\n      {3, [a: 1, b: 2]}\n\n  "
    },
    get_docs = {
      description = "get_docs(binpath, kind) when is_binary(binpath) and kind in @doc_kinds\nget_docs(module, kind) when is_atom(module) and kind in @doc_kinds\n\n  Returns the docs for the given module.\n\n  When given a module name, it finds its BEAM code and reads the docs from it.\n\n  When given a path to a .beam file, it will load the docs directly from that\n  file.\n\n  The return value depends on the `kind` value:\n\n    * `:docs` - list of all docstrings attached to functions and macros\n      using the `@doc` attribute\n\n    * `:moduledoc` - tuple `{<line>, <doc>}` where `line` is the line on\n      which module definition starts and `doc` is the string\n      attached to the module using the `@moduledoc` attribute\n\n    * `:callback_docs` - list of all docstrings attached to\n      `@callbacks` using the `@doc` attribute\n\n    * `:type_docs` - list of all docstrings attached to\n      `@type` callbacks using the `@typedoc` attribute\n\n    * `:all` - a keyword list with `:docs` and `:moduledoc`, `:callback_docs`,\n      and `:type_docs`.\n\n  If the module cannot be found, it returns `nil`.\n\n  ## Examples\n\n      # Get the module documentation\n      iex> {_line, text} = Code.get_docs(Atom, :moduledoc)\n      iex> String.split(text, \"\\n\") |> Enum.at(0)\n      \"Convenience functions for working with atoms.\"\n\n      # Module doesn't exist\n      iex> Code.get_docs(ModuleNotGood, :all)\n      nil\n\n  "
    },
    load_file = {
      description = "load_file(file, relative_to \\\\ nil) when is_binary(file)\n\n  Loads the given file.\n\n  Accepts `relative_to` as an argument to tell where the file is located.\n  If the file was already required/loaded, loads it again.\n\n  It returns a list of tuples `{ModuleName, <<byte_code>>}`, one tuple for\n  each module defined in the file.\n\n  Notice that if `load_file` is invoked by different processes concurrently,\n  the target file will be loaded concurrently many times. Check `require_file/2`\n  if you don't want a file to be loaded concurrently.\n\n  ## Examples\n\n      Code.load_file(\"eex_test.exs\", \"../eex/test\") |> List.first\n      #=> {EExTest.Compiled, <<70, 79, 82, 49, ...>>}\n\n  "
    },
    loaded_files = {
      description = "loaded_files\n\n  Lists all loaded files.\n\n  ## Examples\n\n      Code.require_file(\"../eex/test/eex_test.exs\")\n      List.first(Code.loaded_files) =~ \"eex_test.exs\" #=> true\n\n  "
    },
    prepend_path = {
      description = "prepend_path(path)\n\n  Prepends a path to the beginning of the Erlang VM code path list.\n\n  This is the list of directories the Erlang VM uses for finding\n  module code.\n\n  The path is expanded with `Path.expand/1` before being prepended.\n  If this path does not exist, an error is returned.\n\n  ## Examples\n\n      Code.prepend_path(\".\") #=> true\n\n      Code.prepend_path(\"/does_not_exist\") #=> {:error, :bad_directory}\n\n  "
    },
    require_file = {
      description = "require_file(file, relative_to \\\\ nil) when is_binary(file)\n\n  Requires the given `file`.\n\n  Accepts `relative_to` as an argument to tell where the file is located.\n  The return value is the same as that of `load_file/2`. If the file was already\n  required/loaded, doesn't do anything and returns `nil`.\n\n  Notice that if `require_file` is invoked by different processes concurrently,\n  the first process to invoke `require_file` acquires a lock and the remaining\n  ones will block until the file is available. I.e. if `require_file` is called\n  N times with a given file, it will be loaded only once. The first process to\n  call `require_file` will get the list of loaded modules, others will get `nil`.\n\n  Check `load_file/2` if you want a file to be loaded multiple times. See also\n  `unload_files/1`\n\n  ## Examples\n\n  If the code is already loaded, it returns `nil`:\n\n      Code.require_file(\"eex_test.exs\", \"../eex/test\") #=> nil\n\n  If the code is not loaded yet, it returns the same as `load_file/2`:\n\n      Code.require_file(\"eex_test.exs\", \"../eex/test\") |> List.first\n      #=> {EExTest.Compiled, <<70, 79, 82, 49, ...>>}\n\n  "
    },
    string_to_quoted = {
      description = "string_to_quoted(string, opts \\\\ []) when is_list(opts)\n\n  Converts the given string to its quoted form.\n\n  Returns `{:ok, quoted_form}`\n  if it succeeds, `{:error, {line, error, token}}` otherwise.\n\n  ## Options\n\n    * `:file` - the filename to be used in stacktraces\n      and the file reported in the `__ENV__/0` macro\n\n    * `:line` - the line reported in the `__ENV__/0` macro\n\n    * `:existing_atoms_only` - when `true`, raises an error\n      when non-existing atoms are found by the tokenizer\n\n  ## Macro.to_string/2\n\n  The opposite of converting a string to its quoted form is\n  `Macro.to_string/2`, which converts a quoted form to a string/binary\n  representation.\n  "
    },
    ["string_to_quoted!"] = {
      description = "string_to_quoted!(string, opts \\\\ []) when is_list(opts)\n\n  Converts the given string to its quoted form.\n\n  It returns the ast if it succeeds,\n  raises an exception otherwise. The exception is a `TokenMissingError`\n  in case a token is missing (usually because the expression is incomplete),\n  `SyntaxError` otherwise.\n\n  Check `string_to_quoted/2` for options information.\n  "
    },
    unload_files = {
      description = "unload_files(files)\n\n  Removes files from the loaded files list.\n\n  The modules defined in the file are not removed;\n  calling this function only removes them from the list,\n  allowing them to be required again.\n\n  ## Examples\n\n      # Load EEx test code, unload file, check for functions still available\n      Code.load_file(\"../eex/test/eex_test.exs\")\n      Code.unload_files(Code.loaded_files)\n      function_exported?(EExTest.Compiled, :before_compile, 0) #=> true\n\n  "
    }
  },
  Collectable = {
    command = {
      description = "command :: {:cont, term} | :done | :halt\n"
    },
    description = "\n  A protocol to traverse data structures.\n\n  The `Enum.into/2` function uses this protocol to insert an\n  enumerable into a collection:\n\n      iex> Enum.into([a: 1, b: 2], %{})\n      %{a: 1, b: 2}\n\n  ## Why Collectable?\n\n  The `Enumerable` protocol is useful to take values out of a collection.\n  In order to support a wide range of values, the functions provided by\n  the `Enumerable` protocol do not keep shape. For example, passing a\n  map to `Enum.map/2` always returns a list.\n\n  This design is intentional. `Enumerable` was designed to support infinite\n  collections, resources and other structures with fixed shape. For example,\n  it doesn't make sense to insert values into a range, as it has a fixed\n  shape where just the range limits are stored.\n\n  The `Collectable` module was designed to fill the gap left by the\n  `Enumerable` protocol. `into/1` can be seen as the opposite of\n  `Enumerable.reduce/3`. If `Enumerable` is about taking values out,\n  `Collectable.into/1` is about collecting those values into a structure.\n\n  ## Examples\n\n  To show how to manually use the `Collectable` protocol, let's play with its\n  implementation for `MapSet`.\n\n      iex> {initial_acc, collector_fun} = Collectable.into(MapSet.new())\n      iex> updated_acc = Enum.reduce([1, 2, 3], initial_acc, fn elem, acc ->\n      ...>   collector_fun.(acc, {:cont, elem})\n      ...> end)\n      iex> collector_fun.(updated_acc, :done)\n      #MapSet<[1, 2, 3]>\n\n  To show how the protocol can be implemented, we can take again a look at the\n  implementation for `MapSet`. In this implementation \"collecting\" elements\n  simply means inserting them in the set through `MapSet.put/2`.\n\n      defimpl Collectable do\n        def into(original) do\n          collector_fun = fn\n            set, {:cont, elem} -> MapSet.put(set, elem)\n            set, :done -> set\n            _set, :halt -> :ok\n          end\n\n          {original, collector_fun}\n        end\n      end\n\n  ",
    into = {
      description = "into(original)\ninto(original)\ninto(original)\ninto(t) :: {term, (term, command -> t | term)}\ninto(collectable)\n\n  Returns an initial accumulator and a \"collector\" function.\n\n  The returned function receives a term and a command and injects the term into\n  the collectable on every `{:cont, term}` command.\n\n  `:done` is passed as a command when no further values will be injected. This\n  is useful when there's a need to close resources or normalizing values. A\n  collectable must be returned when the command is `:done`.\n\n  If injection is suddenly interrupted, `:halt` is passed and the function\n  can return any value as it won't be used.\n\n  For examples on how to use the `Collectable` protocol and `into/1` see the\n  module documentation.\n  "
    }
  },
  CompileError = {
    compile = {
      description = "compile(source, options) when is_list(options)\ncompile(source, options) when is_binary(options)\ncompile(binary, binary | [term]) :: {:ok, t} | {:error, any}\ncompile(source, options \\\\ \"\")\n\n  Compiles the regular expression.\n\n  The given options can either be a binary with the characters\n  representing the same regex options given to the `~r` sigil,\n  or a list of options, as expected by the Erlang's [`:re` module](http://www.erlang.org/doc/man/re.html).\n\n  It returns `{:ok, regex}` in case of success,\n  `{:error, reason}` otherwise.\n\n  ## Examples\n\n      iex> Regex.compile(\"foo\")\n      {:ok, ~r\"foo\"}\n\n      iex> Regex.compile(\"*foo\")\n      {:error, {'nothing to repeat', 0}}\n\n  "
    },
    ["compile!"] = {
      description = "compile!(binary, binary | [term]) :: t\ncompile!(source, options \\\\ \"\")\n\n  Compiles the regular expression according to the given options.\n  Fails with `Regex.CompileError` if the regex cannot be compiled.\n  "
    },
    escape = {
      description = "escape(String.t) :: String.t\nescape(string) when is_binary(string)\n\n  Escapes a string to be literally matched in a regex.\n\n  ## Examples\n\n      iex> Regex.escape(\".\")\n      \"\\\\.\"\n\n      iex> Regex.escape(\"\\\\what if\")\n      \"\\\\\\\\what\\\\ if\"\n\n  "
    },
    ["match?"] = {
      description = "match?(t, String.t) :: boolean\nmatch?(%Regex{re_pattern: compiled}, string) when is_binary(string)\n\n  Returns a boolean indicating whether there was a match or not.\n\n  ## Examples\n\n      iex> Regex.match?(~r/foo/, \"foo\")\n      true\n\n      iex> Regex.match?(~r/foo/, \"bar\")\n      false\n\n  "
    },
    message = {
      description = "message(%{file: file, line: line, description: description})\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    },
    named_captures = {
      description = "named_captures(t, String.t, [term]) :: map | nil\nnamed_captures(regex, string, options \\\\ []) when is_binary(string)\n\n  Returns the given captures as a map or `nil` if no captures are\n  found. The option `:return` can be set to `:index` to get indexes\n  back.\n\n  ## Examples\n\n      iex> Regex.named_captures(~r/c(?<foo>d)/, \"abcd\")\n      %{\"foo\" => \"d\"}\n\n      iex> Regex.named_captures(~r/a(?<foo>b)c(?<bar>d)/, \"abcd\")\n      %{\"bar\" => \"d\", \"foo\" => \"b\"}\n\n      iex> Regex.named_captures(~r/a(?<foo>b)c(?<bar>d)/, \"efgh\")\n      nil\n\n  "
    },
    names = {
      description = "names(t) :: [String.t]\nnames(%Regex{re_pattern: re_pattern})\n\n  Returns a list of names in the regex.\n\n  ## Examples\n\n      iex> Regex.names(~r/(?<foo>bar)/)\n      [\"foo\"]\n\n  "
    },
    opts = {
      description = "opts(t) :: String.t\nopts(%Regex{opts: opts})\n\n  Returns the regex options as a string.\n\n  ## Examples\n\n      iex> Regex.opts(~r(foo)m)\n      \"m\"\n\n  "
    },
    re_pattern = {
      description = "re_pattern(t) :: term\nre_pattern(%Regex{re_pattern: compiled})\n\n  Returns the underlying `re_pattern` in the regular expression.\n  "
    },
    ["regex?"] = {
      description = "regex?(_)\nregex?(%Regex{})\nregex?(any) :: boolean\nregex?(term)\n\n  Returns `true` if the given `term` is a regex.\n  Otherwise returns `false`.\n\n  ## Examples\n\n      iex> Regex.regex?(~r/foo/)\n      true\n\n      iex> Regex.regex?(0)\n      false\n\n  "
    },
    replace = {
      description = "replace(regex, string, replacement, options)\nreplace(regex, string, replacement, options)\nreplace(t, String.t, String.t | (... -> String.t), [term]) :: String.t\nreplace(regex, string, replacement, options \\\\ [])\n\n  Receives a regex, a binary and a replacement, returns a new\n  binary where all matches are replaced by the replacement.\n\n  The replacement can be either a string or a function. The string\n  is used as a replacement for every match and it allows specific\n  captures to be accessed via `\\N` or `\\g{N}`, where `N` is the\n  capture. In case `\\0` is used, the whole match is inserted. Note\n  that in regexes the backslash needs to be escaped, hence in practice\n  you'll need to use `\\\\N` and `\\\\g{N}`.\n\n  When the replacement is a function, the function may have arity\n  N where each argument maps to a capture, with the first argument\n  being the whole match. If the function expects more arguments\n  than captures found, the remaining arguments will receive `\"\"`.\n\n  ## Options\n\n    * `:global` - when `false`, replaces only the first occurrence\n      (defaults to `true`)\n\n  ## Examples\n\n      iex> Regex.replace(~r/d/, \"abc\", \"d\")\n      \"abc\"\n\n      iex> Regex.replace(~r/b/, \"abc\", \"d\")\n      \"adc\"\n\n      iex> Regex.replace(~r/b/, \"abc\", \"[\\\\0]\")\n      \"a[b]c\"\n\n      iex> Regex.replace(~r/a(b|d)c/, \"abcadc\", \"[\\\\1]\")\n      \"[b][d]\"\n\n      iex> Regex.replace(~r/\\.(\\d)$/, \"500.5\", \".\\\\g{1}0\")\n      \"500.50\"\n\n      iex> Regex.replace(~r/a(b|d)c/, \"abcadc\", fn _, x -> \"[#{x}]\" end)\n      \"[b][d]\"\n\n      iex> Regex.replace(~r/a/, \"abcadc\", \"A\", global: false)\n      \"Abcadc\"\n\n  "
    },
    run = {
      description = "run(%Regex{re_pattern: compiled}, string, options) when is_binary(string)\nrun(t, binary, [term]) :: nil | [binary] | [{integer, integer}]\nrun(regex, string, options \\\\ [])\n\n  Runs the regular expression against the given string until the first match.\n  It returns a list with all captures or `nil` if no match occurred.\n\n  ## Options\n\n    * `:return`  - sets to `:index` to return indexes. Defaults to `:binary`.\n    * `:capture` - what to capture in the result. Check the moduledoc for `Regex`\n      to see the possible capture values.\n\n  ## Examples\n\n      iex> Regex.run(~r/c(d)/, \"abcd\")\n      [\"cd\", \"d\"]\n\n      iex> Regex.run(~r/e/, \"abcd\")\n      nil\n\n      iex> Regex.run(~r/c(d)/, \"abcd\", return: :index)\n      [{2, 2}, {3, 1}]\n\n  "
    },
    scan = {
      description = "scan(%Regex{re_pattern: compiled}, string, options) when is_binary(string)\nscan(t, String.t, [term]) :: [[String.t]]\nscan(regex, string, options \\\\ [])\n\n  Same as `run/3`, but scans the target several times collecting all\n  matches of the regular expression.\n\n  A list of lists is returned, where each entry in the primary list represents a\n  match and each entry in the secondary list represents the captured contents.\n\n  ## Options\n\n    * `:return`  - sets to `:index` to return indexes. Defaults to `:binary`.\n    * `:capture` - what to capture in the result. Check the moduledoc for `Regex`\n      to see the possible capture values.\n\n  ## Examples\n\n      iex> Regex.scan(~r/c(d|e)/, \"abcd abce\")\n      [[\"cd\", \"d\"], [\"ce\", \"e\"]]\n\n      iex> Regex.scan(~r/c(?:d|e)/, \"abcd abce\")\n      [[\"cd\"], [\"ce\"]]\n\n      iex> Regex.scan(~r/e/, \"abcd\")\n      []\n\n      iex> Regex.scan(~r/\\p{Sc}/u, \"$, £, and €\")\n      [[\"$\"], [\"£\"], [\"€\"]]\n\n  "
    },
    source = {
      description = "source(t) :: String.t\nsource(%Regex{source: source})\n\n  Returns the regex source as a binary.\n\n  ## Examples\n\n      iex> Regex.source(~r(foo))\n      \"foo\"\n\n  "
    },
    split = {
      description = "split(%Regex{re_pattern: compiled}, string, opts) when is_binary(string) and is_list(opts)\nsplit(%Regex{}, \"\", opts)\nsplit(t, String.t, [term]) :: [String.t]\nsplit(regex, string, options \\\\ [])\n\n  Splits the given target based on the given pattern and in the given number of\n  parts.\n\n  ## Options\n\n    * `:parts` - when specified, splits the string into the given number of\n      parts. If not specified, `:parts` defaults to `:infinity`, which will\n      split the string into the maximum number of parts possible based on the\n      given pattern.\n\n    * `:trim` - when `true`, removes empty strings (`\"\"`) from the result.\n\n    * `:on` - specifies which captures to split the string on, and in what\n      order. Defaults to `:first` which means captures inside the regex do not\n      affect the splitting process.\n\n    * `:include_captures` - when `true`, includes in the result the matches of\n      the regular expression. Defaults to `false`.\n\n  ## Examples\n\n      iex> Regex.split(~r{-}, \"a-b-c\")\n      [\"a\", \"b\", \"c\"]\n\n      iex> Regex.split(~r{-}, \"a-b-c\", [parts: 2])\n      [\"a\", \"b-c\"]\n\n      iex> Regex.split(~r{-}, \"abc\")\n      [\"abc\"]\n\n      iex> Regex.split(~r{}, \"abc\")\n      [\"a\", \"b\", \"c\", \"\"]\n\n      iex> Regex.split(~r{a(?<second>b)c}, \"abc\")\n      [\"\", \"\"]\n\n      iex> Regex.split(~r{a(?<second>b)c}, \"abc\", on: [:second])\n      [\"a\", \"c\"]\n\n      iex> Regex.split(~r{(x)}, \"Elixir\", include_captures: true)\n      [\"Eli\", \"x\", \"ir\"]\n\n      iex> Regex.split(~r{a(?<second>b)c}, \"abc\", on: [:second], include_captures: true)\n      [\"a\", \"b\", \"c\"]\n\n  "
    },
    unescape_map = {
      description = "unescape_map(_)\nunescape_map(?a)\nunescape_map(?v)\nunescape_map(?t)\nunescape_map(?r)\nunescape_map(?n)\nunescape_map(?f)\nfalse"
    }
  },
  CondClauseError = {
    message = {
      description = "message(_exception)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    }
  },
  Date = {
    compare = {
      description = "compare(Calendar.date, Calendar.date) :: :lt | :eq | :gt\ncompare(date1, date2)\n\n  Compares two `Date` structs.\n\n  Returns `:gt` if first date is later than the second\n  and `:lt` for vice versa. If the two dates are equal\n  `:eq` is returned.\n\n  ## Examples\n\n      iex> Date.compare(~D[2016-04-16], ~D[2016-04-28])\n      :lt\n\n  This function can also be used to compare across more\n  complex calendar types by considering only the date fields:\n\n      iex> Date.compare(~D[2016-04-16], ~N[2016-04-28 01:23:45])\n      :lt\n      iex> Date.compare(~D[2016-04-16], ~N[2016-04-16 01:23:45])\n      :eq\n      iex> Date.compare(~N[2016-04-16 12:34:56], ~N[2016-04-16 01:23:45])\n      :eq\n\n  "
    },
    day_of_week = {
      description = "day_of_week(%{calendar: calendar, year: year, month: month, day: day})\nday_of_week(Calendar.date) :: non_neg_integer()\nday_of_week(date)\n\n  Calculates the day of the week of a given `Date` struct.\n\n  Returns the day of the week as an integer. For the ISO 8601\n  calendar (the default), it is an integer from 1 to 7, where\n  1 is Monday and 7 is Sunday.\n\n  ## Examples\n\n      iex> Date.day_of_week(~D[2016-10-31])\n      1\n      iex> Date.day_of_week(~D[2016-11-01])\n      2\n      iex> Date.day_of_week(~N[2016-11-01 01:23:45])\n      2\n  "
    },
    days_in_month = {
      description = "days_in_month(%{calendar: calendar, year: year, month: month})\ndays_in_month(Calendar.date) :: Calendar.day\ndays_in_month(date)\n\n  Returns the number of days in the given date month.\n\n  ## Examples\n\n      iex> Date.days_in_month(~D[1900-01-13])\n      31\n      iex> Date.days_in_month(~D[1900-02-09])\n      28\n      iex> Date.days_in_month(~N[2000-02-20 01:23:45])\n      29\n\n  "
    },
    description = "\n  A Date struct and functions.\n\n  The Date struct contains the fields year, month, day and calendar.\n  New dates can be built with the `new/3` function or using the `~D`\n  sigil:\n\n      iex> ~D[2000-01-01]\n      ~D[2000-01-01]\n\n  Both `new/3` and sigil return a struct where the date fields can\n  be accessed directly:\n\n      iex> date = ~D[2000-01-01]\n      iex> date.year\n      2000\n      iex> date.month\n      1\n\n  The functions on this module work with the `Date` struct as well\n  as any struct that contains the same fields as the `Date` struct,\n  such as `NaiveDateTime` and `DateTime`. Such functions expect\n  `t:Calendar.date/0` in their typespecs (instead of `t:t/0`).\n\n  Remember, comparisons in Elixir using `==`, `>`, `<` and friends\n  are structural and based on the Date struct fields. For proper\n  comparison between dates, use the `compare/2` function.\n\n  Developers should avoid creating the Date struct directly and\n  instead rely on the functions provided by this module as well as\n  the ones in 3rd party calendar libraries.\n  ",
    from_erl = {
      description = "from_erl({year, month, day})\nfrom_erl(:calendar.date) :: {:ok, t} | {:error, atom}\nfrom_erl(tuple)\n\n  Converts an Erlang date tuple to a `Date` struct.\n\n  Attempting to convert an invalid ISO calendar date will produce an error tuple.\n\n  ## Examples\n\n      iex> Date.from_erl({2000, 1, 1})\n      {:ok, ~D[2000-01-01]}\n      iex> Date.from_erl({2000, 13, 1})\n      {:error, :invalid_date}\n  "
    },
    ["from_erl!"] = {
      description = "from_erl!(:calendar.date) :: t | no_return\nfrom_erl!(tuple)\n\n  Converts an Erlang date tuple but raises for invalid dates.\n\n  ## Examples\n\n      iex> Date.from_erl!({2000, 1, 1})\n      ~D[2000-01-01]\n      iex> Date.from_erl!({2000, 13, 1})\n      ** (ArgumentError) cannot convert {2000, 13, 1} to date, reason: :invalid_date\n  "
    },
    from_iso8601 = {
      description = "from_iso8601(<<_::binary>>)\nfrom_iso8601(<<year::4-bytes, ?-, month::2-bytes, ?-, day::2-bytes>>)\nfrom_iso8601(String.t) :: {:ok, t} | {:error, atom}\nfrom_iso8601(string)\n\n  Parses the extended \"Date and time of day\" format described by\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  Timezone offset may be included in the string but they will be\n  simply discarded as such information is not included in naive date\n  times.\n\n  Time representations with reduced accuracy are not supported.\n\n  ## Examples\n\n      iex> Date.from_iso8601(\"2015-01-23\")\n      {:ok, ~D[2015-01-23]}\n\n      iex> Date.from_iso8601(\"2015:01:23\")\n      {:error, :invalid_format}\n      iex> Date.from_iso8601(\"2015-01-32\")\n      {:error, :invalid_date}\n\n  "
    },
    ["from_iso8601!"] = {
      description = "from_iso8601!(String.t) :: t | no_return\nfrom_iso8601!(string)\n\n  Parses the extended \"Date and time of day\" format described by\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  Raises if the format is invalid.\n\n  ## Examples\n\n      iex> Date.from_iso8601!(\"2015-01-23\")\n      ~D[2015-01-23]\n      iex> Date.from_iso8601!(\"2015:01:23\")\n      ** (ArgumentError) cannot parse \"2015:01:23\" as date, reason: :invalid_format\n  "
    },
    inspect = {
      description = "inspect(date, opts)\ninspect(%{calendar: Calendar.ISO, year: year, month: month, day: day}, _)\n\n  Calculates the day of the week of a given `Date` struct.\n\n  Returns the day of the week as an integer. For the ISO 8601\n  calendar (the default), it is an integer from 1 to 7, where\n  1 is Monday and 7 is Sunday.\n\n  ## Examples\n\n      iex> Date.day_of_week(~D[2016-10-31])\n      1\n      iex> Date.day_of_week(~D[2016-11-01])\n      2\n      iex> Date.day_of_week(~N[2016-11-01 01:23:45])\n      2\n  "
    },
    ["leap_year?"] = {
      description = "leap_year?(%{calendar: calendar, year: year})\nleap_year?(Calendar.date) :: boolean()\nleap_year?(date)\n\n  Returns true if the year in `date` is a leap year.\n\n  ## Examples\n\n      iex> Date.leap_year?(~D[2000-01-01])\n      true\n      iex> Date.leap_year?(~D[2001-01-01])\n      false\n      iex> Date.leap_year?(~D[2004-01-01])\n      true\n      iex> Date.leap_year?(~D[1900-01-01])\n      false\n      iex> Date.leap_year?(~N[2004-01-01 01:23:45])\n      true\n\n  "
    },
    new = {
      description = "new(Calendar.year, Calendar.month, Calendar.day) :: {:ok, t} | {:error, atom}\nnew(year, month, day)\n\n  Builds a new ISO date.\n\n  Expects all values to be integers. Returns `{:ok, date}` if each\n  entry fits its appropriate range, returns `{:error, reason}` otherwise.\n\n  ## Examples\n\n      iex> Date.new(2000, 1, 1)\n      {:ok, ~D[2000-01-01]}\n      iex> Date.new(2000, 13, 1)\n      {:error, :invalid_date}\n      iex> Date.new(2000, 2, 29)\n      {:ok, ~D[2000-02-29]}\n\n      iex> Date.new(2000, 2, 30)\n      {:error, :invalid_date}\n      iex> Date.new(2001, 2, 29)\n      {:error, :invalid_date}\n\n  "
    },
    t = {
      description = "t :: %Date{year: Calendar.year, month: Calendar.month,\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    to_erl = {
      description = "to_erl(%{calendar: Calendar.ISO, year: year, month: month, day: day})\nto_erl(Calendar.date) :: :calendar.date\nto_erl(date)\n\n  Converts a `Date` struct to an Erlang date tuple.\n\n  Only supports converting dates which are in the ISO calendar,\n  attempting to convert dates from other calendars will raise.\n\n  ## Examples\n\n      iex> Date.to_erl(~D[2000-01-01])\n      {2000, 1, 1}\n      iex> Date.to_erl(~N[2000-01-01 01:23:45])\n      {2000, 1, 1}\n\n  "
    },
    to_iso8601 = {
      description = "to_iso8601(%{calendar: Calendar.ISO, year: year, month: month, day: day})\nto_iso8601(Calendar.date) :: String.t\nto_iso8601(date)\n\n  Converts the given datetime to\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  Only supports converting datetimes which are in the ISO calendar,\n  attempting to convert datetimes from other calendars will raise.\n\n  ### Examples\n\n      iex> Date.to_iso8601(~D[2000-02-28])\n      \"2000-02-28\"\n      iex> Date.to_iso8601(~N[2000-02-28 01:23:45])\n      \"2000-02-28\"\n\n  "
    },
    to_string = {
      description = "to_string(%{calendar: calendar, year: year, month: month, day: day})\nto_string(%{calendar: calendar, year: year, month: month, day: day})\nto_string(Calendar.date) :: String.t\nto_string(date)\n\n  Converts the given date to a string according to its calendar.\n\n  ### Examples\n\n      iex> Date.to_string(~D[2000-02-28])\n      \"2000-02-28\"\n      iex> Date.to_string(~N[2000-02-28 01:23:45])\n      \"2000-02-28\"\n\n  "
    },
    utc_today = {
      description = "utc_today() :: t\nutc_today()\n\n  Returns the current date in UTC.\n\n  ## Examples\n\n      iex> date = Date.utc_today()\n      iex> date.year >= 2016\n      true\n\n  "
    }
  },
  DateTime = {
    compare = {
      description = "compare(DateTime.t, DateTime.t) :: :lt | :eq | :gt\ncompare(%DateTime{} = datetime1, %DateTime{} = datetime2)\n\n  Compares two `DateTime` structs.\n\n  Returns `:gt` if first datetime is later than the second\n  and `:lt` for vice versa. If the two datetimes are equal\n  `:eq` is returned.\n\n  Note that both utc and stc offsets will be taken into\n  account when comparison is done.\n\n  ## Examples\n\n      iex> dt1 = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"AMT\",\n      ...>                 hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                 utc_offset: -14400, std_offset: 0, time_zone: \"America/Manaus\"}\n      iex> dt2 = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                 hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                 utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> DateTime.compare(dt1, dt2)\n      :gt\n  "
    },
    description = "\n  A datetime implementation with a time zone.\n\n  This datetime can be seen as an ephemeral snapshot\n  of a datetime at a given time zone. For such purposes,\n  it also includes both UTC and Standard offsets, as\n  well as the zone abbreviation field used exclusively\n  for formatting purposes.\n\n  Remember, comparisons in Elixir using `==`, `>`, `<` and friends\n  are structural and based on the DateTime struct fields. For proper\n  comparison between datetimes, use the `compare/2` function.\n\n  Developers should avoid creating the DateTime struct directly\n  and instead rely on the functions provided by this module as\n  well as the ones in 3rd party calendar libraries.\n\n  ## Where are my functions?\n\n  You will notice this module only contains conversion\n  functions as well as functions that work on UTC. This\n  is because a proper DateTime implementation requires a\n  TimeZone database which currently is not provided as part\n  of Elixir.\n\n  Such may be addressed in upcoming versions, meanwhile,\n  use 3rd party packages to provide DateTime building and\n  similar functionality with time zone backing.\n  ",
    from_iso8601 = {
      description = "from_iso8601(_)\nfrom_iso8601(<<year::4-bytes, ?-, month::2-bytes, ?-, day::2-bytes, sep,\nfrom_iso8601(String.t) :: {:ok, t, Calendar.utc_offset} | {:error, atom}\nfrom_iso8601(string)\n\n  Parses the extended \"Date and time of day\" format described by\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  Since ISO8601 does not include the proper time zone, the given\n  string will be converted to UTC and its offset in seconds will be\n  returned as part of this function. Therefore offset information\n  must be present in the string.\n\n  As specified in the standard, the separator \"T\" may be omitted if\n  desired as there is no ambiguity within this function.\n\n  Time representations with reduced accuracy are not supported.\n\n  ## Examples\n\n      iex> DateTime.from_iso8601(\"2015-01-23T23:50:07Z\")\n      {:ok, %DateTime{calendar: Calendar.ISO, day: 23, hour: 23, microsecond: {0, 0}, minute: 50, month: 1, second: 7, std_offset: 0,\n                      time_zone: \"Etc/UTC\", utc_offset: 0, year: 2015, zone_abbr: \"UTC\"}, 0}\n      iex> DateTime.from_iso8601(\"2015-01-23T23:50:07.123+02:30\")\n      {:ok, %DateTime{calendar: Calendar.ISO, day: 23, hour: 21, microsecond: {123000, 3}, minute: 20, month: 1, second: 7, std_offset: 0,\n                      time_zone: \"Etc/UTC\", utc_offset: 0, year: 2015, zone_abbr: \"UTC\"}, 9000}\n\n      iex> DateTime.from_iso8601(\"2015-01-23P23:50:07\")\n      {:error, :invalid_format}\n      iex> DateTime.from_iso8601(\"2015-01-23 23:50:07A\")\n      {:error, :invalid_format}\n      iex> DateTime.from_iso8601(\"2015-01-23T23:50:07\")\n      {:error, :missing_offset}\n      iex> DateTime.from_iso8601(\"2015-01-23 23:50:61\")\n      {:error, :invalid_time}\n      iex> DateTime.from_iso8601(\"2015-01-32 23:50:07\")\n      {:error, :invalid_date}\n\n      iex> DateTime.from_iso8601(\"2015-01-23T23:50:07.123-00:00\")\n      {:error, :invalid_format}\n      iex> DateTime.from_iso8601(\"2015-01-23T23:50:07.123-00:60\")\n      {:error, :invalid_format}\n\n  "
    },
    from_naive = {
      description = "from_naive(%NaiveDateTime{hour: hour, minute: minute, second: second, microsecond: microsecond,\nfrom_naive(NaiveDateTime.t, Calendar.time_zone) :: {:ok, DateTime.t}\nfrom_naive(naive_datetime, time_zone)\n\n  Converts the given NaiveDateTime to DateTime.\n\n  It expects a time zone to put the NaiveDateTime in.\n  Currently it only supports \"Etc/UTC\" as time zone.\n\n  ## Examples\n\n      iex> DateTime.from_naive(~N[2016-05-24 13:26:08.003], \"Etc/UTC\")\n      {:ok, %DateTime{calendar: Calendar.ISO, day: 24, hour: 13, microsecond: {3000, 3}, minute: 26,\n                      month: 5, second: 8, std_offset: 0, time_zone: \"Etc/UTC\", utc_offset: 0,\n                      year: 2016, zone_abbr: \"UTC\"}}\n\n  "
    },
    ["from_naive!"] = {
      description = "from_naive!(non_neg_integer, :native | System.time_unit) :: DateTime.t\nfrom_naive!(naive_datetime, time_zone)\n\n  Converts the given NaiveDateTime to DateTime.\n\n  It expects a time zone to put the NaiveDateTime in.\n  Currently it only supports \"Etc/UTC\" as time zone.\n\n  ## Examples\n\n      iex> DateTime.from_naive!(~N[2016-05-24 13:26:08.003], \"Etc/UTC\")\n      %DateTime{calendar: Calendar.ISO, day: 24, hour: 13, microsecond: {3000, 3}, minute: 26,\n                month: 5, second: 8, std_offset: 0, time_zone: \"Etc/UTC\", utc_offset: 0,\n                year: 2016, zone_abbr: \"UTC\"}\n\n  "
    },
    from_unix = {
      description = "from_unix(integer, :native | System.time_unit) :: {:ok, DateTime.t} | {:error, atom}\nfrom_unix(integer, unit \\\\ :second) when is_integer(integer)\n\n  Converts the given Unix time to DateTime.\n\n  The integer can be given in different unit\n  according to `System.convert_time_unit/3` and it will\n  be converted to microseconds internally.\n\n  Unix times are always in UTC and therefore the DateTime\n  will be returned in UTC.\n\n  ## Examples\n\n      iex> DateTime.from_unix(1464096368)\n      {:ok, %DateTime{calendar: Calendar.ISO, day: 24, hour: 13, microsecond: {0, 0}, minute: 26,\n                      month: 5, second: 8, std_offset: 0, time_zone: \"Etc/UTC\", utc_offset: 0,\n                      year: 2016, zone_abbr: \"UTC\"}}\n\n      iex> DateTime.from_unix(1432560368868569, :microsecond)\n      {:ok, %DateTime{calendar: Calendar.ISO, day: 25, hour: 13, microsecond: {868569, 6}, minute: 26,\n                      month: 5, second: 8, std_offset: 0, time_zone: \"Etc/UTC\", utc_offset: 0,\n                      year: 2015, zone_abbr: \"UTC\"}}\n\n  The unit can also be an integer as in `t:System.time_unit/0`:\n\n      iex> DateTime.from_unix(1432560368868569, 1024)\n      {:ok, %DateTime{calendar: Calendar.ISO, day: 23, hour: 22, microsecond: {211914, 3}, minute: 53,\n                      month: 1, second: 43, std_offset: 0, time_zone: \"Etc/UTC\", utc_offset: 0,\n                      year: 46302, zone_abbr: \"UTC\"}}\n\n  Negative Unix times are supported, up to -#{@unix_epoch} seconds,\n  which is equivalent to \"0000-01-01T00:00:00Z\" or 0 gregorian seconds.\n\n      iex> DateTime.from_unix(-12345678910)\n      {:ok, %DateTime{calendar: Calendar.ISO, day: 13, hour: 4, microsecond: {0, 0}, minute: 44,\n                      month: 10, second: 50, std_offset: 0, time_zone: \"Etc/UTC\", utc_offset: 0,\n                      year: 1578, zone_abbr: \"UTC\"}}\n\n  When a Unix time before that moment is passed to `from_unix/2`, `:error` will be returned.\n  "
    },
    ["from_unix!"] = {
      description = "from_unix!(non_neg_integer, :native | System.time_unit) :: DateTime.t\nfrom_unix!(integer, unit \\\\ :second) when is_atom(unit)\n\n  Converts the given Unix time to DateTime.\n\n  The integer can be given in different unit\n  according to `System.convert_time_unit/3` and it will\n  be converted to microseconds internally.\n\n  Unix times are always in UTC and therefore the DateTime\n  will be returned in UTC.\n\n  ## Examples\n\n      iex> DateTime.from_unix!(1464096368)\n      %DateTime{calendar: Calendar.ISO, day: 24, hour: 13, microsecond: {0, 0}, minute: 26,\n                month: 5, second: 8, std_offset: 0, time_zone: \"Etc/UTC\", utc_offset: 0,\n                year: 2016, zone_abbr: \"UTC\"}\n\n      iex> DateTime.from_unix!(1432560368868569, :microsecond)\n      %DateTime{calendar: Calendar.ISO, day: 25, hour: 13, microsecond: {868569, 6}, minute: 26,\n                month: 5, second: 8, std_offset: 0, time_zone: \"Etc/UTC\", utc_offset: 0,\n                year: 2015, zone_abbr: \"UTC\"}\n\n  Negative Unix times are supported, up to -#{@unix_epoch} seconds,\n  which is equivalent to \"0000-01-01T00:00:00Z\" or 0 gregorian seconds.\n\n      iex> DateTime.from_unix(-12345678910)\n      {:ok, %DateTime{calendar: Calendar.ISO, day: 13, hour: 4, microsecond: {0, 0}, minute: 44,\n                      month: 10, second: 50, std_offset: 0, time_zone: \"Etc/UTC\", utc_offset: 0,\n                      year: 1578, zone_abbr: \"UTC\"}}\n\n  When a Unix time before that moment is passed to `from_unix!/2`, an ArgumentError will be raised.\n  "
    },
    t = {
      description = "t :: %__MODULE__{year: Calendar.year, month: Calendar.month, day: Calendar.day,\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    to_date = {
      description = "to_date(%DateTime{year: year, month: month, day: day, calendar: calendar})\n\n  Converts a `DateTime` into a `Date`.\n\n  Because `Date` does not hold time nor time zone information,\n  data will be lost during the conversion.\n\n  ## Examples\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> DateTime.to_date(dt)\n      ~D[2000-02-29]\n\n  "
    },
    to_iso8601 = {
      description = "to_iso8601(%{calendar: Calendar.ISO, year: year, month: month, day: day,\nto_iso8601(Calendar.datetime) :: String.t\nto_iso8601(datetime)\n\n  Converts the given datetime to\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601) format.\n\n  Only supports converting datetimes which are in the ISO calendar,\n  attempting to convert datetimes from other calendars will raise.\n\n  WARNING: the ISO 8601 datetime format does not contain the time zone nor\n  its abbreviation, which means information is lost when converting to such\n  format.\n\n  ### Examples\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> DateTime.to_iso8601(dt)\n      \"2000-02-29T23:00:07+01:00\"\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"UTC\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 0, std_offset: 0, time_zone: \"Etc/UTC\"}\n      iex> DateTime.to_iso8601(dt)\n      \"2000-02-29T23:00:07Z\"\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"AMT\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: -14400, std_offset: 0, time_zone: \"America/Manaus\"}\n      iex> DateTime.to_iso8601(dt)\n      \"2000-02-29T23:00:07-04:00\"\n  "
    },
    to_naive = {
      description = "to_naive(%DateTime{year: year, month: month, day: day, calendar: calendar,\n\n  Converts a `DateTime` into a `NaiveDateTime`.\n\n  Because `NaiveDateTime` does not hold time zone information,\n  any time zone related data will be lost during the conversion.\n\n  ## Examples\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 1},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> DateTime.to_naive(dt)\n      ~N[2000-02-29 23:00:07.0]\n\n  "
    },
    to_string = {
      description = "to_string(%{calendar: calendar, year: year, month: month, day: day,\nto_string(%{calendar: calendar, year: year, month: month, day: day,\nto_string(Calendar.datetime) :: String.t\nto_string(datetime)\n\n  Converts the given datetime to a string according to its calendar.\n\n  ### Examples\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> DateTime.to_string(dt)\n      \"2000-02-29 23:00:07+01:00 CET Europe/Warsaw\"\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"UTC\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 0, std_offset: 0, time_zone: \"Etc/UTC\"}\n      iex> DateTime.to_string(dt)\n      \"2000-02-29 23:00:07Z\"\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"AMT\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: -14400, std_offset: 0, time_zone: \"America/Manaus\"}\n      iex> DateTime.to_string(dt)\n      \"2000-02-29 23:00:07-04:00 AMT America/Manaus\"\n  "
    },
    to_time = {
      description = "to_time(%DateTime{hour: hour, minute: minute, second: second, microsecond: microsecond})\n\n  Converts a `DateTime` into `Time`.\n\n  Because `Time` does not hold date nor time zone information,\n  data will be lost during the conversion.\n\n  ## Examples\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 1},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> DateTime.to_time(dt)\n      ~T[23:00:07.0]\n\n  "
    },
    to_unix = {
      description = "to_unix(%DateTime{calendar: Calendar.ISO, std_offset: std_offset, utc_offset: utc_offset,\nto_unix(DateTime.t, System.time_unit) :: non_neg_integer\nto_unix(datetime, unit \\\\ :second)\n\n  Converts the given DateTime to Unix time.\n\n  The DateTime is expected to be using the ISO calendar\n  with a year greater than or equal to 0.\n\n  It will return the integer with the given unit,\n  according to `System.convert_time_unit/3`.\n\n  ## Examples\n\n      iex> 1464096368 |> DateTime.from_unix!() |> DateTime.to_unix()\n      1464096368\n\n      iex> dt = %DateTime{calendar: Calendar.ISO, day: 20, hour: 18, microsecond: {273806, 6},\n      ...>                minute: 58, month: 11, second: 19, time_zone: \"America/Montevideo\",\n      ...>                utc_offset: -10800, std_offset: 3600, year: 2014, zone_abbr: \"UYST\"}\n      iex> DateTime.to_unix(dt)\n      1416517099\n\n      iex> flamel = %DateTime{calendar: Calendar.ISO, day: 22, hour: 8, microsecond: {527771, 6},\n      ...>                minute: 2, month: 3, second: 25, std_offset: 0, time_zone: \"Etc/UTC\",\n      ...>                utc_offset: 0, year: 1418, zone_abbr: \"UTC\"}\n      iex> DateTime.to_unix(flamel)\n      -17412508655\n\n  "
    },
    utc_now = {
      description = "utc_now() :: DateTime.t\nutc_now()\n\n  Returns the current datetime in UTC.\n\n  ## Examples\n\n      iex> datetime = DateTime.utc_now()\n      iex> datetime.time_zone\n      \"Etc/UTC\"\n\n  "
    }
  },
  Dict = {
    delete = {
      description = "delete(t, key) :: t\ndelete(dict, key)\n"
    },
    description = "\n  WARNING: this module is deprecated.\n\n  If you need a general dictionary, use the `Map` module.\n  If you need to manipulate keyword lists, use `Keyword`.\n\n  To convert maps into keywords and vice-versa, use the\n  `new` function in the respective modules.\n  ",
    drop = {
      description = "drop(t, [key]) :: t\ndrop(dict, keys)\ndrop(dict, keys)\n"
    },
    empty = {
      description = "empty(t) :: t\nempty(dict)\n"
    },
    ["equal?"] = {
      description = "equal?(t, t) :: boolean\nequal?(dict1, dict2)\nequal?(dict1, dict2)\n"
    },
    fetch = {
      description = "fetch(t, key) :: value\nfetch(dict, key)\n"
    },
    ["fetch!"] = {
      description = "fetch!(t, key) :: value | no_return\nfetch!(dict, key)\nfetch!(dict, key)\n"
    },
    get = {
      description = "get(t, key, value) :: value\nget(dict, key, default \\\\ nil)\nget(dict, key, default \\\\ nil)\n"
    },
    get_and_update = {
      description = "get_and_update(t, key, (value -> {value, value})) :: {value, t}\nget_and_update(dict, key, fun)\nget_and_update(dict, key, fun)\n"
    },
    get_lazy = {
      description = "get_lazy(t, key, (() -> value)) :: value\nget_lazy(dict, key, fun)\nget_lazy(dict, key, fun) when is_function(fun, 0)\n"
    },
    ["has_key?"] = {
      description = "has_key?(t, key) :: boolean\nhas_key?(dict, key)\nhas_key?(dict, key)\n"
    },
    key = {
      description = "key :: any\n"
    },
    keys = {
      description = "keys(t) :: [key]\nkeys(dict)\nkeys(dict)\n"
    },
    merge = {
      description = "merge(t, t, (key, value, value -> value)) :: t\nmerge(dict1, dict2, fun)\nmerge(t, t) :: t\nmerge(dict1, dict2)\nmerge(dict1, dict2, fun \\\\ fn(_k, _v1, v2) -> v2 end)\n"
    },
    pop = {
      description = "pop(t, key, value) :: {value, t}\npop(dict, key, default \\\\ nil)\npop(dict, key, default \\\\ nil)\n"
    },
    pop_lazy = {
      description = "pop_lazy(t, key, (() -> value)) :: {value, t}\npop_lazy(dict, key, fun)\npop_lazy(dict, key, fun) when is_function(fun, 0)\n"
    },
    put = {
      description = "put(t, key, value) :: t\nput(dict, key, val)\n"
    },
    put_new = {
      description = "put_new(t, key, value) :: t\nput_new(dict, key, val)\nput_new(dict, key, value)\n"
    },
    put_new_lazy = {
      description = "put_new_lazy(t, key, (() -> value)) :: t\nput_new_lazy(dict, key, fun)\nput_new_lazy(dict, key, fun) when is_function(fun, 0)\n"
    },
    size = {
      description = "size(t) :: non_neg_integer\nsize(dict)\n"
    },
    split = {
      description = "split(t, [key]) :: {t, t}\nsplit(dict, keys)\nsplit(dict, keys)\n"
    },
    t = {
      description = "t :: list | map\n"
    },
    take = {
      description = "take(t, [key]) :: t\ntake(dict, keys)\ntake(dict, keys)\n"
    },
    to_list = {
      description = "to_list(t) :: list\nto_list(dict)\nto_list(dict)\n"
    },
    update = {
      description = "update(t, key, value, (value -> value)) :: t\nupdate(dict, key, initial, fun)\nupdate(dict, key, initial, fun)\n"
    },
    ["update!"] = {
      description = "update!(t, key, (value -> value)) :: t\nupdate!(dict, key, fun)\nupdate!(dict, key, fun)\n"
    },
    value = {
      description = "value :: any\n"
    },
    values = {
      description = "values(t) :: [value]\nvalues(dict)\nvalues(dict)\n"
    }
  },
  Enum = {
    EmptyError = {},
    OutOfBoundsError = {},
    ["all?"] = {
      description = "all?(enumerable, fun) when is_function(fun, 1)\nall?(enumerable, fun) when is_list(enumerable) and is_function(fun, 1)\nall?(t, (element -> as_boolean(term))) :: boolean\nall?(enumerable, fun \\\\ fn(x) -> x end)\n\n  Returns true if the given `fun` evaluates to true on all of the items in the enumerable.\n\n  It stops the iteration at the first invocation that returns `false` or `nil`.\n\n  ## Examples\n\n      iex> Enum.all?([2, 4, 6], fn(x) -> rem(x, 2) == 0 end)\n      true\n\n      iex> Enum.all?([2, 3, 4], fn(x) -> rem(x, 2) == 0 end)\n      false\n\n  If no function is given, it defaults to checking if\n  all items in the enumerable are truthy values.\n\n      iex> Enum.all?([1, 2, 3])\n      true\n\n      iex> Enum.all?([1, nil, 3])\n      false\n\n  "
    },
    ["any?"] = {
      description = "any?(enumerable, fun) when is_function(fun, 1)\nany?(enumerable, fun) when is_list(enumerable) and is_function(fun, 1)\nany?(t, (element -> as_boolean(term))) :: boolean\nany?(enumerable, fun \\\\ fn(x) -> x end)\n\n  Returns true if the given `fun` evaluates to true on any of the items in the enumerable.\n\n  It stops the iteration at the first invocation that returns a truthy value (not `false` or `nil`).\n\n  ## Examples\n\n      iex> Enum.any?([2, 4, 6], fn(x) -> rem(x, 2) == 1 end)\n      false\n\n      iex> Enum.any?([2, 3, 4], fn(x) -> rem(x, 2) == 1 end)\n      true\n\n  If no function is given, it defaults to checking if at least one item\n  in the enumerable is a truthy value.\n\n      iex> Enum.any?([false, false, false])\n      false\n\n      iex> Enum.any?([false, true, false])\n      true\n\n  "
    },
    at = {
      description = "at(t, index, default) :: element | default\nat(enumerable, index, default \\\\ nil)\n\n  Finds the element at the given `index` (zero-based).\n\n  Returns `default` if `index` is out of bounds.\n\n  A negative `index` can be passed, which means the `enumerable` is\n  enumerated once and the `index` is counted from the end (e.g.\n  `-1` finds the last element).\n\n  Note this operation takes linear time. In order to access\n  the element at index `index`, it will need to traverse `index`\n  previous elements.\n\n  ## Examples\n\n      iex> Enum.at([2, 4, 6], 0)\n      2\n\n      iex> Enum.at([2, 4, 6], 2)\n      6\n\n      iex> Enum.at([2, 4, 6], 4)\n      nil\n\n      iex> Enum.at([2, 4, 6], 4, :none)\n      :none\n\n  "
    },
    chunk = {
      description = "chunk(t, pos_integer, pos_integer, t | nil) :: [list]\nchunk(enumerable, count, step, leftover \\\\ nil)\nchunk(t, pos_integer) :: [list]\nchunk(enumerable, count)\n\n  Shortcut to `chunk(enumerable, count, count)`.\n  "
    },
    chunk_by = {
      description = "chunk_by(t, (element -> any)) :: [list]\nchunk_by(enumerable, fun) when is_function(fun, 1)\n\n  Splits enumerable on every element for which `fun` returns a new\n  value.\n\n  Returns a list of lists.\n\n  ## Examples\n\n      iex> Enum.chunk_by([1, 2, 2, 3, 4, 4, 6, 7, 7], &(rem(&1, 2) == 1))\n      [[1], [2, 2], [3], [4, 4, 6], [7, 7]]\n\n  "
    },
    concat = {
      description = "concat(left, right)\nconcat(t, t) :: t\nconcat(left, right) when is_list(left) and is_list(right)\nconcat(t) :: t\nconcat(enumerables)\n\n  Given an enumerable of enumerables, concatenates the enumerables into\n  a single list.\n\n  ## Examples\n\n      iex> Enum.concat([1..3, 4..6, 7..9])\n      [1, 2, 3, 4, 5, 6, 7, 8, 9]\n\n      iex> Enum.concat([[1, [2], 3], [4], [5, 6]])\n      [1, [2], 3, 4, 5, 6]\n\n  "
    },
    count = {
      description = "count(_function),\ncount(map)\ncount(_list),\ncount(t, (element -> as_boolean(term))) :: non_neg_integer\ncount(enumerable, fun) when is_function(fun, 1)\ncount(enumerable)\ncount(t) :: non_neg_integer\ncount(enumerable) when is_list(enumerable)\n\n  Returns the size of the enumerable.\n\n  ## Examples\n\n      iex> Enum.count([1, 2, 3])\n      3\n\n  "
    },
    dedup = {
      description = "dedup(t) :: list\ndedup(enumerable)\n\n  Enumerates the `enumerable`, returning a list where all consecutive\n  duplicated elements are collapsed to a single element.\n\n  Elements are compared using `===`.\n\n  If you want to remove all duplicated elements, regardless of order,\n  see `uniq/1`.\n\n  ## Examples\n\n      iex> Enum.dedup([1, 2, 3, 3, 2, 1])\n      [1, 2, 3, 2, 1]\n\n      iex> Enum.dedup([1, 1, 2, 2.0, :three, :\"three\"])\n      [1, 2, 2.0, :three]\n\n  "
    },
    dedup_by = {
      description = "dedup_by(t, (element -> term)) :: list\ndedup_by(enumerable, fun) when is_function(fun, 1)\n\n  Enumerates the `enumerable`, returning a list where all consecutive\n  duplicated elements are collapsed to a single element.\n\n  The function `fun` maps every element to a term which is used to\n  determine if two elements are duplicates.\n\n  ## Examples\n\n      iex> Enum.dedup_by([{1, :a}, {2, :b}, {2, :c}, {1, :a}], fn {x, _} -> x end)\n      [{1, :a}, {2, :b}, {1, :a}]\n\n      iex> Enum.dedup_by([5, 1, 2, 3, 2, 1], fn x -> x > 2 end)\n      [5, 1, 3, 2]\n\n  "
    },
    default = {
      description = "default :: any\n\n  A partially applied reduce function.\n\n  The continuation is the closure returned as a result when\n  the enumeration is suspended. When invoked, it expects\n  a new accumulator and it returns the result.\n\n  A continuation is easily implemented as long as the reduce\n  function is defined in a tail recursive fashion. If the function\n  is tail recursive, all the state is passed as arguments, so\n  the continuation would simply be the reducing function partially\n  applied.\n  "
    },
    description = "\n  Provides a set of algorithms that enumerate over enumerables according\n  to the `Enumerable` protocol.\n\n      iex> Enum.map([1, 2, 3], fn(x) -> x * 2 end)\n      [2, 4, 6]\n\n  Some particular types, like maps, yield a specific format on enumeration.\n  For example, the argument is always a `{key, value}` tuple for maps:\n\n      iex> map = %{a: 1, b: 2}\n      iex> Enum.map(map, fn {k, v} -> {k, v * 2} end)\n      [a: 2, b: 4]\n\n  Note that the functions in the `Enum` module are eager: they always\n  start the enumeration of the given enumerable. The `Stream` module\n  allows lazy enumeration of enumerables and provides infinite streams.\n\n  Since the majority of the functions in `Enum` enumerate the whole\n  enumerable and return a list as result, infinite streams need to\n  be carefully used with such functions, as they can potentially run\n  forever. For example:\n\n      Enum.each Stream.cycle([1, 2, 3]), &IO.puts(&1)\n\n  ",
    drop = {
      description = "drop(enumerable, amount) when is_integer(amount) and amount < 0\ndrop(enumerable, amount) when is_integer(amount) and amount >= 0\ndrop(t, integer) :: list\ndrop(enumerable, amount)\n\n  Drops the `amount` of items from the enumerable.\n\n  If a negative `amount` is given, the `amount` of last values will be dropped.\n\n  The `enumerable` is enumerated once to retrieve the proper index and\n  the remaining calculation is performed from the end.\n\n  ## Examples\n\n      iex> Enum.drop([1, 2, 3], 2)\n      [3]\n\n      iex> Enum.drop([1, 2, 3], 10)\n      []\n\n      iex> Enum.drop([1, 2, 3], 0)\n      [1, 2, 3]\n\n      iex> Enum.drop([1, 2, 3], -1)\n      [1, 2]\n\n  "
    },
    drop_every = {
      description = "drop_every(enumerable, nth) when is_integer(nth) and nth > 1\ndrop_every([], nth) when is_integer(nth)\ndrop_every(enumerable, 0)\ndrop_every(_enumerable, 1)\ndrop_every(t, non_neg_integer) :: list\ndrop_every(enumerable, nth)\n\n  Returns a list of every `nth` item in the enumerable dropped,\n  starting with the first element.\n\n  The first item is always dropped, unless `nth` is 0.\n\n  The second argument specifying every `nth` item must be a non-negative\n  integer.\n\n  ## Examples\n\n      iex> Enum.drop_every(1..10, 2)\n      [2, 4, 6, 8, 10]\n\n      iex> Enum.drop_every(1..10, 0)\n      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]\n\n      iex> Enum.drop_every([1, 2, 3], 1)\n      []\n\n  "
    },
    drop_while = {
      description = "drop_while(enumerable, fun)\ndrop_while(t, (element -> as_boolean(term))) :: list\ndrop_while(enumerable, fun) when is_list(enumerable) and is_function(fun, 1)\n\n  Drops items at the beginning of the enumerable while `fun` returns a\n  truthy value.\n\n  ## Examples\n\n      iex> Enum.drop_while([1, 2, 3, 2, 1], fn(x) -> x < 3 end)\n      [3, 2, 1]\n\n  "
    },
    each = {
      description = "each(enumerable, fun) when is_function(fun, 1)\neach(t, (element -> any)) :: :ok\neach(enumerable, fun) when is_list(enumerable) and is_function(fun, 1)\n\n  Invokes the given `fun` for each item in the enumerable.\n\n  Returns `:ok`.\n\n  ## Examples\n\n      Enum.each([\"some\", \"example\"], fn(x) -> IO.puts x end)\n      \"some\"\n      \"example\"\n      #=> :ok\n\n  "
    },
    element = {
      description = "element :: any\n\n  A partially applied reduce function.\n\n  The continuation is the closure returned as a result when\n  the enumeration is suspended. When invoked, it expects\n  a new accumulator and it returns the result.\n\n  A continuation is easily implemented as long as the reduce\n  function is defined in a tail recursive fashion. If the function\n  is tail recursive, all the state is passed as arguments, so\n  the continuation would simply be the reducing function partially\n  applied.\n  "
    },
    ["empty?"] = {
      description = "empty?(enumerable)\nempty?(t) :: boolean\nempty?(enumerable) when is_list(enumerable)\n\n  Determines if the enumerable is empty.\n\n  Returns `true` if `enumerable` is empty, otherwise `false`.\n\n  ## Examples\n\n      iex> Enum.empty?([])\n      true\n\n      iex> Enum.empty?([1, 2, 3])\n      false\n\n  "
    },
    fetch = {
      description = "fetch(enumerable, index) when is_integer(index)\nfetch(enumerable, index) when is_integer(index) and index < 0\nfetch(first..last, index) when is_integer(index)\nfetch(enumerable, index) when is_list(enumerable) and is_integer(index)\nfetch(t, index) :: {:ok, element} | :error\nfetch(enumerable, index)\n\n  Finds the element at the given `index` (zero-based).\n\n  Returns `{:ok, element}` if found, otherwise `:error`.\n\n  A negative `index` can be passed, which means the `enumerable` is\n  enumerated once and the `index` is counted from the end (e.g.\n  `-1` fetches the last element).\n\n  Note this operation takes linear time. In order to access\n  the element at index `index`, it will need to traverse `index`\n  previous elements.\n\n  ## Examples\n\n      iex> Enum.fetch([2, 4, 6], 0)\n      {:ok, 2}\n\n      iex> Enum.fetch([2, 4, 6], -3)\n      {:ok, 2}\n\n      iex> Enum.fetch([2, 4, 6], 2)\n      {:ok, 6}\n\n      iex> Enum.fetch([2, 4, 6], 4)\n      :error\n\n  "
    },
    ["fetch!"] = {
      description = "fetch!(t, index) :: element | no_return\nfetch!(enumerable, index)\n\n  Finds the element at the given `index` (zero-based).\n\n  Raises `OutOfBoundsError` if the given `index` is outside the range of\n  the enumerable.\n\n  Note this operation takes linear time. In order to access the element\n  at index `index`, it will need to traverse `index` previous elements.\n\n  ## Examples\n\n      iex> Enum.fetch!([2, 4, 6], 0)\n      2\n\n      iex> Enum.fetch!([2, 4, 6], 2)\n      6\n\n      iex> Enum.fetch!([2, 4, 6], 4)\n      ** (Enum.OutOfBoundsError) out of bounds error\n\n  "
    },
    filter = {
      description = "filter(enumerable, fun) when is_function(fun, 1)\nfilter(t, (element -> as_boolean(term))) :: list\nfilter(enumerable, fun) when is_list(enumerable) and is_function(fun, 1)\n\n  Filters the enumerable, i.e. returns only those elements\n  for which `fun` returns a truthy value.\n\n  See also `reject/2`.\n\n  ## Examples\n\n      iex> Enum.filter([1, 2, 3], fn(x) -> rem(x, 2) == 0 end)\n      [2]\n\n  "
    },
    filter_map = {
      description = "filter_map(enumerable, filter, mapper)\nfilter_map(t, (element -> as_boolean(term)),\nfilter_map(enumerable, filter, mapper)\n\n  Filters the enumerable and maps its elements in one pass.\n\n  ## Examples\n\n      iex> Enum.filter_map([1, 2, 3], fn(x) -> rem(x, 2) == 0 end, &(&1 * 2))\n      [4]\n\n  "
    },
    find = {
      description = "find(enumerable, default, fun) when is_function(fun, 1)\nfind(enumerable, default, fun) when is_list(enumerable) and is_function(fun, 1)\nfind(t, default, (element -> any)) :: element | default\nfind(enumerable, default \\\\ nil, fun)\n\n  Returns the first item for which `fun` returns a truthy value.\n  If no such item is found, returns `default`.\n\n  ## Examples\n\n      iex> Enum.find([2, 4, 6], fn(x) -> rem(x, 2) == 1 end)\n      nil\n\n      iex> Enum.find([2, 4, 6], 0, fn(x) -> rem(x, 2) == 1 end)\n      0\n\n      iex> Enum.find([2, 3, 4], fn(x) -> rem(x, 2) == 1 end)\n      3\n\n  "
    },
    find_index = {
      description = "find_index(enumerable, fun) when is_function(fun, 1)\nfind_index(t, (element -> any)) :: non_neg_integer | nil\nfind_index(enumerable, fun) when is_list(enumerable) and is_function(fun, 1)\n\n  Similar to `find/3`, but returns the index (zero-based)\n  of the element instead of the element itself.\n\n  ## Examples\n\n      iex> Enum.find_index([2, 4, 6], fn(x) -> rem(x, 2) == 1 end)\n      nil\n\n      iex> Enum.find_index([2, 3, 4], fn(x) -> rem(x, 2) == 1 end)\n      1\n\n  "
    },
    find_value = {
      description = "find_value(enumerable, default, fun) when is_function(fun, 1)\nfind_value(enumerable, default, fun) when is_list(enumerable) and is_function(fun, 1)\nfind_value(t, any, (element -> any)) :: any | nil\nfind_value(enumerable, default \\\\ nil, fun)\n\n  Similar to `find/3`, but returns the value of the function\n  invocation instead of the element itself.\n\n  ## Examples\n\n      iex> Enum.find_value([2, 4, 6], fn(x) -> rem(x, 2) == 1 end)\n      nil\n\n      iex> Enum.find_value([2, 3, 4], fn(x) -> rem(x, 2) == 1 end)\n      true\n\n      iex> Enum.find_value([1, 2, 3], \"no bools!\", &is_boolean/1)\n      \"no bools!\"\n\n  "
    },
    flat_map = {
      description = "flat_map(enumerable, fun) when is_function(fun, 1)\nflat_map(t, (element -> t)) :: list\nflat_map(enumerable, fun) when is_list(enumerable) and is_function(fun, 1)\n\n  Maps the given `fun` over `enumerable` and flattens the result.\n\n  This function returns a new enumerable built by appending the result of invoking `fun`\n  on each element of `enumerable` together; conceptually, this is similar to a\n  combination of `map/2` and `concat/1`.\n\n  ## Examples\n\n      iex> Enum.flat_map([:a, :b, :c], fn(x) -> [x, x] end)\n      [:a, :a, :b, :b, :c, :c]\n\n      iex> Enum.flat_map([{1, 3}, {4, 6}], fn({x, y}) -> x..y end)\n      [1, 2, 3, 4, 5, 6]\n\n      iex> Enum.flat_map([:a, :b, :c], fn(x) -> [[x]] end)\n      [[:a], [:b], [:c]]\n\n  "
    },
    flat_map_reduce = {
      description = "flat_map_reduce(t, acc, fun) :: {[any], any}\nflat_map_reduce(enumerable, acc, fun) when is_function(fun, 2)\n\n  Maps and reduces an enumerable, flattening the given results (only one level deep).\n\n  It expects an accumulator and a function that receives each enumerable\n  item, and must return a tuple containing a new enumerable (often a list)\n  with the new accumulator or a tuple with `:halt` as first element and\n  the accumulator as second.\n\n  ## Examples\n\n      iex> enum = 1..100\n      iex> n = 3\n      iex> Enum.flat_map_reduce(enum, 0, fn i, acc ->\n      ...>   if acc < n, do: {[i], acc + 1}, else: {:halt, acc}\n      ...> end)\n      {[1, 2, 3], 3}\n\n      iex> Enum.flat_map_reduce(1..5, 0, fn(i, acc) -> {[[i]], acc + i} end)\n      {[[1], [2], [3], [4], [5]], 15}\n\n  "
    },
    group_by = {
      description = "group_by(enumerable, dict, fun) when is_function(fun, 1)\ngroup_by(enumerable, key_fun, value_fun)\ngroup_by(t, (element -> any), (element -> any)) :: map\ngroup_by(enumerable, key_fun, value_fun \\\\ fn x -> x end)\n\n  Splits the enumerable into groups based on `key_fun`.\n\n  The result is a map where each key is given by `key_fun` and each\n  value is a list of elements given by `value_fun`. Ordering is preserved.\n\n  ## Examples\n\n      iex> Enum.group_by(~w{ant buffalo cat dingo}, &String.length/1)\n      %{3 => [\"ant\", \"cat\"], 7 => [\"buffalo\"], 5 => [\"dingo\"]}\n\n      iex> Enum.group_by(~w{ant buffalo cat dingo}, &String.length/1, &String.first/1)\n      %{3 => [\"a\", \"c\"], 7 => [\"b\"], 5 => [\"d\"]}\n\n  "
    },
    index = {
      description = "index :: integer\n\n  A partially applied reduce function.\n\n  The continuation is the closure returned as a result when\n  the enumeration is suspended. When invoked, it expects\n  a new accumulator and it returns the result.\n\n  A continuation is easily implemented as long as the reduce\n  function is defined in a tail recursive fashion. If the function\n  is tail recursive, all the state is passed as arguments, so\n  the continuation would simply be the reducing function partially\n  applied.\n  "
    },
    intersperse = {
      description = "intersperse(t, element) :: list\nintersperse(enumerable, element)\n\n  Intersperses `element` between each element of the enumeration.\n\n  Complexity: O(n).\n\n  ## Examples\n\n      iex> Enum.intersperse([1, 2, 3], 0)\n      [1, 0, 2, 0, 3]\n\n      iex> Enum.intersperse([1], 0)\n      [1]\n\n      iex> Enum.intersperse([], 0)\n      []\n\n  "
    },
    into = {
      description = "into(enumerable, collectable, transform)\ninto(Enumerable.t, Collectable.t, (term -> term)) :: Collectable.t\ninto(enumerable, collectable, transform)\ninto(enumerable, collectable)\ninto(enumerable, %{} = collectable)\ninto(enumerable, %{} = collectable) when is_list(enumerable)\ninto(%{} = enumerable, %{} = collectable)\ninto(enumerable, %_{} = collectable)\ninto(%_{} = enumerable, collectable)\ninto(Enumerable.t, Collectable.t) :: Collectable.t\ninto(enumerable, collectable) when is_list(collectable)\n\n  Inserts the given `enumerable` into a `collectable`.\n\n  ## Examples\n\n      iex> Enum.into([1, 2], [0])\n      [0, 1, 2]\n\n      iex> Enum.into([a: 1, b: 2], %{})\n      %{a: 1, b: 2}\n\n      iex> Enum.into(%{a: 1}, %{b: 2})\n      %{a: 1, b: 2}\n\n      iex> Enum.into([a: 1, a: 2], %{})\n      %{a: 2}\n\n  "
    },
    join = {
      description = "join(enumerable, joiner) when is_binary(joiner)\njoin(t, String.t) :: String.t\njoin(enumerable, joiner \\\\ \"\")\n\n  Joins the given enumerable into a binary using `joiner` as a\n  separator.\n\n  If `joiner` is not passed at all, it defaults to the empty binary.\n\n  All items in the enumerable must be convertible to a binary,\n  otherwise an error is raised.\n\n  ## Examples\n\n      iex> Enum.join([1, 2, 3])\n      \"123\"\n\n      iex> Enum.join([1, 2, 3], \" = \")\n      \"1 = 2 = 3\"\n\n  "
    },
    map = {
      description = "map(enumerable, fun) when is_function(fun, 1)\nmap(enumerable, fun) when is_list(enumerable) and is_function(fun, 1)\nmap(t, (element -> any)) :: list\nmap(enumerable, fun)\n\n  Returns a list where each item is the result of invoking\n  `fun` on each corresponding item of `enumerable`.\n\n  For maps, the function expects a key-value tuple.\n\n  ## Examples\n\n      iex> Enum.map([1, 2, 3], fn(x) -> x * 2 end)\n      [2, 4, 6]\n\n      iex> Enum.map([a: 1, b: 2], fn({k, v}) -> {k, -v} end)\n      [a: -1, b: -2]\n\n  "
    },
    map_every = {
      description = "map_every(enumerable, nth, fun) when is_integer(nth) and nth > 1\nmap_every([], nth, _fun) when is_integer(nth) and nth > 1\nmap_every(enumerable, 0, _fun)\nmap_every(enumerable, 1, fun)\nmap_every(t, non_neg_integer, (element -> any)) :: list\nmap_every(enumerable, nth, fun)\n\n  Returns a list of results of invoking `fun` on every `nth`\n  item of `enumerable`, starting with the first element.\n\n  The first item is always passed to the given function.\n\n  The second argument specifying every `nth` item must be a non-negative\n  integer.\n\n  ## Examples\n\n      iex> Enum.map_every(1..10, 2, fn(x) -> x * 2 end)\n      [2, 2, 6, 4, 10, 6, 14, 8, 18, 10]\n\n      iex> Enum.map_every(1..5, 0, fn(x) -> x * 2 end)\n      [1, 2, 3, 4, 5]\n\n      iex> Enum.map_every([1, 2, 3], 1, fn(x) -> x * 2 end)\n      [2, 4, 6]\n\n  "
    },
    map_join = {
      description = "map_join(enumerable, joiner, mapper) when is_binary(joiner) and is_function(mapper, 1)\nmap_join(t, String.t, (element -> any)) :: String.t\nmap_join(enumerable, joiner \\\\ \"\", mapper)\n\n  Maps and joins the given enumerable in one pass.\n\n  `joiner` can be either a binary or a list and the result will be of\n  the same type as `joiner`.\n  If `joiner` is not passed at all, it defaults to an empty binary.\n\n  All items in the enumerable must be convertible to a binary,\n  otherwise an error is raised.\n\n  ## Examples\n\n      iex> Enum.map_join([1, 2, 3], &(&1 * 2))\n      \"246\"\n\n      iex> Enum.map_join([1, 2, 3], \" = \", &(&1 * 2))\n      \"2 = 4 = 6\"\n\n  "
    },
    map_reduce = {
      description = "map_reduce(enumerable, acc, fun) when is_function(fun, 2)\nmap_reduce(t, any, (element, any -> {any, any})) :: {any, any}\nmap_reduce(enumerable, acc, fun) when is_list(enumerable) and is_function(fun)\n\n  Invokes the given function to each item in the enumerable to reduce\n  it to a single element, while keeping an accumulator.\n\n  Returns a tuple where the first element is the mapped enumerable and\n  the second one is the final accumulator.\n\n  The function, `fun`, receives two arguments: the first one is the\n  element, and the second one is the accumulator. `fun` must return\n  a tuple with two elements in the form of `{result, accumulator}`.\n\n  For maps, the first tuple element must be a `{key, value}` tuple.\n\n  ## Examples\n\n      iex> Enum.map_reduce([1, 2, 3], 0, fn(x, acc) -> {x * 2, x + acc} end)\n      {[2, 4, 6], 6}\n\n  "
    },
    max = {
      description = "max(enumerable, empty_fallback) when is_function(empty_fallback, 0)\nmax(t, (() -> empty_result)) :: element | empty_result | no_return when empty_result: any\nmax(enumerable, empty_fallback \\\\ fn -> raise Enum.EmptyError end)\n\n  Returns the maximal element in the enumerable according\n  to Erlang's term ordering.\n\n  If multiple elements are considered maximal, the first one that was found\n  is returned.\n\n  Calls the provided `empty_fallback` function and returns its value if\n  `enumerable` is empty. The default `empty_fallback` raises `Enum.EmptyError`.\n\n  ## Examples\n\n      iex> Enum.max([1, 2, 3])\n      3\n\n      iex> Enum.max([], fn -> 0 end)\n      0\n\n  "
    },
    max_by = {
      description = "max_by(enumerable, fun, empty_fallback) when is_function(fun, 1) and is_function(empty_fallback, 0)\nmax_by(t, (element -> any), (() -> empty_result)) :: element | empty_result | no_return when empty_result: any\nmax_by(enumerable, fun, empty_fallback \\\\ fn -> raise Enum.EmptyError end)\n\n  Returns the maximal element in the enumerable as calculated\n  by the given function.\n\n  If multiple elements are considered maximal, the first one that was found\n  is returned.\n\n  Calls the provided `empty_fallback` function and returns its value if\n  `enumerable` is empty. The default `empty_fallback` raises `Enum.EmptyError`.\n\n  ## Examples\n\n      iex> Enum.max_by([\"a\", \"aa\", \"aaa\"], fn(x) -> String.length(x) end)\n      \"aaa\"\n\n      iex> Enum.max_by([\"a\", \"aa\", \"aaa\", \"b\", \"bbb\"], &String.length/1)\n      \"aaa\"\n\n      iex> Enum.max_by([], &String.length/1, fn -> nil end)\n      nil\n\n  "
    },
    ["member?"] = {
      description = "member?(_function, _value),\nmember?(_map, _other)\nmember?(map, {key, value})\nmember?(_list, _value),\nmember?(enumerable, element)\nmember?(t, element) :: boolean\nmember?(enumerable, element) when is_list(enumerable)\n\n  Checks if `element` exists within the enumerable.\n\n  Membership is tested with the match (`===`) operator.\n\n  ## Examples\n\n      iex> Enum.member?(1..10, 5)\n      true\n      iex> Enum.member?(1..10, 5.0)\n      false\n\n      iex> Enum.member?([1.0, 2.0, 3.0], 2)\n      false\n      iex> Enum.member?([1.0, 2.0, 3.0], 2.000)\n      true\n\n      iex> Enum.member?([:a, :b, :c], :d)\n      false\n\n  "
    },
    min = {
      description = "min(enumerable, empty_fallback) when is_function(empty_fallback, 0)\nmin(t, (() -> empty_result)) :: element | empty_result | no_return when empty_result: any\nmin(enumerable, empty_fallback \\\\ fn -> raise Enum.EmptyError end)\n\n  Returns the minimal element in the enumerable according\n  to Erlang's term ordering.\n\n  If multiple elements are considered minimal, the first one that was found\n  is returned.\n\n  Calls the provided `empty_fallback` function and returns its value if\n  `enumerable` is empty. The default `empty_fallback` raises `Enum.EmptyError`.\n\n  ## Examples\n\n      iex> Enum.min([1, 2, 3])\n      1\n\n      iex> Enum.min([], fn -> 0 end)\n      0\n\n  "
    },
    min_by = {
      description = "min_by(enumerable, fun, empty_fallback) when is_function(fun, 1) and is_function(empty_fallback, 0)\nmin_by(t, (element -> any), (() -> empty_result)) :: element | empty_result | no_return when empty_result: any\nmin_by(enumerable, fun, empty_fallback \\\\ fn -> raise Enum.EmptyError end)\n\n  Returns the minimal element in the enumerable as calculated\n  by the given function.\n\n  If multiple elements are considered minimal, the first one that was found\n  is returned.\n\n  Calls the provided `empty_fallback` function and returns its value if\n  `enumerable` is empty. The default `empty_fallback` raises `Enum.EmptyError`.\n\n  ## Examples\n\n      iex> Enum.min_by([\"a\", \"aa\", \"aaa\"], fn(x) -> String.length(x) end)\n      \"a\"\n\n      iex> Enum.min_by([\"a\", \"aa\", \"aaa\", \"b\", \"bbb\"], &String.length/1)\n      \"a\"\n\n      iex> Enum.min_by([], &String.length/1, fn -> nil end)\n      nil\n\n  "
    },
    min_max = {
      description = "min_max(enumerable, empty_fallback) when is_function(empty_fallback, 0)\nmin_max(t, (() -> empty_result)) :: {element, element} | empty_result | no_return when empty_result: any\nmin_max(enumerable, empty_fallback \\\\ fn -> raise Enum.EmptyError end)\n\n  Returns a tuple with the minimal and the maximal elements in the\n  enumerable according to Erlang's term ordering.\n\n  If multiple elements are considered maximal or minimal, the first one\n  that was found is returned.\n\n  Calls the provided `empty_fallback` function and returns its value if\n  `enumerable` is empty. The default `empty_fallback` raises `Enum.EmptyError`.\n\n  ## Examples\n\n      iex> Enum.min_max([2, 3, 1])\n      {1, 3}\n\n      iex> Enum.min_max([], fn -> {nil, nil} end)\n      {nil, nil}\n\n  "
    },
    min_max_by = {
      description = "min_max_by(enumerable, fun, empty_fallback) when is_function(fun, 1) and is_function(empty_fallback, 0)\nmin_max_by(t, (element -> any), (() -> empty_result)) :: {element, element} | empty_result | no_return when empty_result: any\nmin_max_by(enumerable, fun, empty_fallback \\\\ fn -> raise Enum.EmptyError end)\n\n  Returns a tuple with the minimal and the maximal elements in the\n  enumerable as calculated by the given function.\n\n  If multiple elements are considered maximal or minimal, the first one\n  that was found is returned.\n\n  Calls the provided `empty_fallback` function and returns its value if\n  `enumerable` is empty. The default `empty_fallback` raises `Enum.EmptyError`.\n\n  ## Examples\n\n      iex> Enum.min_max_by([\"aaa\", \"bb\", \"c\"], fn(x) -> String.length(x) end)\n      {\"c\", \"aaa\"}\n\n      iex> Enum.min_max_by([\"aaa\", \"a\", \"bb\", \"c\", \"ccc\"], &String.length/1)\n      {\"a\", \"aaa\"}\n\n      iex> Enum.min_max_by([], &String.lenth/1, fn -> {nil, nil} end)\n      {nil, nil}\n\n  "
    },
    partition = {
      description = "partition(t, (element -> any)) :: {list, list}\npartition(enumerable, fun) when is_function(fun, 1)\nfalse"
    },
    random = {
      description = "random(enumerable)\nrandom(first..last),\nrandom(t) :: element | no_return\nrandom(enumerable)\n\n  Returns a random element of an enumerable.\n\n  Raises `Enum.EmptyError` if `enumerable` is empty.\n\n  This function uses Erlang's [`:rand` module](http://www.erlang.org/doc/man/rand.html) to calculate\n  the random value. Check its documentation for setting a\n  different random algorithm or a different seed.\n\n  The implementation is based on the\n  [reservoir sampling](https://en.wikipedia.org/wiki/Reservoir_sampling#Relation_to_Fisher-Yates_shuffle)\n  algorithm.\n  It assumes that the sample being returned can fit into memory;\n  the input `enumerable` doesn't have to, as it is traversed just once.\n\n  If a range is passed into the function, this function will pick a\n  random value between the range limits, without traversing the whole\n  range (thus executing in constant time and constant memory).\n\n  ## Examples\n\n      # Although not necessary, let's seed the random algorithm\n      iex> :rand.seed(:exsplus, {101, 102, 103})\n      iex> Enum.random([1, 2, 3])\n      2\n      iex> Enum.random([1, 2, 3])\n      1\n      iex> Enum.random(1..1_000)\n      776\n\n  "
    },
    reduce = {
      description = "reduce(function, acc, fun) when is_function(function, 2),\nreduce(map, acc, fun)\nreduce([h | t], {:cont, acc}, fun)\nreduce([],      {:cont, acc}, _fun)\nreduce(list,    {:suspend, acc}, fun)\nreduce(_,       {:halt, acc}, _fun)\nreduce(enumerable, acc, fun) when is_function(fun, 2)\nreduce(%{} = enumerable, acc, fun) when is_function(fun, 2)\nreduce(%{__struct__: _} = enumerable, acc, fun) when is_function(fun, 2)\nreduce(first..last, acc, fun) when is_function(fun, 2)\nreduce(t, any, (element, any -> any)) :: any\nreduce(enumerable, acc, fun) when is_list(enumerable) and is_function(fun, 2)\nreduce(enumerable, fun) when is_function(fun, 2)\nreduce([], _fun)\nreduce([h | t], fun) when is_function(fun, 2)\nreduce(t, (element, any -> any)) :: any\nreduce(enumerable, fun)\n\n  Invokes `fun` for each element in the `enumerable`, passing that\n  element and the accumulator as arguments. `fun`'s return value\n  is stored in the accumulator.\n\n  The first element of the enumerable is used as the initial value of\n  the accumulator.\n  If you wish to use another value for the accumulator, use\n  `Enumerable.reduce/3`.\n  This function won't call the specified function for enumerables that\n  are one-element long.\n\n  Returns the accumulator.\n\n  Note that since the first element of the enumerable is used as the\n  initial value of the accumulator, `fun` will only be executed `n - 1`\n  times where `n` is the length of the enumerable.\n\n  ## Examples\n\n      iex> Enum.reduce([1, 2, 3, 4], fn(x, acc) -> x * acc end)\n      24\n\n  "
    },
    reduce_while = {
      description = "reduce_while(t, any, (element, any -> {:cont, any} | {:halt, any})) :: any\nreduce_while(enumerable, acc, fun) when is_function(fun, 2)\n\n  Reduces the enumerable until `fun` returns `{:halt, term}`.\n\n  The return value for `fun` is expected to be\n\n    * `{:cont, acc}` to continue the reduction with `acc` as the new\n      accumulator or\n    * `{:halt, acc}` to halt the reduction and return `acc` as the return\n      value of this function\n\n  ## Examples\n\n      iex> Enum.reduce_while(1..100, 0, fn i, acc ->\n      ...>   if i < 3, do: {:cont, acc + i}, else: {:halt, acc}\n      ...> end)\n      3\n\n  "
    },
    reject = {
      description = "reject(enumerable, fun) when is_function(fun, 1)\nreject(t, (element -> as_boolean(term))) :: list\nreject(enumerable, fun) when is_list(enumerable) and is_function(fun, 1)\n\n  Returns elements of `enumerable` for which the function `fun` returns\n  `false` or `nil`.\n\n  See also `filter/2`.\n\n  ## Examples\n\n      iex> Enum.reject([1, 2, 3], fn(x) -> rem(x, 2) == 0 end)\n      [1, 3]\n\n  "
    },
    reverse = {
      description = "reverse(enumerable, tail)\nreverse(t, t) :: list\nreverse(enumerable, tail) when is_list(enumerable)\nreverse(t) :: list\nreverse(enumerable)\n\n  Returns a list of elements in `enumerable` in reverse order.\n\n  ## Examples\n\n      iex> Enum.reverse([1, 2, 3])\n      [3, 2, 1]\n\n  "
    },
    reverse_slice = {
      description = "reverse_slice(t, non_neg_integer, non_neg_integer) :: list\nreverse_slice(enumerable, start, count)\n\n  Reverses the enumerable in the range from initial position `start`\n  through `count` elements.\n\n  If `count` is greater than the size of the rest of the enumerable,\n  then this function will reverse the rest of the enumerable.\n\n  ## Examples\n\n      iex> Enum.reverse_slice([1, 2, 3, 4, 5, 6], 2, 4)\n      [1, 2, 6, 5, 4, 3]\n\n  "
    },
    scan = {
      description = "scan(t, any, (element, any -> any)) :: list\nscan(enumerable, acc, fun) when is_function(fun, 2)\nscan(t, (element, any -> any)) :: list\nscan(enumerable, fun) when is_function(fun, 2)\n\n  Applies the given function to each element in the enumerable,\n  storing the result in a list and passing it as the accumulator\n  for the next computation.\n\n  ## Examples\n\n      iex> Enum.scan(1..5, &(&1 + &2))\n      [1, 3, 6, 10, 15]\n\n  "
    },
    shuffle = {
      description = "shuffle(t) :: list\nshuffle(enumerable)\n\n  Returns a list with the elements of `enumerable` shuffled.\n\n  This function uses Erlang's [`:rand` module](http://www.erlang.org/doc/man/rand.html) to calculate\n  the random value. Check its documentation for setting a\n  different random algorithm or a different seed.\n\n  ## Examples\n\n      # Although not necessary, let's seed the random algorithm\n      iex> :rand.seed(:exsplus, {1, 2, 3})\n      iex> Enum.shuffle([1, 2, 3])\n      [2, 1, 3]\n      iex> Enum.shuffle([1, 2, 3])\n      [2, 3, 1]\n\n  "
    },
    slice = {
      description = "slice(enumerable, start, amount)\nslice(enumerable, start, amount)\nslice(first..last, start, amount)\nslice(enumerable, start, amount)\nslice(t, index, non_neg_integer) :: list\nslice(_enumerable, start, 0) when is_integer(start)\nslice(enumerable, first..last)\nslice(t, Range.t) :: list\nslice(enumerable, range)\n\n  Returns a subset list of the given enumerable, from `range.first` to `range.last` positions.\n\n  Given `enumerable`, it drops elements until element position `range.first`,\n  then takes elements until element position `range.last` (inclusive).\n\n  Positions are normalized, meaning that negative positions will be counted from the end\n  (e.g. `-1` means the last element of the enumerable).\n  If `range.last` is out of bounds, then it is assigned as the position of the last element.\n\n  If the normalized `range.first` position is out of bounds of the given enumerable,\n  or this one is greater than the normalized `range.last` position, then `[]` is returned.\n\n  ## Examples\n\n      iex> Enum.slice(1..100, 5..10)\n      [6, 7, 8, 9, 10, 11]\n\n      iex> Enum.slice(1..10, 5..20)\n      [6, 7, 8, 9, 10]\n\n      # last five elements (negative positions)\n      iex> Enum.slice(1..30, -5..-1)\n      [26, 27, 28, 29, 30]\n\n      # last five elements (mixed positive and negative positions)\n      iex> Enum.slice(1..30, 25..-1)\n      [26, 27, 28, 29, 30]\n\n      # out of bounds\n      iex> Enum.slice(1..10, 11..20)\n      []\n\n      # range.first is greater than range.last\n      iex> Enum.slice(1..10, 6..5)\n      []\n\n  "
    },
    sort = {
      description = "sort(enumerable, fun) when is_function(fun, 2)\nsort(t, (element, element -> boolean)) :: list\nsort(enumerable, fun) when is_list(enumerable) and is_function(fun, 2)\nsort(enumerable)\nsort(t) :: list\nsort(enumerable) when is_list(enumerable)\n\n  Sorts the enumerable according to Erlang's term ordering.\n\n  Uses the merge sort algorithm.\n\n  ## Examples\n\n      iex> Enum.sort([3, 2, 1])\n      [1, 2, 3]\n\n  "
    },
    sort_by = {
      description = "sort_by(t, (element -> mapped_element),\nsort_by(enumerable, mapper, sorter \\\\ &<=/2)\n\n  Sorts the mapped results of the enumerable according to the provided `sorter`\n  function.\n\n  This function maps each element of the enumerable using the provided `mapper`\n  function.  The enumerable is then sorted by the mapped elements\n  using the `sorter` function, which defaults to `Kernel.<=/2`\n\n  `sort_by/3` differs from `sort/2` in that it only calculates the\n  comparison value for each element in the enumerable once instead of\n  once for each element in each comparison.\n  If the same function is being called on both element, it's also more\n  compact to use `sort_by/3`.\n\n  This technique is also known as a\n  _[Schwartzian Transform](https://en.wikipedia.org/wiki/Schwartzian_transform)_,\n  or the _Lisp decorate-sort-undecorate idiom_ as the `mapper`\n  is decorating the original `enumerable`; then `sorter` is sorting the\n  decorations; and finally the enumerable is being undecorated so only\n  the original elements remain, but now in sorted order.\n\n  ## Examples\n\n  Using the default `sorter` of `<=/2`:\n\n      iex> Enum.sort_by [\"some\", \"kind\", \"of\", \"monster\"], &byte_size/1\n      [\"of\", \"some\", \"kind\", \"monster\"]\n\n  Using a custom `sorter` to override the order:\n\n      iex> Enum.sort_by [\"some\", \"kind\", \"of\", \"monster\"], &byte_size/1, &>=/2\n      [\"monster\", \"some\", \"kind\", \"of\"]\n\n  "
    },
    split = {
      description = "split(enumerable, count) when count < 0\nsplit(enumerable, count) when count >= 0\nsplit(t, integer) :: {list, list}\nsplit(enumerable, count) when is_list(enumerable) and count >= 0\n\n  Splits the `enumerable` into two enumerables, leaving `count`\n  elements in the first one.\n\n  If `count` is a negative number, it starts counting from the\n  back to the beginning of the enumerable.\n\n  Be aware that a negative `count` implies the `enumerable`\n  will be enumerated twice: once to calculate the position, and\n  a second time to do the actual splitting.\n\n  ## Examples\n\n      iex> Enum.split([1, 2, 3], 2)\n      {[1, 2], [3]}\n\n      iex> Enum.split([1, 2, 3], 10)\n      {[1, 2, 3], []}\n\n      iex> Enum.split([1, 2, 3], 0)\n      {[], [1, 2, 3]}\n\n      iex> Enum.split([1, 2, 3], -1)\n      {[1, 2], [3]}\n\n      iex> Enum.split([1, 2, 3], -5)\n      {[], [1, 2, 3]}\n\n  "
    },
    split_while = {
      description = "split_while(enumerable, fun) when is_function(fun, 1)\nsplit_while(t, (element -> as_boolean(term))) :: {list, list}\nsplit_while(enumerable, fun) when is_list(enumerable) and is_function(fun, 1)\n\n  Splits enumerable in two at the position of the element for which\n  `fun` returns `false` for the first time.\n\n  ## Examples\n\n      iex> Enum.split_while([1, 2, 3, 4], fn(x) -> x < 3 end)\n      {[1, 2], [3, 4]}\n\n  "
    },
    split_with = {
      description = "split_with(t, (element -> any)) :: {list, list}\nsplit_with(enumerable, fun) when is_function(fun, 1)\n\n  Splits the `enumerable` in two lists according to the given function `fun`.\n\n  Splits the given `enumerable` in two lists by calling `fun` with each element\n  in the `enumerable` as its only argument. Returns a tuple with the first list\n  containing all the elements in `enumerable` for which applying `fun` returned\n  a truthy value, and a second list with all the elements for which applying\n  `fun` returned a falsey value (`false` or `nil`).\n\n  The elements in both the returned lists are in the same relative order as they\n  were in the original enumerable (if such enumerable was ordered, e.g., a\n  list); see the examples below.\n\n  ## Examples\n\n      iex> Enum.split_with([5, 4, 3, 2, 1, 0], fn(x) -> rem(x, 2) == 0 end)\n      {[4, 2, 0], [5, 3, 1]}\n\n      iex> Enum.split_with(%{a: 1, b: -2, c: 1, d: -3}, fn({_k, v}) -> v < 0 end)\n      {[b: -2, d: -3], [a: 1, c: 1]}\n\n      iex> Enum.split_with(%{a: 1, b: -2, c: 1, d: -3}, fn({_k, v}) -> v > 50 end)\n      {[], [a: 1, b: -2, c: 1, d: -3]}\n\n      iex> Enum.split_with(%{}, fn({_k, v}) -> v > 50 end)\n      {[], []}\n\n  "
    },
    sum = {
      description = "sum(enumerable)\nsum(first..last) when last > first\nsum(first..last) when last < first,\nsum(first..first),\nsum(t) :: number\nsum(enumerable)\n\n  Returns the sum of all elements.\n\n  Raises `ArithmeticError` if `enumerable` contains a non-numeric value.\n\n  ## Examples\n\n      iex> Enum.sum([1, 2, 3])\n      6\n\n  "
    },
    t = {
      description = "t :: Enumerable.t\n\n  A partially applied reduce function.\n\n  The continuation is the closure returned as a result when\n  the enumeration is suspended. When invoked, it expects\n  a new accumulator and it returns the result.\n\n  A continuation is easily implemented as long as the reduce\n  function is defined in a tail recursive fashion. If the function\n  is tail recursive, all the state is passed as arguments, so\n  the continuation would simply be the reducing function partially\n  applied.\n  "
    },
    take = {
      description = "take(enumerable, count) when is_integer(count) and count < 0\ntake(enumerable, count) when is_integer(count) and count > 0\ntake(enumerable, count)\ntake([], _count)\ntake(_enumerable, 0)\ntake(t, integer) :: list\ntake(enumerable, count)\n\n  Takes the first `count` items from the enumerable.\n\n  `count` must be an integer. If a negative `count` is given, the last\n  `count` values will be taken.\n  For such, the enumerable is fully enumerated keeping up\n  to `2 * count` elements in memory. Once the end of the enumerable is\n  reached, the last `count` elements are returned.\n\n  ## Examples\n\n      iex> Enum.take([1, 2, 3], 2)\n      [1, 2]\n\n      iex> Enum.take([1, 2, 3], 10)\n      [1, 2, 3]\n\n      iex> Enum.take([1, 2, 3], 0)\n      []\n\n      iex> Enum.take([1, 2, 3], -1)\n      [3]\n\n  "
    },
    take_every = {
      description = "take_every(enumerable, nth) when is_integer(nth) and nth > 1\ntake_every([], nth) when is_integer(nth) and nth > 1\ntake_every(_enumerable, 0)\ntake_every(enumerable, 1)\ntake_every(t, non_neg_integer) :: list\ntake_every(enumerable, nth)\n\n  Returns a list of every `nth` item in the enumerable,\n  starting with the first element.\n\n  The first item is always included, unless `nth` is 0.\n\n  The second argument specifying every `nth` item must be a non-negative\n  integer.\n\n  ## Examples\n\n      iex> Enum.take_every(1..10, 2)\n      [1, 3, 5, 7, 9]\n\n      iex> Enum.take_every(1..10, 0)\n      []\n\n      iex> Enum.take_every([1, 2, 3], 1)\n      [1, 2, 3]\n\n  "
    },
    take_random = {
      description = "take_random(enumerable, count) when is_integer(count) and count > 0\ntake_random(enumerable, count) when is_integer(count) and count > 128\ntake_random(first..first, count) when is_integer(count) and count >= 1,\ntake_random(_enumerable, 0),\ntake_random(t, non_neg_integer) :: list\ntake_random(enumerable, count)\n\n  Takes `count` random items from `enumerable`.\n\n  Notice this function will traverse the whole `enumerable` to\n  get the random sublist.\n\n  See `random/1` for notes on implementation and random seed.\n\n  ## Examples\n\n      # Although not necessary, let's seed the random algorithm\n      iex> :rand.seed(:exsplus, {1, 2, 3})\n      iex> Enum.take_random(1..10, 2)\n      [5, 4]\n      iex> Enum.take_random(?a..?z, 5)\n      'ipybz'\n\n  "
    },
    take_while = {
      description = "take_while(enumerable, fun) when is_function(fun, 1)\ntake_while(t, (element -> as_boolean(term))) :: list\ntake_while(enumerable, fun) when is_list(enumerable) and is_function(fun, 1)\n\n  Takes the items from the beginning of the enumerable while `fun` returns\n  a truthy value.\n\n  ## Examples\n\n      iex> Enum.take_while([1, 2, 3], fn(x) -> x < 3 end)\n      [1, 2]\n\n  "
    },
    to_list = {
      description = "to_list(enumerable)\nto_list(t) :: [element]\nto_list(enumerable) when is_list(enumerable)\n\n  Converts `enumerable` to a list.\n\n  ## Examples\n\n      iex> Enum.to_list(1..3)\n      [1, 2, 3]\n\n  "
    },
    uniq = {
      description = "uniq(enumerable, fun)\nuniq(t) :: list\nuniq(enumerable)\n\n  Enumerates the `enumerable`, removing all duplicated elements.\n\n  ## Examples\n\n      iex> Enum.uniq([1, 2, 3, 3, 2, 1])\n      [1, 2, 3]\n\n  "
    },
    uniq_by = {
      description = "uniq_by(enumerable, fun) when is_function(fun, 1)\nuniq_by(t, (element -> term)) :: list\nuniq_by(enumerable, fun) when is_list(enumerable) and is_function(fun, 1)\n\n  Enumerates the `enumerable`, by removing the elements for which\n  function `fun` returned duplicate items.\n\n  The function `fun` maps every element to a term which is used to\n  determine if two elements are duplicates.\n\n  The first occurrence of each element is kept.\n\n  ## Example\n\n      iex> Enum.uniq_by([{1, :x}, {2, :y}, {1, :z}], fn {x, _} -> x end)\n      [{1, :x}, {2, :y}]\n\n      iex> Enum.uniq_by([a: {:tea, 2}, b: {:tea, 2}, c: {:coffee, 1}], fn {_, y} -> y end)\n      [a: {:tea, 2}, c: {:coffee, 1}]\n\n  "
    },
    unzip = {
      description = "unzip(t) :: {[element], [element]}\nunzip(enumerable)\n\n  Opposite of `Enum.zip/2`; extracts a two-element tuples from the\n  enumerable and groups them together.\n\n  It takes an enumerable with items being two-element tuples and returns\n  a tuple with two lists, each of which is formed by the first and\n  second element of each tuple, respectively.\n\n  This function fails unless `enumerable` is or can be converted into a\n  list of tuples with *exactly* two elements in each tuple.\n\n  ## Examples\n\n      iex> Enum.unzip([{:a, 1}, {:b, 2}, {:c, 3}])\n      {[:a, :b, :c], [1, 2, 3]}\n\n      iex> Enum.unzip(%{a: 1, b: 2})\n      {[:a, :b], [1, 2]}\n\n  "
    },
    with_index = {
      description = "with_index(t, integer) :: [{element, index}]\nwith_index(enumerable, offset \\\\ 0)\n\n  Returns the enumerable with each element wrapped in a tuple\n  alongside its index.\n\n  If an `offset` is given, we will index from the given offset instead of from zero.\n\n  ## Examples\n\n      iex> Enum.with_index([:a, :b, :c])\n      [a: 0, b: 1, c: 2]\n\n      iex> Enum.with_index([:a, :b, :c], 3)\n      [a: 3, b: 4, c: 5]\n\n  "
    },
    zip = {
      description = "zip(enumerables)\nzip([t]) :: t\nzip([])\nzip(enumerable1, enumerable2)\nzip(t, t) :: [{any, any}]\nzip(enumerable1, enumerable2)\n\n  Zips corresponding elements from two enumerables into one list\n  of tuples.\n\n  The zipping finishes as soon as any enumerable completes.\n\n  ## Examples\n\n      iex> Enum.zip([1, 2, 3], [:a, :b, :c])\n      [{1, :a}, {2, :b}, {3, :c}]\n\n      iex> Enum.zip([1, 2, 3, 4, 5], [:a, :b, :c])\n      [{1, :a}, {2, :b}, {3, :c}]\n\n  "
    }
  },
  Enumerable = {
    acc = {
      description = "acc :: {:cont, term} | {:halt, term} | {:suspend, term}\n\n  The accumulator value for each step.\n\n  It must be a tagged tuple with one of the following \"tags\":\n\n    * `:cont`    - the enumeration should continue\n    * `:halt`    - the enumeration should halt immediately\n    * `:suspend` - the enumeration should be suspended immediately\n\n  Depending on the accumulator value, the result returned by\n  `Enumerable.reduce/3` will change. Please check the `t:result/0`\n  type documentation for more information.\n\n  In case a `t:reducer/0` function returns a `:suspend` accumulator,\n  it must be explicitly handled by the caller and never leak.\n  "
    },
    continuation = {
      description = "continuation :: (acc -> result)\n\n  A partially applied reduce function.\n\n  The continuation is the closure returned as a result when\n  the enumeration is suspended. When invoked, it expects\n  a new accumulator and it returns the result.\n\n  A continuation is easily implemented as long as the reduce\n  function is defined in a tail recursive fashion. If the function\n  is tail recursive, all the state is passed as arguments, so\n  the continuation would simply be the reducing function partially\n  applied.\n  "
    },
    count = {
      description = "count(t) :: {:ok, non_neg_integer} | {:error, module}\ncount(enumerable)\n\n  Retrieves the enumerable's size.\n\n  It should return `{:ok, size}`.\n\n  If `{:error, __MODULE__}` is returned a default algorithm using\n  `reduce` and the match (`===`) operator is used. This algorithm runs\n  in linear time.\n\n  _Please force use of the default algorithm unless you can implement an\n  algorithm that is significantly faster._\n  "
    },
    description = "\n  Enumerable protocol used by `Enum` and `Stream` modules.\n\n  When you invoke a function in the `Enum` module, the first argument\n  is usually a collection that must implement this protocol.\n  For example, the expression:\n\n      Enum.map([1, 2, 3], &(&1 * 2))\n\n  invokes `Enumerable.reduce/3` to perform the reducing\n  operation that builds a mapped list by calling the mapping function\n  `&(&1 * 2)` on every element in the collection and consuming the\n  element with an accumulated list.\n\n  Internally, `Enum.map/2` is implemented as follows:\n\n      def map(enum, fun) do\n        reducer = fn x, acc -> {:cont, [fun.(x) | acc]} end\n        Enumerable.reduce(enum, {:cont, []}, reducer) |> elem(1) |> :lists.reverse()\n      end\n\n  Notice the user-supplied function is wrapped into a `t:reducer/0` function.\n  The `t:reducer/0` function must return a tagged tuple after each step,\n  as described in the `t:acc/0` type.\n\n  The reason the accumulator requires a tagged tuple is to allow the\n  `t:reducer/0` function to communicate the end of enumeration to the underlying\n  enumerable, allowing any open resources to be properly closed.\n  It also allows suspension of the enumeration, which is useful when\n  interleaving between many enumerables is required (as in zip).\n\n  Finally, `Enumerable.reduce/3` will return another tagged tuple,\n  as represented by the `t:result/0` type.\n  ",
    ["member?"] = {
      description = "member?(t, term) :: {:ok, boolean} | {:error, module}\nmember?(enumerable, element)\n\n  Checks if an element exists within the enumerable.\n\n  It should return `{:ok, boolean}`.\n\n  If `{:error, __MODULE__}` is returned a default algorithm using\n  `reduce` and the match (`===`) operator is used. This algorithm runs\n  in linear time.\n\n  _Please force use of the default algorithm unless you can implement an\n  algorithm that is significantly faster._\n  "
    },
    reduce = {
      description = "reduce(t, acc, reducer) :: result\nreduce(enumerable, acc, fun)\n\n  Reduces the enumerable into an element.\n\n  Most of the operations in `Enum` are implemented in terms of reduce.\n  This function should apply the given `t:reducer/0` function to each\n  item in the enumerable and proceed as expected by the returned\n  accumulator.\n\n  As an example, here is the implementation of `reduce` for lists:\n\n      def reduce(_,       {:halt, acc}, _fun),   do: {:halted, acc}\n      def reduce(list,    {:suspend, acc}, fun), do: {:suspended, acc, &reduce(list, &1, fun)}\n      def reduce([],      {:cont, acc}, _fun),   do: {:done, acc}\n      def reduce([h | t], {:cont, acc}, fun),    do: reduce(t, fun.(h, acc), fun)\n\n  "
    },
    reducer = {
      description = "reducer :: (term, term -> acc)\n\n  The reducer function.\n\n  Should be called with the enumerable element and the\n  accumulator contents.\n\n  Returns the accumulator for the next enumeration step.\n  "
    },
    result = {
      description = "result :: {:done, term} |\n\n  The result of the reduce operation.\n\n  It may be *done* when the enumeration is finished by reaching\n  its end, or *halted*/*suspended* when the enumeration was halted\n  or suspended by the `t:reducer/0` function.\n\n  In case a `t:reducer/0` function returns the `:suspend` accumulator, the\n  `:suspended` tuple must be explicitly handled by the caller and\n  never leak. In practice, this means regular enumeration functions\n  just need to be concerned about `:done` and `:halted` results.\n\n  Furthermore, a `:suspend` call must always be followed by another call,\n  eventually halting or continuing until the end.\n  "
    }
  },
  ErlangError = {
    message = {
      description = "message(exception)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    },
    normalize = {
      description = "normalize(other, _stacktrace)\nnormalize({:badarg, payload}, _stacktrace)\nnormalize(:function_clause, stacktrace)\nnormalize(:undef, stacktrace)\nnormalize({:try_clause, term}, _stacktrace)\nnormalize({:with_clause, term}, _stacktrace)\nnormalize({:case_clause, term}, _stacktrace)\nnormalize({:badkey, key, map}, _stacktrace)\nnormalize({:badkey, key}, stacktrace)\nnormalize({:badbool, op, term}, _stacktrace)\nnormalize({:badmap, term}, _stacktrace)\nnormalize({:badmatch, term}, _stacktrace)\nnormalize({:badstruct, struct, term}, _stacktrace)\nnormalize({:badfun, term}, _stacktrace)\nnormalize({:badarity, {fun, args}}, _stacktrace)\nnormalize(:cond_clause, _stacktrace)\nnormalize(:system_limit, _stacktrace)\nnormalize(:badarith, _stacktrace)\nnormalize(:badarg, _stacktrace)\nfalse"
    }
  },
  ErrorHandler = {
    description = "false",
    ensure_compiled = {
      description = "ensure_compiled(module, kind)\nensure_compiled(module, atom) :: boolean\nensure_compiled(nil, _kind)\n"
    },
    ensure_loaded = {
      description = "ensure_loaded(module) :: boolean\nensure_loaded(module)\n"
    },
    undefined_function = {
      description = "undefined_function(module, atom, list) :: term\nundefined_function(module, fun, args)\n"
    },
    undefined_lambda = {
      description = "undefined_lambda(module, fun, list) :: term\nundefined_lambda(module, fun, args)\n"
    }
  },
  Exception = {
    description = "\n  Functions to format throw/catch/exit and exceptions.\n\n  Note that stacktraces in Elixir are updated on throw,\n  errors and exits. For example, at any given moment,\n  `System.stacktrace/0` will return the stacktrace for the\n  last throw/error/exit that occurred in the current process.\n\n  Do not rely on the particular format returned by the `format*`\n  functions in this module. They may be changed in future releases\n  in order to better suit Elixir's tool chain. In other words,\n  by using the functions in this module it is guaranteed you will\n  format exceptions as in the current Elixir version being used.\n  ",
    ["exception?"] = {
      description = "exception?(_)\nexception?(%{__struct__: struct, __exception__: true}) when is_atom(struct),\nexception?(term)\n\n  Returns `true` if the given `term` is an exception.\n  "
    },
    format = {
      description = "format(kind, payload, stacktrace)\nformat({:EXIT, _} = kind, any, _)\nformat(kind, any, stacktrace | nil) :: String.t\nformat(kind, payload, stacktrace \\\\ nil)\n\n  Normalizes and formats throw/errors/exits and stacktraces.\n\n  It relies on `format_banner/3` and `format_stacktrace/1`\n  to generate the final format.\n\n  Note that `{:EXIT, pid}` do not generate a stacktrace though\n  (as they are retrieved as messages without stacktraces).\n  "
    },
    format_banner = {
      description = "format_banner({:EXIT, pid}, reason, _stacktrace)\nformat_banner(:exit, reason, _stacktrace)\nformat_banner(:throw, reason, _stacktrace)\nformat_banner(:error, exception, stacktrace)\nformat_banner(kind, any, stacktrace | nil) :: String.t\nformat_banner(kind, exception, stacktrace \\\\ nil)\n\n  Normalizes and formats any throw/error/exit.\n\n  The message is formatted and displayed in the same\n  format as used by Elixir's CLI.\n\n  The third argument, a stacktrace, is optional. If it is\n  not supplied `System.stacktrace/0` will sometimes be used\n  to get additional information for the `kind` `:error`. If\n  the stacktrace is unknown and `System.stacktrace/0` would\n  not return the stacktrace corresponding to the exception\n  an empty stacktrace, `[]`, must be used.\n  "
    },
    format_exit = {
      description = "format_exit(any) :: String.t\nformat_exit(reason)\n\n  Formats an exit. It returns a string.\n\n  Often there are errors/exceptions inside exits. Exits are often\n  wrapped by the caller and provide stacktraces too. This function\n  formats exits in a way to nicely show the exit reason, caller\n  and stacktrace.\n  "
    },
    format_fa = {
      description = "format_fa(fun, arity) when is_function(fun)\n\n  Receives an anonymous function and arity and formats it as\n  shown in stacktraces. The arity may also be a list of arguments.\n\n  ## Examples\n\n      Exception.format_fa(fn -> nil end, 1)\n      #=> \"#Function<...>/1\"\n\n  "
    },
    format_file_line = {
      description = "format_file_line(file, line, suffix \\\\ \"\")\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    },
    format_mfa = {
      description = "format_mfa(module, fun, arity) when is_atom(module) and is_atom(fun)\n\n  Receives a module, fun and arity and formats it\n  as shown in stacktraces. The arity may also be a list\n  of arguments.\n\n  ## Examples\n\n      iex> Exception.format_mfa Foo, :bar, 1\n      \"Foo.bar/1\"\n\n      iex> Exception.format_mfa Foo, :bar, []\n      \"Foo.bar()\"\n\n      iex> Exception.format_mfa nil, :bar, []\n      \"nil.bar()\"\n\n  Anonymous functions are reported as -func/arity-anonfn-count-,\n  where func is the name of the enclosing function. Convert to\n  \"anonymous fn in func/arity\"\n  "
    },
    format_stacktrace = {
      description = "format_stacktrace(trace \\\\ nil)\n\n  Formats the stacktrace.\n\n  A stacktrace must be given as an argument. If not, the stacktrace\n  is retrieved from `Process.info/2`.\n  "
    },
    format_stacktrace_entry = {
      description = "format_stacktrace_entry({fun, arity, location})\nformat_stacktrace_entry({module, fun, arity, location})\nformat_stacktrace_entry({_module, :__FILE__, 1, location})\nformat_stacktrace_entry({_module, :__MODULE__, 1, location})\nformat_stacktrace_entry({module, :__MODULE__, 0, location})\nformat_stacktrace_entry(stacktrace_entry) :: String.t\nformat_stacktrace_entry(entry)\n\n  Receives a stacktrace entry and formats it into a string.\n  "
    },
    kind = {
      description = "kind :: :error | :exit | :throw | {:EXIT, pid}\n"
    },
    message = {
      description = "message(%{__struct__: module, __exception__: true} = exception) when is_atom(module)\n\n  Gets the message for an `exception`.\n  "
    },
    normalize = {
      description = "normalize(_kind, payload, _stacktrace)\nnormalize(:error, exception, stacktrace)\nnormalize(kind, payload, stacktrace) :: payload when payload: var\nnormalize(kind, payload, stacktrace \\\\ nil)\n\n  Normalizes an exception, converting Erlang exceptions\n  to Elixir exceptions.\n\n  It takes the `kind` spilled by `catch` as an argument and\n  normalizes only `:error`, returning the untouched payload\n  for others.\n\n  The third argument, a stacktrace, is optional. If it is\n  not supplied `System.stacktrace/0` will sometimes be used\n  to get additional information for the `kind` `:error`. If\n  the stacktrace is unknown and `System.stacktrace/0` would\n  not return the stacktrace corresponding to the exception\n  an empty stacktrace, `[]`, must be used.\n  "
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
        description = "message(exception)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
      }
    },
    Error = {
      message = {
        description = "message(%{action: action, reason: reason, path: path})\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
      }
    },
    Stat = {
      description = "\n  A struct that holds file information.\n\n  In Erlang, this struct is represented by a `:file_info` record.\n  Therefore this module also provides functions for converting\n  between the Erlang record and the Elixir struct.\n\n  Its fields are:\n\n    * `size` - size of file in bytes.\n\n    * `type` - `:device | :directory | :regular | :other`; the type of the\n      file.\n\n    * `access` - `:read | :write | :read_write | :none`; the current system\n      access to the file.\n\n    * `atime` - the last time the file was read.\n\n    * `mtime` - the last time the file was written.\n\n    * `ctime` - the interpretation of this time field depends on the operating\n      system. On Unix, it is the last time the file or the inode was changed.\n      In Windows, it is the time of creation.\n\n    * `mode` - the file permissions.\n\n    * `links` - the number of links to this file. This is always 1 for file\n      systems which have no concept of links.\n\n    * `major_device` - identifies the file system where the file is located.\n      In Windows, the number indicates a drive as follows: 0 means A:, 1 means\n      B:, and so on.\n\n    * `minor_device` - only valid for character devices on Unix. In all other\n      cases, this field is zero.\n\n    * `inode` - gives the inode number. On non-Unix file systems, this field\n      will be zero.\n\n    * `uid` - indicates the owner of the file. Will be zero for non-Unix file\n      systems.\n\n    * `gid` - indicates the group that owns the file. Will be zero for\n      non-Unix file systems.\n\n  The time type returned in `atime`, `mtime`, and `ctime` is dependent on the\n  time type set in options. `{:time, type}` where type can be `:local`,\n  `:universal`, or `:posix`. Default is `:universal`.\n  ",
      from_record = {
        description = "from_record({:file_info, unquote_splicing(vals)})\nfrom_record(file_info)\n\n  Converts a `:file_info` record into a `File.Stat`.\n  "
      },
      t = {
        description = "t :: %__MODULE__{}\n"
      },
      to_record = {
        description = "to_record(%File.Stat{unquote_splicing(pairs)})\n\n  Converts a `File.Stat` struct to a `:file_info` record.\n  "
      }
    },
    Stream = {
      __build__ = {
        description = "__build__(path, modes, line_or_bytes)\nfalse"
      },
      count = {
        description = "count(%{path: path, line_or_bytes: bytes})\ncount(%{path: path, modes: modes, line_or_bytes: :line} = stream)\nfalse"
      },
      description = "\n  Defines a `File.Stream` struct returned by `File.stream!/3`.\n\n  The following fields are public:\n\n    * `path`          - the file path\n    * `modes`         - the file modes\n    * `raw`           - a boolean indicating if bin functions should be used\n    * `line_or_bytes` - if reading should read lines or a given amount of bytes\n\n  ",
      into = {
        description = "into(%{path: path, modes: modes, raw: raw} = stream)\nfalse"
      },
      ["member?"] = {
        description = "member?(_stream, _term)\nfalse"
      },
      reduce = {
        description = "reduce(%{path: path, modes: modes, line_or_bytes: line_or_bytes, raw: raw}, acc, fun)\nfalse"
      },
      t = {
        description = "t :: %__MODULE__{}\n"
      }
    },
    cd = {
      description = "cd(Path.t) :: :ok | {:error, posix}\ncd(path)\n\n  Sets the current working directory.\n\n  Returns `:ok` if successful, `{:error, reason}` otherwise.\n  "
    },
    ["cd!"] = {
      description = "cd!(Path.t, (() -> res)) :: res | no_return when res: var\ncd!(path, function)\ncd!(Path.t) :: :ok | no_return\ncd!(path)\n\n  The same as `cd/1`, but raises an exception if it fails.\n  "
    },
    chgrp = {
      description = "chgrp(Path.t, non_neg_integer) :: :ok | {:error, posix}\nchgrp(path, gid)\n\n  Changes the group given by the group id `gid`\n  for a given `file`. Returns `:ok` on success, or\n  `{:error, reason}` on failure.\n  "
    },
    ["chgrp!"] = {
      description = "chgrp!(Path.t, non_neg_integer) :: :ok | no_return\nchgrp!(path, gid)\n\n  Same as `chgrp/2`, but raises an exception in case of failure. Otherwise `:ok`.\n  "
    },
    chmod = {
      description = "chmod(Path.t, non_neg_integer) :: :ok | {:error, posix}\nchmod(path, mode)\n\n  Changes the `mode` for a given `file`.\n\n  Returns `:ok` on success, or `{:error, reason}` on failure.\n\n  ## Permissions\n\n    * 0o400 - read permission: owner\n    * 0o200 - write permission: owner\n    * 0o100 - execute permission: owner\n\n    * 0o040 - read permission: group\n    * 0o020 - write permission: group\n    * 0o010 - execute permission: group\n\n    * 0o004 - read permission: other\n    * 0o002 - write permission: other\n    * 0o001 - execute permission: other\n\n  For example, setting the mode 0o755 gives it\n  write, read and execute permission to the owner\n  and both read and execute permission to group\n  and others.\n  "
    },
    ["chmod!"] = {
      description = "chmod!(Path.t, non_neg_integer) :: :ok | no_return\nchmod!(path, mode)\n\n  Same as `chmod/2`, but raises an exception in case of failure. Otherwise `:ok`.\n  "
    },
    chown = {
      description = "chown(Path.t, non_neg_integer) :: :ok | {:error, posix}\nchown(path, uid)\n\n  Changes the owner given by the user id `uid`\n  for a given `file`. Returns `:ok` on success,\n  or `{:error, reason}` on failure.\n  "
    },
    ["chown!"] = {
      description = "chown!(Path.t, non_neg_integer) :: :ok | no_return\nchown!(path, uid)\n\n  Same as `chown/2`, but raises an exception in case of failure. Otherwise `:ok`.\n  "
    },
    close = {
      description = "close(io_device) :: :ok | {:error, posix | :badarg | :terminated}\nclose(io_device)\n\n  Closes the file referenced by `io_device`. It mostly returns `:ok`, except\n  for some severe errors such as out of memory.\n\n  Note that if the option `:delayed_write` was used when opening the file,\n  `close/1` might return an old write error and not even try to close the file.\n  See `open/2` for more information.\n  "
    },
    copy = {
      description = "copy(Path.t | io_device, Path.t | io_device, pos_integer | :infinity) :: {:ok, non_neg_integer} | {:error, posix}\ncopy(source, destination, bytes_count \\\\ :infinity)\n\n  Copies the contents of `source` to `destination`.\n\n  Both parameters can be a filename or an IO device opened\n  with `open/2`. `bytes_count` specifies the number of\n  bytes to copy, the default being `:infinity`.\n\n  If file `destination` already exists, it is overwritten\n  by the contents in `source`.\n\n  Returns `{:ok, bytes_copied}` if successful,\n  `{:error, reason}` otherwise.\n\n  Compared to the `cp/3`, this function is more low-level,\n  allowing a copy from device to device limited by a number of\n  bytes. On the other hand, `cp/3` performs more extensive\n  checks on both source and destination and it also preserves\n  the file mode after copy.\n\n  Typical error reasons are the same as in `open/2`,\n  `read/1` and `write/3`.\n  "
    },
    ["copy!"] = {
      description = "copy!(Path.t | io_device, Path.t | io_device, pos_integer | :infinity) :: non_neg_integer | no_return\ncopy!(source, destination, bytes_count \\\\ :infinity)\n\n  The same as `copy/3` but raises an `File.CopyError` if it fails.\n  Returns the `bytes_copied` otherwise.\n  "
    },
    cp = {
      description = "cp(Path.t, Path.t, (Path.t, Path.t -> boolean)) :: :ok | {:error, posix}\ncp(source, destination, callback \\\\ fn(_, _) -> true end)\n\n  Copies the contents in `source` to `destination` preserving its mode.\n\n  If a file already exists in the destination, it invokes a\n  callback which should return `true` if the existing file\n  should be overwritten, `false` otherwise. The callback defaults to return `true`.\n\n  The function returns `:ok` in case of success, returns\n  `{:error, reason}` otherwise.\n\n  If you want to copy contents from an IO device to another device\n  or do a straight copy from a source to a destination without\n  preserving modes, check `copy/3` instead.\n\n  Note: The command `cp` in Unix systems behaves differently depending\n  if `destination` is an existing directory or not. We have chosen to\n  explicitly disallow this behaviour. If destination is a directory, an\n  error will be returned.\n  "
    },
    ["cp!"] = {
      description = "cp!(Path.t, Path.t, (Path.t, Path.t -> boolean)) :: :ok | no_return\ncp!(source, destination, callback \\\\ fn(_, _) -> true end)\n\n  The same as `cp/3`, but raises `File.CopyError` if it fails.\n  Returns `:ok` otherwise.\n  "
    },
    cp_r = {
      description = "cp_r(Path.t, Path.t, (Path.t, Path.t -> boolean)) :: {:ok, [binary]} | {:error, posix, binary}\ncp_r(source, destination, callback \\\\ fn(_, _) -> true end) when is_function(callback)\n\n  Copies the contents in source to destination.\n\n  If the source is a file, it copies `source` to\n  `destination`. If the source is a directory, it copies\n  the contents inside source into the destination.\n\n  If a file already exists in the destination,\n  it invokes a callback which should return\n  `true` if the existing file should be overwritten,\n  `false` otherwise. The callback defaults to return `true`.\n\n  If a directory already exists in the destination\n  where a file is meant to be (or vice versa), this\n  function will fail.\n\n  This function may fail while copying files,\n  in such cases, it will leave the destination\n  directory in a dirty state, where file which have already been copied\n  won't be removed.\n\n  The function returns `{:ok, files_and_directories}` in case of\n  success, `files_and_directories` lists all files and directories copied in no\n  specific order. It returns `{:error, reason, file}` otherwise.\n\n  Note: The command `cp` in Unix systems behaves differently\n  depending if `destination` is an existing directory or not.\n  We have chosen to explicitly disallow this behaviour.\n\n  ## Examples\n\n      # Copies file \"a.txt\" to \"b.txt\"\n      File.cp_r \"a.txt\", \"b.txt\"\n\n      # Copies all files in \"samples\" to \"tmp\"\n      File.cp_r \"samples\", \"tmp\"\n\n      # Same as before, but asks the user how to proceed in case of conflicts\n      File.cp_r \"samples\", \"tmp\", fn(source, destination) ->\n        IO.gets(\"Overwriting #{destination} by #{source}. Type y to confirm. \") == \"y\\n\"\n      end\n\n  "
    },
    ["cp_r!"] = {
      description = "cp_r!(Path.t, Path.t, (Path.t, Path.t -> boolean)) :: [binary] | no_return\ncp_r!(source, destination, callback \\\\ fn(_, _) -> true end)\n\n  The same as `cp_r/3`, but raises `File.CopyError` if it fails.\n  Returns the list of copied files otherwise.\n  "
    },
    cwd = {
      description = "cwd() :: {:ok, binary} | {:error, posix}\ncwd()\n\n  Gets the current working directory.\n\n  In rare circumstances, this function can fail on Unix. It may happen\n  if read permissions do not exist for the parent directories of the\n  current directory. For this reason, returns `{:ok, cwd}` in case\n  of success, `{:error, reason}` otherwise.\n  "
    },
    ["cwd!"] = {
      description = "cwd!() :: binary | no_return\ncwd!()\n\n  The same as `cwd/0`, but raises an exception if it fails.\n  "
    },
    description = "\n  This module contains functions to manipulate files.\n\n  Some of those functions are low-level, allowing the user\n  to interact with files or IO devices, like `open/2`,\n  `copy/3` and others. This module also provides higher\n  level functions that work with filenames and have their naming\n  based on UNIX variants. For example, one can copy a file\n  via `cp/3` and remove files and directories recursively\n  via `rm_rf/1`.\n\n  Paths given to functions in this module can be either relative to the\n  current working directory (as returned by `File.cwd/0`), or absolute\n  paths. Shell conventions like `~` are not expanded automatically.\n  To use paths like `~/Downloads`, you can use `Path.expand/1` or\n  `Path.expand/2` to expand your path to an absolute path.\n\n  ## Encoding\n\n  In order to write and read files, one must use the functions\n  in the `IO` module. By default, a file is opened in binary mode,\n  which requires the functions `IO.binread/2` and `IO.binwrite/2`\n  to interact with the file. A developer may pass `:utf8` as an\n  option when opening the file, then the slower `IO.read/2` and\n  `IO.write/2` functions must be used as they are responsible for\n  doing the proper conversions and providing the proper data guarantees.\n\n  Note that filenames when given as charlists in Elixir are\n  always treated as UTF-8. In particular, we expect that the\n  shell and the operating system are configured to use UTF-8\n  encoding. Binary filenames are considered raw and passed\n  to the OS as is.\n\n  ## API\n\n  Most of the functions in this module return `:ok` or\n  `{:ok, result}` in case of success, `{:error, reason}`\n  otherwise. Those functions also have a variant\n  that ends with `!` which returns the result (instead of the\n  `{:ok, result}` tuple) in case of success or raises an\n  exception in case it fails. For example:\n\n      File.read(\"hello.txt\")\n      #=> {:ok, \"World\"}\n\n      File.read(\"invalid.txt\")\n      #=> {:error, :enoent}\n\n      File.read!(\"hello.txt\")\n      #=> \"World\"\n\n      File.read!(\"invalid.txt\")\n      #=> raises File.Error\n\n  In general, a developer should use the former in case they want\n  to react if the file does not exist. The latter should be used\n  when the developer expects their software to fail in case the\n  file cannot be read (i.e. it is literally an exception).\n\n  ## Processes and raw files\n\n  Every time a file is opened, Elixir spawns a new process. Writing\n  to a file is equivalent to sending messages to the process that\n  writes to the file descriptor.\n\n  This means files can be passed between nodes and message passing\n  guarantees they can write to the same file in a network.\n\n  However, you may not always want to pay the price for this abstraction.\n  In such cases, a file can be opened in `:raw` mode. The options `:read_ahead`\n  and `:delayed_write` are also useful when operating on large files or\n  working with files in tight loops.\n\n  Check [`:file.open/2`](http://www.erlang.org/doc/man/file.html#open-2) for more information\n  about such options and other performance considerations.\n  ",
    ["dir?"] = {
      description = "dir?(Path.t) :: boolean\ndir?(path)\n\n  Returns `true` if the given path is a directory.\n\n  ## Examples\n\n      File.dir(\"./test\")\n      #=> true\n\n      File.dir(\"test\")\n      #=> true\n\n      File.dir(\"/usr/bin\")\n      #=> true\n\n      File.dir(\"~/Downloads\")\n      #=> false\n\n      \"~/Downloads\" |> Path.expand |> File.dir?\n      #=> true\n\n  "
    },
    ["exists?"] = {
      description = "exists?(Path.t) :: boolean\nexists?(path)\n\n  Returns `true` if the given path exists.\n  It can be regular file, directory, socket,\n  symbolic link, named pipe or device file.\n\n  ## Examples\n\n      File.exists?(\"test/\")\n      #=> true\n\n      File.exists?(\"missing.txt\")\n      #=> false\n\n      File.exists?(\"/dev/null\")\n      #=> true\n\n  "
    },
    io_device = {
      description = "io_device :: :file.io_device()\n"
    },
    ln_s = {
      description = "ln_s(existing, new)\n\n  Creates a symbolic link `new` to the file or directory `existing`.\n\n  Returns `:ok` if successful, `{:error, reason}` otherwise.\n  If the operating system does not support symlinks, returns\n  `{:error, :enotsup}`.\n  "
    },
    ls = {
      description = "ls(Path.t) :: {:ok, [binary]} | {:error, posix}\nls(path \\\\ \".\")\n\n  Returns the list of files in the given directory.\n\n  Returns `{:ok, [files]}` in case of success,\n  `{:error, reason}` otherwise.\n  "
    },
    ["ls!"] = {
      description = "ls!(Path.t) :: [binary] | no_return\nls!(path \\\\ \".\")\n\n  The same as `ls/1` but raises `File.Error`\n  in case of an error.\n  "
    },
    lstat = {
      description = "lstat(Path.t, stat_options) :: {:ok, File.Stat.t} | {:error, posix}\nlstat(path, opts \\\\ [])\n\n  Returns information about the `path`. If the file is a symlink, sets\n  the `type` to `:symlink` and returns a `File.Stat` struct for the link. For any\n  other file, returns exactly the same values as `stat/2`.\n\n  For more details, see [`:file.read_link_info/2`](http://www.erlang.org/doc/man/file.html#read_link_info-2).\n\n  ## Options\n\n  The accepted options are:\n\n    * `:time` - configures how the file timestamps are returned\n\n  The values for `:time` can be:\n\n    * `:universal` - returns a `{date, time}` tuple in UTC (default)\n    * `:local` - returns a `{date, time}` tuple using the machine time\n    * `:posix` - returns the time as integer seconds since epoch\n\n  "
    },
    ["lstat!"] = {
      description = "lstat!(Path.t, stat_options) :: File.Stat.t | no_return\nlstat!(path, opts \\\\ [])\n\n  Same as `lstat/2` but returns the `File.Stat` struct directly and\n  throws `File.Error` if an error is returned.\n  "
    },
    mkdir = {
      description = "mkdir(Path.t) :: :ok | {:error, posix}\nmkdir(path)\n\n  Tries to create the directory `path`. Missing parent directories are not created.\n  Returns `:ok` if successful, or `{:error, reason}` if an error occurs.\n\n  Typical error reasons are:\n\n    * `:eacces`  - missing search or write permissions for the parent\n      directories of `path`\n    * `:eexist`  - there is already a file or directory named `path`\n    * `:enoent`  - a component of `path` does not exist\n    * `:enospc`  - there is no space left on the device\n    * `:enotdir` - a component of `path` is not a directory;\n      on some platforms, `:enoent` is returned instead\n  "
    },
    ["mkdir!"] = {
      description = "mkdir!(Path.t) :: :ok | no_return\nmkdir!(path)\n\n  Same as `mkdir/1`, but raises an exception in case of failure. Otherwise `:ok`.\n  "
    },
    mkdir_p = {
      description = "mkdir_p(Path.t) :: :ok | {:error, posix}\nmkdir_p(path)\n\n  Tries to create the directory `path`. Missing parent directories are created.\n  Returns `:ok` if successful, or `{:error, reason}` if an error occurs.\n\n  Typical error reasons are:\n\n    * `:eacces`  - missing search or write permissions for the parent\n      directories of `path`\n    * `:enospc`  - there is no space left on the device\n    * `:enotdir` - a component of `path` is not a directory\n  "
    },
    ["mkdir_p!"] = {
      description = "mkdir_p!(Path.t) :: :ok | no_return\nmkdir_p!(path)\n\n  Same as `mkdir_p/1`, but raises an exception in case of failure. Otherwise `:ok`.\n  "
    },
    mode = {
      description = "mode :: :append | :binary | :charlist | :compressed | :delayed_write | :exclusive |\n"
    },
    open = {
      description = "open(Path.t, [mode | :ram], (io_device -> res)) :: {:ok, res} | {:error, posix} when res: var\nopen(path, modes, function) when is_list(modes) and is_function(function, 1)\nopen(path, function) when is_function(function, 1)\nopen(path, modes) when is_list(modes)\nopen(Path.t, (io_device -> res)) :: {:ok, res} | {:error, posix} when res: var\nopen(path, modes_or_function \\\\ [])\n\n  Opens the given `path`.\n\n  In order to write and read files, one must use the functions\n  in the `IO` module. By default, a file is opened in `:binary` mode,\n  which requires the functions `IO.binread/2` and `IO.binwrite/2`\n  to interact with the file. A developer may pass `:utf8` as an\n  option when opening the file and then all other functions from\n  `IO` are available, since they work directly with Unicode data.\n\n  `modes_or_function` can either be a list of modes or a function. If it's a\n  list, it's considered to be a list of modes (that are documented below). If\n  it's a function, then it's equivalent to calling `open(path, [],\n  modes_or_function)`. See the documentation for `open/3` for more information\n  on this function.\n\n  The allowed modes:\n\n    * `:binary` - opens the file in binary mode, disabling special handling of unicode sequences\n      (default mode).\n\n    * `:read` - the file, which must exist, is opened for reading.\n\n    * `:write` - the file is opened for writing. It is created if it does not\n      exist.\n\n      If the file does exists, and if write is not combined with read, the file\n      will be truncated.\n\n    * `:append` - the file will be opened for writing, and it will be created\n      if it does not exist. Every write operation to a file opened with append\n      will take place at the end of the file.\n\n    * `:exclusive` - the file, when opened for writing, is created if it does\n      not exist. If the file exists, open will return `{:error, :eexist}`.\n\n    * `:charlist` - when this term is given, read operations on the file will\n      return charlists rather than binaries.\n\n    * `:compressed` - makes it possible to read or write gzip compressed files.\n\n      The compressed option must be combined with either read or write, but not\n      both. Note that the file size obtained with `stat/1` will most probably\n      not match the number of bytes that can be read from a compressed file.\n\n    * `:utf8` - this option denotes how data is actually stored in the disk\n      file and makes the file perform automatic translation of characters to\n      and from UTF-8.\n\n      If data is sent to a file in a format that cannot be converted to the\n      UTF-8 or if data is read by a function that returns data in a format that\n      cannot cope with the character range of the data, an error occurs and the\n      file will be closed.\n\n    * `:delayed_write`, `:raw`, `:ram`, `:read_ahead`, `:sync`, `{:encoding, ...}`,\n      `{:read_ahead, pos_integer}`, `{:delayed_write, non_neg_integer, non_neg_integer}` -\n      for more information about these options see [`:file.open/2`](http://www.erlang.org/doc/man/file.html#open-2).\n\n  This function returns:\n\n    * `{:ok, io_device}` - the file has been opened in the requested mode.\n\n      `io_device` is actually the PID of the process which handles the file.\n      This process is linked to the process which originally opened the file.\n      If any process to which the `io_device` is linked terminates, the file\n      will be closed and the process itself will be terminated.\n\n      An `io_device` returned from this call can be used as an argument to the\n      `IO` module functions.\n\n    * `{:error, reason}` - the file could not be opened.\n\n  ## Examples\n\n      {:ok, file} = File.open(\"foo.tar.gz\", [:read, :compressed])\n      IO.read(file, :line)\n      File.close(file)\n\n  "
    },
    ["open!"] = {
      description = "open!(Path.t, [mode | :ram], (io_device -> res)) :: res | no_return when res: var\nopen!(path, modes, function)\nopen!(Path.t, (io_device -> res)) :: res | no_return when res: var\nopen!(path, modes_or_function \\\\ [])\n\n  Similar to `open/2` but raises an error if file could not be opened.\n\n  Returns the IO device otherwise.\n\n  See `open/2` for the list of available modes.\n  "
    },
    posix = {
      description = "posix :: :file.posix()\n"
    },
    read = {
      description = "read(Path.t) :: {:ok, binary} | {:error, posix}\nread(path)\n\n  Returns `{:ok, binary}`, where `binary` is a binary data object that contains the contents\n  of `path`, or `{:error, reason}` if an error occurs.\n\n  Typical error reasons:\n\n    * `:enoent`  - the file does not exist\n    * `:eacces`  - missing permission for reading the file,\n      or for searching one of the parent directories\n    * `:eisdir`  - the named file is a directory\n    * `:enotdir` - a component of the file name is not a directory;\n      on some platforms, `:enoent` is returned instead\n    * `:enomem`  - there is not enough memory for the contents of the file\n\n  You can use `:file.format_error/1` to get a descriptive string of the error.\n  "
    },
    ["read!"] = {
      description = "read!(Path.t) :: binary | no_return\nread!(path)\n\n  Returns a binary with the contents of the given filename or raises\n  `File.Error` if an error occurs.\n  "
    },
    ["regular?"] = {
      description = "regular?(Path.t) :: boolean\nregular?(path)\n\n  Returns `true` if the path is a regular file.\n\n  ## Examples\n\n      File.regular? __ENV__.file #=> true\n\n  "
    },
    rename = {
      description = "rename(Path.t, Path.t) :: :ok | {:error, posix}\nrename(source, destination)\n\n  Renames the `source` file to `destination` file.  It can be used to move files\n  (and directories) between directories.  If moving a file, you must fully\n  specify the `destination` filename, it is not sufficient to simply specify\n  its directory.\n\n  Returns `:ok` in case of success, `{:error, reason}` otherwise.\n\n  Note: The command `mv` in Unix systems behaves differently depending\n  if `source` is a file and the `destination` is an existing directory.\n  We have chosen to explicitly disallow this behaviour.\n\n  ## Examples\n\n      # Rename file \"a.txt\" to \"b.txt\"\n      File.rename \"a.txt\", \"b.txt\"\n\n      # Rename directory \"samples\" to \"tmp\"\n      File.rename \"samples\", \"tmp\"\n  "
    },
    rm = {
      description = "rm(Path.t) :: :ok | {:error, posix}\nrm(path)\n\n  Tries to delete the file `path`.\n\n  Returns `:ok` if successful, or `{:error, reason}` if an error occurs.\n\n  Note the file is deleted even if in read-only mode.\n\n  Typical error reasons are:\n\n    * `:enoent`  - the file does not exist\n    * `:eacces`  - missing permission for the file or one of its parents\n    * `:eperm`   - the file is a directory and user is not super-user\n    * `:enotdir` - a component of the file name is not a directory;\n      on some platforms, `:enoent` is returned instead\n    * `:einval`  - filename had an improper type, such as tuple\n\n  ## Examples\n\n      File.rm(\"file.txt\")\n      #=> :ok\n\n      File.rm(\"tmp_dir/\")\n      #=> {:error, :eperm}\n\n  "
    },
    ["rm!"] = {
      description = "rm!(Path.t) :: :ok | no_return\nrm!(path)\n\n  Same as `rm/1`, but raises an exception in case of failure. Otherwise `:ok`.\n  "
    },
    rm_rf = {
      description = "rm_rf(Path.t) :: {:ok, [binary]} | {:error, posix, binary}\nrm_rf(path)\n\n  Removes files and directories recursively at the given `path`.\n  Symlinks are not followed but simply removed, non-existing\n  files are simply ignored (i.e. doesn't make this function fail).\n\n  Returns `{:ok, files_and_directories}` with all files and\n  directories removed in no specific order, `{:error, reason, file}`\n  otherwise.\n\n  ## Examples\n\n      File.rm_rf \"samples\"\n      #=> {:ok, [\"samples\", \"samples/1.txt\"]}\n\n      File.rm_rf \"unknown\"\n      #=> {:ok, []}\n\n  "
    },
    ["rm_rf!"] = {
      description = "rm_rf!(Path.t) :: [binary] | no_return\nrm_rf!(path)\n\n  Same as `rm_rf/1` but raises `File.Error` in case of failures,\n  otherwise the list of files or directories removed.\n  "
    },
    rmdir = {
      description = "rmdir(Path.t) :: :ok | {:error, posix}\nrmdir(path)\n\n  Tries to delete the dir at `path`.\n  Returns `:ok` if successful, or `{:error, reason}` if an error occurs.\n\n  ## Examples\n\n      File.rmdir('tmp_dir')\n      #=> :ok\n\n      File.rmdir('file.txt')\n      #=> {:error, :enotdir}\n\n  "
    },
    ["rmdir!"] = {
      description = "rmdir!(Path.t) :: :ok | {:error, posix}\nrmdir!(path)\n\n  Same as `rmdir/1`, but raises an exception in case of failure. Otherwise `:ok`.\n  "
    },
    stat = {
      description = "stat(Path.t, stat_options) :: {:ok, File.Stat.t} | {:error, posix}\nstat(path, opts \\\\ [])\n\n  Returns information about the `path`. If it exists, it\n  returns a `{:ok, info}` tuple, where info is a\n  `File.Stat` struct. Returns `{:error, reason}` with\n  the same reasons as `read/1` if a failure occurs.\n\n  ## Options\n\n  The accepted options are:\n\n    * `:time` - configures how the file timestamps are returned\n\n  The values for `:time` can be:\n\n    * `:universal` - returns a `{date, time}` tuple in UTC (default)\n    * `:local` - returns a `{date, time}` tuple using the same time zone as the\n      machine\n    * `:posix` - returns the time as integer seconds since epoch\n\n  "
    },
    ["stat!"] = {
      description = "stat!(Path.t, stat_options) :: File.Stat.t | no_return\nstat!(path, opts \\\\ [])\n\n  Same as `stat/2` but returns the `File.Stat` directly and\n  throws `File.Error` if an error is returned.\n  "
    },
    stat_options = {
      description = "stat_options :: [time: :local | :universal | :posix]\n"
    },
    ["stream!"] = {
      description = "stream!(path, modes \\\\ [], line_or_bytes \\\\ :line)\n\n  Returns a `File.Stream` for the given `path` with the given `modes`.\n\n  The stream implements both `Enumerable` and `Collectable` protocols,\n  which means it can be used both for read and write.\n\n  The `line_or_bytes` argument configures how the file is read when\n  streaming, by `:line` (default) or by a given number of bytes.\n\n  Operating the stream can fail on open for the same reasons as\n  `File.open!/2`. Note that the file is automatically opened each time streaming\n  begins. There is no need to pass `:read` and `:write` modes, as those are\n  automatically set by Elixir.\n\n  ## Raw files\n\n  Since Elixir controls when the streamed file is opened, the underlying\n  device cannot be shared and as such it is convenient to open the file\n  in raw mode for performance reasons. Therefore, Elixir **will** open\n  streams in `:raw` mode with the `:read_ahead` option unless an encoding\n  is specified. This means any data streamed into the file must be\n  converted to `t:iodata/0` type. If you pass `[:utf8]` in the modes parameter,\n  the underlying stream will use `IO.write/2` and the `String.Chars` protocol\n  to convert the data. See `IO.binwrite/2` and `IO.write/2` .\n\n  One may also consider passing the `:delayed_write` option if the stream\n  is meant to be written to under a tight loop.\n\n  ## Byte order marks\n\n  If you pass `:trim_bom` in the modes parameter, the stream will\n  trim UTF-8, UTF-16 and UTF-32 byte order marks when reading from file.\n\n  ## Examples\n\n      # Read in 2048 byte chunks rather than lines\n      File.stream!(\"./test/test.data\", [], 2048)\n      #=> %File.Stream{line_or_bytes: 2048, modes: [:raw, :read_ahead, :binary],\n      #=> path: \"./test/test.data\", raw: true}\n\n  See `Stream.run/1` for an example of streaming into a file.\n\n  "
    },
    touch = {
      description = "touch(Path.t, :calendar.datetime) :: :ok | {:error, posix}\ntouch(path, time \\\\ :calendar.universal_time)\n\n  Updates modification time (mtime) and access time (atime) of\n  the given file.\n\n  The file is created if it doesn’t exist. Requires datetime in UTC.\n  "
    },
    ["touch!"] = {
      description = "touch!(Path.t, :calendar.datetime) :: :ok | no_return\ntouch!(path, time \\\\ :calendar.universal_time)\n\n  Same as `touch/2` but raises an exception if it fails.\n\n  Returns `:ok` otherwise. Requires datetime in UTC.\n  "
    },
    write = {
      description = "write(Path.t, iodata, [mode]) :: :ok | {:error, posix}\nwrite(path, content, modes \\\\ [])\n\n  Writes `content` to the file `path`.\n\n  The file is created if it does not exist. If it exists, the previous\n  contents are overwritten. Returns `:ok` if successful, or `{:error, reason}`\n  if an error occurs.\n\n  `content` must be `iodata` (a list of bytes or a binary). Setting the\n  encoding for this function has no effect.\n\n  **Warning:** Every time this function is invoked, a file descriptor is opened\n  and a new process is spawned to write to the file. For this reason, if you are\n  doing multiple writes in a loop, opening the file via `File.open/2` and using\n  the functions in `IO` to write to the file will yield much better performance\n  than calling this function multiple times.\n\n  Typical error reasons are:\n\n    * `:enoent`  - a component of the file name does not exist\n    * `:enotdir` - a component of the file name is not a directory;\n      on some platforms, `:enoent` is returned instead\n    * `:enospc`  - there is no space left on the device\n    * `:eacces`  - missing permission for writing the file or searching one of\n      the parent directories\n    * `:eisdir`  - the named file is a directory\n\n  Check `File.open/2` for other available options.\n  "
    },
    ["write!"] = {
      description = "write!(Path.t, iodata, [mode]) :: :ok | no_return\nwrite!(path, content, modes \\\\ [])\n\n  Same as `write/3` but raises an exception if it fails, returns `:ok` otherwise.\n  "
    },
    write_stat = {
      description = "write_stat(Path.t, File.Stat.t, stat_options) :: :ok | {:error, posix}\nwrite_stat(path, stat, opts \\\\ [])\n\n  Writes the given `File.Stat` back to the filesystem at the given\n  path. Returns `:ok` or `{:error, reason}`.\n  "
    },
    ["write_stat!"] = {
      description = "write_stat!(Path.t, File.Stat.t, stat_options) :: :ok | no_return\nwrite_stat!(path, stat, opts \\\\ [])\n\n  Same as `write_stat/3` but raises an exception if it fails.\n  Returns `:ok` otherwise.\n  "
    }
  },
  Float = {
    ceil = {
      description = "ceil(float, 0..15) :: float\nceil(number, precision \\\\ 0) when is_float(number) and precision in 0..15\n\n  Rounds a float to the smallest integer greater than or equal to `num`.\n\n  `ceil/2` also accepts a precision to round a floating point value down\n  to an arbitrary number of fractional digits (between 0 and 15).\n\n  The operation is performed on the binary floating point, without a\n  conversion to decimal.\n\n  The behaviour of `ceil/2` for floats can be surprising. For example:\n\n      iex> Float.ceil(-12.52, 2)\n      -12.51\n\n  One may have expected it to ceil to -12.52. This is not a bug.\n  Most decimal fractions cannot be represented as a binary floating point\n  and therefore the number above is internally represented as -12.51999999,\n  which explains the behaviour above.\n\n  This function always returns floats. `Kernel.trunc/1` may be used instead to\n  truncate the result to an integer afterwards.\n\n  ## Examples\n\n      iex> Float.ceil(34.25)\n      35.0\n      iex> Float.ceil(-56.5)\n      -56.0\n      iex> Float.ceil(34.251, 2)\n      34.26\n\n  "
    },
    description = "\n  Functions for working with floating point numbers.\n  ",
    floor = {
      description = "floor(float, 0..15) :: float\nfloor(number, precision \\\\ 0) when is_float(number) and precision in 0..15\n\n  Rounds a float to the largest integer less than or equal to `num`.\n\n  `floor/2` also accepts a precision to round a floating point value down\n  to an arbitrary number of fractional digits (between 0 and 15).\n  The operation is performed on the binary floating point, without a\n  conversion to decimal.\n\n  The behaviour of `floor/2` for floats can be surprising. For example:\n\n      iex> Float.floor(12.52, 2)\n      12.51\n\n  One may have expected it to floor to 12.52. This is not a bug.\n  Most decimal fractions cannot be represented as a binary floating point\n  and therefore the number above is internally represented as 12.51999999,\n  which explains the behaviour above.\n\n  This function always returns a float. `Kernel.trunc/1` may be used instead to\n  truncate the result to an integer afterwards.\n\n  ## Examples\n\n      iex> Float.floor(34.25)\n      34.0\n      iex> Float.floor(-56.5)\n      -57.0\n      iex> Float.floor(34.259, 2)\n      34.25\n\n  "
    },
    parse = {
      description = "parse(binary)\nparse(\"+\" <> binary)\nparse(binary) :: {float, binary} | :error\nparse(\"-\" <> binary)\n\n  Parses a binary into a float.\n\n  If successful, returns a tuple in the form of `{float, remainder_of_binary}`;\n  when the binary cannot be coerced into a valid float, the atom `:error` is\n  returned.\n\n  If the size of float exceeds the maximum size of `1.7976931348623157e+308`,\n  the `ArgumentError` exception is raised.\n\n  If you want to convert a string-formatted float directly to a float,\n  `String.to_float/1` can be used instead.\n\n  ## Examples\n\n      iex> Float.parse(\"34\")\n      {34.0, \"\"}\n      iex> Float.parse(\"34.25\")\n      {34.25, \"\"}\n      iex> Float.parse(\"56.5xyz\")\n      {56.5, \"xyz\"}\n\n      iex> Float.parse(\"pi\")\n      :error\n\n  "
    },
    ratio = {
      description = "ratio(float) when is_float(float)\n\n  Returns a pair of integers whose ratio is exactly equal\n  to the original float and with a positive denominator.\n\n  ## Examples\n\n      iex> Float.ratio(3.14)\n      {7070651414971679, 2251799813685248}\n      iex> Float.ratio(-3.14)\n      {-7070651414971679, 2251799813685248}\n      iex> Float.ratio(1.5)\n      {3, 2}\n      iex> Float.ratio(-1.5)\n      {-3, 2}\n      iex> Float.ratio(16.0)\n      {16, 1}\n      iex> Float.ratio(-16.0)\n      {-16, 1}\n\n  "
    },
    round = {
      description = "round(float, 0..15) :: float\nround(float, precision \\\\ 0) when is_float(float) and precision in 0..15\n\n  Rounds a floating point value to an arbitrary number of fractional\n  digits (between 0 and 15).\n\n  The rounding direction always ties to half up. The operation is\n  performed on the binary floating point, without a conversion to decimal.\n\n  This function only accepts floats and always returns a float. Use\n  `Kernel.round/1` if you want a function that accepts both floats\n  and integers and always returns an integer.\n\n  The behaviour of `round/2` for floats can be surprising. For example:\n\n      iex> Float.round(5.5675, 3)\n      5.567\n\n  One may have expected it to round to the half up 5.568. This is not a bug.\n  Most decimal fractions cannot be represented as a binary floating point\n  and therefore the number above is internally represented as 5.567499999,\n  which explains the behaviour above. If you want exact rounding for decimals,\n  you must use a decimal library. The behaviour above is also in accordance\n  to reference implementations, such as \"Correctly Rounded Binary-Decimal and\n  Decimal-Binary Conversions\" by David M. Gay.\n\n  ## Examples\n\n      iex> Float.round(12.5)\n      13.0\n      iex> Float.round(5.5674, 3)\n      5.567\n      iex> Float.round(5.5675, 3)\n      5.567\n      iex> Float.round(-5.5674, 3)\n      -5.567\n      iex> Float.round(-5.5675)\n      -6.0\n      iex> Float.round(12.341444444444441, 15)\n      12.341444444444441\n\n  "
    },
    to_char_list = {
      description = "to_char_list(float, options)\nto_char_list(float)\nfalse"
    },
    to_charlist = {
      description = "to_charlist(float) :: charlist\nto_charlist(float) when is_float(float)\n\n  Returns a charlist which corresponds to the text representation\n  of the given float.\n\n  It uses the shortest representation according to algorithm described\n  in \"Printing Floating-Point Numbers Quickly and Accurately\" in\n  Proceedings of the SIGPLAN '96 Conference on Programming Language\n  Design and Implementation.\n\n  ## Examples\n\n      iex> Float.to_charlist(7.0)\n      '7.0'\n\n  "
    },
    to_string = {
      description = "to_string(float, options)\nto_string(float) :: String.t\nto_string(float) when is_float(float)\n\n  Returns a binary which corresponds to the text representation\n  of the given float.\n\n  It uses the shortest representation according to algorithm described\n  in \"Printing Floating-Point Numbers Quickly and Accurately\" in\n  Proceedings of the SIGPLAN '96 Conference on Programming Language\n  Design and Implementation.\n\n  ## Examples\n\n      iex> Float.to_string(7.0)\n      \"7.0\"\n\n  "
    }
  },
  FunctionClauseError = {
    message = {
      description = "message(exception)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    }
  },
  GenEvent = {
    Stream = {
      code_change = {
        description = "code_change(_old, state, _extra)\nfalse"
      },
      count = {
        description = "count(_stream)\nfalse"
      },
      description = "false",
      handle_call = {
        description = "handle_call(msg, _state)\nfalse"
      },
      handle_event = {
        description = "handle_event(event, _state)\nfalse"
      },
      handle_info = {
        description = "handle_info(_msg, state)\nfalse"
      },
      init = {
        description = "init({_pid, _ref} = state)\nfalse"
      },
      ["member?"] = {
        description = "member?(_stream, _item)\nfalse"
      },
      reduce = {
        description = "reduce(stream, acc, fun)\nfalse"
      },
      t = {
        description = "t :: %__MODULE__{\n"
      },
      terminate = {
        description = "terminate(_reason, _state)\nfalse"
      }
    },
    ack_notify = {
      description = "ack_notify(manager, term) :: :ok\nack_notify(manager, event)\nfalse"
    },
    add_handler = {
      description = "add_handler(manager, handler, term) :: :ok | {:error, term}\nadd_handler(manager, handler, args)\nfalse"
    },
    add_mon_handler = {
      description = "add_mon_handler(manager, handler, term) :: :ok | {:error, term}\nadd_mon_handler(manager, handler, args)\nfalse"
    },
    call = {
      description = "call(manager, handler, term, timeout) ::  term | {:error, term}\ncall(manager, handler, request, timeout \\\\ 5000)\nfalse"
    },
    code_change = {
      description = "code_change(_old, state, _extra)\nfalse"
    },
    description = "\n  WARNING: this module is deprecated.\n\n  If you are interested in implementing an event manager, please read the\n  \"Alternatives\" section below. If you have to implement an event handler to\n  integrate with an existing system, such as Elixir's Logger, please use\n  `:gen_event` instead.\n\n  ## Alternatives\n\n  There are a few suitable alternatives to replace GenEvent. Each of them can be\n  the most beneficial based on the use case.\n\n  ### Supervisor and GenServers\n\n  One alternative to GenEvent is a very minimal solution consisting of using a\n  supervisor and multiple GenServers started under it. The supervisor acts as\n  the \"event manager\" and the children GenServers act as the \"event handlers\".\n  This approach has some shortcomings (it provides no backpressure for example)\n  but can still replace GenEvent for low-profile usages of it. [This blog post\n  by José\n  Valim](http://blog.plataformatec.com.br/2016/11/replacing-genevent-by-a-supervisor-genserver/)\n  has more detailed information on this approach.\n\n  ### GenStage\n\n  If the use case where you were using GenEvent requires more complex logic,\n  [GenStage](https://github.com/elixir-lang/gen_stage) provides a great\n  alternative. GenStage is an external Elixir library maintained by the Elixir\n  team; it provides tool to implement systems that exchange events in a\n  demand-driven way with built-in support for backpressure. See the [GenStage\n  documentation](https://hexdocs.pm/gen_stage) for more information.\n\n  ### `:gen_event`\n\n  If your use case requires exactly what GenEvent provided, or you have to\n  integrate with an existing `:gen_event`-based system, you can still use the\n  [`:gen_event`](http://erlang.org/doc/man/gen_event.html) Erlang module.\n  ",
    format_status = {
      description = "format_status(opt, status_data)\nfalse"
    },
    handle_call = {
      description = "handle_call(msg, state)\nfalse"
    },
    handle_event = {
      description = "handle_event(_event, state)\nfalse"
    },
    handle_info = {
      description = "handle_info(_msg, state)\nfalse"
    },
    handler = {
      description = "handler :: atom | {atom, term}\n"
    },
    init = {
      description = "init(args)\nfalse"
    },
    init_hib = {
      description = "init_hib(parent, name, handlers, debug)\nfalse"
    },
    init_it = {
      description = "init_it(starter, parent, name, _mod, _args, options)\ninit_it(starter, :self, name, mod, args, options)\nfalse"
    },
    manager = {
      description = "manager :: pid | name | {atom, node}\n"
    },
    name = {
      description = "name :: atom | {:global, term} | {:via, module, term}\n"
    },
    notify = {
      description = "notify(manager, msg)\nnotify({:via, mod, name}, msg) when is_atom(mod)\nnotify({:global, name}, msg)\nnotify(manager, term) :: :ok\nnotify(manager, event)\nfalse"
    },
    on_start = {
      description = "on_start :: {:ok, pid} | {:error, {:already_started, pid}}\n"
    },
    options = {
      description = "options :: [name: name]\n"
    },
    remove_handler = {
      description = "remove_handler(manager, handler, term) :: term | {:error, term}\nremove_handler(manager, handler, args)\nfalse"
    },
    start = {
      description = "start(options) :: on_start\nstart(options \\\\ []) when is_list(options)\nfalse"
    },
    start_link = {
      description = "start_link(options) :: on_start\nstart_link(options \\\\ []) when is_list(options)\nfalse"
    },
    stop = {
      description = "stop(manager, reason :: term, timeout) :: :ok\nstop(manager, reason \\\\ :normal, timeout \\\\ :infinity)\nfalse"
    },
    stream = {
      description = "stream(manager, Keyword.t) :: GenEvent.Stream.t\nstream(manager, options \\\\ [])\nfalse"
    },
    swap_handler = {
      description = "swap_handler(manager, handler, term, handler, term) :: :ok | {:error, term}\nswap_handler(manager, handler1, args1, handler2, args2)\nfalse"
    },
    swap_mon_handler = {
      description = "swap_mon_handler(manager, handler, term, handler, term) :: :ok | {:error, term}\nswap_mon_handler(manager, handler1, args1, handler2, args2)\nfalse"
    },
    sync_notify = {
      description = "sync_notify(manager, term) :: :ok\nsync_notify(manager, event)\nfalse"
    },
    system_code_change = {
      description = "system_code_change([name, handlers, hib], module, old_vsn, extra)\nfalse"
    },
    system_continue = {
      description = "system_continue(parent, debug, [name, handlers, hib])\nfalse"
    },
    system_get_state = {
      description = "system_get_state([_name, handlers, _hib])\nfalse"
    },
    system_replace_state = {
      description = "system_replace_state(fun, [name, handlers, hib])\nfalse"
    },
    system_terminate = {
      description = "system_terminate(reason, parent, _debug, [name, handlers, _hib])\nfalse"
    },
    terminate = {
      description = "terminate(_reason, _state)\nfalse"
    },
    which_handlers = {
      description = "which_handlers(manager) :: [handler]\nwhich_handlers(manager)\nfalse"
    }
  },
  GenServer = {
    abcast = {
      description = "abcast([node], name :: atom, term) :: :abcast\nabcast(nodes \\\\ [node() | Node.list()], name, request) when is_list(nodes) and is_atom(name)\n\n  Casts all servers locally registered as `name` at the specified nodes.\n\n  This function returns immediately and ignores nodes that do not exist, or where the\n  server name does not exist.\n\n  See `multi_call/4` for more information.\n  "
    },
    call = {
      description = "call(server, term, timeout) :: term\ncall(server, request, timeout \\\\ 5000)\n\n  Makes a synchronous call to the `server` and waits for its reply.\n\n  The client sends the given `request` to the server and waits until a reply\n  arrives or a timeout occurs. `c:handle_call/3` will be called on the server\n  to handle the request.\n\n  `server` can be any of the values described in the \"Name registration\"\n  section of the documentation for this module.\n\n  ## Timeouts\n\n  `timeout` is an integer greater than zero which specifies how many\n  milliseconds to wait for a reply, or the atom `:infinity` to wait\n  indefinitely. The default value is `5000`. If no reply is received within\n  the specified time, the function call fails and the caller exits. If the\n  caller catches the failure and continues running, and the server is just late\n  with the reply, it may arrive at any time later into the caller's message\n  queue. The caller must in this case be prepared for this and discard any such\n  garbage messages that are two-element tuples with a reference as the first\n  element.\n  "
    },
    cast = {
      description = "cast(dest, request) when is_atom(dest) or is_pid(dest),\ncast({name, node}, request) when is_atom(name) and is_atom(node),\ncast({:via, mod, name}, request)\ncast({:global, name}, request)\ncast(server, term) :: :ok\ncast(server, request)\n\n  Sends an asynchronous request to the `server`.\n\n  This function always returns `:ok` regardless of whether\n  the destination `server` (or node) exists. Therefore it\n  is unknown whether the destination `server` successfully\n  handled the message.\n\n  `c:handle_cast/2` will be called on the server to handle\n  the request. In case the `server` is on a node which is\n  not yet connected to the caller one, the call is going to\n  block until a connection happens. This is different than\n  the behaviour in OTP's `:gen_server` where the message\n  is sent by another process in this case, which could cause\n  messages to other nodes to arrive out of order.\n  "
    },
    code_change = {
      description = "code_change(_old, state, _extra)\nfalse"
    },
    debug = {
      description = "debug :: [:trace | :log | :statistics | {:log_to_file, Path.t}]\n"
    },
    description = "\n  A behaviour module for implementing the server of a client-server relation.\n\n  A GenServer is a process like any other Elixir process and it can be used\n  to keep state, execute code asynchronously and so on. The advantage of using\n  a generic server process (GenServer) implemented using this module is that it\n  will have a standard set of interface functions and include functionality for\n  tracing and error reporting. It will also fit into a supervision tree.\n\n  ## Example\n\n  The GenServer behaviour abstracts the common client-server interaction.\n  Developers are only required to implement the callbacks and functionality they are\n  interested in.\n\n  Let's start with a code example and then explore the available callbacks.\n  Imagine we want a GenServer that works like a stack, allowing us to push\n  and pop items:\n\n      defmodule Stack do\n        use GenServer\n\n        # Callbacks\n\n        def handle_call(:pop, _from, [h | t]) do\n          {:reply, h, t}\n        end\n\n        def handle_cast({:push, item}, state) do\n          {:noreply, [item | state]}\n        end\n      end\n\n      # Start the server\n      {:ok, pid} = GenServer.start_link(Stack, [:hello])\n\n      # This is the client\n      GenServer.call(pid, :pop)\n      #=> :hello\n\n      GenServer.cast(pid, {:push, :world})\n      #=> :ok\n\n      GenServer.call(pid, :pop)\n      #=> :world\n\n  We start our `Stack` by calling `start_link/3`, passing the module\n  with the server implementation and its initial argument (a list\n  representing the stack containing the item `:hello`). We can primarily\n  interact with the server by sending two types of messages. **call**\n  messages expect a reply from the server (and are therefore synchronous)\n  while **cast** messages do not.\n\n  Every time you do a `GenServer.call/3`, the client will send a message\n  that must be handled by the `c:handle_call/3` callback in the GenServer.\n  A `cast/2` message must be handled by `c:handle_cast/2`.\n\n  ## Callbacks\n\n  There are 6 callbacks required to be implemented in a `GenServer`. By\n  adding `use GenServer` to your module, Elixir will automatically define\n  all 6 callbacks for you, leaving it up to you to implement the ones\n  you want to customize.\n\n  ## Name Registration\n\n  Both `start_link/3` and `start/3` support the `GenServer` to register\n  a name on start via the `:name` option. Registered names are also\n  automatically cleaned up on termination. The supported values are:\n\n    * an atom - the GenServer is registered locally with the given name\n      using `Process.register/2`.\n\n    * `{:global, term}`- the GenServer is registered globally with the given\n      term using the functions in the [`:global` module](http://www.erlang.org/doc/man/global.html).\n\n    * `{:via, module, term}` - the GenServer is registered with the given\n      mechanism and name. The `:via` option expects a module that exports\n      `register_name/2`, `unregister_name/1`, `whereis_name/1` and `send/2`.\n      One such example is the [`:global` module](http://www.erlang.org/doc/man/global.html) which uses these functions\n      for keeping the list of names of processes and their associated PIDs\n      that are available globally for a network of Elixir nodes. Elixir also\n      ships with a local, decentralized and scalable registry called `Registry`\n      for locally storing names that are generated dynamically.\n\n  For example, we could start and register our `Stack` server locally as follows:\n\n      # Start the server and register it locally with name MyStack\n      {:ok, _} = GenServer.start_link(Stack, [:hello], name: MyStack)\n\n      # Now messages can be sent directly to MyStack\n      GenServer.call(MyStack, :pop) #=> :hello\n\n  Once the server is started, the remaining functions in this module (`call/3`,\n  `cast/2`, and friends) will also accept an atom, or any `:global` or `:via`\n  tuples. In general, the following formats are supported:\n\n    * a `pid`\n    * an `atom` if the server is locally registered\n    * `{atom, node}` if the server is locally registered at another node\n    * `{:global, term}` if the server is globally registered\n    * `{:via, module, name}` if the server is registered through an alternative\n      registry\n\n  If there is an interest to register dynamic names locally, do not use\n  atoms, as atoms are never garbage collected and therefore dynamically\n  generated atoms won't be garbage collected. For such cases, you can\n  set up your own local registry by using the `Registry` module.\n\n  ## Client / Server APIs\n\n  Although in the example above we have used `GenServer.start_link/3` and\n  friends to directly start and communicate with the server, most of the\n  time we don't call the `GenServer` functions directly. Instead, we wrap\n  the calls in new functions representing the public API of the server.\n\n  Here is a better implementation of our Stack module:\n\n      defmodule Stack do\n        use GenServer\n\n        # Client\n\n        def start_link(default) do\n          GenServer.start_link(__MODULE__, default)\n        end\n\n        def push(pid, item) do\n          GenServer.cast(pid, {:push, item})\n        end\n\n        def pop(pid) do\n          GenServer.call(pid, :pop)\n        end\n\n        # Server (callbacks)\n\n        def handle_call(:pop, _from, [h | t]) do\n          {:reply, h, t}\n        end\n\n        def handle_call(request, from, state) do\n          # Call the default implementation from GenServer\n          super(request, from, state)\n        end\n\n        def handle_cast({:push, item}, state) do\n          {:noreply, [item | state]}\n        end\n\n        def handle_cast(request, state) do\n          super(request, state)\n        end\n      end\n\n  In practice, it is common to have both server and client functions in\n  the same module. If the server and/or client implementations are growing\n  complex, you may want to have them in different modules.\n\n  ## Receiving \"regular\" messages\n\n  The goal of a `GenServer` is to abstract the \"receive\" loop for developers,\n  automatically handling system messages, support code change, synchronous\n  calls and more. Therefore, you should never call your own \"receive\" inside\n  the GenServer callbacks as doing so will cause the GenServer to misbehave.\n\n  Besides the synchronous and asynchronous communication provided by `call/3`\n  and `cast/2`, \"regular\" messages sent by functions such `Kernel.send/2`,\n  `Process.send_after/4` and similar, can be handled inside the `c:handle_info/2`\n  callback.\n\n  `c:handle_info/2` can be used in many situations, such as handling monitor\n  DOWN messages sent by `Process.monitor/1`. Another use case for `c:handle_info/2`\n  is to perform periodic work, with the help of `Process.send_after/4`:\n\n      defmodule MyApp.Periodically do\n        use GenServer\n\n        def start_link do\n          GenServer.start_link(__MODULE__, %{})\n        end\n\n        def init(state) do\n          schedule_work() # Schedule work to be performed on start\n          {:ok, state}\n        end\n\n        def handle_info(:work, state) do\n          # Do the desired work here\n          schedule_work() # Reschedule once more\n          {:noreply, state}\n        end\n\n        defp schedule_work() do\n          Process.send_after(self(), :work, 2 * 60 * 60 * 1000) # In 2 hours\n        end\n      end\n\n  ## Debugging with the :sys module\n\n  GenServers, as [special processes](http://erlang.org/doc/design_principles/spec_proc.html),\n  can be debugged using the [`:sys` module](http://www.erlang.org/doc/man/sys.html). Through various hooks, this module\n  allows developers to introspect the state of the process and trace\n  system events that happen during its execution, such as received messages,\n  sent replies and state changes.\n\n  Let's explore the basic functions from the [`:sys` module](http://www.erlang.org/doc/man/sys.html) used for debugging:\n\n    * [`:sys.get_state/2`](http://erlang.org/doc/man/sys.html#get_state-2) -\n      allows retrieval of the state of the process. In the case of\n      a GenServer process, it will be the callback module state, as\n      passed into the callback functions as last argument.\n    * [`:sys.get_status/2`](http://erlang.org/doc/man/sys.html#get_status-2) -\n      allows retrieval of the status of the process. This status includes\n      the process dictionary, if the process is running or is suspended,\n      the parent PID, the debugger state, and the state of the behaviour module,\n      which includes the callback module state (as returned by `:sys.get_state/2`).\n      It's possible to change how this status is represented by defining\n      the optional `c:GenServer.format_status/2` callback.\n    * [`:sys.trace/3`](http://erlang.org/doc/man/sys.html#trace-3) -\n      prints all the system events to `:stdio`.\n    * [`:sys.statistics/3`](http://erlang.org/doc/man/sys.html#statistics-3) -\n      manages collection of process statistics.\n    * [`:sys.no_debug/2`](http://erlang.org/doc/man/sys.html#no_debug-2) -\n      turns off all debug handlers for the given process. It is very important\n      to switch off debugging once we're done. Excessive debug handlers or\n      those that should be turned off, but weren't, can seriously damage\n      the performance of the system.\n\n  Let's see how we could use those functions for debugging the stack server\n  we defined earlier.\n\n      iex> {:ok, pid} = Stack.start_link([])\n      iex> :sys.statistics(pid, true) # turn on collecting process statistics\n      iex> :sys.trace(pid, true) # turn on event printing\n      iex> Stack.push(pid, 1)\n      *DBG* <0.122.0> got cast {push,1}\n      *DBG* <0.122.0> new state [1]\n      :ok\n      iex> :sys.get_state(pid)\n      [1]\n      iex> Stack.pop(pid)\n      *DBG* <0.122.0> got call pop from <0.80.0>\n      *DBG* <0.122.0> sent 1 to <0.80.0>, new state []\n      1\n      iex> :sys.statistics(pid, :get)\n      {:ok,\n       [start_time: {{2016, 7, 16}, {12, 29, 41}},\n        current_time: {{2016, 7, 16}, {12, 29, 50}},\n        reductions: 117, messages_in: 2, messages_out: 0]}\n      iex> :sys.no_debug(pid) # turn off all debug handlers\n      :ok\n      iex> :sys.get_status(pid)\n      {:status, #PID<0.122.0>, {:module, :gen_server},\n       [[\"$initial_call\": {Stack, :init, 1},            # pdict\n         \"$ancestors\": [#PID<0.80.0>, #PID<0.51.0>]],\n        :running,                                       # :running | :suspended\n        #PID<0.80.0>,                                   # parent\n        [],                                             # debugger state\n        [header: 'Status for generic server <0.122.0>', # module status\n         data: [{'Status', :running}, {'Parent', #PID<0.80.0>},\n           {'Logged events', []}], data: [{'State', [1]}]]]}\n\n  ## Learn more\n\n  If you wish to find out more about gen servers, the Elixir Getting Started\n  guide provides a tutorial-like introduction. The documentation and links\n  in Erlang can also provide extra insight.\n\n    * [GenServer – Elixir's Getting Started Guide](http://elixir-lang.org/getting-started/mix-otp/genserver.html)\n    * [`:gen_server` module documentation](http://www.erlang.org/doc/man/gen_server.html)\n    * [gen_server Behaviour – OTP Design Principles](http://www.erlang.org/doc/design_principles/gen_server_concepts.html)\n    * [Clients and Servers – Learn You Some Erlang for Great Good!](http://learnyousomeerlang.com/clients-and-servers)\n  ",
    from = {
      description = "from :: {pid, tag :: term}\n\n  Tuple describing the client of a call request.\n\n  `pid` is the PID of the caller and `tag` is a unique term used to identify the\n  call.\n  "
    },
    handle_call = {
      description = "handle_call(msg, _from, state)\nfalse"
    },
    handle_cast = {
      description = "handle_cast(msg, state)\nfalse"
    },
    handle_info = {
      description = "handle_info(msg, state)\nfalse"
    },
    init = {
      description = "init(args)\nfalse"
    },
    multi_call = {
      description = "multi_call([node], name :: atom, term, timeout) ::\nmulti_call(nodes \\\\ [node() | Node.list()], name, request, timeout \\\\ :infinity)\n\n  Calls all servers locally registered as `name` at the specified `nodes`.\n\n  First, the `request` is sent to every node in `nodes`; then, the caller waits\n  for the replies. This function returns a two-element tuple `{replies,\n  bad_nodes}` where:\n\n    * `replies` - is a list of `{node, reply}` tuples where `node` is the node\n      that replied and `reply` is its reply\n    * `bad_nodes` - is a list of nodes that either did not exist or where a\n      server with the given `name` did not exist or did not reply\n\n  `nodes` is a list of node names to which the request is sent. The default\n  value is the list of all known nodes (including this node).\n\n  To avoid that late answers (after the timeout) pollute the caller's message\n  queue, a middleman process is used to do the actual calls. Late answers will\n  then be discarded when they arrive to a terminated process.\n\n  ## Examples\n\n  Assuming the `Stack` GenServer mentioned in the docs for the `GenServer`\n  module is registered as `Stack` in the `:\"foo@my-machine\"` and\n  `:\"bar@my-machine\"` nodes:\n\n      GenServer.multi_call(Stack, :pop)\n      #=> {[{:\"foo@my-machine\", :hello}, {:\"bar@my-machine\", :world}], []}\n\n  "
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
      description = "reply({to, tag}, reply) when is_pid(to)\nreply(from, term) :: :ok\nreply(client, reply)\n\n  Replies to a client.\n\n  This function can be used to explicitly send a reply to a client that called\n  `call/3` or `multi_call/4` when the reply cannot be specified in the return\n  value of `c:handle_call/3`.\n\n  `client` must be the `from` argument (the second argument) accepted by\n  `c:handle_call/3` callbacks. `reply` is an arbitrary term which will be given\n  back to the client as the return value of the call.\n\n  Note that `reply/2` can be called from any process, not just the GenServer\n  that originally received the call (as long as that GenServer communicated the\n  `from` argument somehow).\n\n  This function always returns `:ok`.\n\n  ## Examples\n\n      def handle_call(:reply_in_one_second, from, state) do\n        Process.send_after(self(), {:reply, from}, 1_000)\n        {:noreply, state}\n      end\n\n      def handle_info({:reply, from}, state) do\n        GenServer.reply(from, :one_second_has_passed)\n        {:noreply, state}\n      end\n\n  "
    },
    server = {
      description = "server :: pid | name | {atom, node}\n"
    },
    start = {
      description = "start(module, any, options) :: on_start\nstart(module, args, options \\\\ []) when is_atom(module) and is_list(options)\n\n  Starts a `GenServer` process without links (outside of a supervision tree).\n\n  See `start_link/3` for more information.\n  "
    },
    start_link = {
      description = "start_link(module, any, options) :: on_start\nstart_link(module, args, options \\\\ []) when is_atom(module) and is_list(options)\n\n  Starts a `GenServer` process linked to the current process.\n\n  This is often used to start the `GenServer` as part of a supervision tree.\n\n  Once the server is started, the `c:init/1` function of the given `module` is\n  called with `args` as its arguments to initialize the server. To ensure a\n  synchronized start-up procedure, this function does not return until `c:init/1`\n  has returned.\n\n  Note that a `GenServer` started with `start_link/3` is linked to the\n  parent process and will exit in case of crashes from the parent. The GenServer\n  will also exit due to the `:normal` reasons in case it is configured to trap\n  exits in the `c:init/1` callback.\n\n  ## Options\n\n    * `:name` - used for name registration as described in the \"Name\n      registration\" section of the module documentation\n\n    * `:timeout` - if present, the server is allowed to spend the given amount of\n      milliseconds initializing or it will be terminated and the start function\n      will return `{:error, :timeout}`\n\n    * `:debug` - if present, the corresponding function in the [`:sys` module](http://www.erlang.org/doc/man/sys.html) is invoked\n\n    * `:spawn_opt` - if present, its value is passed as options to the\n      underlying process as in `Process.spawn/4`\n\n  ## Return values\n\n  If the server is successfully created and initialized, this function returns\n  `{:ok, pid}`, where `pid` is the PID of the server. If a process with the\n  specified server name already exists, this function returns\n  `{:error, {:already_started, pid}}` with the PID of that process.\n\n  If the `c:init/1` callback fails with `reason`, this function returns\n  `{:error, reason}`. Otherwise, if it returns `{:stop, reason}`\n  or `:ignore`, the process is terminated and this function returns\n  `{:error, reason}` or `:ignore`, respectively.\n  "
    },
    stop = {
      description = "stop(server, reason :: term, timeout) :: :ok\nstop(server, reason \\\\ :normal, timeout \\\\ :infinity)\n\n  Synchronously stops the server with the given `reason`.\n\n  The `c:terminate/2` callback of the given `server` will be invoked before\n  exiting. This function returns `:ok` if the server terminates with the\n  given reason; if it terminates with another reason, the call exits.\n\n  This function keeps OTP semantics regarding error reporting.\n  If the reason is any other than `:normal`, `:shutdown` or\n  `{:shutdown, _}`, an error report is logged.\n  "
    },
    terminate = {
      description = "terminate(_reason, _state)\nfalse"
    },
    whereis = {
      description = "whereis({name, node} = server) when is_atom(name) and is_atom(node)\nwhereis({name, local}) when is_atom(name) and local == node()\nwhereis({:via, mod, name})\nwhereis({:global, name})\nwhereis(name) when is_atom(name)\nwhereis(server) :: pid | {atom, node} | nil\nwhereis(pid) when is_pid(pid)\n\n  Returns the `pid` or `{name, node}` of a GenServer process, or `nil` if\n  no process is associated with the given name.\n\n  ## Examples\n\n  For example, to lookup a server process, monitor it and send a cast to it:\n\n      process = GenServer.whereis(server)\n      monitor = Process.monitor(process)\n      GenServer.cast(process, :hello)\n\n  "
    }
  },
  H = {
    on_def = {
      description = "on_def(_env, kind, name, args, guards, body)\n\n        Sums `a` to `b`.\n        "
    }
  },
  HashDict = {
    count = {
      description = "count(dict)\nfalse"
    },
    delete = {
      description = "delete(dict, key)\n\n  Creates a new empty dict.\n  "
    },
    description = "\n  WARNING: this module is deprecated.\n\n  Use the `Map` module instead.\n  ",
    dict_delete = {
      description = "dict_delete(%HashDict{root: root, size: size}, key)\nfalse"
    },
    fetch = {
      description = "fetch(%HashDict{root: root}, key)\n\n  Creates a new empty dict.\n  "
    },
    inspect = {
      description = "inspect(dict, opts)\nfalse"
    },
    into = {
      description = "into(original)\nfalse"
    },
    ["member?"] = {
      description = "member?(_dict, _)\nmember?(dict, {k, v})\nfalse"
    },
    new = {
      description = "new :: Dict.t\nnew\n\n  Creates a new empty dict.\n  "
    },
    pop = {
      description = "pop(dict, key, default \\\\ nil)\n\n  Creates a new empty dict.\n  "
    },
    put = {
      description = "put(%HashDict{root: root, size: size}, key, value)\n\n  Creates a new empty dict.\n  "
    },
    reduce = {
      description = "reduce(dict, acc, fun)\nreduce(%HashDict{root: root}, acc, fun)\nfalse"
    },
    size = {
      description = "size(%HashDict{size: size})\n\n  Creates a new empty dict.\n  "
    },
    update = {
      description = "update(%HashDict{root: root, size: size}, key, initial, fun) when is_function(fun, 1)\n\n  Creates a new empty dict.\n  "
    },
    ["update!"] = {
      description = "update!(%HashDict{root: root, size: size} = dict, key, fun) when is_function(fun, 1)\n\n  Creates a new empty dict.\n  "
    }
  },
  HashSet = {
    count = {
      description = "count(set)\nfalse"
    },
    delete = {
      description = "delete(%HashSet{root: root, size: size} = set, term)\nfalse"
    },
    description = "\n  WARNING: this module is deprecated.\n\n  Use the `MapSet` module instead.\n  ",
    difference = {
      description = "difference(%HashSet{} = set1, %HashSet{} = set2)\nfalse"
    },
    ["disjoint?"] = {
      description = "disjoint?(%HashSet{} = set1, %HashSet{} = set2)\nfalse"
    },
    ["equal?"] = {
      description = "equal?(%HashSet{size: size1} = set1, %HashSet{size: size2} = set2)\nfalse"
    },
    inspect = {
      description = "inspect(set, opts)\nfalse"
    },
    intersection = {
      description = "intersection(%HashSet{} = set1, %HashSet{} = set2)\nfalse"
    },
    into = {
      description = "into(original)\nfalse"
    },
    ["member?"] = {
      description = "member?(set, v)\nmember?(%HashSet{root: root}, term)\nfalse"
    },
    new = {
      description = "new :: Set.t\nnew\nfalse"
    },
    put = {
      description = "put(%HashSet{root: root, size: size}, term)\nfalse"
    },
    reduce = {
      description = "reduce(set, acc, fun)\nreduce(%HashSet{root: root}, acc, fun)\nfalse"
    },
    size = {
      description = "size(%HashSet{size: size})\nfalse"
    },
    ["subset?"] = {
      description = "subset?(%HashSet{} = set1, %HashSet{} = set2)\nfalse"
    },
    to_list = {
      description = "to_list(set)\nfalse"
    },
    union = {
      description = "union(%HashSet{} = set1, %HashSet{} = set2)\nunion(%HashSet{size: size1} = set1, %HashSet{size: size2} = set2) when size1 <= size2\nfalse"
    }
  },
  IO = {
    ANSI = {
      Docs = {
        default_options = {
          description = "default_options\n\n  The default options used by this module.\n\n  The supported values are:\n\n    * `:enabled`           - toggles coloring on and off (true)\n    * `:doc_bold`          - bold text (bright)\n    * `:doc_code`          - code blocks (cyan)\n    * `:doc_headings`      - h1, h2, h3, h4, h5, h6 headings (yellow)\n    * `:doc_inline_code`   - inline code (cyan)\n    * `:doc_table_heading` - style for table headings\n    * `:doc_title`         - top level heading (reverse, yellow)\n    * `:doc_underline`     - underlined text (underline)\n    * `:width`             - the width to format the text (80)\n\n  Values for the color settings are strings with\n  comma-separated ANSI values.\n  "
        },
        description = "false",
        print = {
          description = "print(doc, options \\\\ [])\n\n  Prints the documentation body.\n\n  In addition to the printing string, takes a set of options\n  defined in `default_options/1`.\n  "
        },
        print_heading = {
          description = "print_heading(heading, options \\\\ [])\n\n  Prints the head of the documentation (i.e. the function signature).\n\n  See `default_options/0` for docs on the supported options.\n  "
        }
      },
      Sequence = {
        description = "false",
        unquote = {
          description = "unquote(name)()\n"
        }
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
      color = {
        description = "color(0..5, 0..5, 0..5) :: String.t\ncolor(r, g, b) when r in 0..5 and g in 0..5 and b in 0..5\ncolor(0..255) :: String.t\ncolor(code) when code in 0..255\n\n  Checks if ANSI coloring is supported and enabled on this machine.\n\n  This function simply reads the configuration value for\n  `:ansi_enabled` in the `:elixir` application. The value is by\n  default `false` unless Elixir can detect during startup that\n  both `stdout` and `stderr` are terminals.\n  "
      },
      color_background = {
        description = "color_background(0..5, 0..5, 0..5) :: String.t\ncolor_background(r, g, b) when r in 0..5 and g in 0..5 and b in 0..5\ncolor_background(0..255) :: String.t\ncolor_background(code) when code in 0..255\n\n  Sets the foreground color from individual RGB values.\n\n  Valid values for each color are in the range 0 to 5.\n  "
      },
      description = "\n  Functionality to render ANSI escape sequences.\n\n  [ANSI escape sequences](https://en.wikipedia.org/wiki/ANSI_escape_code)\n  are characters embedded in text used to control formatting, color, and\n  other output options on video text terminals.\n  ",
      ["enabled?"] = {
        description = "enabled? :: boolean\nenabled?\n\n  Checks if ANSI coloring is supported and enabled on this machine.\n\n  This function simply reads the configuration value for\n  `:ansi_enabled` in the `:elixir` application. The value is by\n  default `false` unless Elixir can detect during startup that\n  both `stdout` and `stderr` are terminals.\n  "
      },
      format = {
        description = "format(chardata, emit? \\\\ enabled?()) when is_boolean(emit?)\n\n  Formats a chardata-like argument by converting named ANSI sequences into actual\n  ANSI codes.\n\n  The named sequences are represented by atoms.\n\n  It will also append an `IO.ANSI.reset/0` to the chardata when a conversion is\n  performed. If you don't want this behaviour, use `format_fragment/2`.\n\n  An optional boolean parameter can be passed to enable or disable\n  emitting actual ANSI codes. When `false`, no ANSI codes will emitted.\n  By default checks if ANSI is enabled using the `enabled?/0` function.\n\n  ## Examples\n\n      iex> IO.ANSI.format([\"Hello, \", :red, :bright, \"world!\"], true)\n      [[[[[[], \"Hello, \"] | \"\\e[31m\"] | \"\\e[1m\"], \"world!\"] | \"\\e[0m\"]\n\n  "
      },
      format_fragment = {
        description = "format_fragment(chardata, emit? \\\\ enabled?()) when is_boolean(emit?)\n\n  Formats a chardata-like argument by converting named ANSI sequences into actual\n  ANSI codes.\n\n  The named sequences are represented by atoms.\n\n  An optional boolean parameter can be passed to enable or disable\n  emitting actual ANSI codes. When `false`, no ANSI codes will emitted.\n  By default checks if ANSI is enabled using the `enabled?/0` function.\n\n  ## Examples\n\n      iex> IO.ANSI.format_fragment([:bright, 'Word'], true)\n      [[[[[[] | \"\\e[1m\"], 87], 111], 114], 100]\n\n  "
      }
    },
    Stream = {
      __build__ = {
        description = "__build__(device, raw, line_or_bytes)\nfalse"
      },
      count = {
        description = "count(_stream)\nfalse"
      },
      description = "\n  Defines an `IO.Stream` struct returned by `IO.stream/2` and `IO.binstream/2`.\n\n  The following fields are public:\n\n    * `device`        - the IO device\n    * `raw`           - a boolean indicating if bin functions should be used\n    * `line_or_bytes` - if reading should read lines or a given amount of bytes\n\n  It is worth noting that an IO stream has side effects and every time you go\n  over the stream you may get different results.\n\n  ",
      into = {
        description = "into(%{device: device, raw: raw} = stream)\nfalse"
      },
      ["member?"] = {
        description = "member?(_stream, _term)\nfalse"
      },
      reduce = {
        description = "reduce(%{device: device, raw: raw, line_or_bytes: line_or_bytes}, acc, fun)\nfalse"
      },
      t = {
        description = "t :: %__MODULE__{}\n"
      }
    },
    StreamError = {
      exception = {
        description = "exception(opts)\n"
      }
    },
    binread = {
      description = "binread(device, count) when is_integer(count) and count >= 0\nbinread(device, :line)\nbinread(device, :all)\nbinread(device, :all | :line | non_neg_integer) :: iodata | nodata\nbinread(device \\\\ :stdio, line_or_chars)\n\n  Reads from the IO `device`. The operation is Unicode unsafe.\n\n  The `device` is iterated by the given number of bytes or line by line if\n  `:line` is given.\n  Alternatively, if `:all` is given, then whole `device` is returned.\n\n  It returns:\n\n    * `data` - the output bytes\n\n    * `:eof` - end of file was encountered\n\n    * `{:error, reason}` - other (rare) error condition;\n      for instance, `{:error, :estale}` if reading from an\n      NFS volume\n\n  If `:all` is given, `:eof` is never returned, but an\n  empty string in case the device has reached EOF.\n\n  Note: do not use this function on IO devices in Unicode mode\n  as it will return the wrong result.\n  "
    },
    binstream = {
      description = "binstream(device, :line | pos_integer) :: Enumerable.t\nbinstream(device, line_or_bytes)\n\n  Converts the IO `device` into an `IO.Stream`. The operation is Unicode unsafe.\n\n  An `IO.Stream` implements both `Enumerable` and\n  `Collectable`, allowing it to be used for both read\n  and write.\n\n  The `device` is iterated by the given number of bytes or line by line if\n  `:line` is given.\n  This reads from the IO device as a raw binary.\n\n  Note that an IO stream has side effects and every time\n  you go over the stream you may get different results.\n\n  Finally, do not use this function on IO devices in Unicode\n  mode as it will return the wrong result.\n\n  "
    },
    binwrite = {
      description = "binwrite(device, iodata) :: :ok | {:error, term}\nbinwrite(device \\\\ :stdio, item) when is_iodata(item)\n\n  Writes `item` as a binary to the given `device`.\n  No Unicode conversion happens.\n  The operation is Unicode unsafe.\n\n  Check `write/2` for more information.\n\n  Note: do not use this function on IO devices in Unicode mode\n  as it will return the wrong result.\n  "
    },
    chardata_to_string = {
      description = "chardata_to_string(list) when is_list(list)\nchardata_to_string(chardata) :: String.t | no_return\nchardata_to_string(string) when is_binary(string)\n\n  Converts chardata (a list of integers representing codepoints,\n  lists and strings) into a string.\n\n  In case the conversion fails, it raises an `UnicodeConversionError`.\n  If a string is given, it returns the string itself.\n\n  ## Examples\n\n      iex> IO.chardata_to_string([0x00E6, 0x00DF])\n      \"æß\"\n\n      iex> IO.chardata_to_string([0x0061, \"bc\"])\n      \"abc\"\n\n      iex> IO.chardata_to_string(\"string\")\n      \"string\"\n\n  "
    },
    description = "\n  Functions handling input/output (IO).\n\n  Many functions in this module expect an IO device as an argument.\n  An IO device must be a PID or an atom representing a process.\n  For convenience, Elixir provides `:stdio` and `:stderr` as\n  shortcuts to Erlang's `:standard_io` and `:standard_error`.\n\n  The majority of the functions expect chardata, i.e. strings or\n  lists of characters and strings. In case another type is given,\n  functions will convert to string via the `String.Chars` protocol\n  (as shown in typespecs).\n\n  The functions starting with `bin` expect iodata as an argument,\n  i.e. binaries or lists of bytes and binaries.\n\n  ## IO devices\n\n  An IO device may be an atom or a PID. In case it is an atom,\n  the atom must be the name of a registered process. In addition,\n  Elixir provides two shortcuts:\n\n    * `:stdio` - a shortcut for `:standard_io`, which maps to\n      the current `Process.group_leader/0` in Erlang\n\n    * `:stderr` - a shortcut for the named process `:standard_error`\n      provided in Erlang\n\n  IO devices maintain their position, that means subsequent calls to any\n  reading or writing functions will start from the place when the device\n  was last accessed. Position of files can be changed using the\n  `:file.position/2` function.\n\n  ",
    device = {
      description = "device :: atom | pid\n"
    },
    each_binstream = {
      description = "each_binstream(device, line_or_chars)\nfalse"
    },
    each_stream = {
      description = "each_stream(device, line_or_codepoints)\nfalse"
    },
    getn = {
      description = "getn(device, chardata | String.Chars.t, pos_integer) :: chardata | nodata\ngetn(device, prompt, count) when is_integer(count) and count > 0\ngetn(device, prompt) when not is_integer(prompt)\ngetn(prompt, count) when is_integer(count) and count > 0\ngetn(device, chardata | String.Chars.t) :: chardata | nodata\ngetn(prompt, count \\\\ 1)\n\n  Gets a number of bytes from IO device `:stdio`.\n\n  If `:stdio` is a Unicode device, `count` implies\n  the number of Unicode codepoints to be retrieved.\n  Otherwise, `count` is the number of raw bytes to be retrieved.\n\n  See `IO.getn/3` for a description of return values.\n\n  "
    },
    gets = {
      description = "gets(device, chardata | String.Chars.t) :: chardata | nodata\ngets(device \\\\ :stdio, prompt)\n\n  Reads a line from the IO `device`.\n\n  It returns:\n\n    * `data` - the characters in the line terminated\n      by a line-feed (LF) or end of file (EOF)\n\n    * `:eof` - end of file was encountered\n\n    * `{:error, reason}` - other (rare) error condition;\n      for instance, `{:error, :estale}` if reading from an\n      NFS volume\n\n  ## Examples\n\n  To display \"What is your name?\" as a prompt and await user input:\n\n      IO.gets \"What is your name?\\n\"\n\n  "
    },
    inspect = {
      description = "inspect(device, item, Keyword.t) :: item when item: var\ninspect(device, item, opts) when is_list(opts)\ninspect(item, Keyword.t) :: item when item: var\ninspect(item, opts \\\\ [])\n\n  Inspects and writes the given `item` to the device.\n\n  It's important to note that it returns the given `item` unchanged.\n  This makes it possible to \"spy\" on values by inserting an\n  `IO.inspect/2` call almost anywhere in your code, for example,\n  in the middle of a pipeline.\n\n  It enables pretty printing by default with width of\n  80 characters. The width can be changed by explicitly\n  passing the `:width` option.\n\n  The output can be decorated with a label, by providing the `:label`\n  option to easily distinguish it from other `IO.inspect/2` calls.\n  The label will be printed before the inspected `item`.\n\n  See `Inspect.Opts` for a full list of remaining formatting options.\n\n  ## Examples\n\n      IO.inspect <<0, 1, 2>>, width: 40\n\n  Prints:\n\n      <<0, 1, 2>>\n\n  We can use the `:label` option to decorate the output:\n\n      IO.inspect 1..100, label: \"a wonderful range\"\n\n  Prints:\n\n      a wonderful range: 1..100\n\n  The `:label` option is especially useful with pipelines:\n\n      [1, 2, 3]\n      |> IO.inspect(label: \"before\")\n      |> Enum.map(&(&1 * 2))\n      |> IO.inspect(label: \"after\")\n      |> Enum.sum\n\n  Prints:\n\n      before: [1, 2, 3]\n      after: [2, 4, 6]\n\n  "
    },
    iodata_length = {
      description = "iodata_length(iodata) :: non_neg_integer\niodata_length(item)\n\n  Returns the size of an iodata.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> IO.iodata_length([1, 2 | <<3, 4>>])\n      4\n\n  "
    },
    iodata_to_binary = {
      description = "iodata_to_binary(iodata) :: binary\niodata_to_binary(item)\n\n  Converts iodata (a list of integers representing bytes, lists\n  and binaries) into a binary.\n  The operation is Unicode unsafe.\n\n  Notice that this function treats lists of integers as raw bytes\n  and does not perform any kind of encoding conversion. If you want\n  to convert from a charlist to a string (UTF-8 encoded), please\n  use `chardata_to_string/1` instead.\n\n  If this function receives a binary, the same binary is returned.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> bin1 = <<1, 2, 3>>\n      iex> bin2 = <<4, 5>>\n      iex> bin3 = <<6>>\n      iex> IO.iodata_to_binary([bin1, 1, [2, 3, bin2], 4 | bin3])\n      <<1, 2, 3, 1, 2, 3, 4, 5, 4, 6>>\n\n      iex> bin = <<1, 2, 3>>\n      iex> IO.iodata_to_binary(bin)\n      <<1, 2, 3>>\n\n  "
    },
    nodata = {
      description = "nodata :: {:error, term} | :eof\n"
    },
    puts = {
      description = "puts(device, chardata | String.Chars.t) :: :ok\nputs(device \\\\ :stdio, item)\n\n  Writes `item` to the given `device`, similar to `write/2`,\n  but adds a newline at the end.\n  "
    },
    read = {
      description = "read(device, count) when is_integer(count) and count >= 0\nread(device, :line)\nread(device, :all)\nread(device, :all | :line | non_neg_integer) :: chardata | nodata\nread(device \\\\ :stdio, line_or_chars)\n\n  Reads from the IO `device`.\n\n  The `device` is iterated by the given number of characters or line by line if\n  `:line` is given.\n  Alternatively, if `:all` is given, then whole `device` is returned.\n\n  It returns:\n\n    * `data` - the output characters\n\n    * `:eof` - end of file was encountered\n\n    * `{:error, reason}` - other (rare) error condition;\n      for instance, `{:error, :estale}` if reading from an\n      NFS volume\n\n  If `:all` is given, `:eof` is never returned, but an\n  empty string in case the device has reached EOF.\n  "
    },
    stream = {
      description = "stream(device, :line | pos_integer) :: Enumerable.t\nstream(device, line_or_codepoints)\n\n  Converts the IO `device` into an `IO.Stream`.\n\n  An `IO.Stream` implements both `Enumerable` and\n  `Collectable`, allowing it to be used for both read\n  and write.\n\n  The `device` is iterated by the given number of characters or line by line if\n  `:line` is given.\n\n  This reads from the IO as UTF-8. Check out\n  `IO.binstream/2` to handle the IO as a raw binary.\n\n  Note that an IO stream has side effects and every time\n  you go over the stream you may get different results.\n\n  ## Examples\n\n  Here is an example on how we mimic an echo server\n  from the command line:\n\n      Enum.each IO.stream(:stdio, :line), &IO.write(&1)\n\n  "
    },
    warn = {
      description = "warn(chardata | String.Chars.t) :: :ok\nwarn(message)\nwarn(message, stacktrace) when is_list(stacktrace)\nwarn(chardata | String.Chars.t, Exception.stacktrace) :: :ok\nwarn(message, [])\n\n  Writes a `message` to stderr, along with the given `stacktrace`.\n\n  This function also notifies the compiler a warning was printed\n  (in case --warnings-as-errors was enabled). It returns `:ok`\n  if it succeeds.\n\n  An empty list can be passed to avoid stacktrace printing.\n\n  ## Examples\n\n      stacktrace = [{MyApp, :main, 1, [file: 'my_app.ex', line: 4]}]\n      IO.warn \"variable bar is unused\", stacktrace\n      #=> warning: variable bar is unused\n      #=>   my_app.ex:4: MyApp.main/1\n\n  "
    },
    write = {
      description = "write(device, chardata | String.Chars.t) :: :ok\nwrite(device \\\\ :stdio, item)\n\n  Writes `item` to the given `device`.\n\n  By default the `device` is the standard output.\n  It returns `:ok` if it succeeds.\n\n  ## Examples\n\n      IO.write \"sample\"\n      #=> sample\n\n      IO.write :stderr, \"error\"\n      #=> error\n\n  "
    }
  },
  Inspect = {
    Algebra = {
      ["break"] = {
        description = "break() :: doc_break\nbreak()\nbreak(binary) :: doc_break\nbreak(string) when is_binary(string)\n\n  Returns a document entity representing a break based on the given\n  `string`.\n\n  This break can be rendered as a linebreak or as the given `string`,\n  depending on the `mode` of the chosen layout or the provided\n  separator.\n\n  ## Examples\n\n  Let's create a document by concatenating two strings with a break between\n  them:\n\n      iex> doc = Inspect.Algebra.concat([\"a\", Inspect.Algebra.break(\"\\t\"), \"b\"])\n      iex> Inspect.Algebra.format(doc, 80)\n      [\"a\", \"\\t\", \"b\"]\n\n  Notice the break was represented with the given string, because we didn't\n  reach a line limit. Once we do, it is replaced by a newline:\n\n      iex> break = Inspect.Algebra.break(\"\\t\")\n      iex> doc = Inspect.Algebra.concat([String.duplicate(\"a\", 20), break, \"b\"])\n      iex> Inspect.Algebra.format(doc, 10)\n      [\"aaaaaaaaaaaaaaaaaaaa\", \"\\n\", \"b\"]\n\n  "
      },
      color = {
        description = "color(t, Inspect.Opts.color_key, Inspect.Opts.t) :: doc_color\ncolor(doc, color_key, %Inspect.Opts{syntax_colors: syntax_colors}) when is_doc(doc)\n\n  Colors a document if the `color_key` has a color in the options.\n  "
      },
      concat = {
        description = "concat([t]) :: t\nconcat(docs) when is_list(docs)\nconcat(t, t) :: t\nconcat(doc1, doc2) when is_doc(doc1) and is_doc(doc2)\n\n  Concatenates two document entities returning a new document.\n\n  ## Examples\n\n      iex> doc = Inspect.Algebra.concat(\"hello\", \"world\")\n      iex> Inspect.Algebra.format(doc, 80)\n      [\"hello\", \"world\"]\n\n  "
      },
      description = "\n  A set of functions for creating and manipulating algebra\n  documents.\n\n  This module implements the functionality described in\n  [\"Strictly Pretty\" (2000) by Christian Lindig][0] with small\n  additions, like support for String nodes, and a custom\n  rendering function that maximises horizontal space use.\n\n      iex> Inspect.Algebra.empty\n      :doc_nil\n\n      iex> \"foo\"\n      \"foo\"\n\n  With the functions in this module, we can concatenate different\n  elements together and render them:\n\n      iex> doc = Inspect.Algebra.concat(Inspect.Algebra.empty, \"foo\")\n      iex> Inspect.Algebra.format(doc, 80)\n      [\"foo\"]\n\n  The functions `nest/2`, `space/2` and `line/2` help you put the\n  document together into a rigid structure. However, the document\n  algebra gets interesting when using functions like `break/1`, which\n  converts the given string into a line break depending on how much space\n  there is to print. Let's glue two docs together with a break and then\n  render it:\n\n      iex> doc = Inspect.Algebra.glue(\"a\", \" \", \"b\")\n      iex> Inspect.Algebra.format(doc, 80)\n      [\"a\", \" \", \"b\"]\n\n  Notice the break was represented as is, because we haven't reached\n  a line limit. Once we do, it is replaced by a newline:\n\n      iex> doc = Inspect.Algebra.glue(String.duplicate(\"a\", 20), \" \", \"b\")\n      iex> Inspect.Algebra.format(doc, 10)\n      [\"aaaaaaaaaaaaaaaaaaaa\", \"\\n\", \"b\"]\n\n  Finally, this module also contains Elixir related functions, a bit\n  tied to Elixir formatting, namely `surround/3` and `surround_many/5`.\n\n  ## Implementation details\n\n  The original Haskell implementation of the algorithm by [Wadler][1]\n  relies on lazy evaluation to unfold document groups on two alternatives:\n  `:flat` (breaks as spaces) and `:break` (breaks as newlines).\n  Implementing the same logic in a strict language such as Elixir leads\n  to an exponential growth of possible documents, unless document groups\n  are encoded explicitly as `:flat` or `:break`. Those groups are then reduced\n  to a simple document, where the layout is already decided, per [Lindig][0].\n\n  This implementation slightly changes the semantic of Lindig's algorithm\n  to allow elements that belong to the same group to be printed together\n  in the same line, even if they do not fit the line fully. This was achieved\n  by changing `:break` to mean a possible break and `:flat` to force a flat\n  structure. Then deciding if a break works as a newline is just a matter\n  of checking if we have enough space until the next break that is not\n  inside a group (which is still flat).\n\n  Custom pretty printers can be implemented using the documents returned\n  by this module and by providing their own rendering functions.\n\n    [0]: http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.34.2200\n    [1]: http://homepages.inf.ed.ac.uk/wadler/papers/prettier/prettier.pdf\n\n  ",
      empty = {
        description = "empty() :: :doc_nil\nempty\n\n  Returns a document entity used to represent nothingness.\n\n  ## Examples\n\n      iex> Inspect.Algebra.empty\n      :doc_nil\n\n  "
      },
      fold_doc = {
        description = "fold_doc([doc | docs], folder_fun) when is_function(folder_fun, 2),\nfold_doc([doc], _folder_fun),\nfold_doc([], _folder_fun),\nfold_doc([t], ((t, t) -> t)) :: t\nfold_doc(docs, folder_fun)\n\n  Folds a list of documents into a document using the given folder function.\n\n  The list of documents is folded \"from the right\"; in that, this function is\n  similar to `List.foldr/3`, except that it doesn't expect an initial\n  accumulator and uses the last element of `docs` as the initial accumulator.\n\n  ## Examples\n\n      iex> docs = [\"A\", \"B\", \"C\"]\n      iex> docs = Inspect.Algebra.fold_doc(docs, fn(doc, acc) ->\n      ...>   Inspect.Algebra.concat([doc, \"!\", acc])\n      ...> end)\n      iex> Inspect.Algebra.format(docs, 80)\n      [\"A\", \"!\", \"B\", \"!\", \"C\"]\n\n  "
      },
      format = {
        description = "format(t, non_neg_integer | :infinity) :: iodata\nformat(doc, width) when is_doc(doc) and (width == :infinity or width >= 0)\n\n  Formats a given document for a given width.\n\n  Takes the maximum width and a document to print as its arguments\n  and returns an IO data representation of the best layout for the\n  document to fit in the given width.\n\n  ## Examples\n\n      iex> doc = Inspect.Algebra.glue(\"hello\", \" \", \"world\")\n      iex> Inspect.Algebra.format(doc, 30) |> IO.iodata_to_binary()\n      \"hello world\"\n      iex> Inspect.Algebra.format(doc, 10) |> IO.iodata_to_binary()\n      \"hello\\nworld\"\n\n  "
      },
      glue = {
        description = "glue(t, binary, t) :: t\nglue(doc1, break_string, doc2) when is_binary(break_string),\nglue(t, t) :: t\nglue(doc1, doc2)\n\n  Glues two documents together inserting `\" \"` as a break between them.\n\n  This means the two documents will be separeted by `\" \"` in case they\n  fit in the same line. Otherwise a line break is used.\n\n  ## Examples\n\n      iex> doc = Inspect.Algebra.glue(\"hello\", \"world\")\n      iex> Inspect.Algebra.format(doc, 80)\n      [\"hello\", \" \", \"world\"]\n\n  "
      },
      group = {
        description = "group(t) :: doc_group\ngroup(doc) when is_doc(doc)\n\n  Returns a group containing the specified document `doc`.\n\n  Documents in a group are attempted to be rendered together\n  to the best of the renderer ability.\n\n  ## Examples\n\n      iex> doc = Inspect.Algebra.group(\n      ...>   Inspect.Algebra.concat(\n      ...>     Inspect.Algebra.group(\n      ...>       Inspect.Algebra.concat(\n      ...>         \"Hello,\",\n      ...>         Inspect.Algebra.concat(\n      ...>           Inspect.Algebra.break,\n      ...>           \"A\"\n      ...>         )\n      ...>       )\n      ...>     ),\n      ...>     Inspect.Algebra.concat(\n      ...>       Inspect.Algebra.break,\n      ...>       \"B\"\n      ...>     )\n      ...> ))\n      iex> Inspect.Algebra.format(doc, 80)\n      [\"Hello,\", \" \", \"A\", \" \", \"B\"]\n      iex> Inspect.Algebra.format(doc, 6)\n      [\"Hello,\", \"\\n\", \"A\", \" \", \"B\"]\n\n  "
      },
      line = {
        description = "line(t, t) :: t\nline(doc1, doc2)\n\n  Inserts a mandatory linebreak between two documents.\n\n  ## Examples\n\n      iex> doc = Inspect.Algebra.line(\"Hughes\", \"Wadler\")\n      iex> Inspect.Algebra.format(doc, 80)\n      [\"Hughes\", \"\\n\", \"Wadler\"]\n\n  "
      },
      nest = {
        description = "nest(doc, level) when is_doc(doc) and is_integer(level) and level > 0\nnest(doc, 0) when is_doc(doc)\nnest(t, non_neg_integer) :: doc_nest\nnest(doc, level)\n\n  Nests the given document at the given `level`.\n\n  Nesting will be appended to the line breaks.\n\n  ## Examples\n\n      iex> doc = Inspect.Algebra.nest(Inspect.Algebra.glue(\"hello\", \"world\"), 5)\n      iex> Inspect.Algebra.format(doc, 5)\n      [\"hello\", \"\\n     \", \"world\"]\n\n  "
      },
      space = {
        description = "space(t, t) :: t\nspace(doc1, doc2)\n\n  Inserts a mandatory single space between two documents.\n\n  ## Examples\n\n      iex> doc = Inspect.Algebra.space(\"Hughes\", \"Wadler\")\n      iex> Inspect.Algebra.format(doc, 5)\n      [\"Hughes\", \" \", \"Wadler\"]\n\n  "
      },
      surround = {
        description = "surround(t, t, t) :: t\nsurround(left, doc, right) when is_doc(left) and is_doc(doc) and is_doc(right)\n\n  Surrounds a document with characters.\n\n  Puts the given document `doc` between the `left` and `right` documents enclosing\n  and nesting it. The document is marked as a group, to show the maximum as\n  possible concisely together.\n\n  ## Examples\n\n      iex> doc = Inspect.Algebra.surround(\"[\", Inspect.Algebra.glue(\"a\", \"b\"), \"]\")\n      iex> Inspect.Algebra.format(doc, 3)\n      [\"[\", \"a\", \"\\n \", \"b\", \"]\"]\n\n  "
      },
      surround_many = {
        description = "surround_many(t, [any], t, Inspect.Opts.t, (term, Inspect.Opts.t -> t), t) :: t\nsurround_many(left, docs, right, %Inspect.Opts{} = opts, fun, separator \\\\ @surround_separator)\n\n  Maps and glues a collection of items.\n\n  It uses the given `left` and `right` documents as surrounding and the\n  separator document `separator` to separate items in `docs`. A limit can be\n  passed: when this limit is reached, this function stops gluing and outputs\n  `\"...\"` instead.\n\n  ## Examples\n\n      iex> doc = Inspect.Algebra.surround_many(\"[\", Enum.to_list(1..5), \"]\",\n      ...>         %Inspect.Opts{limit: :infinity}, fn i, _opts -> to_string(i) end)\n      iex> Inspect.Algebra.format(doc, 5) |> IO.iodata_to_binary\n      \"[1,\\n 2,\\n 3,\\n 4,\\n 5]\"\n\n      iex> doc = Inspect.Algebra.surround_many(\"[\", Enum.to_list(1..5), \"]\",\n      ...>         %Inspect.Opts{limit: 3}, fn i, _opts -> to_string(i) end)\n      iex> Inspect.Algebra.format(doc, 20) |> IO.iodata_to_binary\n      \"[1, 2, 3, ...]\"\n\n      iex> doc = Inspect.Algebra.surround_many(\"[\", Enum.to_list(1..5), \"]\",\n      ...>         %Inspect.Opts{limit: 3}, fn i, _opts -> to_string(i) end, \"!\")\n      iex> Inspect.Algebra.format(doc, 20) |> IO.iodata_to_binary\n      \"[1! 2! 3! ...]\"\n\n  "
      },
      t = {
        description = "t :: :doc_nil | :doc_line | doc_cons | doc_nest | doc_break | doc_group | doc_color | binary\n"
      },
      to_doc = {
        description = "to_doc(arg, %Inspect.Opts{} = opts)\nto_doc(%{__struct__: struct} = map, %Inspect.Opts{} = opts) when is_atom(struct)\nto_doc(any, Inspect.Opts.t) :: t\nto_doc(term, opts)\n\n  Converts an Elixir term to an algebra document\n  according to the `Inspect` protocol.\n  "
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
      description = "escape(other, char)\nescape(binary)\n"
    },
    escape_char = {
      description = "escape_char(char) when char < 0x1000000\nescape_char(char) when char < 0x10000\nescape_char(char) when char < 0x100\nescape_char(0)\nfalse"
    },
    escape_name = {
      description = "escape_name(name) when is_binary(name)\nescape_name(name) when is_atom(name)\nfalse"
    },
    extract_anonymous_fun_parent = {
      description = "extract_anonymous_fun_parent(other) when is_binary(other)\nextract_anonymous_fun_parent(\"-\" <> rest)\nfalse"
    },
    inspect = {
      description = "inspect(%{__struct__: struct} = map, opts)\ninspect(ref, _opts)\ninspect(port, _opts)\ninspect(pid, _opts)\ninspect(function, _opts)\ninspect(regex, opts)\ninspect(term, opts)\ninspect(term, %Inspect.Opts{base: base} = opts)\ninspect(map, name, opts)\ninspect(map, opts)\ninspect(tuple, opts)\ninspect(term, %Inspect.Opts{charlists: lists, char_lists: lists_deprecated} = opts)\ninspect([], opts)\ninspect(term, opts)\ninspect(term, %Inspect.Opts{binaries: bins, base: base} = opts) when is_binary(term)\ninspect(atom)\ninspect(atom) when is_nil(atom) or is_boolean(atom)\ninspect(atom, opts)\ninspect(term, opts)\n"
    },
    keyword = {
      description = "keyword({key, value}, opts)\nfalse"
    },
    ["keyword?"] = {
      description = "keyword?(_other)\nkeyword?([])\nkeyword?([{key, _value} | rest]) when is_atom(key)\nfalse"
    },
    ["printable?"] = {
      description = "printable?(_)\nprintable?([])\nprintable?([?\\a | rest])\nprintable?([?\\e | rest])\nprintable?([?\\f | rest])\nprintable?([?\\b | rest])\nprintable?([?\\v | rest])\nprintable?([?\\t | rest])\nprintable?([?\\r | rest])\nprintable?([?\\n | rest])\nprintable?([char | rest]) when char in 32..126\nfalse"
    }
  },
  Integer = {
    description = "\n  Functions for working with integers.\n  ",
    digits = {
      description = "digits(integer, pos_integer) :: [integer, ...]\ndigits(integer, base \\\\ 10)\n\n  Returns the ordered digits for the given `integer`.\n\n  An optional `base` value may be provided representing the radix for the returned\n  digits. This one must be an integer >= 2.\n\n  ## Examples\n\n      iex> Integer.digits(123)\n      [1, 2, 3]\n\n      iex> Integer.digits(170, 2)\n      [1, 0, 1, 0, 1, 0, 1, 0]\n\n      iex> Integer.digits(-170, 2)\n      [-1, 0, -1, 0, -1, 0, -1, 0]\n\n  "
    },
    floor_div = {
      description = "floor_div(integer, neg_integer | pos_integer) :: integer\nfloor_div(dividend, divisor)\n\n  Performs a floored integer division.\n\n  Raises an `ArithmeticError` exception if one of the arguments is not an\n  integer, or when the `divisor` is `0`.\n\n  `Integer.floor_div/2` performs *floored* integer division. This means that\n  the result is always rounded towards negative infinity.\n\n  If you want to perform truncated integer division (rounding towards zero),\n  use `Kernel.div/2` instead.\n\n  ## Examples\n\n      iex> Integer.floor_div(5, 2)\n      2\n      iex> Integer.floor_div(6, -4)\n      -2\n      iex> Integer.floor_div(-99, 2)\n      -50\n\n  "
    },
    mod = {
      description = "mod(integer, neg_integer | pos_integer) :: integer\nmod(dividend, divisor)\n\n  Computes the modulo remainder of an integer division.\n\n  `Integer.mod/2` uses floored division, which means that\n  the result will always have the sign of the `divisor`.\n\n  Raises an `ArithmeticError` exception if one of the arguments is not an\n  integer, or when the `divisor` is `0`.\n\n  ## Examples\n\n      iex> Integer.mod(5, 2)\n      1\n      iex> Integer.mod(6, -4)\n      -2\n\n  "
    },
    parse = {
      description = "parse(binary, base) when is_binary(binary)\nparse(binary, base) when is_binary(binary) and base in 2..36\nparse(\"\", base) when base in 2..36,\nparse(binary, 2..36) :: {integer, binary} | :error | no_return\nparse(binary, base \\\\ 10)\n\n  Parses a text representation of an integer.\n\n  An optional `base` to the corresponding integer can be provided.\n  If `base` is not given, 10 will be used.\n\n  If successful, returns a tuple in the form of `{integer, remainder_of_binary}`.\n  Otherwise `:error`.\n\n  Raises an error if `base` is less than 2 or more than 36.\n\n  If you want to convert a string-formatted integer directly to a integer,\n  `String.to_integer/1` or `String.to_integer/2` can be used instead.\n\n  ## Examples\n\n      iex> Integer.parse(\"34\")\n      {34, \"\"}\n\n      iex> Integer.parse(\"34.5\")\n      {34, \".5\"}\n\n      iex> Integer.parse(\"three\")\n      :error\n\n      iex> Integer.parse(\"34\", 10)\n      {34, \"\"}\n\n      iex> Integer.parse(\"f4\", 16)\n      {244, \"\"}\n\n      iex> Integer.parse(\"Awww++\", 36)\n      {509216, \"++\"}\n\n      iex> Integer.parse(\"fab\", 10)\n      :error\n\n      iex> Integer.parse(\"a2\", 38)\n      ** (ArgumentError) invalid base 38\n\n  "
    },
    to_char_list = {
      description = "to_char_list(integer) :: charlist\nto_char_list(integer)\nfalse"
    },
    to_charlist = {
      description = "to_charlist(integer, 2..36) :: charlist\nto_charlist(integer, base)\nto_charlist(integer) :: charlist\nto_charlist(integer)\n\n  Returns a charlist which corresponds to the text representation of the given `integer`.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> Integer.to_charlist(123)\n      '123'\n\n      iex> Integer.to_charlist(+456)\n      '456'\n\n      iex> Integer.to_charlist(-789)\n      '-789'\n\n      iex> Integer.to_charlist(0123)\n      '123'\n\n  "
    },
    to_string = {
      description = "to_string(integer, 2..36) :: String.t\nto_string(integer, base)\nto_string(integer) :: String.t\nto_string(integer)\n\n  Returns a binary which corresponds to the text representation\n  of `integer`.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> Integer.to_string(123)\n      \"123\"\n\n      iex> Integer.to_string(+456)\n      \"456\"\n\n      iex> Integer.to_string(-789)\n      \"-789\"\n\n      iex> Integer.to_string(0123)\n      \"123\"\n\n  "
    },
    undigits = {
      description = "undigits([integer], integer) :: integer\nundigits(digits, base \\\\ 10) when is_list(digits) and is_integer(base) and base >= 2\n\n  Returns the integer represented by the ordered `digits`.\n\n  An optional `base` value may be provided representing the radix for the `digits`.\n  This one can be an integer >= 2.\n\n  ## Examples\n\n      iex> Integer.undigits([1, 2, 3])\n      123\n\n      iex> Integer.undigits([1, 4], 16)\n      20\n\n      iex> Integer.undigits([])\n      0\n\n  "
    }
  },
  InvalidRequirementError = {},
  InvalidVersionError = {
    compare = {
      description = "compare(version, version) :: :gt | :eq | :lt\ncompare(version1, version2)\n\n  Compares two versions. Returns `:gt` if the first version is greater than\n  the second one, and `:lt` for vice versa. If the two versions are equal `:eq`\n  is returned.\n\n  Pre-releases are strictly less than their corresponding release versions.\n\n  Patch segments are compared lexicographically if they are alphanumeric, and\n  numerically otherwise.\n\n  Build segments are ignored, if two versions differ only in their build segment\n  they are considered to be equal.\n\n  Raises a `Version.InvalidVersionError` exception if any of the two are not\n  parsable. If given an already parsed version this function won't raise.\n\n  ## Examples\n\n      iex> Version.compare(\"2.0.1-alpha1\", \"2.0.0\")\n      :gt\n\n      iex> Version.compare(\"1.0.0-beta\", \"1.0.0-rc1\")\n      :lt\n\n      iex> Version.compare(\"1.0.0-10\", \"1.0.0-2\")\n      :gt\n\n      iex> Version.compare(\"2.0.1+build0\", \"2.0.1\")\n      :eq\n\n      iex> Version.compare(\"invalid\", \"2.0.1\")\n      ** (Version.InvalidVersionError) invalid\n\n  "
    },
    compile_requirement = {
      description = "compile_requirement(Requirement.t) :: Requirement.t\ncompile_requirement(%Requirement{matchspec: spec} = req)\n\n  Compiles a requirement to its internal representation with\n  `:ets.match_spec_compile/1` for faster matching.\n\n  The internal representation is opaque and can not be converted to external\n  term format and then back again without losing its properties (meaning it\n  can not be sent to a process on another node and still remain a valid\n  compiled match_spec, nor can it be stored on disk).\n  "
    },
    ["match?"] = {
      description = "match?(version, %Requirement{matchspec: spec, compiled: true}, opts)\nmatch?(version, %Requirement{matchspec: spec, compiled: false}, opts)\nmatch?(version, requirement, opts) when is_binary(requirement)\nmatch?(version, requirement, Keyword.t) :: boolean\nmatch?(version, requirement, opts \\\\ [])\n\n  Checks if the given version matches the specification.\n\n  Returns `true` if `version` satisfies `requirement`, `false` otherwise.\n  Raises a `Version.InvalidRequirementError` exception if `requirement` is not\n  parsable, or `Version.InvalidVersionError` if `version` is not parsable.\n  If given an already parsed version and requirement this function won't\n  raise.\n\n  ## Options\n\n    * `:allow_pre` - when `false` pre-release versions will not match\n      unless the operand is a pre-release version, see the table above\n      for examples  (default: `true`);\n\n  ## Examples\n\n      iex> Version.match?(\"2.0.0\", \">1.0.0\")\n      true\n\n      iex> Version.match?(\"2.0.0\", \"==1.0.0\")\n      false\n\n      iex> Version.match?(\"foo\", \"==1.0.0\")\n      ** (Version.InvalidVersionError) foo\n\n      iex> Version.match?(\"2.0.0\", \"== ==1.0.0\")\n      ** (Version.InvalidRequirementError) == ==1.0.0\n\n  "
    },
    parse = {
      description = "parse(String.t) :: {:ok, t} | :error\nparse(string) when is_binary(string)\n\n  Parses a version string into a `Version`.\n\n  ## Examples\n\n      iex> {:ok, version} = Version.parse(\"2.0.1-alpha1\")\n      iex> version\n      #Version<2.0.1-alpha1>\n\n      iex> Version.parse(\"2.0-alpha1\")\n      :error\n\n  "
    },
    ["parse!"] = {
      description = "parse!(String.t) :: t | no_return\nparse!(string) when is_binary(string)\n\n  Parses a version string into a `Version`.\n\n  If `string` is an invalid version, an `InvalidVersionError` is raised.\n\n  ## Examples\n\n      iex> Version.parse!(\"2.0.1-alpha1\")\n      #Version<2.0.1-alpha1>\n\n      iex> Version.parse!(\"2.0-alpha1\")\n      ** (Version.InvalidVersionError) 2.0-alpha1\n\n  "
    },
    parse_requirement = {
      description = "parse_requirement(String.t) :: {:ok, Requirement.t} | :error\nparse_requirement(string) when is_binary(string)\n\n  Parses a version requirement string into a `Version.Requirement`.\n\n  ## Examples\n\n      iex> {:ok, req} = Version.parse_requirement(\"== 2.0.1\")\n      iex> req\n      #Version.Requirement<== 2.0.1>\n\n      iex> Version.parse_requirement(\"== == 2.0.1\")\n      :error\n\n  "
    }
  },
  Kernel = {
    [""] = nil,
    CLI = nil,
    ErrorHandler = nil,
    LexicalTracker = {
      add_alias = {
        description = "add_alias(pid, module, line, warn) when is_atom(module)\nfalse"
      },
      add_import = {
        description = "add_import(pid, module, fas, line, warn) when is_atom(module)\nfalse"
      },
      alias_dispatch = {
        description = "alias_dispatch(pid, module) when is_atom(module)\nfalse"
      },
      code_change = {
        description = "code_change(_old, state, _extra)\nfalse"
      },
      collect_unused_aliases = {
        description = "collect_unused_aliases(pid)\nfalse"
      },
      collect_unused_imports = {
        description = "collect_unused_imports(pid)\nfalse"
      },
      description = "false",
      dest = {
        description = "dest(arg)\n\n  Gets the destination the lexical scope is meant to\n  compile to.\n  "
      },
      handle_call = {
        description = "handle_call(:dest, _from, state)\nhandle_call(:remote_dispatches, _from, state)\nhandle_call(:remote_references, _from, state)\nhandle_call({:unused, tag}, _from, state)\nfalse"
      },
      handle_cast = {
        description = "handle_cast(:stop, state)\nhandle_cast({:add_alias, module, line, warn}, state)\nhandle_cast({:add_import, module, fas, line, warn}, state)\nhandle_cast({:alias_dispatch, module}, state)\nhandle_cast({:import_dispatch, module, {function, arity} = fa, line, mode}, state)\nhandle_cast({:remote_dispatch, module, fa, line, mode}, state)\nhandle_cast({:remote_reference, module, mode}, state)\nfalse"
      },
      handle_info = {
        description = "handle_info(_msg, state)\nfalse"
      },
      import_dispatch = {
        description = "import_dispatch(pid, module, fa, line, mode) when is_atom(module)\nfalse"
      },
      init = {
        description = "init(dest)\nfalse"
      },
      remote_dispatch = {
        description = "remote_dispatch(pid, module, fa, line, mode) when is_atom(module)\nfalse"
      },
      remote_dispatches = {
        description = "remote_dispatches(arg)\n\n  Returns all remote dispatches in this lexical scope.\n  "
      },
      remote_reference = {
        description = "remote_reference(pid, module, mode) when is_atom(module)\nfalse"
      },
      remote_references = {
        description = "remote_references(arg)\n\n  Returns all remotes referenced in this lexical scope.\n  "
      },
      start_link = {
        description = "start_link(dest)\nfalse"
      },
      stop = {
        description = "stop(pid)\nfalse"
      },
      terminate = {
        description = "terminate(_reason, _state)\nfalse"
      }
    },
    ParallelCompiler = {
      description = "\n  A module responsible for compiling files in parallel.\n  ",
      files = {
        description = "files(files, options) when is_list(options)\nfiles(files, options \\\\ [])\n\n  Compiles the given files.\n\n  Those files are compiled in parallel and can automatically\n  detect dependencies between them. Once a dependency is found,\n  the current file stops being compiled until the dependency is\n  resolved.\n\n  If there is an error during compilation or if `warnings_as_errors`\n  is set to `true` and there is a warning, this function will fail\n  with an exception.\n\n  This function accepts the following options:\n\n    * `:each_file` - for each file compiled, invokes the callback passing the\n      file\n\n    * `:each_long_compilation` - for each file that takes more than a given\n      timeout (see the `:long_compilation_threshold` option) to compile, invoke\n      this callback passing the file as its argument\n\n    * `:long_compilation_threshold` - the timeout (in seconds) after the\n      `:each_long_compilation` callback is invoked; defaults to `10`\n\n    * `:each_module` - for each module compiled, invokes the callback passing\n      the file, module and the module bytecode\n\n    * `:dest` - the destination directory for the BEAM files. When using `files/2`,\n      this information is only used to properly annotate the BEAM files before\n      they are loaded into memory. If you want a file to actually be written to\n      `dest`, use `files_to_path/3` instead.\n\n  Returns the modules generated by each compiled file.\n  "
      },
      files_to_path = {
        description = "files_to_path(files, path, options) when is_binary(path) and is_list(options)\nfiles_to_path(files, path, options \\\\ [])\n\n  Compiles the given files to the given path.\n  Read `files/2` for more information.\n  "
      }
    },
    ParallelRequire = {
      description = "\n  A module responsible for requiring files in parallel.\n  ",
      files = {
        description = "files(files, callbacks) when is_list(callbacks)\nfiles(files, callback) when is_function(callback, 1)\nfiles(files, callbacks \\\\ [])\n\n  Requires the given files.\n\n  A callback that will be invoked with each file, or a keyword list of `callbacks` can be provided:\n\n    * `:each_file` - invoked with each file\n\n    * `:each_module` - invoked with file, module name, and binary code\n\n  Returns the modules generated by each required file.\n  "
      }
    },
    SpecialForms = {
      description = "\n  Special forms are the basic building blocks of Elixir, and therefore\n  cannot be overridden by the developer.\n\n  We define them in this module. Some of these forms are lexical (like\n  `alias/2`, `case/2`, etc). The macros `{}` and `<<>>` are also special\n  forms used to define tuple and binary data structures respectively.\n\n  This module also documents macros that return information about Elixir's\n  compilation environment, such as (`__ENV__/0`, `__MODULE__/0`, `__DIR__/0` and `__CALLER__/0`).\n\n  Finally, it also documents two special forms, `__block__/1` and\n  `__aliases__/1`, which are not intended to be called directly by the\n  developer but they appear in quoted contents since they are essential\n  in Elixir's constructs.\n  "
    },
    Typespec = {
      beam_callbacks = {
        description = "beam_callbacks(module | binary) :: [tuple] | nil\nbeam_callbacks(module) when is_atom(module) or is_binary(module)\n\n  Returns all callbacks available from the module's BEAM code.\n\n  The result is returned as a list of tuples where the first\n  element is spec name and arity and the second is the spec.\n\n  The module must have a corresponding BEAM file\n  which can be located by the runtime system.\n  "
      },
      beam_specs = {
        description = "beam_specs(module | binary) :: [tuple] | nil\nbeam_specs(module) when is_atom(module) or is_binary(module)\n\n  Returns all specs available from the module's BEAM code.\n\n  The result is returned as a list of tuples where the first\n  element is spec name and arity and the second is the spec.\n\n  The module must have a corresponding BEAM file which can be\n  located by the runtime system.\n  "
      },
      beam_typedocs = {
        description = "beam_typedocs(module) when is_atom(module) or is_binary(module)\nfalse"
      },
      beam_types = {
        description = "beam_types(module | binary) :: [tuple] | nil\nbeam_types(module) when is_atom(module) or is_binary(module)\n\n  Returns all types available from the module's BEAM code.\n\n  The result is returned as a list of tuples where the first\n  element is the type (`:typep`, `:type` and `:opaque`).\n\n  The module must have a corresponding BEAM file which can be\n  located by the runtime system.\n  "
      },
      define_spec = {
        description = "define_spec(atom, Macro.t, Macro.Env.t) :: Keyword.t\ndefine_spec(kind, expr, env)\n\n  Defines a `spec` by receiving a typespec expression.\n  "
      },
      define_type = {
        description = "define_type(kind, expr, doc \\\\ nil, env)\n\n  Defines a `type`, `typep` or `opaque` by receiving a typespec expression.\n  "
      },
      ["defines_callback?"] = {
        description = "defines_callback?(module, atom, arity) :: boolean\ndefines_callback?(module, name, arity)\n\n  Returns `true` if the current module defines a callback.\n  This function is only available for modules being compiled.\n  "
      },
      ["defines_spec?"] = {
        description = "defines_spec?(module, atom, arity) :: boolean\ndefines_spec?(module, name, arity)\n\n  Returns `true` if the current module defines a given spec.\n  This function is only available for modules being compiled.\n  "
      },
      ["defines_type?"] = {
        description = "defines_type?(module, atom, arity) :: boolean\ndefines_type?(module, name, arity)\n\n  Returns `true` if the current module defines a given type\n  (private, opaque or not). This function is only available\n  for modules being compiled.\n  "
      },
      defspec = {
        description = "defspec(kind, expr, caller)\ndefspec(kind, expr, caller) when kind in [:callback, :macrocallback]\nfalse"
      },
      deftype = {
        description = "deftype(kind, expr, caller)\nfalse"
      },
      description = "false",
      spec_to_ast = {
        description = "spec_to_ast(name, {:type, line, :bounded_fun, [{:type, _, :fun, [{:type, _, :product, args}, result]}, constraints]})\nspec_to_ast(name, {:type, line, :fun, []}) when is_atom(name)\nspec_to_ast(name, {:type, line, :fun, [{:type, _, :product, args}, result]})\nspec_to_ast(atom, tuple) :: {atom, Keyword.t, [Macro.t]}\nspec_to_ast(name, spec)\n\n  Converts a spec clause back to Elixir AST.\n  "
      },
      spec_to_signature = {
        description = "spec_to_signature(other),\nspec_to_signature({:when, _, [spec, _]}),\nfalse"
      },
      translate_spec = {
        description = "translate_spec(kind, spec, caller)\ntranslate_spec(kind, {:when, _meta, [spec, guard]}, caller)\nfalse"
      },
      translate_type = {
        description = "translate_type(_kind, other, caller)\ntranslate_type(kind, {:::, _, [{name, _, args}, definition]}, caller) when is_atom(name) and name != :::\nfalse"
      },
      type_to_ast = {
        description = "type_to_ast({name, type, args}) when is_atom(name)\ntype_to_ast({{:record, record}, fields, args}) when is_atom(record)\ntype_to_ast(type)\n\n  Converts a type clause back to Elixir AST.\n  "
      },
      type_to_signature = {
        description = "type_to_signature(_),\ntype_to_signature({:::, _, [{name, _, args}, _]}) when is_atom(name),\ntype_to_signature({:::, _, [{name, _, context}, _]}) when is_atom(name) and is_atom(context),\nfalse"
      }
    },
    Utils = {
      announce_struct = {
        description = "announce_struct(module)\n\n  Announcing callback for defstruct.\n  "
      },
      defdelegate = {
        description = "defdelegate(fun, opts) when is_list(opts)\n\n  Callback for defdelegate.\n  "
      },
      defstruct = {
        description = "defstruct(module, fields)\n\n  Callback for defstruct.\n  "
      },
      description = "false",
      destructure = {
        description = "destructure(nil, count) when is_integer(count) and count >= 0,\ndestructure(list, count) when is_list(list) and is_integer(count) and count >= 0,\n\n  Callback for destructure.\n  "
      },
      raise = {
        description = "raise(other)\nraise(%{__struct__: struct, __exception__: true} = exception) when is_atom(struct)\nraise(atom) when is_atom(atom)\nraise(msg) when is_binary(msg)\n\n  Callback for raise.\n  "
      }
    },
    __struct__ = {
      description = "__struct__()\n__struct__(kv)\n__struct__(kv)\n\n  Defines a struct.\n\n  A struct is a tagged map that allows developers to provide\n  default values for keys, tags to be used in polymorphic\n  dispatches and compile time assertions.\n\n  To define a struct, a developer must define both `__struct__/0` and\n  `__struct__/1` functions. `defstruct/1` is a convenience macro which\n  defines such functions with some conveniences.\n\n  For more information about structs, please check `Kernel.SpecialForms.%/2`.\n\n  ## Examples\n\n      defmodule User do\n        defstruct name: nil, age: nil\n      end\n\n  Struct fields are evaluated at compile-time, which allows\n  them to be dynamic. In the example below, `10 + 11` is\n  evaluated at compile-time and the age field is stored\n  with value `21`:\n\n      defmodule User do\n        defstruct name: nil, age: 10 + 11\n      end\n\n  The `fields` argument is usually a keyword list with field names\n  as atom keys and default values as corresponding values. `defstruct/1`\n  also supports a list of atoms as its argument: in that case, the atoms\n  in the list will be used as the struct's field names and they will all\n  default to `nil`.\n\n      defmodule Post do\n        defstruct [:title, :content, :author]\n      end\n\n  ## Deriving\n\n  Although structs are maps, by default structs do not implement\n  any of the protocols implemented for maps. For example, attempting\n  to use a protocol with the `User` struct leads to an error:\n\n      john = %User{name: \"John\"}\n      MyProtocol.call(john)\n      ** (Protocol.UndefinedError) protocol MyProtocol not implemented for %User{...}\n\n  `defstruct/1`, however, allows protocol implementations to be\n  *derived*. This can be done by defining a `@derive` attribute as a\n  list before invoking `defstruct/1`:\n\n      defmodule User do\n        @derive [MyProtocol]\n        defstruct name: nil, age: 10 + 11\n      end\n\n      MyProtocol.call(john) #=> works\n\n  For each protocol in the `@derive` list, Elixir will assert there is an\n  implementation of that protocol for any (regardless if fallback to any\n  is `true`) and check if the any implementation defines a `__deriving__/3`\n  callback. If so, the callback is invoked, otherwise an implementation\n  that simply points to the any implementation is automatically derived.\n\n  ## Enforcing keys\n\n  When building a struct, Elixir will automatically guarantee all keys\n  belongs to the struct:\n\n      %User{name: \"john\", unknown: :key}\n      ** (KeyError) key :unknown not found in: %User{age: 21, name: nil}\n\n  Elixir also allows developers to enforce certain keys must always be\n  given when building the struct:\n\n      defmodule User do\n        @enforce_keys [:name]\n        defstruct name: nil, age: 10 + 11\n      end\n\n  Now trying to build a struct without the name key will fail:\n\n      %User{age: 21}\n      ** (ArgumentError) the following keys must also be given when building struct User: [:name]\n\n  Keep in mind `@enforce_keys` is a simple compile-time guarantee\n  to aid developers when building structs. It is not enforced on\n  updates and it does not provide any sort of value-validation.\n\n  ## Types\n\n  It is recommended to define types for structs. By convention such type\n  is called `t`. To define a struct inside a type, the struct literal syntax\n  is used:\n\n      defmodule User do\n        defstruct name: \"John\", age: 25\n        @type t :: %User{name: String.t, age: non_neg_integer}\n      end\n\n  It is recommended to only use the struct syntax when defining the struct's\n  type. When referring to another struct it's better to use `User.t` instead of\n  `%User{}`.\n\n  The types of the struct fields that are not included in `%User{}` default to\n  `term`.\n\n  Structs whose internal structure is private to the local module (pattern\n  matching them or directly accessing their fields should not be allowed) should\n  use the `@opaque` attribute. Structs whose internal structure is public should\n  use `@type`.\n  "
    },
    abs = {
      description = "abs(number) :: number\nabs(number)\n\n  Returns an integer or float which is the arithmetical absolute value of `number`.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> abs(-3.33)\n      3.33\n\n      iex> abs(-3)\n      3\n\n  "
    },
    apply = {
      description = "apply(module, atom, [any]) :: any\napply(module, fun, args)\napply(fun, [any]) :: any\napply(fun, args)\n\n  Invokes the given `fun` with the list of arguments `args`.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> apply(fn x -> x * 2 end, [2])\n      4\n\n  "
    },
    binary_part = {
      description = "binary_part(binary, non_neg_integer, integer) :: binary\nbinary_part(binary, start, length)\n\n  Extracts the part of the binary starting at `start` with length `length`.\n  Binaries are zero-indexed.\n\n  If `start` or `length` reference in any way outside the binary, an\n  `ArgumentError` exception is raised.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> binary_part(\"foo\", 1, 2)\n      \"oo\"\n\n  A negative `length` can be used to extract bytes that come *before* the byte\n  at `start`:\n\n      iex> binary_part(\"Hello\", 5, -3)\n      \"llo\"\n\n  "
    },
    bit_size = {
      description = "bit_size(bitstring) :: non_neg_integer\nbit_size(bitstring)\n\n  Returns an integer which is the size in bits of `bitstring`.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> bit_size(<<433::16, 3::3>>)\n      19\n\n      iex> bit_size(<<1, 2, 3>>)\n      24\n\n  "
    },
    byte_size = {
      description = "byte_size(bitstring) :: non_neg_integer\nbyte_size(bitstring)\n\n  Returns the number of bytes needed to contain `bitstring`.\n\n  That is, if the number of bits in `bitstring` is not divisible by 8, the\n  resulting number of bytes will be rounded up (by excess). This operation\n  happens in constant time.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> byte_size(<<433::16, 3::3>>)\n      3\n\n      iex> byte_size(<<1, 2, 3>>)\n      3\n\n  "
    },
    description = "\n  Provides the default macros and functions Elixir imports into your\n  environment.\n\n  These macros and functions can be skipped or cherry-picked via the\n  `import/2` macro. For instance, if you want to tell Elixir not to\n  import the `if/2` macro, you can do:\n\n      import Kernel, except: [if: 2]\n\n  Elixir also has special forms that are always imported and\n  cannot be skipped. These are described in `Kernel.SpecialForms`.\n\n  Some of the functions described in this module are inlined by\n  the Elixir compiler into their Erlang counterparts in the\n  [`:erlang` module](http://www.erlang.org/doc/man/erlang.html).\n  Those functions are called BIFs (built-in internal functions)\n  in Erlang-land and they exhibit interesting properties, as some of\n  them are allowed in guards and others are used for compiler\n  optimizations.\n\n  Most of the inlined functions can be seen in effect when capturing\n  the function:\n\n      iex> &Kernel.is_atom/1\n      &:erlang.is_atom/1\n\n  Those functions will be explicitly marked in their docs as\n  \"inlined by the compiler\".\n  ",
    div = {
      description = "div(integer, neg_integer | pos_integer) :: integer\ndiv(dividend, divisor)\n\n  Performs an integer division.\n\n  Raises an `ArithmeticError` exception if one of the arguments is not an\n  integer, or when the `divisor` is `0`.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  `div/2` performs *truncated* integer division. This means that\n  the result is always rounded towards zero.\n\n  If you want to perform floored integer division (rounding towards negative infinity),\n  use `Integer.floor_div/2` instead.\n\n  ## Examples\n\n      div(5, 2)\n      #=> 2\n\n      div(6, -4)\n      #=> -1\n\n      div(-99, 2)\n      #=> -49\n\n      div(100, 0)\n      #=> ** (ArithmeticError) bad argument in arithmetic expression\n\n  "
    },
    elem = {
      description = "elem(tuple, non_neg_integer) :: term\nelem(tuple, index)\n\n  Gets the element at the zero-based `index` in `tuple`.\n\n  It raises `ArgumentError` when index is negative or it is out of range of the tuple elements.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      tuple = {:foo, :bar, 3}\n      elem(tuple, 1)\n      #=> :bar\n\n      elem({}, 0)\n      #=> ** (ArgumentError) argument error\n\n      elem({:foo, :bar}, 2)\n      #=> ** (ArgumentError) argument error\n\n  "
    },
    exception = {
      description = "exception(Keyword.t) :: Exception.t\nexception(args) when is_list(args)\nexception(String.t) :: Exception.t\nexception(msg) when is_binary(msg)\n\n  Defines an exception.\n\n  Exceptions are structs backed by a module that implements\n  the `Exception` behaviour. The `Exception` behaviour requires\n  two functions to be implemented:\n\n    * `exception/1` - receives the arguments given to `raise/2`\n      and returns the exception struct. The default implementation\n      accepts either a set of keyword arguments that is merged into\n      the struct or a string to be used as the exception's message.\n\n    * `message/1` - receives the exception struct and must return its\n      message. Most commonly exceptions have a message field which\n      by default is accessed by this function. However, if an exception\n      does not have a message field, this function must be explicitly\n      implemented.\n\n  Since exceptions are structs, the API supported by `defstruct/1`\n  is also available in `defexception/1`.\n\n  ## Raising exceptions\n\n  The most common way to raise an exception is via `raise/2`:\n\n      defmodule MyAppError do\n        defexception [:message]\n      end\n\n      value = [:hello]\n\n      raise MyAppError,\n        message: \"did not get what was expected, got: #{inspect value}\"\n\n  In many cases it is more convenient to pass the expected value to\n  `raise/2` and generate the message in the `c:Exception.exception/1` callback:\n\n      defmodule MyAppError do\n        defexception [:message]\n\n        def exception(value) do\n          msg = \"did not get what was expected, got: #{inspect value}\"\n          %MyAppError{message: msg}\n        end\n      end\n\n      raise MyAppError, value\n\n  The example above shows the preferred strategy for customizing\n  exception messages.\n  "
    },
    exit = {
      description = "exit(term) :: no_return\nexit(reason)\n\n  Stops the execution of the calling process with the given reason.\n\n  Since evaluating this function causes the process to terminate,\n  it has no return value.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n  When a process reaches its end, by default it exits with\n  reason `:normal`. You can also call `exit/1` explicitly if you\n  want to terminate a process but not signal any failure:\n\n      exit(:normal)\n\n  In case something goes wrong, you can also use `exit/1` with\n  a different reason:\n\n      exit(:seems_bad)\n\n  If the exit reason is not `:normal`, all the processes linked to the process\n  that exited will crash (unless they are trapping exits).\n\n  ## OTP exits\n\n  Exits are used by the OTP to determine if a process exited abnormally\n  or not. The following exits are considered \"normal\":\n\n    * `exit(:normal)`\n    * `exit(:shutdown)`\n    * `exit({:shutdown, term})`\n\n  Exiting with any other reason is considered abnormal and treated\n  as a crash. This means the default supervisor behaviour kicks in,\n  error reports are emitted, etc.\n\n  This behaviour is relied on in many different places. For example,\n  `ExUnit` uses `exit(:shutdown)` when exiting the test process to\n  signal linked processes, supervision trees and so on to politely\n  shutdown too.\n\n  ## CLI exits\n\n  Building on top of the exit signals mentioned above, if the\n  process started by the command line exits with any of the three\n  reasons above, its exit is considered normal and the Operating\n  System process will exit with status 0.\n\n  It is, however, possible to customize the Operating System exit\n  signal by invoking:\n\n      exit({:shutdown, integer})\n\n  This will cause the OS process to exit with the status given by\n  `integer` while signaling all linked OTP processes to politely\n  shutdown.\n\n  Any other exit reason will cause the OS process to exit with\n  status `1` and linked OTP processes to crash.\n  "
    },
    ["function_exported?"] = {
      description = "function_exported?(module, atom, arity) :: boolean\nfunction_exported?(module, function, arity)\n\n  Returns `true` if `module` is loaded and contains a\n  public `function` with the given `arity`, otherwise `false`.\n\n  Note that this function does not load the module in case\n  it is not loaded. Check `Code.ensure_loaded/1` for more\n  information.\n\n  ## Examples\n\n      iex> function_exported?(Enum, :member?, 2)\n      true\n\n  "
    },
    get_and_update_in = {
      description = "get_and_update_in(data, [head | tail], fun) when is_function(fun, 1),\nget_and_update_in(data, [head], fun) when is_function(fun, 1),\nget_and_update_in(data, [head | tail], fun) when is_function(head, 3),\nget_and_update_in(data, [head], fun) when is_function(head, 3),\nget_and_update_in(structure :: Access.t, keys, (term -> {get_value, update_value} | :pop)) ::\nget_and_update_in(data, keys, fun)\n\n  Gets a value and updates a nested structure.\n\n  `data` is a nested structure (ie. a map, keyword\n  list, or struct that implements the `Access` behaviour).\n\n  The `fun` argument receives the value of `key` (or `nil` if `key`\n  is not present) and must return a two-element tuple: the \"get\" value\n  (the retrieved value, which can be operated on before being returned)\n  and the new value to be stored under `key`. The `fun` may also\n  return `:pop`, implying the current value shall be removed\n  from the structure and returned.\n\n  It uses the `Access` module to traverse the structures\n  according to the given `keys`, unless the `key` is a\n  function.\n\n  If a key is a function, the function will be invoked\n  passing three arguments, the operation (`:get_and_update`),\n  the data to be accessed, and a function to be invoked next.\n\n  This means `get_and_update_in/3` can be extended to provide\n  custom lookups. The downside is that functions cannot be stored\n  as keys in the accessed data structures.\n\n  ## Examples\n\n  This function is useful when there is a need to retrieve the current\n  value (or something calculated in function of the current value) and\n  update it at the same time. For example, it could be used to increase\n  the age of a user by one and return the previous age in one pass:\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> get_and_update_in(users, [\"john\", :age], &{&1, &1 + 1})\n      {27, %{\"john\" => %{age: 28}, \"meg\" => %{age: 23}}}\n\n  When one of the keys is a function, the function is invoked.\n  In the example below, we use a function to get and increment all\n  ages inside a list:\n\n      iex> users = [%{name: \"john\", age: 27}, %{name: \"meg\", age: 23}]\n      iex> all = fn :get_and_update, data, next ->\n      ...>   Enum.map(data, next) |> :lists.unzip\n      ...> end\n      iex> get_and_update_in(users, [all, :age], &{&1, &1 + 1})\n      {[27, 23], [%{name: \"john\", age: 28}, %{name: \"meg\", age: 24}]}\n\n  If the previous value before invoking the function is `nil`,\n  the function *will* receive `nil` as a value and must handle it\n  accordingly (be it by failing or providing a sane default).\n\n  The `Access` module ships with many convenience accessor functions,\n  like the `all` anonymous function defined above. See `Access.all/0`,\n  `Access.key/2` and others as examples.\n  "
    },
    get_in = {
      description = "get_in(data, [h | t]),\nget_in(data, [h]),\nget_in(nil, [_ | t]),\nget_in(nil, [_]),\nget_in(data, [h | t]) when is_function(h),\nget_in(data, [h]) when is_function(h),\nget_in(Access.t, nonempty_list(term)) :: term\nget_in(data, keys)\n\n  Gets a value from a nested structure.\n\n  Uses the `Access` module to traverse the structures\n  according to the given `keys`, unless the `key` is a\n  function.\n\n  If a key is a function, the function will be invoked\n  passing three arguments, the operation (`:get`), the\n  data to be accessed, and a function to be invoked next.\n\n  This means `get_in/2` can be extended to provide\n  custom lookups. The downside is that functions cannot be\n  stored as keys in the accessed data structures.\n\n  ## Examples\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> get_in(users, [\"john\", :age])\n      27\n\n  In case any of entries in the middle returns `nil`, `nil` will be returned\n  as per the Access module:\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> get_in(users, [\"unknown\", :age])\n      nil\n\n  When one of the keys is a function, the function is invoked.\n  In the example below, we use a function to get all the maps\n  inside a list:\n\n      iex> users = [%{name: \"john\", age: 27}, %{name: \"meg\", age: 23}]\n      iex> all = fn :get, data, next -> Enum.map(data, next) end\n      iex> get_in(users, [all, :age])\n      [27, 23]\n\n  If the previous value before invoking the function is `nil`,\n  the function *will* receive nil as a value and must handle it\n  accordingly.\n  "
    },
    hd = {
      description = "hd(nonempty_maybe_improper_list(elem, any)) :: elem when elem: term\nhd(list)\n\n  Returns the head of a list. Raises `ArgumentError` if the list is empty.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      hd([1, 2, 3, 4])\n      #=> 1\n\n      hd([])\n      #=> ** (ArgumentError) argument error\n\n  "
    },
    inspect = {
      description = "inspect(Inspect.t, Keyword.t) :: String.t\ninspect(arg, opts \\\\ []) when is_list(opts)\n\n  Inspects the given argument according to the `Inspect` protocol.\n  The second argument is a keyword list with options to control\n  inspection.\n\n  ## Options\n\n  `inspect/2` accepts a list of options that are internally\n  translated to an `Inspect.Opts` struct. Check the docs for\n  `Inspect.Opts` to see the supported options.\n\n  ## Examples\n\n      iex> inspect(:foo)\n      \":foo\"\n\n      iex> inspect [1, 2, 3, 4, 5], limit: 3\n      \"[1, 2, 3, ...]\"\n\n      iex> inspect [1, 2, 3], pretty: true, width: 0\n      \"[1,\\n 2,\\n 3]\"\n\n      iex> inspect(\"olá\" <> <<0>>)\n      \"<<111, 108, 195, 161, 0>>\"\n\n      iex> inspect(\"olá\" <> <<0>>, binaries: :as_strings)\n      \"\\\"olá\\\\0\\\"\"\n\n      iex> inspect(\"olá\", binaries: :as_binaries)\n      \"<<111, 108, 195, 161>>\"\n\n      iex> inspect('bar')\n      \"'bar'\"\n\n      iex> inspect([0 | 'bar'])\n      \"[0, 98, 97, 114]\"\n\n      iex> inspect(100, base: :octal)\n      \"0o144\"\n\n      iex> inspect(100, base: :hex)\n      \"0x64\"\n\n  Note that the `Inspect` protocol does not necessarily return a valid\n  representation of an Elixir term. In such cases, the inspected result\n  must start with `#`. For example, inspecting a function will return:\n\n      inspect fn a, b -> a + b end\n      #=> #Function<...>\n\n  "
    },
    is_atom = {
      description = "is_atom(term) :: boolean\nis_atom(term)\n\n  Returns `true` if `term` is an atom; otherwise returns `false`.\n\n  Allowed in guard tests. Inlined by the compiler.\n  "
    },
    is_binary = {
      description = "is_binary(term) :: boolean\nis_binary(term)\n\n  Returns `true` if `term` is a binary; otherwise returns `false`.\n\n  A binary always contains a complete number of bytes.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> is_binary \"foo\"\n      true\n      iex> is_binary <<1::3>>\n      false\n\n  "
    },
    is_bitstring = {
      description = "is_bitstring(term) :: boolean\nis_bitstring(term)\n\n  Returns `true` if `term` is a bitstring (including a binary); otherwise returns `false`.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> is_bitstring \"foo\"\n      true\n      iex> is_bitstring <<1::3>>\n      true\n\n  "
    },
    is_boolean = {
      description = "is_boolean(term) :: boolean\nis_boolean(term)\n\n  Returns `true` if `term` is either the atom `true` or the atom `false` (i.e.,\n  a boolean); otherwise returns `false`.\n\n  Allowed in guard tests. Inlined by the compiler.\n  "
    },
    is_float = {
      description = "is_float(term) :: boolean\nis_float(term)\n\n  Returns `true` if `term` is a floating point number; otherwise returns `false`.\n\n  Allowed in guard tests. Inlined by the compiler.\n  "
    },
    is_function = {
      description = "is_function(term, non_neg_integer) :: boolean\nis_function(term, arity)\nis_function(term) :: boolean\nis_function(term)\n\n  Returns `true` if `term` is a function; otherwise returns `false`.\n\n  Allowed in guard tests. Inlined by the compiler.\n  "
    },
    is_integer = {
      description = "is_integer(term) :: boolean\nis_integer(term)\n\n  Returns `true` if `term` is an integer; otherwise returns `false`.\n\n  Allowed in guard tests. Inlined by the compiler.\n  "
    },
    is_list = {
      description = "is_list(term) :: boolean\nis_list(term)\n\n  Returns `true` if `term` is a list with zero or more elements; otherwise returns `false`.\n\n  Allowed in guard tests. Inlined by the compiler.\n  "
    },
    is_map = {
      description = "is_map(term) :: boolean\nis_map(term)\n\n  Returns `true` if `term` is a map; otherwise returns `false`.\n\n  Allowed in guard tests. Inlined by the compiler.\n  "
    },
    is_number = {
      description = "is_number(term) :: boolean\nis_number(term)\n\n  Returns `true` if `term` is either an integer or a floating point number;\n  otherwise returns `false`.\n\n  Allowed in guard tests. Inlined by the compiler.\n  "
    },
    is_pid = {
      description = "is_pid(term) :: boolean\nis_pid(term)\n\n  Returns `true` if `term` is a PID (process identifier); otherwise returns `false`.\n\n  Allowed in guard tests. Inlined by the compiler.\n  "
    },
    is_port = {
      description = "is_port(term) :: boolean\nis_port(term)\n\n  Returns `true` if `term` is a port identifier; otherwise returns `false`.\n\n  Allowed in guard tests. Inlined by the compiler.\n  "
    },
    is_reference = {
      description = "is_reference(term) :: boolean\nis_reference(term)\n\n  Returns `true` if `term` is a reference; otherwise returns `false`.\n\n  Allowed in guard tests. Inlined by the compiler.\n  "
    },
    is_tuple = {
      description = "is_tuple(term) :: boolean\nis_tuple(term)\n\n  Returns `true` if `term` is a tuple; otherwise returns `false`.\n\n  Allowed in guard tests. Inlined by the compiler.\n  "
    },
    ["left =~ \"\" when is_binary"] = {
      description = "left =~ \"\" when is_binary(left)\n\n  Matches the term on the left against the regular expression or string on the\n  right.\n\n  Returns `true` if `left` matches `right` (if it's a regular expression)\n  or contains `right` (if it's a string).\n\n  ## Examples\n\n      iex> \"abcd\" =~ ~r/c(d)/\n      true\n\n      iex> \"abcd\" =~ ~r/e/\n      false\n\n      iex> \"abcd\" =~ \"bc\"\n      true\n\n      iex> \"abcd\" =~ \"ad\"\n      false\n\n      iex> \"abcd\" =~ \"\"\n      true\n\n  "
    },
    ["left =~ right when is_binary"] = {
      description = "left =~ right when is_binary(left)\nleft =~ right when is_binary(left) and is_binary(right)\n\n  Matches the term on the left against the regular expression or string on the\n  right.\n\n  Returns `true` if `left` matches `right` (if it's a regular expression)\n  or contains `right` (if it's a string).\n\n  ## Examples\n\n      iex> \"abcd\" =~ ~r/c(d)/\n      true\n\n      iex> \"abcd\" =~ ~r/e/\n      false\n\n      iex> \"abcd\" =~ \"bc\"\n      true\n\n      iex> \"abcd\" =~ \"ad\"\n      false\n\n      iex> \"abcd\" =~ \"\"\n      true\n\n  "
    },
    ["left!==right"] = {
      description = "left!==right\n\n  Returns `true` if the two items are not exactly equal.\n\n  All terms in Elixir can be compared with each other.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> 1 !== 2\n      true\n\n      iex> 1 !== 1.0\n      true\n\n  "
    },
    ["left!=right"] = {
      description = "left!=right\n\n  Returns `true` if the two items are not equal.\n\n  This operator considers 1 and 1.0 to be equal. For match\n  comparison, use `!==` instead.\n\n  All terms in Elixir can be compared with each other.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> 1 != 2\n      true\n\n      iex> 1 != 1.0\n      false\n\n  "
    },
    ["left*right"] = {
      description = "left*right\n\n  Arithmetic multiplication.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> 1 * 2\n      2\n\n  "
    },
    ["left++right"] = {
      description = "left++right\n\n  Concatenates a proper list and a term, returning a list.\n\n  The complexity of `a ++ b` is proportional to `length(a)`, so avoid repeatedly\n  appending to lists of arbitrary length, e.g. `list ++ [item]`.\n  Instead, consider prepending via `[item | rest]` and then reversing.\n\n  If the `right` operand is not a proper list, it returns an improper list.\n  If the `left` operand is not a proper list, it raises `ArgumentError`.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> [1] ++ [2, 3]\n      [1, 2, 3]\n\n      iex> 'foo' ++ 'bar'\n      'foobar'\n\n      # returns an improper list\n      iex> [1] ++ 2\n      [1 | 2]\n\n      # returns a proper list\n      iex> [1] ++ [2]\n      [1, 2]\n\n      # improper list on the right will return an improper list\n      iex> [1] ++ [2 | 3]\n      [1, 2 | 3]\n\n  "
    },
    ["left+right"] = {
      description = "left+right\n\n  Arithmetic addition.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> 1 + 2\n      3\n\n  "
    },
    ["left--right"] = {
      description = "left--right\n\n  Removes the first occurrence of an item on the left list\n  for each item on the right.\n\n  The complexity of `a -- b` is proportional to `length(a) * length(b)`,\n  meaning that it will be very slow if both `a` and `b` are long lists.\n  In such cases, consider converting each list to a `MapSet` and using\n  `MapSet.difference/2`.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> [1, 2, 3] -- [1, 2]\n      [3]\n\n      iex> [1, 2, 3, 2, 1] -- [1, 2, 2]\n      [3, 1]\n\n  "
    },
    ["left-right"] = {
      description = "left-right\n\n  Arithmetic subtraction.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> 1 - 2\n      -1\n\n  "
    },
    ["left/right"] = {
      description = "left/right\n\n  Arithmetic division.\n\n  The result is always a float. Use `div/2` and `rem/2` if you want\n  an integer division or the remainder.\n\n  Raises `ArithmeticError` if `right` is 0 or 0.0.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      1 / 2\n      #=> 0.5\n\n      -3.0 / 2.0\n      #=> -1.5\n\n      5 / 1\n      #=> 5.0\n\n      7 / 0\n      #=> ** (ArithmeticError) bad argument in arithmetic expression\n\n  "
    },
    ["left<=right"] = {
      description = "left<=right\n\n  Returns `true` if left is less than or equal to right.\n\n  All terms in Elixir can be compared with each other.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> 1 <= 2\n      true\n\n  "
    },
    ["left<right"] = {
      description = "left<right\n\n  Returns `true` if left is less than right.\n\n  All terms in Elixir can be compared with each other.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> 1 < 2\n      true\n\n  "
    },
    ["left===right"] = {
      description = "left===right\n\n  Returns `true` if the two items are exactly equal.\n\n  The items are only considered to be exactly equal if they\n  have the same value and are of the same type. For example,\n  `1 == 1.0` returns true, but since they are of different\n  types, `1 === 1.0` returns false.\n\n  All terms in Elixir can be compared with each other.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> 1 === 2\n      false\n\n      iex> 1 === 1.0\n      false\n\n  "
    },
    ["left==right"] = {
      description = "left==right\n\n  Returns `true` if the two items are equal.\n\n  This operator considers 1 and 1.0 to be equal. For stricter\n  semantics, use `===` instead.\n\n  All terms in Elixir can be compared with each other.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> 1 == 2\n      false\n\n      iex> 1 == 1.0\n      true\n\n  "
    },
    ["left>=right"] = {
      description = "left>=right\n\n  Returns `true` if left is more than or equal to right.\n\n  All terms in Elixir can be compared with each other.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> 1 >= 2\n      false\n\n  "
    },
    ["left>right"] = {
      description = "left>right\n\n  Returns `true` if left is more than right.\n\n  All terms in Elixir can be compared with each other.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> 1 > 2\n      false\n\n  "
    },
    length = {
      description = "length(list) :: non_neg_integer\nlength(list)\n\n  Returns the length of `list`.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> length([1, 2, 3, 4, 5, 6, 7, 8, 9])\n      9\n\n  "
    },
    ["macro_exported?"] = {
      description = "macro_exported?(module, atom, arity) :: boolean\nmacro_exported?(module, macro, arity)\n\n  Returns `true` if `module` is loaded and contains a\n  public `macro` with the given `arity`, otherwise `false`.\n\n  Note that this function does not load the module in case\n  it is not loaded. Check `Code.ensure_loaded/1` for more\n  information.\n\n  If `module` is an Erlang module (as opposed to an Elixir module), this\n  function always returns `false`.\n\n  ## Examples\n\n      iex> macro_exported?(Kernel, :use, 2)\n      true\n\n      iex> macro_exported?(:erlang, :abs, 1)\n      false\n\n  "
    },
    make_ref = {
      description = "make_ref() :: reference\nmake_ref()\n\n  Returns an almost unique reference.\n\n  The returned reference will re-occur after approximately 2^82 calls;\n  therefore it is unique enough for practical purposes.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      make_ref() #=> #Reference<0.0.0.135>\n\n  "
    },
    map_size = {
      description = "map_size(map) :: non_neg_integer\nmap_size(map)\n\n  Returns the size of a map.\n\n  The size of a map is the number of key-value pairs that the map contains.\n\n  This operation happens in constant time.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> map_size(%{a: \"foo\", b: \"bar\"})\n      2\n\n  "
    },
    max = {
      description = "max(first, second) :: (first | second) when first: term, second: term\nmax(first, second)\n\n  Returns the biggest of the two given terms according to\n  Erlang's term ordering. If the terms compare equal, the\n  first one is returned.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> max(1, 2)\n      2\n      iex> max(:a, :b)\n      :b\n\n  "
    },
    message = {
      description = "message(Exception.t) :: String.t\nmessage(exception)\n\n  Defines an exception.\n\n  Exceptions are structs backed by a module that implements\n  the `Exception` behaviour. The `Exception` behaviour requires\n  two functions to be implemented:\n\n    * `exception/1` - receives the arguments given to `raise/2`\n      and returns the exception struct. The default implementation\n      accepts either a set of keyword arguments that is merged into\n      the struct or a string to be used as the exception's message.\n\n    * `message/1` - receives the exception struct and must return its\n      message. Most commonly exceptions have a message field which\n      by default is accessed by this function. However, if an exception\n      does not have a message field, this function must be explicitly\n      implemented.\n\n  Since exceptions are structs, the API supported by `defstruct/1`\n  is also available in `defexception/1`.\n\n  ## Raising exceptions\n\n  The most common way to raise an exception is via `raise/2`:\n\n      defmodule MyAppError do\n        defexception [:message]\n      end\n\n      value = [:hello]\n\n      raise MyAppError,\n        message: \"did not get what was expected, got: #{inspect value}\"\n\n  In many cases it is more convenient to pass the expected value to\n  `raise/2` and generate the message in the `c:Exception.exception/1` callback:\n\n      defmodule MyAppError do\n        defexception [:message]\n\n        def exception(value) do\n          msg = \"did not get what was expected, got: #{inspect value}\"\n          %MyAppError{message: msg}\n        end\n      end\n\n      raise MyAppError, value\n\n  The example above shows the preferred strategy for customizing\n  exception messages.\n  "
    },
    min = {
      description = "min(first, second) :: (first | second) when first: term, second: term\nmin(first, second)\n\n  Returns the smallest of the two given terms according to\n  Erlang's term ordering. If the terms compare equal, the\n  first one is returned.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> min(1, 2)\n      1\n      iex> min(\"foo\", \"bar\")\n      \"bar\"\n\n  "
    },
    node = {
      description = "node(pid | reference | port) :: node\nnode(arg)\nnode() :: node\nnode\n\n  Returns an atom representing the name of the local node.\n  If the node is not alive, `:nonode@nohost` is returned instead.\n\n  Allowed in guard tests. Inlined by the compiler.\n  "
    },
    ["not"] = {
      description = "not(false) :: true\nnot(arg)\n\n  Boolean not.\n\n  `arg` must be a boolean; if it's not, an `ArgumentError` exception is raised.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> not false\n      true\n\n  "
    },
    pop_in = {
      description = "pop_in(data, keys)\npop_in(nil, [h | _])\npop_in(Access.t, nonempty_list(term)) :: {term, Access.t}\npop_in(data, keys)\n\n  Pops a key from the given nested structure.\n\n  Uses the `Access` protocol to traverse the structures\n  according to the given `keys`, unless the `key` is a\n  function. If the key is a function, it will be invoked\n  as specified in `get_and_update_in/3`.\n\n  ## Examples\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> pop_in(users, [\"john\", :age])\n      {27, %{\"john\" => %{}, \"meg\" => %{age: 23}}}\n\n  In case any entry returns `nil`, its key will be removed\n  and the deletion will be considered a success.\n  "
    },
    put_elem = {
      description = "put_elem(tuple, non_neg_integer, term) :: tuple\nput_elem(tuple, index, value)\n\n  Inserts `value` at the given zero-based `index` in `tuple`.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> tuple = {:foo, :bar, 3}\n      iex> put_elem(tuple, 0, :baz)\n      {:baz, :bar, 3}\n\n  "
    },
    put_in = {
      description = "put_in(Access.t, nonempty_list(term), term) :: Access.t\nput_in(data, keys, value)\n\n  Puts a value in a nested structure.\n\n  Uses the `Access` module to traverse the structures\n  according to the given `keys`, unless the `key` is a\n  function. If the key is a function, it will be invoked\n  as specified in `get_and_update_in/3`.\n\n  ## Examples\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> put_in(users, [\"john\", :age], 28)\n      %{\"john\" => %{age: 28}, \"meg\" => %{age: 23}}\n\n  In case any of entries in the middle returns `nil`,\n  an error will be raised when trying to access it next.\n  "
    },
    rem = {
      description = "rem(integer, neg_integer | pos_integer) :: integer\nrem(dividend, divisor)\n\n  Computes the remainder of an integer division.\n\n  `rem/2` uses truncated division, which means that\n  the result will always have the sign of the `dividend`.\n\n  Raises an `ArithmeticError` exception if one of the arguments is not an\n  integer, or when the `divisor` is `0`.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> rem(5, 2)\n      1\n      iex> rem(6, -4)\n      2\n\n  "
    },
    round = {
      description = "round(value) :: value when value: integer\nround(number)\n\n  Rounds a number to the nearest integer.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> round(5.6)\n      6\n\n      iex> round(5.2)\n      5\n\n      iex> round(-9.9)\n      -10\n\n      iex> round(-9)\n      -9\n\n  "
    },
    self = {
      description = "self() :: pid\nself()\n\n  Returns the PID (process identifier) of the calling process.\n\n  Allowed in guard clauses. Inlined by the compiler.\n  "
    },
    send = {
      description = "send(dest :: pid | port | atom | {atom, node}, msg) :: msg when msg: any\nsend(dest, msg)\n\n  Sends a message to the given `dest` and returns the message.\n\n  `dest` may be a remote or local PID, a (local) port, a locally\n  registered name, or a tuple `{registered_name, node}` for a registered\n  name at another node.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> send self(), :hello\n      :hello\n\n  "
    },
    spawn = {
      description = "spawn(module, atom, list) :: pid\nspawn(module, fun, args)\nspawn((() -> any)) :: pid\nspawn(fun)\n\n  Spawns the given function and returns its PID.\n\n  Typically developers do not use the `spawn` functions, instead they use\n  abstractions such as `Task`, `GenServer` and `Agent`, built on top of\n  `spawn`, that spawns processes with more conveniences in terms of\n  introspection and debugging.\n\n  Check the `Process` module for more process related functions,\n\n  The anonymous function receives 0 arguments, and may return any value.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      current = self()\n      child   = spawn(fn -> send current, {self(), 1 + 2} end)\n\n      receive do\n        {^child, 3} -> IO.puts \"Received 3 back\"\n      end\n\n  "
    },
    spawn_link = {
      description = "spawn_link(module, atom, list) :: pid\nspawn_link(module, fun, args)\nspawn_link((() -> any)) :: pid\nspawn_link(fun)\n\n  Spawns the given function, links it to the current process and returns its PID.\n\n  Typically developers do not use the `spawn` functions, instead they use\n  abstractions such as `Task`, `GenServer` and `Agent`, built on top of\n  `spawn`, that spawns processes with more conveniences in terms of\n  introspection and debugging.\n\n  Check the `Process` module for more process related functions,\n\n  The anonymous function receives 0 arguments, and may return any value.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      current = self()\n      child   = spawn_link(fn -> send current, {self(), 1 + 2} end)\n\n      receive do\n        {^child, 3} -> IO.puts \"Received 3 back\"\n      end\n\n  "
    },
    spawn_monitor = {
      description = "spawn_monitor(module, atom, list) :: {pid, reference}\nspawn_monitor(module, fun, args)\nspawn_monitor((() -> any)) :: {pid, reference}\nspawn_monitor(fun)\n\n  Spawns the given function, monitors it and returns its PID\n  and monitoring reference.\n\n  Typically developers do not use the `spawn` functions, instead they use\n  abstractions such as `Task`, `GenServer` and `Agent`, built on top of\n  `spawn`, that spawns processes with more conveniences in terms of\n  introspection and debugging.\n\n  Check the `Process` module for more process related functions,\n\n  The anonymous function receives 0 arguments, and may return any value.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      current = self()\n      spawn_monitor(fn -> send current, {self(), 1 + 2} end)\n\n  "
    },
    struct = {
      description = "struct(module | struct, Enum.t) :: struct\nstruct(struct, kv \\\\ [])\n\n  Creates and updates structs.\n\n  The `struct` argument may be an atom (which defines `defstruct`)\n  or a `struct` itself. The second argument is any `Enumerable` that\n  emits two-element tuples (key-value pairs) during enumeration.\n\n  Keys in the `Enumerable` that don't exist in the struct are automatically\n  discarded. Note that keys must be atoms, as only atoms are allowed when\n  defining a struct.\n\n  This function is useful for dynamically creating and updating structs, as\n  well as for converting maps to structs; in the latter case, just inserting\n  the appropriate `:__struct__` field into the map may not be enough and\n  `struct/2` should be used instead.\n\n  ## Examples\n\n      defmodule User do\n        defstruct name: \"john\"\n      end\n\n      struct(User)\n      #=> %User{name: \"john\"}\n\n      opts = [name: \"meg\"]\n      user = struct(User, opts)\n      #=> %User{name: \"meg\"}\n\n      struct(user, unknown: \"value\")\n      #=> %User{name: \"meg\"}\n\n      struct(User, %{name: \"meg\"})\n      #=> %User{name: \"meg\"}\n\n      # String keys are ignored\n      struct(User, %{\"name\" => \"meg\"})\n      #=> %User{name: \"john\"}\n\n  "
    },
    ["struct!"] = {
      description = "struct!(struct, kv) when is_map(struct)\nstruct!(struct, kv) when is_atom(struct)\nstruct!(module | struct, Enum.t) :: struct | no_return\nstruct!(struct, kv \\\\ [])\n\n  Similar to `struct/2` but checks for key validity.\n\n  The function `struct!/2` emulates the compile time behaviour\n  of structs. This means that:\n\n    * when building a struct, as in `struct!(SomeStruct, key: :value)`,\n      it is equivalent to `%SomeStruct{key: :value}` and therefore this\n      function will check if every given key-value belongs to the struct.\n      If the struct is enforcing any key via `@enforce_keys`, those will\n      be enforced as well;\n\n    * when updating a struct, as in `struct!(%SomeStruct{}, key: :value)`,\n      it is equivalent to `%SomeStruct{struct | key: :value}` and therefore this\n      function will check if every given key-value belongs to the struct.\n      However, updating structs does not enforce keys, as keys are enforced\n      only when building;\n\n  "
    },
    throw = {
      description = "throw(term) :: no_return\nthrow(term)\n\n  A non-local return from a function.\n\n  Check `Kernel.SpecialForms.try/1` for more information.\n\n  Inlined by the compiler.\n  "
    },
    tl = {
      description = "tl(nonempty_maybe_improper_list(elem, tail)) ::\ntl(list)\n\n  Returns the tail of a list. Raises `ArgumentError` if the list is empty.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      tl([1, 2, 3, :go])\n      #=> [2, 3, :go]\n\n      tl([])\n      #=> ** (ArgumentError) argument error\n\n  "
    },
    trunc = {
      description = "trunc(float) :: integer\ntrunc(number)\n\n  Returns the integer part of `number`.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> trunc(5.4)\n      5\n\n      iex> trunc(-5.99)\n      -5\n\n      iex> trunc(-5)\n      -5\n\n  "
    },
    tuple_size = {
      description = "tuple_size(tuple) :: non_neg_integer\ntuple_size(tuple)\n\n  Returns the size of a tuple.\n\n  This operation happens in constant time.\n\n  Allowed in guard tests. Inlined by the compiler.\n\n  ## Examples\n\n      iex> tuple_size {:a, :b, :c}\n      3\n\n  "
    },
    unquote = {
      description = "unquote(name)(unquote_splicing(args))\n\n  Defines a function that delegates to another module.\n\n  Functions defined with `defdelegate/2` are public and can be invoked from\n  outside the module they're defined in (like if they were defined using\n  `def/2`). When the desire is to delegate as private functions, `import/2` should\n  be used.\n\n  Delegation only works with functions; delegating macros is not supported.\n\n  ## Options\n\n    * `:to` - the module to dispatch to.\n\n    * `:as` - the function to call on the target given in `:to`.\n      This parameter is optional and defaults to the name being\n      delegated (`funs`).\n\n  ## Examples\n\n      defmodule MyList do\n        defdelegate reverse(list), to: :lists\n        defdelegate other_reverse(list), to: :lists, as: :reverse\n      end\n\n      MyList.reverse([1, 2, 3])\n      #=> [3, 2, 1]\n\n      MyList.other_reverse([1, 2, 3])\n      #=> [3, 2, 1]\n\n  "
    },
    update_in = {
      description = "update_in(Access.t, nonempty_list(term), (term -> term)) :: Access.t\nupdate_in(data, keys, fun) when is_function(fun, 1)\n\n  Updates a key in a nested structure.\n\n  Uses the `Access` module to traverse the structures\n  according to the given `keys`, unless the `key` is a\n  function. If the key is a function, it will be invoked\n  as specified in `get_and_update_in/3`.\n\n  ## Examples\n\n      iex> users = %{\"john\" => %{age: 27}, \"meg\" => %{age: 23}}\n      iex> update_in(users, [\"john\", :age], &(&1 + 1))\n      %{\"john\" => %{age: 28}, \"meg\" => %{age: 23}}\n\n  In case any of entries in the middle returns `nil`,\n  an error will be raised when trying to access it next.\n  "
    }
  },
  KeyError = {
    message = {
      description = "message(exception)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    }
  },
  Keyword = {
    delete = {
      description = "delete(t, key) :: t\ndelete(keywords, key) when is_list(keywords) and is_atom(key)\ndelete(t, key, value) :: t\ndelete(keywords, key, value) when is_list(keywords) and is_atom(key)\n\n  Deletes the entries in the keyword list for a `key` with `value`.\n\n  If no `key` with `value` exists, returns the keyword list unchanged.\n\n  ## Examples\n\n      iex> Keyword.delete([a: 1, b: 2], :a, 1)\n      [b: 2]\n      iex> Keyword.delete([a: 1, b: 2, a: 3], :a, 3)\n      [a: 1, b: 2]\n      iex> Keyword.delete([a: 1], :a, 5)\n      [a: 1]\n      iex> Keyword.delete([a: 1], :b, 5)\n      [a: 1]\n\n  "
    },
    delete_first = {
      description = "delete_first(t, key) :: t\ndelete_first(keywords, key) when is_list(keywords) and is_atom(key)\n\n  Deletes the first entry in the keyword list for a specific `key`.\n\n  If the `key` does not exist, returns the keyword list unchanged.\n\n  ## Examples\n\n      iex> Keyword.delete_first([a: 1, b: 2, a: 3], :a)\n      [b: 2, a: 3]\n      iex> Keyword.delete_first([b: 2], :a)\n      [b: 2]\n\n  "
    },
    description = "\n  A set of functions for working with keywords.\n\n  A keyword is a list of two-element tuples where the first\n  element of the tuple is an atom and the second element\n  can be any value.\n\n  For example, the following is a keyword list:\n\n      [{:exit_on_close, true}, {:active, :once}, {:packet_size, 1024}]\n\n  Elixir provides a special and more concise syntax for keyword lists\n  that looks like this:\n\n      [exit_on_close: true, active: :once, packet_size: 1024]\n\n  This is also the syntax that Elixir uses to inspect keyword lists:\n\n      iex> [{:active, :once}]\n      [active: :once]\n\n  The two syntaxes are completely equivalent. Note that when keyword\n  lists are passed as the last argument to a function, if the short-hand\n  syntax is used then the square brackets around the keyword list can\n  be omitted as well. For example, the following:\n\n      String.split(\"1-0\", \"-\", trim: true, parts: 2)\n\n  is equivalent to:\n\n      String.split(\"1-0\", \"-\", [trim: true, parts: 2])\n\n  A keyword may have duplicated keys so it is not strictly\n  a key-value store. However most of the functions in this module\n  behave exactly as a dictionary so they work similarly to\n  the functions you would find in the `Map` module.\n\n  For example, `Keyword.get/3` will get the first entry matching\n  the given key, regardless if duplicated entries exist.\n  Similarly, `Keyword.put/3` and `Keyword.delete/3` ensure all\n  duplicated entries for a given key are removed when invoked.\n  Note that operations that require keys to be found in the keyword\n  list (like `Keyword.get/3`) need to traverse the list in order\n  to find keys, so these operations may be slower than their map\n  counterparts.\n\n  A handful of functions exist to handle duplicated keys, in\n  particular, `Enum.into/2` allows creating new keywords without\n  removing duplicated keys, `get_values/2` returns all values for\n  a given key and `delete_first/2` deletes just one of the existing\n  entries.\n\n  The functions in `Keyword` do not guarantee any property when\n  it comes to ordering. However, since a keyword list is simply a\n  list, all the operations defined in `Enum` and `List` can be\n  applied too, especially when ordering is required.\n  ",
    drop = {
      description = "drop(t, [key]) :: t\ndrop(keywords, keys) when is_list(keywords)\n\n  Drops the given keys from the keyword list.\n\n  Duplicated keys are preserved in the new keyword list.\n\n  ## Examples\n\n      iex> Keyword.drop([a: 1, b: 2, c: 3], [:b, :d])\n      [a: 1, c: 3]\n      iex> Keyword.drop([a: 1, b: 2, b: 3, c: 3, a: 5], [:b, :d])\n      [a: 1, c: 3, a: 5]\n\n  "
    },
    ["equal?"] = {
      description = "equal?(t, t) :: boolean\nequal?(left, right) when is_list(left) and is_list(right)\n\n  Checks if two keywords are equal.\n\n  Two keywords are considered to be equal if they contain\n  the same keys and those keys contain the same values.\n\n  ## Examples\n\n      iex> Keyword.equal?([a: 1, b: 2], [b: 2, a: 1])\n      true\n      iex> Keyword.equal?([a: 1, b: 2], [b: 1, a: 2])\n      false\n      iex> Keyword.equal?([a: 1, b: 2, a: 3], [b: 2, a: 3, a: 1])\n      true\n\n  "
    },
    fetch = {
      description = "fetch(t, key) :: {:ok, value} | :error\nfetch(keywords, key) when is_list(keywords) and is_atom(key)\n\n  Fetches the value for a specific `key` and returns it in a tuple.\n\n  If the `key` does not exist, returns `:error`.\n\n  ## Examples\n\n      iex> Keyword.fetch([a: 1], :a)\n      {:ok, 1}\n      iex> Keyword.fetch([a: 1], :b)\n      :error\n\n  "
    },
    ["fetch!"] = {
      description = "fetch!(t, key) :: value | no_return\nfetch!(keywords, key) when is_list(keywords) and is_atom(key)\n\n  Fetches the value for specific `key`.\n\n  If `key` does not exist, a `KeyError` is raised.\n\n  ## Examples\n\n      iex> Keyword.fetch!([a: 1], :a)\n      1\n      iex> Keyword.fetch!([a: 1], :b)\n      ** (KeyError) key :b not found in: [a: 1]\n\n  "
    },
    get = {
      description = "get(t, key, value) :: value\nget(keywords, key, default \\\\ nil) when is_list(keywords) and is_atom(key)\n\n  Gets the value for a specific `key`.\n\n  If `key` does not exist, return the default value\n  (`nil` if no default value).\n\n  If duplicated entries exist, the first one is returned.\n  Use `get_values/2` to retrieve all entries.\n\n  ## Examples\n\n      iex> Keyword.get([], :a)\n      nil\n      iex> Keyword.get([a: 1], :a)\n      1\n      iex> Keyword.get([a: 1], :b)\n      nil\n      iex> Keyword.get([a: 1], :b, 3)\n      3\n\n  With duplicated keys:\n\n      iex> Keyword.get([a: 1, a: 2], :a, 3)\n      1\n      iex> Keyword.get([a: 1, a: 2], :b, 3)\n      3\n\n  "
    },
    get_and_update = {
      description = "get_and_update(t, key, (value -> {get, value} | :pop)) :: {get, t} when get: term\nget_and_update(keywords, key, fun)\n\n  Gets the value from `key` and updates it, all in one pass.\n\n  This `fun` argument receives the value of `key` (or `nil` if `key`\n  is not present) and must return a two-element tuple: the \"get\" value\n  (the retrieved value, which can be operated on before being returned)\n  and the new value to be stored under `key`. The `fun` may also\n  return `:pop`, implying the current value shall be removed from the\n  keyword list and returned.\n\n  The returned value is a tuple with the \"get\" value returned by\n  `fun` and a new keyword list with the updated value under `key`.\n\n  ## Examples\n\n      iex> Keyword.get_and_update([a: 1], :a, fn current_value ->\n      ...>   {current_value, \"new value!\"}\n      ...> end)\n      {1, [a: \"new value!\"]}\n\n      iex> Keyword.get_and_update([a: 1], :b, fn current_value ->\n      ...>   {current_value, \"new value!\"}\n      ...> end)\n      {nil, [b: \"new value!\", a: 1]}\n\n      iex> Keyword.get_and_update([a: 1], :a, fn _ -> :pop end)\n      {1, []}\n\n      iex> Keyword.get_and_update([a: 1], :b, fn _ -> :pop end)\n      {nil, [a: 1]}\n\n  "
    },
    ["get_and_update!"] = {
      description = "get_and_update!(t, key, (value -> {get, value})) :: {get, t} | no_return when get: term\nget_and_update!(keywords, key, fun)\n\n  Gets the value from `key` and updates it. Raises if there is no `key`.\n\n  This `fun` argument receives the value of `key` and must return a\n  two-element tuple: the \"get\" value (the retrieved value, which can be\n  operated on before being returned) and the new value to be stored under\n  `key`.\n\n  The returned value is a tuple with the \"get\" value returned by `fun` and a new\n  keyword list with the updated value under `key`.\n\n  ## Examples\n\n      iex> Keyword.get_and_update!([a: 1], :a, fn current_value ->\n      ...>   {current_value, \"new value!\"}\n      ...> end)\n      {1, [a: \"new value!\"]}\n\n      iex> Keyword.get_and_update!([a: 1], :b, fn current_value ->\n      ...>   {current_value, \"new value!\"}\n      ...> end)\n      ** (KeyError) key :b not found in: [a: 1]\n\n      iex> Keyword.get_and_update!([a: 1], :a, fn _ ->\n      ...>   :pop\n      ...> end)\n      {1, []}\n\n  "
    },
    get_lazy = {
      description = "get_lazy(t, key, (() -> value)) :: value\nget_lazy(keywords, key, fun)\n\n  Gets the value for a specific `key`.\n\n  If `key` does not exist, lazily evaluates `fun` and returns its result.\n\n  This is useful if the default value is very expensive to calculate or\n  generally difficult to setup and teardown again.\n\n  If duplicated entries exist, the first one is returned.\n  Use `get_values/2` to retrieve all entries.\n\n  ## Examples\n\n      iex> keyword = [a: 1]\n      iex> fun = fn ->\n      ...>   # some expensive operation here\n      ...>   13\n      ...> end\n      iex> Keyword.get_lazy(keyword, :a, fun)\n      1\n      iex> Keyword.get_lazy(keyword, :b, fun)\n      13\n\n  "
    },
    get_values = {
      description = "get_values(t, key) :: [value]\nget_values(keywords, key) when is_list(keywords) and is_atom(key)\n\n  Gets all values for a specific `key`.\n\n  ## Examples\n\n      iex> Keyword.get_values([], :a)\n      []\n      iex> Keyword.get_values([a: 1], :a)\n      [1]\n      iex> Keyword.get_values([a: 1, a: 2], :a)\n      [1, 2]\n\n  "
    },
    ["has_key?"] = {
      description = "has_key?(t, key) :: boolean\nhas_key?(keywords, key) when is_list(keywords) and is_atom(key)\n\n  Returns whether a given `key` exists in the given `keywords`.\n\n  ## Examples\n\n      iex> Keyword.has_key?([a: 1], :a)\n      true\n      iex> Keyword.has_key?([a: 1], :b)\n      false\n\n  "
    },
    key = {
      description = "key :: atom\n"
    },
    keys = {
      description = "keys(t) :: [key]\nkeys(keywords) when is_list(keywords)\n\n  Returns all keys from the keyword list.\n\n  Duplicated keys appear duplicated in the final list of keys.\n\n  ## Examples\n\n      iex> Keyword.keys([a: 1, b: 2])\n      [:a, :b]\n      iex> Keyword.keys([a: 1, b: 2, a: 3])\n      [:a, :b, :a]\n\n  "
    },
    ["keyword?"] = {
      description = "keyword?(_other)\nkeyword?([])\nkeyword?([{key, _value} | rest]) when is_atom(key)\nkeyword?(term) :: boolean\nkeyword?(term)\n\n  Returns `true` if `term` is a keyword list; otherwise returns `false`.\n\n  ## Examples\n\n      iex> Keyword.keyword?([])\n      true\n      iex> Keyword.keyword?([a: 1])\n      true\n      iex> Keyword.keyword?([{Foo, 1}])\n      true\n      iex> Keyword.keyword?([{}])\n      false\n      iex> Keyword.keyword?([:key])\n      false\n      iex> Keyword.keyword?(%{})\n      false\n\n  "
    },
    merge = {
      description = "merge(t, t, (key, value, value -> value)) :: t\nmerge(keywords1, keywords2, fun) when is_list(keywords1) and is_list(keywords2) and is_function(fun, 3)\nmerge(t, t) :: t\nmerge(keywords1, keywords2) when is_list(keywords1) and is_list(keywords2)\n\n  Merges two keyword lists into one.\n\n  All keys, including duplicated keys, given in `keywords2` will be added\n  to `keywords1`, overriding any existing one.\n\n  There are no guarantees about the order of keys in the returned keyword.\n\n  ## Examples\n\n      iex> Keyword.merge([a: 1, b: 2], [a: 3, d: 4])\n      [b: 2, a: 3, d: 4]\n\n      iex> Keyword.merge([a: 1, b: 2], [a: 3, d: 4, a: 5])\n      [b: 2, a: 3, d: 4, a: 5]\n\n      iex> Keyword.merge([a: 1], [2, 3])\n      ** (ArgumentError) expected a keyword list as the second argument, got: [2, 3]\n\n  "
    },
    new = {
      description = "new(Enum.t, (term -> {key, value})) :: t\nnew(pairs, transform)\nnew(Enum.t) :: t\nnew(pairs)\nnew :: []\nnew\n\n  Returns an empty keyword list, i.e. an empty list.\n\n  ## Examples\n\n      iex> Keyword.new()\n      []\n\n  "
    },
    pop = {
      description = "pop(t, key, value) :: {value, t}\npop(keywords, key, default \\\\ nil) when is_list(keywords)\n\n  Returns and removes all values associated with `key` in the keyword list.\n\n  All duplicated keys are removed. See `pop_first/3` for\n  removing only the first entry.\n\n  ## Examples\n\n      iex> Keyword.pop([a: 1], :a)\n      {1, []}\n      iex> Keyword.pop([a: 1], :b)\n      {nil, [a: 1]}\n      iex> Keyword.pop([a: 1], :b, 3)\n      {3, [a: 1]}\n      iex> Keyword.pop([a: 1, a: 2], :a)\n      {1, []}\n\n  "
    },
    pop_first = {
      description = "pop_first(t, key, value) :: {value, t}\npop_first(keywords, key, default \\\\ nil) when is_list(keywords)\n\n  Returns and removes the first value associated with `key` in the keyword list.\n\n  Duplicated keys are not removed.\n\n  ## Examples\n\n      iex> Keyword.pop_first([a: 1], :a)\n      {1, []}\n      iex> Keyword.pop_first([a: 1], :b)\n      {nil, [a: 1]}\n      iex> Keyword.pop_first([a: 1], :b, 3)\n      {3, [a: 1]}\n      iex> Keyword.pop_first([a: 1, a: 2], :a)\n      {1, [a: 2]}\n\n  "
    },
    pop_lazy = {
      description = "pop_lazy(t, key, (() -> value)) :: {value, t}\npop_lazy(keywords, key, fun)\n\n  Lazily returns and removes all values associated with `key` in the keyword list.\n\n  This is useful if the default value is very expensive to calculate or\n  generally difficult to setup and teardown again.\n\n  All duplicated keys are removed. See `pop_first/3` for\n  removing only the first entry.\n\n  ## Examples\n\n      iex> keyword = [a: 1]\n      iex> fun = fn ->\n      ...>   # some expensive operation here\n      ...>   13\n      ...> end\n      iex> Keyword.pop_lazy(keyword, :a, fun)\n      {1, []}\n      iex> Keyword.pop_lazy(keyword, :b, fun)\n      {13, [a: 1]}\n\n  "
    },
    put = {
      description = "put(t, key, value) :: t\nput(keywords, key, value) when is_list(keywords) and is_atom(key)\n\n  Puts the given `value` under `key`.\n\n  If a previous value is already stored, all entries are\n  removed and the value is overridden.\n\n  ## Examples\n\n      iex> Keyword.put([a: 1], :b, 2)\n      [b: 2, a: 1]\n      iex> Keyword.put([a: 1, b: 2], :a, 3)\n      [a: 3, b: 2]\n      iex> Keyword.put([a: 1, b: 2, a: 4], :a, 3)\n      [a: 3, b: 2]\n\n  "
    },
    put_new = {
      description = "put_new(t, key, value) :: t\nput_new(keywords, key, value) when is_list(keywords) and is_atom(key)\n\n  Puts the given `value` under `key` unless the entry `key`\n  already exists.\n\n  ## Examples\n\n      iex> Keyword.put_new([a: 1], :b, 2)\n      [b: 2, a: 1]\n      iex> Keyword.put_new([a: 1, b: 2], :a, 3)\n      [a: 1, b: 2]\n\n  "
    },
    put_new_lazy = {
      description = "put_new_lazy(t, key, (() -> value)) :: t\nput_new_lazy(keywords, key, fun)\n\n  Evaluates `fun` and puts the result under `key`\n  in keyword list unless `key` is already present.\n\n  This is useful if the value is very expensive to calculate or\n  generally difficult to setup and teardown again.\n\n  ## Examples\n\n      iex> keyword = [a: 1]\n      iex> fun = fn ->\n      ...>   # some expensive operation here\n      ...>   3\n      ...> end\n      iex> Keyword.put_new_lazy(keyword, :a, fun)\n      [a: 1]\n      iex> Keyword.put_new_lazy(keyword, :b, fun)\n      [b: 3, a: 1]\n\n  "
    },
    size = {
      description = "size(keyword)\nfalse"
    },
    split = {
      description = "split(t, [key]) :: {t, t}\nsplit(keywords, keys) when is_list(keywords)\n\n  Takes all entries corresponding to the given keys and extracts them into a\n  separate keyword list.\n\n  Returns a tuple with the new list and the old list with removed keys.\n\n  Keys for which there are no entries in the keyword list are ignored.\n\n  Entries with duplicated keys end up in the same keyword list.\n\n  ## Examples\n\n      iex> Keyword.split([a: 1, b: 2, c: 3], [:a, :c, :e])\n      {[a: 1, c: 3], [b: 2]}\n      iex> Keyword.split([a: 1, b: 2, c: 3, a: 4], [:a, :c, :e])\n      {[a: 1, c: 3, a: 4], [b: 2]}\n\n  "
    },
    t = {
      description = "t :: [{key, value}]\n"
    },
    take = {
      description = "take(t, [key]) :: t\ntake(keywords, keys) when is_list(keywords)\n\n  Takes all entries corresponding to the given keys and returns them in a new\n  keyword list.\n\n  Duplicated keys are preserved in the new keyword list.\n\n  ## Examples\n\n      iex> Keyword.take([a: 1, b: 2, c: 3], [:a, :c, :e])\n      [a: 1, c: 3]\n      iex> Keyword.take([a: 1, b: 2, c: 3, a: 5], [:a, :c, :e])\n      [a: 1, c: 3, a: 5]\n\n  "
    },
    to_list = {
      description = "to_list(t) :: t\nto_list(keyword) when is_list(keyword)\n\n  Returns the keyword list itself.\n\n  ## Examples\n\n      iex> Keyword.to_list([a: 1])\n      [a: 1]\n\n  "
    },
    update = {
      description = "update([], key, initial, _fun) when is_atom(key)\nupdate([{_, _} = e | keywords], key, initial, fun)\nupdate([{key, value} | keywords], key, _initial, fun)\nupdate(t, key, value, (value -> value)) :: t\nupdate(keywords, key, initial, fun)\n\n  Updates the `key` in `keywords` with the given function.\n\n  If the `key` does not exist, inserts the given `initial` value.\n\n  If there are duplicated keys, they are all removed and only the first one\n  is updated.\n\n  ## Examples\n\n      iex> Keyword.update([a: 1], :a, 13, &(&1 * 2))\n      [a: 2]\n      iex> Keyword.update([a: 1, a: 2], :a, 13, &(&1 * 2))\n      [a: 2]\n      iex> Keyword.update([a: 1], :b, 11, &(&1 * 2))\n      [a: 1, b: 11]\n\n  "
    },
    ["update!"] = {
      description = "update!(t, key, (value -> value)) :: t | no_return\nupdate!(keywords, key, fun)\n\n  Updates the `key` with the given function.\n\n  If the `key` does not exist, raises `KeyError`.\n\n  If there are duplicated keys, they are all removed and only the first one\n  is updated.\n\n  ## Examples\n\n      iex> Keyword.update!([a: 1], :a, &(&1 * 2))\n      [a: 2]\n      iex> Keyword.update!([a: 1, a: 2], :a, &(&1 * 2))\n      [a: 2]\n\n      iex> Keyword.update!([a: 1], :b, &(&1 * 2))\n      ** (KeyError) key :b not found in: [a: 1]\n\n  "
    },
    value = {
      description = "value :: any\n"
    },
    values = {
      description = "values(t) :: [value]\nvalues(keywords) when is_list(keywords)\n\n  Returns all values from the keyword list.\n\n  Values from duplicated keys will be kept in the final list of values.\n\n  ## Examples\n\n      iex> Keyword.values([a: 1, b: 2])\n      [1, 2]\n      iex> Keyword.values([a: 1, b: 2, a: 3])\n      [1, 2, 3]\n\n  "
    }
  },
  LexicalTracker = nil,
  List = {
    Chars = {
      description = "\n  The List.Chars protocol is responsible for\n  converting a structure to a list (only if applicable).\n  The only function required to be implemented is\n  `to_charlist` which does the conversion.\n\n  The `to_charlist/1` function automatically imported\n  by `Kernel` invokes this protocol.\n  ",
      to_charlist = {
        description = "to_charlist(term)\nto_charlist(term)\nto_charlist(list)\nto_charlist(term)\nto_charlist(term) when is_binary(term)\nto_charlist(atom)\nto_charlist(term)\n"
      }
    },
    delete = {
      description = "delete(list, any) :: list\ndelete(list, item)\n\n  Deletes the given `item` from the `list`. Returns a new list without\n  the item.\n\n  If the `item` occurs more than once in the `list`, just\n  the first occurrence is removed.\n\n  ## Examples\n\n      iex> List.delete([:a, :b, :c], :a)\n      [:b, :c]\n\n      iex> List.delete([:a, :b, :b, :c], :b)\n      [:a, :b, :c]\n\n  "
    },
    delete_at = {
      description = "delete_at(list, integer) :: list\ndelete_at(list, index) when is_integer(index)\n\n  Produces a new list by removing the value at the specified `index`.\n\n  Negative indices indicate an offset from the end of the `list`.\n  If `index` is out of bounds, the original `list` is returned.\n\n  ## Examples\n\n      iex> List.delete_at([1, 2, 3], 0)\n      [2, 3]\n\n      iex> List.delete_at([1, 2, 3], 10)\n      [1, 2, 3]\n\n      iex> List.delete_at([1, 2, 3], -1)\n      [1, 2]\n\n  "
    },
    description = "\n  Functions that work on (linked) lists.\n\n  Lists in Elixir are specified between square brackets:\n\n      iex> [1, \"two\", 3, :four]\n      [1, \"two\", 3, :four]\n\n  Two lists can be concatenated and subtracted using the\n  `Kernel.++/2` and `Kernel.--/2` operators:\n\n      iex> [1, 2, 3] ++ [4, 5, 6]\n      [1, 2, 3, 4, 5, 6]\n      iex> [1, true, 2, false, 3, true] -- [true, false]\n      [1, 2, 3, true]\n\n  Lists in Elixir are effectively linked lists, which means\n  they are internally represented in pairs containing the\n  head and the tail of a list:\n\n      iex> [head | tail] = [1, 2, 3]\n      iex> head\n      1\n      iex> tail\n      [2, 3]\n\n  Similarly, we could write the list `[1, 2, 3]` using only\n  such pairs (called cons cells):\n\n      iex> [1 | [2 | [3 | []]]]\n      [1, 2, 3]\n\n  Some lists, called improper lists, do not have an empty list as\n  the second element in the last cons cell:\n\n      iex> [1 | [2 | [3 | 4]]]\n      [1, 2, 3 | 4]\n\n  Although improper lists are generally avoided, they are used in some\n  special circumstances like iodata and chardata entities (see the `IO` module).\n\n  Due to their cons cell based representation, prepending an element\n  to a list is always fast (constant time), while appending becomes\n  slower as the list grows in size (linear time):\n\n      iex> list = [1, 2, 3]\n      iex> [0 | list]   # fast\n      [0, 1, 2, 3]\n      iex> list ++ [4]  # slow\n      [1, 2, 3, 4]\n\n  The `Kernel` module contains many functions to manipulate lists\n  and that are allowed in guards. For example, `Kernel.hd/1` to\n  retrieve the head, `Kernel.tl/1` to fetch the tail and\n  `Kernel.length/1` for calculating the length. Keep in mind that,\n  similar to appending to a list, calculating the length needs to\n  traverse the whole list.\n\n  ## Charlists\n\n  If a list is made of non-negative integers, it can also be called\n  a charlist. Elixir uses single quotes to define charlists:\n\n      iex> 'héllo'\n      [104, 233, 108, 108, 111]\n\n  In particular, charlists may be printed back in single\n  quotes if they contain only ASCII-printable codepoints:\n\n      iex> 'abc'\n      'abc'\n\n  The rationale behind this behaviour is to better support\n  Erlang libraries which may return text as charlists\n  instead of Elixir strings. One example of such functions\n  is `Application.loaded_applications/0`:\n\n      Application.loaded_applications\n      #=>  [{:stdlib, 'ERTS  CXC 138 10', '2.6'},\n            {:compiler, 'ERTS  CXC 138 10', '6.0.1'},\n            {:elixir, 'elixir', '1.0.0'},\n            {:kernel, 'ERTS  CXC 138 10', '4.1'},\n            {:logger, 'logger', '1.0.0'}]\n\n  ## List and Enum modules\n\n  This module aims to provide operations that are specific\n  to lists, like conversion between data types, updates,\n  deletions and key lookups (for lists of tuples). For traversing\n  lists in general, developers should use the functions in the\n  `Enum` module that work across a variety of data types.\n\n  In both `Enum` and `List` modules, any kind of index access\n  on a list is linear. Negative indexes are also supported but\n  they imply the list will be iterated twice, one to calculate\n  the proper index and another to perform the operation.\n  ",
    duplicate = {
      description = "duplicate(elem, non_neg_integer) :: [elem] when elem: var\nduplicate(elem, n)\n\n  Duplicates the given element `n` times in a list.\n\n  ## Examples\n\n      iex> List.duplicate(\"hello\", 3)\n      [\"hello\", \"hello\", \"hello\"]\n\n      iex> List.duplicate([1, 2], 2)\n      [[1, 2], [1, 2]]\n\n  "
    },
    first = {
      description = "first([head | _])\nfirst([elem]) :: nil | elem when elem: var\nfirst([])\n\n  Returns the first element in `list` or `nil` if `list` is empty.\n\n  ## Examples\n\n      iex> List.first([])\n      nil\n\n      iex> List.first([1])\n      1\n\n      iex> List.first([1, 2, 3])\n      1\n\n  "
    },
    flatten = {
      description = "flatten(deep_list, [elem]) :: [elem] when elem: var, deep_list: [elem | deep_list]\nflatten(list, tail)\nflatten(deep_list) :: list when deep_list: [any | deep_list]\nflatten(list)\n\n  Flattens the given `list` of nested lists.\n\n  ## Examples\n\n      iex> List.flatten([1, [[2], 3]])\n      [1, 2, 3]\n\n  "
    },
    foldl = {
      description = "foldl([elem], acc, (elem, acc -> acc)) :: acc when elem: var, acc: var\nfoldl(list, acc, function) when is_list(list) and is_function(function)\n\n  Folds (reduces) the given list from the left with\n  a function. Requires an accumulator.\n\n  ## Examples\n\n      iex> List.foldl([5, 5], 10, fn(x, acc) -> x + acc end)\n      20\n\n      iex> List.foldl([1, 2, 3, 4], 0, fn(x, acc) -> x - acc end)\n      2\n\n  "
    },
    foldr = {
      description = "foldr([elem], acc, (elem, acc -> acc)) :: acc when elem: var, acc: var\nfoldr(list, acc, function) when is_list(list) and is_function(function)\n\n  Folds (reduces) the given list from the right with\n  a function. Requires an accumulator.\n\n  ## Examples\n\n      iex> List.foldr([1, 2, 3, 4], 0, fn(x, acc) -> x - acc end)\n      -2\n\n  "
    },
    insert_at = {
      description = "insert_at(list, integer, any) :: list\ninsert_at(list, index, value) when is_integer(index)\n\n  Returns a list with `value` inserted at the specified `index`.\n\n  Note that `index` is capped at the list length. Negative indices\n  indicate an offset from the end of the `list`.\n\n  ## Examples\n\n      iex> List.insert_at([1, 2, 3, 4], 2, 0)\n      [1, 2, 0, 3, 4]\n\n      iex> List.insert_at([1, 2, 3], 10, 0)\n      [1, 2, 3, 0]\n\n      iex> List.insert_at([1, 2, 3], -1, 0)\n      [1, 2, 3, 0]\n\n      iex> List.insert_at([1, 2, 3], -10, 0)\n      [0, 1, 2, 3]\n\n  "
    },
    keydelete = {
      description = "keydelete([tuple], any, non_neg_integer) :: [tuple]\nkeydelete(list, key, position)\n\n  Receives a `list` of tuples and deletes the first tuple\n  where the item at `position` matches the\n  given `key`. Returns the new list.\n\n  ## Examples\n\n      iex> List.keydelete([a: 1, b: 2], :a, 0)\n      [b: 2]\n\n      iex> List.keydelete([a: 1, b: 2], 2, 1)\n      [a: 1]\n\n      iex> List.keydelete([a: 1, b: 2], :c, 0)\n      [a: 1, b: 2]\n\n  "
    },
    keyfind = {
      description = "keyfind([tuple], any, non_neg_integer, any) :: any\nkeyfind(list, key, position, default \\\\ nil)\n\n  Receives a list of tuples and returns the first tuple\n  where the item at `position` in the tuple matches the\n  given `key`.\n\n  ## Examples\n\n      iex> List.keyfind([a: 1, b: 2], :a, 0)\n      {:a, 1}\n\n      iex> List.keyfind([a: 1, b: 2], 2, 1)\n      {:b, 2}\n\n      iex> List.keyfind([a: 1, b: 2], :c, 0)\n      nil\n\n  "
    },
    ["keymember?"] = {
      description = "keymember?([tuple], any, non_neg_integer) :: boolean\nkeymember?(list, key, position)\n\n  Receives a list of tuples and returns `true` if there is\n  a tuple where the item at `position` in the tuple matches\n  the given `key`.\n\n  ## Examples\n\n      iex> List.keymember?([a: 1, b: 2], :a, 0)\n      true\n\n      iex> List.keymember?([a: 1, b: 2], 2, 1)\n      true\n\n      iex> List.keymember?([a: 1, b: 2], :c, 0)\n      false\n\n  "
    },
    keyreplace = {
      description = "keyreplace([tuple], any, non_neg_integer, tuple) :: [tuple]\nkeyreplace(list, key, position, new_tuple)\n\n  Receives a list of tuples and replaces the item\n  identified by `key` at `position` if it exists.\n\n  ## Examples\n\n      iex> List.keyreplace([a: 1, b: 2], :a, 0, {:a, 3})\n      [a: 3, b: 2]\n\n  "
    },
    keysort = {
      description = "keysort([tuple], non_neg_integer) :: [tuple]\nkeysort(list, position)\n\n  Receives a list of tuples and sorts the items\n  at `position` of the tuples. The sort is stable.\n\n  ## Examples\n\n      iex> List.keysort([a: 5, b: 1, c: 3], 1)\n      [b: 1, c: 3, a: 5]\n\n      iex> List.keysort([a: 5, c: 1, b: 3], 0)\n      [a: 5, b: 3, c: 1]\n\n  "
    },
    keystore = {
      description = "keystore([tuple], any, non_neg_integer, tuple) :: [tuple, ...]\nkeystore(list, key, position, new_tuple)\n\n  Receives a `list` of tuples and replaces the item\n  identified by `key` at `position`.\n\n  If the item does not exist, it is added to the end of the `list`.\n\n  ## Examples\n\n      iex> List.keystore([a: 1, b: 2], :a, 0, {:a, 3})\n      [a: 3, b: 2]\n\n      iex> List.keystore([a: 1, b: 2], :c, 0, {:c, 3})\n      [a: 1, b: 2, c: 3]\n\n  "
    },
    keytake = {
      description = "keytake([tuple], any, non_neg_integer) :: {tuple, [tuple]} | nil\nkeytake(list, key, position)\n\n  Receives a `list` of tuples and returns the first tuple\n  where the element at `position` in the tuple matches the\n  given `key`, as well as the `list` without found tuple.\n\n  If such a tuple is not found, `nil` will be returned.\n\n  ## Examples\n\n      iex> List.keytake([a: 1, b: 2], :a, 0)\n      {{:a, 1}, [b: 2]}\n\n      iex> List.keytake([a: 1, b: 2], 2, 1)\n      {{:b, 2}, [a: 1]}\n\n      iex> List.keytake([a: 1, b: 2], :c, 0)\n      nil\n\n  "
    },
    last = {
      description = "last([_ | tail])\nlast([head])\nlast([elem]) :: nil | elem when elem: var\nlast([])\n\n  Returns the last element in `list` or `nil` if `list` is empty.\n\n  ## Examples\n\n      iex> List.last([])\n      nil\n\n      iex> List.last([1])\n      1\n\n      iex> List.last([1, 2, 3])\n      3\n\n  "
    },
    myers_difference = {
      description = "myers_difference(list, list) :: [{:eq | :ins | :del, list}] | nil\nmyers_difference(list1, list2) when is_list(list1) and is_list(list2)\n\n  Returns a keyword list that represents an *edit script*.\n\n  The algorithm is outlined in the\n  \"An O(ND) Difference Algorithm and Its Variations\" paper by E. Myers.\n\n  An *edit script* is a keyword list. Each key describes the \"editing action\" to\n  take in order to bring `list1` closer to being equal to `list2`; a key can be\n  `:eq`, `:ins`, or `:del`. Each value is a sublist of either `list1` or `list2`\n  that should be inserted (if the corresponding key `:ins`), deleted (if the\n  corresponding key is `:del`), or left alone (if the corresponding key is\n  `:eq`) in `list1` in order to be closer to `list2`.\n\n  ## Examples\n\n      iex> List.myers_difference([1, 4, 2, 3], [1, 2, 3, 4])\n      [eq: [1], del: [4], eq: [2, 3], ins: [4]]\n\n  "
    },
    pop_at = {
      description = "pop_at(list, integer, any) :: {any, list}\npop_at(list, index, default \\\\ nil) when is_integer(index)\n\n  Returns and removes the value at the specified `index` in the `list`.\n\n  Negative indices indicate an offset from the end of the `list`.\n  If `index` is out of bounds, the original `list` is returned.\n\n  ## Examples\n\n      iex> List.pop_at([1, 2, 3], 0)\n      {1, [2, 3]}\n      iex> List.pop_at([1, 2, 3], 5)\n      {nil, [1, 2, 3]}\n      iex> List.pop_at([1, 2, 3], 5, 10)\n      {10, [1, 2, 3]}\n      iex> List.pop_at([1, 2, 3], -1)\n      {3, [1, 2]}\n\n  "
    },
    replace_at = {
      description = "replace_at(list, integer, any) :: list\nreplace_at(list, index, value) when is_integer(index)\n\n  Returns a list with a replaced value at the specified `index`.\n\n  Negative indices indicate an offset from the end of the `list`.\n  If `index` is out of bounds, the original `list` is returned.\n\n  ## Examples\n\n      iex> List.replace_at([1, 2, 3], 0, 0)\n      [0, 2, 3]\n\n      iex> List.replace_at([1, 2, 3], 10, 0)\n      [1, 2, 3]\n\n      iex> List.replace_at([1, 2, 3], -1, 0)\n      [1, 2, 0]\n\n      iex> List.replace_at([1, 2, 3], -10, 0)\n      [1, 2, 3]\n\n  "
    },
    to_atom = {
      description = "to_atom(charlist) :: atom\nto_atom(charlist)\n\n  Converts a charlist to an atom.\n\n  Currently Elixir does not support conversions from charlists\n  which contains Unicode codepoints greater than 0xFF.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> List.to_atom('elixir')\n      :elixir\n\n  "
    },
    to_existing_atom = {
      description = "to_existing_atom(charlist) :: atom\nto_existing_atom(charlist)\n\n  Converts a charlist to an existing atom. Raises an `ArgumentError`\n  if the atom does not exist.\n\n  Currently Elixir does not support conversions from charlists\n  which contains Unicode codepoints greater than 0xFF.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> _ = :my_atom\n      iex> List.to_existing_atom('my_atom')\n      :my_atom\n\n      iex> List.to_existing_atom('this_atom_will_never_exist')\n      ** (ArgumentError) argument error\n\n  "
    },
    to_float = {
      description = "to_float(charlist) :: float\nto_float(charlist)\n\n  Returns the float whose text representation is `charlist`.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> List.to_float('2.2017764e+0')\n      2.2017764\n\n  "
    },
    to_integer = {
      description = "to_integer(charlist, 2..36) :: integer\nto_integer(charlist, base)\nto_integer(charlist) :: integer\nto_integer(charlist)\n\n  Returns an integer whose text representation is `charlist`.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> List.to_integer('123')\n      123\n\n  "
    },
    to_string = {
      description = "to_string(:unicode.charlist) :: String.t\nto_string(list) when is_list(list)\n\n  Converts a list of integers representing codepoints, lists or\n  strings into a string.\n\n  Notice that this function expects a list of integers representing\n  UTF-8 codepoints. If you have a list of bytes, you must instead use\n  the [`:binary` module](http://www.erlang.org/doc/man/binary.html).\n\n  ## Examples\n\n      iex> List.to_string([0x00E6, 0x00DF])\n      \"æß\"\n\n      iex> List.to_string([0x0061, \"bc\"])\n      \"abc\"\n\n  "
    },
    to_tuple = {
      description = "to_tuple(list) :: tuple\nto_tuple(list)\n\n  Converts a list to a tuple.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> List.to_tuple([:share, [:elixir, 163]])\n      {:share, [:elixir, 163]}\n\n  "
    },
    update_at = {
      description = "update_at([elem], integer, (elem -> any)) :: list when elem: var\nupdate_at(list, index, fun) when is_function(fun, 1) and is_integer(index)\n\n  Returns a list with an updated value at the specified `index`.\n\n  Negative indices indicate an offset from the end of the `list`.\n  If `index` is out of bounds, the original `list` is returned.\n\n  ## Examples\n\n      iex> List.update_at([1, 2, 3], 0, &(&1 + 10))\n      [11, 2, 3]\n\n      iex> List.update_at([1, 2, 3], 10, &(&1 + 10))\n      [1, 2, 3]\n\n      iex> List.update_at([1, 2, 3], -1, &(&1 + 10))\n      [1, 2, 13]\n\n      iex> List.update_at([1, 2, 3], -10, &(&1 + 10))\n      [1, 2, 3]\n\n  "
    },
    wrap = {
      description = "wrap(other)\nwrap(nil)\nwrap(list | any) :: list\nwrap(list) when is_list(list)\n\n  Wraps the argument in a list.\n\n  If the argument is already a list, returns the list.\n  If the argument is `nil`, returns an empty list.\n\n  ## Examples\n\n      iex> List.wrap(\"hello\")\n      [\"hello\"]\n\n      iex> List.wrap([1, 2, 3])\n      [1, 2, 3]\n\n      iex> List.wrap(nil)\n      []\n\n  "
    },
    zip = {
      description = "zip(list_of_lists) when is_list(list_of_lists)\nzip([list]) :: [tuple]\nzip([])\n\n  Zips corresponding elements from each list in `list_of_lists`.\n\n  The zipping finishes as soon as any list terminates.\n\n  ## Examples\n\n      iex> List.zip([[1, 2], [3, 4], [5, 6]])\n      [{1, 3, 5}, {2, 4, 6}]\n\n      iex> List.zip([[1, 2], [3], [5, 6]])\n      [{1, 3, 5}]\n\n  "
    }
  },
  M = {
    __after_compile__ = {
      description = "__after_compile__(env, _bytecode)\n\n        Sums `a` to `b`.\n        "
    },
    __info__ = {
      description = "__info__(kind)\n\n  Provides runtime information about functions and macros defined by the\n  module, enables docstring extraction, etc.\n\n  Each module gets an `__info__/1` function when it's compiled. The function\n  takes one of the following atoms:\n\n    * `:functions`  - keyword list of public functions along with their arities\n\n    * `:macros`     - keyword list of public macros along with their arities\n\n    * `:module`     - module name (`Module == Module.__info__(:module)`)\n\n  In addition to the above, you may also pass to `__info__/1` any atom supported\n  by `:erlang.module_info/0` which also gets defined for each compiled module.\n\n  For a list of supported attributes and more information, see [Modules – Erlang Reference Manual](http://www.erlang.org/doc/reference_manual/modules.html#id77056).\n  "
    },
    add_doc = {
      description = "add_doc(module, line, kind, tuple, signature, doc) when\nadd_doc(_module, _line, kind, _tuple, _signature, doc) when kind in [:defp, :defmacrop, :typep]\nadd_doc(module, line, kind, tuple, signature \\\\ [], doc)\n\n  Attaches documentation to a given function or type.\n\n  It expects the module the function/type belongs to, the line (a non\n  negative integer), the kind (`def` or `defmacro`), a tuple representing\n  the function and its arity, the function signature (the signature\n  should be omitted for types) and the documentation, which should\n  be either a binary or a boolean.\n\n  ## Examples\n\n      defmodule MyModule do\n        Module.add_doc(__MODULE__, __ENV__.line + 1, :def, {:version, 0}, [], \"Manually added docs\")\n        def version, do: 1\n      end\n\n  "
    },
    compile_doc = {
      description = "compile_doc(env, kind, name, args, _guards, _body)\nfalse"
    },
    concat = {
      description = "concat(binary | atom, binary | atom) :: atom\nconcat(left, right)\nconcat([binary | atom]) :: atom\nconcat(list) when is_list(list)\n\n  Concatenates a list of aliases and returns a new alias.\n\n  ## Examples\n\n      iex> Module.concat([Foo, Bar])\n      Foo.Bar\n\n      iex> Module.concat([Foo, \"Bar\"])\n      Foo.Bar\n\n  "
    },
    create = {
      description = "create(module, quoted, opts) when is_atom(module) and is_list(opts)\ncreate(module, quoted, %Macro.Env{} = env)\ncreate(module, quoted, opts)\n\n  Creates a module with the given name and defined by\n  the given quoted expressions.\n\n  The line where the module is defined and its file **must**\n  be passed as options.\n\n  ## Examples\n\n      contents =\n        quote do\n          def world, do: true\n        end\n\n      Module.create(Hello, contents, Macro.Env.location(__ENV__))\n\n      Hello.world #=> true\n\n  ## Differences from `defmodule`\n\n  `Module.create/3` works similarly to `defmodule` and\n  return the same results. While one could also use\n  `defmodule` to define modules dynamically, this\n  function is preferred when the module body is given\n  by a quoted expression.\n\n  Another important distinction is that `Module.create/3`\n  allows you to control the environment variables used\n  when defining the module, while `defmodule` automatically\n  shares the same environment.\n  "
    },
    ["defines?"] = {
      description = "defines?(module, tuple, kind)\ndefines?(module, tuple) when is_tuple(tuple)\n\n  Checks if the module defines the given function or macro.\n\n  Use `defines?/3` to assert for a specific type.\n\n  This function can only be used on modules that have not yet been compiled.\n  Use `Kernel.function_exported?/3` to check compiled modules.\n\n  ## Examples\n\n      defmodule Example do\n        Module.defines? __MODULE__, {:version, 0} #=> false\n        def version, do: 1\n        Module.defines? __MODULE__, {:version, 0} #=> true\n      end\n\n  "
    },
    definitions_in = {
      description = "definitions_in(module, kind)\ndefinitions_in(module)\n\n  Returns all functions defined in `module`.\n\n  ## Examples\n\n      defmodule Example do\n        def version, do: 1\n        Module.definitions_in __MODULE__ #=> [{:version, 0}]\n      end\n\n  "
    },
    delete_attribute = {
      description = "delete_attribute(module, key :: atom) :: (value :: term)\ndelete_attribute(module, key) when is_atom(key)\n\n  Deletes the module attribute that matches the given key.\n\n  It returns the deleted attribute value (or `nil` if nothing was set).\n\n  ## Examples\n\n      defmodule MyModule do\n        Module.put_attribute __MODULE__, :custom_threshold_for_lib, 10\n        Module.delete_attribute __MODULE__, :custom_threshold_for_lib\n      end\n\n  "
    },
    description = "\n        A very useful module\n        ",
    eval_quoted = {
      description = "eval_quoted(module, quoted, binding, opts)\neval_quoted(module, quoted, binding, %Macro.Env{} = env)\neval_quoted(%Macro.Env{} = env, quoted, binding, opts)\neval_quoted(module_or_env, quoted, binding \\\\ [], opts \\\\ [])\n\n  Evaluates the quoted contents in the given module's context.\n\n  A list of environment options can also be given as argument.\n  See `Code.eval_string/3` for more information.\n\n  Raises an error if the module was already compiled.\n\n  ## Examples\n\n      defmodule Foo do\n        contents = quote do: (def sum(a, b), do: a + b)\n        Module.eval_quoted __MODULE__, contents\n      end\n\n      Foo.sum(1, 2) #=> 3\n\n  For convenience, you can pass any `Macro.Env` struct, such\n  as  `__ENV__/0`, as the first argument or as options. Both\n  the module and all options will be automatically extracted\n  from the environment:\n\n      defmodule Foo do\n        contents = quote do: (def sum(a, b), do: a + b)\n        Module.eval_quoted __ENV__, contents\n      end\n\n      Foo.sum(1, 2) #=> 3\n\n  Note that if you pass a `Macro.Env` struct as first argument\n  while also passing `opts`, they will be merged with `opts`\n  having precedence.\n  "
    },
    get_attribute = {
      description = "get_attribute(module, key, stack) when is_atom(key)\nget_attribute(module, atom) :: term\nget_attribute(module, key)\n\n  Gets the given attribute from a module.\n\n  If the attribute was marked with `accumulate` with\n  `Module.register_attribute/3`, a list is always returned.\n  `nil` is returned if the attribute has not been marked with\n  `accumulate` and has not been set to any value.\n\n  The `@` macro compiles to a call to this function. For example,\n  the following code:\n\n      @foo\n\n  Expands to something akin to:\n\n      Module.get_attribute(__MODULE__, :foo)\n\n  ## Examples\n\n      defmodule Foo do\n        Module.put_attribute __MODULE__, :value, 1\n        Module.get_attribute __MODULE__, :value #=> 1\n\n        Module.register_attribute __MODULE__, :value, accumulate: true\n        Module.put_attribute __MODULE__, :value, 1\n        Module.get_attribute __MODULE__, :value #=> [1]\n      end\n\n  "
    },
    hello = {
      description = "hello(_)\nhello(arg) when is_binary(arg) or is_list(arg)\nhello\nhello\nfalse"
    },
    load_check = {
      description = "load_check\n\n        Sums `a` to `b`.\n        "
    },
    make_overridable = {
      description = "make_overridable(module, tuples)\n\n  Makes the given functions in `module` overridable.\n\n  An overridable function is lazily defined, allowing a\n  developer to customize it. See `Kernel.defoverridable/1` for\n  more information and documentation.\n  "
    },
    my_fun = {
      description = "my_fun(arg)\nmy_fun(arg)\n"
    },
    ["open?"] = {
      description = "open?(module)\n\n  Checks if a module is open, i.e. it is currently being defined\n  and its attributes and functions can be modified.\n  "
    },
    ["overridable?"] = {
      description = "overridable?(module, tuple)\n\n  Returns `true` if `tuple` in `module` is marked as overridable.\n  "
    },
    put_attribute = {
      description = "put_attribute(module, key, value, stack, unread_line) when is_atom(key)\nput_attribute(module, key :: atom, value :: term) :: :ok\nput_attribute(module, key, value)\n\n  Puts a module attribute with key and value in the given module.\n\n  ## Examples\n\n      defmodule MyModule do\n        Module.put_attribute __MODULE__, :custom_threshold_for_lib, 10\n      end\n\n  "
    },
    register_attribute = {
      description = "register_attribute(module, new, opts) when is_atom(new)\n\n  Registers an attribute.\n\n  By registering an attribute, a developer is able to customize\n  how Elixir will store and accumulate the attribute values.\n\n  ## Options\n\n  When registering an attribute, two options can be given:\n\n    * `:accumulate` - several calls to the same attribute will\n      accumulate instead of override the previous one. New attributes\n      are always added to the top of the accumulated list.\n\n    * `:persist` - the attribute will be persisted in the Erlang\n      Abstract Format. Useful when interfacing with Erlang libraries.\n\n  By default, both options are `false`.\n\n  ## Examples\n\n      defmodule MyModule do\n        Module.register_attribute __MODULE__,\n          :custom_threshold_for_lib,\n          accumulate: true, persist: false\n\n        @custom_threshold_for_lib 10\n        @custom_threshold_for_lib 20\n        @custom_threshold_for_lib #=> [20, 10]\n      end\n\n  "
    },
    safe_concat = {
      description = "safe_concat(binary | atom, binary | atom) :: atom | no_return\nsafe_concat(left, right)\nsafe_concat([binary | atom]) :: atom | no_return\nsafe_concat(list) when is_list(list)\n\n  Concatenates a list of aliases and returns a new alias only if the alias\n  was already referenced.\n\n  If the alias was not referenced yet, fails with `ArgumentError`.\n  It handles charlists, binaries and atoms.\n\n  ## Examples\n\n      iex> Module.safe_concat([Module, Unknown])\n      ** (ArgumentError) argument error\n\n      iex> Module.safe_concat([List, Chars])\n      List.Chars\n\n  "
    },
    some_condition = {
      description = "some_condition\n\n        Sums `a` to `b`.\n        "
    },
    split = {
      description = "split(\"Elixir.\" <> name)\nsplit(module) when is_atom(module)\n\n  Splits the given module name into binary parts.\n\n  ## Examples\n\n      iex> Module.split Very.Long.Module.Name.And.Even.Longer\n      [\"Very\", \"Long\", \"Module\", \"Name\", \"And\", \"Even\", \"Longer\"]\n\n  "
    },
    store_typespec = {
      description = "store_typespec(module, key, value) when is_atom(key)\nfalse"
    },
    sum = {
      description = "sum(a, b)\n\n        Sums `a` to `b`.\n        "
    }
  },
  Macro = {
    Env = {
      __struct__ = {
        description = "__struct__(kv)\n__struct__\n"
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
        description = "in_guard?(%{__struct__: Macro.Env, context: context})\nin_guard?(t) :: boolean\nin_guard?(env)\n\n  Returns whether the compilation environment is currently\n  inside a guard.\n  "
      },
      ["in_match?"] = {
        description = "in_match?(%{__struct__: Macro.Env, context: context})\nin_match?(t) :: boolean\nin_match?(env)\n\n  Returns whether the compilation environment is currently\n  inside a match clause.\n  "
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
        description = "location(%{__struct__: Macro.Env, file: file, line: line})\nlocation(t) :: Keyword.t\nlocation(env)\n\n  Returns a keyword list containing the file and line\n  information as keys.\n  "
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
      stacktrace = {
        description = "stacktrace(t) :: list\nstacktrace(%{__struct__: Macro.Env} = env)\n\n  Returns the environment stacktrace.\n  "
      },
      t = {
        description = "t :: %{__struct__: __MODULE__,\n"
      },
      vars = {
        description = "vars :: [{atom, atom | non_neg_integer}]\n"
      }
    },
    camelize = {
      description = "camelize(<<h, t::binary>>),\ncamelize(<<?_, t::binary>>),\ncamelize(\"\"),\ncamelize(String.t) :: String.t\ncamelize(string)\n\n  Converts the given string to CamelCase format.\n\n  This function was designed to camelize language identifiers/tokens,\n  that's why it belongs to the `Macro` module. Do not use it as a general\n  mechanism for camelizing strings as it does not support Unicode or\n  characters that are not valid in Elixir identifiers.\n\n  ## Examples\n\n      iex> Macro.camelize \"foo_bar\"\n      \"FooBar\"\n\n  "
    },
    classify_identifier = {
      description = "classify_identifier(string) when is_binary(string)\nclassify_identifier(atom) when is_atom(atom)\nclassify_identifier(atom_or_string)\nfalse"
    },
    decompose_call = {
      description = "decompose_call(_),\ndecompose_call({name, _, args}) when is_atom(name) and is_list(args),\ndecompose_call({name, _, args}) when is_atom(name) and is_atom(args),\ndecompose_call({{:., _, [remote, function]}, _, args}) when is_tuple(remote) or is_atom(remote),\ndecompose_call(Macro.t) :: {atom, [Macro.t]} | {Macro.t, atom, [Macro.t]} | :error\ndecompose_call(ast)\n\n  Decomposes a local or remote call into its remote part (when provided),\n  function name and argument list.\n\n  Returns `:error` when an invalid call syntax is provided.\n\n  ## Examples\n\n      iex> Macro.decompose_call(quote(do: foo))\n      {:foo, []}\n\n      iex> Macro.decompose_call(quote(do: foo()))\n      {:foo, []}\n\n      iex> Macro.decompose_call(quote(do: foo(1, 2, 3)))\n      {:foo, [1, 2, 3]}\n\n      iex> Macro.decompose_call(quote(do: Elixir.M.foo(1, 2, 3)))\n      {{:__aliases__, [], [:Elixir, :M]}, :foo, [1, 2, 3]}\n\n      iex> Macro.decompose_call(quote(do: 42))\n      :error\n\n  "
    },
    description = "\n  Conveniences for working with macros.\n\n  ## Custom Sigils\n\n  To create a custom sigil, define a function with the name\n  `sigil_{identifier}` that takes two arguments. The first argument will be\n  the string, the second will be a charlist containing any modifiers. If the\n  sigil is lower case (such as `sigil_x`) then the string argument will allow\n  interpolation. If the sigil is upper case (such as `sigil_X`) then the string\n  will not be interpolated.\n\n  Valid modifiers include only lower and upper case letters. Other characters\n  will cause a syntax error.\n\n  The module containing the custom sigil must be imported before the sigil\n  syntax can be used.\n\n  ### Examples\n\n      defmodule MySigils do\n        defmacro sigil_x(term, [?r]) do\n          quote do\n            unquote(term) |> String.reverse()\n          end\n        end\n        defmacro sigil_x(term, _modifiers) do\n          term\n        end\n        defmacro sigil_X(term, [?r]) do\n          quote do\n            unquote(term) |> String.reverse()\n          end\n        end\n        defmacro sigil_X(term, _modifiers) do\n          term\n        end\n      end\n\n      import MySigils\n\n      ~x(with #{\"inter\" <> \"polation\"})\n      #=>\"with interpolation\"\n\n      ~x(with #{\"inter\" <> \"polation\"})r\n      #=>\"noitalopretni htiw\"\n\n      ~X(without #{\"interpolation\"})\n      #=>\"without \\#{\"interpolation\"}\"\n\n      ~X(without #{\"interpolation\"})r\n      #=>\"}\\\"noitalopretni\\\"{# tuohtiw\"\n  ",
    escape = {
      description = "escape(term, Keyword.t) :: Macro.t\nescape(expr, opts \\\\ [])\n\n  Recursively escapes a value so it can be inserted\n  into a syntax tree.\n\n  One may pass `unquote: true` to `escape/2`\n  which leaves `unquote/1` statements unescaped, effectively\n  unquoting the contents on escape.\n\n  ## Examples\n\n      iex> Macro.escape(:foo)\n      :foo\n\n      iex> Macro.escape({:a, :b, :c})\n      {:{}, [], [:a, :b, :c]}\n\n      iex> Macro.escape({:unquote, [], [1]}, unquote: true)\n      1\n\n  "
    },
    expand = {
      description = "expand(tree, env)\n\n  Receives an AST node and expands it until it can no longer\n  be expanded.\n\n  This function uses `expand_once/2` under the hood. Check\n  it out for more information and examples.\n  "
    },
    expand_once = {
      description = "expand_once(ast, env)\n\n  Receives an AST node and expands it once.\n\n  The following contents are expanded:\n\n    * Macros (local or remote)\n    * Aliases are expanded (if possible) and return atoms\n    * Compilation environment macros (`__ENV__/0`, `__MODULE__/0` and `__DIR__/0`)\n    * Module attributes reader (`@foo`)\n\n  If the expression cannot be expanded, it returns the expression\n  itself. Notice that `expand_once/2` performs the expansion just\n  once and it is not recursive. Check `expand/2` for expansion\n  until the node can no longer be expanded.\n\n  ## Examples\n\n  In the example below, we have a macro that generates a module\n  with a function named `name_length` that returns the length\n  of the module name. The value of this function will be calculated\n  at compilation time and not at runtime.\n\n  Consider the implementation below:\n\n      defmacro defmodule_with_length(name, do: block) do\n        length = length(Atom.to_charlist(name))\n\n        quote do\n          defmodule unquote(name) do\n            def name_length, do: unquote(length)\n            unquote(block)\n          end\n        end\n      end\n\n  When invoked like this:\n\n      defmodule_with_length My.Module do\n        def other_function, do: ...\n      end\n\n  The compilation will fail because `My.Module` when quoted\n  is not an atom, but a syntax tree as follow:\n\n      {:__aliases__, [], [:My, :Module]}\n\n  That said, we need to expand the aliases node above to an\n  atom, so we can retrieve its length. Expanding the node is\n  not straight-forward because we also need to expand the\n  caller aliases. For example:\n\n      alias MyHelpers, as: My\n\n      defmodule_with_length My.Module do\n        def other_function, do: ...\n      end\n\n  The final module name will be `MyHelpers.Module` and not\n  `My.Module`. With `Macro.expand/2`, such aliases are taken\n  into consideration. Local and remote macros are also\n  expanded. We could rewrite our macro above to use this\n  function as:\n\n      defmacro defmodule_with_length(name, do: block) do\n        expanded = Macro.expand(name, __CALLER__)\n        length   = length(Atom.to_charlist(expanded))\n\n        quote do\n          defmodule unquote(name) do\n            def name_length, do: unquote(length)\n            unquote(block)\n          end\n        end\n      end\n\n  "
    },
    expr = {
      description = "expr :: {expr | atom, Keyword.t, atom | [t]}\n"
    },
    generate_arguments = {
      description = "generate_arguments(amount, context) when is_integer(amount) and amount > 0 and is_atom(context)\ngenerate_arguments(0, _)\n\n  Generates AST nodes for a given number of required argument variables using\n  `Macro.var/2`.\n\n  ## Examples\n\n      iex> Macro.generate_arguments(2, __MODULE__)\n      [{:var1, [], __MODULE__}, {:var2, [], __MODULE__}]\n\n  "
    },
    pipe = {
      description = "pipe(expr, call_args, _integer)\npipe(expr, {call, line, args}, integer) when is_list(args)\npipe(expr, {call, line, atom}, integer) when is_atom(atom)\npipe(expr, {:fn, _, _}, _integer)\npipe(expr, {call, _, [_, _]} = call_args, _integer)\npipe(expr, {:__aliases__, _, _} = call_args, _integer)\npipe(expr, {tuple_or_map, _, _} = call_args, _integer) when tuple_or_map in [:{}, :%{}]\npipe(expr, {:&, _, _} = call_args, _integer)\npipe(Macro.t, Macro.t, integer) :: Macro.t | no_return\npipe(expr, call_args, position)\n\n  Pipes `expr` into the `call_args` at the given `position`.\n  "
    },
    pipe_warning = {
      description = "pipe_warning(_)\npipe_warning({call, _, _}) when call in unquote(@unary_ops)\nfalse"
    },
    postwalk = {
      description = "postwalk(t, any, (t, any -> {t, any})) :: {t, any}\npostwalk(ast, acc, fun) when is_function(fun, 2)\npostwalk(t, (t -> t)) :: t\npostwalk(ast, fun) when is_function(fun, 1)\n\n  Performs a depth-first, post-order traversal of quoted expressions.\n  "
    },
    prewalk = {
      description = "prewalk(t, any, (t, any -> {t, any})) :: {t, any}\nprewalk(ast, acc, fun) when is_function(fun, 2)\nprewalk(t, (t -> t)) :: t\nprewalk(ast, fun) when is_function(fun, 1)\n\n  Performs a depth-first, pre-order traversal of quoted expressions.\n  "
    },
    t = {
      description = "t :: expr | {t, t} | atom | number | binary | pid | fun | [t]\n"
    },
    to_string = {
      description = "to_string(other, fun)\nto_string(list, fun) when is_list(list)\nto_string({left, right}, fun)\nto_string({target, _, args} = ast, fun) when is_list(args)\nto_string({{:., _, [Access, :get]}, _, [left, right]} = ast, fun)\nto_string({{:., _, [Access, :get]}, _, [{op, _, _} = left, right]} = ast, fun)\nto_string({op, _, [arg]} = ast, fun) when op in unquote(@unary_ops)\nto_string({:not, _, [arg]} = ast, fun)\nto_string({unary, _, [{binary, _, [_, _]} = arg]} = ast, fun)\nto_string({:not, _, [{:in, _, [left, right]}]} = ast, fun)\nto_string({:&, _, [arg]} = ast, fun) when not is_integer(arg)\nto_string({:&, _, [{:/, _, [{{:., _, [mod, name]}, _, []}, arity]}]} = ast, fun)\nto_string({:&, _, [{:/, _, [{name, _, ctx}, arity]}]} = ast, fun)\nto_string({:when, _, args} = ast, fun)\nto_string({op, _, [left, right]} = ast, fun) when op in unquote(@binary_ops)\nto_string({:when, _, [left, right]} = ast, fun)\nto_string([{:->, _, _} | _] = ast, fun)\nto_string({:.., _, args} = ast, fun)\nto_string({:fn, _, block} = ast, fun)\nto_string({:fn, _, [{:->, _, _}] = block} = ast, fun)\nto_string({:fn, _, [{:->, _, [_, tuple]}] = arrow} = ast, fun)\nto_string({:%, _, [structname, map]} = ast, fun)\nto_string({:%{}, _, args} = ast, fun)\nto_string({:{}, _, args} = ast, fun)\nto_string({:<<>>, _, parts} = ast, fun)\nto_string({:__block__, _, _} = ast, fun)\nto_string({:__block__, _, [expr]} = ast, fun)\nto_string({:__aliases__, _, refs} = ast, fun)\nto_string({var, _, atom} = ast, fun) when is_atom(atom)\nto_string(Macro.t, (Macro.t, String.t -> String.t)) :: String.t\nto_string(tree, fun \\\\ fn(_ast, string) -> string end)\n\n  Converts the given expression to a binary.\n\n  The given `fun` is called for every node in the AST with two arguments: the\n  AST of the node being printed and the string representation of that same\n  node. The return value of this function is used as the final string\n  representation for that AST node.\n\n  ## Examples\n\n      iex> Macro.to_string(quote(do: foo.bar(1, 2, 3)))\n      \"foo.bar(1, 2, 3)\"\n\n      iex> Macro.to_string(quote(do: 1 + 2), fn\n      ...>   1, _string -> \"one\"\n      ...>   2, _string -> \"two\"\n      ...>   _ast, string -> string\n      ...> end)\n      \"one + two\"\n\n  "
    },
    traverse = {
      description = "traverse(t, any, (t, any -> {t, any}), (t, any -> {t, any})) :: {t, any}\ntraverse(ast, acc, pre, post) when is_function(pre, 2) and is_function(post, 2)\n\n  Performs a depth-first traversal of quoted expressions\n  using an accumulator.\n  "
    },
    underscore = {
      description = "underscore(<<h, t::binary>>)\nunderscore(\"\")\nunderscore(atom) when is_atom(atom)\n\n  Converts the given atom or binary to underscore format.\n\n  If an atom is given, it is assumed to be an Elixir module,\n  so it is converted to a binary and then processed.\n\n  This function was designed to underscore language identifiers/tokens,\n  that's why it belongs to the `Macro` module. Do not use it as a general\n  mechanism for underscoring strings as it does not support Unicode or\n  characters that are not valid in Elixir identifiers.\n\n  ## Examples\n\n      iex> Macro.underscore \"FooBar\"\n      \"foo_bar\"\n\n      iex> Macro.underscore \"Foo.Bar\"\n      \"foo/bar\"\n\n      iex> Macro.underscore Foo.Bar\n      \"foo/bar\"\n\n  In general, `underscore` can be thought of as the reverse of\n  `camelize`, however, in some cases formatting may be lost:\n\n      iex> Macro.underscore \"SAPExample\"\n      \"sap_example\"\n\n      iex> Macro.camelize \"sap_example\"\n      \"SapExample\"\n\n      iex> Macro.camelize \"hello_10\"\n      \"Hello10\"\n\n  "
    },
    unescape_string = {
      description = "unescape_string(String.t, (non_neg_integer -> non_neg_integer | false)) :: String.t\nunescape_string(chars, map)\nunescape_string(String.t) :: String.t\nunescape_string(chars)\n\n  Unescapes the given chars.\n\n  This is the unescaping behaviour used by default in Elixir\n  single- and double-quoted strings. Check `unescape_string/2`\n  for information on how to customize the escaping map.\n\n  In this setup, Elixir will escape the following: `\\0`, `\\a`, `\\b`,\n  `\\d`, `\\e`, `\\f`, `\\n`, `\\r`, `\\s`, `\\t` and `\\v`. Bytes can be\n  given as hexadecimals via `\\xNN` and Unicode Codepoints as\n  `\\uNNNN` escapes.\n\n  This function is commonly used on sigil implementations\n  (like `~r`, `~s` and others) which receive a raw, unescaped\n  string.\n\n  ## Examples\n\n      iex> Macro.unescape_string(\"example\\\\n\")\n      \"example\\n\"\n\n  In the example above, we pass a string with `\\n` escaped\n  and return a version with it unescaped.\n  "
    },
    unescape_tokens = {
      description = "unescape_tokens([Macro.t], (non_neg_integer -> non_neg_integer | false)) :: [Macro.t]\nunescape_tokens(tokens, map)\nunescape_tokens([Macro.t]) :: [Macro.t]\nunescape_tokens(tokens)\n\n  Unescapes the given tokens according to the default map.\n\n  Check `unescape_string/1` and `unescape_string/2` for more\n  information about unescaping.\n\n  Only tokens that are binaries are unescaped, all others are\n  ignored. This function is useful when implementing your own\n  sigils. Check the implementation of `Kernel.sigil_s/2`\n  for examples.\n  "
    },
    unpipe = {
      description = "unpipe(Macro.t) :: [Macro.t]\nunpipe(expr)\n\n  Breaks a pipeline expression into a list.\n\n  The AST for a pipeline (a sequence of applications of `|>`) is similar to the\n  AST of a sequence of binary operators or function applications: the top-level\n  expression is the right-most `:|>` (which is the last one to be executed), and\n  its left-hand and right-hand sides are its arguments:\n\n      quote do: 100 |> div(5) |> div(2)\n      #=> {:|>, _, [arg1, arg2]}\n\n  In the example above, the `|>` pipe is the right-most pipe; `arg1` is the AST\n  for `100 |> div(5)`, and `arg2` is the AST for `div(2)`.\n\n  It's often useful to have the AST for such a pipeline as a list of function\n  applications. This function does exactly that:\n\n      Macro.unpipe(quote do: 100 |> div(5) |> div(2))\n      #=> [{100, 0}, {{:div, [], [5]}, 0}, {{:div, [], [2]}, 0}]\n\n  We get a list that follows the pipeline directly: first the `100`, then the\n  `div(5)` (more precisely, its AST), then `div(2)`. The `0` as the second\n  element of the tuples is the position of the previous element in the pipeline\n  inside the current function application: `{{:div, [], [5]}, 0}` means that the\n  previous element (`100`) will be inserted as the 0th (first) argument to the\n  `div/2` function, so that the AST for that function will become `{:div, [],\n  [100, 5]}` (`div(100, 5)`).\n  "
    },
    update_meta = {
      description = "update_meta(other, _fun)\nupdate_meta({left, meta, right}, fun) when is_list(meta)\nupdate_meta(t, (Keyword.t -> Keyword.t)) :: t\nupdate_meta(quoted, fun)\n\n  Applies the given function to the node metadata if it contains one.\n\n  This is often useful when used with `Macro.prewalk/2` to remove\n  information like lines and hygienic counters from the expression\n  for either storage or comparison.\n\n  ## Examples\n\n      iex> quoted = quote line: 10, do: sample()\n      {:sample, [line: 10], []}\n      iex> Macro.update_meta(quoted, &Keyword.delete(&1, :line))\n      {:sample, [], []}\n\n  "
    },
    validate = {
      description = "validate(term) :: :ok | {:error, term}\nvalidate(expr)\n\n  Validates the given expressions are valid quoted expressions.\n\n  Checks the `t:Macro.t/0` for the specification of a valid\n  quoted expression.\n\n  It returns `:ok` if the expression is valid. Otherwise it returns a tuple in the form of\n  `{:error, remainder}` where `remainder` is the invalid part of the quoted expression.\n\n  ## Examples\n\n      iex> Macro.validate({:two_element, :tuple})\n      :ok\n      iex> Macro.validate({:three, :element, :tuple})\n      {:error, {:three, :element, :tuple}}\n\n      iex> Macro.validate([1, 2, 3])\n      :ok\n      iex> Macro.validate([1, 2, 3, {4}])\n      {:error, {4}}\n\n  "
    },
    var = {
      description = "var(var, context) :: {var, [], context} when var: atom, context: atom\nvar(var, context) when is_atom(var) and is_atom(context)\n\n  Generates an AST node representing the variable given\n  by the atoms `var` and `context`.\n\n  ## Examples\n\n  In order to build a variable, a context is expected.\n  Most of the times, in order to preserve hygiene, the\n  context must be `__MODULE__/0`:\n\n      iex> Macro.var(:foo, __MODULE__)\n      {:foo, [], __MODULE__}\n\n  However, if there is a need to access the user variable,\n  nil can be given:\n\n      iex> Macro.var(:foo, nil)\n      {:foo, [], nil}\n\n  "
    }
  },
  Map = {
    delete = {
      description = "delete(map, key) :: map\ndelete(map, key)\n\n  Deletes the entry in `map` for a specific `key`.\n\n  If the `key` does not exist, returns `map` unchanged.\n\n  ## Examples\n\n      iex> Map.delete(%{a: 1, b: 2}, :a)\n      %{b: 2}\n      iex> Map.delete(%{b: 2}, :a)\n      %{b: 2}\n\n  "
    },
    description = "\n  A set of functions for working with maps.\n\n  Maps are the \"go to\" key-value data structure in Elixir. Maps can be created\n  with the `%{}` syntax, and key-value pairs can be expressed as `key => value`:\n\n      iex> %{}\n      %{}\n      iex> %{\"one\" => :two, 3 => \"four\"}\n      %{3 => \"four\", \"one\" => :two}\n\n  Key-value pairs in a map do not follow any order (that's why the printed map\n  in the example above has a different order than the map that was created).\n\n  Maps do not impose any restriction on the key type: anything can be a key in a\n  map. As a key-value structure, maps do not allow duplicated keys. Keys are\n  compared using the exact-equality operator (`===`). If colliding keys are defined\n  in a map literal, the last one prevails.\n\n  When the key in a key-value pair is an atom, the `key: value` shorthand syntax\n  can be used (as in many other special forms), provided key-value pairs are put at\n  the end:\n\n      iex> %{\"hello\" => \"world\", a: 1, b: 2}\n      %{:a => 1, :b => 2, \"hello\" => \"world\"}\n\n  Keys in maps can be accessed through some of the functions in this module\n  (such as `Map.get/3` or `Map.fetch/2`) or through the `[]` syntax provided by\n  the `Access` module:\n\n      iex> map = %{a: 1, b: 2}\n      iex> Map.fetch(map, :a)\n      {:ok, 1}\n      iex> map[:b]\n      2\n      iex> map[\"non_existing_key\"]\n      nil\n\n  The alternative access syntax `map.key` is provided alongside `[]` when the\n  map has a `:key` key; note that while `map[key]` will return `nil` if `map`\n  doesn't contain the key `key`, `map.key` will raise if `map` doesn't contain\n  the key `:key`.\n\n      iex> map = %{foo: \"bar\", baz: \"bong\"}\n      iex> map.foo\n      \"bar\"\n      iex> map.non_existing_key\n      ** (KeyError) key :non_existing_key not found in: %{baz: \"bong\", foo: \"bar\"}\n\n  Maps can be pattern matched on; when a map is on the left-hand side of a\n  pattern match, it will match if the map on the right-hand side contains the\n  keys on the left-hand side and their values match the ones on the left-hand\n  side. This means that an empty map matches every map.\n\n      iex> %{} = %{foo: \"bar\"}\n      %{foo: \"bar\"}\n      iex> %{a: a} = %{:a => 1, \"b\" => 2, [:c, :e, :e] => 3}\n      iex> a\n      1\n      iex> %{:c => 3} = %{:a => 1, 2 => :b}\n      ** (MatchError) no match of right hand side value: %{2 => :b, :a => 1}\n\n  Variables can be used as map keys both when writing map literals as well as\n  when matching:\n\n      iex> n = 1\n      1\n      iex> %{n => :one}\n      %{1 => :one}\n      iex> %{^n => :one} = %{1 => :one, 2 => :two, 3 => :three}\n      %{1 => :one, 2 => :two, 3 => :three}\n\n  Maps also support a specific update syntax to update the value stored under\n  *existing* atom keys:\n\n      iex> map = %{one: 1, two: 2}\n      iex> %{map | one: \"one\"}\n      %{one: \"one\", two: 2}\n      iex> %{map | three: 3}\n      ** (KeyError) key :three not found\n\n  ## Modules to work with maps\n\n  This module aims to provide functions that perform operations specific to maps\n  (like accessing keys, updating values, and so on). For traversing maps as\n  collections, developers should use the `Enum` module that works across a\n  variety of data types.\n\n  The `Kernel` module also provides a few functions to work with maps: for\n  example, `Kernel.map_size/1` to know the number of key-value pairs in a map or\n  `Kernel.is_map/1` to know if a term is a map.\n  ",
    drop = {
      description = "drop(non_map, _keys)\ndrop(map, keys) when is_map(map)\ndrop(map, Enumerable.t) :: map\ndrop(map, keys)\n\n  Drops the given `keys` from `map`.\n\n  If `keys` contains keys that are not in `map`, they're simply ignored.\n\n  ## Examples\n\n      iex> Map.drop(%{a: 1, b: 2, c: 3}, [:b, :d])\n      %{a: 1, c: 3}\n\n  "
    },
    ["equal?"] = {
      description = "equal?(map, map) :: boolean\nequal?(%{} = map1, %{} = map2)\n\n  Checks if two maps are equal.\n\n  Two maps are considered to be equal if they contain\n  the same keys and those keys contain the same values.\n\n  ## Examples\n\n      iex> Map.equal?(%{a: 1, b: 2}, %{b: 2, a: 1})\n      true\n      iex> Map.equal?(%{a: 1, b: 2}, %{b: 1, a: 2})\n      false\n\n  "
    },
    fetch = {
      description = "fetch(map, key) :: {:ok, value} | :error\nfetch(map, key)\n\n  Fetches the value for a specific `key` in the given `map`.\n\n  If `map` contains the given `key` with value `value`, then `{:ok, value}` is\n  returned. If `map` doesn't contain `key`, `:error` is returned.\n\n  ## Examples\n\n      iex> Map.fetch(%{a: 1}, :a)\n      {:ok, 1}\n      iex> Map.fetch(%{a: 1}, :b)\n      :error\n\n  "
    },
    ["fetch!"] = {
      description = "fetch!(map, key) :: value | no_return\nfetch!(map, key)\n\n  Fetches the value for a specific `key` in the given `map`, erroring out if\n  `map` doesn't contain `key`.\n\n  If `map` contains the given `key`, the corresponding value is returned. If\n  `map` doesn't contain `key`, a `KeyError` exception is raised.\n\n  ## Examples\n\n      iex> Map.fetch!(%{a: 1}, :a)\n      1\n      iex> Map.fetch!(%{a: 1}, :b)\n      ** (KeyError) key :b not found in: %{a: 1}\n\n  "
    },
    from_struct = {
      description = "from_struct(%{__struct__: _} = struct)\nfrom_struct(atom | struct) :: map\nfrom_struct(struct) when is_atom(struct)\n\n  Converts a `struct` to map.\n\n  It accepts the struct module or a struct itself and\n  simply removes the `__struct__` field from the given struct\n  or from a new struct generated from the given module.\n\n  ## Example\n\n      defmodule User do\n        defstruct [:name]\n      end\n\n      Map.from_struct(User)\n      #=> %{name: nil}\n\n      Map.from_struct(%User{name: \"john\"})\n      #=> %{name: \"john\"}\n\n  "
    },
    get = {
      description = "get(map, key, value) :: value\nget(map, key, default \\\\ nil)\n\n  Gets the value for a specific `key` in `map`.\n\n  If `key` is present in `map` with value `value`, then `value` is\n  returned. Otherwise, `default` is returned (which is `nil` unless\n  specified otherwise).\n\n  ## Examples\n\n      iex> Map.get(%{}, :a)\n      nil\n      iex> Map.get(%{a: 1}, :a)\n      1\n      iex> Map.get(%{a: 1}, :b)\n      nil\n      iex> Map.get(%{a: 1}, :b, 3)\n      3\n\n  "
    },
    get_and_update = {
      description = "get_and_update(map, _key, _fun)\nget_and_update(map, key, (value -> {get, value} | :pop)) :: {get, map} when get: term\nget_and_update(%{} = map, key, fun) when is_function(fun, 1)\n\n  Gets the value from `key` and updates it, all in one pass.\n\n  `fun` is called with the current value under `key` in `map` (or `nil` if `key`\n  is not present in `map`) and must return a two-element tuple: the \"get\" value\n  (the retrieved value, which can be operated on before being returned) and the\n  new value to be stored under `key` in the resulting new map. `fun` may also\n  return `:pop`, which means the current value shall be removed from `map` and\n  returned (making this function behave like `Map.pop(map, key)`.\n\n  The returned value is a tuple with the \"get\" value returned by\n  `fun` and a new map with the updated value under `key`.\n\n  ## Examples\n\n      iex> Map.get_and_update(%{a: 1}, :a, fn current_value ->\n      ...>   {current_value, \"new value!\"}\n      ...> end)\n      {1, %{a: \"new value!\"}}\n\n      iex> Map.get_and_update(%{a: 1}, :b, fn current_value ->\n      ...>   {current_value, \"new value!\"}\n      ...> end)\n      {nil, %{b: \"new value!\", a: 1}}\n\n      iex> Map.get_and_update(%{a: 1}, :a, fn _ -> :pop end)\n      {1, %{}}\n\n      iex> Map.get_and_update(%{a: 1}, :b, fn _ -> :pop end)\n      {nil, %{a: 1}}\n\n  "
    },
    ["get_and_update!"] = {
      description = "get_and_update!(map, _key, _fun)\nget_and_update!(map, key, (value -> {get, value})) :: {get, map} | no_return when get: term\nget_and_update!(%{} = map, key, fun) when is_function(fun, 1)\n\n  Gets the value from `key` and updates it. Raises if there is no `key`.\n\n  Behaves exactly like `get_and_update/3`, but raises a `KeyError` exception if\n  `key` is not present in `map`.\n\n  ## Examples\n\n      iex> Map.get_and_update!(%{a: 1}, :a, fn current_value ->\n      ...>   {current_value, \"new value!\"}\n      ...> end)\n      {1, %{a: \"new value!\"}}\n\n      iex> Map.get_and_update!(%{a: 1}, :b, fn current_value ->\n      ...>   {current_value, \"new value!\"}\n      ...> end)\n      ** (KeyError) key :b not found in: %{a: 1}\n\n      iex> Map.get_and_update!(%{a: 1}, :a, fn _ ->\n      ...>   :pop\n      ...> end)\n      {1, %{}}\n\n  "
    },
    get_lazy = {
      description = "get_lazy(map, key, (() -> value)) :: value\nget_lazy(map, key, fun) when is_function(fun, 0)\n\n  Gets the value for a specific `key` in `map`.\n\n  If `key` is present in `map` with value `value`, then `value` is\n  returned. Otherwise, `fun` is evaluated and its result is returned.\n\n  This is useful if the default value is very expensive to calculate or\n  generally difficult to setup and teardown again.\n\n  ## Examples\n\n      iex> map = %{a: 1}\n      iex> fun = fn ->\n      ...>   # some expensive operation here\n      ...>   13\n      ...> end\n      iex> Map.get_lazy(map, :a, fun)\n      1\n      iex> Map.get_lazy(map, :b, fun)\n      13\n\n  "
    },
    ["has_key?"] = {
      description = "has_key?(map, key) :: boolean\nhas_key?(map, key)\n\n  Returns whether the given `key` exists in the given `map`.\n\n  ## Examples\n\n      iex> Map.has_key?(%{a: 1}, :a)\n      true\n      iex> Map.has_key?(%{a: 1}, :b)\n      false\n\n  "
    },
    key = {
      description = "key :: any\n"
    },
    merge = {
      description = "merge(map, map, (key, value, value -> value)) :: map\nmerge(map1, map2, callback) when is_function(callback, 3)\n\n  Merges two maps into one, resolving conflicts through the given `callback`.\n\n  All keys in `map2` will be added to `map1`. The given function will be invoked\n  when there are duplicate keys; its arguments are `key` (the duplicate key),\n  `value1` (the value of `key` in `map1`), and `value2` (the value of `key` in\n  `map2`). The value returned by `callback` is used as the value under `key` in\n  the resulting map.\n\n  ## Examples\n\n      iex> Map.merge(%{a: 1, b: 2}, %{a: 3, d: 4}, fn _k, v1, v2 ->\n      ...>   v1 + v2\n      ...> end)\n      %{a: 4, b: 2, d: 4}\n\n  "
    },
    new = {
      description = "new(Enumerable.t, (term -> {key, value})) :: map\nnew(enumerable, transform) when is_function(transform, 1)\nnew(enum)\nnew(%{} = map)\nnew(%{__struct__: _} = struct)\nnew(Enumerable.t) :: map\nnew(enumerable)\nnew :: map\nnew\n\n  Returns a new empty map.\n\n  ## Examples\n\n      iex> Map.new\n      %{}\n\n  "
    },
    pop = {
      description = "pop(map, key, value) :: {value, map}\npop(map, key, default \\\\ nil)\n\n  Returns and removes the value associated with `key` in `map`.\n\n  If `key` is present in `map` with value `value`, `{value, new_map}` is\n  returned where `new_map` is the result of removing `key` from `map`. If `key`\n  is not present in `map`, `{default, map}` is returned.\n\n  ## Examples\n\n      iex> Map.pop(%{a: 1}, :a)\n      {1, %{}}\n      iex> Map.pop(%{a: 1}, :b)\n      {nil, %{a: 1}}\n      iex> Map.pop(%{a: 1}, :b, 3)\n      {3, %{a: 1}}\n\n  "
    },
    pop_lazy = {
      description = "pop_lazy(map, key, (() -> value)) :: {value, map}\npop_lazy(map, key, fun) when is_function(fun, 0)\n\n  Lazily returns and removes the value associated with `key` in `map`.\n\n  If `key` is present in `map` with value `value`, `{value, new_map}` is\n  returned where `new_map` is the result of removing `key` from `map`. If `key`\n  is not present in `map`, `{fun_result, map}` is returned, where `fun_result`\n  is the result of applying `fun`.\n\n  This is useful if the default value is very expensive to calculate or\n  generally difficult to setup and teardown again.\n\n  ## Examples\n\n      iex> map = %{a: 1}\n      iex> fun = fn ->\n      ...>   # some expensive operation here\n      ...>   13\n      ...> end\n      iex> Map.pop_lazy(map, :a, fun)\n      {1, %{}}\n      iex> Map.pop_lazy(map, :b, fun)\n      {13, %{a: 1}}\n\n  "
    },
    put = {
      description = "put(map, key, value) :: map\nput(map, key, value)\n\n  Puts the given `value` under `key` in `map`.\n\n  ## Examples\n\n      iex> Map.put(%{a: 1}, :b, 2)\n      %{a: 1, b: 2}\n      iex> Map.put(%{a: 1, b: 2}, :a, 3)\n      %{a: 3, b: 2}\n\n  "
    },
    put_new = {
      description = "put_new(map, key, value) :: map\nput_new(map, key, value)\n\n  Puts the given `value` under `key` unless the entry `key`\n  already exists in `map`.\n\n  ## Examples\n\n      iex> Map.put_new(%{a: 1}, :b, 2)\n      %{a: 1, b: 2}\n      iex> Map.put_new(%{a: 1, b: 2}, :a, 3)\n      %{a: 1, b: 2}\n\n  "
    },
    put_new_lazy = {
      description = "put_new_lazy(map, key, (() -> value)) :: map\nput_new_lazy(map, key, fun) when is_function(fun, 0)\n\n  Evaluates `fun` and puts the result under `key`\n  in `map` unless `key` is already present.\n\n  This function is useful in case you want to compute the value to put under\n  `key` only if `key` is not already present (e.g., the value is expensive to\n  calculate or generally difficult to setup and teardown again).\n\n  ## Examples\n\n      iex> map = %{a: 1}\n      iex> fun = fn ->\n      ...>   # some expensive operation here\n      ...>   3\n      ...> end\n      iex> Map.put_new_lazy(map, :a, fun)\n      %{a: 1}\n      iex> Map.put_new_lazy(map, :b, fun)\n      %{a: 1, b: 3}\n\n  "
    },
    size = {
      description = "size(map)\nfalse"
    },
    split = {
      description = "split(non_map, _keys)\nsplit(map, keys) when is_map(map)\nsplit(map, Enumerable.t) :: {map, map}\nsplit(map, keys)\n\n  Takes all entries corresponding to the given `keys` in `map` and extracts\n  them into a separate map.\n\n  Returns a tuple with the new map and the old map with removed keys.\n\n  Keys for which there are no entries in `map` are ignored.\n\n  ## Examples\n\n      iex> Map.split(%{a: 1, b: 2, c: 3}, [:a, :c, :e])\n      {%{a: 1, c: 3}, %{b: 2}}\n\n  "
    },
    take = {
      description = "take(non_map, _keys)\ntake(map, keys) when is_map(map)\ntake(map, Enumerable.t) :: map\ntake(map, keys)\n\n  Returns a new map with all the key-value pairs in `map` where the key\n  is in `keys`.\n\n  If `keys` contains keys that are not in `map`, they're simply ignored.\n\n  ## Examples\n\n      iex> Map.take(%{a: 1, b: 2, c: 3}, [:a, :c, :e])\n      %{a: 1, c: 3}\n\n  "
    },
    update = {
      description = "update(map, key, value, (value -> value)) :: map\nupdate(map, key, initial, fun) when is_function(fun, 1)\n\n  Updates the `key` in `map` with the given function.\n\n  If `key` is present in `map` with value `value`, `fun` is invoked with\n  argument `value` and its result is used as the new value of `key`. If `key` is\n  not present in `map`, `initial` is inserted as the value of `key`.\n\n  ## Examples\n\n      iex> Map.update(%{a: 1}, :a, 13, &(&1 * 2))\n      %{a: 2}\n      iex> Map.update(%{a: 1}, :b, 11, &(&1 * 2))\n      %{a: 1, b: 11}\n\n  "
    },
    ["update!"] = {
      description = "update!(map, _key, _fun)\nupdate!(map, key, (value -> value)) :: map | no_return\nupdate!(%{} = map, key, fun) when is_function(fun, 1)\n\n  Updates `key` with the given function.\n\n  If `key` is present in `map` with value `value`, `fun` is invoked with\n  argument `value` and its result is used as the new value of `key`. If `key` is\n  not present in `map`, a `KeyError` exception is raised.\n\n  ## Examples\n\n      iex> Map.update!(%{a: 1}, :a, &(&1 * 2))\n      %{a: 2}\n\n      iex> Map.update!(%{a: 1}, :b, &(&1 * 2))\n      ** (KeyError) key :b not found in: %{a: 1}\n\n  "
    },
    value = {
      description = "value :: any\n"
    }
  },
  MapSet = {
    count = {
      description = "count(map_set)\n\n  Returns a set containing all members of `map_set1` and `map_set2`.\n\n  ## Examples\n\n      iex> MapSet.union(MapSet.new([1, 2]), MapSet.new([2, 3, 4]))\n      #MapSet<[1, 2, 3, 4]>\n\n  "
    },
    delete = {
      description = "delete(t(val1), val2) :: t(val1) when val1: value, val2: value\ndelete(%MapSet{map: map} = map_set, value)\n\n  Deletes `value` from `map_set`.\n\n  Returns a new set which is a copy of `map_set` but without `value`.\n\n  ## Examples\n\n      iex> map_set = MapSet.new([1, 2, 3])\n      iex> MapSet.delete(map_set, 4)\n      #MapSet<[1, 2, 3]>\n      iex> MapSet.delete(map_set, 2)\n      #MapSet<[1, 3]>\n\n  "
    },
    description = "\n  Functions that work on sets.\n\n  `MapSet` is the \"go to\" set data structure in Elixir. A set can be constructed\n  using `MapSet.new/0`:\n\n      iex> MapSet.new\n      #MapSet<[]>\n\n  A set can contain any kind of elements, and elements in a set don't have to be\n  of the same type. By definition, sets can't contain duplicate elements: when\n  inserting an element in a set where it's already present, the insertion is\n  simply a no-op.\n\n      iex> map_set = MapSet.new\n      iex> MapSet.put(map_set, \"foo\")\n      #MapSet<[\"foo\"]>\n      iex> map_set |> MapSet.put(\"foo\") |> MapSet.put(\"foo\")\n      #MapSet<[\"foo\"]>\n\n  A `MapSet` is represented internally using the `%MapSet{}` struct. This struct\n  can be used whenever there's a need to pattern match on something being a `MapSet`:\n\n      iex> match?(%MapSet{}, MapSet.new())\n      true\n\n  Note that, however, the struct fields are private and must not be accessed\n  directly; use the functions in this module to perform operations on sets.\n\n  `MapSet`s can also be constructed starting from other collection-type data\n  structures: for example, see `MapSet.new/1` or `Enum.into/2`.\n  ",
    difference = {
      description = "difference(%MapSet{map: map1}, %MapSet{map: map2})\ndifference(%MapSet{map: map1}, %MapSet{map: map2})\ndifference(t(val1), t(val2)) :: t(val1) when val1: value, val2: value\ndifference(map_set1, map_set2)\n\n  Returns a set that is `map_set1` without the members of `map_set2`.\n\n  ## Examples\n\n      iex> MapSet.difference(MapSet.new([1, 2]), MapSet.new([2, 3, 4]))\n      #MapSet<[1]>\n\n  "
    },
    ["disjoint?"] = {
      description = "disjoint?(t, t) :: boolean\ndisjoint?(%MapSet{map: map1}, %MapSet{map: map2})\n\n  Checks if `map_set1` and `map_set2` have no members in common.\n\n  ## Examples\n\n      iex> MapSet.disjoint?(MapSet.new([1, 2]), MapSet.new([3, 4]))\n      true\n      iex> MapSet.disjoint?(MapSet.new([1, 2]), MapSet.new([2, 3]))\n      false\n\n  "
    },
    ["equal?"] = {
      description = "equal?(t, t) :: boolean\nequal?(%MapSet{map: map1}, %MapSet{map: map2})\n\n  Checks if two sets are equal.\n\n  The comparison between elements must be done using `===`.\n\n  ## Examples\n\n      iex> MapSet.equal?(MapSet.new([1, 2]), MapSet.new([2, 1, 1]))\n      true\n      iex> MapSet.equal?(MapSet.new([1, 2]), MapSet.new([3, 4]))\n      false\n\n  "
    },
    inspect = {
      description = "inspect(map_set, opts)\n\n  Returns a set containing all members of `map_set1` and `map_set2`.\n\n  ## Examples\n\n      iex> MapSet.union(MapSet.new([1, 2]), MapSet.new([2, 3, 4]))\n      #MapSet<[1, 2, 3, 4]>\n\n  "
    },
    intersection = {
      description = "intersection(t(val), t(val)) :: t(val) when val: value\nintersection(%MapSet{map: map1}, %MapSet{map: map2})\n\n  Returns a set containing only members that `map_set1` and `map_set2` have in common.\n\n  ## Examples\n\n      iex> MapSet.intersection(MapSet.new([1, 2]), MapSet.new([2, 3, 4]))\n      #MapSet<[2]>\n\n      iex> MapSet.intersection(MapSet.new([1, 2]), MapSet.new([3, 4]))\n      #MapSet<[]>\n\n  "
    },
    into = {
      description = "into(original)\n\n  Returns a set containing all members of `map_set1` and `map_set2`.\n\n  ## Examples\n\n      iex> MapSet.union(MapSet.new([1, 2]), MapSet.new([2, 3, 4]))\n      #MapSet<[1, 2, 3, 4]>\n\n  "
    },
    ["member?"] = {
      description = "member?(map_set, val)\nmember?(t, value) :: boolean\nmember?(%MapSet{map: map}, value)\n\n  Checks if `map_set` contains `value`.\n\n  ## Examples\n\n      iex> MapSet.member?(MapSet.new([1, 2, 3]), 2)\n      true\n      iex> MapSet.member?(MapSet.new([1, 2, 3]), 4)\n      false\n\n  "
    },
    new = {
      description = "new(Enum.t, (term -> val)) :: t(val) when val: value\nnew(enumerable, transform) when is_function(transform, 1)\nnew(enumerable)\nnew(%__MODULE__{} = map_set)\nnew(Enum.t) :: t\nnew(enumerable)\nnew :: t\nnew()\n\n  Returns a new set.\n\n  ## Examples\n\n      iex> MapSet.new\n      #MapSet<[]>\n\n  "
    },
    put = {
      description = "put(t(val), new_val) :: t(val | new_val) when val: value, new_val: value\nput(%MapSet{map: map} = map_set, value)\n\n  Inserts `value` into `map_set` if `map_set` doesn't already contain it.\n\n  ## Examples\n\n      iex> MapSet.put(MapSet.new([1, 2, 3]), 3)\n      #MapSet<[1, 2, 3]>\n      iex> MapSet.put(MapSet.new([1, 2, 3]), 4)\n      #MapSet<[1, 2, 3, 4]>\n\n  "
    },
    reduce = {
      description = "reduce(map_set, acc, fun)\n\n  Returns a set containing all members of `map_set1` and `map_set2`.\n\n  ## Examples\n\n      iex> MapSet.union(MapSet.new([1, 2]), MapSet.new([2, 3, 4]))\n      #MapSet<[1, 2, 3, 4]>\n\n  "
    },
    size = {
      description = "size(t) :: non_neg_integer\nsize(%MapSet{map: map})\n\n  Returns the number of elements in `map_set`.\n\n  ## Examples\n\n      iex> MapSet.size(MapSet.new([1, 2, 3]))\n      3\n\n  "
    },
    ["subset?"] = {
      description = "subset?(t, t) :: boolean\nsubset?(%MapSet{map: map1}, %MapSet{map: map2})\n\n  Checks if `map_set1`'s members are all contained in `map_set2`.\n\n  This function checks if `map_set1` is a subset of `map_set2`.\n\n  ## Examples\n\n      iex> MapSet.subset?(MapSet.new([1, 2]), MapSet.new([1, 2, 3]))\n      true\n      iex> MapSet.subset?(MapSet.new([1, 2, 3]), MapSet.new([1, 2]))\n      false\n\n  "
    },
    t = {
      description = "t :: t(term)\n"
    },
    to_list = {
      description = "to_list(t(val)) :: [val] when val: value\nto_list(%MapSet{map: map})\n\n  Converts `map_set` to a list.\n\n  ## Examples\n\n      iex> MapSet.to_list(MapSet.new([1, 2, 3]))\n      [1, 2, 3]\n\n  "
    },
    union = {
      description = "union(t(val1), t(val2)) :: t(val1 | val2) when val1: value, val2: value\nunion(%MapSet{map: map1}, %MapSet{map: map2})\n\n  Returns a set containing all members of `map_set1` and `map_set2`.\n\n  ## Examples\n\n      iex> MapSet.union(MapSet.new([1, 2]), MapSet.new([2, 3, 4]))\n      #MapSet<[1, 2, 3, 4]>\n\n  "
    },
    value = {
      description = "value :: term\n"
    }
  },
  MatchError = {
    message = {
      description = "message(exception)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    }
  },
  Module = {
    LocalsTracker = {
      add_defaults = {
        description = "add_defaults(pid, kind, tuple, defaults) when kind in [:def, :defp, :defmacro, :defmacrop]\nfalse"
      },
      add_definition = {
        description = "add_definition(pid, kind, tuple) when kind in [:def, :defp, :defmacro, :defmacrop]\nfalse"
      },
      add_import = {
        description = "add_import(pid, function, module, target) when is_atom(module) and is_tuple(target)\nfalse"
      },
      add_local = {
        description = "add_local(pid, from, to) when is_tuple(from) and is_tuple(to)\nadd_local(pid, to) when is_tuple(to)\nfalse"
      },
      cache_env = {
        description = "cache_env(pid, env)\nfalse"
      },
      code_change = {
        description = "code_change(_old, state, _extra)\nfalse"
      },
      collect_imports_conflicts = {
        description = "collect_imports_conflicts(pid, all_defined)\nfalse"
      },
      collect_unused_locals = {
        description = "collect_unused_locals(ref, private)\nfalse"
      },
      description = "false",
      get_cached_env = {
        description = "get_cached_env(pid, ref)\nfalse"
      },
      handle_call = {
        description = "handle_call(:digraph, _from, {d, _} = state)\nhandle_call({:yank, local}, _from, {d, _} = state)\nhandle_call({:get_cached_env, ref}, _from, {_, cache} = state)\nhandle_call({:cache_env, env}, _from, {d, cache})\nfalse"
      },
      handle_cast = {
        description = "handle_cast(:stop, state)\nhandle_cast({:reattach, _kind, tuple, {in_neigh, out_neigh}}, {d, _} = state)\nhandle_cast({:add_defaults, kind, {name, arity}, defaults}, {d, _} = state)\nhandle_cast({:add_definition, kind, tuple}, {d, _} = state)\nhandle_cast({:add_import, function, module, {name, arity}}, {d, _} = state)\nhandle_cast({:add_local, from, to}, {d, _} = state)\nfalse"
      },
      handle_info = {
        description = "handle_info(_msg, state)\nfalse"
      },
      import = {
        description = "import :: {:import, name, arity}\n"
      },
      imports_with_dispatch = {
        description = "imports_with_dispatch(ref, name_arity) :: [module]\nimports_with_dispatch(ref, {name, arity})\n\n  Returns all imported modules that had the given\n  `{name, arity}` invoked.\n  "
      },
      init = {
        description = "init([])\nfalse"
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
      reachable = {
        description = "reachable(ref) :: [local]\nreachable(ref)\n\n  Returns all locals that are reachable.\n\n  By default, all public functions are reachable.\n  A private function is only reachable if it has\n  a public function that it invokes directly.\n  "
      },
      reattach = {
        description = "reattach(pid, kind, tuple, neighbours)\nfalse"
      },
      ref = {
        description = "ref :: pid | module\n"
      },
      start_link = {
        description = "start_link\nfalse"
      },
      stop = {
        description = "stop(pid)\nfalse"
      },
      terminate = {
        description = "terminate(_reason, _state)\nfalse"
      },
      yank = {
        description = "yank(pid, local)\nfalse"
      }
    }
  },
  NaiveDateTime = {
    add = {
      description = "add(t, integer, System.time_unit) :: t\nadd(%NaiveDateTime{microsecond: {_microsecond, precision}} = naive_datetime,\n\n  Adds a specified amount of time to a `NaiveDateTime`.\n\n  Accepts an `integer` in any `unit` available from `t:System.time_unit/0`.\n  Negative values will be move backwards in time.\n\n  ## Examples\n\n      # adds seconds by default\n      iex> NaiveDateTime.add(~N[2014-10-02 00:29:10], 2)\n      ~N[2014-10-02 00:29:12]\n      # accepts negative offsets\n      iex> NaiveDateTime.add(~N[2014-10-02 00:29:10], -2)\n      ~N[2014-10-02 00:29:08]\n      # can work with other units\n      iex> NaiveDateTime.add(~N[2014-10-02 00:29:10], 2_000, :millisecond)\n      ~N[2014-10-02 00:29:12]\n      # keeps the same precision\n      iex> NaiveDateTime.add(~N[2014-10-02 00:29:10.021], 21, :second)\n      ~N[2014-10-02 00:29:31.021]\n      # changes below the precision will not be visible\n      iex> hidden = NaiveDateTime.add(~N[2014-10-02 00:29:10], 21, :millisecond)\n      iex> hidden.microsecond  # ~N[2014-10-02 00:29:10]\n      {21000, 0}\n      # from gregorian seconds\n      iex> NaiveDateTime.add(~N[0000-01-01 00:00:00], 63579428950)\n      ~N[2014-10-02 00:29:10]\n  "
    },
    compare = {
      description = "compare(Calendar.naive_datetime, Calendar.naive_datetime) :: :lt | :eq | :gt\ncompare(naive_datetime1, naive_datetime2)\n\n  Compares two `NaiveDateTime` structs.\n\n  Returns `:gt` if first is later than the second\n  and `:lt` for vice versa. If the two NaiveDateTime\n  are equal `:eq` is returned\n\n  ## Examples\n\n      iex> NaiveDateTime.compare(~N[2016-04-16 13:30:15], ~N[2016-04-28 16:19:25])\n      :lt\n      iex> NaiveDateTime.compare(~N[2016-04-16 13:30:15.1], ~N[2016-04-16 13:30:15.01])\n      :gt\n\n  This function can also be used to compare a DateTime without\n  the time zone information:\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> NaiveDateTime.compare(dt, ~N[2000-02-29 23:00:07])\n      :eq\n      iex> NaiveDateTime.compare(dt, ~N[2000-01-29 23:00:07])\n      :gt\n      iex> NaiveDateTime.compare(dt, ~N[2000-03-29 23:00:07])\n      :lt\n\n  "
    },
    description = "\n  A NaiveDateTime struct (without a time zone) and functions.\n\n  The NaiveDateTime struct contains the fields year, month, day, hour,\n  minute, second, microsecond and calendar. New naive datetimes can be\n  built with the `new/7` function or using the `~N` sigil:\n\n      iex> ~N[2000-01-01 23:00:07]\n      ~N[2000-01-01 23:00:07]\n\n  Both `new/7` and sigil return a struct where the date fields can\n  be accessed directly:\n\n      iex> naive = ~N[2000-01-01 23:00:07]\n      iex> naive.year\n      2000\n      iex> naive.second\n      7\n\n  The naive bit implies this datetime representation does\n  not have a time zone. This means the datetime may not\n  actually exist in certain areas in the world even though\n  it is valid.\n\n  For example, when daylight saving changes are applied\n  by a region, the clock typically moves forward or backward\n  by one hour. This means certain datetimes never occur or\n  may occur more than once. Since `NaiveDateTime` is not\n  validated against a time zone, such errors would go unnoticed.\n\n  Remember, comparisons in Elixir using `==`, `>`, `<` and friends\n  are structural and based on the NaiveDateTime struct fields. For\n  proper comparison between naive datetimes, use the `compare/2`\n  function.\n\n  Developers should avoid creating the NaiveDateTime struct directly\n  and instead rely on the functions provided by this module as well\n  as the ones in 3rd party calendar libraries.\n  ",
    diff = {
      description = "diff(t, t, System.time_unit) :: integer\ndiff(%NaiveDateTime{} = naive_datetime1,\n\n  Subtracts `naive_datetime2` from `naive_datetime1`.\n\n  The answer can be returned in any `unit` available from `t:System.time_unit/0`.\n\n  ## Examples\n\n      iex> NaiveDateTime.diff(~N[2014-10-02 00:29:12], ~N[2014-10-02 00:29:10])\n      2\n      iex> NaiveDateTime.diff(~N[2014-10-02 00:29:12], ~N[2014-10-02 00:29:10], :microsecond)\n      2_000_000\n      iex> NaiveDateTime.diff(~N[2014-10-02 00:29:10.042], ~N[2014-10-02 00:29:10.021], :millisecond)\n      21\n      # to gregorian seconds\n      iex> NaiveDateTime.diff(~N[2014-10-02 00:29:10], ~N[0000-01-01 00:00:00])\n      63579428950\n  "
    },
    from_erl = {
      description = "from_erl({{year, month, day}, {hour, minute, second}}, microsecond)\nfrom_erl(:calendar.datetime, Calendar.microsecond) :: {:ok, t} | {:error, atom}\nfrom_erl(tuple, microsecond \\\\ {0, 0})\n\n  Converts an Erlang datetime tuple to a `NaiveDateTime` struct.\n\n  Attempting to convert an invalid ISO calendar date will produce an error tuple.\n\n  ## Examples\n\n      iex> NaiveDateTime.from_erl({{2000, 1, 1}, {13, 30, 15}})\n      {:ok, ~N[2000-01-01 13:30:15]}\n      iex> NaiveDateTime.from_erl({{2000, 1, 1}, {13, 30, 15}}, {5000, 3})\n      {:ok, ~N[2000-01-01 13:30:15.005]}\n      iex> NaiveDateTime.from_erl({{2000, 13, 1}, {13, 30, 15}})\n      {:error, :invalid_date}\n      iex> NaiveDateTime.from_erl({{2000, 13, 1},{13, 30, 15}})\n      {:error, :invalid_date}\n  "
    },
    ["from_erl!"] = {
      description = "from_erl!(:calendar.datetime, Calendar.microsecond) :: t | no_return\nfrom_erl!(tuple, microsecond \\\\ {0, 0})\n\n  Converts an Erlang datetime tuple to a `NaiveDateTime` struct.\n\n  Raises if the datetime is invalid.\n  Attempting to convert an invalid ISO calendar date will produce an error tuple.\n\n  ## Examples\n\n      iex> NaiveDateTime.from_erl!({{2000, 1, 1}, {13, 30, 15}})\n      ~N[2000-01-01 13:30:15]\n      iex> NaiveDateTime.from_erl!({{2000, 1, 1}, {13, 30, 15}}, {5000, 3})\n      ~N[2000-01-01 13:30:15.005]\n      iex> NaiveDateTime.from_erl!({{2000, 13, 1}, {13, 30, 15}})\n      ** (ArgumentError) cannot convert {{2000, 13, 1}, {13, 30, 15}} to naive datetime, reason: :invalid_date\n  "
    },
    from_iso8601 = {
      description = "from_iso8601(<<_::binary>>)\nfrom_iso8601(<<year::4-bytes, ?-, month::2-bytes, ?-, day::2-bytes, sep,\nfrom_iso8601(String.t) :: {:ok, t} | {:error, atom}\nfrom_iso8601(string)\n\n  Parses the extended \"Date and time of day\" format described by\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  Timezone offset may be included in the string but they will be\n  simply discarded as such information is not included in naive date\n  times.\n\n  As specified in the standard, the separator \"T\" may be omitted if\n  desired as there is no ambiguity within this function.\n\n  Time representations with reduced accuracy are not supported.\n\n  ## Examples\n\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23 23:50:07\")\n      {:ok, ~N[2015-01-23 23:50:07]}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07\")\n      {:ok, ~N[2015-01-23 23:50:07]}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07Z\")\n      {:ok, ~N[2015-01-23 23:50:07]}\n\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23 23:50:07.0\")\n      {:ok, ~N[2015-01-23 23:50:07.0]}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23 23:50:07.0123456\")\n      {:ok, ~N[2015-01-23 23:50:07.012345]}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07.123Z\")\n      {:ok, ~N[2015-01-23 23:50:07.123]}\n\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23P23:50:07\")\n      {:error, :invalid_format}\n      iex> NaiveDateTime.from_iso8601(\"2015:01:23 23-50-07\")\n      {:error, :invalid_format}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23 23:50:07A\")\n      {:error, :invalid_format}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23 23:50:61\")\n      {:error, :invalid_time}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-32 23:50:07\")\n      {:error, :invalid_date}\n\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07.123+02:30\")\n      {:ok, ~N[2015-01-23 23:50:07.123]}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07.123+00:00\")\n      {:ok, ~N[2015-01-23 23:50:07.123]}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07.123-02:30\")\n      {:ok, ~N[2015-01-23 23:50:07.123]}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07.123-00:00\")\n      {:error, :invalid_format}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07.123-00:60\")\n      {:error, :invalid_format}\n      iex> NaiveDateTime.from_iso8601(\"2015-01-23T23:50:07.123-24:00\")\n      {:error, :invalid_format}\n\n  "
    },
    ["from_iso8601!"] = {
      description = "from_iso8601!(String.t) :: t | no_return\nfrom_iso8601!(string)\n\n  Parses the extended \"Date and time of day\" format described by\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  Raises if the format is invalid.\n\n  ## Examples\n\n      iex> NaiveDateTime.from_iso8601!(\"2015-01-23T23:50:07.123Z\")\n      ~N[2015-01-23 23:50:07.123]\n      iex> NaiveDateTime.from_iso8601!(\"2015-01-23P23:50:07\")\n      ** (ArgumentError) cannot parse \"2015-01-23P23:50:07\" as naive datetime, reason: :invalid_format\n\n  "
    },
    inspect = {
      description = "inspect(naive, opts)\ninspect(%{calendar: Calendar.ISO, year: year, month: month, day: day,\n\n  Compares two `NaiveDateTime` structs.\n\n  Returns `:gt` if first is later than the second\n  and `:lt` for vice versa. If the two NaiveDateTime\n  are equal `:eq` is returned\n\n  ## Examples\n\n      iex> NaiveDateTime.compare(~N[2016-04-16 13:30:15], ~N[2016-04-28 16:19:25])\n      :lt\n      iex> NaiveDateTime.compare(~N[2016-04-16 13:30:15.1], ~N[2016-04-16 13:30:15.01])\n      :gt\n\n  This function can also be used to compare a DateTime without\n  the time zone information:\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> NaiveDateTime.compare(dt, ~N[2000-02-29 23:00:07])\n      :eq\n      iex> NaiveDateTime.compare(dt, ~N[2000-01-29 23:00:07])\n      :gt\n      iex> NaiveDateTime.compare(dt, ~N[2000-03-29 23:00:07])\n      :lt\n\n  "
    },
    new = {
      description = "new(%Date{calendar: calendar, year: year, month: month, day: day},\nnew(Date.t, Time.t) :: {:ok, t}\nnew(date, time)\nnew(Calendar.year, Calendar.month, Calendar.day,\nnew(year, month, day, hour, minute, second, microsecond \\\\ {0, 0})\n\n  Builds a new ISO naive datetime.\n\n  Expects all values to be integers. Returns `{:ok, naive_datetime}`\n  if each entry fits its appropriate range, returns `{:error, reason}`\n  otherwise.\n\n  ## Examples\n\n      iex> NaiveDateTime.new(2000, 1, 1, 0, 0, 0)\n      {:ok, ~N[2000-01-01 00:00:00]}\n      iex> NaiveDateTime.new(2000, 13, 1, 0, 0, 0)\n      {:error, :invalid_date}\n      iex> NaiveDateTime.new(2000, 2, 29, 0, 0, 0)\n      {:ok, ~N[2000-02-29 00:00:00]}\n      iex> NaiveDateTime.new(2000, 2, 30, 0, 0, 0)\n      {:error, :invalid_date}\n      iex> NaiveDateTime.new(2001, 2, 29, 0, 0, 0)\n      {:error, :invalid_date}\n\n      iex> NaiveDateTime.new(2000, 1, 1, 23, 59, 59, {0, 1})\n      {:ok, ~N[2000-01-01 23:59:59.0]}\n      iex> NaiveDateTime.new(2000, 1, 1, 23, 59, 59, 999_999)\n      {:ok, ~N[2000-01-01 23:59:59.999999]}\n      iex> NaiveDateTime.new(2000, 1, 1, 23, 59, 60, 999_999)\n      {:ok, ~N[2000-01-01 23:59:60.999999]}\n      iex> NaiveDateTime.new(2000, 1, 1, 24, 59, 59, 999_999)\n      {:error, :invalid_time}\n      iex> NaiveDateTime.new(2000, 1, 1, 23, 60, 59, 999_999)\n      {:error, :invalid_time}\n      iex> NaiveDateTime.new(2000, 1, 1, 23, 59, 61, 999_999)\n      {:error, :invalid_time}\n      iex> NaiveDateTime.new(2000, 1, 1, 23, 59, 59, 1_000_000)\n      {:error, :invalid_time}\n\n  "
    },
    t = {
      description = "t :: %NaiveDateTime{year: Calendar.year, month: Calendar.month, day: Calendar.day,\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    to_date = {
      description = "to_date(t) :: Date.t\nto_date(%NaiveDateTime{year: year, month: month, day: day, calendar: calendar})\n\n  Converts a `NaiveDateTime` into a `Date`.\n\n  Because `Date` does not hold time information,\n  data will be lost during the conversion.\n\n  ## Examples\n\n      iex> NaiveDateTime.to_date(~N[2002-01-13 23:00:07])\n      ~D[2002-01-13]\n\n  "
    },
    to_erl = {
      description = "to_erl(%{calendar: Calendar.ISO, year: year, month: month, day: day,\nto_erl(t) :: :calendar.datetime\nto_erl(naive_datetime)\n\n  Converts a `NaiveDateTime` struct to an Erlang datetime tuple.\n\n  Only supports converting naive datetimes which are in the ISO calendar,\n  attempting to convert naive datetimes from other calendars will raise.\n\n  WARNING: Loss of precision may occur, as Erlang time tuples only store\n  hour/minute/second.\n\n  ## Examples\n\n      iex> NaiveDateTime.to_erl(~N[2000-01-01 13:30:15])\n      {{2000, 1, 1}, {13, 30, 15}}\n\n  This function can also be used to convert a DateTime to a erl format\n  without the time zone information:\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> NaiveDateTime.to_erl(dt)\n      {{2000, 2, 29}, {23, 00, 07}}\n\n  "
    },
    to_iso8601 = {
      description = "to_iso8601(%{year: year, month: month, day: day,\nto_iso8601(Calendar.naive_datetime) :: String.t\nto_iso8601(naive_datetime)\n\n  Converts the given naive datetime to\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  Only supports converting naive datetimes which are in the ISO calendar,\n  attempting to convert naive datetimes from other calendars will raise.\n\n  ### Examples\n\n      iex> NaiveDateTime.to_iso8601(~N[2000-02-28 23:00:13])\n      \"2000-02-28T23:00:13\"\n\n      iex> NaiveDateTime.to_iso8601(~N[2000-02-28 23:00:13.001])\n      \"2000-02-28T23:00:13.001\"\n\n  This function can also be used to convert a DateTime to ISO8601 without\n  the time zone information:\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> NaiveDateTime.to_iso8601(dt)\n      \"2000-02-29T23:00:07\"\n\n  "
    },
    to_string = {
      description = "to_string(%{calendar: calendar, year: year, month: month, day: day,\nto_string(%{calendar: calendar, year: year, month: month, day: day,\nto_string(Calendar.naive_datetime) :: String.t\nto_string(naive_datetime)\n\n  Converts the given naive datetime to a string according to its calendar.\n\n  ### Examples\n\n      iex> NaiveDateTime.to_string(~N[2000-02-28 23:00:13])\n      \"2000-02-28 23:00:13\"\n      iex> NaiveDateTime.to_string(~N[2000-02-28 23:00:13.001])\n      \"2000-02-28 23:00:13.001\"\n\n  This function can also be used to convert a DateTime to a string without\n  the time zone information:\n\n      iex> dt = %DateTime{year: 2000, month: 2, day: 29, zone_abbr: \"CET\",\n      ...>                hour: 23, minute: 0, second: 7, microsecond: {0, 0},\n      ...>                utc_offset: 3600, std_offset: 0, time_zone: \"Europe/Warsaw\"}\n      iex> NaiveDateTime.to_string(dt)\n      \"2000-02-29 23:00:07\"\n\n  "
    },
    to_time = {
      description = "to_time(t) :: Time.t\nto_time(%NaiveDateTime{hour: hour, minute: minute, second: second, microsecond: microsecond})\n\n  Converts a `NaiveDateTime` into `Time`.\n\n  Because `Time` does not hold date information,\n  data will be lost during the conversion.\n\n  ## Examples\n\n      iex> NaiveDateTime.to_time(~N[2002-01-13 23:00:07])\n      ~T[23:00:07]\n\n  "
    },
    utc_now = {
      description = "utc_now() :: t\nutc_now()\n\n  Returns the current naive datetime in UTC.\n\n  Prefer using `DateTime.utc_now/0` when possible as, opposite\n  to `NaiveDateTime`, it will keep the time zone information.\n\n  ## Examples\n\n      iex> naive_datetime = NaiveDateTime.utc_now()\n      iex> naive_datetime.year >= 2016\n      true\n\n  "
    }
  },
  Node = {
    ["alive?"] = {
      description = "alive? :: boolean\nalive?\n\n  Returns `true` if the local node is alive.\n\n  That is, if the node can be part of a distributed system.\n  "
    },
    connect = {
      description = "connect(t) :: boolean | :ignored\nconnect(node)\n\n  Establishes a connection to `node`.\n\n  Returns `true` if successful, `false` if not, and the atom\n  `:ignored` if the local node is not alive.\n\n  For more information, see\n  [`:net_kernel.connect_node/1`](http://www.erlang.org/doc/man/net_kernel.html#connect_node-1).\n  "
    },
    description = "\n  Functions related to VM nodes.\n\n  Some of the functions in this module are inlined by the compiler,\n  similar to functions in the `Kernel` module and they are explicitly\n  marked in their docs as \"inlined by the compiler\". For more information\n  about inlined functions, check out the `Kernel` module.\n  ",
    disconnect = {
      description = "disconnect(t) :: boolean | :ignored\ndisconnect(node)\n\n  Forces the disconnection of a node.\n\n  This will appear to the `node` as if the local node has crashed.\n  This function is mainly used in the Erlang network authentication\n  protocols. Returns `true` if disconnection succeeds, otherwise `false`.\n  If the local node is not alive, the function returns `:ignored`.\n\n  For more information, see\n  [`:erlang.disconnect_node/1`](http://www.erlang.org/doc/man/erlang.html#disconnect_node-1).\n  "
    },
    get_cookie = {
      description = "get_cookie()\n\n  Returns the magic cookie of the local node.\n\n  Returns the cookie if the node is alive, otherwise `:nocookie`.\n  "
    },
    list = {
      description = "list(state | [state]) :: [t]\nlist(args)\nlist :: [t]\nlist\n\n  Returns a list of all visible nodes in the system, excluding\n  the local node.\n\n  Same as `list(:visible)`.\n  "
    },
    monitor = {
      description = "monitor(t, boolean, [:allow_passive_connect]) :: true\nmonitor(node, flag, options)\nmonitor(t, boolean) :: true\nmonitor(node, flag)\n\n  Monitors the status of the node.\n\n  If `flag` is `true`, monitoring is turned on.\n  If `flag` is `false`, monitoring is turned off.\n\n  For more information, see\n  [`:erlang.monitor_node/2`](http://www.erlang.org/doc/man/erlang.html#monitor_node-2).\n  "
    },
    ping = {
      description = "ping(t) :: :pong | :pang\nping(node)\n\n  Tries to set up a connection to node.\n\n  Returns `:pang` if it fails, or `:pong` if it is successful.\n\n  ## Examples\n\n      iex> Node.ping(:unknown_node)\n      :pang\n\n  "
    },
    self = {
      description = "self :: t\nself\n\n  Returns the current node.\n\n  It returns the same as the built-in `node()`.\n  "
    },
    set_cookie = {
      description = "set_cookie(node \\\\ Node.self, cookie) when is_atom(cookie)\n\n  Sets the magic cookie of `node` to the atom `cookie`.\n\n  The default node is `Node.self/0`, the local node. If `node` is the local node,\n  the function also sets the cookie of all other unknown nodes to `cookie`.\n\n  This function will raise `FunctionClauseError` if the given `node` is not alive.\n  "
    },
    spawn = {
      description = "spawn(t, module, atom, [any], Process.spawn_opts) :: pid | {pid, reference}\nspawn(node, module, fun, args, opts)\nspawn(t, module, atom, [any]) :: pid\nspawn(node, module, fun, args)\nspawn(t, (() -> any), Process.spawn_opts) :: pid | {pid, reference}\nspawn(node, fun, opts)\nspawn(t, (() -> any)) :: pid\nspawn(node, fun)\n\n  Returns the PID of a new process started by the application of `fun`\n  on `node`. If `node` does not exist, a useless PID is returned.\n\n  For the list of available options, see\n  [`:erlang.spawn/2`](http://www.erlang.org/doc/man/erlang.html#spawn-2).\n\n  Inlined by the compiler.\n  "
    },
    spawn_link = {
      description = "spawn_link(t, module, atom, [any]) :: pid\nspawn_link(node, module, fun, args)\nspawn_link(t, (() -> any)) :: pid\nspawn_link(node, fun)\n\n  Returns the PID of a new linked process started by the application of `fun` on `node`.\n\n  A link is created between the calling process and the new process, atomically.\n  If `node` does not exist, a useless PID is returned (and due to the link, an exit\n  signal with exit reason `:noconnection` will be received).\n\n  Inlined by the compiler.\n  "
    },
    start = {
      description = "start(node, :longnames | :shortnames, non_neg_integer) ::\nstart(name, type \\\\ :longnames, tick_time \\\\ 15000)\n\n  Turns a non-distributed node into a distributed node.\n\n  This functionality starts the `:net_kernel` and other\n  related processes.\n  "
    },
    stop = {
      description = "stop() :: :ok | {:error, :not_allowed | :not_found}\nstop()\n\n  Turns a distributed node into a non-distributed node.\n\n  For other nodes in the network, this is the same as the node going down.\n  Only possible when the node was started with `Node.start/3`, otherwise\n  returns `{:error, :not_allowed}`. Returns `{:error, :not_found}` if the\n  local node is not alive.\n  "
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
      description = "get_option_key(option, allow_nonexistent_atoms?)\n\n  Splits a string into `t:argv/0` chunks.\n\n  This function splits the given `string` into a list of strings in a similar\n  way to many shells.\n\n  ## Examples\n\n      iex> OptionParser.split(\"foo bar\")\n      [\"foo\", \"bar\"]\n\n      iex> OptionParser.split(\"foo \\\"bar baz\\\"\")\n      [\"foo\", \"bar baz\"]\n\n  "
    },
    next = {
      description = "next(argv, options) ::\nnext(argv, opts \\\\ []) when is_list(argv) and is_list(opts)\n\n  Low-level function that parses one option.\n\n  It accepts the same options as `parse/2` and `parse_head/2`\n  as both functions are built on top of this function. This function\n  may return:\n\n    * `{:ok, key, value, rest}` - the option `key` with `value` was\n      successfully parsed\n\n    * `{:invalid, key, value, rest}` - the option `key` is invalid with `value`\n      (returned when the value cannot be parsed according to the switch type)\n\n    * `{:undefined, key, value, rest}` - the option `key` is undefined\n      (returned in strict mode when the switch is unknown)\n\n    * `{:error, rest}` - there are no switches at the head of the given `argv`\n\n  "
    },
    parse = {
      description = "parse(argv, options) :: {parsed, argv, errors}\nparse(argv, opts \\\\ []) when is_list(argv) and is_list(opts)\n\n  Parses `argv` into a keyword list.\n\n  It returns a three-element tuple with the form `{parsed, args, invalid}`, where:\n\n    * `parsed` is a keyword list of parsed switches with `{switch_name, value}`\n      tuples in it; `switch_name` is the atom representing the switch name while\n      `value` is the value for that switch parsed according to `opts` (see the\n      \"Examples\" section for more information)\n    * `args` is a list of the remaining arguments in `argv` as strings\n    * `invalid` is a list of invalid options as `{option_name, value}` where\n      `option_name` is the raw option and `value` is `nil` if the option wasn't\n      expected or the string value if the value didn't have the expected type for\n      the corresponding option\n\n  Elixir converts switches to underscored atoms, so `--source-path` becomes\n  `:source_path`. This is done to better suit Elixir conventions. However, this\n  means that switches can't contain underscores and switches that do contain\n  underscores are always returned in the list of invalid switches.\n\n  When parsing, it is common to list switches and their expected types:\n\n      iex> OptionParser.parse([\"--debug\"], switches: [debug: :boolean])\n      {[debug: true], [], []}\n\n      iex> OptionParser.parse([\"--source\", \"lib\"], switches: [source: :string])\n      {[source: \"lib\"], [], []}\n\n      iex> OptionParser.parse([\"--source-path\", \"lib\", \"test/enum_test.exs\", \"--verbose\"],\n      ...>                    switches: [source_path: :string, verbose: :boolean])\n      {[source_path: \"lib\", verbose: true], [\"test/enum_test.exs\"], []}\n\n  We will explore the valid switches and operation modes of option parser below.\n\n  ## Options\n\n  The following options are supported:\n\n    * `:switches` or `:strict` - see the \"Switch definitions\" section below\n    * `:allow_nonexistent_atoms` - see the \"Parsing dynamic switches\" section below\n    * `:aliases` - see the \"Aliases\" section below\n\n  ## Switch definitions\n\n  Switches can be specified via one of two options:\n\n    * `:switches` - defines some switches and their types. This function\n      still attempts to parse switches that are not in this list.\n    * `:strict` - defines strict switches. Any switch in `argv` that is not\n      specified in the list is returned in the invalid options list.\n\n  Both these options accept a keyword list of `{name, type}` tuples where `name`\n  is an atom defining the name of the switch and `type` is an atom that\n  specifies the type for the value of this switch (see the \"Types\" section below\n  for the possible types and more information about type casting).\n\n  Note that you should only supply the `:switches` or the`:strict` option.\n  If you supply both, an `ArgumentError` exception will be raised.\n\n  ### Types\n\n  Switches parsed by `OptionParser` may take zero or one arguments.\n\n  The following switches types take no arguments:\n\n    * `:boolean` - sets the value to `true` when given (see also the\n      \"Negation switches\" section below)\n    * `:count` - counts the number of times the switch is given\n\n  The following switches take one argument:\n\n    * `:integer` - parses the value as an integer\n    * `:float` - parses the value as a float\n    * `:string` - parses the value as a string\n\n  If a switch can't be parsed according to the given type, it is\n  returned in the invalid options list.\n\n  ### Modifiers\n\n  Switches can be specified with modifiers, which change how\n  they behave. The following modifiers are supported:\n\n    * `:keep` - keeps duplicated items instead of overriding them;\n      works with all types except `:count`. Specifying `switch_name: :keep`\n      assumes the type of `:switch_name` will be `:string`.\n\n  To use `:keep` with a type other than `:string`, use a list as the type\n  for the switch. For example: `[foo: [:integer, :keep]]`.\n\n  ### Negation switches\n\n  In case a switch `SWITCH` is specified to have type `:boolean`, it may be\n  passed as `--no-SWITCH` as well which will set the option to `false`:\n\n      iex> OptionParser.parse([\"--no-op\", \"path/to/file\"], switches: [op: :boolean])\n      {[op: false], [\"path/to/file\"], []}\n\n  ### Parsing dynamic switches\n\n  `OptionParser` also includes a dynamic mode where it will attempt to parse\n  switches dynamically. Such can be done by not specifying the `:switches` or\n  `:strict` option.\n\n      iex> OptionParser.parse([\"--debug\"])\n      {[debug: true], [], []}\n\n\n  Switches followed by a value will be assigned the value, as a string. Switches\n  without an argument, like `--debug` in the examples above, will automatically be\n  set to `true`.\n\n  Since Elixir converts switches to atoms, the dynamic mode will only parse\n  switches that translates to atoms used by the runtime. Therefore, the code below\n  likely won't parse the given option since the `:option_parser_example` atom is\n  never used anywhere:\n\n      OptionParser.parse([\"--option-parser-example\"])\n      # Does nothing more...\n\n  However, the code below does since the `:option_parser_example` atom is used\n  at some point later (or earlier) on:\n\n      {opts, _, _} = OptionParser.parse([\"--option-parser-example\"])\n      opts[:option_parser_example]\n\n  In other words, when using dynamic mode, Elixir will do the correct thing and\n  only parse options that are used by the runtime, ignoring all others. If you\n  would like to parse all switches, regardless if they exist or not, you can\n  force creation of atoms by passing `allow_nonexistent_atoms: true` as option.\n  Such option is useful when you are building command-line applications that\n  receive dynamically-named arguments but must be used with care on long-running\n  systems.\n\n  Switches followed by a value will be assigned the value, as a string.\n  Switches without an argument, like `--debug` in the examples above, will\n  automatically be set to `true`.\n\n  ## Aliases\n\n  A set of aliases can be specified in the `:aliases` option:\n\n      iex> OptionParser.parse([\"-d\"], aliases: [d: :debug])\n      {[debug: true], [], []}\n\n  ## Examples\n\n  Here are some examples of working with different types and modifiers:\n\n      iex> OptionParser.parse([\"--unlock\", \"path/to/file\"], strict: [unlock: :boolean])\n      {[unlock: true], [\"path/to/file\"], []}\n\n      iex> OptionParser.parse([\"--unlock\", \"--limit\", \"0\", \"path/to/file\"],\n      ...>                    strict: [unlock: :boolean, limit: :integer])\n      {[unlock: true, limit: 0], [\"path/to/file\"], []}\n\n      iex> OptionParser.parse([\"--limit\", \"3\"], strict: [limit: :integer])\n      {[limit: 3], [], []}\n\n      iex> OptionParser.parse([\"--limit\", \"xyz\"], strict: [limit: :integer])\n      {[], [], [{\"--limit\", \"xyz\"}]}\n\n      iex> OptionParser.parse([\"--verbose\"], switches: [verbose: :count])\n      {[verbose: 1], [], []}\n\n      iex> OptionParser.parse([\"-v\", \"-v\"], aliases: [v: :verbose], strict: [verbose: :count])\n      {[verbose: 2], [], []}\n\n      iex> OptionParser.parse([\"--unknown\", \"xyz\"], strict: [])\n      {[], [\"xyz\"], [{\"--unknown\", nil}]}\n\n      iex> OptionParser.parse([\"--limit\", \"3\", \"--unknown\", \"xyz\"],\n      ...>                    switches: [limit: :integer])\n      {[limit: 3, unknown: \"xyz\"], [], []}\n\n      iex> OptionParser.parse([\"--unlock\", \"path/to/file\", \"--unlock\", \"path/to/another/file\"], strict: [unlock: :keep])\n      {[unlock: \"path/to/file\", unlock: \"path/to/another/file\"], [], []}\n\n  "
    },
    ["parse!"] = {
      description = "parse!(argv, options) :: {parsed, argv} | no_return\nparse!(argv, opts \\\\ []) when is_list(argv) and is_list(opts)\n\n  The same as `parse/2` but raises an `OptionParser.ParseError`\n  exception if any invalid options are given.\n\n  If there are no errors, returns a `{parsed, rest}` tuple where:\n\n    * `parsed` is the list of parsed switches (same as in `parse/2`)\n    * `rest` is the list of arguments (same as in `parse/2`)\n\n  ## Examples\n\n      iex> OptionParser.parse!([\"--debug\", \"path/to/file\"], strict: [debug: :boolean])\n      {[debug: true], [\"path/to/file\"]}\n\n      iex> OptionParser.parse!([\"--limit\", \"xyz\"], strict: [limit: :integer])\n      ** (OptionParser.ParseError) 1 error found!\n      --limit : Expected type integer, got \"xyz\"\n\n      iex> OptionParser.parse!([\"--unknown\", \"xyz\"], strict: [])\n      ** (OptionParser.ParseError) 1 error found!\n      --unknown : Unknown option\n\n      iex> OptionParser.parse!([\"-l\", \"xyz\", \"-f\", \"bar\"],\n      ...>                     switches: [limit: :integer, foo: :integer], aliases: [l: :limit, f: :foo])\n      ** (OptionParser.ParseError) 2 errors found!\n      -l : Expected type integer, got \"xyz\"\n      -f : Expected type integer, got \"bar\"\n\n  "
    },
    parse_head = {
      description = "parse_head(argv, options) :: {parsed, argv, errors}\nparse_head(argv, opts \\\\ []) when is_list(argv) and is_list(opts)\n\n  Similar to `parse/2` but only parses the head of `argv`;\n  as soon as it finds a non-switch, it stops parsing.\n\n  See `parse/2` for more information.\n\n  ## Example\n\n      iex> OptionParser.parse_head([\"--source\", \"lib\", \"test/enum_test.exs\", \"--verbose\"],\n      ...>                         switches: [source: :string, verbose: :boolean])\n      {[source: \"lib\"], [\"test/enum_test.exs\", \"--verbose\"], []}\n\n      iex> OptionParser.parse_head([\"--verbose\", \"--source\", \"lib\", \"test/enum_test.exs\", \"--unlock\"],\n      ...>                         switches: [source: :string, verbose: :boolean, unlock: :boolean])\n      {[verbose: true, source: \"lib\"], [\"test/enum_test.exs\", \"--unlock\"], []}\n\n  "
    },
    ["parse_head!"] = {
      description = "parse_head!(argv, options) :: {parsed, argv} | no_return\nparse_head!(argv, opts \\\\ []) when is_list(argv) and is_list(opts)\n\n  The same as `parse_head/2` but raises an `OptionParser.ParseError`\n  exception if any invalid options are given.\n\n  If there are no errors, returns a `{parsed, rest}` tuple where:\n\n    * `parsed` is the list of parsed switches (same as in `parse_head/2`)\n    * `rest` is the list of arguments (same as in `parse_head/2`)\n\n  ## Examples\n\n      iex> OptionParser.parse_head!([\"--source\", \"lib\", \"path/to/file\", \"--verbose\"],\n      ...>                         switches: [source: :string, verbose: :boolean])\n      {[source: \"lib\"], [\"path/to/file\", \"--verbose\"]}\n\n      iex> OptionParser.parse_head!([\"--number\", \"lib\", \"test/enum_test.exs\", \"--verbose\"],\n      ...>                          strict: [number: :integer])\n      ** (OptionParser.ParseError) 1 error found!\n      --number : Expected type integer, got \"lib\"\n\n      iex> OptionParser.parse_head!([\"--verbose\", \"--source\", \"lib\", \"test/enum_test.exs\", \"--unlock\"],\n      ...>                          strict: [verbose: :integer, source: :integer])\n      ** (OptionParser.ParseError) 2 errors found!\n      --verbose : Missing argument of type integer\n      --source : Expected type integer, got \"lib\"\n  "
    },
    split = {
      description = "split(String.t) :: argv\nsplit(string)\n\n  Splits a string into `t:argv/0` chunks.\n\n  This function splits the given `string` into a list of strings in a similar\n  way to many shells.\n\n  ## Examples\n\n      iex> OptionParser.split(\"foo bar\")\n      [\"foo\", \"bar\"]\n\n      iex> OptionParser.split(\"foo \\\"bar baz\\\"\")\n      [\"foo\", \"bar baz\"]\n\n  "
    },
    to_argv = {
      description = "to_argv(Enumerable.t, options) :: argv\nto_argv(enum, opts \\\\ [])\n\n  Receives a key-value enumerable and converts it to `t:argv/0`.\n\n  Keys must be atoms. Keys with `nil` value are discarded,\n  boolean values are converted to `--key` or `--no-key`\n  (if the value is `true` or `false`, respectively),\n  and all other values are converted using `Kernel.to_string/1`.\n\n  It is advised to pass to `to_argv/2` the same set of `options`\n  given to `parse/2`. Some switches can only be reconstructed\n  correctly with the `switches` information in hand.\n\n  ## Examples\n\n      iex>  OptionParser.to_argv([foo_bar: \"baz\"])\n      [\"--foo-bar\", \"baz\"]\n      iex>  OptionParser.to_argv([bool: true, bool: false, discarded: nil])\n      [\"--bool\", \"--no-bool\"]\n\n  Some switches will output different values based on the switches\n  flag:\n\n      iex> OptionParser.to_argv([number: 2], switches: [])\n      [\"--number\", \"2\"]\n      iex> OptionParser.to_argv([number: 2], switches: [number: :count])\n      [\"--number\", \"--number\"]\n\n  "
    }
  },
  Parser = {
    DSL = {
      description = "false",
      lexer = {
        description = "lexer(<<unquote(char)::utf8, rest::binary>>, unquote(acc))\nlexer(\"\", unquote(acc))\nlexer(unquote(match) <> rest, acc)\n\n  Compiles a requirement to its internal representation with\n  `:ets.match_spec_compile/1` for faster matching.\n\n  The internal representation is opaque and can not be converted to external\n  term format and then back again without losing its properties (meaning it\n  can not be sent to a process on another node and still remain a valid\n  compiled match_spec, nor can it be stored on disk).\n  "
      }
    },
    description = "false",
    inspect = {
      description = "inspect(%Version.Requirement{source: source}, _opts)\ninspect(self, _opts)\n\n  Compiles a requirement to its internal representation with\n  `:ets.match_spec_compile/1` for faster matching.\n\n  The internal representation is opaque and can not be converted to external\n  term format and then back again without losing its properties (meaning it\n  can not be sent to a process on another node and still remain a valid\n  compiled match_spec, nor can it be stored on disk).\n  "
    },
    parse_requirement = {
      description = "parse_requirement(String.t) :: {:ok, term} | :error\nparse_requirement(source)\n\n  Compiles a requirement to its internal representation with\n  `:ets.match_spec_compile/1` for faster matching.\n\n  The internal representation is opaque and can not be converted to external\n  term format and then back again without losing its properties (meaning it\n  can not be sent to a process on another node and still remain a valid\n  compiled match_spec, nor can it be stored on disk).\n  "
    },
    parse_version = {
      description = "parse_version(String.t) :: {:ok, Version.matchable} | :error\nparse_version(string, approximate? \\\\ false) when is_binary(string)\n\n  Compiles a requirement to its internal representation with\n  `:ets.match_spec_compile/1` for faster matching.\n\n  The internal representation is opaque and can not be converted to external\n  term format and then back again without losing its properties (meaning it\n  can not be sent to a process on another node and still remain a valid\n  compiled match_spec, nor can it be stored on disk).\n  "
    },
    to_string = {
      description = "to_string(%Version.Requirement{source: source})\nto_string(version)\n\n  Compiles a requirement to its internal representation with\n  `:ets.match_spec_compile/1` for faster matching.\n\n  The internal representation is opaque and can not be converted to external\n  term format and then back again without losing its properties (meaning it\n  can not be sent to a process on another node and still remain a valid\n  compiled match_spec, nor can it be stored on disk).\n  "
    }
  },
  Path = {
    absname = {
      description = "absname(t, t) :: binary\nabsname(path, relative_to)\nabsname(t) :: binary\nabsname(path)\n\n  Converts the given path to an absolute one. Unlike\n  `expand/1`, no attempt is made to resolve `..`, `.` or `~`.\n\n  ## Examples\n\n  ### Unix\n\n      Path.absname(\"foo\")\n      #=> \"/usr/local/foo\"\n\n      Path.absname(\"../x\")\n      #=> \"/usr/local/../x\"\n\n  ### Windows\n\n      Path.absname(\"foo\").\n      #=> \"D:/usr/local/foo\"\n      Path.absname(\"../x\").\n      #=> \"D:/usr/local/../x\"\n\n  "
    },
    basename = {
      description = "basename(t, t) :: binary\nbasename(path, extension)\nbasename(t) :: binary\nbasename(path)\n\n  Returns the last component of the path or the path\n  itself if it does not contain any directory separators.\n\n  ## Examples\n\n      iex> Path.basename(\"foo\")\n      \"foo\"\n\n      iex> Path.basename(\"foo/bar\")\n      \"bar\"\n\n      iex> Path.basename(\"/\")\n      \"\"\n\n  "
    },
    description = "\n  This module provides conveniences for manipulating or\n  retrieving file system paths.\n\n  The functions in this module may receive a chardata as\n  argument (i.e. a string or a list of characters / string)\n  and will always return a string (encoded in UTF-8).\n\n  The majority of the functions in this module do not\n  interact with the file system, except for a few functions\n  that require it (like `wildcard/2` and `expand/1`).\n  ",
    dirname = {
      description = "dirname(t) :: binary\ndirname(path)\n\n  Returns the directory component of `path`.\n\n  ## Examples\n\n      iex> Path.dirname(\"/foo/bar.ex\")\n      \"/foo\"\n\n      iex> Path.dirname(\"/foo/bar/baz.ex\")\n      \"/foo/bar\"\n\n      iex> Path.dirname(\"/foo/bar/\")\n      \"/foo/bar\"\n\n  "
    },
    expand = {
      description = "expand(t, t) :: binary\nexpand(path, relative_to)\nexpand(t) :: binary\nexpand(path)\n\n  Converts the path to an absolute one and expands\n  any `.` and `..` characters and a leading `~`.\n\n  ## Examples\n\n      Path.expand(\"/foo/bar/../bar\")\n      #=> \"/foo/bar\"\n\n  "
    },
    extname = {
      description = "extname(t) :: binary\nextname(path)\n\n  Returns the extension of the last component of `path`.\n\n  ## Examples\n\n      iex> Path.extname(\"foo.erl\")\n      \".erl\"\n\n      iex> Path.extname(\"~/foo/bar\")\n      \"\"\n\n  "
    },
    join = {
      description = "join(t, t) :: binary\njoin(left, right)\njoin([name])\njoin(nonempty_list(t)) :: binary\njoin([name1, name2 | rest])\n\n  Joins a list of paths.\n\n  This function should be used to convert a list of paths to a path.\n  Note that any trailing slash is removed when joining.\n\n  ## Examples\n\n      iex> Path.join([\"~\", \"foo\"])\n      \"~/foo\"\n\n      iex> Path.join([\"foo\"])\n      \"foo\"\n\n      iex> Path.join([\"/\", \"foo\", \"bar/\"])\n      \"/foo/bar\"\n\n  "
    },
    relative = {
      description = "relative(t) :: binary\nrelative(name)\n\n  Forces the path to be a relative path.\n\n  ## Examples\n\n  ### Unix\n\n      Path.relative(\"/usr/local/bin\")   #=> \"usr/local/bin\"\n      Path.relative(\"usr/local/bin\")    #=> \"usr/local/bin\"\n      Path.relative(\"../usr/local/bin\") #=> \"../usr/local/bin\"\n\n  ### Windows\n\n      Path.relative(\"D:/usr/local/bin\") #=> \"usr/local/bin\"\n      Path.relative(\"usr/local/bin\")    #=> \"usr/local/bin\"\n      Path.relative(\"D:bar.ex\")         #=> \"bar.ex\"\n      Path.relative(\"/bar/foo.ex\")      #=> \"bar/foo.ex\"\n\n  "
    },
    relative_to = {
      description = "relative_to(t, t) :: binary\nrelative_to(path, from)\n\n  Returns the given `path` relative to the given `from` path.\n\n  In other words, this function tries to strip the `from` prefix from `path`.\n\n  This function does not query the file system, so it assumes\n  no symlinks between the paths.\n\n  In case a direct relative path cannot be found, it returns\n  the original path.\n\n  ## Examples\n\n      iex> Path.relative_to(\"/usr/local/foo\", \"/usr/local\")\n      \"foo\"\n\n      iex> Path.relative_to(\"/usr/local/foo\", \"/\")\n      \"usr/local/foo\"\n\n      iex> Path.relative_to(\"/usr/local/foo\", \"/etc\")\n      \"/usr/local/foo\"\n\n  "
    },
    relative_to_cwd = {
      description = "relative_to_cwd(t) :: binary\nrelative_to_cwd(path)\n\n  Convenience to get the path relative to the current working\n  directory.\n\n  If, for some reason, the current working directory\n  cannot be retrieved, this function returns the given `path`.\n  "
    },
    rootname = {
      description = "rootname(t, t) :: binary\nrootname(path, extension)\nrootname(t) :: binary\nrootname(path)\n\n  Returns the `path` with the `extension` stripped.\n\n  ## Examples\n\n      iex> Path.rootname(\"/foo/bar\")\n      \"/foo/bar\"\n\n      iex> Path.rootname(\"/foo/bar.ex\")\n      \"/foo/bar\"\n\n  "
    },
    split = {
      description = "split(path)\nsplit(t) :: [binary]\nsplit(\"\")\n\n  Splits the path into a list at the path separator.\n\n  If an empty string is given, returns an empty list.\n\n  On Windows, path is split on both \"\\\" and \"/\" separators\n  and the driver letter, if there is one, is always returned\n  in lowercase.\n\n  ## Examples\n\n      iex> Path.split(\"\")\n      []\n\n      iex> Path.split(\"foo\")\n      [\"foo\"]\n\n      iex> Path.split(\"/foo/bar\")\n      [\"/\", \"foo\", \"bar\"]\n\n  "
    },
    t = {
      description = "t :: :unicode.chardata()\n"
    },
    type = {
      description = "type(t) :: :absolute | :relative | :volumerelative\ntype(name) when is_list(name) or is_binary(name)\n\n  Returns the path type.\n\n  ## Examples\n\n  ### Unix\n\n      Path.type(\"/\")                #=> :absolute\n      Path.type(\"/usr/local/bin\")   #=> :absolute\n      Path.type(\"usr/local/bin\")    #=> :relative\n      Path.type(\"../usr/local/bin\") #=> :relative\n      Path.type(\"~/file\")           #=> :relative\n\n  ### Windows\n\n      Path.type(\"D:/usr/local/bin\") #=> :absolute\n      Path.type(\"usr/local/bin\")    #=> :relative\n      Path.type(\"D:bar.ex\")         #=> :volumerelative\n      Path.type(\"/bar/foo.ex\")      #=> :volumerelative\n\n  "
    }
  },
  Port = {
    close = {
      description = "close(port) :: true\nclose(port)\n\n  Closes the `port`.\n\n  For more information, see [`:erlang.port_close/1`](http://www.erlang.org/doc/man/erlang.html#port_close-1).\n\n  Inlined by the compiler.\n  "
    },
    command = {
      description = "command(port, iodata, [:force | :nosuspend]) :: boolean\ncommand(port, data, options \\\\ [])\n\n  Sends `data` to the port driver `port`.\n\n  For more information, see [`:erlang.port_command/2`](http://www.erlang.org/doc/man/erlang.html#port_command-2).\n\n  Inlined by the compiler.\n  "
    },
    connect = {
      description = "connect(port, pid) :: true\nconnect(port, pid)\n\n  Associates the `port` identifier with a `pid`.\n\n  For more information, see [`:erlang.port_connect/2`](http://www.erlang.org/doc/man/erlang.html#port_connect-2).\n\n  Inlined by the compiler.\n  "
    },
    description = "\n  Functions for interacting with the external world through ports.\n\n  Ports provide a mechanism to start operating system processes external\n  to the Erlang VM and communicate with them via message passing.\n\n  ## Example\n\n      iex> port = Port.open({:spawn, \"cat\"}, [:binary])\n      iex> send port, {self(), {:command, \"hello\"}}\n      iex> send port, {self(), {:command, \"world\"}}\n      iex> flush()\n      {#Port<0.1444>, {:data, \"hello\"}}\n      {#Port<0.1444>, {:data, \"world\"}}\n      iex> send port, {self(), :close}\n      :ok\n      iex> flush()\n      {#Port<0.1464>, :closed}\n      :ok\n\n  In the example above, we have created a new port that executes the\n  program `cat`. `cat` is a program available on UNIX systems that\n  receives data from multiple inputs and concatenates them in the output.\n\n  After the port was created, we sent it two commands in the form of\n  messages using `Kernel.send/2`. The first command has the binary payload\n  of \"hello\" and the second has \"world\".\n\n  After sending those two messages, we invoked the IEx helper `flush()`,\n  which printed all messages received from the port, in this case we got\n  \"hello\" and \"world\" back. Notice the messages are in binary because we\n  passed the `:binary` option when opening the port in `Port.open/2`. Without\n  such option, it would have yielded a list of bytes.\n\n  Once everything was done, we closed the port.\n\n  Elixir provides many conveniences for working with ports and some drawbacks.\n  We will explore those below.\n\n  ## Message and function APIs\n\n  There are two APIs for working with ports. It can be either asynchronous via\n  message passing, as in the example above, or by calling the functions on this\n  module.\n\n  The messages supported by ports and their counterpart function APIs are\n  listed below:\n\n    * `{pid, {:command, binary}}` - sends the given data to the port.\n      See `command/3`.\n\n    * `{pid, :close}` - closes the port. Unless the port is already closed,\n      the port will reply with `{port, :closed}` message once it has flushed\n      its buffers and effectively closed. See `close/1`.\n\n    * `{pid, {:connect, new_pid}}` - sets the `new_pid` as the new owner of\n      the port. Once a port is opened, the port is linked and connected to the\n      caller process and communication to the port only happens through the\n      connected process. This message makes `new_pid` the new connected processes.\n      Unless the port is dead, the port will reply to the old owner with\n      `{port, :connected}`. See `connect/2`.\n\n  On its turn, the port will send the connected process the following messages:\n\n    * `{port, {:data, data}}` - data sent by the port\n    * `{port, :closed}` - reply to the `{pid, :close}` message\n    * `{port, :connected}` - reply to the `{pid, {:connect, new_pid}}` message\n    * `{:EXIT, port, reason}` - exit signals in case the port crashes and the\n      owner process is trapping exits\n\n  ## Open mechanisms\n\n  The port can be opened through four main mechanisms.\n\n  As a short summary, prefer to using the `:spawn` and `:spawn_executable`\n  options mentioned below. The other two options, `:spawn_driver` and `:fd`\n  are for advanced usage within the VM. Also consider using `System.cmd/3`\n  if all you want is to execute a program and retrieve its return value.\n\n  ### spawn\n\n  The `:spawn` tuple receives a binary that is going to be executed as a\n  full invocation. For example, we can use it to invoke \"echo hello\" directly:\n\n      iex> port = Port.open({:spawn, \"echo oops\"}, [:binary])\n      iex> flush()\n      {#Port<0.1444>, {:data, \"oops\\n\"}}\n\n  `:spawn` will retrieve the program name from the argument and traverse your\n  OS `$PATH` environment variable looking for a matching program.\n\n  Although the above is handy, it means it is impossible to invoke an executable\n  that has whitespaces on its name or in any of its arguments. For those reasons,\n  most times it is preferrable to execute `:spawn_executable`.\n\n  ### spawn_executable\n\n  Spawn executable is a more restricted and explicit version of spawn. It expects\n  full file paths to the executable you want to execute. If they are in your `$PATH`,\n  they can be retrieved by calling `System.find_executable/1`:\n\n      iex> path = System.find_executable(\"echo\")\n      iex> port = Port.open({:spawn_executable, path}, [:binary, args: [\"hello world\"]])\n      iex> flush()\n      {#Port<0.1380>, {:data, \"hello world\\n\"}}\n\n  When using `:spawn_executable`, the list of arguments can be passed via\n  the `:args` option as done above. For the full list of options, see the\n  documentation for the Erlang function `:erlang.open_port/2`.\n\n  ### spawn_driver\n\n  Spawn driver is used to start Port Drivers, which are programs written in\n  C that implements a specific communication protocols and are dynamically\n  linked to the Erlang VM. Port drivers are an advanced topic and one of the\n  mechanisms for integrating C code, alongside NIFs. For more information,\n  [please check the Erlang docs](http://erlang.org/doc/reference_manual/ports.html).\n\n  ### fd\n\n  The `:fd` name option allows developers to access `in` and `out` file\n  descriptors used by the Erlang VM. You would use those only if you are\n  reimplementing core part of the Runtime System, such as the `:user` and\n  `:shell` processes.\n\n  ## Zombie processes\n\n  A port can be closed via the `close/1` function or by sending a `{pid, :close}`\n  message. However, if the VM crashes, a long-running program started by the port\n  will have its stdin and stdout channels closed but **it won't be automatically\n  terminated**.\n\n  While most UNIX command line tools will exit once its communication channels\n  are closed, not all command line applications will do so. While we encourage\n  graceful termination by detecting if stdin/stdout has been closed, we do not\n  always have control over how 3rd party software terminates. In those cases,\n  you can wrap the application in a script that checks for stdin. Here is such\n  script in bash:\n\n      #!/bin/sh\n      \"$@\"\n      pid=$!\n      while read line ; do\n        :\n      done\n      kill -KILL $pid\n\n\n  Now instead of:\n\n      Port.open({:spawn_executable, \"/path/to/program\"},\n                [args: [\"a\", \"b\", \"c\"]])\n\n  You may invoke:\n\n      Port.open({:spawn_executable, \"/path/to/wrapper\"},\n                [args: [\"/path/to/program\", \"a\", \"b\", \"c\"]])\n\n  ",
    info = {
      description = "info(port, item)\ninfo(port, :registered_name)\ninfo(port, atom) :: {atom, term} | nil\ninfo(port, spec)\ninfo(port)\n\n  Returns information about the `port` or `nil` if the port is closed.\n\n  For more information, see [`:erlang.port_info/1`](http://www.erlang.org/doc/man/erlang.html#port_info-1).\n  "
    },
    list = {
      description = "list :: [port]\nlist\n\n  Returns a list of all ports in the current node.\n\n  Inlined by the compiler.\n  "
    },
    name = {
      description = "name :: {:spawn, charlist | binary} |\n"
    },
    open = {
      description = "open(name, list) :: port\nopen(name, settings)\n\n  Opens a port given a tuple `name` and a list of `options`.\n\n  The module documentation above contains documentation and examples\n  for the supported `name` values, summarized below:\n\n    * `{:spawn, command}` - runs an external program. `command` must contain\n      the program name and optionally a list of arguments separated by space.\n      If passing programs or arguments with space in their name, use the next option.\n    * `{:spawn_executable, filename}` - runs the executable given by the absolute\n      file name `filename`. Arguments can be passed via the `:args` option.\n    * `{:spawn_driver, command}` - spawns so-called port drivers.\n    * `{:fd, fd_in, fd_out}` - accesses file descriptors, `fd_in` and `fd_out`\n      opened by the VM.\n\n  For more information and the list of options, see\n  [`:erlang.open_port/2`](http://www.erlang.org/doc/man/erlang.html#open_port-2).\n\n  Inlined by the compiler.\n  "
    }
  },
  Process = {
    ["alive?"] = {
      description = "alive?(pid) :: boolean\nalive?(pid)\n\n  Tells whether the given process is alive.\n\n  If the process identified by `pid` is alive (that is, it's not exiting and has\n  not exited yet) than this function returns `true`. Otherwise, it returns\n  `false`.\n\n  `pid` must refer to a process running on the local node.\n\n  Inlined by the compiler.\n  "
    },
    cancel_timer = {
      description = "cancel_timer(reference) :: non_neg_integer | false\ncancel_timer(timer_ref)\n\n  Cancels a timer returned by `send_after/3`.\n\n  When the result is an integer, it represents the time in milliseconds\n  left until the timer would have expired.\n\n  When the result is `false`, a timer corresponding to `timer_ref` could not be\n  found. This can happen either because the timer expired, because it has\n  already been canceled, or because `timer_ref` never corresponded to a timer.\n\n  Even if the timer had expired and the message was sent, this function does not\n  tell you if the timeout message has arrived at its destination yet.\n\n  Inlined by the compiler.\n  "
    },
    delete = {
      description = "delete(term) :: term | nil\ndelete(key)\n\n  Deletes the given `key` from the process dictionary.\n  "
    },
    demonitor = {
      description = "demonitor(reference, options :: [:flush | :info]) :: boolean\ndemonitor(monitor_ref, options \\\\ [])\n\n  Demonitors the monitor identifies by the given `reference`.\n\n  If `monitor_ref` is a reference which the calling process\n  obtained by calling `monitor/1`, that monitoring is turned off.\n  If the monitoring is already turned off, nothing happens.\n\n  See [`:erlang.demonitor/2`](http://www.erlang.org/doc/man/erlang.html#demonitor-2) for more info.\n\n  Inlined by the compiler.\n  "
    },
    description = "\n  Conveniences for working with processes and the process dictionary.\n\n  Besides the functions available in this module, the `Kernel` module\n  exposes and auto-imports some basic functionality related to processes\n  available through the following functions:\n\n    * `Kernel.spawn/1` and `Kernel.spawn/3`\n    * `Kernel.spawn_link/1` and `Kernel.spawn_link/3`\n    * `Kernel.spawn_monitor/1` and `Kernel.spawn_monitor/3`\n    * `Kernel.self/0`\n    * `Kernel.send/2`\n\n  ",
    exit = {
      description = "exit(pid, term) :: true\nexit(pid, reason)\n\n  Sends an exit signal with the given `reason` to `pid`.\n\n  The following behaviour applies if `reason` is any term except `:normal`\n  or `:kill`:\n\n    1. If `pid` is not trapping exits, `pid` will exit with the given\n       `reason`.\n\n    2. If `pid` is trapping exits, the exit signal is transformed into a\n       message `{:EXIT, from, reason}` and delivered to the message queue\n       of `pid`.\n\n  If `reason` is the atom `:normal`, `pid` will not exit (unless `pid` is\n  the calling process, in which case it will exit with the reason `:normal`).\n  If it is trapping exits, the exit signal is transformed into a message\n  `{:EXIT, from, :normal}` and delivered to its message queue.\n\n  If `reason` is the atom `:kill`, that is if `Process.exit(pid, :kill)` is called,\n  an untrappable exit signal is sent to `pid` which will unconditionally exit\n  with reason `:killed`.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      Process.exit(pid, :kill)\n      #=> true\n\n  "
    },
    flag = {
      description = "flag(pid, :save_calls, non_neg_integer) :: non_neg_integer\nflag(pid, flag, value)\nflag(process_flag, term) :: term\nflag(flag, value)\n\n  Sets the given `flag` to `value` for the calling process.\n\n  Returns the old value of `flag`.\n\n  See [`:erlang.process_flag/2`](http://www.erlang.org/doc/man/erlang.html#process_flag-2) for more info.\n  "
    },
    get = {
      description = "get(term, default :: term) :: term\nget(key, default \\\\ nil)\nget :: [{term, term}]\nget\n\n  Returns all key-value pairs in the process dictionary.\n\n  Inlined by the compiler.\n  "
    },
    get_keys = {
      description = "get_keys(term) :: [term]\nget_keys(value)\nget_keys() :: [term]\nget_keys()\n\n  Returns all keys in the process dictionary.\n\n  Inlined by the compiler.\n  "
    },
    group_leader = {
      description = "group_leader(pid, leader :: pid) :: true\ngroup_leader(pid, leader)\ngroup_leader :: pid\ngroup_leader\n\n  Returns the PID of the group leader for the calling process.\n  "
    },
    hibernate = {
      description = "hibernate(module, atom, list) :: no_return\nhibernate(mod, fun, args)\n\n  Puts the calling process into a \"hibernation\" state.\n\n  The calling process is put into a waiting state\n  where its memory allocation has been reduced as much as possible,\n  which is useful if the process does not expect to receive any messages\n  in the near future.\n\n  See [`:erlang.hibernate/3`](http://www.erlang.org/doc/man/erlang.html#hibernate-3) for more info.\n\n  Inlined by the compiler.\n  "
    },
    info = {
      description = "info(pid, spec) when is_atom(spec) or is_list(spec)\ninfo(pid, :registered_name)\ninfo(pid, atom | [atom]) :: {atom, term} | [{atom, term}]  | nil\ninfo(pid, spec)\ninfo(pid) :: Keyword.t\ninfo(pid)\n\n  Returns information about the process identified by `pid`, or returns `nil` if the process\n  is not alive.\n\n  Use this only for debugging information.\n\n  See [`:erlang.process_info/1`](http://www.erlang.org/doc/man/erlang.html#process_info-1) for more info.\n  "
    },
    link = {
      description = "link(pid | port) :: true\nlink(pid_or_port)\n\n  Creates a link between the calling process and the given item (process or\n  port).\n\n  If such a link exists already, this function does nothing.\n\n  See [`:erlang.link/1`](http://www.erlang.org/doc/man/erlang.html#link-1) for more info.\n\n  Inlined by the compiler.\n  "
    },
    list = {
      description = "list :: [pid]\nlist\n\n  Returns a list of PIDs corresponding to all the\n  processes currently existing on the local node.\n\n  Note that if a process is exiting, it is considered to exist but not be\n  alive. This means that for such process, `alive?/1` will return `false` but\n  its PID will be part of the list of PIDs returned by this function.\n\n  See [`:erlang.processes/0`](http://www.erlang.org/doc/man/erlang.html#processes-0) for more info.\n  "
    },
    monitor = {
      description = "monitor(pid | {reg_name :: atom, node :: atom} | reg_name :: atom) :: reference\nmonitor(item)\n\n  Starts monitoring the given `item` from the calling process.\n\n  This function returns the monitor reference.\n\n  See [the need for monitoring](http://elixir-lang.org/getting-started/mix-otp/genserver.html#the-need-for-monitoring)\n  for an example.\n  See [`:erlang.monitor/2`](http://www.erlang.org/doc/man/erlang.html#monitor-2) for more info.\n\n  Inlined by the compiler.\n  "
    },
    put = {
      description = "put(term, term) :: term | nil\nput(key, value)\n\n  Stores the given `key`-`value` pair in the process dictionary.\n\n  The return value of this function is the value that was previously stored\n  under the key `key`, or `nil` in case no value was stored under `key`.\n\n  ## Examples\n\n      # Assuming :locale was not set\n      Process.put(:locale, \"en\")\n      #=> nil\n      Process.put(:locale, \"fr\")\n      #=> \"en\"\n\n  "
    },
    read_timer = {
      description = "read_timer(reference) :: non_neg_integer | false\nread_timer(timer_ref)\n\n  Reads a timer created by `send_after/3`.\n\n  When the result is an integer, it represents the time in milliseconds\n  left until the timer will expire.\n\n  When the result is `false`, a timer corresponding to `timer_ref` could not be\n  found. This can be either because the timer expired, because it has already\n  been canceled, or because `timer_ref` never corresponded to a timer.\n\n  Even if the timer had expired and the message was sent, this function does not\n  tell you if the timeout message has arrived at its destination yet.\n\n  Inlined by the compiler.\n  "
    },
    register = {
      description = "register(pid | port, atom) :: true\nregister(pid_or_port, name) when is_atom(name) and name not in [nil, false, true, :undefined]\n\n  Registers the given `pid_or_port` under the given `name`.\n\n  `name` must be an atom and can then be used instead of the\n  PID/port identifier when sending messages with `Kernel.send/2`.\n\n  `register/2` will fail with `ArgumentError` in any of the following cases:\n\n    * the PID/Port is not existing locally and alive\n    * the name is already registered\n    * the `pid_or_port` is already registered under a different `name`\n\n  The following names are reserved and cannot be assigned to\n  processes nor ports:\n\n    * `nil`\n    * `false`\n    * `true`\n    * `:undefined`\n\n  "
    },
    registered = {
      description = "registered :: [atom]\nregistered\n\n  Returns a list of names which have been registered using `register/2`.\n  "
    },
    send = {
      description = "send(dest, msg, [option]) :: :ok | :noconnect | :nosuspend\nsend(dest, msg, options)\n\n  Sends a message to the given process.\n\n  ## Options\n\n    * `:noconnect` - when used, if sending the message would require an\n      auto-connection to another node the message is not sent and `:noconnect` is\n      returned.\n\n    * `:nosuspend` - when used, if sending the message would cause the sender to\n      be suspended the message is not sent and `:nosuspend` is returned.\n\n  Otherwise the message is sent and `:ok` is returned.\n\n  ## Examples\n\n      iex> Process.send({:name, :node_that_does_not_exist}, :hi, [:noconnect])\n      :noconnect\n\n  "
    },
    send_after = {
      description = "send_after(pid | atom, term, non_neg_integer, [option]) :: reference\nsend_after(dest, msg, time, opts \\\\ [])\n\n  Sends `msg` to `dest` after `time` milliseconds.\n\n  If `dest` is a PID, it must be the PID of a local process, dead or alive.\n  If `dest` is an atom, it must be the name of a registered process\n  which is looked up at the time of delivery. No error is produced if the name does\n  not refer to a process.\n\n  This function returns a timer reference, which can be read with `read_timer/1`\n  or canceled with `cancel_timer/1`.\n\n  The timer will be automatically canceled if the given `dest` is a PID\n  which is not alive or when the given PID exits. Note that timers will not be\n  automatically canceled when `dest` is an atom (as the atom resolution is done\n  on delivery).\n\n  ## Options\n\n    * `:abs` - (boolean) when `false`, `time` is treated as relative to the\n    current monotonic time. When `true`, `time` is the absolute value of the\n    Erlang monotonic time at which `msg` should be delivered to `dest`.\n    To read more about Erlang monotonic time and other time-related concepts,\n    look at the documentation for the `System` module. Defaults to `false`.\n\n  ## Examples\n\n      timer_ref = Process.send_after(pid, :hi, 1000)\n\n  "
    },
    sleep = {
      description = "sleep(timeout)\n\n  Sleeps the current process for the given `timeout`.\n\n  `timeout` is either the number of milliseconds to sleep as an\n  integer or the atom `:infinity`. When `:infinity` is given,\n  the current process will suspend forever.\n\n  **Use this function with extreme care**. For almost all situations\n  where you would use `sleep/1` in Elixir, there is likely a\n  more correct, faster and precise way of achieving the same with\n  message passing.\n\n  For example, if you are waiting a process to perform some\n  action, it is better to communicate the progress of such action\n  with messages.\n\n  In other words, **do not**:\n\n      Task.start_link fn ->\n        do_something()\n        ...\n      end\n\n      # Wait until work is done\n      Process.sleep(2000)\n\n  But **do**:\n\n      parent = self()\n      Task.start_link fn ->\n        do_something()\n        send parent, :work_is_done\n        ...\n      end\n\n      receive do\n        :work_is_done -> :ok\n      after\n        30_000 -> :timeout # Optional timeout\n      end\n\n  For cases like the one above, `Task.async/1` and `Task.await/2` are\n  preferred.\n\n  Similarly, if you are waiting for a process to terminate,\n  monitor that process instead of sleeping. **Do not**:\n\n      Task.start_link fn ->\n        ...\n      end\n\n      # Wait until task terminates\n      Process.sleep(2000)\n\n  Instead **do**:\n\n      {:ok, pid} =\n        Task.start_link fn ->\n          ...\n        end\n\n      ref = Process.monitor(pid)\n      receive do\n        {:DOWN, ^ref, _, _, _} -> :task_is_down\n      after\n        30_000 -> :timeout # Optional timeout\n      end\n\n  "
    },
    spawn = {
      description = "spawn(module, atom, list, spawn_opts) :: pid | {pid, reference}\nspawn(mod, fun, args, opts)\nspawn((() -> any), spawn_opts) :: pid | {pid, reference}\nspawn(fun, opts)\n\n  Spawns the given function according to the given options.\n\n  The result depends on the given options. In particular,\n  if `:monitor` is given as an option, it will return a tuple\n  containing the PID and the monitoring reference, otherwise\n  just the spawned process PID.\n\n  More options are available; for the comprehensive list of available options\n  check [`:erlang.spawn_opt/4`](http://www.erlang.org/doc/man/erlang.html#spawn_opt-4).\n\n  Inlined by the compiler.\n  "
    },
    spawn_opt = {
      description = "spawn_opt :: :link | :monitor | {:priority, :low | :normal | :high} |\n"
    },
    spawn_opts = {
      description = "spawn_opts :: [spawn_opt]\n"
    },
    unlink = {
      description = "unlink(pid | port) :: true\nunlink(pid_or_port)\n\n\n  Removes the link between the calling process and the given item (process or\n  port).\n\n  If there is no such link, this function does nothing. If `pid_or_port` does\n  not exist, this function does not produce any errors and simply does nothing.\n\n  The return value of this function is always `true`.\n\n  See [`:erlang.unlink/1`](http://www.erlang.org/doc/man/erlang.html#unlink-1) for more info.\n\n  Inlined by the compiler.\n  "
    },
    unregister = {
      description = "unregister(atom) :: true\nunregister(name)\n\n  Removes the registered `name`, associated with a PID\n  or a port identifier.\n\n  Fails with `ArgumentError` if the name is not registered\n  to any PID or port.\n  "
    },
    whereis = {
      description = "whereis(atom) :: pid | port | nil\nwhereis(name)\n\n  Returns the PID or port identifier registered under `name` or `nil` if the\n  name is not registered.\n\n  See [`:erlang.whereis/1`](http://www.erlang.org/doc/man/erlang.html#whereis-1) for more info.\n  "
    }
  },
  Protocol = {
    UndefinedError = {
      message = {
        description = "message(exception)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
      }
    },
    __builtin__ = {
      description = "__builtin__\nfalse"
    },
    __derive__ = {
      description = "__derive__(derives, for, %Macro.Env{} = env) when is_atom(for)\nfalse"
    },
    __ensure_defimpl__ = {
      description = "__ensure_defimpl__(protocol, for, env)\nfalse"
    },
    __functions_spec__ = {
      description = "__functions_spec__([head | tail]),\n__functions_spec__([]),\nfalse"
    },
    __impl__ = {
      description = "__impl__(:for)\n__impl__(:protocol)\n__impl__(:for) :: unquote(for)\n__impl__(:target)\n__impl__(:protocol)\n__impl__(:target)\n__impl__(:protocol) :: unquote(protocol)\n__impl__(:for)\n__impl__(protocol, opts)\nfalse"
    },
    __protocol__ = {
      description = "__protocol__(name, [do: block])\nfalse"
    },
    ["__spec__?"] = {
      description = "__spec__?(module, name, arity)\nfalse"
    },
    ["assert_impl!"] = {
      description = "assert_impl!(module, module) :: :ok | no_return\nassert_impl!(protocol, base)\n\n  Checks if the given module is loaded and is an implementation\n  of the given protocol.\n\n  Returns `:ok` if so, otherwise raises `ArgumentError`.\n  "
    },
    ["assert_protocol!"] = {
      description = "assert_protocol!(module) :: :ok | no_return\nassert_protocol!(module)\n\n  Checks if the given module is loaded and is protocol.\n\n  Returns `:ok` if so, otherwise raises `ArgumentError`.\n  "
    },
    consolidate = {
      description = "consolidate(module, [module]) ::\nconsolidate(protocol, types) when is_atom(protocol)\n\n  Receives a protocol and a list of implementations and\n  consolidates the given protocol.\n\n  Consolidation happens by changing the protocol `impl_for`\n  in the abstract format to have fast lookup rules. Usually\n  the list of implementations to use during consolidation\n  are retrieved with the help of `extract_impls/2`.\n\n  It returns the updated version of the protocol bytecode.\n  A given bytecode or protocol implementation can be checked\n  to be consolidated or not by analyzing the protocol\n  attribute:\n\n      Protocol.consolidated?(Enumerable)\n\n  If the first element of the tuple is `true`, it means\n  the protocol was consolidated.\n\n  This function does not load the protocol at any point\n  nor loads the new bytecode for the compiled module.\n  However each implementation must be available and\n  it will be loaded.\n  "
    },
    ["consolidated?"] = {
      description = "consolidated?(module) :: boolean\nconsolidated?(protocol)\n\n  Returns `true` if the protocol was consolidated.\n  "
    },
    description = "\n  Functions for working with protocols.\n  ",
    extract_impls = {
      description = "extract_impls(module, [charlist | String.t]) :: [atom]\nextract_impls(protocol, paths) when is_atom(protocol)\n\n  Extracts all types implemented for the given protocol from\n  the given paths.\n\n  The paths can be either a charlist or a string. Internally\n  they are worked on as charlists, so passing them as lists\n  avoid extra conversion.\n\n  Does not load any of the implementations.\n\n  ## Examples\n\n      # Get Elixir's ebin and retrieve all protocols\n      iex> path = :code.lib_dir(:elixir, :ebin)\n      iex> mods = Protocol.extract_impls(Enumerable, [path])\n      iex> List in mods\n      true\n\n  "
    },
    extract_protocols = {
      description = "extract_protocols([charlist | String.t]) :: [atom]\nextract_protocols(paths)\n\n  Extracts all protocols from the given paths.\n\n  The paths can be either a charlist or a string. Internally\n  they are worked on as charlists, so passing them as lists\n  avoid extra conversion.\n\n  Does not load any of the protocols.\n\n  ## Examples\n\n      # Get Elixir's ebin and retrieve all protocols\n      iex> path = :code.lib_dir(:elixir, :ebin)\n      iex> mods = Protocol.extract_protocols([path])\n      iex> Enumerable in mods\n      true\n\n  "
    },
    ["import Protocol"] = {
      description = "import Protocol\nfalse"
    },
    ["inside defprotocol\""] = {
      description = "inside defprotocol\"\n\n  Defines a new protocol function.\n\n  Protocols do not allow functions to be defined directly, instead, the\n  regular `Kernel.def/*` macros are replaced by this macro which\n  defines the protocol functions with the appropriate callbacks.\n  "
    },
    t = {
      description = "t :: term\n"
    }
  },
  Range = {
    count = {
      description = "count(first..last)\n\n  Returns `true` if the given `term` is a valid range.\n\n  ## Examples\n\n      iex> Range.range?(1..3)\n      true\n\n      iex> Range.range?(0)\n      false\n\n  "
    },
    description = "\n  Defines a range.\n\n  A range represents a discrete number of values where\n  the first and last values are integers.\n\n  Ranges can be either increasing (first <= last) or\n  decreasing (first > last). Ranges are also always\n  inclusive.\n\n  A Range is represented internally as a struct. However,\n  the most common form of creating and matching on ranges\n  is via the `../2` macro, auto-imported from `Kernel`:\n\n      iex> range = 1..3\n      1..3\n      iex> first..last = range\n      iex> first\n      1\n      iex> last\n      3\n\n  A Range implements the Enumerable protocol, which means\n  all of the functions in the Enum module is available:\n\n      iex> range = 1..10\n      1..10\n      iex> Enum.reduce(range, 0, fn i, acc -> i * i + acc end)\n      385\n      iex> Enum.count(range)\n      10\n      iex> Enum.member?(range, 11)\n      false\n      iex> Enum.member?(range, 8)\n      true\n\n  ",
    inspect = {
      description = "inspect(first..last, opts)\n\n  Returns `true` if the given `term` is a valid range.\n\n  ## Examples\n\n      iex> Range.range?(1..3)\n      true\n\n      iex> Range.range?(0)\n      false\n\n  "
    },
    ["member?"] = {
      description = "member?(_.._, _value)\nmember?(first..last, value) when is_integer(value)\n\n  Returns `true` if the given `term` is a valid range.\n\n  ## Examples\n\n      iex> Range.range?(1..3)\n      true\n\n      iex> Range.range?(0)\n      false\n\n  "
    },
    new = {
      description = "new(first, last)\nnew(integer, integer) :: t\nnew(first, last) when is_integer(first) and is_integer(last)\n\n  Creates a new range.\n  "
    },
    ["range?"] = {
      description = "range?(_)\nrange?(first..last) when is_integer(first) and is_integer(last)\nrange?(term) :: boolean\nrange?(term)\n\n  Returns `true` if the given `term` is a valid range.\n\n  ## Examples\n\n      iex> Range.range?(1..3)\n      true\n\n      iex> Range.range?(0)\n      false\n\n  "
    },
    reduce = {
      description = "reduce(first..last, acc, fun)\n\n  Returns `true` if the given `term` is a valid range.\n\n  ## Examples\n\n      iex> Range.range?(1..3)\n      true\n\n      iex> Range.range?(0)\n      false\n\n  "
    },
    t = {
      description = "t :: %Range{first: integer, last: integer}\n"
    }
  },
  Record = {
    Extractor = {
      description = "false",
      extract = {
        description = "extract(name, from_lib: file) when is_binary(file)\nextract(name, from: file) when is_binary(file)\n"
      },
      extract_all = {
        description = "extract_all(from_lib: file) when is_binary(file)\nextract_all(from: file) when is_binary(file)\n"
      }
    },
    __access__ = {
      description = "__access__(atom, fields, record, args, caller)\n__access__(atom, fields, args, caller)\nfalse"
    },
    __fields__ = {
      description = "__fields__(type, fields)\nfalse"
    },
    __keyword__ = {
      description = "__keyword__(atom, fields, record)\nfalse"
    },
    description = "\n  Module to work with, define, and import records.\n\n  Records are simply tuples where the first element is an atom:\n\n      iex> Record.is_record {User, \"john\", 27}\n      true\n\n  This module provides conveniences for working with records at\n  compilation time, where compile-time field names are used to\n  manipulate the tuples, providing fast operations on top of\n  the tuples' compact structure.\n\n  In Elixir, records are used mostly in two situations:\n\n    1. to work with short, internal data\n    2. to interface with Erlang records\n\n  The macros `defrecord/3` and `defrecordp/3` can be used to create records\n  while `extract/2` and `extract_all/1` can be used to extract records from\n  Erlang files.\n\n  ## Types\n\n  Types can be defined for tuples with the `record/2` macro (only available in\n  typespecs). This macro will expand to a tuple as seen in the example below:\n\n      defmodule MyModule do\n        require Record\n        Record.defrecord :user, name: \"john\", age: 25\n\n        @type user :: record(:user, name: String.t, age: integer)\n        # expands to: \"@type user :: {:user, String.t, integer}\"\n      end\n\n  ",
    extract = {
      description = "extract(name, opts) when is_atom(name) and is_list(opts)\n\n  Extracts record information from an Erlang file.\n\n  Returns a quoted expression containing the fields as a list\n  of tuples.\n\n  `name`, which is the name of the extracted record, is expected to be an atom\n  *at compile time*.\n\n  ## Options\n\n  This function accepts the following options, which are exclusive to each other\n  (i.e., only one of them can be used in the same call):\n\n    * `:from` - (binary representing a path to a file) path to the Erlang file\n      that contains the record definition to extract; with this option, this\n      function uses the same path lookup used by the `-include` attribute used in\n      Erlang modules.\n    * `:from_lib` - (binary representing a path to a file) path to the Erlang\n      file that contains the record definition to extract; with this option,\n      this function uses the same path lookup used by the `-include_lib`\n      attribute used in Erlang modules.\n\n  These options are expected to be literals (including the binary values) at\n  compile time.\n\n  ## Examples\n\n      iex> Record.extract(:file_info, from_lib: \"kernel/include/file.hrl\")\n      [size: :undefined, type: :undefined, access: :undefined, atime: :undefined,\n       mtime: :undefined, ctime: :undefined, mode: :undefined, links: :undefined,\n       major_device: :undefined, minor_device: :undefined, inode: :undefined,\n       uid: :undefined, gid: :undefined]\n\n  "
    },
    extract_all = {
      description = "extract_all(opts) when is_list(opts)\n\n  Extracts all records information from an Erlang file.\n\n  Returns a keyword list of `{record_name, fields}` tuples where `record_name`\n  is the name of an extracted record and `fields` is a list of `{field, value}`\n  tuples representing the fields for that record.\n\n  ## Options\n\n  This function accepts the following options, which are exclusive to each other\n  (i.e., only one of them can be used in the same call):\n\n    * `:from` - (binary representing a path to a file) path to the Erlang file\n      that contains the record definitions to extract; with this option, this\n      function uses the same path lookup used by the `-include` attribute used in\n      Erlang modules.\n    * `:from_lib` - (binary representing a path to a file) path to the Erlang\n      file that contains the record definitions to extract; with this option,\n      this function uses the same path lookup used by the `-include_lib`\n      attribute used in Erlang modules.\n\n  These options are expected to be literals (including the binary values) at\n  compile time.\n  "
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
        description = "handle_call(:sync, _, state)\n\n  Starts the registry partition.\n\n  The process is only responsible for monitoring, demonitoring\n  and cleaning up when monitored processes crash.\n  "
      },
      handle_info = {
        description = "handle_info(msg, state)\nhandle_info({:EXIT, pid, _reason}, ets)\n\n  Starts the registry partition.\n\n  The process is only responsible for monitoring, demonitoring\n  and cleaning up when monitored processes crash.\n  "
      },
      init = {
        description = "init({kind, registry, i, partitions, key_partition, pid_partition, listeners})\n\n  Starts the registry partition.\n\n  The process is only responsible for monitoring, demonitoring\n  and cleaning up when monitored processes crash.\n  "
      },
      key_name = {
        description = "key_name(atom, non_neg_integer) :: atom\nkey_name(registry, partition)\n\n  Returns the name of key partition table.\n  "
      },
      pid_name = {
        description = "pid_name(atom, non_neg_integer) :: atom\npid_name(name, partition)\n\n  Returns the name of pid partition table.\n  "
      },
      start_link = {
        description = "start_link(registry, arg)\n\n  Starts the registry partition.\n\n  The process is only responsible for monitoring, demonitoring\n  and cleaning up when monitored processes crash.\n  "
      }
    },
    Supervisor = {
      description = "false",
      init = {
        description = "init({kind, registry, partitions, listeners, entries})\n\n  Stores registry metadata.\n\n  Atoms and tuples are allowed as keys.\n\n  ## Examples\n\n      iex> Registry.start_link(:unique, Registry.PutMetaTest)\n      iex> Registry.put_meta(Registry.PutMetaTest, :custom_key, \"custom_value\")\n      :ok\n      iex> Registry.meta(Registry.PutMetaTest, :custom_key)\n      {:ok, \"custom_value\"}\n      iex> Registry.put_meta(Registry.PutMetaTest, {:tuple, :key}, \"tuple_value\")\n      :ok\n      iex> Registry.meta(Registry.PutMetaTest, {:tuple, :key})\n      {:ok, \"tuple_value\"}\n\n  "
      },
      start_link = {
        description = "start_link(kind, registry, partitions, listeners, entries)\n\n  Stores registry metadata.\n\n  Atoms and tuples are allowed as keys.\n\n  ## Examples\n\n      iex> Registry.start_link(:unique, Registry.PutMetaTest)\n      iex> Registry.put_meta(Registry.PutMetaTest, :custom_key, \"custom_value\")\n      :ok\n      iex> Registry.meta(Registry.PutMetaTest, :custom_key)\n      {:ok, \"custom_value\"}\n      iex> Registry.put_meta(Registry.PutMetaTest, {:tuple, :key}, \"tuple_value\")\n      :ok\n      iex> Registry.meta(Registry.PutMetaTest, {:tuple, :key})\n      {:ok, \"tuple_value\"}\n\n  "
      }
    },
    description = "\n  A local, decentralized and scalable key-value process storage.\n\n  It allows developers to lookup one or more processes with a given key.\n  If the registry has `:unique` keys, a key points to 0 or 1 processes.\n  If the registry allows `:duplicate` keys, a single key may point to any\n  number of processes. In both cases, different keys could identify the\n  same process.\n\n  Each entry in the registry is associated to the process that has\n  registered the key. If the process crashes, the keys associated to that\n  process are automatically removed. All key comparisons in the registry\n  are done using the match operation (`===`).\n\n  The registry can be used for different purposes, such as name lookups (using\n  the `:via` option), storing properties, custom dispatching rules, or a pubsub\n  implementation. We explore some of those use cases below.\n\n  The registry may also be transparently partitioned, which provides\n  more scalable behaviour for running registries on highly concurrent\n  environments with thousands or millions of entries.\n\n  ## Using in `:via`\n\n  Once the registry is started with a given name using\n  `Registry.start_link/2`, it can be used to register and access named\n  processes using the `{:via, Registry, {registry, key}}` tuple:\n\n      {:ok, _} = Registry.start_link(:unique, Registry.ViaTest)\n      name = {:via, Registry, {Registry.ViaTest, \"agent\"}}\n      {:ok, _} = Agent.start_link(fn -> 0 end, name: name)\n      Agent.get(name, & &1)\n      #=> 0\n      Agent.update(name, & &1 + 1)\n      Agent.get(name, & &1)\n      #=> 1\n\n  Typically the registry is started as part of a supervision tree though:\n\n      supervisor(Registry, [:unique, Registry.ViaTest])\n\n  Only registries with unique keys can be used in `:via`. If the name is\n  already taken, the case-specific `start_link` function (`Agent.start_link/2`\n  in the example above) will return `{:error, {:already_started, current_pid}}`.\n\n  ## Using as a dispatcher\n\n  `Registry` has a dispatch mechanism that allows developers to implement custom\n  dispatch logic triggered from the caller. For example, let's say we have a\n  duplicate registry started as so:\n\n      {:ok, _} = Registry.start_link(:duplicate, Registry.DispatcherTest)\n\n  By calling `register/3`, different processes can register under a given key\n  and associate any value under that key. In this case, let's register the\n  current process under the key `\"hello\"` and attach the `{IO, :inspect}` tuple\n  to it:\n\n      {:ok, _} = Registry.register(Registry.DispatcherTest, \"hello\", {IO, :inspect})\n\n  Now, an entity interested in dispatching events for a given key may call\n  `dispatch/3` passing in the key and a callback. This callback will be invoked\n  with a list of all the values registered under the requested key, alongside\n  the pid of the process that registered each value, in the form of `{pid,\n  value}` tuples. In our example, `value` will be the `{module, function}` tuple\n  in the code above:\n\n      Registry.dispatch(Registry.DispatcherTest, \"hello\", fn entries ->\n        for {pid, {module, function}} <- entries, do: apply(module, function, [pid])\n      end)\n      # Prints #PID<...> where the pid is for the process that called register/3 above\n      #=> :ok\n\n  Dispatching happens in the process that calls `dispatch/3` either serially or\n  concurrently in case of multiple partitions (via spawned tasks). The\n  registered processes are not involved in dispatching unless involving them is\n  done explicitly (for example, by sending them a message in the callback).\n\n  Furthermore, if there is a failure when dispatching, due to a bad\n  registration, dispatching will always fail and the registered process will not\n  be notified. Therefore let's make sure we at least wrap and report those\n  errors:\n\n      require Logger\n      Registry.dispatch(Registry.DispatcherTest, \"hello\", fn entries ->\n        for {pid, {module, function}} <- entries do\n          try do\n            apply(module, function, [pid])\n          catch\n            kind, reason ->\n              formatted = Exception.format(kind, reason, System.stacktrace)\n              Logger.error \"Registry.dispatch/3 failed with #{formatted}\"\n          end\n        end\n      end)\n      # Prints #PID<...>\n      #=> :ok\n\n  You could also replace the whole `apply` system by explicitly sending\n  messages. That's the example we will see next.\n\n  ## Using as a PubSub\n\n  Registries can also be used to implement a local, non-distributed, scalable\n  PubSub by relying on the `dispatch/3` function, similarly to the previous\n  section: in this case, however, we will send messages to each associated\n  process, instead of invoking a given module-function.\n\n  In this example, we will also set the number of partitions to the number of\n  schedulers online, which will make the registry more performant on highly\n  concurrent environments as each partition will spawn a new process, allowing\n  dispatching to happen in parallel:\n\n      {:ok, _} = Registry.start_link(:duplicate, Registry.PubSubTest,\n                                     partitions: System.schedulers_online)\n      {:ok, _} = Registry.register(Registry.PubSubTest, \"hello\", [])\n      Registry.dispatch(Registry.PubSubTest, \"hello\", fn entries ->\n        for {pid, _} <- entries, do: send(pid, {:broadcast, \"world\"})\n      end)\n      #=> :ok\n\n  The example above broadcasted the message `{:broadcast, \"world\"}` to all\n  processes registered under the \"topic\" (or \"key\" as we called it until now)\n  `\"hello\"`.\n\n  The third argument given to `register/3` is a value associated to the\n  current process. While in the previous section we used it when dispatching,\n  in this particular example we are not interested in it, so we have set it\n  to an empty list. You could store a more meaningful value if necessary.\n\n  ## Registrations\n\n  Looking up, dispatching and registering are efficient and immediate at\n  the cost of delayed unsubscription. For example, if a process crashes,\n  its keys are automatically removed from the registry but the change may\n  not propagate immediately. This means certain operations may return processes\n  that are already dead. When such may happen, it will be explicitly stated\n  in the function documentation.\n\n  However, keep in mind those cases are typically not an issue. After all, a\n  process referenced by a pid may crash at any time, including between getting\n  the value from the registry and sending it a message. Many parts of the standard\n  library are designed to cope with that, such as `Process.monitor/1` which will\n  deliver the `:DOWN` message immediately if the monitored process is already dead\n  and `Kernel.send/2` which acts as a no-op for dead processes.\n\n  ## ETS\n\n  Note that the registry uses one ETS table plus two ETS tables per partition.\n  ",
    dispatch = {
      description = "dispatch(registry, key, (entries :: [{pid, value}] -> term)) :: :ok\ndispatch(registry, key, mfa_or_fun)\n\n  Invokes the callback with all entries under `key` in each partition\n  for the given `registry`.\n\n  The list of `entries` is a non-empty list of two-element tuples where\n  the first element is the pid and the second element is the value\n  associated to the pid. If there are no entries for the given key,\n  the callback is never invoked.\n\n  If the registry is not partitioned, the callback is invoked in the process\n  that calls `dispatch/3`. If the registry is partitioned, the callback is\n  invoked concurrently per partition by starting a task linked to the\n  caller. The callback, however, is only invoked if there are entries for that\n  partition.\n\n  See the module documentation for examples of using the `dispatch/3`\n  function for building custom dispatching or a pubsub system.\n  "
    },
    key = {
      description = "key :: term\n"
    },
    keys = {
      description = "keys(registry, pid) :: [key]\nkeys(registry, pid) when is_atom(registry) and is_pid(pid)\n\n  Returns the known keys for the given `pid` in `registry` in no particular order.\n\n  If the registry is unique, the keys are unique. Otherwise\n  they may contain duplicates if the process was registered\n  under the same key multiple times. The list will be empty\n  if the process is dead or it has no keys in this registry.\n\n  ## Examples\n\n  Registering under a unique registry does not allow multiple entries:\n\n      iex> Registry.start_link(:unique, Registry.UniqueKeysTest)\n      iex> Registry.keys(Registry.UniqueKeysTest, self())\n      []\n      iex> {:ok, _} = Registry.register(Registry.UniqueKeysTest, \"hello\", :world)\n      iex> Registry.register(Registry.UniqueKeysTest, \"hello\", :later) # registry is :unique\n      {:error, {:already_registered, self()}}\n      iex> Registry.keys(Registry.UniqueKeysTest, self())\n      [\"hello\"]\n\n  Such is possible for duplicate registries though:\n\n      iex> Registry.start_link(:duplicate, Registry.DuplicateKeysTest)\n      iex> Registry.keys(Registry.DuplicateKeysTest, self())\n      []\n      iex> {:ok, _} = Registry.register(Registry.DuplicateKeysTest, \"hello\", :world)\n      iex> {:ok, _} = Registry.register(Registry.DuplicateKeysTest, \"hello\", :world)\n      iex> Registry.keys(Registry.DuplicateKeysTest, self())\n      [\"hello\", \"hello\"]\n\n  "
    },
    kind = {
      description = "kind :: :unique | :duplicate\n"
    },
    lookup = {
      description = "lookup(registry, key) :: [{pid, value}]\nlookup(registry, key) when is_atom(registry)\n\n  Finds the `{pid, value}` pair for the given `key` in `registry` in no particular order.\n\n  An empty list if there is no match.\n\n  For unique registries, a single partition lookup is necessary. For\n  duplicate registries, all partitions must be looked up.\n\n  ## Examples\n\n  In the example below we register the current process and look it up\n  both from itself and other processes:\n\n      iex> Registry.start_link(:unique, Registry.UniqueLookupTest)\n      iex> Registry.lookup(Registry.UniqueLookupTest, \"hello\")\n      []\n      iex> {:ok, _} = Registry.register(Registry.UniqueLookupTest, \"hello\", :world)\n      iex> Registry.lookup(Registry.UniqueLookupTest, \"hello\")\n      [{self(), :world}]\n      iex> Task.async(fn -> Registry.lookup(Registry.UniqueLookupTest, \"hello\") end) |> Task.await\n      [{self(), :world}]\n\n  The same applies to duplicate registries:\n\n      iex> Registry.start_link(:duplicate, Registry.DuplicateLookupTest)\n      iex> Registry.lookup(Registry.DuplicateLookupTest, \"hello\")\n      []\n      iex> {:ok, _} = Registry.register(Registry.DuplicateLookupTest, \"hello\", :world)\n      iex> Registry.lookup(Registry.DuplicateLookupTest, \"hello\")\n      [{self(), :world}]\n      iex> {:ok, _} = Registry.register(Registry.DuplicateLookupTest, \"hello\", :another)\n      iex> Enum.sort(Registry.lookup(Registry.DuplicateLookupTest, \"hello\"))\n      [{self(), :another}, {self(), :world}]\n\n  "
    },
    match = {
      description = "match(registry, key, match_pattern :: atom() | tuple()) :: [{pid, term}]\nmatch(registry, key, pattern) when is_atom(registry)\n\n  Returns `{pid, value}` pairs under the given `key` in `registry` that match `pattern`.\n\n  Pattern must be an atom or a tuple that will match the structure of the\n  value stored in the registry. The atom `:_` can be used to ignore a given\n  value or tuple element, while :\"$1\" can be used to temporarily assign part\n  of pattern to a variable for a subsequent comparison.\n\n  An empty list will be returned if there is no match.\n\n  For unique registries, a single partition lookup is necessary. For\n  duplicate registries, all partitions must be looked up.\n\n  ## Examples\n\n  In the example below we register the current process under the same\n  key in a duplicate registry but with different values:\n\n      iex> Registry.start_link(:duplicate, Registry.MatchTest)\n      iex> {:ok, _} = Registry.register(Registry.MatchTest, \"hello\", {1, :atom, 1})\n      iex> {:ok, _} = Registry.register(Registry.MatchTest, \"hello\", {2, :atom, 2})\n      iex> Registry.match(Registry.MatchTest, \"hello\", {1, :_, :_})\n      [{self(), {1, :atom, 1}}]\n      iex> Registry.match(Registry.MatchTest, \"hello\", {2, :_, :_})\n      [{self(), {2, :atom, 2}}]\n      iex> Registry.match(Registry.MatchTest, \"hello\", {:_, :atom, :_}) |> Enum.sort()\n      [{self(), {1, :atom, 1}}, {self(), {2, :atom, 2}}]\n      iex> Registry.match(Registry.MatchTest, \"hello\", {:\"$1\", :_, :\"$1\"}) |> Enum.sort()\n      [{self(), {1, :atom, 1}}, {self(), {2, :atom, 2}}]\n\n  "
    },
    meta = {
      description = "meta(registry, meta_key) :: {:ok, meta_value} | :error\nmeta(registry, key) when is_atom(registry) and (is_atom(key) or is_tuple(key))\n\n  Reads registry metadata given on `start_link/3`.\n\n  Atoms and tuples are allowed as keys.\n\n  ## Examples\n\n      iex> Registry.start_link(:unique, Registry.MetaTest, meta: [custom_key: \"custom_value\"])\n      iex> Registry.meta(Registry.MetaTest, :custom_key)\n      {:ok, \"custom_value\"}\n      iex> Registry.meta(Registry.MetaTest, :unknown_key)\n      :error\n\n  "
    },
    meta_key = {
      description = "meta_key :: atom | tuple\n"
    },
    meta_value = {
      description = "meta_value :: term\n"
    },
    put_meta = {
      description = "put_meta(registry, meta_key, meta_value) :: :ok\nput_meta(registry, key, value) when is_atom(registry) and (is_atom(key) or is_tuple(key))\n\n  Stores registry metadata.\n\n  Atoms and tuples are allowed as keys.\n\n  ## Examples\n\n      iex> Registry.start_link(:unique, Registry.PutMetaTest)\n      iex> Registry.put_meta(Registry.PutMetaTest, :custom_key, \"custom_value\")\n      :ok\n      iex> Registry.meta(Registry.PutMetaTest, :custom_key)\n      {:ok, \"custom_value\"}\n      iex> Registry.put_meta(Registry.PutMetaTest, {:tuple, :key}, \"tuple_value\")\n      :ok\n      iex> Registry.meta(Registry.PutMetaTest, {:tuple, :key})\n      {:ok, \"tuple_value\"}\n\n  "
    },
    register = {
      description = "register(registry, key, value) :: {:ok, pid} | {:error, {:already_registered, pid}}\nregister(registry, key, value) when is_atom(registry)\n\n  Registers the current process under the given `key` in `registry`.\n\n  A value to be associated with this registration must also be given.\n  This value will be retrieved whenever dispatching or doing a key\n  lookup.\n\n  This function returns `{:ok, owner}` or `{:error, reason}`.\n  The `owner` is the pid in the registry partition responsible for\n  the pid. The owner is automatically linked to the caller.\n\n  If the registry has unique keys, it will return `{:ok, owner}` unless\n  the key is already associated to a pid, in which case it returns\n  `{:error, {:already_registered, pid}}`.\n\n  If the registry has duplicate keys, multiple registrations from the\n  current process under the same key are allowed.\n\n  ## Examples\n\n  Registering under a unique registry does not allow multiple entries:\n\n      iex> Registry.start_link(:unique, Registry.UniqueRegisterTest)\n      iex> {:ok, _} = Registry.register(Registry.UniqueRegisterTest, \"hello\", :world)\n      iex> Registry.register(Registry.UniqueRegisterTest, \"hello\", :later)\n      {:error, {:already_registered, self()}}\n      iex> Registry.keys(Registry.UniqueRegisterTest, self())\n      [\"hello\"]\n\n  Such is possible for duplicate registries though:\n\n      iex> Registry.start_link(:duplicate, Registry.DuplicateRegisterTest)\n      iex> {:ok, _} = Registry.register(Registry.DuplicateRegisterTest, \"hello\", :world)\n      iex> {:ok, _} = Registry.register(Registry.DuplicateRegisterTest, \"hello\", :world)\n      iex> Registry.keys(Registry.DuplicateRegisterTest, self())\n      [\"hello\", \"hello\"]\n\n  "
    },
    register_name = {
      description = "register_name({registry, key}, pid) when pid == self()\nfalse"
    },
    registry = {
      description = "registry :: atom\n"
    },
    send = {
      description = "send({registry, key}, msg)\nfalse"
    },
    start_link = {
      description = "start_link(kind, registry, options) :: {:ok, pid} | {:error, term}\nstart_link(kind, registry, options \\\\ []) when kind in @kind and is_atom(registry)\n\n  Starts the registry as a supervisor process.\n\n  Manually it can be started as:\n\n      Registry.start_link(:unique, MyApp.Registry)\n\n  In your supervisor tree, you would write:\n\n      supervisor(Registry, [:unique, MyApp.Registry])\n\n  For intensive workloads, the registry may also be partitioned (by specifying\n  the `:partitions` option). If partitioning is required then a good default is to\n  set the number of partitions to the number of schedulers available:\n\n      Registry.start_link(:unique, MyApp.Registry, partitions: System.schedulers_online())\n\n  or:\n\n      supervisor(Registry, [:unique, MyApp.Registry, [partitions: System.schedulers_online()]])\n\n  ## Options\n\n  The registry supports the following options:\n\n    * `:partitions` - the number of partitions in the registry. Defaults to `1`.\n    * `:listeners` - a list of named processes which are notified of `:register`\n      and `:unregister` events. The registered process must be monitored by the\n      listener if the listener wants to be notified if the registered process\n      crashes.\n    * `:meta` - a keyword list of metadata to be attached to the registry.\n\n  "
    },
    unregister = {
      description = "unregister(registry, key) :: :ok\nunregister(registry, key) when is_atom(registry)\n\n  Unregisters all entries for the given `key` associated to the current\n  process in `registry`.\n\n  Always returns `:ok` and automatically unlinks the current process from\n  the owner if there are no more keys associated to the current process. See\n  also `register/3` to read more about the \"owner\".\n\n  ## Examples\n\n  For unique registries:\n\n      iex> Registry.start_link(:unique, Registry.UniqueUnregisterTest)\n      iex> Registry.register(Registry.UniqueUnregisterTest, \"hello\", :world)\n      iex> Registry.keys(Registry.UniqueUnregisterTest, self())\n      [\"hello\"]\n      iex> Registry.unregister(Registry.UniqueUnregisterTest, \"hello\")\n      :ok\n      iex> Registry.keys(Registry.UniqueUnregisterTest, self())\n      []\n\n  For duplicate registries:\n\n      iex> Registry.start_link(:duplicate, Registry.DuplicateUnregisterTest)\n      iex> Registry.register(Registry.DuplicateUnregisterTest, \"hello\", :world)\n      iex> Registry.register(Registry.DuplicateUnregisterTest, \"hello\", :world)\n      iex> Registry.keys(Registry.DuplicateUnregisterTest, self())\n      [\"hello\", \"hello\"]\n      iex> Registry.unregister(Registry.DuplicateUnregisterTest, \"hello\")\n      :ok\n      iex> Registry.keys(Registry.DuplicateUnregisterTest, self())\n      []\n\n  "
    },
    unregister_name = {
      description = "unregister_name({registry, key})\nfalse"
    },
    update_value = {
      description = "update_value(registry, key, (value -> value)) :: {new_value :: term, old_value :: term} | :error\nupdate_value(registry, key, callback) when is_atom(registry) and is_function(callback, 1)\n\n  Updates the value for `key` for the current process in the unique `registry`.\n\n  Returns a `{new_value, old_value}` tuple or `:error` if there\n  is no such key assigned to the current process.\n\n  If a non-unique registry is given, an error is raised.\n\n  ## Examples\n\n      iex> Registry.start_link(:unique, Registry.UpdateTest)\n      iex> {:ok, _} = Registry.register(Registry.UpdateTest, \"hello\", 1)\n      iex> Registry.lookup(Registry.UpdateTest, \"hello\")\n      [{self(), 1}]\n      iex> Registry.update_value(Registry.UpdateTest, \"hello\", & &1 + 1)\n      {2, 1}\n      iex> Registry.lookup(Registry.UpdateTest, \"hello\")\n      [{self(), 2}]\n\n  "
    },
    value = {
      description = "value :: term\n"
    },
    whereis_name = {
      description = "whereis_name({registry, key})\nfalse"
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
      description = "delete(set, value)\n"
    },
    description = "\n  WARNING: this module is deprecated.\n\n  Use the `MapSet` module instead.\n  ",
    difference = {
      description = "difference(set1, set2)\n"
    },
    ["disjoint?"] = {
      description = "disjoint?(set1, set2)\n"
    },
    empty = {
      description = "empty(set)\nfalse"
    },
    ["equal?"] = {
      description = "equal?(set1, set2)\nfalse"
    },
    intersection = {
      description = "intersection(set1, set2)\nfalse"
    },
    ["member?"] = {
      description = "member?(set, value)\nfalse"
    },
    put = {
      description = "put(set, value)\nfalse"
    },
    size = {
      description = "size(set)\nfalse"
    },
    ["subset?"] = {
      description = "subset?(set1, set2)\nfalse"
    },
    t = {
      description = "t :: map\n"
    },
    to_list = {
      description = "to_list(set)\nfalse"
    },
    union = {
      description = "union(set1, set2)\nfalse"
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
      description = "false"
    },
    acc = {
      description = "acc :: any\n"
    },
    chunk = {
      description = "chunk(Enumerable.t, pos_integer, pos_integer, Enumerable.t | nil) :: Enumerable.t\nchunk(enum, n, step, leftover \\\\ nil)\nchunk(Enumerable.t, pos_integer) :: Enumerable.t\nchunk(enum, n)\n\n  Shortcut to `chunk(enum, n, n)`.\n  "
    },
    chunk_by = {
      description = "chunk_by(Enumerable.t, (element -> any)) :: Enumerable.t\nchunk_by(enum, fun)\n\n  Chunks the `enum` by buffering elements for which `fun` returns\n  the same value and only emit them when `fun` returns a new value\n  or the `enum` finishes.\n\n  ## Examples\n\n      iex> stream = Stream.chunk_by([1, 2, 2, 3, 4, 4, 6, 7, 7], &(rem(&1, 2) == 1))\n      iex> Enum.to_list(stream)\n      [[1], [2, 2], [3], [4, 4, 6], [7, 7]]\n\n  "
    },
    concat = {
      description = "concat(Enumerable.t, Enumerable.t) :: Enumerable.t\nconcat(first, second)\nconcat(Enumerable.t) :: Enumerable.t\nconcat(enumerables)\n\n  Creates a stream that enumerates each enumerable in an enumerable.\n\n  ## Examples\n\n      iex> stream = Stream.concat([1..3, 4..6, 7..9])\n      iex> Enum.to_list(stream)\n      [1, 2, 3, 4, 5, 6, 7, 8, 9]\n\n  "
    },
    count = {
      description = "count(_lazy)\n\n  Emits a sequence of values for the given accumulator.\n\n  Successive values are generated by calling `next_fun` with the previous\n  accumulator and it must return a tuple with the current value and next\n  accumulator. The enumeration finishes if it returns `nil`.\n\n  ## Examples\n\n      iex> Stream.unfold(5, fn 0 -> nil; n -> {n, n-1} end) |> Enum.to_list()\n      [5, 4, 3, 2, 1]\n\n  "
    },
    cycle = {
      description = "cycle(enumerable)\ncycle(enumerable) when is_list(enumerable)\ncycle(Enumerable.t) :: Enumerable.t\ncycle(enumerable)\n\n  Creates a stream that cycles through the given enumerable,\n  infinitely.\n\n  ## Examples\n\n      iex> stream = Stream.cycle([1, 2, 3])\n      iex> Enum.take(stream, 5)\n      [1, 2, 3, 1, 2]\n\n  "
    },
    dedup = {
      description = "dedup(Enumerable.t) :: Enumerable.t\ndedup(enum)\n\n  Creates a stream that only emits elements if they are different from the last emitted element.\n\n  This function only ever needs to store the last emitted element.\n\n  Elements are compared using `===`.\n\n  ## Examples\n\n      iex> Stream.dedup([1, 2, 3, 3, 2, 1]) |> Enum.to_list\n      [1, 2, 3, 2, 1]\n\n  "
    },
    dedup_by = {
      description = "dedup_by(Enumerable.t, (element -> term)) :: Enumerable.t\ndedup_by(enum, fun) when is_function(fun, 1)\n\n  Creates a stream that only emits elements if the result of calling `fun` on the element is\n  different from the (stored) result of calling `fun` on the last emitted element.\n\n  ## Examples\n\n      iex> Stream.dedup_by([{1, :x}, {2, :y}, {2, :z}, {1, :x}], fn {x, _} -> x end) |> Enum.to_list\n      [{1, :x}, {2, :y}, {1, :x}]\n\n  "
    },
    default = {
      description = "default :: any\n"
    },
    description = "\n  Module for creating and composing streams.\n\n  Streams are composable, lazy enumerables. Any enumerable that generates\n  items one by one during enumeration is called a stream. For example,\n  Elixir's `Range` is a stream:\n\n      iex> range = 1..5\n      1..5\n      iex> Enum.map range, &(&1 * 2)\n      [2, 4, 6, 8, 10]\n\n  In the example above, as we mapped over the range, the elements being\n  enumerated were created one by one, during enumeration. The `Stream`\n  module allows us to map the range, without triggering its enumeration:\n\n      iex> range = 1..3\n      iex> stream = Stream.map(range, &(&1 * 2))\n      iex> Enum.map(stream, &(&1 + 1))\n      [3, 5, 7]\n\n  Notice we started with a range and then we created a stream that is\n  meant to multiply each item in the range by 2. At this point, no\n  computation was done. Only when `Enum.map/2` is called we actually\n  enumerate over each item in the range, multiplying it by 2 and adding 1.\n  We say the functions in `Stream` are *lazy* and the functions in `Enum`\n  are *eager*.\n\n  Due to their laziness, streams are useful when working with large\n  (or even infinite) collections. When chaining many operations with `Enum`,\n  intermediate lists are created, while `Stream` creates a recipe of\n  computations that are executed at a later moment. Let's see another\n  example:\n\n      1..3\n      |> Enum.map(&IO.inspect(&1))\n      |> Enum.map(&(&1 * 2))\n      |> Enum.map(&IO.inspect(&1))\n      1\n      2\n      3\n      2\n      4\n      6\n      #=> [2, 4, 6]\n\n  Notice that we first printed each item in the list, then multiplied each\n  element by 2 and finally printed each new value. In this example, the list\n  was enumerated three times. Let's see an example with streams:\n\n      stream = 1..3\n      |> Stream.map(&IO.inspect(&1))\n      |> Stream.map(&(&1 * 2))\n      |> Stream.map(&IO.inspect(&1))\n      Enum.to_list(stream)\n      1\n      2\n      2\n      4\n      3\n      6\n      #=> [2, 4, 6]\n\n  Although the end result is the same, the order in which the items were\n  printed changed! With streams, we print the first item and then print\n  its double. In this example, the list was enumerated just once!\n\n  That's what we meant when we said earlier that streams are composable,\n  lazy enumerables. Notice we could call `Stream.map/2` multiple times,\n  effectively composing the streams and keeping them lazy. The computations\n  are only performed when you call a function from the `Enum` module.\n\n  ## Creating Streams\n\n  There are many functions in Elixir's standard library that return\n  streams, some examples are:\n\n    * `IO.stream/2`         - streams input lines, one by one\n    * `URI.query_decoder/1` - decodes a query string, pair by pair\n\n  This module also provides many convenience functions for creating streams,\n  like `Stream.cycle/1`, `Stream.unfold/2`, `Stream.resource/3` and more.\n\n  Note the functions in this module are guaranteed to return enumerables.\n  Since enumerables can have different shapes (structs, anonymous functions,\n  and so on), the functions in this module may return any of those shapes\n  and that this may change at any time. For example, a function that today\n  returns an anonymous function may return a struct in future releases.\n  ",
    drop = {
      description = "drop(enum, n) when n < 0\ndrop(Enumerable.t, non_neg_integer) :: Enumerable.t\ndrop(enum, n) when n >= 0\n\n  Lazily drops the next `n` items from the enumerable.\n\n  If a negative `n` is given, it will drop the last `n` items from\n  the collection. Note that the mechanism by which this is implemented\n  will delay the emission of any item until `n` additional items have\n  been emitted by the enum.\n\n  ## Examples\n\n      iex> stream = Stream.drop(1..10, 5)\n      iex> Enum.to_list(stream)\n      [6, 7, 8, 9, 10]\n\n      iex> stream = Stream.drop(1..10, -5)\n      iex> Enum.to_list(stream)\n      [1, 2, 3, 4, 5]\n\n  "
    },
    drop_every = {
      description = "drop_every(enum, nth) when is_integer(nth) and nth > 0\ndrop_every([], _nth)\ndrop_every(enum, 0)\ndrop_every(Enumerable.t, non_neg_integer) :: Enumerable.t\ndrop_every(enum, nth)\n\n  Creates a stream that drops every `nth` item from the enumerable.\n\n  The first item is always dropped, unless `nth` is 0.\n\n  `nth` must be a non-negative integer.\n\n  ## Examples\n\n      iex> stream = Stream.drop_every(1..10, 2)\n      iex> Enum.to_list(stream)\n      [2, 4, 6, 8, 10]\n\n      iex> stream = Stream.drop_every(1..1000, 1)\n      iex> Enum.to_list(stream)\n      []\n\n      iex> stream = Stream.drop_every([1, 2, 3, 4, 5], 0)\n      iex> Enum.to_list(stream)\n      [1, 2, 3, 4, 5]\n\n  "
    },
    drop_while = {
      description = "drop_while(Enumerable.t, (element -> as_boolean(term))) :: Enumerable.t\ndrop_while(enum, fun)\n\n  Lazily drops elements of the enumerable while the given\n  function returns `true`.\n\n  ## Examples\n\n      iex> stream = Stream.drop_while(1..10, &(&1 <= 5))\n      iex> Enum.to_list(stream)\n      [6, 7, 8, 9, 10]\n\n  "
    },
    each = {
      description = "each(Enumerable.t, (element -> term)) :: Enumerable.t\neach(enum, fun) when is_function(fun, 1)\n\n  Executes the given function for each item.\n\n  Useful for adding side effects (like printing) to a stream.\n\n  ## Examples\n\n      iex> stream = Stream.each([1, 2, 3], fn(x) -> send self(), x end)\n      iex> Enum.to_list(stream)\n      iex> receive do: (x when is_integer(x) -> x)\n      1\n      iex> receive do: (x when is_integer(x) -> x)\n      2\n      iex> receive do: (x when is_integer(x) -> x)\n      3\n\n  "
    },
    element = {
      description = "element :: any\n"
    },
    filter = {
      description = "filter(Enumerable.t, (element -> as_boolean(term))) :: Enumerable.t\nfilter(enum, fun)\n\n  Creates a stream that filters elements according to\n  the given function on enumeration.\n\n  ## Examples\n\n      iex> stream = Stream.filter([1, 2, 3], fn(x) -> rem(x, 2) == 0 end)\n      iex> Enum.to_list(stream)\n      [2]\n\n  "
    },
    filter_map = {
      description = "filter_map(Enumerable.t, (element -> as_boolean(term)), (element -> any)) :: Enumerable.t\nfilter_map(enum, filter, mapper)\n\n  Creates a stream that filters and then maps elements according\n  to given functions.\n\n  Exists for symmetry with `Enum.filter_map/3`.\n\n  ## Examples\n\n      iex> stream = Stream.filter_map(1..6, fn(x) -> rem(x, 2) == 0 end, &(&1 * 2))\n      iex> Enum.to_list(stream)\n      [4, 8, 12]\n\n  "
    },
    flat_map = {
      description = "flat_map(Enumerable.t, (element -> Enumerable.t)) :: Enumerable.t\nflat_map(enum, mapper)\n\n  Maps the given `fun` over `enumerable` and flattens the result.\n\n  This function returns a new stream built by appending the result of invoking `fun`\n  on each element of `enumerable` together.\n\n  ## Examples\n\n      iex> stream = Stream.flat_map([1, 2, 3], fn(x) -> [x, x * 2] end)\n      iex> Enum.to_list(stream)\n      [1, 2, 2, 4, 3, 6]\n\n      iex> stream = Stream.flat_map([1, 2, 3], fn(x) -> [[x]] end)\n      iex> Enum.to_list(stream)\n      [[1], [2], [3]]\n\n  "
    },
    index = {
      description = "index :: non_neg_integer\n"
    },
    inspect = {
      description = "inspect(%{enum: enum, funs: funs}, opts)\n\n  Emits a sequence of values for the given accumulator.\n\n  Successive values are generated by calling `next_fun` with the previous\n  accumulator and it must return a tuple with the current value and next\n  accumulator. The enumeration finishes if it returns `nil`.\n\n  ## Examples\n\n      iex> Stream.unfold(5, fn 0 -> nil; n -> {n, n-1} end) |> Enum.to_list()\n      [5, 4, 3, 2, 1]\n\n  "
    },
    interval = {
      description = "interval(non_neg_integer) :: Enumerable.t\ninterval(n)\n\n  Creates a stream that emits a value after the given period `n`\n  in milliseconds.\n\n  The values emitted are an increasing counter starting at `0`.\n  This operation will block the caller by the given interval\n  every time a new item is streamed.\n\n  Do not use this function to generate a sequence of numbers.\n  If blocking the caller process is not necessary, use\n  `Stream.iterate(0, & &1 + 1)` instead.\n\n  ## Examples\n\n      iex> Stream.interval(10) |> Enum.take(10)\n      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]\n\n  "
    },
    into = {
      description = "into(Enumerable.t, Collectable.t, (term -> term)) :: Enumerable.t\ninto(enum, collectable, transform \\\\ fn x -> x end) when is_function(transform, 1)\n\n  Injects the stream values into the given collectable as a side-effect.\n\n  This function is often used with `run/1` since any evaluation\n  is delayed until the stream is executed. See `run/1` for an example.\n  "
    },
    iterate = {
      description = "iterate(element, (element -> element)) :: Enumerable.t\niterate(start_value, next_fun)\n\n  Emits a sequence of values, starting with `start_value`. Successive\n  values are generated by calling `next_fun` on the previous value.\n\n  ## Examples\n\n      iex> Stream.iterate(0, &(&1+1)) |> Enum.take(5)\n      [0, 1, 2, 3, 4]\n\n  "
    },
    map = {
      description = "map(Enumerable.t, (element -> any)) :: Enumerable.t\nmap(enum, fun)\n\n  Creates a stream that will apply the given function on\n  enumeration.\n\n  ## Examples\n\n      iex> stream = Stream.map([1, 2, 3], fn(x) -> x * 2 end)\n      iex> Enum.to_list(stream)\n      [2, 4, 6]\n\n  "
    },
    map_every = {
      description = "map_every(enum, nth, fun) when is_integer(nth) and nth > 0\nmap_every([], _nth, _fun)\nmap_every(enum, 0, _fun)\nmap_every(enum, 1, fun)\nmap_every(Enumerable.t, non_neg_integer, (element -> any)) :: Enumerable.t\nmap_every(enum, nth, fun)\n\n  Creates a stream that will apply the given function on\n  every `nth` item from the enumerable.\n\n  The first item is always passed to the given function.\n\n  `nth` must be a non-negative integer.\n\n  ## Examples\n\n      iex> stream = Stream.map_every(1..10, 2, fn(x) -> x * 2 end)\n      iex> Enum.to_list(stream)\n      [2, 2, 6, 4, 10, 6, 14, 8, 18, 10]\n\n      iex> stream = Stream.map_every([1, 2, 3, 4, 5], 1, fn(x) -> x * 2 end)\n      iex> Enum.to_list(stream)\n      [2, 4, 6, 8, 10]\n\n      iex> stream = Stream.map_every(1..5, 0, fn(x) -> x * 2 end)\n      iex> Enum.to_list(stream)\n      [1, 2, 3, 4, 5]\n\n  "
    },
    ["member?"] = {
      description = "member?(_lazy, _value)\n\n  Emits a sequence of values for the given accumulator.\n\n  Successive values are generated by calling `next_fun` with the previous\n  accumulator and it must return a tuple with the current value and next\n  accumulator. The enumeration finishes if it returns `nil`.\n\n  ## Examples\n\n      iex> Stream.unfold(5, fn 0 -> nil; n -> {n, n-1} end) |> Enum.to_list()\n      [5, 4, 3, 2, 1]\n\n  "
    },
    reduce = {
      description = "reduce(lazy, acc, fun)\n\n  Emits a sequence of values for the given accumulator.\n\n  Successive values are generated by calling `next_fun` with the previous\n  accumulator and it must return a tuple with the current value and next\n  accumulator. The enumeration finishes if it returns `nil`.\n\n  ## Examples\n\n      iex> Stream.unfold(5, fn 0 -> nil; n -> {n, n-1} end) |> Enum.to_list()\n      [5, 4, 3, 2, 1]\n\n  "
    },
    reject = {
      description = "reject(Enumerable.t, (element -> as_boolean(term))) :: Enumerable.t\nreject(enum, fun)\n\n  Creates a stream that will reject elements according to\n  the given function on enumeration.\n\n  ## Examples\n\n      iex> stream = Stream.reject([1, 2, 3], fn(x) -> rem(x, 2) == 0 end)\n      iex> Enum.to_list(stream)\n      [1, 3]\n\n  "
    },
    repeatedly = {
      description = "repeatedly((() -> element)) :: Enumerable.t\nrepeatedly(generator_fun) when is_function(generator_fun, 0)\n\n  Returns a stream generated by calling `generator_fun` repeatedly.\n\n  ## Examples\n\n      # Although not necessary, let's seed the random algorithm\n      iex> :rand.seed(:exsplus, {1, 2, 3})\n      iex> Stream.repeatedly(&:rand.uniform/0) |> Enum.take(3)\n      [0.40502929729990744, 0.45336720247823126, 0.04094511692041057]\n\n  "
    },
    resource = {
      description = "resource((() -> acc), (acc -> {[element], acc} | {:halt, acc}), (acc -> term)) :: Enumerable.t\nresource(start_fun, next_fun, after_fun)\n\n  Emits a sequence of values for the given resource.\n\n  Similar to `transform/3` but the initial accumulated value is\n  computed lazily via `start_fun` and executes an `after_fun` at\n  the end of enumeration (both in cases of success and failure).\n\n  Successive values are generated by calling `next_fun` with the\n  previous accumulator (the initial value being the result returned\n  by `start_fun`) and it must return a tuple containing a list\n  of items to be emitted and the next accumulator. The enumeration\n  finishes if it returns `{:halt, acc}`.\n\n  As the name says, this function is useful to stream values from\n  resources.\n\n  ## Examples\n\n      Stream.resource(fn -> File.open!(\"sample\") end,\n                      fn file ->\n                        case IO.read(file, :line) do\n                          data when is_binary(data) -> {[data], file}\n                          _ -> {:halt, file}\n                        end\n                      end,\n                      fn file -> File.close(file) end)\n\n  "
    },
    run = {
      description = "run(Enumerable.t) :: :ok\nrun(stream)\n\n  Runs the given stream.\n\n  This is useful when a stream needs to be run, for side effects,\n  and there is no interest in its return result.\n\n  ## Examples\n\n  Open up a file, replace all `#` by `%` and stream to another file\n  without loading the whole file in memory:\n\n      stream = File.stream!(\"code\")\n      |> Stream.map(&String.replace(&1, \"#\", \"%\"))\n      |> Stream.into(File.stream!(\"new\"))\n      |> Stream.run\n\n  No computation will be done until we call one of the Enum functions\n  or `Stream.run/1`.\n  "
    },
    scan = {
      description = "scan(Enumerable.t, acc, (element, acc -> any)) :: Enumerable.t\nscan(enum, acc, fun)\nscan(Enumerable.t, (element, acc -> any)) :: Enumerable.t\nscan(enum, fun)\n\n  Creates a stream that applies the given function to each\n  element, emits the result and uses the same result as the accumulator\n  for the next computation.\n\n  ## Examples\n\n      iex> stream = Stream.scan(1..5, &(&1 + &2))\n      iex> Enum.to_list(stream)\n      [1, 3, 6, 10, 15]\n\n  "
    },
    take = {
      description = "take(enum, count) when is_integer(count) and count < 0\ntake(enum, count) when is_integer(count) and count > 0\ntake([], _count)\ntake(Enumerable.t, integer) :: Enumerable.t\ntake(_enum, 0)\n\n  Lazily takes the next `count` items from the enumerable and stops\n  enumeration.\n\n  If a negative `count` is given, the last `count` values will be taken.\n  For such, the collection is fully enumerated keeping up to `2 * count`\n  elements in memory. Once the end of the collection is reached,\n  the last `count` elements will be executed. Therefore, using\n  a negative `count` on an infinite collection will never return.\n\n  ## Examples\n\n      iex> stream = Stream.take(1..100, 5)\n      iex> Enum.to_list(stream)\n      [1, 2, 3, 4, 5]\n\n      iex> stream = Stream.take(1..100, -5)\n      iex> Enum.to_list(stream)\n      [96, 97, 98, 99, 100]\n\n      iex> stream = Stream.cycle([1, 2, 3]) |> Stream.take(5)\n      iex> Enum.to_list(stream)\n      [1, 2, 3, 1, 2]\n\n  "
    },
    take_every = {
      description = "take_every(enum, nth) when is_integer(nth) and nth > 0\ntake_every([], _nth)\ntake_every(_enum, 0)\ntake_every(Enumerable.t, non_neg_integer) :: Enumerable.t\ntake_every(enum, nth)\n\n  Creates a stream that takes every `nth` item from the enumerable.\n\n  The first item is always included, unless `nth` is 0.\n\n  `nth` must be a non-negative integer.\n\n  ## Examples\n\n      iex> stream = Stream.take_every(1..10, 2)\n      iex> Enum.to_list(stream)\n      [1, 3, 5, 7, 9]\n\n      iex> stream = Stream.take_every([1, 2, 3, 4, 5], 1)\n      iex> Enum.to_list(stream)\n      [1, 2, 3, 4, 5]\n\n      iex> stream = Stream.take_every(1..1000, 0)\n      iex> Enum.to_list(stream)\n      []\n\n  "
    },
    take_while = {
      description = "take_while(Enumerable.t, (element -> as_boolean(term))) :: Enumerable.t\ntake_while(enum, fun)\n\n  Lazily takes elements of the enumerable while the given\n  function returns `true`.\n\n  ## Examples\n\n      iex> stream = Stream.take_while(1..100, &(&1 <= 5))\n      iex> Enum.to_list(stream)\n      [1, 2, 3, 4, 5]\n\n  "
    },
    timer = {
      description = "timer(non_neg_integer) :: Enumerable.t\ntimer(n)\n\n  Creates a stream that emits a single value after `n` milliseconds.\n\n  The value emitted is `0`. This operation will block the caller by\n  the given time until the item is streamed.\n\n  ## Examples\n\n      iex> Stream.timer(10) |> Enum.to_list\n      [0]\n\n  "
    },
    transform = {
      description = "transform(Enumerable.t, (() -> acc), fun, (acc -> term)) :: Enumerable.t\ntransform(enum, start_fun, reducer, after_fun)\ntransform(Enumerable.t, acc, fun) :: Enumerable.t\ntransform(enum, acc, reducer) when is_function(reducer, 2)\n\n  Transforms an existing stream.\n\n  It expects an accumulator and a function that receives each stream item\n  and an accumulator, and must return a tuple containing a new stream\n  (often a list) with the new accumulator or a tuple with `:halt` as first\n  element and the accumulator as second.\n\n  Note: this function is similar to `Enum.flat_map_reduce/3` except the\n  latter returns both the flat list and accumulator, while this one returns\n  only the stream.\n\n  ## Examples\n\n  `Stream.transform/3` is useful as it can be used as the basis to implement\n  many of the functions defined in this module. For example, we can implement\n  `Stream.take(enum, n)` as follows:\n\n      iex> enum = 1..100\n      iex> n = 3\n      iex> stream = Stream.transform(enum, 0, fn i, acc ->\n      ...>   if acc < n, do: {[i], acc + 1}, else: {:halt, acc}\n      ...> end)\n      iex> Enum.to_list(stream)\n      [1, 2, 3]\n\n  "
    },
    unfold = {
      description = "unfold(acc, (acc -> {element, acc} | nil)) :: Enumerable.t\nunfold(next_acc, next_fun)\n\n  Emits a sequence of values for the given accumulator.\n\n  Successive values are generated by calling `next_fun` with the previous\n  accumulator and it must return a tuple with the current value and next\n  accumulator. The enumeration finishes if it returns `nil`.\n\n  ## Examples\n\n      iex> Stream.unfold(5, fn 0 -> nil; n -> {n, n-1} end) |> Enum.to_list()\n      [5, 4, 3, 2, 1]\n\n  "
    },
    uniq = {
      description = "uniq(enum, fun)\nuniq(Enumerable.t) :: Enumerable.t\nuniq(enum)\n\n  Creates a stream that only emits elements if they are unique.\n\n  Keep in mind that, in order to know if an element is unique\n  or not, this function needs to store all unique values emitted\n  by the stream. Therefore, if the stream is infinite, the number\n  of items stored will grow infinitely, never being garbage collected.\n\n  ## Examples\n\n      iex> Stream.uniq([1, 2, 3, 3, 2, 1]) |> Enum.to_list\n      [1, 2, 3]\n\n  "
    },
    uniq_by = {
      description = "uniq_by(Enumerable.t, (element -> term)) :: Enumerable.t\nuniq_by(enum, fun)\n\n  Creates a stream that only emits elements if they are unique, by removing the\n  elements for which function `fun` returned duplicate items.\n\n  The function `fun` maps every element to a term which is used to\n  determine if two elements are duplicates.\n\n  Keep in mind that, in order to know if an element is unique\n  or not, this function needs to store all unique values emitted\n  by the stream. Therefore, if the stream is infinite, the number\n  of items stored will grow infinitely, never being garbage collected.\n\n  ## Example\n\n      iex> Stream.uniq_by([{1, :x}, {2, :y}, {1, :z}], fn {x, _} -> x end) |> Enum.to_list\n      [{1, :x}, {2, :y}]\n\n      iex> Stream.uniq_by([a: {:tea, 2}, b: {:tea, 2}, c: {:coffee, 1}], fn {_, y} -> y end) |> Enum.to_list\n      [a: {:tea, 2}, c: {:coffee, 1}]\n\n  "
    },
    with_index = {
      description = "with_index(Enumerable.t, integer) :: Enumerable.t\nwith_index(enum, offset \\\\ 0)\n\n  Creates a stream where each item in the enumerable will\n  be wrapped in a tuple alongside its index.\n\n  If an `offset` is given, we will index from the given offset instead of from zero.\n\n  ## Examples\n\n      iex> stream = Stream.with_index([1, 2, 3])\n      iex> Enum.to_list(stream)\n      [{1, 0}, {2, 1}, {3, 2}]\n\n      iex> stream = Stream.with_index([1, 2, 3], 3)\n      iex> Enum.to_list(stream)\n      [{1, 3}, {2, 4}, {3, 5}]\n\n  "
    },
    zip = {
      description = "zip([Enumerable.t]) :: Enumerable.t\nzip(enumerables)\nzip(Enumerable.t, Enumerable.t) :: Enumerable.t\nzip(left, right)\n\n  Zips two collections together, lazily.\n\n  The zipping finishes as soon as any enumerable completes.\n\n  ## Examples\n\n      iex> concat = Stream.concat(1..3, 4..6)\n      iex> cycle  = Stream.cycle([:a, :b, :c])\n      iex> Stream.zip(concat, cycle) |> Enum.to_list\n      [{1, :a}, {2, :b}, {3, :c}, {4, :a}, {5, :b}, {6, :c}]\n\n  "
    }
  },
  String = {
    Chars = {
      description = "\n  The `String.Chars` protocol is responsible for\n  converting a structure to a binary (only if applicable).\n  The only function required to be implemented is\n  `to_string` which does the conversion.\n\n  The `to_string/1` function automatically imported\n  by `Kernel` invokes this protocol. String\n  interpolation also invokes `to_string` in its\n  arguments. For example, `\"foo#{bar}\"` is the same\n  as `\"foo\" <> to_string(bar)`.\n  ",
      to_string = {
        description = "to_string(term)\nto_string(term)\nto_string(charlist)\nto_string(term)\nto_string(term) when is_binary(term)\nto_string(atom)\nto_string(nil)\nto_string(term)\n"
      }
    },
    at = {
      description = "at(string, position) when is_integer(position) and position < 0\nat(t, integer) :: grapheme | nil\nat(string, position) when is_integer(position) and position >= 0\n\n  Returns the grapheme at the `position` of the given UTF-8 `string`.\n  If `position` is greater than `string` length, then it returns `nil`.\n\n  ## Examples\n\n      iex> String.at(\"elixir\", 0)\n      \"e\"\n\n      iex> String.at(\"elixir\", 1)\n      \"l\"\n\n      iex> String.at(\"elixir\", 10)\n      nil\n\n      iex> String.at(\"elixir\", -1)\n      \"r\"\n\n      iex> String.at(\"elixir\", -10)\n      nil\n\n  "
    },
    capitalize = {
      description = "capitalize(t) :: t\ncapitalize(string) when is_binary(string)\n\n  Converts the first character in the given string to\n  uppercase and the remainder to lowercase.\n\n  This relies on the titlecase information provided\n  by the Unicode Standard. Note this function makes\n  no attempt to capitalize all words in the string\n  (usually known as titlecase).\n\n  ## Examples\n\n      iex> String.capitalize(\"abcd\")\n      \"Abcd\"\n\n      iex> String.capitalize(\"ﬁn\")\n      \"Fin\"\n\n      iex> String.capitalize(\"olá\")\n      \"Olá\"\n\n  "
    },
    chunk = {
      description = "chunk(string, trait) when trait in [:valid, :printable]\nchunk(\"\", _)\nchunk(t, :valid | :printable) :: [t]\nchunk(string, trait)\n\n  Splits the string into chunks of characters that share a common trait.\n\n  The trait can be one of two options:\n\n    * `:valid` - the string is split into chunks of valid and invalid\n      character sequences\n\n    * `:printable` - the string is split into chunks of printable and\n      non-printable character sequences\n\n  Returns a list of binaries each of which contains only one kind of\n  characters.\n\n  If the given string is empty, an empty list is returned.\n\n  ## Examples\n\n      iex> String.chunk(<<?a, ?b, ?c, 0>>, :valid)\n      [\"abc\\0\"]\n\n      iex> String.chunk(<<?a, ?b, ?c, 0, 0x0FFFF::utf8>>, :valid)\n      [\"abc\\0\", <<0x0FFFF::utf8>>]\n\n      iex> String.chunk(<<?a, ?b, ?c, 0, 0x0FFFF::utf8>>, :printable)\n      [\"abc\", <<0, 0x0FFFF::utf8>>]\n\n  "
    },
    codepoint = {
      description = "codepoint :: t\n"
    },
    ["contains?"] = {
      description = "contains?(string, contents) when is_binary(string)\ncontains?(string, contents) when is_binary(string) and is_list(contents)\ncontains?(t, pattern) :: boolean\ncontains?(string, []) when is_binary(string)\n\n  Checks if `string` contains any of the given `contents`.\n\n  `contents` can be either a single string or a list of strings.\n\n  ## Examples\n\n      iex> String.contains? \"elixir of life\", \"of\"\n      true\n      iex> String.contains? \"elixir of life\", [\"life\", \"death\"]\n      true\n      iex> String.contains? \"elixir of life\", [\"death\", \"mercury\"]\n      false\n\n  An empty string will always match:\n\n      iex> String.contains? \"elixir of life\", \"\"\n      true\n      iex> String.contains? \"elixir of life\", [\"\", \"other\"]\n      true\n\n  The argument can also be a precompiled pattern:\n\n      iex> pattern = :binary.compile_pattern([\"life\", \"death\"])\n      iex> String.contains? \"elixir of life\", pattern\n      true\n\n  "
    },
    description = "\n  A String in Elixir is a UTF-8 encoded binary.\n\n  ## Codepoints and grapheme cluster\n\n  The functions in this module act according to the Unicode\n  Standard, version 9.0.0.\n\n  As per the standard, a codepoint is a single Unicode Character,\n  which may be represented by one or more bytes.\n\n  For example, the codepoint \"é\" is two bytes:\n\n      iex> byte_size(\"é\")\n      2\n\n  However, this module returns the proper length:\n\n      iex> String.length(\"é\")\n      1\n\n  Furthermore, this module also presents the concept of grapheme cluster\n  (from now on referenced as graphemes). Graphemes can consist of multiple\n  codepoints that may be perceived as a single character by readers. For\n  example, \"é\" can be represented either as a single \"e with acute\" codepoint\n  or as the letter \"e\" followed by a \"combining acute accent\" (two codepoints):\n\n      iex> string = \"\\u0065\\u0301\"\n      iex> byte_size(string)\n      3\n      iex> String.length(string)\n      1\n      iex> String.codepoints(string)\n      [\"e\", \"́\"]\n      iex> String.graphemes(string)\n      [\"é\"]\n\n  Although the example above is made of two characters, it is\n  perceived by users as one.\n\n  Graphemes can also be two characters that are interpreted\n  as one by some languages. For example, some languages may\n  consider \"ch\" as a single character. However, since this\n  information depends on the locale, it is not taken into account\n  by this module.\n\n  In general, the functions in this module rely on the Unicode\n  Standard, but do not contain any of the locale specific behaviour.\n\n  More information about graphemes can be found in the [Unicode\n  Standard Annex #29](http://www.unicode.org/reports/tr29/).\n  The current Elixir version implements Extended Grapheme Cluster\n  algorithm.\n\n  ## String and binary operations\n\n  To act according to the Unicode Standard, many functions\n  in this module run in linear time, as they need to traverse\n  the whole string considering the proper Unicode codepoints.\n\n  For example, `String.length/1` will take longer as\n  the input grows. On the other hand, `Kernel.byte_size/1` always runs\n  in constant time (i.e. regardless of the input size).\n\n  This means often there are performance costs in using the\n  functions in this module, compared to the more low-level\n  operations that work directly with binaries:\n\n    * `Kernel.binary_part/3` - retrieves part of the binary\n    * `Kernel.bit_size/1` and `Kernel.byte_size/1` - size related functions\n    * `Kernel.is_bitstring/1` and `Kernel.is_binary/1` - type checking function\n    * Plus a number of functions for working with binaries (bytes)\n      in the [`:binary` module](http://www.erlang.org/doc/man/binary.html)\n\n  There are many situations where using the `String` module can\n  be avoided in favor of binary functions or pattern matching.\n  For example, imagine you have a string `prefix` and you want to\n  remove this prefix from another string named `full`.\n\n  One may be tempted to write:\n\n      iex> take_prefix = fn full, prefix ->\n      ...>   base = String.length(prefix)\n      ...>   String.slice(full, base, String.length(full) - base)\n      ...> end\n      iex> take_prefix.(\"Mr. John\", \"Mr. \")\n      \"John\"\n\n  Although the function above works, it performs poorly. To\n  calculate the length of the string, we need to traverse it\n  fully, so we traverse both `prefix` and `full` strings, then\n  slice the `full` one, traversing it again.\n\n  A first attempt at improving it could be with ranges:\n\n      iex> take_prefix = fn full, prefix ->\n      ...>   base = String.length(prefix)\n      ...>   String.slice(full, base..-1)\n      ...> end\n      iex> take_prefix.(\"Mr. John\", \"Mr. \")\n      \"John\"\n\n  While this is much better (we don't traverse `full` twice),\n  it could still be improved. In this case, since we want to\n  extract a substring from a string, we can use `Kernel.byte_size/1`\n  and `Kernel.binary_part/3` as there is no chance we will slice in\n  the middle of a codepoint made of more than one byte:\n\n      iex> take_prefix = fn full, prefix ->\n      ...>   base = byte_size(prefix)\n      ...>   binary_part(full, base, byte_size(full) - base)\n      ...> end\n      iex> take_prefix.(\"Mr. John\", \"Mr. \")\n      \"John\"\n\n  Or simply use pattern matching:\n\n      iex> take_prefix = fn full, prefix ->\n      ...>   base = byte_size(prefix)\n      ...>   <<_::binary-size(base), rest::binary>> = full\n      ...>   rest\n      ...> end\n      iex> take_prefix.(\"Mr. John\", \"Mr. \")\n      \"John\"\n\n  On the other hand, if you want to dynamically slice a string\n  based on an integer value, then using `String.slice/3` is the\n  best option as it guarantees we won't incorrectly split a valid\n  codepoint into multiple bytes.\n\n  ## Integer codepoints\n\n  Although codepoints could be represented as integers, this\n  module represents all codepoints as strings. For example:\n\n      iex> String.codepoints(\"olá\")\n      [\"o\", \"l\", \"á\"]\n\n  There are a couple of ways to retrieve a character integer\n  codepoint. One may use the `?` construct:\n\n      iex> ?o\n      111\n\n      iex> ?á\n      225\n\n  Or also via pattern matching:\n\n      iex> <<aacute::utf8>> = \"á\"\n      iex> aacute\n      225\n\n  As we have seen above, codepoints can be inserted into\n  a string by their hexadecimal code:\n\n      \"ol\\u0061\\u0301\" #=>\n      \"olá\"\n\n  ## Self-synchronization\n\n  The UTF-8 encoding is self-synchronizing. This means that\n  if malformed data (i.e., data that is not possible according\n  to the definition of the encoding) is encountered, only one\n  codepoint needs to be rejected.\n\n  This module relies on this behaviour to ignore such invalid\n  characters. For example, `length/1` will return\n  a correct result even if an invalid codepoint is fed into it.\n\n  In other words, this module expects invalid data to be detected\n  elsewhere, usually when retrieving data from the external source.\n  For example, a driver that reads strings from a database will be\n  responsible to check the validity of the encoding. `String.chunk/2`\n  can be used for breaking a string into valid and invalid parts.\n\n  ## Patterns\n\n  Many functions in this module work with patterns. For example,\n  `String.split/2` can split a string into multiple patterns given\n  a pattern. This pattern can be a string, a list of strings or\n  a compiled pattern:\n\n      iex> String.split(\"foo bar\", \" \")\n      [\"foo\", \"bar\"]\n\n      iex> String.split(\"foo bar!\", [\" \", \"!\"])\n      [\"foo\", \"bar\", \"\"]\n\n      iex> pattern = :binary.compile_pattern([\" \", \"!\"])\n      iex> String.split(\"foo bar!\", pattern)\n      [\"foo\", \"bar\", \"\"]\n\n  The compiled pattern is useful when the same match will\n  be done over and over again. Note though the compiled\n  pattern cannot be stored in a module attribute as the pattern\n  is generated at runtime and does not survive compile term.\n  ",
    duplicate = {
      description = "duplicate(t, non_neg_integer) :: t\nduplicate(subject, n) when is_integer(n) and n >= 0\n\n  Returns a string `subject` duplicated `n` times.\n\n  ## Examples\n\n      iex> String.duplicate(\"abc\", 0)\n      \"\"\n\n      iex> String.duplicate(\"abc\", 1)\n      \"abc\"\n\n      iex> String.duplicate(\"abc\", 2)\n      \"abcabc\"\n\n  "
    },
    ["ends_with?"] = {
      description = "ends_with?(string, suffix) when is_binary(string)\nends_with?(t, t | [t]) :: boolean\nends_with?(string, suffixes) when is_binary(string) and is_list(suffixes)\n\n  Returns `true` if `string` ends with any of the suffixes given.\n\n  `suffixes` can be either a single suffix or a list of suffixes.\n\n  ## Examples\n\n      iex> String.ends_with? \"language\", \"age\"\n      true\n      iex> String.ends_with? \"language\", [\"youth\", \"age\"]\n      true\n      iex> String.ends_with? \"language\", [\"youth\", \"elixir\"]\n      false\n\n  An empty suffix will always match:\n\n      iex> String.ends_with? \"language\", \"\"\n      true\n      iex> String.ends_with? \"language\", [\"\", \"other\"]\n      true\n\n  "
    },
    ["equivalent?"] = {
      description = "equivalent?(t, t) :: boolean\nequivalent?(string1, string2)\n\n  Returns `true` if `string1` is canonically equivalent to 'string2'.\n\n  It performs Normalization Form Canonical Decomposition (NFD) on the\n  strings before comparing them. This function is equivalent to:\n\n      String.normalize(string1, :nfd) == String.normalize(string2, :nfd)\n\n  Therefore, if you plan to compare multiple strings, multiple times\n  in a row, you may normalize them upfront and compare them directly\n  to avoid multiple normalization passes.\n\n  ## Examples\n\n      iex> String.equivalent?(\"abc\", \"abc\")\n      true\n\n      iex> String.equivalent?(\"man\\u0303ana\", \"mañana\")\n      true\n\n      iex> String.equivalent?(\"abc\", \"ABC\")\n      false\n\n      iex> String.equivalent?(\"nø\", \"nó\")\n      false\n\n  "
    },
    first = {
      description = "first(t) :: grapheme | nil\nfirst(string)\n\n  Returns the first grapheme from a UTF-8 string,\n  `nil` if the string is empty.\n\n  ## Examples\n\n      iex> String.first(\"elixir\")\n      \"e\"\n\n      iex> String.first(\"եոգլի\")\n      \"ե\"\n\n  "
    },
    grapheme = {
      description = "grapheme :: t\n"
    },
    jaro_distance = {
      description = "jaro_distance(string1, string2)\njaro_distance(\"\", _string)\njaro_distance(_string, \"\")\njaro_distance(string, string)\njaro_distance(t, t) :: float\njaro_distance(string1, string2)\n\n  Returns a float value between 0 (equates to no similarity) and 1 (is an exact match)\n  representing [Jaro](https://en.wikipedia.org/wiki/Jaro–Winkler_distance)\n  distance between `string1` and `string2`.\n\n  The Jaro distance metric is designed and best suited for short strings such as person names.\n\n  ## Examples\n\n      iex> String.jaro_distance(\"dwayne\", \"duane\")\n      0.8222222222222223\n      iex> String.jaro_distance(\"even\", \"odd\")\n      0.0\n\n  "
    },
    last = {
      description = "last(t) :: grapheme | nil\nlast(string)\n\n  Returns the last grapheme from a UTF-8 string,\n  `nil` if the string is empty.\n\n  ## Examples\n\n      iex> String.last(\"elixir\")\n      \"r\"\n\n      iex> String.last(\"եոգլի\")\n      \"ի\"\n\n  "
    },
    ljust = {
      description = "ljust(subject, len, pad \\\\ ?\\s) when is_integer(pad) and is_integer(len) and len >= 0\nfalse"
    },
    lstrip = {
      description = "lstrip(string, char) when is_integer(char)\nfalse"
    },
    ["match?"] = {
      description = "match?(t, Regex.t) :: boolean\nmatch?(string, regex)\n\n  Checks if `string` matches the given regular expression.\n\n  ## Examples\n\n      iex> String.match?(\"foo\", ~r/foo/)\n      true\n\n      iex> String.match?(\"bar\", ~r/foo/)\n      false\n\n  "
    },
    myers_difference = {
      description = "myers_difference(t, t) :: [{:eq | :ins | :del, t}] | nil\nmyers_difference(string1, string2)\n\n  Returns a keyword list that represents an edit script.\n\n  Check `List.myers_difference/2` for more information.\n\n  ## Examples\n\n      iex> string1 = \"fox hops over the dog\"\n      iex> string2 = \"fox jumps over the lazy cat\"\n      iex> String.myers_difference(string1, string2)\n      [eq: \"fox \", del: \"ho\", ins: \"jum\", eq: \"ps over the \", del: \"dog\", ins: \"lazy cat\"]\n\n  "
    },
    next_grapheme = {
      description = "next_grapheme(t) :: {grapheme, t} | nil\nnext_grapheme(binary)\n\n  Returns the next grapheme in a string.\n\n  The result is a tuple with the grapheme and the\n  remainder of the string or `nil` in case\n  the String reached its end.\n\n  ## Examples\n\n      iex> String.next_grapheme(\"olá\")\n      {\"o\", \"lá\"}\n\n  "
    },
    pad_leading = {
      description = "pad_leading(string, count, [_ | _] = padding)\npad_leading(string, count, padding) when is_binary(padding)\npad_leading(t, non_neg_integer, t | [t]) :: t\npad_leading(string, count, padding \\\\ [\" \"])\n\n  Returns a new string padded with a leading filler\n  which is made of elements from the `padding`.\n\n  Passing a list of strings as `padding` will take one element of the list\n  for every missing entry. If the list is shorter than the number of inserts,\n  the filling will start again from the beginning of the list.\n  Passing a string `padding` is equivalent to passing the list of graphemes in it.\n  If no `padding` is given, it defaults to whitespace.\n\n  When `count` is less than or equal to the length of `string`,\n  given `string` is returned.\n\n  Raises `ArgumentError` if the given `padding` contains non-string element.\n\n  ## Examples\n\n      iex> String.pad_leading(\"abc\", 5)\n      \"  abc\"\n\n      iex> String.pad_leading(\"abc\", 4, \"12\")\n      \"1abc\"\n\n      iex> String.pad_leading(\"abc\", 6, \"12\")\n      \"121abc\"\n\n      iex> String.pad_leading(\"abc\", 5, [\"1\", \"23\"])\n      \"123abc\"\n\n  "
    },
    pad_trailing = {
      description = "pad_trailing(string, count, [_ | _] = padding)\npad_trailing(string, count, padding) when is_binary(padding)\npad_trailing(t, non_neg_integer, t | [t]) :: t\npad_trailing(string, count, padding \\\\ [\" \"])\n\n  Returns a new string padded with a trailing filler\n  which is made of elements from the `padding`.\n\n  Passing a list of strings as `padding` will take one element of the list\n  for every missing entry. If the list is shorter than the number of inserts,\n  the filling will start again from the beginning of the list.\n  Passing a string `padding` is equivalent to passing the list of graphemes in it.\n  If no `padding` is given, it defaults to whitespace.\n\n  When `count` is less than or equal to the length of `string`,\n  given `string` is returned.\n\n  Raises `ArgumentError` if the given `padding` contains non-string element.\n\n  ## Examples\n\n      iex> String.pad_trailing(\"abc\", 5)\n      \"abc  \"\n\n      iex> String.pad_trailing(\"abc\", 4, \"12\")\n      \"abc1\"\n\n      iex> String.pad_trailing(\"abc\", 6, \"12\")\n      \"abc121\"\n\n      iex> String.pad_trailing(\"abc\", 5, [\"1\", \"23\"])\n      \"abc123\"\n\n  "
    },
    pattern = {
      description = "pattern :: t | [t] | :binary.cp\n"
    },
    ["printable?"] = {
      description = "printable?(binary) when is_binary(binary)\nprintable?(<<>>)\nprintable?(<<char::utf8, rest::binary>>)\nprintable?(<<?\\a, rest::binary>>)\nprintable?(<<?\\d, rest::binary>>)\nprintable?(<<?\\e, rest::binary>>)\nprintable?(<<?\\f, rest::binary>>)\nprintable?(<<?\\b, rest::binary>>)\nprintable?(<<?\\v, rest::binary>>)\nprintable?(<<?\\t, rest::binary>>)\nprintable?(<<?\\r, rest::binary>>)\nprintable?(<<?\\n, rest::binary>>)\nprintable?(<<unquote(char), rest::binary>>)\nprintable?(t) :: boolean\nprintable?(string)\n\n  Checks if a string contains only printable characters.\n\n  ## Examples\n\n      iex> String.printable?(\"abc\")\n      true\n\n  "
    },
    replace = {
      description = "replace(t, pattern | Regex.t, t, Keyword.t) :: t\nreplace(subject, pattern, replacement, options \\\\ []) when is_binary(replacement)\n\n  Returns a new string created by replacing occurrences of `pattern` in\n  `subject` with `replacement`.\n\n  The `pattern` may be a string or a regular expression.\n\n  By default it replaces all occurrences but this behaviour can be controlled\n  through the `:global` option; see the \"Options\" section below.\n\n  ## Options\n\n    * `:global` - (boolean) if `true`, all occurrences of `pattern` are replaced\n      with `replacement`, otherwise only the first occurrence is\n      replaced. Defaults to `true`\n\n    * `:insert_replaced` - (integer or list of integers) specifies the position\n      where to insert the replaced part inside the `replacement`. If any\n      position given in the `:insert_replaced` option is larger than the\n      replacement string, or is negative, an `ArgumentError` is raised. See the\n      examples below\n\n  ## Examples\n\n      iex> String.replace(\"a,b,c\", \",\", \"-\")\n      \"a-b-c\"\n\n      iex> String.replace(\"a,b,c\", \",\", \"-\", global: false)\n      \"a-b,c\"\n\n  When the pattern is a regular expression, one can give `\\N` or\n  `\\g{N}` in the `replacement` string to access a specific capture in the\n  regular expression:\n\n      iex> String.replace(\"a,b,c\", ~r/,(.)/, \",\\\\1\\\\g{1}\")\n      \"a,bb,cc\"\n\n  Notice we had to escape the backslash escape character (i.e., we used `\\\\N`\n  instead of just `\\N` to escape the backslash; same thing for `\\\\g{N}`). By\n  giving `\\0`, one can inject the whole matched pattern in the replacement\n  string.\n\n  When the pattern is a string, a developer can use the replaced part inside\n  the `replacement` by using the `:insert_replaced` option and specifying the\n  position(s) inside the `replacement` where the string pattern will be\n  inserted:\n\n      iex> String.replace(\"a,b,c\", \"b\", \"[]\", insert_replaced: 1)\n      \"a,[b],c\"\n\n      iex> String.replace(\"a,b,c\", \",\", \"[]\", insert_replaced: 2)\n      \"a[],b[],c\"\n\n      iex> String.replace(\"a,b,c\", \",\", \"[]\", insert_replaced: [1, 1])\n      \"a[,,]b[,,]c\"\n\n  "
    },
    replace_leading = {
      description = "replace_leading(t, t, t) :: t | no_return\nreplace_leading(string, match, replacement)\n\n  Replaces all leading occurrences of `match` by `replacement` of `match` in `string`.\n\n  Returns the string untouched if there are no occurrences.\n\n  If `match` is `\"\"`, this function raises an `ArgumentError` exception: this\n  happens because this function replaces **all** the occurrences of `match` at\n  the beginning of `string`, and it's impossible to replace \"multiple\"\n  occurrences of `\"\"`.\n\n  ## Examples\n\n      iex> String.replace_leading(\"hello world\", \"hello \", \"\")\n      \"world\"\n      iex> String.replace_leading(\"hello hello world\", \"hello \", \"\")\n      \"world\"\n\n      iex> String.replace_leading(\"hello world\", \"hello \", \"ola \")\n      \"ola world\"\n      iex> String.replace_leading(\"hello hello world\", \"hello \", \"ola \")\n      \"ola ola world\"\n\n  "
    },
    replace_prefix = {
      description = "replace_prefix(t, t, t) :: t\nreplace_prefix(string, match, replacement)\n\n  Replaces prefix in `string` by `replacement` if it matches `match`.\n\n  Returns the string untouched if there is no match. If `match` is an empty\n  string (`\"\"`), `replacement` is just prepended to `string`.\n\n  ## Examples\n\n      iex> String.replace_prefix(\"world\", \"hello \", \"\")\n      \"world\"\n      iex> String.replace_prefix(\"hello world\", \"hello \", \"\")\n      \"world\"\n      iex> String.replace_prefix(\"hello hello world\", \"hello \", \"\")\n      \"hello world\"\n\n      iex> String.replace_prefix(\"world\", \"hello \", \"ola \")\n      \"world\"\n      iex> String.replace_prefix(\"hello world\", \"hello \", \"ola \")\n      \"ola world\"\n      iex> String.replace_prefix(\"hello hello world\", \"hello \", \"ola \")\n      \"ola hello world\"\n\n      iex> String.replace_prefix(\"world\", \"\", \"hello \")\n      \"hello world\"\n\n  "
    },
    replace_suffix = {
      description = "replace_suffix(t, t, t) :: t\nreplace_suffix(string, match, replacement)\n\n  Replaces suffix in `string` by `replacement` if it matches `match`.\n\n  Returns the string untouched if there is no match. If `match` is an empty\n  string (`\"\"`), `replacement` is just appended to `string`.\n\n  ## Examples\n\n      iex> String.replace_suffix(\"hello\", \" world\", \"\")\n      \"hello\"\n      iex> String.replace_suffix(\"hello world\", \" world\", \"\")\n      \"hello\"\n      iex> String.replace_suffix(\"hello world world\", \" world\", \"\")\n      \"hello world\"\n\n      iex> String.replace_suffix(\"hello\", \" world\", \" mundo\")\n      \"hello\"\n      iex> String.replace_suffix(\"hello world\", \" world\", \" mundo\")\n      \"hello mundo\"\n      iex> String.replace_suffix(\"hello world world\", \" world\", \" mundo\")\n      \"hello world mundo\"\n\n      iex> String.replace_suffix(\"hello\", \"\", \" world\")\n      \"hello world\"\n\n  "
    },
    replace_trailing = {
      description = "replace_trailing(t, t, t) :: t | no_return\nreplace_trailing(string, match, replacement)\n\n  Replaces all trailing occurrences of `match` by `replacement` in `string`.\n\n  Returns the string untouched if there are no occurrences.\n\n  If `match` is `\"\"`, this function raises an `ArgumentError` exception: this\n  happens because this function replaces **all** the occurrences of `match` at\n  the end of `string`, and it's impossible to replace \"multiple\" occurrences of\n  `\"\"`.\n\n  ## Examples\n\n      iex> String.replace_trailing(\"hello world\", \" world\", \"\")\n      \"hello\"\n      iex> String.replace_trailing(\"hello world world\", \" world\", \"\")\n      \"hello\"\n\n      iex> String.replace_trailing(\"hello world\", \" world\", \" mundo\")\n      \"hello mundo\"\n      iex> String.replace_trailing(\"hello world world\", \" world\", \" mundo\")\n      \"hello mundo mundo\"\n\n  "
    },
    reverse = {
      description = "reverse(t) :: t\nreverse(string)\n\n  Reverses the graphemes in given string.\n\n  ## Examples\n\n      iex> String.reverse(\"abcd\")\n      \"dcba\"\n\n      iex> String.reverse(\"hello world\")\n      \"dlrow olleh\"\n\n      iex> String.reverse(\"hello ∂og\")\n      \"go∂ olleh\"\n\n  Keep in mind reversing the same string twice does\n  not necessarily yield the original string:\n\n      iex> \"̀e\"\n      \"̀e\"\n      iex> String.reverse(\"̀e\")\n      \"è\"\n      iex> String.reverse String.reverse(\"̀e\")\n      \"è\"\n\n  In the first example the accent is before the vowel, so\n  it is considered two graphemes. However, when you reverse\n  it once, you have the vowel followed by the accent, which\n  becomes one grapheme. Reversing it again will keep it as\n  one single grapheme.\n  "
    },
    rjust = {
      description = "rjust(subject, len, pad \\\\ ?\\s) when is_integer(pad) and is_integer(len) and len >= 0\nfalse"
    },
    rstrip = {
      description = "rstrip(string, char) when is_integer(char)\nfalse"
    },
    slice = {
      description = "slice(string, first..last)\nslice(string, first..last) when first >= 0 and last >= 0\nslice(string, first..-1) when first >= 0\nslice(\"\", _.._)\nslice(t, Range.t) :: t\nslice(string, range)\nslice(string, start, len) when start < 0 and len >= 0\nslice(string, start, len) when start >= 0 and len >= 0\nslice(t, integer, integer) :: grapheme\nslice(_, _, 0)\n\n  Returns a substring starting at the offset `start`, and of\n  length `len`.\n\n  If the offset is greater than string length, then it returns `\"\"`.\n\n  Remember this function works with Unicode graphemes and considers\n  the slices to represent grapheme offsets. If you want to split\n  on raw bytes, check `Kernel.binary_part/3` instead.\n\n  ## Examples\n\n      iex> String.slice(\"elixir\", 1, 3)\n      \"lix\"\n\n      iex> String.slice(\"elixir\", 1, 10)\n      \"lixir\"\n\n      iex> String.slice(\"elixir\", 10, 3)\n      \"\"\n\n      iex> String.slice(\"elixir\", -4, 4)\n      \"ixir\"\n\n      iex> String.slice(\"elixir\", -10, 3)\n      \"\"\n\n      iex> String.slice(\"a\", 0, 1500)\n      \"a\"\n\n      iex> String.slice(\"a\", 1, 1500)\n      \"\"\n\n      iex> String.slice(\"a\", 2, 1500)\n      \"\"\n\n  "
    },
    split = {
      description = "split(string, pattern, options) when is_binary(string)\nsplit(string, pattern, []) when is_binary(string) and pattern != \"\"\nsplit(string, %Regex{} = pattern, options) when is_binary(string)\nsplit(t, pattern | Regex.t, Keyword.t) :: [t]\nsplit(string, pattern, options \\\\ [])\n\n  Divides a string into substrings based on a pattern.\n\n  Returns a list of these substrings. The pattern can\n  be a string, a list of strings or a regular expression.\n\n  The string is split into as many parts as possible by\n  default, but can be controlled via the `parts: pos_integer` option.\n  If you pass `parts: :infinity`, it will return all possible parts\n  (`:infinity` is the default).\n\n  Empty strings are only removed from the result if the\n  `trim` option is set to `true` (default is `false`).\n\n  When the pattern used is a regular expression, the string is\n  split using `Regex.split/3`. In that case this function accepts\n  additional options which are documented in `Regex.split/3`.\n\n  ## Examples\n\n  Splitting with a string pattern:\n\n      iex> String.split(\"a,b,c\", \",\")\n      [\"a\", \"b\", \"c\"]\n\n      iex> String.split(\"a,b,c\", \",\", parts: 2)\n      [\"a\", \"b,c\"]\n\n      iex> String.split(\" a b c \", \" \", trim: true)\n      [\"a\", \"b\", \"c\"]\n\n  A list of patterns:\n\n      iex> String.split(\"1,2 3,4\", [\" \", \",\"])\n      [\"1\", \"2\", \"3\", \"4\"]\n\n  A regular expression:\n\n      iex> String.split(\"a,b,c\", ~r{,})\n      [\"a\", \"b\", \"c\"]\n\n      iex> String.split(\"a,b,c\", ~r{,}, parts: 2)\n      [\"a\", \"b,c\"]\n\n      iex> String.split(\" a b c \", ~r{\\s}, trim: true)\n      [\"a\", \"b\", \"c\"]\n\n      iex> String.split(\"abc\", ~r{b}, include_captures: true)\n      [\"a\", \"b\", \"c\"]\n\n  Splitting on empty patterns returns graphemes:\n\n      iex> String.split(\"abc\", ~r{})\n      [\"a\", \"b\", \"c\", \"\"]\n\n      iex> String.split(\"abc\", \"\")\n      [\"a\", \"b\", \"c\", \"\"]\n\n      iex> String.split(\"abc\", \"\", trim: true)\n      [\"a\", \"b\", \"c\"]\n\n      iex> String.split(\"abc\", \"\", parts: 2)\n      [\"a\", \"bc\"]\n\n  A precompiled pattern can also be given:\n\n      iex> pattern = :binary.compile_pattern([\" \", \",\"])\n      iex> String.split(\"1,2 3,4\", pattern)\n      [\"1\", \"2\", \"3\", \"4\"]\n\n  "
    },
    split_at = {
      description = "split_at(string, position) when is_integer(position) and position < 0\nsplit_at(string, position) when is_integer(position) and position >= 0\nsplit_at(t, integer) :: {t, t}\nsplit_at(string, position)\n\n  Splits a string into two at the specified offset. When the offset given is\n  negative, location is counted from the end of the string.\n\n  The offset is capped to the length of the string. Returns a tuple with\n  two elements.\n\n  Note: keep in mind this function splits on graphemes and for such it\n  has to linearly traverse the string. If you want to split a string or\n  a binary based on the number of bytes, use `Kernel.binary_part/3`\n  instead.\n\n  ## Examples\n\n      iex> String.split_at \"sweetelixir\", 5\n      {\"sweet\", \"elixir\"}\n\n      iex> String.split_at \"sweetelixir\", -6\n      {\"sweet\", \"elixir\"}\n\n      iex> String.split_at \"abc\", 0\n      {\"\", \"abc\"}\n\n      iex> String.split_at \"abc\", 1000\n      {\"abc\", \"\"}\n\n      iex> String.split_at \"abc\", -1000\n      {\"\", \"abc\"}\n\n  "
    },
    splitter = {
      description = "splitter(t, pattern, Keyword.t) :: Enumerable.t\nsplitter(string, pattern, options \\\\ [])\n\n  Returns an enumerable that splits a string on demand.\n\n  This is in contrast to `split/3` which splits all\n  the string upfront.\n\n  Note splitter does not support regular expressions\n  (as it is often more efficient to have the regular\n  expressions traverse the string at once than in\n  multiple passes).\n\n  ## Options\n\n    * :trim - when `true`, does not emit empty patterns\n\n  ## Examples\n\n      iex> String.splitter(\"1,2 3,4 5,6 7,8,...,99999\", [\" \", \",\"]) |> Enum.take(4)\n      [\"1\", \"2\", \"3\", \"4\"]\n\n      iex> String.splitter(\"abcd\", \"\") |> Enum.take(10)\n      [\"a\", \"b\", \"c\", \"d\", \"\"]\n\n      iex> String.splitter(\"abcd\", \"\", trim: true) |> Enum.take(10)\n      [\"a\", \"b\", \"c\", \"d\"]\n\n  "
    },
    ["starts_with?"] = {
      description = "starts_with?(string, prefix) when is_binary(string)\nstarts_with?(string, prefix) when is_binary(string) and is_list(prefix)\nstarts_with?(t, t | [t]) :: boolean\nstarts_with?(string, []) when is_binary(string)\n\n  Returns `true` if `string` starts with any of the prefixes given.\n\n  `prefix` can be either a single prefix or a list of prefixes.\n\n  ## Examples\n\n      iex> String.starts_with? \"elixir\", \"eli\"\n      true\n      iex> String.starts_with? \"elixir\", [\"erlang\", \"elixir\"]\n      true\n      iex> String.starts_with? \"elixir\", [\"erlang\", \"ruby\"]\n      false\n\n  An empty string will always match:\n\n      iex> String.starts_with? \"elixir\", \"\"\n      true\n      iex> String.starts_with? \"elixir\", [\"\", \"other\"]\n      true\n\n  "
    },
    strip = {
      description = "strip(string, char)\nstrip(string)\nfalse"
    },
    t = {
      description = "t :: binary\n"
    },
    to_atom = {
      description = "to_atom(String.t) :: atom\nto_atom(string)\n\n  Converts a string to an atom.\n\n  Currently Elixir does not support the conversion of strings\n  that contain Unicode codepoints greater than 0xFF.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> String.to_atom(\"my_atom\")\n      :my_atom\n\n  "
    },
    to_char_list = {
      description = "to_char_list(t) :: charlist\nto_char_list(string)\nfalse"
    },
    to_charlist = {
      description = "to_charlist(t) :: charlist\nto_charlist(string) when is_binary(string)\n\n  Converts a string into a charlist.\n\n  Specifically, this functions takes a UTF-8 encoded binary and returns a list of its integer\n  codepoints. It is similar to `codepoints/1` except that the latter returns a list of codepoints as\n  strings.\n\n  In case you need to work with bytes, take a look at the\n  [`:binary` module](http://www.erlang.org/doc/man/binary.html).\n\n  ## Examples\n\n      iex> String.to_charlist(\"æß\")\n      'æß'\n  "
    },
    to_existing_atom = {
      description = "to_existing_atom(String.t) :: atom\nto_existing_atom(string)\n\n  Converts a string to an existing atom.\n\n  Currently Elixir does not support the conversion of strings\n  that contain Unicode codepoints greater than 0xFF.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> _ = :my_atom\n      iex> String.to_existing_atom(\"my_atom\")\n      :my_atom\n\n      iex> String.to_existing_atom(\"this_atom_will_never_exist\")\n      ** (ArgumentError) argument error\n\n  "
    },
    to_float = {
      description = "to_float(String.t) :: float\nto_float(string)\n\n  Returns a float whose text representation is `string`.\n\n  `string` must be the string representation of a float.\n  If a string representation of an integer wants to be used,\n  then `Float.parse/1` should be used instead,\n  otherwise an argument error will be raised.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> String.to_float(\"2.2017764e+0\")\n      2.2017764\n\n      iex> String.to_float(\"3.0\")\n      3.0\n\n  "
    },
    to_integer = {
      description = "to_integer(String.t, 2..36) :: integer\nto_integer(string, base)\nto_integer(String.t) :: integer\nto_integer(string)\n\n  Returns an integer whose text representation is `string`.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> String.to_integer(\"123\")\n      123\n\n  "
    },
    trim = {
      description = "trim(t, t) :: t\ntrim(string, to_trim)\ntrim(t) :: t\ntrim(string)\n\n  Returns a string where all leading and trailing Unicode whitespaces\n  have been removed.\n\n  ## Examples\n\n      iex> String.trim(\"\\n  abc\\n  \")\n      \"abc\"\n\n  "
    },
    trim_leading = {
      description = "trim_leading(t, t) :: t\ntrim_leading(string, to_trim)\n\n  Returns a string where all leading `to_trim`s have been removed.\n\n  ## Examples\n\n      iex> String.trim_leading(\"__ abc _\", \"_\")\n      \" abc _\"\n\n      iex> String.trim_leading(\"1 abc\", \"11\")\n      \"1 abc\"\n\n  "
    },
    trim_trailing = {
      description = "trim_trailing(t, t) :: t\ntrim_trailing(string, to_trim)\n\n  Returns a string where all trailing `to_trim`s have been removed.\n\n  ## Examples\n\n      iex> String.trim_trailing(\"_ abc __\", \"_\")\n      \"_ abc \"\n\n      iex> String.trim_trailing(\"abc 1\", \"11\")\n      \"abc 1\"\n\n  "
    },
    ["valid?"] = {
      description = "valid?(_)\nvalid?(<<>>)\nvalid?(<<_::utf8, t::binary>>)\nvalid?(<<unquote(noncharacter)::utf8, _::binary>>)\nvalid?(t) :: boolean\nvalid?(string)\n\n  Checks whether `string` contains only valid characters.\n\n  ## Examples\n\n      iex> String.valid?(\"a\")\n      true\n\n      iex> String.valid?(\"ø\")\n      true\n\n      iex> String.valid?(<<0xFFFF :: 16>>)\n      false\n\n      iex> String.valid?(\"asd\" <> <<0xFFFF :: 16>>)\n      false\n\n  "
    },
    ["valid_character?"] = {
      description = "valid_character?(string)\nfalse"
    }
  },
  StringIO = {
    close = {
      description = "close(pid) :: {:ok, {binary, binary}}\nclose(pid) when is_pid(pid)\n\n  Stops the IO device and returns the remaining input/output\n  buffers.\n\n  ## Examples\n\n      iex> {:ok, pid} = StringIO.open(\"in\")\n      iex> IO.write(pid, \"out\")\n      iex> StringIO.close(pid)\n      {:ok, {\"in\", \"out\"}}\n\n  "
    },
    contents = {
      description = "contents(pid) :: {binary, binary}\ncontents(pid) when is_pid(pid)\n\n  Returns the current input/output buffers for the given IO\n  device.\n\n  ## Examples\n\n      iex> {:ok, pid} = StringIO.open(\"in\")\n      iex> IO.write(pid, \"out\")\n      iex> StringIO.contents(pid)\n      {\"in\", \"out\"}\n\n  "
    },
    description = "\n  Controls an IO device process that wraps a string.\n\n  A `StringIO` IO device can be passed as a \"device\" to\n  most of the functions in the `IO` module.\n\n  ## Examples\n\n      iex> {:ok, pid} = StringIO.open(\"foo\")\n      iex> IO.read(pid, 2)\n      \"fo\"\n\n  ",
    flush = {
      description = "flush(pid) :: binary\nflush(pid) when is_pid(pid)\n\n  Flushes the output buffer and returns its current contents.\n\n  ## Examples\n\n      iex> {:ok, pid} = StringIO.open(\"in\")\n      iex> IO.write(pid, \"out\")\n      iex> StringIO.flush(pid)\n      \"out\"\n      iex> StringIO.contents(pid)\n      {\"in\", \"\"}\n\n  "
    },
    handle_call = {
      description = "handle_call(request, from, s)\nhandle_call(:close, _from, %{input: input, output: output} = s)\nhandle_call(:flush, _from, %{output: output} = s)\nhandle_call(:contents, _from, %{input: input, output: output} = s)\n\n  Stops the IO device and returns the remaining input/output\n  buffers.\n\n  ## Examples\n\n      iex> {:ok, pid} = StringIO.open(\"in\")\n      iex> IO.write(pid, \"out\")\n      iex> StringIO.close(pid)\n      {:ok, {\"in\", \"out\"}}\n\n  "
    },
    handle_info = {
      description = "handle_info(msg, s)\nhandle_info({:io_request, from, reply_as, req}, s)\n\n  Stops the IO device and returns the remaining input/output\n  buffers.\n\n  ## Examples\n\n      iex> {:ok, pid} = StringIO.open(\"in\")\n      iex> IO.write(pid, \"out\")\n      iex> StringIO.close(pid)\n      {:ok, {\"in\", \"out\"}}\n\n  "
    },
    init = {
      description = "init({string, options})\n\n  Stops the IO device and returns the remaining input/output\n  buffers.\n\n  ## Examples\n\n      iex> {:ok, pid} = StringIO.open(\"in\")\n      iex> IO.write(pid, \"out\")\n      iex> StringIO.close(pid)\n      {:ok, {\"in\", \"out\"}}\n\n  "
    },
    open = {
      description = "open(binary, Keyword.t) :: {:ok, pid}\nopen(string, options \\\\ []) when is_binary(string)\n\n  Creates an IO device.\n\n  `string` will be the initial input of the newly created\n  device.\n\n  If the `:capture_prompt` option is set to `true`,\n  prompts (specified as arguments to `IO.get*` functions)\n  are captured.\n\n  ## Examples\n\n      iex> {:ok, pid} = StringIO.open(\"foo\")\n      iex> IO.gets(pid, \">\")\n      \"foo\"\n      iex> StringIO.contents(pid)\n      {\"\", \"\"}\n\n      iex> {:ok, pid} = StringIO.open(\"foo\", capture_prompt: true)\n      iex> IO.gets(pid, \">\")\n      \"foo\"\n      iex> StringIO.contents(pid)\n      {\"\", \">\"}\n\n  "
    }
  },
  Supervisor = {
    Default = {
      description = "false",
      init = {
        description = "init(args)\n\n  Supervisor callback that simply returns the given args.\n\n  This is the supervisor used by `Supervisor.start_link/2`\n  and others.\n  "
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
      supervise = {
        description = "supervise([spec], strategy: strategy,\nsupervise(children, options)\n\n  Receives a list of children (workers or supervisors) to\n  supervise and a set of options.\n\n  Returns a tuple containing the supervisor specification. This tuple can be\n  used as the return value of the `c:init/1` callback when implementing a\n  module-based supervisor.\n\n  ## Examples\n\n      supervise(children, strategy: :one_for_one)\n\n  ## Options\n\n    * `:strategy` - the restart strategy option. It can be either\n      `:one_for_one`, `:rest_for_one`, `:one_for_all`, or\n      `:simple_one_for_one`. You can learn more about strategies\n      in the `Supervisor` module docs.\n\n    * `:max_restarts` - the maximum amount of restarts allowed in\n      a time frame. Defaults to `3`.\n\n    * `:max_seconds` - the time frame in which `:max_restarts` applies.\n      Defaults to `5`.\n\n  The `:strategy` option is required and by default a maximum of 3 restarts is\n  allowed within 5 seconds. Check the `Supervisor` module for a detailed\n  description of the available strategies.\n  "
      },
      supervisor = {
        description = "supervisor(module, [term], [restart: restart, shutdown: shutdown,\nsupervisor(module, args, options \\\\ [])\n\n  Defines the given `module` as a supervisor which will be started\n  with the given arguments.\n\n      supervisor(ExUnit.Runner, [], restart: :permanent)\n\n  By default, the function `start_link` is invoked on the given\n  module. Overall, the default values for the options are:\n\n      [id: module,\n       function: :start_link,\n       restart: :permanent,\n       shutdown: :infinity,\n       modules: [module]]\n\n  Check the documentation for the `Supervisor.Spec` module for more\n  information on the options.\n  "
      },
      worker = {
        description = "worker(module, [term], [restart: restart, shutdown: shutdown,\nworker(module, args, options \\\\ [])\nworker :: :worker | :supervisor\n"
      }
    },
    child = {
      description = "child :: pid | :undefined\n"
    },
    count_children = {
      description = "count_children(supervisor) ::\ncount_children(supervisor)\n\n  Returns a map containing count values for the given supervisor.\n\n  The map contains the following keys:\n\n    * `:specs` - the total count of children, dead or alive\n\n    * `:active` - the count of all actively running child processes managed by\n      this supervisor\n\n    * `:supervisors` - the count of all supervisors whether or not these\n      child supervisors are still alive\n\n    * `:workers` - the count of all workers, whether or not these child workers\n      are still alive\n\n  "
    },
    delete_child = {
      description = "delete_child(supervisor, Supervisor.Spec.child_id) :: :ok | {:error, error}\ndelete_child(supervisor, child_id)\n\n  Deletes the child specification identified by `child_id`.\n\n  The corresponding child process must not be running; use `terminate_child/2`\n  to terminate it if it's running.\n\n  If successful, this function returns `:ok`. This function may return an error\n  with an appropriate error tuple if the `child_id` is not found, or if the\n  current process is running or being restarted.\n\n  This operation is not supported by `:simple_one_for_one` supervisors.\n  "
    },
    description = "\n  A behaviour module for implementing supervision functionality.\n\n  A supervisor is a process which supervises other processes, which we refer\n  to as *child processes*. Supervisors are used to build a hierarchical process\n  structure called a *supervision tree*. Supervision trees are a nice way to\n  structure fault-tolerant applications.\n\n  A supervisor implemented using this module has a standard set\n  of interface functions and includes functionality for tracing and error\n  reporting. It also fits into a supervision tree.\n\n  ## Examples\n\n  In order to define a supervisor, we need to first define a child process\n  that is going to be supervised. In order to do so, we will define a GenServer\n  that represents a stack:\n\n      defmodule Stack do\n        use GenServer\n\n        def start_link(state, opts \\\\ []) do\n          GenServer.start_link(__MODULE__, state, opts)\n        end\n\n        def handle_call(:pop, _from, [h | t]) do\n          {:reply, h, t}\n        end\n\n        def handle_cast({:push, h}, t) do\n          {:noreply, [h | t]}\n        end\n      end\n\n  We can now define our supervisor and start it as follows:\n\n      # Import helpers for defining supervisors\n      import Supervisor.Spec\n\n      # Supervise the Stack server which will be started with\n      # two arguments. The initial stack, [:hello], and a\n      # keyword list containing the GenServer options that\n      # set the registered name of the server to MyStack.\n      children = [\n        worker(Stack, [[:hello], [name: MyStack]])\n      ]\n\n      # Start the supervisor with our child\n      {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)\n\n      # There is one child worker started\n      Supervisor.count_children(pid)\n      #=> %{active: 1, specs: 1, supervisors: 0, workers: 1}\n\n  Notice that when starting the GenServer, we are registering it\n  with name `MyStack`, which allows us to call it directly and\n  get what is on the stack:\n\n      GenServer.call(MyStack, :pop)\n      #=> :hello\n\n      GenServer.cast(MyStack, {:push, :world})\n      #=> :ok\n\n      GenServer.call(MyStack, :pop)\n      #=> :world\n\n  However, there is a bug in our stack server. If we call `:pop` and\n  the stack is empty, it is going to crash because no clause matches:\n\n      GenServer.call(MyStack, :pop)\n      ** (exit) exited in: GenServer.call(MyStack, :pop, 5000)\n\n  Luckily, since the server is being supervised by a supervisor, the\n  supervisor will automatically start a new one, with the initial stack\n  of `[:hello]`:\n\n      GenServer.call(MyStack, :pop)\n      #=> :hello\n\n  Supervisors support different strategies; in the example above, we\n  have chosen `:one_for_one`. Furthermore, each supervisor can have many\n  workers and supervisors as children, each of them with their specific\n  configuration, shutdown values, and restart strategies.\n\n  The rest of this documentation will cover supervision strategies; also read\n  the documentation for the `Supervisor.Spec` module to learn about the\n  specification for workers and supervisors.\n\n  ## Module-based supervisors\n\n  In the example above, a supervisor was started by passing the supervision\n  structure to `start_link/2`. However, supervisors can also be created by\n  explicitly defining a supervision module:\n\n      defmodule MyApp.Supervisor do\n        # Automatically imports Supervisor.Spec\n        use Supervisor\n\n        def start_link do\n          Supervisor.start_link(__MODULE__, [])\n        end\n\n        def init([]) do\n          children = [\n            worker(Stack, [[:hello]])\n          ]\n\n          # supervise/2 is imported from Supervisor.Spec\n          supervise(children, strategy: :one_for_one)\n        end\n      end\n\n  You may want to use a module-based supervisor if:\n\n    * You need to perform some particular action on supervisor\n      initialization, like setting up an ETS table.\n\n    * You want to perform partial hot-code swapping of the\n      tree. For example, if you add or remove children,\n      the module-based supervision will add and remove the\n      new children directly, while dynamic supervision\n      requires the whole tree to be restarted in order to\n      perform such swaps.\n\n  ## Strategies\n\n  Supervisors support different supervision strategies (through the `:strategy`\n  option, as seen above):\n\n    * `:one_for_one` - if a child process terminates, only that\n      process is restarted.\n\n    * `:one_for_all` - if a child process terminates, all other child\n      processes are terminated and then all child processes (including\n      the terminated one) are restarted.\n\n    * `:rest_for_one` - if a child process terminates, the \"rest\" of\n      the child processes, i.e., the child processes after the terminated\n      one in start order, are terminated. Then the terminated child\n      process and the rest of the child processes are restarted.\n\n    * `:simple_one_for_one` - similar to `:one_for_one` but suits better\n      when dynamically attaching children. This strategy requires the\n      supervisor specification to contain only one child. Many functions\n      in this module behave slightly differently when this strategy is\n      used.\n\n  ## Simple one for one\n\n  The `:simple_one_for_one` supervisor is useful when you want to dynamically\n  start and stop supervised children. For example, imagine you want to\n  dynamically create multiple stacks. We can do so by defining a `:simple_one_for_one`\n  supervisor:\n\n      # Import helpers for defining supervisors\n      import Supervisor.Spec\n\n      # This time, we don't pass any argument because\n      # the argument will be given when we start the child\n      children = [\n        worker(Stack, [], restart: :transient)\n      ]\n\n      # Start the supervisor with our one child as a template\n      {:ok, sup_pid} = Supervisor.start_link(children, strategy: :simple_one_for_one)\n\n      # No child worker is active yet until start_child is called\n      Supervisor.count_children(sup_pid)\n      #=> %{active: 0, specs: 1, supervisors: 0, workers: 0}\n\n  There are a couple differences here:\n\n    * the simple one for one specification can define only one child which\n      works as a template for when we call `start_child/2`\n\n    * we have defined the child to have a restart strategy of `:transient`. This\n      means that, if the child process exits due to a `:normal`, `:shutdown`,\n      or `{:shutdown, term}` reason, it won't be restarted. This is useful\n      as it allows our workers to politely shutdown and be removed from the\n      `:simple_one_for_one` supervisor, without being restarted. You can find\n      more information about restart strategies in the documentation for the\n      `Supervisor.Spec` module\n\n  With the supervisor defined, let's dynamically start stacks:\n\n      {:ok, pid} = Supervisor.start_child(sup_pid, [[:hello, :world], []])\n      GenServer.call(pid, :pop) #=> :hello\n      GenServer.call(pid, :pop) #=> :world\n\n      {:ok, pid} = Supervisor.start_child(sup_pid, [[:something, :else], []])\n      GenServer.call(pid, :pop) #=> :something\n      GenServer.call(pid, :pop) #=> :else\n\n      Supervisor.count_children(sup_pid)\n      #=> %{active: 2, specs: 1, supervisors: 0, workers: 2}\n\n  ## Exit reasons\n\n  From the example above, you may have noticed that the `:transient` restart\n  strategy for the worker does not restart the child in case it exits with\n  reason `:normal`, `:shutdown` or `{:shutdown, term}`.\n\n  So one may ask: which exit reason should I choose when exiting my worker?\n  There are three options:\n\n    * `:normal` - in such cases, the exit won't be logged, there is no restart\n      in transient mode, and linked processes do not exit\n\n    * `:shutdown` or `{:shutdown, term}` - in such cases, the exit won't be\n      logged, there is no restart in transient mode, and linked processes exit\n      with the same reason unless they're trapping exits\n\n    * any other term - in such cases, the exit will be logged, there are\n      restarts in transient mode, and linked processes exit with the same reason\n      unless they're trapping exits\n\n  ## Name registration\n\n  A supervisor is bound to the same name registration rules as a `GenServer`.\n  Read more about these rules in the documentation for `GenServer`.\n\n  ",
    init = {
      description = "init(arg)\nfalse"
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
    restart_child = {
      description = "restart_child(supervisor, Supervisor.Spec.child_id) ::\nrestart_child(supervisor, child_id)\n\n  Restarts a child process identified by `child_id`.\n\n  The child specification must exist and the corresponding child process must not\n  be running.\n\n  Note that for temporary children, the child specification is automatically deleted\n  when the child terminates, and thus it is not possible to restart such children.\n\n  If the child process start function returns `{:ok, child}` or `{:ok, child, info}`,\n  the PID is added to the supervisor and this function returns the same value.\n\n  If the child process start function returns `:ignore`, the PID remains set to\n  `:undefined` and this function returns `{:ok, :undefined}`.\n\n  This function may return an error with an appropriate error tuple if the\n  `child_id` is not found, or if the current process is running or being\n  restarted.\n\n  If the child process start function returns an error tuple or an erroneous value,\n  or if it fails, this function returns `{:error, error}`.\n\n  This operation is not supported by `:simple_one_for_one` supervisors.\n  "
    },
    start_child = {
      description = "start_child(supervisor, Supervisor.Spec.spec | [term]) :: on_start_child\nstart_child(supervisor, child_spec_or_args)\n\n  Dynamically adds a child specification to `supervisor` and starts that child.\n\n  `child_spec` should be a valid child specification (unless the supervisor\n  is a `:simple_one_for_one` supervisor, see below). The child process will\n  be started as defined in the child specification.\n\n  In the case of `:simple_one_for_one`, the child specification defined in\n  the supervisor is used and instead of a `child_spec`, an arbitrary list\n  of terms is expected. The child process will then be started by appending\n  the given list to the existing function arguments in the child specification.\n\n  If a child specification with the specified id already exists, `child_spec` is\n  discarded and this function returns an error with `:already_started` or\n  `:already_present` if the corresponding child process is running or not,\n  respectively.\n\n  If the child process start function returns `{:ok, child}` or `{:ok, child,\n  info}`, then child specification and PID are added to the supervisor and\n  this function returns the same value.\n\n  If the child process start function returns `:ignore`, the child specification\n  is added to the supervisor, the PID is set to `:undefined` and this function\n  returns `{:ok, :undefined}`.\n\n  If the child process start function returns an error tuple or an erroneous\n  value, or if it fails, the child specification is discarded and this function\n  returns `{:error, error}` where `error` is a term containing information about\n  the error and child specification.\n  "
    },
    start_link = {
      description = "start_link(module, term, options) :: on_start\nstart_link(module, arg, options \\\\ []) when is_list(options)\nstart_link([Supervisor.Spec.spec], options) :: on_start\nstart_link(children, options) when is_list(children)\n\n  Starts a supervisor with the given children.\n\n  A strategy is required to be provided through the `:strategy` option.\n  Furthermore, the `:max_restarts` and `:max_seconds` options can be\n  configured as described in the documentation for `Supervisor.Spec.supervise/2`.\n\n  The options can also be used to register a supervisor name.\n  The supported values are described under the \"Name registration\"\n  section in the `GenServer` module docs.\n\n  If the supervisor and its child processes are successfully created\n  (i.e., if the start function of each child process returns `{:ok, child}`,\n  `{:ok, child, info}`, or `:ignore`) this function returns\n  `{:ok, pid}`, where `pid` is the PID of the supervisor. If a process with the\n   specified name already exists, the function returns `{:error,\n   {:already_started, pid}}`, where `pid` is the PID of that process.\n\n  If the start function of any of the child processes fails or returns an error\n  tuple or an erroneous value, the supervisor first terminates with reason\n  `:shutdown` all the child processes that have already been started, and then\n  terminates itself and returns `{:error, {:shutdown, reason}}`.\n\n  Note that a supervisor started with this function is linked to the parent\n  process and exits not only on crashes but also if the parent process exits\n  with `:normal` reason.\n  "
    },
    stop = {
      description = "stop(supervisor, reason :: term, timeout) :: :ok\nstop(supervisor, reason \\\\ :normal, timeout \\\\ :infinity)\n\n  Synchronously stops the given supervisor with the given `reason`.\n\n  It returns `:ok` if the supervisor terminates with the given\n  reason. If it terminates with another reason, the call exits.\n\n  This function keeps OTP semantics regarding error reporting.\n  If the reason is any other than `:normal`, `:shutdown` or\n  `{:shutdown, _}`, an error report is logged.\n  "
    },
    supervisor = {
      description = "supervisor :: pid | name | {atom, node}\n"
    },
    terminate_child = {
      description = "terminate_child(supervisor, pid | Supervisor.Spec.child_id) :: :ok | {:error, error}\nterminate_child(supervisor, pid_or_child_id)\n\n  Terminates the given children, identified by PID or child id.\n\n  If the supervisor is not a `:simple_one_for_one`, the child id is expected\n  and the process, if there's one, is terminated; the child specification is\n  kept unless the child is temporary.\n\n  In case of a `:simple_one_for_one` supervisor, a PID is expected. If the child\n  specification identifier is given instead of a `pid`, this function returns\n  `{:error, :simple_one_for_one}`.\n\n  A non-temporary child process may later be restarted by the supervisor. The child\n  process can also be restarted explicitly by calling `restart_child/2`. Use\n  `delete_child/2` to remove the child specification.\n\n  If successful, this function returns `:ok`. If there is no child specification\n  for the given child id or there is no process with the given PID, this\n  function returns `{:error, :not_found}`.\n  "
    },
    which_children = {
      description = "which_children(supervisor) ::\nwhich_children(supervisor)\n\n  Returns a list with information about all children of the given supervisor.\n\n  Note that calling this function when supervising a large number of children\n  under low memory conditions can cause an out of memory exception.\n\n  This function returns a list of `{id, child, type, modules}` tuples, where:\n\n    * `id` - as defined in the child specification or `:undefined` in the case\n      of a `simple_one_for_one` supervisor\n\n    * `child` - the PID of the corresponding child process, `:restarting` if the\n      process is about to be restarted, or `:undefined` if there is no such\n      process\n\n    * `type` - `:worker` or `:supervisor`, as specified by the child specification\n\n    * `modules` - as specified by the child specification\n\n  "
    }
  },
  SyntaxError = {
    message = {
      description = "message(exception)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    }
  },
  System = {
    argv = {
      description = "argv([String.t]) :: :ok\nargv(args)\nargv() :: [String.t]\nargv\n\n  Lists command line arguments.\n\n  Returns the list of command line arguments passed to the program.\n  "
    },
    at_exit = {
      description = "at_exit(fun) when is_function(fun, 1)\n\n  Registers a program exit handler function.\n\n  Registers a function that will be invoked at the end of program execution.\n  Useful for invoking a hook in \"script\" mode.\n\n  The handler always executes in a different process from the one it was\n  registered in. As a consequence, any resources managed by the calling process\n  (ETS tables, open files, etc.) won't be available by the time the handler\n  function is invoked.\n\n  The function must receive the exit status code as an argument.\n  "
    },
    build_info = {
      description = "build_info() :: map\nbuild_info\n\n  Elixir build information.\n\n  Returns a keyword list with Elixir version, Git short revision hash and compilation date.\n  "
    },
    cmd = {
      description = "cmd(binary, [binary], Keyword.t) ::\ncmd(command, args, opts \\\\ []) when is_binary(command) and is_list(args)\n\n  Executes the given `command` with `args`.\n\n  `command` is expected to be an executable available in PATH\n  unless an absolute path is given.\n\n  `args` must be a list of binaries which the executable will receive\n  as its arguments as is. This means that:\n\n    * environment variables will not be interpolated\n    * wildcard expansion will not happen (unless `Path.wildcard/2` is used\n      explicitly)\n    * arguments do not need to be escaped or quoted for shell safety\n\n  This function returns a tuple containing the collected result\n  and the command exit status.\n\n  Internally, this function uses a `Port` for interacting with the\n  outside world. However, if you plan to run a long-running program,\n  ports guarantee stdin/stdout devices will be closed but it does not\n  automatically terminate the program. The documentation for the\n  `Port` module describes this problem and possible solutions under\n  the \"Zombie processes\" section.\n\n  ## Examples\n\n      iex> System.cmd \"echo\", [\"hello\"]\n      {\"hello\\n\", 0}\n\n      iex> System.cmd \"echo\", [\"hello\"], env: [{\"MIX_ENV\", \"test\"}]\n      {\"hello\\n\", 0}\n\n      iex> System.cmd \"echo\", [\"hello\"], into: IO.stream(:stdio, :line)\n      hello\n      {%IO.Stream{}, 0}\n\n  ## Options\n\n    * `:into` - injects the result into the given collectable, defaults to `\"\"`\n    * `:cd` - the directory to run the command in\n    * `:env` - an enumerable of tuples containing environment key-value as binary\n    * `:arg0` - sets the command arg0\n    * `:stderr_to_stdout` - redirects stderr to stdout when `true`\n    * `:parallelism` - when `true`, the VM will schedule port tasks to improve\n      parallelism in the system. If set to `false`, the VM will try to perform\n      commands immediately, improving latency at the expense of parallelism.\n      The default can be set on system startup by passing the \"+spp\" argument\n      to `--erl`.\n\n  ## Error reasons\n\n  If invalid arguments are given, `ArgumentError` is raised by\n  `System.cmd/3`. `System.cmd/3` also expects a strict set of\n  options and will raise if unknown or invalid options are given.\n\n  Furthermore, `System.cmd/3` may fail with one of the POSIX reasons\n  detailed below:\n\n    * `:system_limit` - all available ports in the Erlang emulator are in use\n\n    * `:enomem` - there was not enough memory to create the port\n\n    * `:eagain` - there are no more available operating system processes\n\n    * `:enametoolong` - the external command given was too long\n\n    * `:emfile` - there are no more available file descriptors\n      (for the operating system process that the Erlang emulator runs in)\n\n    * `:enfile` - the file table is full (for the entire operating system)\n\n    * `:eacces` - the command does not point to an executable file\n\n    * `:enoent` - the command does not point to an existing file\n\n  ## Shell commands\n\n  If you desire to execute a trusted command inside a shell, with pipes,\n  redirecting and so on, please check\n  [`:os.cmd/1`](http://www.erlang.org/doc/man/os.html#cmd-1).\n  "
    },
    compiled_endianness = {
      description = "compiled_endianness\n\n  Returns the endianness the system was compiled with.\n  "
    },
    convert_time_unit = {
      description = "convert_time_unit(integer, time_unit | :native, time_unit | :native) :: integer\nconvert_time_unit(time, from_unit, to_unit)\n\n  Converts `time` from time unit `from_unit` to time unit `to_unit`.\n\n  The result is rounded via the floor function.\n\n  `convert_time_unit/3` accepts an additional time unit (other than the\n  ones in the `t:time_unit/0` type) called `:native`. `:native` is the time\n  unit used by the Erlang runtime system. It's determined when the runtime\n  starts and stays the same until the runtime is stopped. To determine what\n  the `:native` unit amounts to in a system, you can call this function to\n  convert 1 second to the `:native` time unit (i.e.,\n  `System.convert_time_unit(1, :second, :native)`).\n  "
    },
    cwd = {
      description = "cwd\n\n  Current working directory.\n\n  Returns the current working directory or `nil` if one\n  is not available.\n  "
    },
    ["cwd!"] = {
      description = "cwd!\n\n  Current working directory, exception on error.\n\n  Returns the current working directory or raises `RuntimeError`.\n  "
    },
    delete_env = {
      description = "delete_env(String.t) :: :ok\ndelete_env(varname)\n\n  Deletes an environment variable.\n\n  Removes the variable `varname` from the environment.\n  "
    },
    description = "\n  The `System` module provides functions that interact directly\n  with the VM or the host system.\n\n  ## Time\n\n  The `System` module also provides functions that work with time,\n  returning different times kept by the system with support for\n  different time units.\n\n  One of the complexities in relying on system times is that they\n  may be adjusted. For example, when you enter and leave daylight\n  saving time, the system clock will be adjusted, often adding\n  or removing one hour. We call such changes \"time warps\". In\n  order to understand how such changes may be harmful, imagine\n  the following code:\n\n      ## DO NOT DO THIS\n      prev = System.os_time()\n      # ... execute some code ...\n      next = System.os_time()\n      diff = next - prev\n\n  If, while the code is executing, the system clock changes,\n  some code that executed in 1 second may be reported as taking\n  over 1 hour! To address such concerns, the VM provides a\n  monotonic time via `System.monotonic_time/0` which never\n  decreases and does not leap:\n\n      ## DO THIS\n      prev = System.monotonic_time()\n      # ... execute some code ...\n      next = System.monotonic_time()\n      diff = next - prev\n\n  Generally speaking, the VM provides three time measurements:\n\n    * `os_time/0` - the time reported by the OS. This time may be\n      adjusted forwards or backwards in time with no limitation;\n\n    * `system_time/0` - the VM view of the `os_time/0`. The system time and OS\n      time may not match in case of time warps although the VM works towards\n      aligning them. This time is not monotonic (i.e., it may decrease)\n      as its behaviour is configured [by the VM time warp\n      mode](http://www.erlang.org/doc/apps/erts/time_correction.html#Time_Warp_Modes);\n\n    * `monotonic_time/0` - a monotonically increasing time provided\n      by the Erlang VM.\n\n  The time functions in this module work in the `:native` unit\n  (unless specified otherwise), which is OS dependent. Most of\n  the time, all calculations are done in the `:native` unit, to\n  avoid loss of precision, with `convert_time_unit/3` being\n  invoked at the end to convert to a specific time unit like\n  `:millisecond` or `:microsecond`. See the `t:time_unit/0` type for\n  more information.\n\n  For a more complete rundown on the VM support for different\n  times, see the [chapter on time and time\n  correction](http://www.erlang.org/doc/apps/erts/time_correction.html)\n  in the Erlang docs.\n  ",
    endianness = {
      description = "endianness\n\n  Returns the endianness.\n  "
    },
    find_executable = {
      description = "find_executable(binary) :: binary | nil\nfind_executable(program) when is_binary(program)\n\n  Locates an executable on the system.\n\n  This function looks up an executable program given\n  its name using the environment variable PATH on Unix\n  and Windows. It also considers the proper executable\n  extension for each OS, so for Windows it will try to\n  lookup files with `.com`, `.cmd` or similar extensions.\n  "
    },
    get_env = {
      description = "get_env(String.t) :: String.t | nil\nget_env(varname) when is_binary(varname)\nget_env() :: %{optional(String.t) => String.t}\nget_env\n\n  Returns all system environment variables.\n\n  The returned value is a map containing name-value pairs.\n  Variable names and their values are strings.\n  "
    },
    get_pid = {
      description = "get_pid() :: binary\nget_pid\n\n  Erlang VM process identifier.\n\n  Returns the process identifier of the current Erlang emulator\n  in the format most commonly used by the operating system environment.\n\n  For more information, see [`:os.getpid/0`](http://www.erlang.org/doc/man/os.html#getpid-0).\n  "
    },
    halt = {
      description = "halt(status) when is_binary(status)\nhalt(status) when is_integer(status) or status == :abort\nhalt(non_neg_integer | binary | :abort) :: no_return\nhalt(status \\\\ 0)\n\n  Immediately halts the Erlang runtime system.\n\n  Terminates the Erlang runtime system without properly shutting down\n  applications and ports. Please see `stop/1` for a careful shutdown of the\n  system.\n\n  `status` must be a non-negative integer, the atom `:abort` or a binary.\n\n    * If an integer, the runtime system exits with the integer value which\n      is returned to the operating system.\n\n    * If `:abort`, the runtime system aborts producing a core dump, if that is\n      enabled in the operating system.\n\n    * If a string, an Erlang crash dump is produced with status as slogan,\n      and then the runtime system exits with status code 1.\n\n  Note that on many platforms, only the status codes 0-255 are supported\n  by the operating system.\n\n  For more information, see [`:erlang.halt/1`](http://www.erlang.org/doc/man/erlang.html#halt-1).\n\n  ## Examples\n\n      System.halt(0)\n      System.halt(1)\n      System.halt(:abort)\n\n  "
    },
    monotonic_time = {
      description = "monotonic_time(time_unit) :: integer\nmonotonic_time(unit)\nmonotonic_time() :: integer\nmonotonic_time\n\n  Returns the current monotonic time in the `:native` time unit.\n\n  This time is monotonically increasing and starts in an unspecified\n  point in time.\n\n  Inlined by the compiler into `:erlang.monotonic_time/0`.\n  "
    },
    os_time = {
      description = "os_time(time_unit) :: integer\nos_time(unit)\nos_time() :: integer\nos_time\n\n  Returns the current OS time.\n\n  The result is returned in the `:native` time unit.\n\n  This time may be adjusted forwards or backwards in time\n  with no limitation and is not monotonic.\n\n  Inlined by the compiler into `:os.system_time/0`.\n  "
    },
    otp_release = {
      description = "otp_release :: String.t\notp_release\n\n  Returns the OTP release number.\n  "
    },
    put_env = {
      description = "put_env(Enumerable.t) :: :ok\nput_env(enum)\nput_env(binary, binary) :: :ok\nput_env(varname, value) when is_binary(varname) and is_binary(value)\n\n  Sets an environment variable value.\n\n  Sets a new `value` for the environment variable `varname`.\n  "
    },
    schedulers = {
      description = "schedulers :: pos_integer\nschedulers\n\n  Returns the number of schedulers in the VM.\n  "
    },
    schedulers_online = {
      description = "schedulers_online :: pos_integer\nschedulers_online\n\n  Returns the number of schedulers online in the VM.\n  "
    },
    stacktrace = {
      description = "stacktrace\n\n  Last exception stacktrace.\n\n  Note that the Erlang VM (and therefore this function) does not\n  return the current stacktrace but rather the stacktrace of the\n  latest exception.\n\n  Inlined by the compiler into `:erlang.get_stacktrace/0`.\n  "
    },
    stop = {
      description = "stop(status) when is_binary(status)\nstop(status) when is_integer(status)\nstop(non_neg_integer | binary) :: no_return\nstop(status \\\\ 0)\n\n  Carefully stops the Erlang runtime system.\n\n  All applications are taken down smoothly, all code is unloaded, and all ports\n  are closed before the system terminates by calling `halt/1`.\n\n  `status` must be a non-negative integer value which is returned by the\n  runtime system to the operating system.\n\n  Note that on many platforms, only the status codes 0-255 are supported\n  by the operating system.\n\n  For more information, see [`:init.stop/1`](http://erlang.org/doc/man/init.html#stop-1).\n\n  ## Examples\n\n      System.stop(0)\n      System.stop(1)\n\n  "
    },
    system_time = {
      description = "system_time(time_unit) :: integer\nsystem_time(unit)\nsystem_time() :: integer\nsystem_time\n\n  Returns the current system time in the `:native` time unit.\n\n  It is the VM view of the `os_time/0`. They may not match in\n  case of time warps although the VM works towards aligning\n  them. This time is not monotonic.\n\n  Inlined by the compiler into `:erlang.system_time/0`.\n  "
    },
    time_offset = {
      description = "time_offset(time_unit) :: integer\ntime_offset(unit)\ntime_offset() :: integer\ntime_offset\n\n  Returns the current time offset between the Erlang VM monotonic\n  time and the Erlang VM system time.\n\n  The result is returned in the `:native` time unit.\n\n  See `time_offset/1` for more information.\n\n  Inlined by the compiler into `:erlang.time_offset/0`.\n  "
    },
    time_unit = {
      description = "time_unit :: :second\n\n  The time unit to be passed to functions like `monotonic_time/1` and others.\n\n  The `:second`, `:millisecond`, `:microsecond` and `:nanosecond` time\n  units controls the return value of the functions that accept a time unit.\n\n  A time unit can also be a strictly positive integer. In this case, it\n  represents the \"parts per second\": the time will be returned in `1 /\n  parts_per_second` seconds. For example, using the `:millisecond` time unit\n  is equivalent to using `1000` as the time unit (as the time will be returned\n  in 1/1000 seconds - milliseconds).\n\n  Keep in mind the Erlang API prior to version 19.1 will use `:milli_seconds`,\n  `:micro_seconds` and `:nano_seconds` as time units although Elixir normalizes\n  their spelling to match the SI convention.\n  "
    },
    tmp_dir = {
      description = "tmp_dir\n\n  Writable temporary directory.\n\n  Returns a writable temporary directory.\n  Searches for directories in the following order:\n\n    1. the directory named by the TMPDIR environment variable\n    2. the directory named by the TEMP environment variable\n    3. the directory named by the TMP environment variable\n    4. `C:\\TMP` on Windows or `/tmp` on Unix\n    5. as a last resort, the current working directory\n\n  Returns `nil` if none of the above are writable.\n  "
    },
    ["tmp_dir!"] = {
      description = "tmp_dir!\n\n  Writable temporary directory, exception on error.\n\n  Same as `tmp_dir/0` but raises `RuntimeError`\n  instead of returning `nil` if no temp dir is set.\n  "
    },
    unique_integer = {
      description = "unique_integer([:positive | :monotonic]) :: integer\nunique_integer(modifiers \\\\ [])\n\n  Generates and returns an integer that is unique in the current runtime\n  instance.\n\n  \"Unique\" means that this function, called with the same list of `modifiers`,\n  will never return the same integer more than once on the current runtime\n  instance.\n\n  If `modifiers` is `[]`, then a unique integer (that can be positive or negative) is returned.\n  Other modifiers can be passed to change the properties of the returned integer:\n\n    * `:positive` - the returned integer is guaranteed to be positive.\n    * `:monotonic` - the returned integer is monotonically increasing. This\n      means that, on the same runtime instance (but even on different\n      processes), integers returned using the `:monotonic` modifier will always\n      be strictly less than integers returned by successive calls with the\n      `:monotonic` modifier.\n\n  All modifiers listed above can be combined; repeated modifiers in `modifiers`\n  will be ignored.\n\n  Inlined by the compiler into `:erlang.unique_integer/1`.\n  "
    },
    user_home = {
      description = "user_home\n\n  User home directory.\n\n  Returns the user home directory (platform independent).\n  "
    },
    ["user_home!"] = {
      description = "user_home!\n\n  User home directory, exception on error.\n\n  Same as `user_home/0` but raises `RuntimeError`\n  instead of returning `nil` if no user home is set.\n  "
    },
    version = {
      description = "version() :: String.t\nversion\n\n  Elixir version information.\n\n  Returns Elixir's version as binary.\n  "
    }
  },
  SystemLimitError = {
    message = {
      description = "message(_)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    }
  },
  Task = {
    Supervised = {
      description = "false",
      noreply = {
        description = "noreply(info, mfa)\n"
      },
      reply = {
        description = "reply(caller, monitor, info, mfa)\n"
      },
      spawn_link = {
        description = "spawn_link(caller, monitor \\\\ :nomonitor, info, fun)\n"
      },
      start = {
        description = "start(info, fun)\n"
      },
      start_link = {
        description = "start_link(caller, monitor, info, fun)\nstart_link(info, fun)\n"
      },
      stream = {
        description = "stream(enumerable, acc, reducer, mfa, options, spawn)\n"
      }
    },
    Supervisor = {
      async = {
        description = "async(Supervisor.supervisor, module, atom, [term]) :: Task.t\nasync(supervisor, module, fun, args)\nasync(Supervisor.supervisor, fun) :: Task.t\nasync(supervisor, fun)\n\n  Starts a task that can be awaited on.\n\n  The `supervisor` must be a reference as defined in `Task.Supervisor`.\n  The task will still be linked to the caller, see `Task.async/3` for\n  more information and `async_nolink/2` for a non-linked variant.\n  "
      },
      async_nolink = {
        description = "async_nolink(Supervisor.supervisor, module, atom, [term]) :: Task.t\nasync_nolink(supervisor, module, fun, args)\nasync_nolink(Supervisor.supervisor, fun) :: Task.t\nasync_nolink(supervisor, fun)\n\n  Starts a task that can be awaited on.\n\n  The `supervisor` must be a reference as defined in `Task.Supervisor`.\n  The task won't be linked to the caller, see `Task.async/3` for\n  more information.\n\n  ## Compatibility with OTP behaviours\n\n  If you create a task using `async_nolink` inside an OTP behaviour\n  like `GenServer`, you should match on the message coming from the\n  task inside your `GenServer.handle_info/2` callback.\n\n  The reply sent by the task will be in the format `{ref, result}`,\n  where `ref` is the monitor reference held by the task struct\n  and `result` is the return value of the task function.\n\n  Keep in mind that, regardless of how the task created with `async_nolink`\n  terminates, the caller's process will always receive a `:DOWN` message\n  with the same `ref` value that is held by the task struct. If the task\n  terminates normally, the reason in the `:DOWN` message will be `:normal`.\n  "
      },
      async_stream = {
        description = "async_stream(Supervisor.supervisor, Enumerable.t, (term -> term), Keyword.t) ::\nasync_stream(supervisor, enumerable, fun, options \\\\ []) when is_function(fun, 1)\nasync_stream(Supervisor.supervisor, Enumerable.t, module, atom, [term], Keyword.t) ::\nasync_stream(supervisor, enumerable, module, function, args, options \\\\ [])\n\n  Returns a stream that runs the given `module`, `function`, and `args`\n  concurrently on each item in `enumerable`.\n\n  Each item will be appended to the given `args` and processed by its\n  own task. The tasks will be spawned under the given `supervisor` and\n  linked to the current process, similarly to `async/4`.\n\n  When streamed, each task will emit `{:ok, val}` upon successful\n  completion or `{:exit, val}` if the caller is trapping exits. Results\n  are emitted in the same order as the original `enumerable`.\n\n  The level of concurrency can be controlled via the `:max_concurrency`\n  option and defaults to `System.schedulers_online/0`. A timeout\n  can also be given as an option representing the maximum amount of\n  time to wait without a task reply.\n\n  Finally, if you find yourself trapping exits to handle exits inside\n  the async stream, consider using `async_stream_nolink/6` to start tasks\n  that are not linked to the current process.\n\n  ## Options\n\n    * `:max_concurrency` - sets the maximum number of tasks to run\n      at the same time. Defaults to `System.schedulers_online/0`.\n    * `:timeout` - the maximum amount of time to wait (in milliseconds)\n      without receiving a task reply (across all running tasks).\n      Defaults to `5000`.\n\n  ## Examples\n\n  Let's build a stream and then enumerate it:\n\n      stream = Task.Supervisor.async_stream(MySupervisor, collection, Mod, :expensive_fun, [])\n      Enum.to_list(stream)\n\n  "
      },
      async_stream_nolink = {
        description = "async_stream_nolink(Supervisor.supervisor, Enumerable.t, (term -> term), Keyword.t) ::\nasync_stream_nolink(supervisor, enumerable, fun, options \\\\ []) when is_function(fun, 1)\nasync_stream_nolink(Supervisor.supervisor, Enumerable.t, module, atom, [term], Keyword.t) ::\nasync_stream_nolink(supervisor, enumerable, module, function, args, options \\\\ [])\n\n  Returns a stream that runs the given `module`, `function`, and `args`\n  concurrently on each item in `enumerable`.\n\n  Each item in `enumerable` will be appended to the given `args` and processed\n  by its own task. The tasks will be spawned under the given `supervisor` and\n  will not be linked to the current process, similarly to `async_nolink/4`.\n\n  See `async_stream/6` for discussion, options, and examples.\n  "
      },
      children = {
        description = "children(Supervisor.supervisor) :: [pid]\nchildren(supervisor)\n\n  Returns all children PIDs.\n  "
      },
      description = "\n  A task supervisor.\n\n  This module defines a supervisor which can be used to dynamically\n  supervise tasks. Behind the scenes, this module is implemented as a\n  `:simple_one_for_one` supervisor where the workers are temporary by\n  default (that is, they are not restarted after they die; read the docs\n  for `start_link/1` for more information on choosing the restart\n  strategy).\n\n  See the `Task` module for more information.\n\n  ## Name registration\n\n  A `Task.Supervisor` is bound to the same name registration rules as a\n  `GenServer`. Read more about them in the `GenServer` docs.\n  ",
      start_child = {
        description = "start_child(Supervisor.supervisor, module, atom, [term]) :: {:ok, pid}\nstart_child(supervisor, module, fun, args)\nstart_child(Supervisor.supervisor, fun) :: {:ok, pid}\nstart_child(supervisor, fun)\n\n  Starts a task as a child of the given `supervisor`.\n\n  Note that the spawned process is not linked to the caller, but\n  only to the supervisor. This command is useful in case the\n  task needs to perform side-effects (like I/O) and does not need\n  to report back to the caller.\n  "
      },
      start_link = {
        description = "start_link(Supervisor.options) :: Supervisor.on_start\nstart_link(opts \\\\ [])\n\n  Starts a new supervisor.\n\n  The supported options are:\n\n  * `:name` - used to register a supervisor name, the supported values are\n    described under the `Name Registration` section in the `GenServer` module\n    docs;\n\n  * `:restart` - the restart strategy, may be `:temporary` (the default),\n    `:transient` or `:permanent`. Check `Supervisor.Spec` for more info.\n    Defaults to `:temporary` so tasks aren't automatically restarted when\n    they complete nor in case of crashes;\n\n  * `:shutdown` - `:brutal_kill` if the tasks must be killed directly on shutdown\n    or an integer indicating the timeout value, defaults to 5000 milliseconds;\n\n  * `:max_restarts` and `:max_seconds` - as specified in `Supervisor.Spec.supervise/2`;\n\n  "
      },
      terminate_child = {
        description = "terminate_child(Supervisor.supervisor, pid) :: :ok\nterminate_child(supervisor, pid) when is_pid(pid)\n\n  Terminates the child with the given `pid`.\n  "
      }
    },
    async = {
      description = "async(module, atom, [term]) :: t\nasync(mod, fun, args)\nasync(fun) :: t\nasync(fun)\n\n  Starts a task that must be awaited on.\n\n  This function spawns a process that is linked to and monitored\n  by the caller process. A `Task` struct is returned containing\n  the relevant information.\n\n  Read the `Task` module documentation for more info on general\n  usage of `async/1` and `async/3`.\n\n  See also `async/3`.\n  "
    },
    async_stream = {
      description = "async_stream(Enumerable.t, (term -> term), Keyword.t) :: Enumerable.t\nasync_stream(enumerable, fun, options \\\\ []) when is_function(fun, 1)\nasync_stream(Enumerable.t, module, atom, [term], Keyword.t) :: Enumerable.t\nasync_stream(enumerable, module, function, args, options \\\\ [])\n\n  Returns a stream that runs the given `module`, `function`, and `args`\n  concurrently on each item in `enumerable`.\n\n  Each item will be prepended to the given `args` and processed by its\n  own task. The tasks will be linked to an intermediate process that is\n  then linked to the current process. This means a failure in a task\n  terminates the current process and a failure in the current process\n  terminates all tasks.\n\n  When streamed, each task will emit `{:ok, val}` upon successful\n  completion or `{:exit, val}` if the caller is trapping exits. Results\n  are emitted in the same order as the original `enumerable`.\n\n  The level of concurrency can be controlled via the `:max_concurrency`\n  option and defaults to `System.schedulers_online/0`. A timeout\n  can also be given as an option representing the maximum amount of\n  time to wait without a task reply.\n\n  Finally, consider using `Task.Supervisor.async_stream/6` to start tasks\n  under a supervisor. If you find yourself trapping exits to handle exits\n  inside the async stream, consider using `Task.Supervisor.async_stream_nolink/6`\n  to start tasks that are not linked to the current process.\n\n  ## Options\n\n    * `:max_concurrency` - sets the maximum number of tasks to run\n      at the same time. Defaults to `System.schedulers_online/0`.\n    * `:timeout` - the maximum amount of time to wait (in milliseconds)\n      without receiving a task reply (across all running tasks).\n      Defaults to `5000`.\n\n  ## Example\n\n  Let's build a stream and then enumerate it:\n\n      stream = Task.async_stream(collection, Mod, :expensive_fun, [])\n      Enum.to_list(stream)\n\n  The concurrency can be increased or decreased using the `:max_concurrency`\n  option. For example, if the tasks are IO heavy, the value can be increased:\n\n      max_concurrency = System.schedulers_online * 2\n      stream = Task.async_stream(collection, Mod, :expensive_fun, [], max_concurrency: max_concurrency)\n      Enum.to_list(stream)\n\n  "
    },
    await = {
      description = "await(%Task{ref: ref} = task, timeout)\nawait(%Task{owner: owner} = task, _) when owner != self()\nawait(t, timeout) :: term | no_return\nawait(task, timeout \\\\ 5000)\n\n  Awaits a task reply and returns it.\n\n  A timeout, in milliseconds, can be given with default value\n  of `5000`. In case the task process dies, this function will\n  exit with the same reason as the task.\n\n  If the timeout is exceeded, `await` will exit; however,\n  the task will continue to run. When the calling process exits, its\n  exit signal will terminate the task if it is not trapping exits.\n\n  This function assumes the task's monitor is still active or the monitor's\n  `:DOWN` message is in the message queue. If it has been demonitored, or the\n  message already received, this function will wait for the duration of the\n  timeout awaiting the message.\n\n  This function can only be called once for any given task. If you want\n  to be able to check multiple times if a long-running task has finished\n  its computation, use `yield/2` instead.\n\n  ## Compatibility with OTP behaviours\n\n  It is not recommended to `await` a long-running task inside an OTP\n  behaviour such as `GenServer`. Instead, you should match on the message\n  coming from a task inside your `GenServer.handle_info/2` callback.\n\n  ## Examples\n\n      iex> task = Task.async(fn -> 1 + 1 end)\n      iex> Task.await(task)\n      2\n\n  "
    },
    description = "\n  Conveniences for spawning and awaiting tasks.\n\n  Tasks are processes meant to execute one particular\n  action throughout their lifetime, often with little or no\n  communication with other processes. The most common use case\n  for tasks is to convert sequential code into concurrent code\n  by computing a value asynchronously:\n\n      task = Task.async(fn -> do_some_work() end)\n      res  = do_some_other_work()\n      res + Task.await(task)\n\n  Tasks spawned with `async` can be awaited on by their caller\n  process (and only their caller) as shown in the example above.\n  They are implemented by spawning a process that sends a message\n  to the caller once the given computation is performed.\n\n  Besides `async/1` and `await/2`, tasks can also be\n  started as part of a supervision tree and dynamically spawned\n  on remote nodes. We will explore all three scenarios next.\n\n  ## async and await\n\n  One of the common uses of tasks is to convert sequential code\n  into concurrent code with `Task.async/1` while keeping its semantics.\n  When invoked, a new process will be created, linked and monitored\n  by the caller. Once the task action finishes, a message will be sent\n  to the caller with the result.\n\n  `Task.await/2` is used to read the message sent by the task.\n\n  There are two important things to consider when using `async`:\n\n    1. If you are using async tasks, you **must await** a reply\n       as they are *always* sent. If you are not expecting a reply,\n       consider using `Task.start_link/1` detailed below.\n\n    2. async tasks link the caller and the spawned process. This\n       means that, if the caller crashes, the task will crash\n       too and vice-versa. This is on purpose: if the process\n       meant to receive the result no longer exists, there is\n       no purpose in completing the computation.\n\n       If this is not desired, use `Task.start/1` or consider starting\n       the task under a `Task.Supervisor` using `async_nolink` or\n       `start_child`.\n\n  `Task.yield/2` is an alternative to `await/2` where the caller will\n  temporarily block, waiting until the task replies or crashes. If the\n  result does not arrive within the timeout, it can be called again at a\n  later moment. This allows checking for the result of a task multiple\n  times. If a reply does not arrive within the desired time,\n  `Task.shutdown/2` can be used to stop the task.\n\n  ## Supervised tasks\n\n  It is also possible to spawn a task under a supervisor:\n\n      import Supervisor.Spec\n\n      children = [\n        #\n        worker(Task, [fn -> IO.puts \"ok\" end])\n      ]\n\n  Internally the supervisor will invoke `Task.start_link/1`.\n\n  Since these tasks are supervised and not directly linked to\n  the caller, they cannot be awaited on. Note `start_link/1`,\n  unlike `async/1`, returns `{:ok, pid}` (which is\n  the result expected by supervision trees).\n\n  By default, most supervision strategies will try to restart\n  a worker after it exits regardless of the reason. If you design\n  the task to terminate normally (as in the example with `IO.puts/2`\n  above), consider passing `restart: :transient` in the options\n  to `Supervisor.Spec.worker/3`.\n\n  ## Dynamically supervised tasks\n\n  The `Task.Supervisor` module allows developers to dynamically\n  create multiple supervised tasks.\n\n  A short example is:\n\n      {:ok, pid} = Task.Supervisor.start_link()\n      task = Task.Supervisor.async(pid, fn ->\n        # Do something\n      end)\n      Task.await(task)\n\n  However, in the majority of cases, you want to add the task supervisor\n  to your supervision tree:\n\n      import Supervisor.Spec\n\n      children = [\n        supervisor(Task.Supervisor, [[name: MyApp.TaskSupervisor]])\n      ]\n\n  Now you can dynamically start supervised tasks:\n\n      Task.Supervisor.start_child(MyApp.TaskSupervisor, fn ->\n        # Do something\n      end)\n\n  Or even use the async/await pattern:\n\n      Task.Supervisor.async(MyApp.TaskSupervisor, fn ->\n        # Do something\n      end) |> Task.await()\n\n  Finally, check `Task.Supervisor` for other supported operations.\n\n  ## Distributed tasks\n\n  Since Elixir provides a Task supervisor, it is easy to use one\n  to dynamically spawn tasks across nodes:\n\n      # On the remote node\n      Task.Supervisor.start_link(name: MyApp.DistSupervisor)\n\n      # On the client\n      Task.Supervisor.async({MyApp.DistSupervisor, :remote@local},\n                            MyMod, :my_fun, [arg1, arg2, arg3])\n\n  Note that, when working with distributed tasks, one should use the `Task.Supervisor.async/4` function\n  that expects explicit module, function and arguments, instead of `Task.Supervisor.async/2` that\n  works with anonymous functions. That's because anonymous functions expect\n  the same module version to exist on all involved nodes. Check the `Agent` module\n  documentation for more information on distributed processes as the limitations\n  described there apply to the whole ecosystem.\n  ",
    find = {
      description = "find(tasks, msg)\nfalse"
    },
    shutdown = {
      description = "shutdown(%Task{pid: pid} = task, timeout)\nshutdown(%Task{pid: pid} = task, :brutal_kill)\nshutdown(%Task{owner: owner} = task, _) when owner != self()\nshutdown(%Task{pid: nil} = task, _)\nshutdown(t, timeout | :brutal_kill) :: {:ok, term} | {:exit, term} | nil\nshutdown(task, shutdown \\\\ 5_000)\n\n  Unlinks and shuts down the task, and then checks for a reply.\n\n  Returns `{:ok, reply}` if the reply is received while shutting down the task,\n  `{:exit, reason}` if the task died, otherwise `nil`.\n\n  The shutdown method is either a timeout or `:brutal_kill`. In case\n  of a `timeout`, a `:shutdown` exit signal is sent to the task process\n  and if it does not exit within the timeout, it is killed. With `:brutal_kill`\n  the task is killed straight away. In case the task terminates abnormally\n  (possibly killed by another process), this function will exit with the same reason.\n\n  It is not required to call this function when terminating the caller, unless\n  exiting with reason `:normal` or if the task is trapping exits. If the caller is\n  exiting with a reason other than `:normal` and the task is not trapping exits, the\n  caller's exit signal will stop the task. The caller can exit with reason\n  `:shutdown` to shutdown all of its linked processes, including tasks, that\n  are not trapping exits without generating any log messages.\n\n  If a task's monitor has already been demonitored or received  and there is not\n  a response waiting in the message queue this function will return\n  `{:exit, :noproc}` as the result or exit reason can not be determined.\n  "
    },
    start = {
      description = "start(module, atom, [term]) :: {:ok, pid}\nstart(mod, fun, args)\nstart(fun) :: {:ok, pid}\nstart(fun)\n\n  Starts a task.\n\n  This is only used when the task is used for side-effects\n  (i.e. no interest in the returned result) and it should not\n  be linked to the current process.\n  "
    },
    start_link = {
      description = "start_link(module, atom, [term]) :: {:ok, pid}\nstart_link(mod, fun, args)\nstart_link(fun) :: {:ok, pid}\nstart_link(fun)\n\n  Starts a task as part of a supervision tree.\n  "
    },
    t = {
      description = "t :: %__MODULE__{}\n"
    },
    yield = {
      description = "yield(%Task{ref: ref} = task, timeout)\nyield(%Task{owner: owner} = task, _) when owner != self()\nyield(t, timeout) :: {:ok, term} | {:exit, term} | nil\nyield(task, timeout \\\\ 5_000)\n\n  Temporarily blocks the current process waiting for a task reply.\n\n  Returns `{:ok, reply}` if the reply is received, `nil` if\n  no reply has arrived, or `{:exit, reason}` if the task has already\n  exited. Keep in mind that normally a task failure also causes\n  the process owning the task to exit. Therefore this function can\n  return `{:exit, reason}` only if\n\n    * the task process exited with the reason `:normal`\n    * it isn't linked to the caller\n    * the caller is trapping exits\n\n  A timeout, in milliseconds, can be given with default value\n  of `5000`. If the time runs out before a message from\n  the task is received, this function will return `nil`\n  and the monitor will remain active. Therefore `yield/2` can be\n  called multiple times on the same task.\n\n  This function assumes the task's monitor is still active or the\n  monitor's `:DOWN` message is in the message queue. If it has been\n  demonitored or the message already received, this function will wait\n  for the duration of the timeout awaiting the message.\n\n  If you intend to shut the task down if it has not responded within `timeout`\n  milliseconds, you should chain this together with `shutdown/1`, like so:\n\n      case Task.yield(task, timeout) || Task.shutdown(task) do\n        {:ok, result} ->\n          result\n        nil ->\n          Logger.warn \"Failed to get a result in #{timeout}ms\"\n          nil\n      end\n\n  That ensures that if the task completes after the `timeout` but before `shutdown/1`\n  has been called, you will still get the result, since `shutdown/1` is designed to\n  handle this case and return the result.\n  "
    },
    yield_many = {
      description = "yield_many([t], timeout) :: [{t, {:ok, term} | {:exit, term} | nil}]\nyield_many(tasks, timeout \\\\ 5000)\n\n  Yields to multiple tasks in the given time interval.\n\n  This function receives a list of tasks and waits for their\n  replies in the given time interval. It returns a list\n  of tuples of two elements, with the task as the first element\n  and the yielded result as the second.\n\n  Similarly to `yield/2`, each task's result will be\n\n    * `{:ok, term}` if the task has successfully reported its\n      result back in the given time interval\n    * `{:exit, reason}` if the task has died\n    * `nil` if the task keeps running past the timeout\n\n  Check `yield/2` for more information.\n\n  ## Example\n\n  `Task.yield_many/2` allows developers to spawn multiple tasks\n  and retrieve the results received in a given timeframe.\n  If we combine it with `Task.shutdown/2`, it allows us to gather\n  those results and cancel the tasks that have not replied in time.\n\n  Let's see an example.\n\n      tasks =\n        for i <- 1..10 do\n          Task.async(fn ->\n            Process.sleep(i * 1000)\n            i\n          end)\n        end\n\n      tasks_with_results = Task.yield_many(tasks, 5000)\n\n      results = Enum.map(tasks_with_results, fn {task, res} ->\n        # Shutdown the tasks that did not reply nor exit\n        res || Task.shutdown(task, :brutal_kill)\n      end)\n\n      # Here we are matching only on {:ok, value} and\n      # ignoring {:exit, _} (crashed tasks) and `nil` (no replies)\n      for {:ok, value} <- results do\n        IO.inspect value\n      end\n\n  In the example above, we create tasks that sleep from 1\n  up to 10 seconds and return the amount of seconds they slept.\n  If you execute the code all at once, you should see 1 up to 5\n  printed, as those were the tasks that have replied in the\n  given time. All other tasks will have been shut down using\n  the `Task.shutdown/2` call.\n  "
    }
  },
  Time = {
    compare = {
      description = "compare(Calendar.time, Calendar.time) :: :lt | :eq | :gt\ncompare(time1, time2)\n\n  Compares two `Time` structs.\n\n  Returns `:gt` if first time is later than the second\n  and `:lt` for vice versa. If the two times are equal\n  `:eq` is returned\n\n  ## Examples\n\n      iex> Time.compare(~T[16:04:16], ~T[16:04:28])\n      :lt\n      iex> Time.compare(~T[16:04:16.01], ~T[16:04:16.001])\n      :gt\n\n  This function can also be used to compare across more\n  complex calendar types by considering only the time fields:\n\n      iex> Time.compare(~N[2015-01-01 16:04:16], ~N[2015-01-01 16:04:28])\n      :lt\n      iex> Time.compare(~N[2015-01-01 16:04:16.01], ~N[2000-01-01 16:04:16.001])\n      :gt\n\n  "
    },
    description = "\n  A Time struct and functions.\n\n  The Time struct contains the fields hour, minute, second and microseconds.\n  New times can be built with the `new/4` function or using the `~T`\n  sigil:\n\n      iex> ~T[23:00:07.001]\n      ~T[23:00:07.001]\n\n  Both `new/4` and sigil return a struct where the time fields can\n  be accessed directly:\n\n      iex> time = ~T[23:00:07.001]\n      iex> time.hour\n      23\n      iex> time.microsecond\n      {1000, 3}\n\n  The functions on this module work with the `Time` struct as well\n  as any struct that contains the same fields as the `Time` struct,\n  such as `NaiveDateTime` and `DateTime`. Such functions expect\n  `t:Calendar.time/0` in their typespecs (instead of `t:t/0`).\n\n  Remember, comparisons in Elixir using `==`, `>`, `<` and friends\n  are structural and based on the Time struct fields. For proper\n  comparison between times, use the `compare/2` function.\n\n  Developers should avoid creating the Time struct directly and\n  instead rely on the functions provided by this module as well as\n  the ones in 3rd party calendar libraries.\n  ",
    from_erl = {
      description = "from_erl({hour, minute, second}, microsecond)\nfrom_erl(:calendar.time, Calendar.microsecond) :: {:ok, t} | {:error, atom}\nfrom_erl(tuple, microsecond \\\\ {0, 0})\n\n  Converts an Erlang time tuple to a `Time` struct.\n\n  ## Examples\n\n      iex> Time.from_erl({23, 30, 15}, {5000, 3})\n      {:ok, ~T[23:30:15.005]}\n      iex> Time.from_erl({24, 30, 15})\n      {:error, :invalid_time}\n  "
    },
    ["from_erl!"] = {
      description = "from_erl!(:calendar.time, Calendar.microsecond) :: t | no_return\nfrom_erl!(tuple, microsecond \\\\ {0, 0})\n\n  Converts an Erlang time tuple to a `Time` struct.\n\n  ## Examples\n\n      iex> Time.from_erl!({23, 30, 15})\n      ~T[23:30:15]\n      iex> Time.from_erl!({23, 30, 15}, {5000, 3})\n      ~T[23:30:15.005]\n      iex> Time.from_erl!({24, 30, 15})\n      ** (ArgumentError) cannot convert {24, 30, 15} to time, reason: :invalid_time\n  "
    },
    from_iso8601 = {
      description = "from_iso8601(<<_::binary>>)\nfrom_iso8601(<<hour::2-bytes, ?:, min::2-bytes, ?:, sec::2-bytes, rest::binary>>)\nfrom_iso8601(<<?T, h, rest::binary>>) when h in ?0..?9\nfrom_iso8601(String.t) :: {:ok, t} | {:error, atom}\nfrom_iso8601(string)\n\n  Parses the extended \"Local time\" format described by\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  Timezone offset may be included in the string but they will be\n  simply discarded as such information is not included in times.\n\n  As specified in the standard, the separator \"T\" may be omitted if\n  desired as there is no ambiguity within this function.\n\n  Time representations with reduced accuracy are not supported.\n\n  ## Examples\n\n      iex> Time.from_iso8601(\"23:50:07\")\n      {:ok, ~T[23:50:07]}\n      iex> Time.from_iso8601(\"23:50:07Z\")\n      {:ok, ~T[23:50:07]}\n      iex> Time.from_iso8601(\"T23:50:07Z\")\n      {:ok, ~T[23:50:07]}\n\n      iex> Time.from_iso8601(\"23:50:07.0123456\")\n      {:ok, ~T[23:50:07.012345]}\n      iex> Time.from_iso8601(\"23:50:07.123Z\")\n      {:ok, ~T[23:50:07.123]}\n\n      iex> Time.from_iso8601(\"2015:01:23 23-50-07\")\n      {:error, :invalid_format}\n      iex> Time.from_iso8601(\"23:50:07A\")\n      {:error, :invalid_format}\n      iex> Time.from_iso8601(\"23:50:07.\")\n      {:error, :invalid_format}\n      iex> Time.from_iso8601(\"23:50:61\")\n      {:error, :invalid_time}\n\n  "
    },
    ["from_iso8601!"] = {
      description = "from_iso8601!(String.t) :: t | no_return\nfrom_iso8601!(string)\n\n  Parses the extended \"Local time\" format described by\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  Raises if the format is invalid.\n\n  ## Examples\n\n      iex> Time.from_iso8601!(\"23:50:07.123Z\")\n      ~T[23:50:07.123]\n      iex> Time.from_iso8601!(\"2015:01:23 23-50-07\")\n      ** (ArgumentError) cannot parse \"2015:01:23 23-50-07\" as time, reason: :invalid_format\n  "
    },
    inspect = {
      description = "inspect(%{hour: hour, minute: minute, second: second, microsecond: microsecond}, _)\n\n  Compares two `Time` structs.\n\n  Returns `:gt` if first time is later than the second\n  and `:lt` for vice versa. If the two times are equal\n  `:eq` is returned\n\n  ## Examples\n\n      iex> Time.compare(~T[16:04:16], ~T[16:04:28])\n      :lt\n      iex> Time.compare(~T[16:04:16.01], ~T[16:04:16.001])\n      :gt\n\n  This function can also be used to compare across more\n  complex calendar types by considering only the time fields:\n\n      iex> Time.compare(~N[2015-01-01 16:04:16], ~N[2015-01-01 16:04:28])\n      :lt\n      iex> Time.compare(~N[2015-01-01 16:04:16.01], ~N[2000-01-01 16:04:16.001])\n      :gt\n\n  "
    },
    new = {
      description = "new(hour, minute, second, {microsecond, precision})\nnew(hour, minute, second, microsecond) when is_integer(microsecond)\nnew(Calendar.hour, Calendar.minute, Calendar.second, Calendar.microsecond) ::\nnew(hour, minute, second, microsecond \\\\ {0, 0})\n\n  Builds a new time.\n\n  Expects all values to be integers. Returns `{:ok, time}` if each\n  entry fits its appropriate range, returns `{:error, reason}` otherwise.\n\n  Note a time may have 60 seconds in case of leap seconds.\n\n  ## Examples\n\n      iex> Time.new(0, 0, 0, 0)\n      {:ok, ~T[00:00:00.000000]}\n      iex> Time.new(23, 59, 59, 999_999)\n      {:ok, ~T[23:59:59.999999]}\n      iex> Time.new(23, 59, 60, 999_999)\n      {:ok, ~T[23:59:60.999999]}\n\n      # Time with microseconds and their precision\n      iex> Time.new(23, 59, 60, {10_000, 2})\n      {:ok, ~T[23:59:60.01]}\n\n      iex> Time.new(24, 59, 59, 999_999)\n      {:error, :invalid_time}\n      iex> Time.new(23, 60, 59, 999_999)\n      {:error, :invalid_time}\n      iex> Time.new(23, 59, 61, 999_999)\n      {:error, :invalid_time}\n      iex> Time.new(23, 59, 59, 1_000_000)\n      {:error, :invalid_time}\n\n  "
    },
    t = {
      description = "t :: %Time{hour: Calendar.hour, minute: Calendar.minute,\n\n  Microseconds with stored precision.\n\n  The precision represents the number of digits\n  that must be used when representing the microseconds\n  to external format. If the precision is 0, it means\n  microseconds must be skipped.\n  "
    },
    to_erl = {
      description = "to_erl(%{hour: hour, minute: minute, second: second})\nto_erl(Calendar.time) :: :calendar.time\nto_erl(time)\n\n  Converts a `Time` struct to an Erlang time tuple.\n\n  WARNING: Loss of precision may occur, as Erlang time tuples\n  only contain hours/minutes/seconds.\n\n  ## Examples\n\n      iex> Time.to_erl(~T[23:30:15.999])\n      {23, 30, 15}\n\n      iex> Time.to_erl(~N[2015-01-01 23:30:15.999])\n      {23, 30, 15}\n\n  "
    },
    to_iso8601 = {
      description = "to_iso8601(%{hour: hour, minute: minute, second: second, microsecond: microsecond})\nto_iso8601(Calendar.time) :: String.t\nto_iso8601(time)\n\n  Converts the given time to\n  [ISO 8601:2004](https://en.wikipedia.org/wiki/ISO_8601).\n\n  ### Examples\n\n      iex> Time.to_iso8601(~T[23:00:13])\n      \"23:00:13\"\n      iex> Time.to_iso8601(~T[23:00:13.001])\n      \"23:00:13.001\"\n\n      iex> Time.to_iso8601(~N[2015-01-01 23:00:13])\n      \"23:00:13\"\n      iex> Time.to_iso8601(~N[2015-01-01 23:00:13.001])\n      \"23:00:13.001\"\n\n  "
    },
    to_string = {
      description = "to_string(%{hour: hour, minute: minute, second: second, microsecond: microsecond})\nto_string(%{hour: hour, minute: minute, second: second, microsecond: microsecond})\nto_string(Calendar.time) :: String.t\nto_string(time)\n\n  Converts the given time to a string.\n\n  ### Examples\n\n      iex> Time.to_string(~T[23:00:00])\n      \"23:00:00\"\n      iex> Time.to_string(~T[23:00:00.001])\n      \"23:00:00.001\"\n      iex> Time.to_string(~T[23:00:00.123456])\n      \"23:00:00.123456\"\n\n      iex> Time.to_string(~N[2015-01-01 23:00:00.001])\n      \"23:00:00.001\"\n      iex> Time.to_string(~N[2015-01-01 23:00:00.123456])\n      \"23:00:00.123456\"\n\n  "
    },
    utc_now = {
      description = "utc_now() :: t\nutc_now()\n\n  Returns the current time in UTC.\n\n  ## Examples\n\n      iex> time = Time.utc_now()\n      iex> time.hour >= 0\n      true\n\n  "
    }
  },
  TokenMissingError = {
    message = {
      description = "message(%{file: file, line: line, description: description})\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    }
  },
  TryClauseError = {
    message = {
      description = "message(exception)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    }
  },
  Tuple = {
    append = {
      description = "append(tuple, term) :: tuple\nappend(tuple, value)\n\n  Inserts an element at the end of a tuple.\n\n  Returns a new tuple with the element appended at the end, and contains\n  the elements in `tuple` followed by `value` as the last element.\n\n  Inlined by the compiler.\n\n  ## Examples\n      iex> tuple = {:foo, :bar}\n      iex> Tuple.append(tuple, :baz)\n      {:foo, :bar, :baz}\n\n  "
    },
    delete_at = {
      description = "delete_at(tuple, non_neg_integer) :: tuple\ndelete_at(tuple, index)\n\n  Removes an element from a tuple.\n\n  Deletes the element at the given `index` from `tuple`.\n  Raises an `ArgumentError` if `index` is negative or greater than\n  or equal to the length of `tuple`. Index is zero-based.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> tuple = {:foo, :bar, :baz}\n      iex> Tuple.delete_at(tuple, 0)\n      {:bar, :baz}\n\n  "
    },
    description = "\n  Functions for working with tuples.\n\n  Tuples are ordered collections of elements; tuples can contain elements of any\n  type, and a tuple can contain elements of different types. Curly braces can be\n  used to create tuples:\n\n      iex> {}\n      {}\n      iex> {1, :two, \"three\"}\n      {1, :two, \"three\"}\n\n  Tuples store elements contiguously in memory; this means that accessing a\n  tuple element by index (which can be done through the `Kernel.elem/2`\n  function) is a constant-time operation:\n\n      iex> tuple = {1, :two, \"three\"}\n      iex> elem(tuple, 0)\n      1\n      iex> elem(tuple, 2)\n      \"three\"\n\n  Same goes for getting the tuple size (via `Kernel.tuple_size/1`):\n\n      iex> tuple_size({})\n      0\n      iex> tuple_size({1, 2, 3})\n      3\n\n  Tuples being stored contiguously in memory also means that updating a tuple\n  (for example replacing an element with `Kernel.put_elem/3`) will make a copy\n  of the whole tuple.\n\n  Tuples are not meant to be used as a \"collection\" type (which is also\n  suggested by the absence of an implementation of the `Enumerable` protocol for\n  tuples): they're mostly meant to be used as a fixed-size container for\n  multiple elements. For example, tuples are often used to have functions return\n  \"enriched\" values: a common pattern is for functions to return `{:ok, value}`\n  for successful cases and `{:error, reason}` for unsuccessful cases. For\n  example, this is exactly what `File.read/1` does: it returns `{:ok, contents}`\n  if reading the given file is successful, or `{:error, reason}` otherwise\n  (e.g., `{:error, :enoent}` if the file doesn't exist).\n\n  This module provides functions to work with tuples; some more functions to\n  work with tuples can be found in `Kernel` (`Kernel.tuple_size/1`,\n  `Kernel.elem/2`, `Kernel.put_elem/3`, and others).\n  ",
    duplicate = {
      description = "duplicate(term, non_neg_integer) :: tuple\nduplicate(data, size)\n\n  Creates a new tuple.\n\n  Creates a tuple of `size` containing the\n  given `data` at every position.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> Tuple.duplicate(:hello, 3)\n      {:hello, :hello, :hello}\n\n  "
    },
    insert_at = {
      description = "insert_at(tuple, non_neg_integer, term) :: tuple\ninsert_at(tuple, index, value)\n\n  Inserts an element into a tuple.\n\n  Inserts `value` into `tuple` at the given `index`.\n  Raises an `ArgumentError` if `index` is negative or greater than the\n  length of `tuple`. Index is zero-based.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> tuple = {:bar, :baz}\n      iex> Tuple.insert_at(tuple, 0, :foo)\n      {:foo, :bar, :baz}\n      iex> Tuple.insert_at(tuple, 2, :bong)\n      {:bar, :baz, :bong}\n\n  "
    },
    to_list = {
      description = "to_list(tuple) :: list\nto_list(tuple)\n\n  Converts a tuple to a list.\n\n  Returns a new list with all the tuple elements.\n\n  Inlined by the compiler.\n\n  ## Examples\n\n      iex> tuple = {:foo, :bar, :baz}\n      iex> Tuple.to_list(tuple)\n      [:foo, :bar, :baz]\n\n  "
    }
  },
  Typespec = nil,
  URI = {
    HTTP = {
      default_port = {
        description = "default_port()\n"
      },
      parse = {
        description = "parse(info)\n"
      }
    },
    Parser = {},
    ["char_reserved?"] = {
      description = "char_reserved?(char) :: boolean\nchar_reserved?(char) when char in 0..0x10FFFF\n\n  Checks if the character is a \"reserved\" character in a URI.\n\n  Reserved characters are specified in\n  [RFC 3986, section 2.2](https://tools.ietf.org/html/rfc3986#section-2.2).\n\n  ## Examples\n\n      iex> URI.char_reserved?(?+)\n      true\n\n  "
    },
    ["char_unescaped?"] = {
      description = "char_unescaped?(char) :: boolean\nchar_unescaped?(char) when char in 0..0x10FFFF\n\n  Checks if the character is allowed unescaped in a URI.\n\n  This is the default used by `URI.encode/2` where both\n  reserved and unreserved characters are kept unescaped.\n\n  ## Examples\n\n      iex> URI.char_unescaped?(?{)\n      false\n\n  "
    },
    ["char_unreserved?"] = {
      description = "char_unreserved?(char) :: boolean\nchar_unreserved?(char) when char in 0..0x10FFFF\n\n  Checks if the character is a \"unreserved\" character in a URI.\n\n  Unreserved characters are specified in\n  [RFC 3986, section 2.3](https://tools.ietf.org/html/rfc3986#section-2.3).\n\n  ## Examples\n\n      iex> URI.char_unreserved?(?_)\n      true\n\n  "
    },
    decode = {
      description = "decode(binary) :: binary\ndecode(uri)\n\n  Percent-unescapes a URI.\n\n  ## Examples\n\n      iex> URI.decode(\"http%3A%2F%2Felixir-lang.org\")\n      \"http://elixir-lang.org\"\n\n  "
    },
    decode_query = {
      description = "decode_query(query, dict) when is_binary(query)\ndecode_query(query, map) when is_binary(query) and is_map(map)\ndecode_query(query, %{__struct__: _} = dict) when is_binary(query)\ndecode_query(binary, map) :: map\ndecode_query(query, map \\\\ %{})\n\n  Decodes a query string into a map.\n\n  Given a query string of the form of `key1=value1&key2=value2...`, this\n  function inserts each key-value pair in the query string as one entry in the\n  given `map`. Keys and values in the resulting map will be binaries. Keys and\n  values will be percent-unescaped.\n\n  Use `query_decoder/1` if you want to iterate over each value manually.\n\n  ## Examples\n\n      iex> URI.decode_query(\"foo=1&bar=2\")\n      %{\"bar\" => \"2\", \"foo\" => \"1\"}\n\n      iex> URI.decode_query(\"percent=oh+yes%21\", %{\"starting\" => \"map\"})\n      %{\"percent\" => \"oh yes!\", \"starting\" => \"map\"}\n\n  "
    },
    decode_www_form = {
      description = "decode_www_form(binary) :: binary\ndecode_www_form(string)\n\n  Decodes a string as \"x-www-form-urlencoded\".\n\n  ## Examples\n\n      iex> URI.decode_www_form(\"%3Call+in%2F\")\n      \"<all in/\"\n\n  "
    },
    default_port = {
      description = "default_port(binary, non_neg_integer) :: :ok\ndefault_port(scheme, port) when is_binary(scheme) and is_integer(port) and port >= 0\ndefault_port(binary) :: nil | non_neg_integer\ndefault_port(scheme) when is_binary(scheme)\n\n  Returns the default port for a given scheme.\n\n  If the scheme is unknown to the `URI` module, this function returns\n  `nil`. The default port for any scheme can be configured globally\n  via `default_port/2`.\n\n  ## Examples\n\n      iex> URI.default_port(\"ftp\")\n      21\n\n      iex> URI.default_port(\"ponzi\")\n      nil\n\n  "
    },
    description = "\n  Utilities for working with URIs.\n\n  This module provides functions for working with URIs (for example, parsing\n  URIs or encoding query strings). For reference, most of the functions in this\n  module refer to [RFC 3986](https://tools.ietf.org/html/rfc3986).\n  ",
    encode = {
      description = "encode(binary, (byte -> boolean)) :: binary\nencode(string, predicate \\\\ &char_unescaped?/1)\n\n  Percent-escapes the given string.\n\n  This function accepts a `predicate` function as an optional argument; if\n  passed, this function will be called with each character (byte) in `string` as\n  its argument and should return `true` if that character should not be escaped\n  and left as is.\n\n  ## Examples\n\n      iex> URI.encode(\"ftp://s-ite.tld/?value=put it+й\")\n      \"ftp://s-ite.tld/?value=put%20it+%D0%B9\"\n\n      iex> URI.encode(\"a string\", &(&1 != ?i))\n      \"a str%69ng\"\n\n  "
    },
    encode_query = {
      description = "encode_query(term) :: binary\nencode_query(enumerable)\n\n  Encodes an enumerable into a query string.\n\n  Takes an enumerable that enumerates as a list of two-element\n  tuples (e.g., a map or a keyword list) and returns a string\n  in the form of `key1=value1&key2=value2...` where keys and\n  values are URL encoded as per `encode_www_form/1`.\n\n  Keys and values can be any term that implements the `String.Chars`\n  protocol, except lists which are explicitly forbidden.\n\n  ## Examples\n\n      iex> hd = %{\"foo\" => 1, \"bar\" => 2}\n      iex> URI.encode_query(hd)\n      \"bar=2&foo=1\"\n\n      iex> query = %{\"key\" => \"value with spaces\"}\n      iex> URI.encode_query(query)\n      \"key=value+with+spaces\"\n\n      iex> URI.encode_query %{key: [:a, :list]}\n      ** (ArgumentError) encode_query/1 values cannot be lists, got: [:a, :list]\n\n  "
    },
    encode_www_form = {
      description = "encode_www_form(binary) :: binary\nencode_www_form(string) when is_binary(string)\n\n  Encodes a string as \"x-www-form-urlencoded\".\n\n  ## Example\n\n      iex> URI.encode_www_form(\"put: it+й\")\n      \"put%3A+it%2B%D0%B9\"\n\n  "
    },
    merge = {
      description = "merge(base, rel)\nmerge(%URI{} = base, %URI{} = rel)\nmerge(%URI{} = base, %URI{path: rel_path} = rel) when rel_path in [\"\", nil]\nmerge(_base, %URI{scheme: rel_scheme} = rel) when rel_scheme != nil\nmerge(%URI{authority: nil}, _rel)\nmerge(t | binary, t | binary) :: t\nmerge(uri, rel)\n\n  Merges two URIs.\n\n  This function merges two URIs as per\n  [RFC 3986, section 5.2](https://tools.ietf.org/html/rfc3986#section-5.2).\n\n  ## Examples\n\n      iex> URI.merge(URI.parse(\"http://google.com\"), \"/query\") |> to_string\n      \"http://google.com/query\"\n\n      iex> URI.merge(\"http://example.com\", \"http://google.com\") |> to_string\n      \"http://google.com\"\n\n  "
    },
    parse = {
      description = "parse(string) when is_binary(string)\nparse(%URI{} = uri)\nparse(t | binary) :: t\nparse(uri)\n\n  Parses a well-formed URI reference into its components.\n\n  Note this function expects a well-formed URI and does not perform\n  any validation. See the \"Examples\" section below for examples of how\n  `URI.parse/1` can be used to parse a wide range of URIs.\n\n  This function uses the parsing regular expression as defined\n  in [RFC 3986, Appendix B](https://tools.ietf.org/html/rfc3986#appendix-B).\n\n  When a URI is given without a port, the value returned by\n  `URI.default_port/1` for the URI's scheme is used for the `:port` field.\n\n  If a `%URI{}` struct is given to this function, this function returns it\n  unmodified.\n\n  ## Examples\n\n      iex> URI.parse(\"http://elixir-lang.org/\")\n      %URI{scheme: \"http\", path: \"/\", query: nil, fragment: nil,\n           authority: \"elixir-lang.org\", userinfo: nil,\n           host: \"elixir-lang.org\", port: 80}\n\n      iex> URI.parse(\"//elixir-lang.org/\")\n      %URI{authority: \"elixir-lang.org\", fragment: nil, host: \"elixir-lang.org\",\n           path: \"/\", port: nil, query: nil, scheme: nil, userinfo: nil}\n\n      iex> URI.parse(\"/foo/bar\")\n      %URI{authority: nil, fragment: nil, host: nil, path: \"/foo/bar\",\n           port: nil, query: nil, scheme: nil, userinfo: nil}\n\n      iex> URI.parse(\"foo/bar\")\n      %URI{authority: nil, fragment: nil, host: nil, path: \"foo/bar\",\n           port: nil, query: nil, scheme: nil, userinfo: nil}\n\n  "
    },
    path_to_segments = {
      description = "path_to_segments(path)\n\n  Merges two URIs.\n\n  This function merges two URIs as per\n  [RFC 3986, section 5.2](https://tools.ietf.org/html/rfc3986#section-5.2).\n\n  ## Examples\n\n      iex> URI.merge(URI.parse(\"http://google.com\"), \"/query\") |> to_string\n      \"http://google.com/query\"\n\n      iex> URI.merge(\"http://example.com\", \"http://google.com\") |> to_string\n      \"http://google.com\"\n\n  "
    },
    query_decoder = {
      description = "query_decoder(binary) :: Enumerable.t\nquery_decoder(query) when is_binary(query)\n\n  Returns a stream of two-element tuples representing key-value pairs in the\n  given `query`.\n\n  Key and value in each tuple will be binaries and will be percent-unescaped.\n\n  ## Examples\n\n      iex> URI.query_decoder(\"foo=1&bar=2\") |> Enum.to_list()\n      [{\"foo\", \"1\"}, {\"bar\", \"2\"}]\n\n  "
    },
    t = {
      description = "t :: %__MODULE__{\n"
    },
    to_string = {
      description = "to_string(%{scheme: scheme, port: port, path: path,\n\n  Merges two URIs.\n\n  This function merges two URIs as per\n  [RFC 3986, section 5.2](https://tools.ietf.org/html/rfc3986#section-5.2).\n\n  ## Examples\n\n      iex> URI.merge(URI.parse(\"http://google.com\"), \"/query\") |> to_string\n      \"http://google.com/query\"\n\n      iex> URI.merge(\"http://example.com\", \"http://google.com\") |> to_string\n      \"http://google.com\"\n\n  "
    }
  },
  UndefinedFunctionError = {
    message = {
      description = "message(%{reason: reason,  module: module, function: function, arity: arity})\nmessage(%{reason: :\"function not available\", module: module, function: function, arity: arity})\nmessage(%{reason: :\"function not exported\",  module: module, function: function, arity: arity, exports: exports})\nmessage(%{reason: :\"module could not be loaded\", module: module, function: function, arity: arity})\nmessage(%{reason: nil, module: module, function: function, arity: arity} = e)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    }
  },
  UnicodeConversionError = {
    exception = {
      description = "exception(opts)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
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
      description = "list_dir(dir)\n\n  Splits the path into a list at the path separator.\n\n  If an empty string is given, returns an empty list.\n\n  On Windows, path is split on both \"\\\" and \"/\" separators\n  and the driver letter, if there is one, is always returned\n  in lowercase.\n\n  ## Examples\n\n      iex> Path.split(\"\")\n      []\n\n      iex> Path.split(\"foo\")\n      [\"foo\"]\n\n      iex> Path.split(\"/foo/bar\")\n      [\"/\", \"foo\", \"bar\"]\n\n  "
    },
    read_link_info = {
      description = "read_link_info(file)\n\n  Splits the path into a list at the path separator.\n\n  If an empty string is given, returns an empty list.\n\n  On Windows, path is split on both \"\\\" and \"/\" separators\n  and the driver letter, if there is one, is always returned\n  in lowercase.\n\n  ## Examples\n\n      iex> Path.split(\"\")\n      []\n\n      iex> Path.split(\"foo\")\n      [\"foo\"]\n\n      iex> Path.split(\"/foo/bar\")\n      [\"/\", \"foo\", \"bar\"]\n\n  "
    },
    wildcard = {
      description = "wildcard(t, Keyword.t) :: [binary]\nwildcard(glob, opts \\\\ [])\n\n  Traverses paths according to the given `glob` expression and returns a\n  list of matches.\n\n  The wildcard looks like an ordinary path, except that certain\n  \"wildcard characters\" are interpreted in a special way. The\n  following characters are special:\n\n    * `?` - matches one character\n\n    * `*` - matches any number of characters up to the end of the filename, the\n      next dot, or the next slash\n\n    * `**` - two adjacent `*`'s used as a single pattern will match all\n      files and zero or more directories and subdirectories\n\n    * `[char1,char2,...]` - matches any of the characters listed; two\n      characters separated by a hyphen will match a range of characters.\n      Do not add spaces before and after the comma as it would then match\n      paths containing the space character itself.\n\n    * `{item1,item2,...}` - matches one of the alternatives\n      Do not add spaces before and after the comma as it would then match\n      paths containing the space character itself.\n\n  Other characters represent themselves. Only paths that have\n  exactly the same character in the same position will match. Note\n  that matching is case-sensitive: `\"a\"` will not match `\"A\"`.\n\n  By default, the patterns `*` and `?` do not match files starting\n  with a dot `.` unless `match_dot: true` is given in `opts`.\n\n  ## Examples\n\n  Imagine you have a directory called `projects` with three Elixir projects\n  inside of it: `elixir`, `ex_doc`, and `plug`. You can find all `.beam` files\n  inside the `ebin` directory of each project as follows:\n\n      Path.wildcard(\"projects/*/ebin/**/*.beam\")\n\n  If you want to search for both `.beam` and `.app` files, you could do:\n\n      Path.wildcard(\"projects/*/ebin/**/*.{beam,app}\")\n\n  "
    }
  },
  WithClauseError = {
    message = {
      description = "message(exception)\n\n  Formats the given `file` and `line` as shown in stacktraces.\n  If any of the values are `nil`, they are omitted.\n\n  ## Examples\n\n      iex> Exception.format_file_line(\"foo\", 1)\n      \"foo:1:\"\n\n      iex> Exception.format_file_line(\"foo\", nil)\n      \"foo:\"\n\n      iex> Exception.format_file_line(nil, nil)\n      \"\"\n\n  "
    }
  },
  __struct__ = nil,
  abs = nil,
  apply = nil,
  binary_part = nil,
  bit_size = nil,
  byte_size = nil,
  description = "\n  Provides the default macros and functions Elixir imports into your\n  environment.\n\n  These macros and functions can be skipped or cherry-picked via the\n  `import/2` macro. For instance, if you want to tell Elixir not to\n  import the `if/2` macro, you can do:\n\n      import Kernel, except: [if: 2]\n\n  Elixir also has special forms that are always imported and\n  cannot be skipped. These are described in `Kernel.SpecialForms`.\n\n  Some of the functions described in this module are inlined by\n  the Elixir compiler into their Erlang counterparts in the\n  [`:erlang` module](http://www.erlang.org/doc/man/erlang.html).\n  Those functions are called BIFs (built-in internal functions)\n  in Erlang-land and they exhibit interesting properties, as some of\n  them are allowed in guards and others are used for compiler\n  optimizations.\n\n  Most of the inlined functions can be seen in effect when capturing\n  the function:\n\n      iex> &Kernel.is_atom/1\n      &:erlang.is_atom/1\n\n  Those functions will be explicitly marked in their docs as\n  \"inlined by the compiler\".\n  ",
  div = nil,
  elem = nil,
  exception = nil,
  exit = nil,
  ["function_exported?"] = nil,
  get_and_update_in = nil,
  get_in = nil,
  hd = nil,
  inspect = nil,
  is_atom = nil,
  is_binary = nil,
  is_bitstring = nil,
  is_boolean = nil,
  is_float = nil,
  is_function = nil,
  is_integer = nil,
  is_list = nil,
  is_map = nil,
  is_number = nil,
  is_pid = nil,
  is_port = nil,
  is_reference = nil,
  is_tuple = nil,
  ["left =~ \"\" when is_binary"] = nil,
  ["left =~ right when is_binary"] = nil,
  ["left!==right"] = nil,
  ["left!=right"] = nil,
  ["left*right"] = nil,
  ["left++right"] = nil,
  ["left+right"] = nil,
  ["left--right"] = nil,
  ["left-right"] = nil,
  ["left/right"] = nil,
  ["left<=right"] = nil,
  ["left<right"] = nil,
  ["left===right"] = nil,
  ["left==right"] = nil,
  ["left>=right"] = nil,
  ["left>right"] = nil,
  length = nil,
  ["macro_exported?"] = nil,
  make_ref = nil,
  map_size = nil,
  max = nil,
  message = nil,
  min = nil,
  node = nil,
  ["not"] = nil,
  pop_in = nil,
  put_elem = nil,
  put_in = nil,
  rem = nil,
  round = nil,
  self = nil,
  send = nil,
  spawn = nil,
  spawn_link = nil,
  spawn_monitor = nil,
  struct = nil,
  ["struct!"] = nil,
  throw = nil,
  tl = nil,
  trunc = nil,
  tuple_size = nil,
  unquote = nil,
  update_in = nil
}
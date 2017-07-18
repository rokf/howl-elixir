-- inspection parser for dogma logs in flycheck format
-- lib/todo.ex:2:1: W: Module Todo is missing a @moduledoc.

local function parse(report,fname_filter,root_path)
  local format = "([%w%.%/]+):(%d+):%d+: (%a): ([^\n]+)"
  local out = {}
  for f,l,t,m in report:gmatch(format) do
    local msgtype = "error"
    if t == "W" then msgtype = "warning" end
    if (root_path .. '/' .. f) == string.format("%s",fname_filter) then
      table.insert(out, {
        filename = f,
        line = tonumber(l),
        type = msgtype,
        message = m
      })
    end
  end
  return out
end

return {
  parse = parse
}

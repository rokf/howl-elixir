-- inspection parser for credo in flycheck format
-- [R] → lib/todo.ex:2:11 Modules should have a @moduledoc tag.

local lpeg = require 'lpeg'
local P,R = lpeg.P, lpeg.R

local Ct,Cg = lpeg.Ct, lpeg.Cg

local logtype = P'[' * Cg((R'AZ' / function (c)
  if c == 'E' then return 'error' end
  return 'warning'
end), 'type') * P']'
local integer = R'19' * R'09'^0
local filename = Cg((P(1) - P':')^1,'filename')
local message =( P(1) - P'\n')^1
local line = logtype * P' ' * (P(1) - R('az','AZ'))^1 * filename * P':' *
  Cg(integer / tonumber,'line') * P':' * integer * P' ' * Cg(message,'message') * P'\n'^0
local pattern = Ct(Ct(line)^0)

local function parse(report, fname_filter, root_path)
  local matches = pattern:match(report)
  local filtered = {}
  for _,v in ipairs(matches) do
    if (root_path .. '/' .. v.filename) == string.format("%s",fname_filter) then
      table.insert(filtered, v)
    end
  end
  return filtered
end

return {
  parse = parse
}

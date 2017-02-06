
local lpeg = require 'lpeg'

local P,R,S,V =
  lpeg.P,
  lpeg.R,
  lpeg.S,
  lpeg.V

local C,Ct,Cg,Cp,Cg,Cc =
  lpeg.C,
  lpeg.Ct,
  lpeg.Cg,
  lpeg.Cp,
  lpeg.Cg,
  lpeg.Cc

-- import, alias
local scope_changers = P {
  "all",
  all = Ct(V'rec'),
  rec = (V'possibilities' + P(1))^0,
  possibilities = V'import' + V'alias',
  import = P'import' * V'ws' * Ct(Cg(Cc'import','tag') * (((Cg(V'name',"root_name") * P'.' * Cg(V'wrapped_names','wrapped')) + Cg(V'name','root_name')))),
  alias = P'alias' * V'ws' * Ct(Cg(Cc'alias','tag') * (((Cg(V'name',"root_name") * P'.' * Cg(V'wrapped_names','wrapped')) + Cg(V'name','root_name'))) * Cg(V'as','as')^-1),
  as = P',' * V'ws' * P'as:' * V'ws' * V'name',
  name = Ct(C(R'AZ' * R('AZ','az')^0) * (P'.' * C(R'AZ' * R('AZ','az')^0))^0),
  names = Ct(V'name' * V'ws' * (P',' * V'ws' * V'name')^0),
  wrapped_names = P'{' * V'ws' * V'names' * V'ws' * P'}',
  ws = S' \n\t\r'^0
}

local _M = {}

function _M.find_scope_changers(txt)
  local m = scope_changers:match(txt)
  return m
end

return _M

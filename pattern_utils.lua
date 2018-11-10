local lpeg = require 'lpeg'

local P,R,S,V =
  lpeg.P,
  lpeg.R,
  lpeg.S,
  lpeg.V

local C,Ct,Cg,Cc =
  lpeg.C,
  lpeg.Ct,
  lpeg.Cg,
  lpeg.Cc

local scope_changers = P {
  Ct(((V'import' + V'alias') + P(1))^0),
  import = P'import' * V'ws' * Ct(Cg(Cc'import','tag') *
    (((Cg(V'name',"root_name") * P'.' * Cg(V'wn','wrapped')) + Cg(V'name','root_name')))),
  alias = P'alias' * V'ws' * Ct(Cg(Cc'alias','tag') * (((Cg(V'name',"root_name") *
    P'.' * Cg(V'wn','wrapped')) + Cg(V'name','root_name'))) * Cg(V'as','as')^-1),
  as = P',' * V'ws' * P'as:' * V'ws' * V'name',
  name = Ct(C(R'AZ' * R('AZ','az')^0) * (P'.' * C(R'AZ' * R('AZ','az')^0))^0),
  names = Ct(V'name' * V'ws' * (P',' * V'ws' * V'name')^0),
  wn = P'{' * V'ws' * V'names' * V'ws' * P'}',
  ws = S' \n\t\r'^0
}

return {
  find_scope_changers = function (txt)
    return scope_changers:match(txt)
  end
}

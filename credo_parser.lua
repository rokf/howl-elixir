
local lpeg = require 'lpeg'
-- local serpent = require 'serpent'

local P,R,S,V =
  lpeg.P,
  lpeg.R,
  lpeg.S,
  lpeg.V

local C,Ct,Cg =
  lpeg.C,
  lpeg.Ct,
  lpeg.Cg

local CREDO = {}

-- arrows: ↑↗→↘↓

local grammar = P {
  Ct(V('rec')),
  rec = (V'options' + P(1))^0,
  options = V'log',
  -- location = Ct(V'ws' * V'filename' * V'linen' * V'charn' * V'ws' * P'(' * V'ident_path' * P')'),
  log = Ct(V'logtype' * V'ws' * S'↑↗→↘↓' * V'ws' * V'message' * V'ws' * P'┃' * V'ws' * V'location'),
  location = V'filename' * V'linen' * V'charn' * V'ws' * P'(' * V'ident_path' * P')',
  logtype = P'[' * Cg((C(R('AZ')) / function (c)
    if c == 'E' then return 'error' end
    return 'warning'
  end), 'type') * P']',
  message = Cg(C((P(1) - P('\n'))^1) / function (msg) print(msg); return msg; end, 'message'),
  filename = Cg(C((P(1) - P(':'))^1), 'filename') * P':',
  linen = Cg((C(R('19') * R('09')^0) / tonumber), 'line') * P':',
  charn = R('19') * R('09')^0,
  ident_path = Cg((Ct(C(V('ident')) * (P('.') * C(V('ident')))^0) / function (t)
    return t[#t]
  end), 'search'),
  ident = (R('AZ','az') + P'_') * (R('AZ','az','09') + P'_' )^0,
  ws = S(' \n\t\r')^0,
}

-- parse an elixir mix credo report
function CREDO.parse(report, fname_filter, root_path)
  local matches = grammar:match(report)
  local filtered = {}
  for _,v in ipairs(matches) do
    if (root_path .. '/' .. v.filename) == string.format("%s",fname_filter) then
      table.insert(filtered, v)
    end
  end
  return filtered
end

return CREDO

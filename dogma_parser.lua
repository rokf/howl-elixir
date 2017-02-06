
local lpeg = require 'lpeg'
-- local serpent = require 'serpent'

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

local DOGMA = {}

local last_filename = ""

local grammar = P {
  'all',
  all = Ct(V('rec')),
  rec = (V'options' + P(1))^0,
  options = V'header' + V'log',
  header = P'==' * V'ws' * (V'filename' / function (f)
    last_filename = f
  end) * V'ws' * P'==' * V'ws',
  log = Ct(V'linen' * V'message') / function (t)
    t.filename = last_filename
    t.type = 'warning' -- error?
    return t
  end,
  message = Cg(C((P(1) - P'\n')^1), 'message'),
  filename = C((P(1) - P(' '))^1),
  linen = Cg((C(R('19') * R('09')^0) / tonumber), 'line') * P': ',
  ws = S(' \n\t\r')^0,
}

-- parse an elixir mix dogma report
function DOGMA.parse(report, fname_filter, root_path)
  local matches = grammar:match(report)
  local filtered = {}
  for i,v in ipairs(matches) do
    if (root_path .. '/' .. v.filename) == string.format("%s",fname_filter) then
      table.insert(filtered, v)
    end
  end
  return filtered
end

return DOGMA

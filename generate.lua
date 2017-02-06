
local lpeg = require 'lpeg'
local serpent = require 'serpent'
local lfs = require 'lfs'
local gsources = require 'gsources'

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

local H = P {
  'all',
  all = Ct(V('rec')),
  rec = (V'opt' + P(1))^0,
  opt = V'moduledoc' + V'typedoc' + V'doc' + V'spec' + V'exported_type' + V'defmodule' + V'defprotocol' + V'def' + V'defp',
  defmodule = P'defmodule' * V'ws' * (C(V'module_name') / function (mn)
    return { mod = 1, modname = mn }
  end) * V'ws' * P('do'),
  defprotocol = P'defprotocol' * V'ws' * (C(V'module_name') / function (mn)
    return { mod = 1, modname = mn }
  end) * V'ws' * P'do',
  def = V'ws' * P'def' * V'ws' * V'fdef' /
  function (c)
    return { scope = "public", data = c }
  end,
  defp = V'ws' * P'defp' * V'ws' * V'fdef' /
  function (c)
    return { scope = "private", data = c }
  end,
  fdef = C((P(1) - P('\n'))^1) /
  function (d)
    local i1,i2 = string.find(d,"%s+do$")
    if i1 == nil then
      i1,i2 = string.find(d,",%s*do:")
    end
    if i1 ~= nil then
      local ss = string.sub(d,1,i1-1) -- has to be -1 else the , are still present
      local b1 = string.find(ss,"%(")
      if b1 ~= nil then
        -- found (
        return { name = string.sub(ss,1,b1-1), args = string.sub(ss,b1,#ss) }
      else
        -- didn't find (
        b1 = string.find(ss,',')
        if b1 ~= nil then
          -- found ,
          return { name = string.sub(ss,1,b1-1), args = "" }
        else
          -- no ,
          return { name = string.gsub(ss," ","") , args = "" }
        end
      end
    else
      local b1 = string.find(d,"%(")
      if b1 ~= nil then
        -- found (
        return { name = string.sub(d,1,b1-1), args = string.sub(d,b1,#d) }
      else
        -- didn't find (
        b1 = string.find(d,',')
        if b1 ~= nil then
          -- found ,
          return { name = string.sub(d,1,b1-1), args = "" }
        else
          -- no ,
          return { name = d, args = "" }
        end
      end
    end
  end,
  module_name = R('AZ') * R('az','AZ')^0 * (P('.') * R('AZ') * R('az','AZ')^0)^0,
  moduledoc = P'@moduledoc' * V'ws' * (V'doc_secondary'/ function (str) return { docs = 1, doctype = 'mod', txt = str } end),
  doc = P'@doc' * V'ws' * (V'doc_secondary' / function (str) return { docs = 1, doctype = 'doc', txt = str } end),
  typedoc = P'@typedoc' * V'ws' * (V'doc_secondary' / function (str) return { docs = 1, doctype = 'type', txt = str } end),
  exported_type = P'@type' * V'ws' * Ct(Cg(C((R('az') + S('_'))^1), 'type_name') * V'ws' * P'::' * V'ws' * Cg(C((P(1) - P('\n'))^1),'type_def')),
  doc_secondary = (V'multiline_string' + C(P"false") + (P'~S' * V'multiline_string')),
  multiline_string = P('"""') * C((P(1) - P('"""'))^0) * P('"""'),
  spec = P'@spec' * V'ws' * Ct(Cg(C(V'fident'),'spec_fname') * Cg(C((P(1) - P('\n'))^1), 'spec_other')),
  fident = (R('az') + P('_')) * (R('az','AZ','09') + P('_'))^0 * (S('!?'))^-1,
  ows = S(' \n\t\r')^0,
  ws = S(' \n\t\r')^1
}

local whole_api = {}

function run_over_matches(mc)
  local current_doc = ""
  local current_mod = whole_api
  local current_typedoc = ""
  local current_spec = {}
  for i,v in ipairs(mc) do
    if v.mod ~= nil then -- new module
      current_mod = whole_api -- reset to root
      for m in string.gmatch(v.modname, "%a+") do
        print('MOD:',m)
        if current_mod[m] == nil then
          current_mod[m] = {}
        end
        current_mod = current_mod[m]
      end
    end
    if v.docs ~= nil then -- one of the docs
        if current_mod.description == nil and v.doctype == "mod" then
          current_mod.description = v.txt
        elseif v.doctype == "doc" then
          current_doc = v.txt
        elseif v.doctype == "type" then
          current_typedoc = v.txt
        end
    end
    if v.scope == "public" then -- public function
        if current_mod[v.data.name] == nil then
          current_mod[v.data.name] = {}
          if current_spec.spec_fname == v.data.name then
            current_mod[v.data.name].description = current_spec.spec_fname .. current_spec.spec_other .. '\n' .. v.data.name .. v.data.args .. "\n" .. current_doc
            current_spec = {}
          else
            current_mod[v.data.name].description = v.data.name .. v.data.args .. "\n" .. current_doc
          end
        else
          if current_spec.spec_fname == v.data.name then
            current_mod[v.data.name].description = current_spec.spec_fname .. current_spec.spec_other .. '\n' .. v.data.name .. v.data.args .. "\n" .. current_mod[v.data.name].description
            current_spec = {}
          else
            current_mod[v.data.name].description = v.data.name .. v.data.args .. "\n" .. current_mod[v.data.name].description
          end
        end
    end
    if v.type_name then -- it is a type
      current_mod[v.type_name] = {}
      current_mod[v.type_name].description = v.type_name .. ' :: ' .. v.type_def .. "\n" .. current_typedoc
    end
    if v.spec_fname then -- it is a spec
      current_spec = v
    end
  end
end

function attrdir (path)
  for file in lfs.dir(path) do
    if file ~= "." and file ~= ".." then
      local f = path..'/'..file
      print ("\t "..f)
      local attr = lfs.attributes (f)
      assert (type(attr) == "table")
      if attr.mode == "directory" then
        attrdir (f)
      else
        local file = io.open(f)
        txt = file:read('*all')
        file:close()
        local m = H:match(txt)
        run_over_matches(m)
      end
    end
  end
end

-- go over source directories listed in [gsources.lua]
for _,s in ipairs(gsources) do
  attrdir(s) -- append data to global [whole_api]
end

-- copy Kernel module items to root table
for k,v in pairs(whole_api['Kernel']) do
  whole_api[k] = v
end

local file = io.open('api.lua', "w")
file:write("return " .. serpent.block(whole_api,{comment = false}))
file:close()

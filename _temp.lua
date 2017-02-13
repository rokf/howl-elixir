  -- old_fdef = C((P(1) - P('\n'))^1) / capture_fdef, -- OLD
  -- prefix = P'(' * V'prefix_operator' * R'az' * P')',
  -- prefix_operator = S'+-',
  -- left_right = P'left' * V'ows' * (P(1) - P'right')^1 * P'right',
  -- first_last = P'first' * V'ows' * (P(1) - P'last')^1 * P'last',
  -- spec = P'@spec' * V'ws' * Ct(Cg(C(V'fident'),'spec_fname') * Cg(C((P(1) - P('\n'))^1), 'spec_other')),

-- function run_over_matches(mc)
--   local current_doc = ""
--   local current_mod = whole_api
--   local current_typedoc = ""
--   local current_spec = {}
--   for i,v in ipairs(mc) do
--     if v.mod ~= nil then -- new module
--       current_mod = whole_api -- reset to root
--       for m in string.gmatch(v.modname, "%a+") do
--         print('MOD:',m)
--         if current_mod[m] == nil then
--           current_mod[m] = {}
--         end
--         current_mod = current_mod[m]
--       end
--     end
--     if v.docs ~= nil then -- one of the docs
--       if current_mod.description == nil and v.doctype == "mod" then
--         current_mod.description = v.txt
--       elseif v.doctype == "doc" then
--         current_doc = v.txt
--       elseif v.doctype == "type" then
--         current_typedoc = v.txt
--       end
--     end
--     if v.scope == "public" then
--       if current_mod[v.data.name] == nil then
--         current_mod[v.data.name] = {}
--         if current_spec.spec_fname == v.data.name then
--           current_mod[v.data.name].description = current_spec.spec_fname .. current_spec.spec_other .. '\n' .. v.data.name .. v.data.args .. "\n" .. current_doc
--           current_spec = {}
--         else
--           current_mod[v.data.name].description = v.data.name .. v.data.args .. "\n" .. current_doc
--         end
--       else
--         if current_spec.spec_fname == v.data.name then
--           current_mod[v.data.name].description = current_spec.spec_fname .. current_spec.spec_other .. '\n' .. v.data.name .. v.data.args .. "\n" .. current_mod[v.data.name].description
--           current_spec = {}
--         else
--           current_mod[v.data.name].description = v.data.name .. v.data.args .. "\n" .. current_mod[v.data.name].description
--         end
--       end
--     end
--     if v.type_name then -- it is a type
--       current_mod[v.type_name] = {}
--       current_mod[v.type_name].description = v.type_name .. ' :: ' .. v.type_def .. "\n" .. current_typedoc
--     end
--     if v.spec_fname then -- it is a spec
--       current_spec = v
--     end
--   end
-- end

function capture_fdef(d)
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
end

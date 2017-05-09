
lpeg = require 'lpeg'
serpent = require 'serpent'
lfs = require 'lfs'
gsources = require 'gsources'

import P,R,S,V,C,Ct,Cg,Cp,Cc from lpeg

mnpat = (start,stop) ->
  start * ((V'bp' + P(1)) - stop)^0 * stop

H = P {
  'root'
  root: Ct((V'opt' + P(1))^0)
  opt: V'moduledoc' + V'typedoc' + V'doc' + V'exported_type' + V'defmodule' + V'defprotocol' + V'defmacro' + V'defdelegate' + V'def' + V'defp'
  defmodule: V'indentation' * P'defmodule' * V'ws' * (C(V'module_name') / (mn) -> {mod:1,modname:mn}) * V'ws' * P'do'
  defprotocol: V'indentation' * P'defprotocol' * V'ws' * (C(V'module_name') / (mn) -> {mod:1, modname:mn}) * V'ws' * P'do'
  def: V'indentation' * P'def' * V'ws' * (V'fdef' / (c) -> {scope:'public',data:c})
  defp: V'ws' * P'defp' * V'ws' * (V'fdef' / (c) -> {scope:'private',data:c})
  defmacro: V'indentation' * P'defmacro' * V'ws' * (V'hungry_fdef' / (c) -> {scope:'public',data:c})
  defdelegate: V'indentation' * P'defdelegate' * V'ws' * (Ct(V'left_part') / (c) -> {scope:'public',data:c}) * P','
  indentation: C(P(' ')^0 + P('\t')^0) / (ind) -> {indent: #ind}

  fdef: Ct(V'left_part' * V'optional_guard' * V'right_part')
  hungry_fdef: Ct(V'left_part' * V'optional_guard' * V'hungry_right_part')
  left_part: V'name_with_brackets' + V'name_no_brackets'
  name_with_brackets: C(V'fident') * C(P'(' * (P(1) - P')')^1 * P')')
  name_no_brackets: C(V'fident')
  optional_guard: C(V'ws' * P'when' * (P(1) - P'do')^1)^-1
  right_part: P' '^0  * (P'do' + (P',' * V'ows' * P'do:') + P'\n')

  bp: V'fnblock' + V'doblock'
  fnblock: mnpat((P'fn' * S' ('), ('end' * S'\n),'))
  doblock: mnpat(P'do\n', ('end' * S'\n),'))
  hungry_right_part: P' '^0  * (V'doblock' + (P',' * V'ows' * P'do:') + P'\n')

  specs: Ct(Cg(Cc('spec'), 'tag') * Cg(C(P'@spec' * (P(1) - P('def'))^1), 'spec_content'))
  module_name: R('AZ') * R('az','AZ')^0 * (P('.') * R('AZ') * R('az','AZ')^0)^0
  moduledoc: P'@moduledoc' * V'ws' * (V'doc_secondary'/ (str) -> {docs:1,doctype:'mod',txt:str})
  doc: P'@doc' * V'ws' * (V'doc_secondary' / (str) -> {docs:1,doctype:'doc',txt:str})
  typedoc: P'@typedoc' * V'ws' * (V'doc_secondary' / (str) -> {docs:1,doctype:'type',txt:str})
  exported_type: P'@type' * V'ws' * Ct(Cg(C((R('az') + S('_'))^1), 'type_name') * V'ws' * P'::' * V'ws' * Cg(C((P(1) - P('\n'))^1),'type_def'))
  doc_secondary: (V'multiline_string' + C(P"false") + (P'~S' * V'multiline_string'))
  multiline_string: P('"""') * C((P(1) - P('"""'))^0) * P('"""')
  fident: (R('az') + P('_')) * (R('az','AZ','09') + P('_'))^0 * (S('!?'))^-1
  ows: S(' \n\t\r')^0
  ws: S(' \n\t\r')^1
}

API = {}

run_over_matches = (mc) ->
  cd,ctd,cs = '','','' -- docs, typedocs, spec
  cm,lmod = API,API -- current and last module
  ci,cmi = 0,0
  for v in *mc
    if v.indent
      ci = v.indent
      if ci <= cmi then cm = lmod
    if v.mod
      lmod = cm
      cmi = ci
      for m in string.gmatch v.modname, '%a+'
        if not cm[m] then cm[m] = {}
        cm = cm[m]
    if v.docs
      if (not cm.description) and v.doctype == 'mod'
        cm.description = v.txt
      elseif v.doctype == 'doc' then cd = v.txt
      elseif v.doctype == 'type' then ctd = v.txt
    if v.scope == 'public'
      fn = v.data[1]
      if not cm[fn]
        cm[fn] = {}
        cm[fn].description = cs .. '\n' .. table.concat(v.data) .. "\n" .. cd
        cs,cd = "",""
      else
        cm[fn].description = cs .. '\n' .. table.concat(v.data) .. cd ..  "\n" .. cm[fn].description
        cs,cd = "",""
    if v.type_name
      cm[v.type_name] = {}
      cm[v.type_name].description = v.type_name .. ' :: ' .. v.type_def .. "\n" .. ctd
    if v.tag == 'spec'
      cs = v.spec_content

attrdir = (path) ->
  for file in lfs.dir path
    if file != "." and file != ".."
      f = path .. '/' .. file
      attr = lfs.attributes f
      if attr.mode == 'directory'
        attrdir f
      else
        file = io.open f
        txt = file\read '*all'
        file\close!
        m = H\match txt
        run_over_matches m

for s in *gsources
  attrdir s

for k,v in pairs API['Kernel']
  if string.lower(k) == k then API[k] = {
    description: v.description
  }

file = io.open 'elixir_api.lua', 'w'
file\write("return " .. serpent.block(API, {comment: false}))
file\close!

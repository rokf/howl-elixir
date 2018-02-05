
lpeg = require 'lpeg'
serpent = require 'serpent'
lfs = require 'lfs'
gsources = require 'gsources'

import P,R,S,V,C,Ct from lpeg

mnpat = (start,stop) -> start * ((V'bp' + P(1)) - stop)^0 * stop
docret = (t) -> (V'doc_secondary' / (str) -> {doctype:t,txt:str})
pubret = (c) -> {scope:'public',data:c}
privret = (c) -> {scope:'private',data:c}
modret = (mn) -> {modname:mn}

H = P {
  Ct((V'opt' + P(1))^0)
  opt: V'docalt' + V'defalt'
  defalt: V'defmod' + V'defmacro' + V'defdelegate' + V'def' + V'defp'
  docalt: V'moduledoc' + V'doc'
  modkw: (P'defmodule' + P'defprotocol')
  defmod: V'idt' * V'modkw' * V'ws' * (C(V'mname') / modret) * V'ws' * P'do'
  def: V'idt' * P'def' * V'ws' * (V'fdef' / pubret)
  defp: V'ws' * P'defp' * V'ws' * (V'fdef' / privret)
  defmacro: V'idt' * P'defmacro' * V'ws' * (V'hungry_fdef' / pubret)
  defdelegate: V'idt' * P'defdelegate' * V'ws' * (Ct(V'left_part') / pubret) * P','
  idt: C(P(' ')^0 + P('\t')^0) / (ind) -> {indent: #ind}

  fdef: Ct(V'left_part' * V'optional_guard' * V'right_part')
  hungry_fdef: Ct(V'left_part' * V'optional_guard' * V'hungry_right_part')
  left_part: V'name_with_braces' + V'name_no_braces'
  name_with_braces: C(V'fident') * C(P'(' * (P(1) - P')')^1 * P')')
  name_no_braces: C(V'fident')
  optional_guard: C(V'ws' * P'when' * (P(1) - P'do')^1)^-1
  right_part: P' '^0  * (P'do' + (P',' * V'ows' * P'do:') + P'\n')
  hungry_right_part: P' '^0  * (V'doblock' + (P',' * V'ows' * P'do:') + P'\n')

  bp: V'fnblock' + V'doblock'
  fnblock: mnpat((P'fn' * S' (\n'), ('end' * S'\n)}, '))
  doblock: mnpat(P'do\n', ('end' * S'\n),'))

  mname: R('AZ') * R('az','AZ')^0 * (P('.') * R('AZ') * R('az','AZ')^0)^0
  moduledoc: P'@moduledoc' * V'ws' * docret('mod')
  doc: P'@doc' * V'ws' * docret('doc')
  doc_secondary: (V'multiline_string' + C(P"false") + (P'~S' * V'multiline_string'))
  multiline_string: P('"""') * C((P(1) - P('"""'))^0) * P('"""')
  fident: (R('az') + P('_')) * (R('az','AZ','09') + P('_'))^0 * (S('!?'))^-1
  ows: S(' \n\t\r')^0
  ws: S(' \n\t\r')^1
}

API = {}

run_over_matches = (mc) ->
  cm,lmod = API,API
  ci,cmi,cd = 0,0,''
  for v in *mc
    if v.indent
      ci = v.indent
      if ci <= cmi then cm = lmod
    if v.modname
      lmod,cmi = cm,ci
      for m in string.gmatch v.modname, '%a+'
        if not cm[m] then cm[m] = {}
        cm = cm[m]
    if v.doctype
      if (not cm.description) and v.doctype == 'mod'
        cm.description = v.txt
      elseif v.doctype == 'doc'
        cd = v.txt
    if v.scope == 'public'
      fn = v.data[1]
      if not cm[fn]
        cm[fn] = {}
        cm[fn].description = '\n' ..
          table.concat(v.data) .. "\n" .. cd
      else
        cm[fn].description = '\n' ..
          table.concat(v.data) .. cd ..
          "\n" .. cm[fn].description
      cd = ''

checkdir = (path) ->
  for file in lfs.dir path
    if file != "." and file != ".."
      f = path .. '/' .. file
      attr = lfs.attributes f
      if attr.mode == 'directory'
        checkdir f
      else
        if string.match f, "%.ex"
          with io.open f
            txt = \read '*all'
            \close!
            m = H\match txt
            run_over_matches m

for s in *gsources
  checkdir s

for k,v in pairs API['Kernel']
  if string.lower(k) == k then API[k] = {
    description: v.description
  }

with io.open 'api.lua', 'w'
  \write("return " .. serpent.block(API, {comment: false}))
  \close!

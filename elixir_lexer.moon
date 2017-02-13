-- Copyright 2014-2015 The Howl Developers
-- License: MIT (see LICENSE.md)

howl.util.lpeg_lexer ->
  c = capture

  kw = c 'keyword', word {
    'cond','case', 'defmodule', 'defstruct', 'defmacro', 'defprotocol', 'defexception', 'defdelegate'
    'defimpl', 'try','catch', 'do', 'end', 'after', 'if', 'else', 'unless',
    'fn','defp','def', 'and', 'or', 'rescue',
    'receive', 'alias', 'use', 'require', 'import', 'for', 'when'
  }

  comment = c('comment', '#' * scan_until(eol))

  sq_string = span("'", "'", '\\')
  dq_string = span('"', '"', '\\')
  string = c 'string', any {
    '"""' * (P(1) - P('"""'))^0 * '"""',
    sq_string,
    dq_string,
  }

  operator = c 'operator', S('+-*!/%^#~=<>;,.&(){}[]|?')

  hexadecimal_number =  P'0' * S'xX' * xdigit^1 * (P'.' * xdigit^1)^0 * (S'pP' * S'-+'^0 * xdigit^1)^0
  float = digit^1 * P'.' * digit^1
  number = c 'number', any({
    hexadecimal_number * any('LL', 'll', 'ULL', 'ull')^-1,
    digit^1 * any { 'LL', 'll', 'ULL', 'ull' },
    (float + digit^1) * (S'eE' * P('-')^0 * digit^1)^0
  })

  ident = (alpha + '_')^1 * (alpha + digit + '_')^0 * S('!?')^-1
  identifier = c 'identifier', ident
  module = c 'class', upper^1 * any(alpha, '_', digit)^0

  sp = { -- sigil pairs
    '/': '/',
    '|': '|',
    '"': '"',
    '\'': '\'',
    '(': ')',
    '[': ']',
    '{': '}',
    '<': '>'
  }

  special = c 'special', any {
    'true',
    'false',
    'nil',
    ident * P(':'),
    P(':') * ident,
    P('@') * ident,
    P('~') * alpha * any {
      span('/','/','\\'),
      span('|','|','\\'),
      span('"','"','\\'),
      span('\'','\'','\\'),
      span('(',')','\\'),
      span('[',']','\\'),
      span('{','}','\\'),
      span('<','>','\\'),
    } * lower^-1
  }

  ws = c 'whitespace', blank^0

  -- fdecl = any {
  --   sequence {
  --     c('keyword', 'function'),
  --     c 'whitespace', blank^1,
  --     c('fdecl', ident * (S':.' * ident)^-1)
  --   },
  --   sequence {
  --     c('fdecl', ident),
  --     ws,
  --     c('operator', '='),
  --     ws,
  --     c('keyword', 'function'),
  --     -#any(digit, alpha)
  --   }
  -- }

  -- cdef = sequence {
  --   any {

  --     sequence {
  --       c('identifier', 'ffi'),
  --       c('operator', '.'),
  --     },
  --     line_start
  --   },
  --   c('identifier', 'cdef'),
  --   c('operator', '(')^-1,
  --   ws,
  --   any {
  --     sequence {
  --       c('string', bracket_quote_lvl_start),
  --       sub_lex('c', bracket_quote_lvl_end),
  --       c('string', bracket_quote_lvl_end)^-1,
  --     },
  --     sequence {
  --       c('string', '"'),
  --       sub_lex('c', '"'),
  --       c('string', '"')^-1,
  --     },
  --     sequence {
  --       c('string', "'"),
  --       sub_lex('c', "'"),
  --       c('string', "'")^-1,
  --     }
  --   }
  -- }

  any {
    number,
    string,
    comment,
    special,
    kw,
    module,
    identifier,
    operator
  }

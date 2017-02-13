
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

unit grammar Log::Reader::ELF;

token TOP(@*FIELDS=[], @*ROWS=[], %*DIRECTIVES={}, @*DATA=[]) {
  ^ <line>* $
}
token line {
  (
  ||<directive>
  ||<data>
  ||<error-row>
  )
  <+[\s]-[\r\n]>*
  <[\r]>?
  (<[\n]> | $)
}
token directive {
  '#'
  (
  ||<version>
  ||<fields>
  ||<software>
  ||<x-date>
  ||<remark>
  ||<other-directive>
  )
}

regex error-row {# this is as directed by spec.
  .*? <before "\n">
}

token remark {
  'Remark:'
  $<remark> = <:!Cc>* 
}

token other-directive {
  $<key> = <:!Cc -[:]>*
  ( ':'
    \s*
    $<value> = <:!Cc -[\r\n]>*
  )?
}

token x-date {
  $<dirstr> = ('Start-Date:' | 'End-Date:' | 'Date:')
  \s*
  <date>\s*<time>?
  <+[\s]-[\r\n]>*
}

token version {
  'Version:' \s*
  $<ver>=(\d+ '.' \d+)
  <+[\s]-[\r\n]>*
}
token software {
  'Software:' \s* $<name> = <:!Cc -[\r\n]>*
}
token fields {
  'Fields:' \s*
  <field-list>
}
token field-list {
  <field>* % <+[\s]-[\r\n]>*
}
token field {
  <+[a..zA..Z0..9\-_()]>+
}
token data {
  <dat>+ % <+[\s]-[\r\n]>*
}
token dat {
  ||<date>
  ||<time>
  ||<address>
  ||<number>
  ||<string>
}
token date {
  $<year> = \d ** 4
  '-'
  $<month> = \d ** 2
  '-'
  $<day> = \d ** 2
}
token time {
  $<hour> = \d ** 2
  ':'
  $<min> = \d ** 2
  [':' $<sec> = \d ** 2
    ( '.' $<ms> = \d+ )?
  ]?
}
token number {
  (\d+ ('.' \d+)?)
  <before \s>
}
token string {
  (
  ||'"' ~ '"' .*?
  ||<:!Cc -[\s]>+
  )
}
token address {
  (
  |<ipv4>
  |<ipv6>
  )
  (':' \d+)?
  <?before \s>
}
token ipv4 {
  ((\d+ '.') ** 3)
  \d+
}
token ipv6 {
  Nil
}

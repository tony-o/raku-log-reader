# log reader

this is a log reader with a basic interface.

## current features

supports a grammar/action parse, currently implemented with the extended log format (you can read about it from w3c).

## usage

```raku
use Log::Reader;

my %data = parse-log('your-log'.IO.slurp);

# do something with %data<directives> and %data<rows> here

# note: parse-log is a shortcut for Log::Reader.new(parser=>ELF, actions=>ELF::Actions).parse
```

easy peasy.

have your own grammar/actions?

```raku
use Log::Reader;
use Custom::Grammar;
use Custom::Actions;

my $parser = Log::Reader.new(:parser(Custom::Grammar), :actions(Custom::Actions));

$parser.parse('some-file'.IO.slurp);
```

## todo

* support streams for i/o

## authors

tony-o

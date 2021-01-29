# log reader

this is a log reader with a basic interface.

## current features

supports a grammar/action parse, currently implemented with the extended log format (you can read about it from w3c).

## usage

```raku
use Log::Reader;

my %data = parse-log('your-log'.IO.slurp);

# do something with %data<directives> and %data<rows> here
```

easy peasy.

## todo

* support streams for io

## authors

tony-o

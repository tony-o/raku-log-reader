use Test;
use Log::Reader;

sub from-j($t) { ::("Rakudo::Internals::JSON").from-json($t); }

my @jsons = 't/json'.IO
                    .dir
                    .grep(*.f && *.extension eq 'json')
                    .sort
                    .map({ %(FILE => $_, |from-j($_.slurp)) });

plan 8540;

for @jsons -> $j {
  for 0 ..^ $j<expected> -> $idx {
    for $j<expected>[$idx].keys -> $k {
      my $e = $j<expected>[$idx]{$k};
      if $e ~~ Array {
        if $e[0] > 23 {
          $j<expected>[$idx]{$k} = DateTime.new(year => $e[0], month => $e[1], day => $e[2]);
        } else {
          $j<expected>[$idx]{$k} = DateTime.new(year => 1900, hour => $e[0], minute => $e[1], second => ($e[2]//0))
        }
      }
    }
  }
  
  my $result = parse-log($j<input>);
  is +$result<ROWS>, +$j<expected>, $j<FILE>.basename ~ ' rows match';
  for 0..^$result<ROWS> -> $idx {
    my ($e, $g) = ($j<expected>[$idx], $result<ROWS>[$idx]);
    ok(+($e.keys.sort (-) $g.keys.sort).Slip == 0, $j<FILE>.basename ~ '[' ~ $idx ~ '] keys');
    for $e.keys -> $k {
      if $e{$k} ~~ DateTime {
        ok $e{$k}.yyyy-mm-dd eq $e{$k}.yyyy-mm-dd, '  checking: ' ~ $k;
        next;
      } elsif Any ~~ $e{$k} {
        ok Any ~~ $g{$k}, '  checking: ' ~ $k;
        next;
      }
      ok $e{$k} eq $g{$k}, '  checking: ' ~ $k;
    }
  }
}

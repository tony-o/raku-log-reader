class Log::Reader::ELF::Actions {
  method TOP($/) {
    make {:%*DIRECTIVES,:@*ROWS};
  }
  method version($/) { %*DIRECTIVES<Version> = $<ver>.Str; }
  method software($/) { %*DIRECTIVES<Software> = $<name>.Str; }
  method remark($/) { %*DIRECTIVES<Remark> = $<remark>.Str; }
  method other-directive($/) { %*DIRECTIVES{$<key>.Str} = $<value>.Str//Nil; }
  method field-list($/) { @*FIELDS = $<field>>>.made; }
  method field($/) { make $/.Str; }
  method data($/) {
    @*ROWS.push({});
    @*ROWS[*-1]{@*FIELDS} = @*DATA;
    @*DATA = ();
  }
  method dat($/) {
    push @*DATA, $<date time address number string>.grep(*.made.so).first.made;
  }
  method x-date($/) {
    %*DIRECTIVES{$<dirstr>.Str} = DateTime.new(
      year   => $<date>.made.year,
      month  => $<date>.made.month,
      day    => $<date>.made.day,
      hour   => $<time>.made.hour,
      minute => $<time>.made.minute,
      second => $<time>.made.second,
    );
  }
  method date($/) {
    make DateTime.new(year => $<year>, month => $<month>, day => $<day>);
  }
  method time($/) {
    make DateTime.new(year => 1900, hour => $<hour>, minute => $<min>, second => ($<sec>//0));
  }
  method address($/) { make $/.Str; }
  method number($/) {
    make $/.Int || $/.Rat;
  }
  method string($/) { make $/.Str eq '-' ?? Nil !! $/.Str; }
}

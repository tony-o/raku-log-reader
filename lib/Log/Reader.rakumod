unit class Log::Reader;
use Log::Reader::ELF;
use Log::Reader::ELF::Actions;

has $!parser;
has $!actions;

submethod BUILD($!parser = Log::Reader::ELF, $!actions = Log::Reader::ELF::Actions) { }

method parse-log(Str() $data) is export {
  $!parser.parse($data, actions => $!actions).made;
}

unit class Kitten is Stringy;
use nqp;

has Iterator $!iter;
has Str      $!window = '';

method !SET-SELF ($!iter) { self }
method new (*@stuff) { self.bless!SET-SELF: @stuff.iterator; }

method words(::?CLASS:D: |c) { self!ITEM-SEQ: 'words', |c }

method !ITEM-SEQ (\meth, |args) {
    Seq.new: class :: does Iterator {
        has Cat     $!cat;
        has Str     $!meth;
        has Capture $!args;
        method !SET-SELF ($!cat, $!meth, $!args) { self }
        method new (\cat, \meth, \args) {
            nqp::create(self)!SET-SELF: cat, meth, args
        }

        method pull-one {
            nqp::while(
              nqp::eqaddr((my $chunk := nqp::getattr(
                  nqp::decont($!cat), Cat, '$!window'
                )."$!meth"(|$!args).iterator.pull-one),
                IterationEnd)
              && nqp::isfalse(
                nqp::eqaddr(($_ := nqp::getattr(
                  nqp::decont($!cat), Cat, '$!iter').pull-one),
                  IterationEnd)),
              nqp::bindattr(nqp::decont($!cat), Cat, '$!window',
                nqp::concat(
                  nqp::getattr(nqp::decont($!cat), Cat, '$!window'), $_)));
            nqp::if(
              nqp::eqaddr($chunk, IterationEnd),
              IterationEnd,
              nqp::stmts(
                nqp::bindattr(nqp::decont($!cat), Cat, '$!window',
                  nqp::substr(
                    nqp::getattr(nqp::decont($!cat), Cat, '$!window'),
                      nqp::chars($chunk))),
                $chunk))
        }
    }.new: self, meth, args
}

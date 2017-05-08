unit class Kitten is Stringy;
use nqp;

has Iterator $.iter   is rw;
has Str:D    $.window is rw = '' ;

method !SET-SELF (\iter) {
    unless ($_ := iter.pull-one) =:= IterationEnd {
        $!iter = iter;
        $!window = $_;
    }
    self
}
method new (*@stuff) { self.bless!SET-SELF: @stuff.iterator; }

method words(::?CLASS:D: |c) { self!ITEM-SEQ: 'words', |c }
method !ITEM-SEQ (\meth, |args) {
    Seq.new: class :: does Iterator {
        has Kitten  $!cat;
        has Str     $!meth;
        has Capture $!args;
        method !SET-SELF ($!cat, $!meth, $!args) { self }
        method new (\cat, \meth, \args) {
            self.bless!SET-SELF: cat, meth, args
        }

        method pull-one {
            return IterationEnd without $!cat.iter;

            my $peek := IterationEnd;
            my $witer = $!cat.window."$!meth"(|$!args).iterator;
            while ((my $chunk := $witer.pull-one) =:= IterationEnd
                or (   $peek  := $witer.pull-one) =:= IterationEnd
                or $peek eq $chunk
              ) and not ($_ := $!cat.iter.pull-one) =:= IterationEnd {
                $!cat.window ~= $_;
                $witer = $!cat.window."$!meth"(|$!args).iterator;
            }
            dd ['before', $!cat.window];
            $!cat.window .= substr: $chunk.chars unless $chunk =:= IterationEnd;
            # $!cat.window ~= $peek unless $peek =:= IterationEnd;
            dd ['after', $!cat.window];
            $chunk
        }
    }.new: self, meth, args;
}

# method !SET-SELF (\iter) {
#     nqp::unless(
#       nqp::eqaddr(($_ := iter.pull-one), IterationEnd),
#       nqp::stmts(
#         ($!iter   = iter),
#         ($!window = $_  )));
#     self
# }

# method !ITEM-SEQ (\meth, |args) {
#     Seq.new: class :: does Iterator {
#         has Kitten   $!cat;
#         has          $!window-iter;
#         has Capture  $!args;
#         has Str      $!meth;
#         has          $!peek;
#         method !SET-SELF (\cat, $!meth, $!args) {
#             nqp::stmts(
#               ($!cat := nqp::decont(cat)),
#               nqp::if(
#                 nqp::chars(nqp::getattr(cat, Kitten, '$!window')),
#                 self,
#                 nqp::if(
#                   nqp::isconcrete(
#                     my $iter := nqp::getattr(cat, Kitten, '$!iter')),
#                   nqp::stmts(
#                     (my $win := $iter.pull-one),
#                     nqp::if(
#                       nqp::eqaddr($win, IterationEnd),
#                       nqp::stmts(
#                         nqp::bindattr(cat, Kitten, '$!iter', Nil),
#                         ().Seq.iterator),
#                       nqp::stmts(
#                         nqp::bindattr(cat, Kitten, '$!window', $win),
#                         ($!window-iter := $win."$!meth"(|$!args).iterator),
#                         self))),
#                   ().Seq.iterator)))
#         }
#         method new (\cat, \meth, \args) {
#             nqp::create(self)!SET-SELF: cat, meth, args
#         }
#
#         method pull-one {
#             nqp::if(
#               nqp::eqaddr($!peek, IterationEnd)
#               || nqp::isfalse(
#                   nqp::isconcrete(nqp::getattr($!cat, Kitten, '$!iter'))),
#               IterationEnd,
#               nqp::stmts(
#                 (my $win := nqp::getattr($!cat, Kitten, '$!window')),
#                 nqp::while(
#                   (
#                     nqp::eqaddr(
#                       (my $chunk := $!window-iter.pull-one), IterationEnd)
#                     || nqp::eqaddr(
#                       (   $!peek := $!window-iter.pull-one), IterationEnd)
#                     || nqp::iseq_s($chunk, $!peek)
#                     )
#                   )
#                   && nqp::if(
#                     nqp::eqaddr(
#                       ($_ := nqp::getattr($!cat, Kitten, '$!iter').pull-one),
#                       IterationEnd),
#                     nqp::bindattr($!cat, Kitten, '$!iter', Nil),
#                     1),
#                   nqp::stmts(
#                     ($win   := nqp::concat($win, $_)),
#                     ($!peek := Str),
#                     $!window-iter := $win."$!meth"(|$!args).iterator)),
#                 nqp::if(
#                   nqp::isconcrete($chunk),
#                   ($win := nqp::substr($win, nqp::chars($chunk)))),
#                 nqp::bindattr($!cat, Kitten, '$!window', $win),
#                 nqp::if(
#                   nqp::isconcrete($chunk),
#                   $chunk,
#                   IterationEnd)))
#         }
#     }.new: self, meth, args
# }

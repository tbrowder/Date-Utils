#!/bin/env raku

subset DoW of Int where { 0 < $_ < 8 }
my DoW ($a, $b) = 1, 1;

my @args;
for @*ARGS {
    when /(\d)/ {
        my $x = +$0;
        @args.push: $x;
    }
}
$a = shift @args if @args.elems;
$b = shift @args if @args.elems;

say "Inputs: $a, $b";


say days-remain($a, $b);

sub days-remain(
    DoW $week-start-dow, 
    DoW $first-dow = 1,
) {
    my $a = $week-start-dow - 1;
    my $b = $first-dow - 1;
    my @a = 1..7;
    my @b = @a.rotate($a);
    @b
}


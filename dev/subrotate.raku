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

say "Inputs:";
say "  Calendar week first day: $a";
say "  First dow in the month:  $b";

my $debug  = 0;
my $remain = days-remain($a, $b);
say "Days remaining: $remain";

sub days-remain(
    DoW $week-start-dow, 
    DoW $first-dow = 1,
    :$debug,
) {
    my $a = $week-start-dow - 1;
    my $b = $first-dow - 1;
    my @a = 1..7;
    # @b has calweek dows in order for the desired first cal dow
    my @b = @a.rotate($a);

    # given the dow to look up, calculate the days remaining in
    # the week
    # days remaining? create a hash
    my %rem;
    my $rem = 8;
    for @b -> $b {
        --$rem;
        %rem{$b} = $rem;
    }

    # get the position of the desired dow
    my $pos;
    for @b -> $p {
        $pos = $p if $p == $first-dow;
        last if $pos;
    }
    die "FATAL: \$pos is not defined" if not $pos;
    %rem{$pos}
}


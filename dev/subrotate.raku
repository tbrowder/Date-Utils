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
my $remain = days-in-week1($a, $b);
say "Days remaining: $remain";

sub days-in-week1(
    DoW $week-start-dow, 
    DoW $first-dow = 1,
    :$debug,
) {
    # create indexes into arrays
    my $a = $week-start-dow - 1;
    my $b = $first-dow - 1;
    my @dow = 1..7;
    # @calweek has calweek dows in order for the desired first cal dow
    my @calweek = @dow.rotate($a);

    # given the dow to look up, calculate the days remaining in
    # the week, create a hash
    my %days-remaining;
    my $remain = 8;
    for @calweek -> $b {
        --$remain;
        %days-remaining{$b} = $remain;
    }

    # get the position of the desired dow
    my $position;
    for @calweek -> $p {
        $position = $p if $p == $first-dow;
        last if $position;

    }
    die "FATAL: \$position is not defined" if not $position;
    %days-remaining{$position}
}


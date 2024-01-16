#!/bin/env raku

my @dows = 1..7;
for @dows -> $cal-start-day {
    say "$cal-start-day: {@dows.rotate($cal-start-day-1)}";
}
say "$_: {@dows.rotate($_-1)}" for 1..7;

say "=====";
my $calweeks = 1 + 26 div 7;
say "calweeks = $calweeks";

++$calweeks if 26 mod 7 > 0;
say "calweeks = $calweeks";


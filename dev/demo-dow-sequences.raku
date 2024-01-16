#!/bin/env raku

my @dows = 1..7;
for 1..7 -> $cal-start-day {
    say "$cal-start-day: {@dows.rotate($cal-start-day-1)}";
}

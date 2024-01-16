#!/bin/env raku

my @dows = 1..7;
for @dows -> $cal-start-day {
    say "$cal-start-day: {@dows.rotate($cal-start-day-1)}";
}
say "$_: {@dows.rotate($_-1)}" for 1..7;

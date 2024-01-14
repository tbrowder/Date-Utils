[![Actions Status](https://github.com/tbrowder/Date-Utils/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/Date-Utils/actions) [![Actions Status](https://github.com/tbrowder/Date-Utils/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/Date-Utils/actions) [![Actions Status](https://github.com/tbrowder/Date-Utils/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/Date-Utils/actions)

NAME
====

**Date::Utils** - Provides helpful date routines for calendar creation

SYNOPSIS
========

```raku
use Date::Utils;
...# use the routines to create a calendar
```

DESCRIPTION
===========

**Date::Utils** is a collection of routines to help users calculate certain dates in relation to other dates provided by Raku's powerful `Date` class.

Current routines provided:

  * `weeks-in-month`

    These two multi-subs return the total number of full and partial seven-day weeks in a calendar month where the day-of-week (dow) order begins with any desired day and ends the week six days later. The default is to start calendar weeks on Sunday and end on Saturday as normally used in US calendars.

    See the discussion of the methodology used in **Notes** below.

        multi sub weeks-in-month(
            :$year!, :$month!,
            :$cal-first-dow = 7, # Sunday
            :$debug
            --> UInt) {...}

        multi sub weeks-in-month(
            Date $date,
            :$cal-first-dow = 7, # Sunday
            :$debug
            --> UInt) {...}

  * `nth-day-of-week-in-month`

        sub nth-day-of-week-in-month(
            :$year!, :$month!, :$nth! is copy,
            :$day-of-week! where {0 < $_ <= 7},
            :$debug
            --> Date) {...}

    If `$nth` is greater than the actual number of `day-of-week`s in the desired month or if that number is zero or negative, the date of its last appearance in that month is returned.

    As a convenience, a version of the same routine requiring fewer key strokes is provided:

        sub nth-dow-in-month(
            :$year!, :$month!, :$nth! is copy,
            :$dow! where {0 < $_ <= 7},
            :$debug
            --> Date) {...}

  * `nth-day-of-week-after-date`

        sub nth-day-of-week-after-date(
            Date :$date!, :$nth! is copy,
            :$day-of-week! where {0 < $_ <= 7},
            :$debug
            --> Date) {...}

    As a convenience, a version of the same routine requiring fewer key strokes is provided:

        sub nth-dow-after-date(
            Date :$date!, :$nth! is copy,
            :$dow! where {0 < $_ <= 7},
            :$debug
            --> Date) {...}

Notes
=====



This version adds a more general routine to calculate the *weeks-in-month* for any starting day of the week (dow) given its number (Monday through Sunday) as a Raku Date dow in the range 1..7. The routine is important for laying out a calendar because it determines the vertical space required for the presentation.

Given a calendar week starting on Monday, the Raku Date dow values for a month are shown below along with the corresponding calendar values for a 31-day month starting on a Friday. Note there are five calendar weeks consisting of one partial week followed by four full weeks.

    Code             Days
    M T W T F S S    Mo Tu We Th Fr Sa Su
            5 6 7                 1  2  3
    1 2 3 4 5 6 7     4  5  6  7  8  9 10
    1 2 3 4 5 6 7    11 12 13 14 15 16 17
    1 2 3 4 5 6 7    18 19 20 21 22 23 24
    1 2 3 4 5 6 7    25 26 27 28 29 30 31

Changing the start day can have significant effects. If the calendar week starts on a Sunday, the Date dow numbers and the calendar days for the same month change to the form shown below. Note there are now **six** calendar weeks, consisting of one partial week followed by four full weeks followed by one partial week.

    Code             Days
    S M T W T F S    Su Mo Tu We Th Fr Sa
              5 6                    1  2
    7 1 2 3 4 5 6     3  4  5  6  7  8  9
    7 1 2 3 4 5 6    10 11 12 13 14 15 16
    7 1 2 3 4 5 6    17 18 19 20 21 22 23
    7 1 2 3 4 5 6    24 25 26 27 28 29 30
    7                31

So, how can we turn those observations into an algorithm? Raku's `Dateish` routines provide us with two known values of the month:

We choose our calendar week start day of the week from the last example: `my $Fc = 5`; # Friday>.

  * `my $Fd = $date.first-day-of-month; # 1..7`

  * `my $dim = $date.date.days-in-month; # 28, 29, 30, 31`

We observe that the maximum days in a month can consist of 28, 29, 30, or 31. If we take the first day of the month and compare it to our desired calendar week start day, we can derive the Date days in the first calendar week. Note lists of Date days stay in the proper order, so we must get one of the following sequences in a first week of one to seven days. Note each sequence is defined by its first day number, but it does **not** have to have its full set of days (as occurs in a partial first week).

We now construct a constant data object that enables us to address the Date dow for any combination of calendar week start day and position (1..7) in that week. We define a hash of hashes keyed by the Date dow desired to begin a calendar week. The values are hashes of that first week keyed with Date dow numbers for that week whose values are the number of days remaing in the week for each dow.

    my %calweeks = [
        1 => {
            # keys are Date dow's for this week
            # values are the number of days remaining in the week
            1 => 7, 2 => 6, 3 => 5, 4 => 4, 5 => 3, 6 => 2, 7 => 1,
        },
        2 => {
            2 => 7, 3 => 6, 4 => 5, 5 => 4, 6 => 3, 7 => 2, 1 => 1,
        },
        3 => {
            3 => 7, 4 => 6, 5 => 5, 6 => 4, 7 => 3, 1 => 2, 2 => 1,
        },
        4 => {
            4 => 7, 5 => 6, 6 => 5, 7 => 4, 1 => 3, 2 => 2, 3 => 1,
        },
        5 => {
            5 => 7, 6 => 6, 7 => 5, 1 => 4, 2 => 3, 3 => 2, 4 => 1,
        },
        6 => {
            6 => 7, 7 => 6, 1 => 5, 2 => 4, 3 => 3, 4 => 2, 5 => 1,
        },
        7 => {
            7 => 7, 1 => 6, 2 => 5, 3 => 4, 4 => 3, 5 => 2, 6 => 1,
        },
    ];

For example, given a calendar week that starts on Sunday (Date dow 7) and the first day of the month is a Date dow of 2 (Tuesday), we can find the existing position (`$Fc=7` and `$dow=2`). Using the hash we get the value of `%calweeks{$Fc}{$dow}=5` which are the days remaining in that week.

Given that value, subtract it from `$dim` to get the number of days left in the month. Those remaining days divided by seven (rounded up) yield the remaining weeks so we have our desired number.

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2024 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.


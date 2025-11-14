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

The ISO standard calendar week begins on Monday as day-of-the-week (DoW) one and ends on Sunday, DoW seven, but the default in the subroutines herein is set for the US practice of beginning the calendar week on Sunday. However, that default is easily changed by the named parameter `:$cal-first-dow` as seen in the signatures of pertinent subroutines listed below.

Routines provided in this module
================================

  * `dow-name`

    Given the day-of-week (DoW) for a Date, return its name in US English.

    (If another language is desired use module `Date::Names`.)

  * `days-of-week`

    Given the day-of-week (DoW) for the start of a calendar week, return a list of the DoWs. Access the list with the `day-index-in-week`.

        sub days-of-week(
            DoW $cal-first-dow = 7, # Sunday
            :$debug,
            --> List # range 1..7
        ) is export {

  * `day-index-in-week`

    Given the day-of-week (DoW) of any day of a week, and the starting DoW for a calendar week, this routine returns the index of that DoW in a list of the calendar's DoWs. Use the index with the list from `days-of-week`.

        sub day-index-in-week(
            DoW $dow, # range 1..7
            DoW :$cal-first-dow = 7, # Sunday
            :$debug,
            --> UInt # range 0..6
        ) is export {...}

  * `days-in-week1`

    Given the day-of-week (DoW) of the first Date of the month, and the starting DoW for a calendar week, this routine returns the number of days remaining in the month's first calendar week.

        subset DoW of Int where { 0 < $_ < 8 }
        sub days-in-week1(
            DoW $first-dow,
            DoW :$cal-first-dow = 7, # Sunday
            :$debug,
            --> DoW
        ) is export {...}

  * `weeks-in-month`

    These two multi-subs return the total number of full and partial seven-day weeks in a calendar month where the day-of-week order begins with any desired day and ends the week six days later.

        multi sub weeks-in-month(
            :$year!, :$month!,
            DoW :$cal-first-dow = 7, # Sunday
            :$debug
            --> UInt) {...}

        multi sub weeks-in-month(
            Date $date,
            DoW :$cal-first-dow = 7, # Sunday
            :$debug
            --> UInt) {...}

  * `nth-day-of-week-in-month`

        sub nth-day-of-week-in-month(
            :$year!, :$month!, :$nth! is copy,
            DoW :$day-of-week!,
            :$debug
            --> Date) {...}

    If `$nth` is greater than the actual number of `day-of-week`s in the desired month or if that number is zero or negative, the date of its last appearance in that month is returned.

    As a convenience, a version of the same routine requiring fewer key strokes is provided:

        sub nth-dow-in-month(
            :$year!, :$month!, :$nth! is copy,
            DoW :$dow!,
            :$debug
            --> Date) {...}

  * `nth-day-of-week-after-date`

        sub nth-day-of-week-after-date(
            Date :$date!, :$nth! is copy,
            DoW :$day-of-week!,
            :$debug
            --> Date) {...}

    As a convenience, a version of the same routine requiring fewer key strokes is provided:

        sub nth-dow-after-date(
            Date :$date!, :$nth! is copy,
            DoW :$dow!,
            :$debug
            --> Date) {...}

Notes
=====



A more general routine has been added since the original release to calculate the *weeks-in-month* for **any** starting day of the week (DoW) given its number (Monday through Sunday) as a Raku Date DoW in the range 1..7 (the default ISO DoW order for a Raku Date). The routine is important for laying out a calendar because it determines the vertical space required for the presentation.

With a calendar week starting on Monday, the ISO Date DoW values for a month are shown below along with the corresponding calendar values for a 31-day month starting on a Friday. Note there are five calendar weeks consisting of one partial week followed by four full weeks.

    Code             Days
    M T W T F S S    Mo Tu We Th Fr Sa Su
            5 6 7                 1  2  3
    1 2 3 4 5 6 7     4  5  6  7  8  9 10
    1 2 3 4 5 6 7    11 12 13 14 15 16 17
    1 2 3 4 5 6 7    18 19 20 21 22 23 24
    1 2 3 4 5 6 7    25 26 27 28 29 30 31

Changing the calendar week start day can have significant effects. If the calendar week starts on a Sunday, the Date DoW numbers and the calendar days for the **same month** change to the form shown below. Note there are now **six** calendar weeks consisting of one partial week followed by four full weeks followed by one partial week.

    Code             Days
    S M T W T F S    Su Mo Tu We Th Fr Sa
              5 6                    1  2
    7 1 2 3 4 5 6     3  4  5  6  7  8  9
    7 1 2 3 4 5 6    10 11 12 13 14 15 16
    7 1 2 3 4 5 6    17 18 19 20 21 22 23
    7 1 2 3 4 5 6    24 25 26 27 28 29 30
    7                31

Raku's `Date` routines provide us with two known values of the month that will enable the needed calculations. They are:

    A: Date.first-date-of-month.day-of-week # range: 1..7
    B: Date.days-in-month                   # range: 28..31

Given the first value (A), and knowing the DoWs retain their order, we can derive the Date days in the first calendar week. The lists of Date DoWs stay in the proper order as shown in the following code:

    my @dows = 1..7;
    for @dows -> $cal-start-day {
        say "$cal-start-day: {@dows.rotate($cal-start-day-1)}";
    }
    # OUTPUT:
    1: 1 2 3 4 5 6 7
    2: 2 3 4 5 6 7 1
    3: 3 4 5 6 7 1 2
    4: 4 5 6 7 1 2 3
    5: 5 6 7 1 2 3 4
    6: 6 7 1 2 3 4 5
    7: 7 1 2 3 4 5 6

Therefore, we must get one of the above sequences during the first week, which can range from one to seven days. Also note that each sequence is defined by its first day number, but it doesn't necessarily include a full set of days, as seen in a partial first week.

For example, given a calendar week that starts on Sunday (Date DoW 7) and the first day of the month is a Date DoW of 2 (Tuesday), using the routine `days-in-week1` yields a value of 5 which is the number of days remaining in that first week.

    C: days-in-week1 7, 2  # OUTPUT: 5

Subtracting that number from the **A** value (`Date.days-in-month`) yields the number of days left in the month: `D = A - C = 26`.

Dividing the remaining days by seven (and rounding up by one for any partial week) gives us the remaining weeks, leading to the desired result:

    $cal-weeks  =  1;                # from the B Date value 
    $cal-weeks += 26 div 7;          # OUTPUT: 4 # plus other full weeks
    $cal-weeks += 1 if 26 mod 7 > 0; # OUTPUT: 5 # plus a partial week
                                                 # yields the end result

CREDITS
=======



Thanks to fellow Raku user and author **Anton Antonov** (Github and #raku alias: @antononcube) and his fluency with LLMs for helping me to clean up my awkward grammar in the Notes section of this document.

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2024 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.


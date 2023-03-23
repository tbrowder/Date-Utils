[![Actions Status](https://github.com/tbrowder/Date-Utils/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/Date-Utils/actions) [![Actions Status](https://github.com/tbrowder/Date-Utils/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/Date-Utils/actions) [![Actions Status](https://github.com/tbrowder/Date-Utils/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/Date-Utils/actions)

NAME
====

**Date::Utils** - Provides helpful date routines for calendar creation

SYNOPSIS
========

```raku
use Date::Utils;
```

DESCRIPTION
===========

**Date::Utils** is a collection of routines to help users calculate certain dates in relation to other dates provided by Raku's powerful `Date` class.

Also provided are routines representing methods not currently provided by the `Dateish` role. Current routines provided:

  * `weeks-in-month`

    These multi-subs return the total number of full and partial weeks in a month.

    Note these routines have been proposed as new methods for the Raku `Dateish` role.

        multi sub weeks-in-month(
            :$year!, :$month!, 
            :$debug
            --> UInt) {...}

        multi sub weeks-in-month(
            Date $date,
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

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2023 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.


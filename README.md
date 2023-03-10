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

Current routine provided:

  * `nth-day-of-week-in-month`

    sub nth-day-of-week-in-month(
         :$year!, :$month!, :$nth! is copy, 
         :$day-of-week! where {0 < $_ <= 7}, 
         :$debug
         --> Date) {...}

If `$nth` is greater than the actual number of `day-of-week`s in the desired month or if that number is negative, the date of its last appearance in that month is returned.

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2023 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.


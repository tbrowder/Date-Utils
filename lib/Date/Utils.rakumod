unit module Date::Utils;

my sub days-in-week1(
    Date $date,
    :$cal-first-dow = 7, # Sunday
    :$debug
    --> UInt) {
    my $F     = $date.first-date-in-month;
    my $Fd    = $F.day-of-week; # 1..7 (Mon..Sun)
    my $Fc    = $cal-first-dow;
    my $ndays = $date.days-in-month;
    
}

multi sub weeks-in-month(
    :$year!, :$month!, 
    :cal-first-dow = 7, # Sunday
    :$debug
    --> UInt) is export {
    my $date = Date.new: :$year, :$month;
    weeks-in-month $date, :$cal-first-dow, :$debug
}

multi sub weeks-in-month(
    Date $date,
    :$cal-first-dow = 7, # Sunday
    :$debug
    --> UInt) is export {

    my $Fc = $cal-first-dow; # 1..7
    unless 0 < $Fc < 8 {
        die "FATAL: cal-first-dow out of range 1..7, input value was: $Fc"
    }

    # get days in first week
    # transform this:
    # 7 1 2 3 4 5 6 => $dow 
    # to this
    # 1 2 3 4 5 6 7
    # 7 - 6 = 1
    # 1 + 1 = 2
    # 2
    # 3
    # 4
    # 5
    # 6 + 1 = 7

    my $F   = $date.first-date-in-month;
    my $dim = $date.days-in-month;
    my $Fd  = $F.day-of-week; # 1..7 (Mon..Sun)

    my ($dw1, $dw2, $days-in-week1);
    with $Fd { # 1..7 (Mo..Su)
        when $Fc == $Fd     { $dw1 = 7 }
          # Fc - Fd = 0 => 7
          # 7  - Fd = 0 => 1
        when $Fc == $Fd + 1 { $dw1 = 6 }
          # Fc - Fd = 0 => 7
        when $Fc == $Fd + 2 { $dw1 = 5 }
        when $Fc == $Fd + 3 { $dw1 = 4 }
        when $Fc == $Fd + 4 { $dw1 = 3 }
        when $Fc == $Fd + 5 { $dw1 = 2 }
        when $Fc == $Fd + 6 { $dw1 = 1 }
    }
    # summarized as
    #   days = ($Fc - $Fd) + 1
    days-in-week1 = $dw1;

    my $days-remain    = $dim - $days-in-week1;
    my $weeks-in-month = 1; # the first full or partial week

    # account for remaining days
    $weeks-in-month += ($days-remain div 7);
    ++$weeks-in-month if ($days-remain mod 7).so;
    $weeks-in-month

    # Visualize the situation
    # Monday starts the month
    # 1 2 3 4 5 6 7    7
    # 1 2 3 4 5 6 7   14
    # 1 2 3 4 5 6 7   21
    # 1 2 3 4 5 6 7   28
    # 1 2 3 4 5 6 7   35
    # 1 2 3 4 5 6 7   42

    # Sunday starts the month
    #             7    1
    # 1 2 3 4 5 6 7    8
    # 1 2 3 4 5 6 7   15
    # 1 2 3 4 5 6 7   22
    # 1 2 3 4 5 6 7   29
    # 1 2 3 4 5 6 7   36
    # 1 2 3 4 5 6 7   43

    # divide days-in-month by 7:
    #   first day is on a Monday
    #   31: 4 weeks plus 3 days (5 weeks max)
    #   30: 4 weeks plus 2 days (5 weeks max) 
    #   29: 4 weeks plus 1 day  (5 weeks max) 
    #   28: 4 weeks exactly     (4 weeks max) 

    #   first day is on a Sunday
    #   31: 1 day plus 4 weeks plus 2 days (6 weeks max)
    #   30: 1 day plus 4 weeks plus 1 day  (6 weeks max) 
    #   29: 1 day plus 4 weeks exactly     (5 weeks max) 
    #   28: 1 day plus 3 weeks plus 6 days (5 weeks max) 
}

sub nth-dow-in-month(
    :$year!, :$month!, :$nth! is copy, 
    :$dow! where {0 < $_ <= 7}, 
    :$debug
    --> Date) is export {

    nth-day-of-week-in-month :$year, :$month, :$nth, 
    :day-of-week($dow), :$debug
}

sub nth-day-of-week-in-month(
    :$year!, :$month!, :$nth! is copy, 
    :$day-of-week! where {0 < $_ <= 7}, 
    :$debug
    --> Date) is export {

    if $nth < 1 {
        $nth = 10;
    }

    my Date $date;
    # get the first dow in the month
    my Date $d = Date.new: :$year, :$month; # default is day = 1;
    my $dow = $d.day-of-week;
    # find first instance in the month
    while $dow != $day-of-week {
        $d += 1;
        $dow = $d.day-of-week;
    }

    my $instance = 1;
    my $dd       = $d;

    # find the nth instance within the same month
    while $instance != $nth {
        $dd += 7;
        # we're finished if we're in the next month
        if $dd.month != $d.month {
            $dd -= 7;
            last;
        }

        # keep going
        $instance += 1;
    }
    $dd
}

sub nth-dow-after-date(
    Date :$date!, :$nth! is copy, 
    :$dow! where {0 < $_ <= 7}, 
    :$debug
    --> Date) is export {

    nth-day-of-week-after-date :$date, :$nth, 
    :day-of-week($dow), :$debug
}

sub nth-day-of-week-after-date(
    Date :$date!, :$nth! is copy, 
    :$day-of-week! where {0 < $_ <= 7}, 
    :$debug
    --> Date) is export {

    if $nth < 1 {
        $nth = 10;
    }

    # get the first dow after the start date
    my Date $d = $date;
    my $dow = $d.day-of-week;
    # find first instance after the start date
    # BUT do not count the start date
    $d += 1;
    $dow = $d.day-of-week;
    while $dow != $day-of-week {
        $d += 1;
        $dow = $d.day-of-week;
    }

    my $instance = 1;
    my $dd       = $d;

    # find the nth instance after the start date
    while $instance != $nth {
        $dd += 7;
        # keep going
        $instance += 1;
    }
    $dd
}

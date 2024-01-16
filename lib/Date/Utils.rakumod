unit module Date::Utils;

my %calweeks;

subset DoW of Int where { 0 < $_ < 8 }

sub days-in-week1(
    DoW $cal-week-start-dow, 
    DoW $first-dow = 1,
    :$debug,
    --> DoW
) is export {
    # create indexes into arrays
    my $a = $cal-week-start-dow - 1;
    my $b = $first-dow - 1;
    my @DoW = 1..7;
    # @calweek has calweek DoWs in order for the desired first cal DoW
    my @calweek = @DoW.rotate($a);

    # given the DoW to look up, calculate the days remaining in
    # the week, create a hash
    my %days-remaining;
    my $remain = 8;
    for @calweek -> $b {
        --$remain;
        %days-remaining{$b} = $remain;
    }

    # get the position of the desired DoW
    my $position;
    for @calweek -> $p {
        $position = $p if $p == $first-dow;
        last if $position;

    }
    die "FATAL: \$position is not defined" if not $position;
    %days-remaining{$position}
}

multi sub weeks-in-month(
    :$year!, :$month!,
    DoW :$cal-first-dow = 7, # Sunday
    :$debug
    --> UInt) is export {
    my $date = Date.new: :$year, :$month;
    weeks-in-month $date, :$cal-first-dow, :$debug
}

multi sub weeks-in-month(
    Date $date,
    DoW :$cal-first-dow = 7, # Sunday
    :$debug
    --> UInt) is export {

    # Define the first DoW for a calendar week
    my $Fc = $cal-first-dow; # 1..7

    # Get the first Date DoW in the month
    #my $F   = $date.first-date-in-month;
    # Get its DoW
    my $Fd  = $date.first-date-in-month.day-of-week;
    # Get the total number of days in the month
    my $Dim = $date.days-in-month;

    my ($days-in-week1, $d1, $days-remain, $dr, $weeks-in-month);
    #$days-in-week1  = %calweeks{$Fc}{$Fd};
    $days-in-week1  = days-in-week1 $Fc, $Fd;

    $days-remain    = $Dim - $days-in-week1;

    # We now know all about the first week in this month
    $weeks-in-month = 1; # the first full or partial week

    # Calculate the number of weeks remaining in the month
    $weeks-in-month += $days-remain div 7;
    # Any left over days are a partial week which also counts as a week
    ++$weeks-in-month if $days-remain % 7 > 0;

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
    DoW :$dow!,
    :$debug
    --> Date) is export {

    nth-day-of-week-in-month :$year, :$month, :$nth,
        :day-of-week($dow), :$debug
}

sub nth-day-of-week-in-month(
    :$year!, :$month!, :$nth! is copy,
    DoW :$day-of-week!,
    :$debug
    --> Date) is export {

    if $nth < 1 {
        $nth = 10;
    }

    my Date $date;
    # get the first DoW in the month
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
    DoW :$dow!,
    :$debug
    --> Date) is export {

    nth-day-of-week-after-date :$date, :$nth,
        :day-of-week($dow), :$debug
}

sub nth-day-of-week-after-date(
    Date :$date!, :$nth! is copy,
    DoW :$day-of-week!,
    :$debug
    --> Date) is export {

    if $nth < 1 {
        $nth = 10;
    }

    # Get the first DoW after the start date
    my Date $d = $date;
    my $dow = $d.day-of-week;
    # Find first instance after the start date
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

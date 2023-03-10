unit module Date::Utils;

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
    --> Date) {

    nth-day-of-week-after-date :$date, :$nth, 
    :day-of-week($dow), :$debug
}

sub nth-day-of-week-after-date(
    Date :$date!, :$nth! is copy, 
    :$day-of-week! where {0 < $_ <= 7}, 
    :$debug
    --> Date) {

    if $nth < 1 {
        $nth = 10;
    }

    # get the first dow after the start date
    my Date $d = $date;
    my $dow = $d.day-of-week;
    # find first instance after the start date
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

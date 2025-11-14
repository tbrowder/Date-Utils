use Test;

use Date::Utils;

plan 8;

my $d = Date.new: "2025-11-14";
is $d.day-of-week, 5;

my $dow = dow-name $d.day-of-week;
is $dow, "Friday";

$d -= 4;
$dow = dow-name $d.day-of-week;
is $dow, "Monday";

++$d;
$dow = dow-name $d.day-of-week;
is $dow, "Tuesday";

++$d;
$dow = dow-name $d.day-of-week;
is $dow, "Wednesday";

++$d;
$dow = dow-name $d.day-of-week;
is $dow, "Thursday";

$d += 2;
$dow = dow-name $d.day-of-week;
is $dow, "Saturday";

++$d;
$dow = dow-name $d.day-of-week;
is $dow, "Sunday";


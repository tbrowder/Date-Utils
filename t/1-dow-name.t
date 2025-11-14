use Test;

use Date::Utils;

plan 14;

my ($d, $dow, $n, $dow2);
$d = Date.new: "2025-11-14";
$n = $d.day-of-week;
is $n, 5;

$dow = dow-name $n;
is $dow, "Friday";

$d -= 4;
$n = $d.day-of-week;
$dow = dow-name $n;
is $dow, "Monday";
$dow2 = dow-name $d;
is $dow2, "Monday";

++$d;
$n = $d.day-of-week;
$dow = dow-name $n;
is $dow, "Tuesday";
$dow2 = dow-name $d;
is $dow2, "Tuesday";

++$d;
$n = $d.day-of-week;
$dow = dow-name $n;
is $dow, "Wednesday";
$dow2 = dow-name $d;
is $dow2, "Wednesday";

++$d;
$n = $d.day-of-week;
$dow = dow-name $n;
is $dow, "Thursday";
$dow2 = dow-name $d;
is $dow2, "Thursday";

$d += 2;
$n = $d.day-of-week;
$dow = dow-name $n;
is $dow, "Saturday";
$dow2 = dow-name $d;
is $dow2, "Saturday";

++$d;
$n = $d.day-of-week;
$dow = dow-name $n;
is $dow, "Sunday";
$dow2 = dow-name $d;
is $dow2, "Sunday";


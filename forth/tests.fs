( Generated tests from tests.yaml )

VARIABLE FAILED-TESTS
0 FAILED-TESTS !

: TEST-START ( addr len -- )
  CR ." Running: " TYPE ;

: ASSERT-EQUAL-STR ( addr1 len1 addr2 len2 -- )
  2OVER 2OVER COMPARE 0 = IF
    2DROP 2DROP ."  [PASS]"
  ELSE
    CR ."  [FAIL] Expected: '" TYPE ." ' Got: '" TYPE ." '"
    1 FAILED-TESTS +!
  THEN ;

: ASSERT-EQUAL-INT ( n1 n2 -- )
  2DUP = IF
    2DROP ."  [PASS]"
  ELSE
    CR ."  [FAIL] Expected: " N>S TYPE ."  Got: " N>S TYPE
    1 FAILED-TESTS +!
  THEN ;

: ASSERT-ERROR ( xt -- )
  DEPTH 1- >R ( depth before execute, excluding xt )
  EXECUTE
  DEPTH R> - ( depth_change )
  2 = IF
    ( addr len )
    2DUP S" ERROR" COMPARE 0 = IF
      2DROP ."  [PASS]"
    ELSE
      2DROP ."  [FAIL] Expected 'ERROR'"
      1 FAILED-TESTS +!
    THEN
  ELSE
    ( n )
    -1 = IF
      ."  [PASS]"
    ELSE
      ."  [FAIL] Expected -1"
      1 FAILED-TESTS +!
    THEN
  THEN ;

: REPORT-SUMMARY
  CR CR FAILED-TESTS @ 0 = IF
    ." All tests passed!"
  ELSE
    FAILED-TESTS @ N>S TYPE ."  tests failed."
  THEN CR ;


S" timeago: just now - identical timestamps" TEST-START
1704067200 1704067200 TIMEAGO
S" just now" ASSERT-EQUAL-STR

S" timeago: just now - 30 seconds ago" TEST-START
1704067170 1704067200 TIMEAGO
S" just now" ASSERT-EQUAL-STR

S" timeago: just now - 44 seconds ago" TEST-START
1704067156 1704067200 TIMEAGO
S" just now" ASSERT-EQUAL-STR

S" timeago: 1 minute ago - 45 seconds" TEST-START
1704067155 1704067200 TIMEAGO
S" 1 minute ago" ASSERT-EQUAL-STR

S" timeago: 1 minute ago - 89 seconds" TEST-START
1704067111 1704067200 TIMEAGO
S" 1 minute ago" ASSERT-EQUAL-STR

S" timeago: 2 minutes ago - 90 seconds" TEST-START
1704067110 1704067200 TIMEAGO
S" 2 minutes ago" ASSERT-EQUAL-STR

S" timeago: 30 minutes ago" TEST-START
1704065400 1704067200 TIMEAGO
S" 30 minutes ago" ASSERT-EQUAL-STR

S" timeago: 44 minutes ago" TEST-START
1704064560 1704067200 TIMEAGO
S" 44 minutes ago" ASSERT-EQUAL-STR

S" timeago: 1 hour ago - 45 minutes" TEST-START
1704064500 1704067200 TIMEAGO
S" 1 hour ago" ASSERT-EQUAL-STR

S" timeago: 1 hour ago - 89 minutes" TEST-START
1704061860 1704067200 TIMEAGO
S" 1 hour ago" ASSERT-EQUAL-STR

S" timeago: 2 hours ago - 90 minutes" TEST-START
1704061800 1704067200 TIMEAGO
S" 2 hours ago" ASSERT-EQUAL-STR

S" timeago: 5 hours ago" TEST-START
1704049200 1704067200 TIMEAGO
S" 5 hours ago" ASSERT-EQUAL-STR

S" timeago: 21 hours ago" TEST-START
1703991600 1704067200 TIMEAGO
S" 21 hours ago" ASSERT-EQUAL-STR

S" timeago: 1 day ago - 22 hours" TEST-START
1703988000 1704067200 TIMEAGO
S" 1 day ago" ASSERT-EQUAL-STR

S" timeago: 1 day ago - 35 hours" TEST-START
1703941200 1704067200 TIMEAGO
S" 1 day ago" ASSERT-EQUAL-STR

S" timeago: 2 days ago - 36 hours" TEST-START
1703937600 1704067200 TIMEAGO
S" 2 days ago" ASSERT-EQUAL-STR

S" timeago: 7 days ago" TEST-START
1703462400 1704067200 TIMEAGO
S" 7 days ago" ASSERT-EQUAL-STR

S" timeago: 25 days ago" TEST-START
1701907200 1704067200 TIMEAGO
S" 25 days ago" ASSERT-EQUAL-STR

S" timeago: 1 month ago - 26 days" TEST-START
1701820800 1704067200 TIMEAGO
S" 1 month ago" ASSERT-EQUAL-STR

S" timeago: 1 month ago - 45 days" TEST-START
1700179200 1704067200 TIMEAGO
S" 1 month ago" ASSERT-EQUAL-STR

S" timeago: 2 months ago - 46 days" TEST-START
1700092800 1704067200 TIMEAGO
S" 2 months ago" ASSERT-EQUAL-STR

S" timeago: 6 months ago" TEST-START
1688169600 1704067200 TIMEAGO
S" 6 months ago" ASSERT-EQUAL-STR

S" timeago: 10 months ago - 319 days" TEST-START
1676505600 1704067200 TIMEAGO
S" 10 months ago" ASSERT-EQUAL-STR

S" timeago: 1 year ago - 320 days" TEST-START
1676419200 1704067200 TIMEAGO
S" 1 year ago" ASSERT-EQUAL-STR

S" timeago: 1 year ago - 547 days" TEST-START
1656806400 1704067200 TIMEAGO
S" 1 year ago" ASSERT-EQUAL-STR

S" timeago: 2 years ago - 548 days" TEST-START
1656720000 1704067200 TIMEAGO
S" 2 years ago" ASSERT-EQUAL-STR

S" timeago: 5 years ago" TEST-START
1546300800 1704067200 TIMEAGO
S" 5 years ago" ASSERT-EQUAL-STR

S" timeago: future - in just now (30 seconds)" TEST-START
1704067230 1704067200 TIMEAGO
S" just now" ASSERT-EQUAL-STR

S" timeago: future - in 1 minute" TEST-START
1704067260 1704067200 TIMEAGO
S" in 1 minute" ASSERT-EQUAL-STR

S" timeago: future - in 5 minutes" TEST-START
1704067500 1704067200 TIMEAGO
S" in 5 minutes" ASSERT-EQUAL-STR

S" timeago: future - in 1 hour" TEST-START
1704070200 1704067200 TIMEAGO
S" in 1 hour" ASSERT-EQUAL-STR

S" timeago: future - in 3 hours" TEST-START
1704078000 1704067200 TIMEAGO
S" in 3 hours" ASSERT-EQUAL-STR

S" timeago: future - in 1 day" TEST-START
1704150000 1704067200 TIMEAGO
S" in 1 day" ASSERT-EQUAL-STR

S" timeago: future - in 2 days" TEST-START
1704240000 1704067200 TIMEAGO
S" in 2 days" ASSERT-EQUAL-STR

S" timeago: future - in 1 month" TEST-START
1706745600 1704067200 TIMEAGO
S" in 1 month" ASSERT-EQUAL-STR

S" timeago: future - in 1 year" TEST-START
1735689600 1704067200 TIMEAGO
S" in 1 year" ASSERT-EQUAL-STR

S" duration: zero seconds" TEST-START
RESET-OPTIONS
0 DURATION
S" 0 seconds" ASSERT-EQUAL-STR

S" duration: 1 second" TEST-START
RESET-OPTIONS
1 DURATION
S" 1 second" ASSERT-EQUAL-STR

S" duration: 45 seconds" TEST-START
RESET-OPTIONS
45 DURATION
S" 45 seconds" ASSERT-EQUAL-STR

S" duration: 1 minute" TEST-START
RESET-OPTIONS
60 DURATION
S" 1 minute" ASSERT-EQUAL-STR

S" duration: 1 minute 30 seconds" TEST-START
RESET-OPTIONS
90 DURATION
S" 1 minute, 30 seconds" ASSERT-EQUAL-STR

S" duration: 2 minutes" TEST-START
RESET-OPTIONS
120 DURATION
S" 2 minutes" ASSERT-EQUAL-STR

S" duration: 1 hour" TEST-START
RESET-OPTIONS
3600 DURATION
S" 1 hour" ASSERT-EQUAL-STR

S" duration: 1 hour 1 minute" TEST-START
RESET-OPTIONS
3661 DURATION
S" 1 hour, 1 minute" ASSERT-EQUAL-STR

S" duration: 1 hour 30 minutes" TEST-START
RESET-OPTIONS
5400 DURATION
S" 1 hour, 30 minutes" ASSERT-EQUAL-STR

S" duration: 2 hours 30 minutes" TEST-START
RESET-OPTIONS
9000 DURATION
S" 2 hours, 30 minutes" ASSERT-EQUAL-STR

S" duration: 1 day" TEST-START
RESET-OPTIONS
86400 DURATION
S" 1 day" ASSERT-EQUAL-STR

S" duration: 1 day 2 hours" TEST-START
RESET-OPTIONS
93600 DURATION
S" 1 day, 2 hours" ASSERT-EQUAL-STR

S" duration: 7 days" TEST-START
RESET-OPTIONS
604800 DURATION
S" 7 days" ASSERT-EQUAL-STR

S" duration: 1 month (30 days)" TEST-START
RESET-OPTIONS
2592000 DURATION
S" 1 month" ASSERT-EQUAL-STR

S" duration: 1 year (365 days)" TEST-START
RESET-OPTIONS
31536000 DURATION
S" 1 year" ASSERT-EQUAL-STR

S" duration: 1 year 2 months" TEST-START
RESET-OPTIONS
36720000 DURATION
S" 1 year, 2 months" ASSERT-EQUAL-STR

S" duration: compact - 1h 1m" TEST-START
RESET-OPTIONS
1 OPT-COMPACT !
3661 DURATION
S" 1h 1m" ASSERT-EQUAL-STR

S" duration: compact - 2h 30m" TEST-START
RESET-OPTIONS
1 OPT-COMPACT !
9000 DURATION
S" 2h 30m" ASSERT-EQUAL-STR

S" duration: compact - 1d 2h" TEST-START
RESET-OPTIONS
1 OPT-COMPACT !
93600 DURATION
S" 1d 2h" ASSERT-EQUAL-STR

S" duration: compact - 45s" TEST-START
RESET-OPTIONS
1 OPT-COMPACT !
45 DURATION
S" 45s" ASSERT-EQUAL-STR

S" duration: compact - 0s" TEST-START
RESET-OPTIONS
1 OPT-COMPACT !
0 DURATION
S" 0s" ASSERT-EQUAL-STR

S" duration: max_units 1 - hours only" TEST-START
RESET-OPTIONS
1 OPT-MAX-UNITS !
3661 DURATION
S" 1 hour" ASSERT-EQUAL-STR

S" duration: max_units 1 - days only" TEST-START
RESET-OPTIONS
1 OPT-MAX-UNITS !
93600 DURATION
S" 1 day" ASSERT-EQUAL-STR

S" duration: max_units 3" TEST-START
RESET-OPTIONS
3 OPT-MAX-UNITS !
93661 DURATION
S" 1 day, 2 hours, 1 minute" ASSERT-EQUAL-STR

S" duration: compact max_units 1" TEST-START
RESET-OPTIONS
1 OPT-COMPACT !
1 OPT-MAX-UNITS !
9000 DURATION
S" 2h" ASSERT-EQUAL-STR

S" duration: error - negative seconds" TEST-START
RESET-OPTIONS
-100 DURATION S" ERROR" ASSERT-EQUAL-STR

S" parse_duration: compact hours minutes" TEST-START
S" 2h30m" PARSE-DURATION
9000 ASSERT-EQUAL-INT

S" parse_duration: compact with space" TEST-START
S" 2h 30m" PARSE-DURATION
9000 ASSERT-EQUAL-INT

S" parse_duration: compact with comma" TEST-START
S" 2h, 30m" PARSE-DURATION
9000 ASSERT-EQUAL-INT

S" parse_duration: verbose" TEST-START
S" 2 hours 30 minutes" PARSE-DURATION
9000 ASSERT-EQUAL-INT

S" parse_duration: verbose with and" TEST-START
S" 2 hours and 30 minutes" PARSE-DURATION
9000 ASSERT-EQUAL-INT

S" parse_duration: verbose with comma and" TEST-START
S" 2 hours, and 30 minutes" PARSE-DURATION
9000 ASSERT-EQUAL-INT

S" parse_duration: decimal hours" TEST-START
S" 2.5 hours" PARSE-DURATION
9000 ASSERT-EQUAL-INT

S" parse_duration: decimal compact" TEST-START
S" 1.5h" PARSE-DURATION
5400 ASSERT-EQUAL-INT

S" parse_duration: single unit minutes verbose" TEST-START
S" 90 minutes" PARSE-DURATION
5400 ASSERT-EQUAL-INT

S" parse_duration: single unit minutes compact" TEST-START
S" 90m" PARSE-DURATION
5400 ASSERT-EQUAL-INT

S" parse_duration: single unit min" TEST-START
S" 90min" PARSE-DURATION
5400 ASSERT-EQUAL-INT

S" parse_duration: colon notation h:mm" TEST-START
S" 2:30" PARSE-DURATION
9000 ASSERT-EQUAL-INT

S" parse_duration: colon notation h:mm:ss" TEST-START
S" 1:30:00" PARSE-DURATION
5400 ASSERT-EQUAL-INT

S" parse_duration: colon notation with seconds" TEST-START
S" 0:05:30" PARSE-DURATION
330 ASSERT-EQUAL-INT

S" parse_duration: days verbose" TEST-START
S" 2 days" PARSE-DURATION
172800 ASSERT-EQUAL-INT

S" parse_duration: days compact" TEST-START
S" 2d" PARSE-DURATION
172800 ASSERT-EQUAL-INT

S" parse_duration: weeks verbose" TEST-START
S" 1 week" PARSE-DURATION
604800 ASSERT-EQUAL-INT

S" parse_duration: weeks compact" TEST-START
S" 1w" PARSE-DURATION
604800 ASSERT-EQUAL-INT

S" parse_duration: mixed verbose" TEST-START
S" 1 day, 2 hours, and 30 minutes" PARSE-DURATION
95400 ASSERT-EQUAL-INT

S" parse_duration: mixed compact" TEST-START
S" 1d 2h 30m" PARSE-DURATION
95400 ASSERT-EQUAL-INT

S" parse_duration: seconds only verbose" TEST-START
S" 45 seconds" PARSE-DURATION
45 ASSERT-EQUAL-INT

S" parse_duration: seconds compact s" TEST-START
S" 45s" PARSE-DURATION
45 ASSERT-EQUAL-INT

S" parse_duration: seconds compact sec" TEST-START
S" 45sec" PARSE-DURATION
45 ASSERT-EQUAL-INT

S" parse_duration: hours hr" TEST-START
S" 2hr" PARSE-DURATION
7200 ASSERT-EQUAL-INT

S" parse_duration: hours hrs" TEST-START
S" 2hrs" PARSE-DURATION
7200 ASSERT-EQUAL-INT

S" parse_duration: minutes mins" TEST-START
S" 30mins" PARSE-DURATION
1800 ASSERT-EQUAL-INT

S" parse_duration: case insensitive" TEST-START
S" 2H 30M" PARSE-DURATION
9000 ASSERT-EQUAL-INT

S" parse_duration: whitespace tolerance" TEST-START
S"   2 hours   30 minutes  " PARSE-DURATION
9000 ASSERT-EQUAL-INT

S" parse_duration: error - empty string" TEST-START
S" " PARSE-DURATION -1 ASSERT-EQUAL-INT

S" parse_duration: error - no units" TEST-START
S" hello world" PARSE-DURATION -1 ASSERT-EQUAL-INT

S" parse_duration: error - negative" TEST-START
S" -5 hours" PARSE-DURATION -1 ASSERT-EQUAL-INT

S" parse_duration: error - just number" TEST-START
S" 42" PARSE-DURATION -1 ASSERT-EQUAL-INT

S" human_date: today" TEST-START
1705276800 1705276800 HUMAN-DATE
S" Today" ASSERT-EQUAL-STR

S" human_date: today - same day different time" TEST-START
1705320000 1705276800 HUMAN-DATE
S" Today" ASSERT-EQUAL-STR

S" human_date: yesterday" TEST-START
1705190400 1705276800 HUMAN-DATE
S" Yesterday" ASSERT-EQUAL-STR

S" human_date: tomorrow" TEST-START
1705363200 1705276800 HUMAN-DATE
S" Tomorrow" ASSERT-EQUAL-STR

S" human_date: last Sunday (1 day before Monday)" TEST-START
1705190400 1705276800 HUMAN-DATE
S" Yesterday" ASSERT-EQUAL-STR

S" human_date: last Saturday (2 days ago)" TEST-START
1705104000 1705276800 HUMAN-DATE
S" Last Saturday" ASSERT-EQUAL-STR

S" human_date: last Friday (3 days ago)" TEST-START
1705017600 1705276800 HUMAN-DATE
S" Last Friday" ASSERT-EQUAL-STR

S" human_date: last Thursday (4 days ago)" TEST-START
1704931200 1705276800 HUMAN-DATE
S" Last Thursday" ASSERT-EQUAL-STR

S" human_date: last Wednesday (5 days ago)" TEST-START
1704844800 1705276800 HUMAN-DATE
S" Last Wednesday" ASSERT-EQUAL-STR

S" human_date: last Tuesday (6 days ago)" TEST-START
1704758400 1705276800 HUMAN-DATE
S" Last Tuesday" ASSERT-EQUAL-STR

S" human_date: last Monday (7 days ago) - becomes date" TEST-START
1704672000 1705276800 HUMAN-DATE
S" January 8" ASSERT-EQUAL-STR

S" human_date: this Tuesday (1 day future)" TEST-START
1705363200 1705276800 HUMAN-DATE
S" Tomorrow" ASSERT-EQUAL-STR

S" human_date: this Wednesday (2 days future)" TEST-START
1705449600 1705276800 HUMAN-DATE
S" This Wednesday" ASSERT-EQUAL-STR

S" human_date: this Thursday (3 days future)" TEST-START
1705536000 1705276800 HUMAN-DATE
S" This Thursday" ASSERT-EQUAL-STR

S" human_date: this Sunday (6 days future)" TEST-START
1705795200 1705276800 HUMAN-DATE
S" This Sunday" ASSERT-EQUAL-STR

S" human_date: next Monday (7 days future) - becomes date" TEST-START
1705881600 1705276800 HUMAN-DATE
S" January 22" ASSERT-EQUAL-STR

S" human_date: same year different month" TEST-START
1709251200 1705276800 HUMAN-DATE
S" March 1" ASSERT-EQUAL-STR

S" human_date: same year end of year" TEST-START
1735603200 1705276800 HUMAN-DATE
S" December 31" ASSERT-EQUAL-STR

S" human_date: previous year" TEST-START
1672531200 1705276800 HUMAN-DATE
S" January 1, 2023" ASSERT-EQUAL-STR

S" human_date: next year" TEST-START
1736121600 1705276800 HUMAN-DATE
S" January 6, 2025" ASSERT-EQUAL-STR

S" date_range: same day" TEST-START
1705276800 1705276800 DATE-RANGE
S" January 15, 2024" ASSERT-EQUAL-STR

S" date_range: same day different times" TEST-START
1705276800 1705320000 DATE-RANGE
S" January 15, 2024" ASSERT-EQUAL-STR

S" date_range: consecutive days same month" TEST-START
1705276800 1705363200 DATE-RANGE
S" January 15–16, 2024" ASSERT-EQUAL-STR

S" date_range: same month range" TEST-START
1705276800 1705881600 DATE-RANGE
S" January 15–22, 2024" ASSERT-EQUAL-STR

S" date_range: same year different months" TEST-START
1705276800 1707955200 DATE-RANGE
S" January 15 – February 15, 2024" ASSERT-EQUAL-STR

S" date_range: different years" TEST-START
1703721600 1705276800 DATE-RANGE
S" December 28, 2023 – January 15, 2024" ASSERT-EQUAL-STR

S" date_range: full year span" TEST-START
1704067200 1735603200 DATE-RANGE
S" January 1 – December 31, 2024" ASSERT-EQUAL-STR

S" date_range: swapped inputs - should auto-correct" TEST-START
1705881600 1705276800 DATE-RANGE
S" January 15–22, 2024" ASSERT-EQUAL-STR

S" date_range: multi-year span" TEST-START
1672531200 1735689600 DATE-RANGE
S" January 1, 2023 – January 1, 2025" ASSERT-EQUAL-STR
REPORT-SUMMARY
BYE

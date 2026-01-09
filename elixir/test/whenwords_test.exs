defmodule WhenwordsTest do
  use ExUnit.Case
  doctest Whenwords

  # Reference timestamp for most timeago tests: 1704067200 (2024-01-01 00:00:00 UTC)

  describe "timeago" do
    test "just now - identical timestamps" do
      assert Whenwords.timeago(1704067200, 1704067200) == "just now"
    end

    test "just now - 30 seconds ago" do
      assert Whenwords.timeago(1704067170, 1704067200) == "just now"
    end

    test "just now - 44 seconds ago" do
      assert Whenwords.timeago(1704067156, 1704067200) == "just now"
    end

    test "1 minute ago - 45 seconds" do
      assert Whenwords.timeago(1704067155, 1704067200) == "1 minute ago"
    end

    test "1 minute ago - 89 seconds" do
      assert Whenwords.timeago(1704067111, 1704067200) == "1 minute ago"
    end

    test "2 minutes ago - 90 seconds" do
      assert Whenwords.timeago(1704067110, 1704067200) == "2 minutes ago"
    end

    test "30 minutes ago" do
      assert Whenwords.timeago(1704065400, 1704067200) == "30 minutes ago"
    end

    test "44 minutes ago" do
      assert Whenwords.timeago(1704064560, 1704067200) == "44 minutes ago"
    end

    test "1 hour ago - 45 minutes" do
      assert Whenwords.timeago(1704064500, 1704067200) == "1 hour ago"
    end

    test "1 hour ago - 89 minutes" do
      assert Whenwords.timeago(1704061860, 1704067200) == "1 hour ago"
    end

    test "2 hours ago - 90 minutes" do
      assert Whenwords.timeago(1704061800, 1704067200) == "2 hours ago"
    end

    test "5 hours ago" do
      assert Whenwords.timeago(1704049200, 1704067200) == "5 hours ago"
    end

    test "21 hours ago" do
      assert Whenwords.timeago(1703991600, 1704067200) == "21 hours ago"
    end

    test "1 day ago - 22 hours" do
      assert Whenwords.timeago(1703988000, 1704067200) == "1 day ago"
    end

    test "1 day ago - 35 hours" do
      assert Whenwords.timeago(1703941200, 1704067200) == "1 day ago"
    end

    test "2 days ago - 36 hours" do
      assert Whenwords.timeago(1703937600, 1704067200) == "2 days ago"
    end

    test "7 days ago" do
      assert Whenwords.timeago(1703462400, 1704067200) == "7 days ago"
    end

    test "25 days ago" do
      assert Whenwords.timeago(1701907200, 1704067200) == "25 days ago"
    end

    test "1 month ago - 26 days" do
      assert Whenwords.timeago(1701820800, 1704067200) == "1 month ago"
    end

    test "1 month ago - 45 days" do
      assert Whenwords.timeago(1700179200, 1704067200) == "1 month ago"
    end

    test "2 months ago - 46 days" do
      assert Whenwords.timeago(1700092800, 1704067200) == "2 months ago"
    end

    test "6 months ago" do
      assert Whenwords.timeago(1688169600, 1704067200) == "6 months ago"
    end

    test "10 months ago - 319 days" do
      assert Whenwords.timeago(1676505600, 1704067200) == "10 months ago"
    end

    test "1 year ago - 320 days" do
      assert Whenwords.timeago(1676419200, 1704067200) == "1 year ago"
    end

    test "1 year ago - 547 days" do
      assert Whenwords.timeago(1656806400, 1704067200) == "1 year ago"
    end

    test "2 years ago - 548 days" do
      assert Whenwords.timeago(1656720000, 1704067200) == "2 years ago"
    end

    test "5 years ago" do
      assert Whenwords.timeago(1546300800, 1704067200) == "5 years ago"
    end

    test "future - in just now (30 seconds)" do
      assert Whenwords.timeago(1704067230, 1704067200) == "just now"
    end

    test "future - in 1 minute" do
      assert Whenwords.timeago(1704067260, 1704067200) == "in 1 minute"
    end

    test "future - in 5 minutes" do
      assert Whenwords.timeago(1704067500, 1704067200) == "in 5 minutes"
    end

    test "future - in 1 hour" do
      assert Whenwords.timeago(1704070200, 1704067200) == "in 1 hour"
    end

    test "future - in 3 hours" do
      assert Whenwords.timeago(1704078000, 1704067200) == "in 3 hours"
    end

    test "future - in 1 day" do
      assert Whenwords.timeago(1704150000, 1704067200) == "in 1 day"
    end

    test "future - in 2 days" do
      assert Whenwords.timeago(1704240000, 1704067200) == "in 2 days"
    end

    test "future - in 1 month" do
      assert Whenwords.timeago(1706745600, 1704067200) == "in 1 month"
    end

    test "future - in 1 year" do
      assert Whenwords.timeago(1735689600, 1704067200) == "in 1 year"
    end
  end

  describe "duration" do
    test "zero seconds" do
      assert Whenwords.duration(0) == "0 seconds"
    end

    test "1 second" do
      assert Whenwords.duration(1) == "1 second"
    end

    test "45 seconds" do
      assert Whenwords.duration(45) == "45 seconds"
    end

    test "1 minute" do
      assert Whenwords.duration(60) == "1 minute"
    end

    test "1 minute 30 seconds" do
      assert Whenwords.duration(90) == "1 minute, 30 seconds"
    end

    test "2 minutes" do
      assert Whenwords.duration(120) == "2 minutes"
    end

    test "1 hour" do
      assert Whenwords.duration(3600) == "1 hour"
    end

    test "1 hour 1 minute" do
      assert Whenwords.duration(3661) == "1 hour, 1 minute"
    end

    test "1 hour 30 minutes" do
      assert Whenwords.duration(5400) == "1 hour, 30 minutes"
    end

    test "2 hours 30 minutes" do
      assert Whenwords.duration(9000) == "2 hours, 30 minutes"
    end

    test "1 day" do
      assert Whenwords.duration(86400) == "1 day"
    end

    test "1 day 2 hours" do
      assert Whenwords.duration(93600) == "1 day, 2 hours"
    end

    test "7 days" do
      assert Whenwords.duration(604800) == "7 days"
    end

    test "1 month (30 days)" do
      assert Whenwords.duration(2592000) == "1 month"
    end

    test "1 year (365 days)" do
      assert Whenwords.duration(31536000) == "1 year"
    end

    test "1 year 2 months" do
      assert Whenwords.duration(36720000) == "1 year, 2 months"
    end

    test "compact - 1h 1m" do
      assert Whenwords.duration(3661, %{compact: true}) == "1h 1m"
    end

    test "compact - 2h 30m" do
      assert Whenwords.duration(9000, %{compact: true}) == "2h 30m"
    end

    test "compact - 1d 2h" do
      assert Whenwords.duration(93600, %{compact: true}) == "1d 2h"
    end

    test "compact - 45s" do
      assert Whenwords.duration(45, %{compact: true}) == "45s"
    end

    test "compact - 0s" do
      assert Whenwords.duration(0, %{compact: true}) == "0s"
    end

    test "max_units 1 - hours only" do
      assert Whenwords.duration(3661, %{max_units: 1}) == "1 hour"
    end

    test "max_units 1 - days only" do
      assert Whenwords.duration(93600, %{max_units: 1}) == "1 day"
    end

    test "max_units 3" do
      assert Whenwords.duration(93661, %{max_units: 3}) == "1 day, 2 hours, 1 minute"
    end

    test "compact max_units 1" do
      assert Whenwords.duration(9000, %{compact: true, max_units: 1}) == "2h"
    end

    test "error - negative seconds" do
      assert_raise ArgumentError, fn -> Whenwords.duration(-100) end
    end
  end

  describe "parse_duration" do
    test "compact hours minutes" do
      assert Whenwords.parse_duration("2h30m") == 9000
    end

    test "compact with space" do
      assert Whenwords.parse_duration("2h 30m") == 9000
    end

    test "compact with comma" do
      assert Whenwords.parse_duration("2h, 30m") == 9000
    end

    test "verbose" do
      assert Whenwords.parse_duration("2 hours 30 minutes") == 9000
    end

    test "verbose with and" do
      assert Whenwords.parse_duration("2 hours and 30 minutes") == 9000
    end

    test "verbose with comma and" do
      assert Whenwords.parse_duration("2 hours, and 30 minutes") == 9000
    end

    test "decimal hours" do
      assert Whenwords.parse_duration("2.5 hours") == 9000
    end

    test "decimal compact" do
      assert Whenwords.parse_duration("1.5h") == 5400
    end

    test "single unit minutes verbose" do
      assert Whenwords.parse_duration("90 minutes") == 5400
    end

    test "single unit minutes compact" do
      assert Whenwords.parse_duration("90m") == 5400
    end

    test "single unit min" do
      assert Whenwords.parse_duration("90min") == 5400
    end

    test "colon notation h:mm" do
      assert Whenwords.parse_duration("2:30") == 9000
    end

    test "colon notation h:mm:ss" do
      assert Whenwords.parse_duration("1:30:00") == 5400
    end

    test "colon notation with seconds" do
      assert Whenwords.parse_duration("0:05:30") == 330
    end

    test "days verbose" do
      assert Whenwords.parse_duration("2 days") == 172800
    end

    test "days compact" do
      assert Whenwords.parse_duration("2d") == 172800
    end

    test "weeks verbose" do
      assert Whenwords.parse_duration("1 week") == 604800
    end

    test "weeks compact" do
      assert Whenwords.parse_duration("1w") == 604800
    end

    test "mixed verbose" do
      assert Whenwords.parse_duration("1 day, 2 hours, and 30 minutes") == 95400
    end

    test "mixed compact" do
      assert Whenwords.parse_duration("1d 2h 30m") == 95400
    end

    test "seconds only verbose" do
      assert Whenwords.parse_duration("45 seconds") == 45
    end

    test "seconds compact s" do
      assert Whenwords.parse_duration("45s") == 45
    end

    test "seconds compact sec" do
      assert Whenwords.parse_duration("45sec") == 45
    end

    test "hours hr" do
      assert Whenwords.parse_duration("2hr") == 7200
    end

    test "hours hrs" do
      assert Whenwords.parse_duration("2hrs") == 7200
    end

    test "minutes mins" do
      assert Whenwords.parse_duration("30mins") == 1800
    end

    test "case insensitive" do
      assert Whenwords.parse_duration("2H 30M") == 9000
    end

    test "whitespace tolerance" do
      assert Whenwords.parse_duration("  2 hours   30 minutes  ") == 9000
    end

    test "error - empty string" do
      assert_raise ArgumentError, fn -> Whenwords.parse_duration("") end
    end

    test "error - no units" do
      assert_raise ArgumentError, fn -> Whenwords.parse_duration("hello world") end
    end

    test "error - negative" do
      assert_raise ArgumentError, fn -> Whenwords.parse_duration("-5 hours") end
    end

    test "error - just number" do
      assert_raise ArgumentError, fn -> Whenwords.parse_duration("42") end
    end
  end

  describe "human_date" do
    # Reference: 2024-01-15 00:00:00 UTC (Monday)
    # timestamp 1705276800

    test "today" do
      assert Whenwords.human_date(1705276800, 1705276800) == "Today"
    end

    test "today - same day different time" do
      assert Whenwords.human_date(1705320000, 1705276800) == "Today"
    end

    test "yesterday" do
      assert Whenwords.human_date(1705190400, 1705276800) == "Yesterday"
    end

    test "tomorrow" do
      assert Whenwords.human_date(1705363200, 1705276800) == "Tomorrow"
    end

    test "last Sunday (1 day before Monday)" do
      assert Whenwords.human_date(1705190400, 1705276800) == "Yesterday"
    end

    test "last Saturday (2 days ago)" do
      assert Whenwords.human_date(1705104000, 1705276800) == "Last Saturday"
    end

    test "last Friday (3 days ago)" do
      assert Whenwords.human_date(1705017600, 1705276800) == "Last Friday"
    end

    test "last Thursday (4 days ago)" do
      assert Whenwords.human_date(1704931200, 1705276800) == "Last Thursday"
    end

    test "last Wednesday (5 days ago)" do
      assert Whenwords.human_date(1704844800, 1705276800) == "Last Wednesday"
    end

    test "last Tuesday (6 days ago)" do
      assert Whenwords.human_date(1704758400, 1705276800) == "Last Tuesday"
    end

    test "last Monday (7 days ago) - becomes date" do
      assert Whenwords.human_date(1704672000, 1705276800) == "January 8"
    end

    test "this Tuesday (1 day future)" do
      assert Whenwords.human_date(1705363200, 1705276800) == "Tomorrow"
    end

    test "this Wednesday (2 days future)" do
      assert Whenwords.human_date(1705449600, 1705276800) == "This Wednesday"
    end

    test "this Thursday (3 days future)" do
      assert Whenwords.human_date(1705536000, 1705276800) == "This Thursday"
    end

    test "this Sunday (6 days future)" do
      assert Whenwords.human_date(1705795200, 1705276800) == "This Sunday"
    end

    test "next Monday (7 days future) - becomes date" do
      assert Whenwords.human_date(1705881600, 1705276800) == "January 22"
    end

    test "same year different month" do
      assert Whenwords.human_date(1709251200, 1705276800) == "March 1"
    end

    test "same year end of year" do
      assert Whenwords.human_date(1735603200, 1705276800) == "December 31"
    end

    test "previous year" do
      assert Whenwords.human_date(1672531200, 1705276800) == "January 1, 2023"
    end

    test "next year" do
      assert Whenwords.human_date(1736121600, 1705276800) == "January 6, 2025"
    end
  end

  describe "date_range" do
    test "same day" do
      assert Whenwords.date_range(1705276800, 1705276800) == "January 15, 2024"
    end

    test "same day different times" do
      assert Whenwords.date_range(1705276800, 1705320000) == "January 15, 2024"
    end

    test "consecutive days same month" do
      assert Whenwords.date_range(1705276800, 1705363200) == "January 15–16, 2024"
    end

    test "same month range" do
      assert Whenwords.date_range(1705276800, 1705881600) == "January 15–22, 2024"
    end

    test "same year different months" do
      assert Whenwords.date_range(1705276800, 1707955200) == "January 15 – February 15, 2024"
    end

    test "different years" do
      assert Whenwords.date_range(1703721600, 1705276800) == "December 28, 2023 – January 15, 2024"
    end

    test "full year span" do
      assert Whenwords.date_range(1704067200, 1735603200) == "January 1 – December 31, 2024"
    end

    test "swapped inputs - should auto-correct" do
      assert Whenwords.date_range(1705881600, 1705276800) == "January 15–22, 2024"
    end

    test "multi-year span" do
      assert Whenwords.date_range(1672531200, 1735689600) == "January 1, 2023 – January 1, 2025"
    end
  end
end

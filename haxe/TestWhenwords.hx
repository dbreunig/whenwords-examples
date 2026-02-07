import utest.Test;
import utest.Assert;
import Whenwords;

class TestWhenwords extends Test {
    
    // TIMEAGO TESTS
    
    function testTimeago_justNow_identicalTimestamps() {
        Assert.equals("just now", Whenwords.timeago(1704067200, 1704067200));
    }
    
    function testTimeago_justNow_30SecondsAgo() {
        Assert.equals("just now", Whenwords.timeago(1704067170, 1704067200));
    }
    
    function testTimeago_justNow_44SecondsAgo() {
        Assert.equals("just now", Whenwords.timeago(1704067156, 1704067200));
    }
    
    function testTimeago_1MinuteAgo_45Seconds() {
        Assert.equals("1 minute ago", Whenwords.timeago(1704067155, 1704067200));
    }
    
    function testTimeago_1MinuteAgo_89Seconds() {
        Assert.equals("1 minute ago", Whenwords.timeago(1704067111, 1704067200));
    }
    
    function testTimeago_2MinutesAgo_90Seconds() {
        Assert.equals("2 minutes ago", Whenwords.timeago(1704067110, 1704067200));
    }
    
    function testTimeago_30MinutesAgo() {
        Assert.equals("30 minutes ago", Whenwords.timeago(1704065400, 1704067200));
    }
    
    function testTimeago_44MinutesAgo() {
        Assert.equals("44 minutes ago", Whenwords.timeago(1704064560, 1704067200));
    }
    
    function testTimeago_1HourAgo_45Minutes() {
        Assert.equals("1 hour ago", Whenwords.timeago(1704064500, 1704067200));
    }
    
    function testTimeago_1HourAgo_89Minutes() {
        Assert.equals("1 hour ago", Whenwords.timeago(1704061860, 1704067200));
    }
    
    function testTimeago_2HoursAgo_90Minutes() {
        Assert.equals("2 hours ago", Whenwords.timeago(1704061800, 1704067200));
    }
    
    function testTimeago_5HoursAgo() {
        Assert.equals("5 hours ago", Whenwords.timeago(1704049200, 1704067200));
    }
    
    function testTimeago_21HoursAgo() {
        Assert.equals("21 hours ago", Whenwords.timeago(1703991600, 1704067200));
    }
    
    function testTimeago_1DayAgo_22Hours() {
        Assert.equals("1 day ago", Whenwords.timeago(1703988000, 1704067200));
    }
    
    function testTimeago_1DayAgo_35Hours() {
        Assert.equals("1 day ago", Whenwords.timeago(1703941200, 1704067200));
    }
    
    function testTimeago_2DaysAgo_36Hours() {
        Assert.equals("2 days ago", Whenwords.timeago(1703937600, 1704067200));
    }
    
    function testTimeago_7DaysAgo() {
        Assert.equals("7 days ago", Whenwords.timeago(1703462400, 1704067200));
    }
    
    function testTimeago_25DaysAgo() {
        Assert.equals("25 days ago", Whenwords.timeago(1701907200, 1704067200));
    }
    
    function testTimeago_1MonthAgo_26Days() {
        Assert.equals("1 month ago", Whenwords.timeago(1701820800, 1704067200));
    }
    
    function testTimeago_1MonthAgo_45Days() {
        Assert.equals("1 month ago", Whenwords.timeago(1700179200, 1704067200));
    }
    
    function testTimeago_2MonthsAgo_46Days() {
        Assert.equals("2 months ago", Whenwords.timeago(1700092800, 1704067200));
    }
    
    function testTimeago_6MonthsAgo() {
        Assert.equals("6 months ago", Whenwords.timeago(1688169600, 1704067200));
    }
    
    function testTimeago_11MonthsAgo_319Days() {
        Assert.equals("11 months ago", Whenwords.timeago(1676505600, 1704067200));
    }
    
    function testTimeago_1YearAgo_320Days() {
        Assert.equals("1 year ago", Whenwords.timeago(1676419200, 1704067200));
    }
    
    function testTimeago_1YearAgo_547Days() {
        Assert.equals("1 year ago", Whenwords.timeago(1656806400, 1704067200));
    }
    
    function testTimeago_2YearsAgo_548Days() {
        Assert.equals("2 years ago", Whenwords.timeago(1656720000, 1704067200));
    }
    
    function testTimeago_5YearsAgo() {
        Assert.equals("5 years ago", Whenwords.timeago(1546300800, 1704067200));
    }
    
    function testTimeago_future_inJustNow_30Seconds() {
        Assert.equals("just now", Whenwords.timeago(1704067230, 1704067200));
    }
    
    function testTimeago_future_in1Minute() {
        Assert.equals("in 1 minute", Whenwords.timeago(1704067260, 1704067200));
    }
    
    function testTimeago_future_in5Minutes() {
        Assert.equals("in 5 minutes", Whenwords.timeago(1704067500, 1704067200));
    }
    
    function testTimeago_future_in1Hour() {
        Assert.equals("in 1 hour", Whenwords.timeago(1704070200, 1704067200));
    }
    
    function testTimeago_future_in3Hours() {
        Assert.equals("in 3 hours", Whenwords.timeago(1704078000, 1704067200));
    }
    
    function testTimeago_future_in1Day() {
        Assert.equals("in 1 day", Whenwords.timeago(1704150000, 1704067200));
    }
    
    function testTimeago_future_in2Days() {
        Assert.equals("in 2 days", Whenwords.timeago(1704240000, 1704067200));
    }
    
    function testTimeago_future_in1Month() {
        Assert.equals("in 1 month", Whenwords.timeago(1706745600, 1704067200));
    }
    
    function testTimeago_future_in1Year() {
        Assert.equals("in 1 year", Whenwords.timeago(1735689600, 1704067200));
    }
    
    // DURATION TESTS
    
    function testDuration_zeroSeconds() {
        Assert.equals("0 seconds", Whenwords.duration(0));
    }
    
    function testDuration_1Second() {
        Assert.equals("1 second", Whenwords.duration(1));
    }
    
    function testDuration_45Seconds() {
        Assert.equals("45 seconds", Whenwords.duration(45));
    }
    
    function testDuration_1Minute() {
        Assert.equals("1 minute", Whenwords.duration(60));
    }
    
    function testDuration_1Minute30Seconds() {
        Assert.equals("1 minute, 30 seconds", Whenwords.duration(90));
    }
    
    function testDuration_2Minutes() {
        Assert.equals("2 minutes", Whenwords.duration(120));
    }
    
    function testDuration_1Hour() {
        Assert.equals("1 hour", Whenwords.duration(3600));
    }
    
    function testDuration_1Hour1Minute() {
        Assert.equals("1 hour, 1 minute", Whenwords.duration(3661));
    }
    
    function testDuration_1Hour30Minutes() {
        Assert.equals("1 hour, 30 minutes", Whenwords.duration(5400));
    }
    
    function testDuration_2Hours30Minutes() {
        Assert.equals("2 hours, 30 minutes", Whenwords.duration(9000));
    }
    
    function testDuration_1Day() {
        Assert.equals("1 day", Whenwords.duration(86400));
    }
    
    function testDuration_1Day2Hours() {
        Assert.equals("1 day, 2 hours", Whenwords.duration(93600));
    }
    
    function testDuration_7Days() {
        Assert.equals("7 days", Whenwords.duration(604800));
    }
    
    function testDuration_1Month_30Days() {
        Assert.equals("1 month", Whenwords.duration(2592000));
    }
    
    function testDuration_1Year_365Days() {
        Assert.equals("1 year", Whenwords.duration(31536000));
    }
    
    function testDuration_1Year2Months() {
        Assert.equals("1 year, 2 months", Whenwords.duration(36720000));
    }
    
    function testDuration_compact_1h1m() {
        Assert.equals("1h 1m", Whenwords.duration(3661, {compact: true}));
    }
    
    function testDuration_compact_2h30m() {
        Assert.equals("2h 30m", Whenwords.duration(9000, {compact: true}));
    }
    
    function testDuration_compact_1d2h() {
        Assert.equals("1d 2h", Whenwords.duration(93600, {compact: true}));
    }
    
    function testDuration_compact_45s() {
        Assert.equals("45s", Whenwords.duration(45, {compact: true}));
    }
    
    function testDuration_compact_0s() {
        Assert.equals("0s", Whenwords.duration(0, {compact: true}));
    }
    
    function testDuration_maxUnits1_hoursOnly() {
        Assert.equals("1 hour", Whenwords.duration(3661, {maxUnits: 1}));
    }
    
    function testDuration_maxUnits1_daysOnly() {
        Assert.equals("1 day", Whenwords.duration(93600, {maxUnits: 1}));
    }
    
    function testDuration_maxUnits3() {
        Assert.equals("1 day, 2 hours, 1 minute", Whenwords.duration(93661, {maxUnits: 3}));
    }
    
    function testDuration_compactMaxUnits1() {
        Assert.equals("3h", Whenwords.duration(9000, {compact: true, maxUnits: 1}));
    }
    
    function testDuration_error_negativeSeconds() {
        Assert.raises(function() {
            Whenwords.duration(-100);
        });
    }
    
    // PARSE_DURATION TESTS
    
    function testParseDuration_compactHoursMinutes() {
        Assert.equals(9000, Whenwords.parseDuration("2h30m"));
    }
    
    function testParseDuration_compactWithSpace() {
        Assert.equals(9000, Whenwords.parseDuration("2h 30m"));
    }
    
    function testParseDuration_compactWithComma() {
        Assert.equals(9000, Whenwords.parseDuration("2h, 30m"));
    }
    
    function testParseDuration_verbose() {
        Assert.equals(9000, Whenwords.parseDuration("2 hours 30 minutes"));
    }
    
    function testParseDuration_verboseWithAnd() {
        Assert.equals(9000, Whenwords.parseDuration("2 hours and 30 minutes"));
    }
    
    function testParseDuration_verboseWithCommaAnd() {
        Assert.equals(9000, Whenwords.parseDuration("2 hours, and 30 minutes"));
    }
    
    function testParseDuration_decimalHours() {
        Assert.equals(9000, Whenwords.parseDuration("2.5 hours"));
    }
    
    function testParseDuration_decimalCompact() {
        Assert.equals(5400, Whenwords.parseDuration("1.5h"));
    }
    
    function testParseDuration_singleUnitMinutesVerbose() {
        Assert.equals(5400, Whenwords.parseDuration("90 minutes"));
    }
    
    function testParseDuration_singleUnitMinutesCompact() {
        Assert.equals(5400, Whenwords.parseDuration("90m"));
    }
    
    function testParseDuration_singleUnitMin() {
        Assert.equals(5400, Whenwords.parseDuration("90min"));
    }
    
    function testParseDuration_colonNotation_hMm() {
        Assert.equals(9000, Whenwords.parseDuration("2:30"));
    }
    
    function testParseDuration_colonNotation_hMmSs() {
        Assert.equals(5400, Whenwords.parseDuration("1:30:00"));
    }
    
    function testParseDuration_colonNotationWithSeconds() {
        Assert.equals(330, Whenwords.parseDuration("0:05:30"));
    }
    
    function testParseDuration_daysVerbose() {
        Assert.equals(172800, Whenwords.parseDuration("2 days"));
    }
    
    function testParseDuration_daysCompact() {
        Assert.equals(172800, Whenwords.parseDuration("2d"));
    }
    
    function testParseDuration_weeksVerbose() {
        Assert.equals(604800, Whenwords.parseDuration("1 week"));
    }
    
    function testParseDuration_weeksCompact() {
        Assert.equals(604800, Whenwords.parseDuration("1w"));
    }
    
    function testParseDuration_mixedVerbose() {
        Assert.equals(95400, Whenwords.parseDuration("1 day, 2 hours, and 30 minutes"));
    }
    
    function testParseDuration_mixedCompact() {
        Assert.equals(95400, Whenwords.parseDuration("1d 2h 30m"));
    }
    
    function testParseDuration_secondsOnlyVerbose() {
        Assert.equals(45, Whenwords.parseDuration("45 seconds"));
    }
    
    function testParseDuration_secondsCompactS() {
        Assert.equals(45, Whenwords.parseDuration("45s"));
    }
    
    function testParseDuration_secondsCompactSec() {
        Assert.equals(45, Whenwords.parseDuration("45sec"));
    }
    
    function testParseDuration_hoursHr() {
        Assert.equals(7200, Whenwords.parseDuration("2hr"));
    }
    
    function testParseDuration_hoursHrs() {
        Assert.equals(7200, Whenwords.parseDuration("2hrs"));
    }
    
    function testParseDuration_minutesMins() {
        Assert.equals(1800, Whenwords.parseDuration("30mins"));
    }
    
    function testParseDuration_caseInsensitive() {
        Assert.equals(9000, Whenwords.parseDuration("2H 30M"));
    }
    
    function testParseDuration_whitespaceTolerance() {
        Assert.equals(9000, Whenwords.parseDuration("  2 hours   30 minutes  "));
    }
    
    function testParseDuration_error_emptyString() {
        Assert.raises(function() {
            Whenwords.parseDuration("");
        });
    }
    
    function testParseDuration_error_noUnits() {
        Assert.raises(function() {
            Whenwords.parseDuration("hello world");
        });
    }
    
    function testParseDuration_error_negative() {
        Assert.raises(function() {
            Whenwords.parseDuration("-5 hours");
        });
    }
    
    function testParseDuration_error_justNumber() {
        Assert.raises(function() {
            Whenwords.parseDuration("42");
        });
    }
    
    // HUMAN_DATE TESTS
    
    function testHumanDate_today() {
        Assert.equals("Today", Whenwords.humanDate(1705276800, 1705276800));
    }
    
    function testHumanDate_today_sameDayDifferentTime() {
        Assert.equals("Today", Whenwords.humanDate(1705320000, 1705276800));
    }
    
    function testHumanDate_yesterday() {
        Assert.equals("Yesterday", Whenwords.humanDate(1705190400, 1705276800));
    }
    
    function testHumanDate_tomorrow() {
        Assert.equals("Tomorrow", Whenwords.humanDate(1705363200, 1705276800));
    }
    
    function testHumanDate_lastSunday_1DayBeforeMonday() {
        Assert.equals("Yesterday", Whenwords.humanDate(1705190400, 1705276800));
    }
    
    function testHumanDate_lastSaturday_2DaysAgo() {
        Assert.equals("Last Saturday", Whenwords.humanDate(1705104000, 1705276800));
    }
    
    function testHumanDate_lastFriday_3DaysAgo() {
        Assert.equals("Last Friday", Whenwords.humanDate(1705017600, 1705276800));
    }
    
    function testHumanDate_lastThursday_4DaysAgo() {
        Assert.equals("Last Thursday", Whenwords.humanDate(1704931200, 1705276800));
    }
    
    function testHumanDate_lastWednesday_5DaysAgo() {
        Assert.equals("Last Wednesday", Whenwords.humanDate(1704844800, 1705276800));
    }
    
    function testHumanDate_lastTuesday_6DaysAgo() {
        Assert.equals("Last Tuesday", Whenwords.humanDate(1704758400, 1705276800));
    }
    
    function testHumanDate_lastMonday_7DaysAgo_becomesDate() {
        Assert.equals("January 8", Whenwords.humanDate(1704672000, 1705276800));
    }
    
    function testHumanDate_thisTuesday_1DayFuture() {
        Assert.equals("Tomorrow", Whenwords.humanDate(1705363200, 1705276800));
    }
    
    function testHumanDate_thisWednesday_2DaysFuture() {
        Assert.equals("This Wednesday", Whenwords.humanDate(1705449600, 1705276800));
    }
    
    function testHumanDate_thisThursday_3DaysFuture() {
        Assert.equals("This Thursday", Whenwords.humanDate(1705536000, 1705276800));
    }
    
    function testHumanDate_thisSunday_6DaysFuture() {
        Assert.equals("This Sunday", Whenwords.humanDate(1705795200, 1705276800));
    }
    
    function testHumanDate_nextMonday_7DaysFuture_becomesDate() {
        Assert.equals("January 22", Whenwords.humanDate(1705881600, 1705276800));
    }
    
    function testHumanDate_sameYearDifferentMonth() {
        Assert.equals("March 1", Whenwords.humanDate(1709251200, 1705276800));
    }
    
    function testHumanDate_sameYearEndOfYear() {
        Assert.equals("December 31", Whenwords.humanDate(1735603200, 1705276800));
    }
    
    function testHumanDate_previousYear() {
        Assert.equals("January 1, 2023", Whenwords.humanDate(1672531200, 1705276800));
    }
    
    function testHumanDate_nextYear() {
        Assert.equals("January 6, 2025", Whenwords.humanDate(1736121600, 1705276800));
    }
    
    // DATE_RANGE TESTS
    
    function testDateRange_sameDay() {
        Assert.equals("January 15, 2024", Whenwords.dateRange(1705276800, 1705276800));
    }
    
    function testDateRange_sameDayDifferentTimes() {
        Assert.equals("January 15, 2024", Whenwords.dateRange(1705276800, 1705320000));
    }
    
    function testDateRange_consecutiveDaysSameMonth() {
        Assert.equals("January 15–16, 2024", Whenwords.dateRange(1705276800, 1705363200));
    }
    
    function testDateRange_sameMonthRange() {
        Assert.equals("January 15–22, 2024", Whenwords.dateRange(1705276800, 1705881600));
    }
    
    function testDateRange_sameYearDifferentMonths() {
        Assert.equals("January 15 – February 15, 2024", Whenwords.dateRange(1705276800, 1707955200));
    }
    
    function testDateRange_differentYears() {
        Assert.equals("December 28, 2023 – January 15, 2024", Whenwords.dateRange(1703721600, 1705276800));
    }
    
    function testDateRange_fullYearSpan() {
        Assert.equals("January 1 – December 31, 2024", Whenwords.dateRange(1704067200, 1735603200));
    }
    
    function testDateRange_swappedInputs_shouldAutoCorrect() {
        Assert.equals("January 15–22, 2024", Whenwords.dateRange(1705881600, 1705276800));
    }
    
    function testDateRange_multiYearSpan() {
        Assert.equals("January 1, 2023 – January 1, 2025", Whenwords.dateRange(1672531200, 1735689600));
    }
}

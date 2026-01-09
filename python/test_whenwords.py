"""
Tests for whenwords library - generated from tests.yaml
"""

import pytest
from whenwords import timeago, duration, parse_duration, human_date, date_range


# ============================================================================
# timeago tests
# ============================================================================

def test_timeago_just_now_identical_timestamps():
    result = timeago(1704067200, reference=1704067200)
    assert result == "just now"


def test_timeago_just_now_30_seconds_ago():
    result = timeago(1704067170, reference=1704067200)
    assert result == "just now"


def test_timeago_just_now_44_seconds_ago():
    result = timeago(1704067156, reference=1704067200)
    assert result == "just now"


def test_timeago_1_minute_ago_45_seconds():
    result = timeago(1704067155, reference=1704067200)
    assert result == "1 minute ago"


def test_timeago_1_minute_ago_89_seconds():
    result = timeago(1704067111, reference=1704067200)
    assert result == "1 minute ago"


def test_timeago_2_minutes_ago_90_seconds():
    result = timeago(1704067110, reference=1704067200)
    assert result == "2 minutes ago"


def test_timeago_30_minutes_ago():
    result = timeago(1704065400, reference=1704067200)
    assert result == "30 minutes ago"


def test_timeago_44_minutes_ago():
    result = timeago(1704064560, reference=1704067200)
    assert result == "44 minutes ago"


def test_timeago_1_hour_ago_45_minutes():
    result = timeago(1704064500, reference=1704067200)
    assert result == "1 hour ago"


def test_timeago_1_hour_ago_89_minutes():
    result = timeago(1704061860, reference=1704067200)
    assert result == "1 hour ago"


def test_timeago_2_hours_ago_90_minutes():
    result = timeago(1704061800, reference=1704067200)
    assert result == "2 hours ago"


def test_timeago_5_hours_ago():
    result = timeago(1704049200, reference=1704067200)
    assert result == "5 hours ago"


def test_timeago_21_hours_ago():
    result = timeago(1703991600, reference=1704067200)
    assert result == "21 hours ago"


def test_timeago_1_day_ago_22_hours():
    result = timeago(1703988000, reference=1704067200)
    assert result == "1 day ago"


def test_timeago_1_day_ago_35_hours():
    result = timeago(1703941200, reference=1704067200)
    assert result == "1 day ago"


def test_timeago_2_days_ago_36_hours():
    result = timeago(1703937600, reference=1704067200)
    assert result == "2 days ago"


def test_timeago_7_days_ago():
    result = timeago(1703462400, reference=1704067200)
    assert result == "7 days ago"


def test_timeago_25_days_ago():
    result = timeago(1701907200, reference=1704067200)
    assert result == "25 days ago"


def test_timeago_1_month_ago_26_days():
    result = timeago(1701820800, reference=1704067200)
    assert result == "1 month ago"


def test_timeago_1_month_ago_45_days():
    result = timeago(1700179200, reference=1704067200)
    assert result == "1 month ago"


def test_timeago_2_months_ago_46_days():
    result = timeago(1700092800, reference=1704067200)
    assert result == "2 months ago"


def test_timeago_6_months_ago():
    result = timeago(1688169600, reference=1704067200)
    assert result == "6 months ago"


def test_timeago_10_months_ago_319_days():
    result = timeago(1676505600, reference=1704067200)
    assert result == "10 months ago"


def test_timeago_1_year_ago_320_days():
    result = timeago(1676419200, reference=1704067200)
    assert result == "1 year ago"


def test_timeago_1_year_ago_547_days():
    result = timeago(1656806400, reference=1704067200)
    assert result == "1 year ago"


def test_timeago_2_years_ago_548_days():
    result = timeago(1656720000, reference=1704067200)
    assert result == "2 years ago"


def test_timeago_5_years_ago():
    result = timeago(1546300800, reference=1704067200)
    assert result == "5 years ago"


def test_timeago_future_in_just_now_30_seconds():
    result = timeago(1704067230, reference=1704067200)
    assert result == "just now"


def test_timeago_future_in_1_minute():
    result = timeago(1704067260, reference=1704067200)
    assert result == "in 1 minute"


def test_timeago_future_in_5_minutes():
    result = timeago(1704067500, reference=1704067200)
    assert result == "in 5 minutes"


def test_timeago_future_in_1_hour():
    result = timeago(1704070200, reference=1704067200)
    assert result == "in 1 hour"


def test_timeago_future_in_3_hours():
    result = timeago(1704078000, reference=1704067200)
    assert result == "in 3 hours"


def test_timeago_future_in_1_day():
    result = timeago(1704150000, reference=1704067200)
    assert result == "in 1 day"


def test_timeago_future_in_2_days():
    result = timeago(1704240000, reference=1704067200)
    assert result == "in 2 days"


def test_timeago_future_in_1_month():
    result = timeago(1706745600, reference=1704067200)
    assert result == "in 1 month"


def test_timeago_future_in_1_year():
    result = timeago(1735689600, reference=1704067200)
    assert result == "in 1 year"


# ============================================================================
# duration tests
# ============================================================================

def test_duration_zero_seconds():
    result = duration(0)
    assert result == "0 seconds"


def test_duration_1_second():
    result = duration(1)
    assert result == "1 second"


def test_duration_45_seconds():
    result = duration(45)
    assert result == "45 seconds"


def test_duration_1_minute():
    result = duration(60)
    assert result == "1 minute"


def test_duration_1_minute_30_seconds():
    result = duration(90)
    assert result == "1 minute, 30 seconds"


def test_duration_2_minutes():
    result = duration(120)
    assert result == "2 minutes"


def test_duration_1_hour():
    result = duration(3600)
    assert result == "1 hour"


def test_duration_1_hour_1_minute():
    result = duration(3661)
    assert result == "1 hour, 1 minute"


def test_duration_1_hour_30_minutes():
    result = duration(5400)
    assert result == "1 hour, 30 minutes"


def test_duration_2_hours_30_minutes():
    result = duration(9000)
    assert result == "2 hours, 30 minutes"


def test_duration_1_day():
    result = duration(86400)
    assert result == "1 day"


def test_duration_1_day_2_hours():
    result = duration(93600)
    assert result == "1 day, 2 hours"


def test_duration_7_days():
    result = duration(604800)
    assert result == "7 days"


def test_duration_1_month_30_days():
    result = duration(2592000)
    assert result == "1 month"


def test_duration_1_year_365_days():
    result = duration(31536000)
    assert result == "1 year"


def test_duration_1_year_2_months():
    result = duration(36720000)
    assert result == "1 year, 2 months"


def test_duration_compact_1h_1m():
    result = duration(3661, options={"compact": True})
    assert result == "1h 1m"


def test_duration_compact_2h_30m():
    result = duration(9000, options={"compact": True})
    assert result == "2h 30m"


def test_duration_compact_1d_2h():
    result = duration(93600, options={"compact": True})
    assert result == "1d 2h"


def test_duration_compact_45s():
    result = duration(45, options={"compact": True})
    assert result == "45s"


def test_duration_compact_0s():
    result = duration(0, options={"compact": True})
    assert result == "0s"


def test_duration_max_units_1_hours_only():
    result = duration(3661, options={"max_units": 1})
    assert result == "1 hour"


def test_duration_max_units_1_days_only():
    result = duration(93600, options={"max_units": 1})
    assert result == "1 day"


def test_duration_max_units_3():
    result = duration(93661, options={"max_units": 3})
    assert result == "1 day, 2 hours, 1 minute"


def test_duration_compact_max_units_1():
    result = duration(9000, options={"compact": True, "max_units": 1})
    assert result == "2h"


def test_duration_error_negative_seconds():
    with pytest.raises(ValueError):
        duration(-100)


# ============================================================================
# parse_duration tests
# ============================================================================

def test_parse_duration_compact_hours_minutes():
    result = parse_duration("2h30m")
    assert result == 9000


def test_parse_duration_compact_with_space():
    result = parse_duration("2h 30m")
    assert result == 9000


def test_parse_duration_compact_with_comma():
    result = parse_duration("2h, 30m")
    assert result == 9000


def test_parse_duration_verbose():
    result = parse_duration("2 hours 30 minutes")
    assert result == 9000


def test_parse_duration_verbose_with_and():
    result = parse_duration("2 hours and 30 minutes")
    assert result == 9000


def test_parse_duration_verbose_with_comma_and():
    result = parse_duration("2 hours, and 30 minutes")
    assert result == 9000


def test_parse_duration_decimal_hours():
    result = parse_duration("2.5 hours")
    assert result == 9000


def test_parse_duration_decimal_compact():
    result = parse_duration("1.5h")
    assert result == 5400


def test_parse_duration_single_unit_minutes_verbose():
    result = parse_duration("90 minutes")
    assert result == 5400


def test_parse_duration_single_unit_minutes_compact():
    result = parse_duration("90m")
    assert result == 5400


def test_parse_duration_single_unit_min():
    result = parse_duration("90min")
    assert result == 5400


def test_parse_duration_colon_notation_h_mm():
    result = parse_duration("2:30")
    assert result == 9000


def test_parse_duration_colon_notation_h_mm_ss():
    result = parse_duration("1:30:00")
    assert result == 5400


def test_parse_duration_colon_notation_with_seconds():
    result = parse_duration("0:05:30")
    assert result == 330


def test_parse_duration_days_verbose():
    result = parse_duration("2 days")
    assert result == 172800


def test_parse_duration_days_compact():
    result = parse_duration("2d")
    assert result == 172800


def test_parse_duration_weeks_verbose():
    result = parse_duration("1 week")
    assert result == 604800


def test_parse_duration_weeks_compact():
    result = parse_duration("1w")
    assert result == 604800


def test_parse_duration_mixed_verbose():
    result = parse_duration("1 day, 2 hours, and 30 minutes")
    assert result == 95400


def test_parse_duration_mixed_compact():
    result = parse_duration("1d 2h 30m")
    assert result == 95400


def test_parse_duration_seconds_only_verbose():
    result = parse_duration("45 seconds")
    assert result == 45


def test_parse_duration_seconds_compact_s():
    result = parse_duration("45s")
    assert result == 45


def test_parse_duration_seconds_compact_sec():
    result = parse_duration("45sec")
    assert result == 45


def test_parse_duration_hours_hr():
    result = parse_duration("2hr")
    assert result == 7200


def test_parse_duration_hours_hrs():
    result = parse_duration("2hrs")
    assert result == 7200


def test_parse_duration_minutes_mins():
    result = parse_duration("30mins")
    assert result == 1800


def test_parse_duration_case_insensitive():
    result = parse_duration("2H 30M")
    assert result == 9000


def test_parse_duration_whitespace_tolerance():
    result = parse_duration("  2 hours   30 minutes  ")
    assert result == 9000


def test_parse_duration_error_empty_string():
    with pytest.raises(ValueError):
        parse_duration("")


def test_parse_duration_error_no_units():
    with pytest.raises(ValueError):
        parse_duration("hello world")


def test_parse_duration_error_negative():
    with pytest.raises(ValueError):
        parse_duration("-5 hours")


def test_parse_duration_error_just_number():
    with pytest.raises(ValueError):
        parse_duration("42")


# ============================================================================
# human_date tests
# ============================================================================

def test_human_date_today():
    result = human_date(1705276800, reference=1705276800)
    assert result == "Today"


def test_human_date_today_same_day_different_time():
    result = human_date(1705320000, reference=1705276800)
    assert result == "Today"


def test_human_date_yesterday():
    result = human_date(1705190400, reference=1705276800)
    assert result == "Yesterday"


def test_human_date_tomorrow():
    result = human_date(1705363200, reference=1705276800)
    assert result == "Tomorrow"


def test_human_date_last_sunday_1_day_before_monday():
    result = human_date(1705190400, reference=1705276800)
    assert result == "Yesterday"


def test_human_date_last_saturday_2_days_ago():
    result = human_date(1705104000, reference=1705276800)
    assert result == "Last Saturday"


def test_human_date_last_friday_3_days_ago():
    result = human_date(1705017600, reference=1705276800)
    assert result == "Last Friday"


def test_human_date_last_thursday_4_days_ago():
    result = human_date(1704931200, reference=1705276800)
    assert result == "Last Thursday"


def test_human_date_last_wednesday_5_days_ago():
    result = human_date(1704844800, reference=1705276800)
    assert result == "Last Wednesday"


def test_human_date_last_tuesday_6_days_ago():
    result = human_date(1704758400, reference=1705276800)
    assert result == "Last Tuesday"


def test_human_date_last_monday_7_days_ago_becomes_date():
    result = human_date(1704672000, reference=1705276800)
    assert result == "January 8"


def test_human_date_this_tuesday_1_day_future():
    result = human_date(1705363200, reference=1705276800)
    assert result == "Tomorrow"


def test_human_date_this_wednesday_2_days_future():
    result = human_date(1705449600, reference=1705276800)
    assert result == "This Wednesday"


def test_human_date_this_thursday_3_days_future():
    result = human_date(1705536000, reference=1705276800)
    assert result == "This Thursday"


def test_human_date_this_sunday_6_days_future():
    result = human_date(1705795200, reference=1705276800)
    assert result == "This Sunday"


def test_human_date_next_monday_7_days_future_becomes_date():
    result = human_date(1705881600, reference=1705276800)
    assert result == "January 22"


def test_human_date_same_year_different_month():
    result = human_date(1709251200, reference=1705276800)
    assert result == "March 1"


def test_human_date_same_year_end_of_year():
    result = human_date(1735603200, reference=1705276800)
    assert result == "December 31"


def test_human_date_previous_year():
    result = human_date(1672531200, reference=1705276800)
    assert result == "January 1, 2023"


def test_human_date_next_year():
    result = human_date(1736121600, reference=1705276800)
    assert result == "January 6, 2025"


# ============================================================================
# date_range tests
# ============================================================================

def test_date_range_same_day():
    result = date_range(1705276800, 1705276800)
    assert result == "January 15, 2024"


def test_date_range_same_day_different_times():
    result = date_range(1705276800, 1705320000)
    assert result == "January 15, 2024"


def test_date_range_consecutive_days_same_month():
    result = date_range(1705276800, 1705363200)
    assert result == "January 15–16, 2024"


def test_date_range_same_month_range():
    result = date_range(1705276800, 1705881600)
    assert result == "January 15–22, 2024"


def test_date_range_same_year_different_months():
    result = date_range(1705276800, 1707955200)
    assert result == "January 15 – February 15, 2024"


def test_date_range_different_years():
    result = date_range(1703721600, 1705276800)
    assert result == "December 28, 2023 – January 15, 2024"


def test_date_range_full_year_span():
    result = date_range(1704067200, 1735603200)
    assert result == "January 1 – December 31, 2024"


def test_date_range_swapped_inputs_should_auto_correct():
    result = date_range(1705881600, 1705276800)
    assert result == "January 15–22, 2024"


def test_date_range_multi_year_span():
    result = date_range(1672531200, 1735689600)
    assert result == "January 1, 2023 – January 1, 2025"

//! Generated tests from tests.yaml

use super::*;

// ============================================================================
// timeago tests
// ============================================================================

#[test]
fn test_timeago_just_now_identical_timestamps() {
    assert_eq!(timeago(1704067200_i64, 1704067200_i64), "just now");
}

#[test]
fn test_timeago_just_now_30_seconds_ago() {
    assert_eq!(timeago(1704067170_i64, 1704067200_i64), "just now");
}

#[test]
fn test_timeago_just_now_44_seconds_ago() {
    assert_eq!(timeago(1704067156_i64, 1704067200_i64), "just now");
}

#[test]
fn test_timeago_1_minute_ago_45_seconds() {
    assert_eq!(timeago(1704067155_i64, 1704067200_i64), "1 minute ago");
}

#[test]
fn test_timeago_1_minute_ago_89_seconds() {
    assert_eq!(timeago(1704067111_i64, 1704067200_i64), "1 minute ago");
}

#[test]
fn test_timeago_2_minutes_ago_90_seconds() {
    assert_eq!(timeago(1704067110_i64, 1704067200_i64), "2 minutes ago");
}

#[test]
fn test_timeago_30_minutes_ago() {
    assert_eq!(timeago(1704065400_i64, 1704067200_i64), "30 minutes ago");
}

#[test]
fn test_timeago_44_minutes_ago() {
    assert_eq!(timeago(1704064560_i64, 1704067200_i64), "44 minutes ago");
}

#[test]
fn test_timeago_1_hour_ago_45_minutes() {
    assert_eq!(timeago(1704064500_i64, 1704067200_i64), "1 hour ago");
}

#[test]
fn test_timeago_1_hour_ago_89_minutes() {
    assert_eq!(timeago(1704061860_i64, 1704067200_i64), "1 hour ago");
}

#[test]
fn test_timeago_2_hours_ago_90_minutes() {
    assert_eq!(timeago(1704061800_i64, 1704067200_i64), "2 hours ago");
}

#[test]
fn test_timeago_5_hours_ago() {
    assert_eq!(timeago(1704049200_i64, 1704067200_i64), "5 hours ago");
}

#[test]
fn test_timeago_21_hours_ago() {
    assert_eq!(timeago(1703991600_i64, 1704067200_i64), "21 hours ago");
}

#[test]
fn test_timeago_1_day_ago_22_hours() {
    assert_eq!(timeago(1703988000_i64, 1704067200_i64), "1 day ago");
}

#[test]
fn test_timeago_1_day_ago_35_hours() {
    assert_eq!(timeago(1703941200_i64, 1704067200_i64), "1 day ago");
}

#[test]
fn test_timeago_2_days_ago_36_hours() {
    assert_eq!(timeago(1703937600_i64, 1704067200_i64), "2 days ago");
}

#[test]
fn test_timeago_7_days_ago() {
    assert_eq!(timeago(1703462400_i64, 1704067200_i64), "7 days ago");
}

#[test]
fn test_timeago_25_days_ago() {
    assert_eq!(timeago(1701907200_i64, 1704067200_i64), "25 days ago");
}

#[test]
fn test_timeago_1_month_ago_26_days() {
    assert_eq!(timeago(1701820800_i64, 1704067200_i64), "1 month ago");
}

#[test]
fn test_timeago_1_month_ago_45_days() {
    assert_eq!(timeago(1700179200_i64, 1704067200_i64), "1 month ago");
}

#[test]
fn test_timeago_2_months_ago_46_days() {
    assert_eq!(timeago(1700092800_i64, 1704067200_i64), "2 months ago");
}

#[test]
fn test_timeago_6_months_ago() {
    assert_eq!(timeago(1688169600_i64, 1704067200_i64), "6 months ago");
}

#[test]
fn test_timeago_10_months_ago_319_days() {
    assert_eq!(timeago(1676505600_i64, 1704067200_i64), "10 months ago");
}

#[test]
fn test_timeago_1_year_ago_320_days() {
    assert_eq!(timeago(1676419200_i64, 1704067200_i64), "1 year ago");
}

#[test]
fn test_timeago_1_year_ago_547_days() {
    assert_eq!(timeago(1656806400_i64, 1704067200_i64), "1 year ago");
}

#[test]
fn test_timeago_2_years_ago_548_days() {
    assert_eq!(timeago(1656720000_i64, 1704067200_i64), "2 years ago");
}

#[test]
fn test_timeago_5_years_ago() {
    assert_eq!(timeago(1546300800_i64, 1704067200_i64), "5 years ago");
}

#[test]
fn test_timeago_future_in_just_now_30_seconds() {
    assert_eq!(timeago(1704067230_i64, 1704067200_i64), "just now");
}

#[test]
fn test_timeago_future_in_1_minute() {
    assert_eq!(timeago(1704067260_i64, 1704067200_i64), "in 1 minute");
}

#[test]
fn test_timeago_future_in_5_minutes() {
    assert_eq!(timeago(1704067500_i64, 1704067200_i64), "in 5 minutes");
}

#[test]
fn test_timeago_future_in_1_hour() {
    assert_eq!(timeago(1704070200_i64, 1704067200_i64), "in 1 hour");
}

#[test]
fn test_timeago_future_in_3_hours() {
    assert_eq!(timeago(1704078000_i64, 1704067200_i64), "in 3 hours");
}

#[test]
fn test_timeago_future_in_1_day() {
    assert_eq!(timeago(1704150000_i64, 1704067200_i64), "in 1 day");
}

#[test]
fn test_timeago_future_in_2_days() {
    assert_eq!(timeago(1704240000_i64, 1704067200_i64), "in 2 days");
}

#[test]
fn test_timeago_future_in_1_month() {
    assert_eq!(timeago(1706745600_i64, 1704067200_i64), "in 1 month");
}

#[test]
fn test_timeago_future_in_1_year() {
    assert_eq!(timeago(1735689600_i64, 1704067200_i64), "in 1 year");
}

// ============================================================================
// duration tests
// ============================================================================

#[test]
fn test_duration_zero_seconds() {
    assert_eq!(duration(0, None).unwrap(), "0 seconds");
}

#[test]
fn test_duration_1_second() {
    assert_eq!(duration(1, None).unwrap(), "1 second");
}

#[test]
fn test_duration_45_seconds() {
    assert_eq!(duration(45, None).unwrap(), "45 seconds");
}

#[test]
fn test_duration_1_minute() {
    assert_eq!(duration(60, None).unwrap(), "1 minute");
}

#[test]
fn test_duration_1_minute_30_seconds() {
    assert_eq!(duration(90, None).unwrap(), "1 minute, 30 seconds");
}

#[test]
fn test_duration_2_minutes() {
    assert_eq!(duration(120, None).unwrap(), "2 minutes");
}

#[test]
fn test_duration_1_hour() {
    assert_eq!(duration(3600, None).unwrap(), "1 hour");
}

#[test]
fn test_duration_1_hour_1_minute() {
    assert_eq!(duration(3661, None).unwrap(), "1 hour, 1 minute");
}

#[test]
fn test_duration_1_hour_30_minutes() {
    assert_eq!(duration(5400, None).unwrap(), "1 hour, 30 minutes");
}

#[test]
fn test_duration_2_hours_30_minutes() {
    assert_eq!(duration(9000, None).unwrap(), "2 hours, 30 minutes");
}

#[test]
fn test_duration_1_day() {
    assert_eq!(duration(86400, None).unwrap(), "1 day");
}

#[test]
fn test_duration_1_day_2_hours() {
    assert_eq!(duration(93600, None).unwrap(), "1 day, 2 hours");
}

#[test]
fn test_duration_7_days() {
    assert_eq!(duration(604800, None).unwrap(), "7 days");
}

#[test]
fn test_duration_1_month_30_days() {
    assert_eq!(duration(2592000, None).unwrap(), "1 month");
}

#[test]
fn test_duration_1_year_365_days() {
    assert_eq!(duration(31536000, None).unwrap(), "1 year");
}

#[test]
fn test_duration_1_year_2_months() {
    assert_eq!(duration(36720000, None).unwrap(), "1 year, 2 months");
}

#[test]
fn test_duration_compact_1h_1m() {
    let opts = DurationOptions::new().compact(true);
    assert_eq!(duration(3661, Some(opts)).unwrap(), "1h 1m");
}

#[test]
fn test_duration_compact_2h_30m() {
    let opts = DurationOptions::new().compact(true);
    assert_eq!(duration(9000, Some(opts)).unwrap(), "2h 30m");
}

#[test]
fn test_duration_compact_1d_2h() {
    let opts = DurationOptions::new().compact(true);
    assert_eq!(duration(93600, Some(opts)).unwrap(), "1d 2h");
}

#[test]
fn test_duration_compact_45s() {
    let opts = DurationOptions::new().compact(true);
    assert_eq!(duration(45, Some(opts)).unwrap(), "45s");
}

#[test]
fn test_duration_compact_0s() {
    let opts = DurationOptions::new().compact(true);
    assert_eq!(duration(0, Some(opts)).unwrap(), "0s");
}

#[test]
fn test_duration_max_units_1_hours_only() {
    let opts = DurationOptions::new().max_units(1);
    assert_eq!(duration(3661, Some(opts)).unwrap(), "1 hour");
}

#[test]
fn test_duration_max_units_1_days_only() {
    let opts = DurationOptions::new().max_units(1);
    assert_eq!(duration(93600, Some(opts)).unwrap(), "1 day");
}

#[test]
fn test_duration_max_units_3() {
    let opts = DurationOptions::new().max_units(3);
    assert_eq!(duration(93661, Some(opts)).unwrap(), "1 day, 2 hours, 1 minute");
}

#[test]
fn test_duration_compact_max_units_1() {
    let opts = DurationOptions::new().compact(true).max_units(1);
    assert_eq!(duration(9000, Some(opts)).unwrap(), "2h");
}

#[test]
fn test_duration_error_negative_seconds() {
    assert!(duration(-100, None).is_err());
}

// ============================================================================
// parse_duration tests
// ============================================================================

#[test]
fn test_parse_duration_compact_hours_minutes() {
    assert_eq!(parse_duration("2h30m").unwrap(), 9000);
}

#[test]
fn test_parse_duration_compact_with_space() {
    assert_eq!(parse_duration("2h 30m").unwrap(), 9000);
}

#[test]
fn test_parse_duration_compact_with_comma() {
    assert_eq!(parse_duration("2h, 30m").unwrap(), 9000);
}

#[test]
fn test_parse_duration_verbose() {
    assert_eq!(parse_duration("2 hours 30 minutes").unwrap(), 9000);
}

#[test]
fn test_parse_duration_verbose_with_and() {
    assert_eq!(parse_duration("2 hours and 30 minutes").unwrap(), 9000);
}

#[test]
fn test_parse_duration_verbose_with_comma_and() {
    assert_eq!(parse_duration("2 hours, and 30 minutes").unwrap(), 9000);
}

#[test]
fn test_parse_duration_decimal_hours() {
    assert_eq!(parse_duration("2.5 hours").unwrap(), 9000);
}

#[test]
fn test_parse_duration_decimal_compact() {
    assert_eq!(parse_duration("1.5h").unwrap(), 5400);
}

#[test]
fn test_parse_duration_single_unit_minutes_verbose() {
    assert_eq!(parse_duration("90 minutes").unwrap(), 5400);
}

#[test]
fn test_parse_duration_single_unit_minutes_compact() {
    assert_eq!(parse_duration("90m").unwrap(), 5400);
}

#[test]
fn test_parse_duration_single_unit_min() {
    assert_eq!(parse_duration("90min").unwrap(), 5400);
}

#[test]
fn test_parse_duration_colon_notation_hmm() {
    assert_eq!(parse_duration("2:30").unwrap(), 9000);
}

#[test]
fn test_parse_duration_colon_notation_hmmss() {
    assert_eq!(parse_duration("1:30:00").unwrap(), 5400);
}

#[test]
fn test_parse_duration_colon_notation_with_seconds() {
    assert_eq!(parse_duration("0:05:30").unwrap(), 330);
}

#[test]
fn test_parse_duration_days_verbose() {
    assert_eq!(parse_duration("2 days").unwrap(), 172800);
}

#[test]
fn test_parse_duration_days_compact() {
    assert_eq!(parse_duration("2d").unwrap(), 172800);
}

#[test]
fn test_parse_duration_weeks_verbose() {
    assert_eq!(parse_duration("1 week").unwrap(), 604800);
}

#[test]
fn test_parse_duration_weeks_compact() {
    assert_eq!(parse_duration("1w").unwrap(), 604800);
}

#[test]
fn test_parse_duration_mixed_verbose() {
    assert_eq!(parse_duration("1 day, 2 hours, and 30 minutes").unwrap(), 95400);
}

#[test]
fn test_parse_duration_mixed_compact() {
    assert_eq!(parse_duration("1d 2h 30m").unwrap(), 95400);
}

#[test]
fn test_parse_duration_seconds_only_verbose() {
    assert_eq!(parse_duration("45 seconds").unwrap(), 45);
}

#[test]
fn test_parse_duration_seconds_compact_s() {
    assert_eq!(parse_duration("45s").unwrap(), 45);
}

#[test]
fn test_parse_duration_seconds_compact_sec() {
    assert_eq!(parse_duration("45sec").unwrap(), 45);
}

#[test]
fn test_parse_duration_hours_hr() {
    assert_eq!(parse_duration("2hr").unwrap(), 7200);
}

#[test]
fn test_parse_duration_hours_hrs() {
    assert_eq!(parse_duration("2hrs").unwrap(), 7200);
}

#[test]
fn test_parse_duration_minutes_mins() {
    assert_eq!(parse_duration("30mins").unwrap(), 1800);
}

#[test]
fn test_parse_duration_case_insensitive() {
    assert_eq!(parse_duration("2H 30M").unwrap(), 9000);
}

#[test]
fn test_parse_duration_whitespace_tolerance() {
    assert_eq!(parse_duration("  2 hours   30 minutes  ").unwrap(), 9000);
}

#[test]
fn test_parse_duration_error_empty_string() {
    assert!(parse_duration("").is_err());
}

#[test]
fn test_parse_duration_error_no_units() {
    assert!(parse_duration("hello world").is_err());
}

#[test]
fn test_parse_duration_error_negative() {
    assert!(parse_duration("-5 hours").is_err());
}

#[test]
fn test_parse_duration_error_just_number() {
    assert!(parse_duration("42").is_err());
}

// ============================================================================
// human_date tests
// ============================================================================

#[test]
fn test_human_date_today() {
    assert_eq!(human_date(1705276800_i64, 1705276800_i64), "Today");
}

#[test]
fn test_human_date_today_same_day_different_time() {
    assert_eq!(human_date(1705320000_i64, 1705276800_i64), "Today");
}

#[test]
fn test_human_date_yesterday() {
    assert_eq!(human_date(1705190400_i64, 1705276800_i64), "Yesterday");
}

#[test]
fn test_human_date_tomorrow() {
    assert_eq!(human_date(1705363200_i64, 1705276800_i64), "Tomorrow");
}

#[test]
fn test_human_date_last_sunday_1_day_before_monday() {
    // This is also "Yesterday" per the test case
    assert_eq!(human_date(1705190400_i64, 1705276800_i64), "Yesterday");
}

#[test]
fn test_human_date_last_saturday_2_days_ago() {
    assert_eq!(human_date(1705104000_i64, 1705276800_i64), "Last Saturday");
}

#[test]
fn test_human_date_last_friday_3_days_ago() {
    assert_eq!(human_date(1705017600_i64, 1705276800_i64), "Last Friday");
}

#[test]
fn test_human_date_last_thursday_4_days_ago() {
    assert_eq!(human_date(1704931200_i64, 1705276800_i64), "Last Thursday");
}

#[test]
fn test_human_date_last_wednesday_5_days_ago() {
    assert_eq!(human_date(1704844800_i64, 1705276800_i64), "Last Wednesday");
}

#[test]
fn test_human_date_last_tuesday_6_days_ago() {
    assert_eq!(human_date(1704758400_i64, 1705276800_i64), "Last Tuesday");
}

#[test]
fn test_human_date_last_monday_7_days_ago_becomes_date() {
    assert_eq!(human_date(1704672000_i64, 1705276800_i64), "January 8");
}

#[test]
fn test_human_date_this_tuesday_1_day_future() {
    // This is also "Tomorrow" per the test case
    assert_eq!(human_date(1705363200_i64, 1705276800_i64), "Tomorrow");
}

#[test]
fn test_human_date_this_wednesday_2_days_future() {
    assert_eq!(human_date(1705449600_i64, 1705276800_i64), "This Wednesday");
}

#[test]
fn test_human_date_this_thursday_3_days_future() {
    assert_eq!(human_date(1705536000_i64, 1705276800_i64), "This Thursday");
}

#[test]
fn test_human_date_this_sunday_6_days_future() {
    assert_eq!(human_date(1705795200_i64, 1705276800_i64), "This Sunday");
}

#[test]
fn test_human_date_next_monday_7_days_future_becomes_date() {
    assert_eq!(human_date(1705881600_i64, 1705276800_i64), "January 22");
}

#[test]
fn test_human_date_same_year_different_month() {
    assert_eq!(human_date(1709251200_i64, 1705276800_i64), "March 1");
}

#[test]
fn test_human_date_same_year_end_of_year() {
    assert_eq!(human_date(1735603200_i64, 1705276800_i64), "December 31");
}

#[test]
fn test_human_date_previous_year() {
    assert_eq!(human_date(1672531200_i64, 1705276800_i64), "January 1, 2023");
}

#[test]
fn test_human_date_next_year() {
    assert_eq!(human_date(1736121600_i64, 1705276800_i64), "January 6, 2025");
}

// ============================================================================
// date_range tests
// ============================================================================

#[test]
fn test_date_range_same_day() {
    assert_eq!(date_range(1705276800_i64, 1705276800_i64), "January 15, 2024");
}

#[test]
fn test_date_range_same_day_different_times() {
    assert_eq!(date_range(1705276800_i64, 1705320000_i64), "January 15, 2024");
}

#[test]
fn test_date_range_consecutive_days_same_month() {
    assert_eq!(date_range(1705276800_i64, 1705363200_i64), "January 15\u{2013}16, 2024");
}

#[test]
fn test_date_range_same_month_range() {
    assert_eq!(date_range(1705276800_i64, 1705881600_i64), "January 15\u{2013}22, 2024");
}

#[test]
fn test_date_range_same_year_different_months() {
    assert_eq!(
        date_range(1705276800_i64, 1707955200_i64),
        "January 15 \u{2013} February 15, 2024"
    );
}

#[test]
fn test_date_range_different_years() {
    assert_eq!(
        date_range(1703721600_i64, 1705276800_i64),
        "December 28, 2023 \u{2013} January 15, 2024"
    );
}

#[test]
fn test_date_range_full_year_span() {
    assert_eq!(
        date_range(1704067200_i64, 1735603200_i64),
        "January 1 \u{2013} December 31, 2024"
    );
}

#[test]
fn test_date_range_swapped_inputs_should_auto_correct() {
    assert_eq!(date_range(1705881600_i64, 1705276800_i64), "January 15\u{2013}22, 2024");
}

#[test]
fn test_date_range_multi_year_span() {
    assert_eq!(
        date_range(1672531200_i64, 1735689600_i64),
        "January 1, 2023 \u{2013} January 1, 2025"
    );
}

module main

import whenwords

// timeago tests

fn test_timeago_just_now_identical_timestamps() {
	result := whenwords.timeago(1704067200, 1704067200)
	assert result == 'just now'
}

fn test_timeago_just_now_30_seconds_ago() {
	result := whenwords.timeago(1704067170, 1704067200)
	assert result == 'just now'
}

fn test_timeago_just_now_44_seconds_ago() {
	result := whenwords.timeago(1704067156, 1704067200)
	assert result == 'just now'
}

fn test_timeago_1_minute_ago_45_seconds() {
	result := whenwords.timeago(1704067155, 1704067200)
	assert result == '1 minute ago'
}

fn test_timeago_1_minute_ago_89_seconds() {
	result := whenwords.timeago(1704067111, 1704067200)
	assert result == '1 minute ago'
}

fn test_timeago_2_minutes_ago_90_seconds() {
	result := whenwords.timeago(1704067110, 1704067200)
	assert result == '2 minutes ago'
}

fn test_timeago_30_minutes_ago() {
	result := whenwords.timeago(1704065400, 1704067200)
	assert result == '30 minutes ago'
}

fn test_timeago_44_minutes_ago() {
	result := whenwords.timeago(1704064560, 1704067200)
	assert result == '44 minutes ago'
}

fn test_timeago_1_hour_ago_45_minutes() {
	result := whenwords.timeago(1704064500, 1704067200)
	assert result == '1 hour ago'
}

fn test_timeago_1_hour_ago_89_minutes() {
	result := whenwords.timeago(1704061860, 1704067200)
	assert result == '1 hour ago'
}

fn test_timeago_2_hours_ago_90_minutes() {
	result := whenwords.timeago(1704061800, 1704067200)
	assert result == '2 hours ago'
}

fn test_timeago_5_hours_ago() {
	result := whenwords.timeago(1704049200, 1704067200)
	assert result == '5 hours ago'
}

fn test_timeago_21_hours_ago() {
	result := whenwords.timeago(1703991600, 1704067200)
	assert result == '21 hours ago'
}

fn test_timeago_1_day_ago_22_hours() {
	result := whenwords.timeago(1703988000, 1704067200)
	assert result == '1 day ago'
}

fn test_timeago_1_day_ago_35_hours() {
	result := whenwords.timeago(1703941200, 1704067200)
	assert result == '1 day ago'
}

fn test_timeago_2_days_ago_36_hours() {
	result := whenwords.timeago(1703937600, 1704067200)
	assert result == '2 days ago'
}

fn test_timeago_7_days_ago() {
	result := whenwords.timeago(1703462400, 1704067200)
	assert result == '7 days ago'
}

fn test_timeago_25_days_ago() {
	result := whenwords.timeago(1701907200, 1704067200)
	assert result == '25 days ago'
}

fn test_timeago_1_month_ago_26_days() {
	result := whenwords.timeago(1701820800, 1704067200)
	assert result == '1 month ago'
}

fn test_timeago_1_month_ago_45_days() {
	result := whenwords.timeago(1700179200, 1704067200)
	assert result == '1 month ago'
}

fn test_timeago_2_months_ago_46_days() {
	result := whenwords.timeago(1700092800, 1704067200)
	assert result == '2 months ago'
}

fn test_timeago_6_months_ago() {
	result := whenwords.timeago(1688169600, 1704067200)
	assert result == '6 months ago'
}

fn test_timeago_11_months_ago_319_days() {
	result := whenwords.timeago(1676505600, 1704067200)
	assert result == '11 months ago'
}

fn test_timeago_1_year_ago_320_days() {
	result := whenwords.timeago(1676419200, 1704067200)
	assert result == '1 year ago'
}

fn test_timeago_1_year_ago_547_days() {
	result := whenwords.timeago(1656806400, 1704067200)
	assert result == '1 year ago'
}

fn test_timeago_2_years_ago_548_days() {
	result := whenwords.timeago(1656720000, 1704067200)
	assert result == '2 years ago'
}

fn test_timeago_5_years_ago() {
	result := whenwords.timeago(1546300800, 1704067200)
	assert result == '5 years ago'
}

fn test_timeago_future_in_just_now_30_seconds() {
	result := whenwords.timeago(1704067230, 1704067200)
	assert result == 'just now'
}

fn test_timeago_future_in_1_minute() {
	result := whenwords.timeago(1704067260, 1704067200)
	assert result == 'in 1 minute'
}

fn test_timeago_future_in_5_minutes() {
	result := whenwords.timeago(1704067500, 1704067200)
	assert result == 'in 5 minutes'
}

fn test_timeago_future_in_1_hour() {
	result := whenwords.timeago(1704070200, 1704067200)
	assert result == 'in 1 hour'
}

fn test_timeago_future_in_3_hours() {
	result := whenwords.timeago(1704078000, 1704067200)
	assert result == 'in 3 hours'
}

fn test_timeago_future_in_1_day() {
	result := whenwords.timeago(1704150000, 1704067200)
	assert result == 'in 1 day'
}

fn test_timeago_future_in_2_days() {
	result := whenwords.timeago(1704240000, 1704067200)
	assert result == 'in 2 days'
}

fn test_timeago_future_in_1_month() {
	result := whenwords.timeago(1706745600, 1704067200)
	assert result == 'in 1 month'
}

fn test_timeago_future_in_1_year() {
	result := whenwords.timeago(1735689600, 1704067200)
	assert result == 'in 1 year'
}

// duration tests

fn test_duration_zero_seconds() {
	result := whenwords.duration(0, whenwords.DurationOptions{})!
	assert result == '0 seconds'
}

fn test_duration_1_second() {
	result := whenwords.duration(1, whenwords.DurationOptions{})!
	assert result == '1 second'
}

fn test_duration_45_seconds() {
	result := whenwords.duration(45, whenwords.DurationOptions{})!
	assert result == '45 seconds'
}

fn test_duration_1_minute() {
	result := whenwords.duration(60, whenwords.DurationOptions{})!
	assert result == '1 minute'
}

fn test_duration_1_minute_30_seconds() {
	result := whenwords.duration(90, whenwords.DurationOptions{})!
	assert result == '1 minute, 30 seconds'
}

fn test_duration_2_minutes() {
	result := whenwords.duration(120, whenwords.DurationOptions{})!
	assert result == '2 minutes'
}

fn test_duration_1_hour() {
	result := whenwords.duration(3600, whenwords.DurationOptions{})!
	assert result == '1 hour'
}

fn test_duration_1_hour_1_minute() {
	result := whenwords.duration(3661, whenwords.DurationOptions{})!
	assert result == '1 hour, 1 minute'
}

fn test_duration_1_hour_30_minutes() {
	result := whenwords.duration(5400, whenwords.DurationOptions{})!
	assert result == '1 hour, 30 minutes'
}

fn test_duration_2_hours_30_minutes() {
	result := whenwords.duration(9000, whenwords.DurationOptions{})!
	assert result == '2 hours, 30 minutes'
}

fn test_duration_1_day() {
	result := whenwords.duration(86400, whenwords.DurationOptions{})!
	assert result == '1 day'
}

fn test_duration_1_day_2_hours() {
	result := whenwords.duration(93600, whenwords.DurationOptions{})!
	assert result == '1 day, 2 hours'
}

fn test_duration_7_days() {
	result := whenwords.duration(604800, whenwords.DurationOptions{})!
	assert result == '7 days'
}

fn test_duration_1_month_30_days() {
	result := whenwords.duration(2592000, whenwords.DurationOptions{})!
	assert result == '1 month'
}

fn test_duration_1_year_365_days() {
	result := whenwords.duration(31536000, whenwords.DurationOptions{})!
	assert result == '1 year'
}

fn test_duration_1_year_2_months() {
	result := whenwords.duration(36720000, whenwords.DurationOptions{})!
	assert result == '1 year, 2 months'
}

fn test_duration_compact_1h_1m() {
	result := whenwords.duration(3661, whenwords.DurationOptions{ compact: true })!
	assert result == '1h 1m'
}

fn test_duration_compact_2h_30m() {
	result := whenwords.duration(9000, whenwords.DurationOptions{ compact: true })!
	assert result == '2h 30m'
}

fn test_duration_compact_1d_2h() {
	result := whenwords.duration(93600, whenwords.DurationOptions{ compact: true })!
	assert result == '1d 2h'
}

fn test_duration_compact_45s() {
	result := whenwords.duration(45, whenwords.DurationOptions{ compact: true })!
	assert result == '45s'
}

fn test_duration_compact_0s() {
	result := whenwords.duration(0, whenwords.DurationOptions{ compact: true })!
	assert result == '0s'
}

fn test_duration_max_units_1_hours_only() {
	result := whenwords.duration(3661, whenwords.DurationOptions{ max_units: 1 })!
	assert result == '1 hour'
}

fn test_duration_max_units_1_days_only() {
	result := whenwords.duration(93600, whenwords.DurationOptions{ max_units: 1 })!
	assert result == '1 day'
}

fn test_duration_max_units_3() {
	result := whenwords.duration(93661, whenwords.DurationOptions{ max_units: 3 })!
	assert result == '1 day, 2 hours, 1 minute'
}

fn test_duration_compact_max_units_1() {
	result := whenwords.duration(9000, whenwords.DurationOptions{ compact: true, max_units: 1 })!
	assert result == '3h'
}

fn test_duration_error_negative_seconds() {
	whenwords.duration(-100, whenwords.DurationOptions{}) or { return }
	assert false, 'should have returned an error'
}

// parse_duration tests

fn test_parse_duration_compact_hours_minutes() {
	result := whenwords.parse_duration('2h30m')!
	assert result == 9000
}

fn test_parse_duration_compact_with_space() {
	result := whenwords.parse_duration('2h 30m')!
	assert result == 9000
}

fn test_parse_duration_compact_with_comma() {
	result := whenwords.parse_duration('2h, 30m')!
	assert result == 9000
}

fn test_parse_duration_verbose() {
	result := whenwords.parse_duration('2 hours 30 minutes')!
	assert result == 9000
}

fn test_parse_duration_verbose_with_and() {
	result := whenwords.parse_duration('2 hours and 30 minutes')!
	assert result == 9000
}

fn test_parse_duration_verbose_with_comma_and() {
	result := whenwords.parse_duration('2 hours, and 30 minutes')!
	assert result == 9000
}

fn test_parse_duration_decimal_hours() {
	result := whenwords.parse_duration('2.5 hours')!
	assert result == 9000
}

fn test_parse_duration_decimal_compact() {
	result := whenwords.parse_duration('1.5h')!
	assert result == 5400
}

fn test_parse_duration_single_unit_minutes_verbose() {
	result := whenwords.parse_duration('90 minutes')!
	assert result == 5400
}

fn test_parse_duration_single_unit_minutes_compact() {
	result := whenwords.parse_duration('90m')!
	assert result == 5400
}

fn test_parse_duration_single_unit_min() {
	result := whenwords.parse_duration('90min')!
	assert result == 5400
}

fn test_parse_duration_colon_notation_h_mm() {
	result := whenwords.parse_duration('2:30')!
	assert result == 9000
}

fn test_parse_duration_colon_notation_h_mm_ss() {
	result := whenwords.parse_duration('1:30:00')!
	assert result == 5400
}

fn test_parse_duration_colon_notation_with_seconds() {
	result := whenwords.parse_duration('0:05:30')!
	assert result == 330
}

fn test_parse_duration_days_verbose() {
	result := whenwords.parse_duration('2 days')!
	assert result == 172800
}

fn test_parse_duration_days_compact() {
	result := whenwords.parse_duration('2d')!
	assert result == 172800
}

fn test_parse_duration_weeks_verbose() {
	result := whenwords.parse_duration('1 week')!
	assert result == 604800
}

fn test_parse_duration_weeks_compact() {
	result := whenwords.parse_duration('1w')!
	assert result == 604800
}

fn test_parse_duration_mixed_verbose() {
	result := whenwords.parse_duration('1 day, 2 hours, and 30 minutes')!
	assert result == 95400
}

fn test_parse_duration_mixed_compact() {
	result := whenwords.parse_duration('1d 2h 30m')!
	assert result == 95400
}

fn test_parse_duration_seconds_only_verbose() {
	result := whenwords.parse_duration('45 seconds')!
	assert result == 45
}

fn test_parse_duration_seconds_compact_s() {
	result := whenwords.parse_duration('45s')!
	assert result == 45
}

fn test_parse_duration_seconds_compact_sec() {
	result := whenwords.parse_duration('45sec')!
	assert result == 45
}

fn test_parse_duration_hours_hr() {
	result := whenwords.parse_duration('2hr')!
	assert result == 7200
}

fn test_parse_duration_hours_hrs() {
	result := whenwords.parse_duration('2hrs')!
	assert result == 7200
}

fn test_parse_duration_minutes_mins() {
	result := whenwords.parse_duration('30mins')!
	assert result == 1800
}

fn test_parse_duration_case_insensitive() {
	result := whenwords.parse_duration('2H 30M')!
	assert result == 9000
}

fn test_parse_duration_whitespace_tolerance() {
	result := whenwords.parse_duration('  2 hours   30 minutes  ')!
	assert result == 9000
}

fn test_parse_duration_error_empty_string() {
	whenwords.parse_duration('') or { return }
	assert false, 'should have returned an error'
}

fn test_parse_duration_error_no_units() {
	whenwords.parse_duration('hello world') or { return }
	assert false, 'should have returned an error'
}

fn test_parse_duration_error_negative() {
	whenwords.parse_duration('-5 hours') or { return }
	assert false, 'should have returned an error'
}

fn test_parse_duration_error_just_number() {
	whenwords.parse_duration('42') or { return }
	assert false, 'should have returned an error'
}

// human_date tests

fn test_human_date_today() {
	result := whenwords.human_date(1705276800, 1705276800)
	assert result == 'Today'
}

fn test_human_date_today_same_day_different_time() {
	result := whenwords.human_date(1705320000, 1705276800)
	assert result == 'Today'
}

fn test_human_date_yesterday() {
	result := whenwords.human_date(1705190400, 1705276800)
	assert result == 'Yesterday'
}

fn test_human_date_tomorrow() {
	result := whenwords.human_date(1705363200, 1705276800)
	assert result == 'Tomorrow'
}

fn test_human_date_last_sunday_1_day_before_monday() {
	result := whenwords.human_date(1705190400, 1705276800)
	assert result == 'Yesterday'
}

fn test_human_date_last_saturday_2_days_ago() {
	result := whenwords.human_date(1705104000, 1705276800)
	assert result == 'Last Saturday'
}

fn test_human_date_last_friday_3_days_ago() {
	result := whenwords.human_date(1705017600, 1705276800)
	assert result == 'Last Friday'
}

fn test_human_date_last_thursday_4_days_ago() {
	result := whenwords.human_date(1704931200, 1705276800)
	assert result == 'Last Thursday'
}

fn test_human_date_last_wednesday_5_days_ago() {
	result := whenwords.human_date(1704844800, 1705276800)
	assert result == 'Last Wednesday'
}

fn test_human_date_last_tuesday_6_days_ago() {
	result := whenwords.human_date(1704758400, 1705276800)
	assert result == 'Last Tuesday'
}

fn test_human_date_last_monday_7_days_ago_becomes_date() {
	result := whenwords.human_date(1704672000, 1705276800)
	assert result == 'January 8'
}

fn test_human_date_this_tuesday_1_day_future() {
	result := whenwords.human_date(1705363200, 1705276800)
	assert result == 'Tomorrow'
}

fn test_human_date_this_wednesday_2_days_future() {
	result := whenwords.human_date(1705449600, 1705276800)
	assert result == 'This Wednesday'
}

fn test_human_date_this_thursday_3_days_future() {
	result := whenwords.human_date(1705536000, 1705276800)
	assert result == 'This Thursday'
}

fn test_human_date_this_sunday_6_days_future() {
	result := whenwords.human_date(1705795200, 1705276800)
	assert result == 'This Sunday'
}

fn test_human_date_next_monday_7_days_future_becomes_date() {
	result := whenwords.human_date(1705881600, 1705276800)
	assert result == 'January 22'
}

fn test_human_date_same_year_different_month() {
	result := whenwords.human_date(1709251200, 1705276800)
	assert result == 'March 1'
}

fn test_human_date_same_year_end_of_year() {
	result := whenwords.human_date(1735603200, 1705276800)
	assert result == 'December 31'
}

fn test_human_date_previous_year() {
	result := whenwords.human_date(1672531200, 1705276800)
	assert result == 'January 1, 2023'
}

fn test_human_date_next_year() {
	result := whenwords.human_date(1736121600, 1705276800)
	assert result == 'January 6, 2025'
}

// date_range tests

fn test_date_range_same_day() {
	result := whenwords.date_range(1705276800, 1705276800)
	assert result == 'January 15, 2024'
}

fn test_date_range_same_day_different_times() {
	result := whenwords.date_range(1705276800, 1705320000)
	assert result == 'January 15, 2024'
}

fn test_date_range_consecutive_days_same_month() {
	result := whenwords.date_range(1705276800, 1705363200)
	assert result == 'January 15–16, 2024'
}

fn test_date_range_same_month_range() {
	result := whenwords.date_range(1705276800, 1705881600)
	assert result == 'January 15–22, 2024'
}

fn test_date_range_same_year_different_months() {
	result := whenwords.date_range(1705276800, 1707955200)
	assert result == 'January 15 – February 15, 2024'
}

fn test_date_range_different_years() {
	result := whenwords.date_range(1703721600, 1705276800)
	assert result == 'December 28, 2023 – January 15, 2024'
}

fn test_date_range_full_year_span() {
	result := whenwords.date_range(1704067200, 1735603200)
	assert result == 'January 1 – December 31, 2024'
}

fn test_date_range_swapped_inputs_should_auto_correct() {
	result := whenwords.date_range(1705881600, 1705276800)
	assert result == 'January 15–22, 2024'
}

fn test_date_range_multi_year_span() {
	result := whenwords.date_range(1672531200, 1735689600)
	assert result == 'January 1, 2023 – January 1, 2025'
}

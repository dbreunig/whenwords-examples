import XCTest
@testable import Whenwords

// Tests generated from tests.yaml

class WhenwordsTests: XCTestCase {

    // MARK: - timeago tests

    func test_timeago_just_now_identical_timestamps() throws {
        let result = try timeago(1704067200, reference: 1704067200)
        XCTAssertEqual(result, "just now")
    }

    func test_timeago_just_now_30_seconds_ago() throws {
        let result = try timeago(1704067170, reference: 1704067200)
        XCTAssertEqual(result, "just now")
    }

    func test_timeago_just_now_44_seconds_ago() throws {
        let result = try timeago(1704067156, reference: 1704067200)
        XCTAssertEqual(result, "just now")
    }

    func test_timeago_1_minute_ago_45_seconds() throws {
        let result = try timeago(1704067155, reference: 1704067200)
        XCTAssertEqual(result, "1 minute ago")
    }

    func test_timeago_1_minute_ago_89_seconds() throws {
        let result = try timeago(1704067111, reference: 1704067200)
        XCTAssertEqual(result, "1 minute ago")
    }

    func test_timeago_2_minutes_ago_90_seconds() throws {
        let result = try timeago(1704067110, reference: 1704067200)
        XCTAssertEqual(result, "2 minutes ago")
    }

    func test_timeago_30_minutes_ago() throws {
        let result = try timeago(1704065400, reference: 1704067200)
        XCTAssertEqual(result, "30 minutes ago")
    }

    func test_timeago_44_minutes_ago() throws {
        let result = try timeago(1704064560, reference: 1704067200)
        XCTAssertEqual(result, "44 minutes ago")
    }

    func test_timeago_1_hour_ago_45_minutes() throws {
        let result = try timeago(1704064500, reference: 1704067200)
        XCTAssertEqual(result, "1 hour ago")
    }

    func test_timeago_1_hour_ago_89_minutes() throws {
        let result = try timeago(1704061860, reference: 1704067200)
        XCTAssertEqual(result, "1 hour ago")
    }

    func test_timeago_2_hours_ago_90_minutes() throws {
        let result = try timeago(1704061800, reference: 1704067200)
        XCTAssertEqual(result, "2 hours ago")
    }

    func test_timeago_5_hours_ago() throws {
        let result = try timeago(1704049200, reference: 1704067200)
        XCTAssertEqual(result, "5 hours ago")
    }

    func test_timeago_21_hours_ago() throws {
        let result = try timeago(1703991600, reference: 1704067200)
        XCTAssertEqual(result, "21 hours ago")
    }

    func test_timeago_1_day_ago_22_hours() throws {
        let result = try timeago(1703988000, reference: 1704067200)
        XCTAssertEqual(result, "1 day ago")
    }

    func test_timeago_1_day_ago_35_hours() throws {
        let result = try timeago(1703941200, reference: 1704067200)
        XCTAssertEqual(result, "1 day ago")
    }

    func test_timeago_2_days_ago_36_hours() throws {
        let result = try timeago(1703937600, reference: 1704067200)
        XCTAssertEqual(result, "2 days ago")
    }

    func test_timeago_7_days_ago() throws {
        let result = try timeago(1703462400, reference: 1704067200)
        XCTAssertEqual(result, "7 days ago")
    }

    func test_timeago_25_days_ago() throws {
        let result = try timeago(1701907200, reference: 1704067200)
        XCTAssertEqual(result, "25 days ago")
    }

    func test_timeago_1_month_ago_26_days() throws {
        let result = try timeago(1701820800, reference: 1704067200)
        XCTAssertEqual(result, "1 month ago")
    }

    func test_timeago_1_month_ago_45_days() throws {
        let result = try timeago(1700179200, reference: 1704067200)
        XCTAssertEqual(result, "1 month ago")
    }

    func test_timeago_2_months_ago_46_days() throws {
        let result = try timeago(1700092800, reference: 1704067200)
        XCTAssertEqual(result, "2 months ago")
    }

    func test_timeago_6_months_ago() throws {
        let result = try timeago(1688169600, reference: 1704067200)
        XCTAssertEqual(result, "6 months ago")
    }

    func test_timeago_10_months_ago_319_days() throws {
        let result = try timeago(1676505600, reference: 1704067200)
        XCTAssertEqual(result, "10 months ago")
    }

    func test_timeago_1_year_ago_320_days() throws {
        let result = try timeago(1676419200, reference: 1704067200)
        XCTAssertEqual(result, "1 year ago")
    }

    func test_timeago_1_year_ago_547_days() throws {
        let result = try timeago(1656806400, reference: 1704067200)
        XCTAssertEqual(result, "1 year ago")
    }

    func test_timeago_2_years_ago_548_days() throws {
        let result = try timeago(1656720000, reference: 1704067200)
        XCTAssertEqual(result, "2 years ago")
    }

    func test_timeago_5_years_ago() throws {
        let result = try timeago(1546300800, reference: 1704067200)
        XCTAssertEqual(result, "5 years ago")
    }

    func test_timeago_future_in_just_now_30_seconds() throws {
        let result = try timeago(1704067230, reference: 1704067200)
        XCTAssertEqual(result, "just now")
    }

    func test_timeago_future_in_1_minute() throws {
        let result = try timeago(1704067260, reference: 1704067200)
        XCTAssertEqual(result, "in 1 minute")
    }

    func test_timeago_future_in_5_minutes() throws {
        let result = try timeago(1704067500, reference: 1704067200)
        XCTAssertEqual(result, "in 5 minutes")
    }

    func test_timeago_future_in_1_hour() throws {
        let result = try timeago(1704070200, reference: 1704067200)
        XCTAssertEqual(result, "in 1 hour")
    }

    func test_timeago_future_in_3_hours() throws {
        let result = try timeago(1704078000, reference: 1704067200)
        XCTAssertEqual(result, "in 3 hours")
    }

    func test_timeago_future_in_1_day() throws {
        let result = try timeago(1704150000, reference: 1704067200)
        XCTAssertEqual(result, "in 1 day")
    }

    func test_timeago_future_in_2_days() throws {
        let result = try timeago(1704240000, reference: 1704067200)
        XCTAssertEqual(result, "in 2 days")
    }

    func test_timeago_future_in_1_month() throws {
        let result = try timeago(1706745600, reference: 1704067200)
        XCTAssertEqual(result, "in 1 month")
    }

    func test_timeago_future_in_1_year() throws {
        let result = try timeago(1735689600, reference: 1704067200)
        XCTAssertEqual(result, "in 1 year")
    }

    // MARK: - duration tests

    func test_duration_zero_seconds() throws {
        let result = try duration(0)
        XCTAssertEqual(result, "0 seconds")
    }

    func test_duration_1_second() throws {
        let result = try duration(1)
        XCTAssertEqual(result, "1 second")
    }

    func test_duration_45_seconds() throws {
        let result = try duration(45)
        XCTAssertEqual(result, "45 seconds")
    }

    func test_duration_1_minute() throws {
        let result = try duration(60)
        XCTAssertEqual(result, "1 minute")
    }

    func test_duration_1_minute_30_seconds() throws {
        let result = try duration(90)
        XCTAssertEqual(result, "1 minute, 30 seconds")
    }

    func test_duration_2_minutes() throws {
        let result = try duration(120)
        XCTAssertEqual(result, "2 minutes")
    }

    func test_duration_1_hour() throws {
        let result = try duration(3600)
        XCTAssertEqual(result, "1 hour")
    }

    func test_duration_1_hour_1_minute() throws {
        let result = try duration(3661)
        XCTAssertEqual(result, "1 hour, 1 minute")
    }

    func test_duration_1_hour_30_minutes() throws {
        let result = try duration(5400)
        XCTAssertEqual(result, "1 hour, 30 minutes")
    }

    func test_duration_2_hours_30_minutes() throws {
        let result = try duration(9000)
        XCTAssertEqual(result, "2 hours, 30 minutes")
    }

    func test_duration_1_day() throws {
        let result = try duration(86400)
        XCTAssertEqual(result, "1 day")
    }

    func test_duration_1_day_2_hours() throws {
        let result = try duration(93600)
        XCTAssertEqual(result, "1 day, 2 hours")
    }

    func test_duration_7_days() throws {
        let result = try duration(604800)
        XCTAssertEqual(result, "7 days")
    }

    func test_duration_1_month_30_days() throws {
        let result = try duration(2592000)
        XCTAssertEqual(result, "1 month")
    }

    func test_duration_1_year_365_days() throws {
        let result = try duration(31536000)
        XCTAssertEqual(result, "1 year")
    }

    func test_duration_1_year_2_months() throws {
        let result = try duration(36720000)
        XCTAssertEqual(result, "1 year, 2 months")
    }

    func test_duration_compact_1h_1m() throws {
        let result = try duration(3661, options: DurationOptions(compact: true))
        XCTAssertEqual(result, "1h 1m")
    }

    func test_duration_compact_2h_30m() throws {
        let result = try duration(9000, options: DurationOptions(compact: true))
        XCTAssertEqual(result, "2h 30m")
    }

    func test_duration_compact_1d_2h() throws {
        let result = try duration(93600, options: DurationOptions(compact: true))
        XCTAssertEqual(result, "1d 2h")
    }

    func test_duration_compact_45s() throws {
        let result = try duration(45, options: DurationOptions(compact: true))
        XCTAssertEqual(result, "45s")
    }

    func test_duration_compact_0s() throws {
        let result = try duration(0, options: DurationOptions(compact: true))
        XCTAssertEqual(result, "0s")
    }

    func test_duration_max_units_1_hours_only() throws {
        let result = try duration(3661, options: DurationOptions(maxUnits: 1))
        XCTAssertEqual(result, "1 hour")
    }

    func test_duration_max_units_1_days_only() throws {
        let result = try duration(93600, options: DurationOptions(maxUnits: 1))
        XCTAssertEqual(result, "1 day")
    }

    func test_duration_max_units_3() throws {
        let result = try duration(93661, options: DurationOptions(maxUnits: 3))
        XCTAssertEqual(result, "1 day, 2 hours, 1 minute")
    }

    func test_duration_compact_max_units_1() throws {
        let result = try duration(9000, options: DurationOptions(compact: true, maxUnits: 1))
        XCTAssertEqual(result, "2h")
    }

    func test_duration_error_negative_seconds() throws {
        XCTAssertThrowsError(try duration(-100))
    }

    // MARK: - parse_duration tests

    func test_parseDuration_compact_hours_minutes() throws {
        let result = try parseDuration("2h30m")
        XCTAssertEqual(result, 9000)
    }

    func test_parseDuration_compact_with_space() throws {
        let result = try parseDuration("2h 30m")
        XCTAssertEqual(result, 9000)
    }

    func test_parseDuration_compact_with_comma() throws {
        let result = try parseDuration("2h, 30m")
        XCTAssertEqual(result, 9000)
    }

    func test_parseDuration_verbose() throws {
        let result = try parseDuration("2 hours 30 minutes")
        XCTAssertEqual(result, 9000)
    }

    func test_parseDuration_verbose_with_and() throws {
        let result = try parseDuration("2 hours and 30 minutes")
        XCTAssertEqual(result, 9000)
    }

    func test_parseDuration_verbose_with_comma_and() throws {
        let result = try parseDuration("2 hours, and 30 minutes")
        XCTAssertEqual(result, 9000)
    }

    func test_parseDuration_decimal_hours() throws {
        let result = try parseDuration("2.5 hours")
        XCTAssertEqual(result, 9000)
    }

    func test_parseDuration_decimal_compact() throws {
        let result = try parseDuration("1.5h")
        XCTAssertEqual(result, 5400)
    }

    func test_parseDuration_single_unit_minutes_verbose() throws {
        let result = try parseDuration("90 minutes")
        XCTAssertEqual(result, 5400)
    }

    func test_parseDuration_single_unit_minutes_compact() throws {
        let result = try parseDuration("90m")
        XCTAssertEqual(result, 5400)
    }

    func test_parseDuration_single_unit_min() throws {
        let result = try parseDuration("90min")
        XCTAssertEqual(result, 5400)
    }

    func test_parseDuration_colon_notation_h_mm() throws {
        let result = try parseDuration("2:30")
        XCTAssertEqual(result, 9000)
    }

    func test_parseDuration_colon_notation_h_mm_ss() throws {
        let result = try parseDuration("1:30:00")
        XCTAssertEqual(result, 5400)
    }

    func test_parseDuration_colon_notation_with_seconds() throws {
        let result = try parseDuration("0:05:30")
        XCTAssertEqual(result, 330)
    }

    func test_parseDuration_days_verbose() throws {
        let result = try parseDuration("2 days")
        XCTAssertEqual(result, 172800)
    }

    func test_parseDuration_days_compact() throws {
        let result = try parseDuration("2d")
        XCTAssertEqual(result, 172800)
    }

    func test_parseDuration_weeks_verbose() throws {
        let result = try parseDuration("1 week")
        XCTAssertEqual(result, 604800)
    }

    func test_parseDuration_weeks_compact() throws {
        let result = try parseDuration("1w")
        XCTAssertEqual(result, 604800)
    }

    func test_parseDuration_mixed_verbose() throws {
        let result = try parseDuration("1 day, 2 hours, and 30 minutes")
        XCTAssertEqual(result, 95400)
    }

    func test_parseDuration_mixed_compact() throws {
        let result = try parseDuration("1d 2h 30m")
        XCTAssertEqual(result, 95400)
    }

    func test_parseDuration_seconds_only_verbose() throws {
        let result = try parseDuration("45 seconds")
        XCTAssertEqual(result, 45)
    }

    func test_parseDuration_seconds_compact_s() throws {
        let result = try parseDuration("45s")
        XCTAssertEqual(result, 45)
    }

    func test_parseDuration_seconds_compact_sec() throws {
        let result = try parseDuration("45sec")
        XCTAssertEqual(result, 45)
    }

    func test_parseDuration_hours_hr() throws {
        let result = try parseDuration("2hr")
        XCTAssertEqual(result, 7200)
    }

    func test_parseDuration_hours_hrs() throws {
        let result = try parseDuration("2hrs")
        XCTAssertEqual(result, 7200)
    }

    func test_parseDuration_minutes_mins() throws {
        let result = try parseDuration("30mins")
        XCTAssertEqual(result, 1800)
    }

    func test_parseDuration_case_insensitive() throws {
        let result = try parseDuration("2H 30M")
        XCTAssertEqual(result, 9000)
    }

    func test_parseDuration_whitespace_tolerance() throws {
        let result = try parseDuration("  2 hours   30 minutes  ")
        XCTAssertEqual(result, 9000)
    }

    func test_parseDuration_error_empty_string() throws {
        XCTAssertThrowsError(try parseDuration(""))
    }

    func test_parseDuration_error_no_units() throws {
        XCTAssertThrowsError(try parseDuration("hello world"))
    }

    func test_parseDuration_error_negative() throws {
        XCTAssertThrowsError(try parseDuration("-5 hours"))
    }

    func test_parseDuration_error_just_number() throws {
        XCTAssertThrowsError(try parseDuration("42"))
    }

    // MARK: - human_date tests
    // Reference: 2024-01-15 00:00:00 UTC (Monday) = 1705276800

    func test_humanDate_today() throws {
        let result = try humanDate(1705276800, reference: 1705276800)
        XCTAssertEqual(result, "Today")
    }

    func test_humanDate_today_same_day_different_time() throws {
        let result = try humanDate(1705320000, reference: 1705276800)
        XCTAssertEqual(result, "Today")
    }

    func test_humanDate_yesterday() throws {
        let result = try humanDate(1705190400, reference: 1705276800)
        XCTAssertEqual(result, "Yesterday")
    }

    func test_humanDate_tomorrow() throws {
        let result = try humanDate(1705363200, reference: 1705276800)
        XCTAssertEqual(result, "Tomorrow")
    }

    func test_humanDate_last_Sunday_1_day_before_Monday() throws {
        let result = try humanDate(1705190400, reference: 1705276800)
        XCTAssertEqual(result, "Yesterday")
    }

    func test_humanDate_last_Saturday_2_days_ago() throws {
        let result = try humanDate(1705104000, reference: 1705276800)
        XCTAssertEqual(result, "Last Saturday")
    }

    func test_humanDate_last_Friday_3_days_ago() throws {
        let result = try humanDate(1705017600, reference: 1705276800)
        XCTAssertEqual(result, "Last Friday")
    }

    func test_humanDate_last_Thursday_4_days_ago() throws {
        let result = try humanDate(1704931200, reference: 1705276800)
        XCTAssertEqual(result, "Last Thursday")
    }

    func test_humanDate_last_Wednesday_5_days_ago() throws {
        let result = try humanDate(1704844800, reference: 1705276800)
        XCTAssertEqual(result, "Last Wednesday")
    }

    func test_humanDate_last_Tuesday_6_days_ago() throws {
        let result = try humanDate(1704758400, reference: 1705276800)
        XCTAssertEqual(result, "Last Tuesday")
    }

    func test_humanDate_last_Monday_7_days_ago_becomes_date() throws {
        let result = try humanDate(1704672000, reference: 1705276800)
        XCTAssertEqual(result, "January 8")
    }

    func test_humanDate_this_Tuesday_1_day_future() throws {
        let result = try humanDate(1705363200, reference: 1705276800)
        XCTAssertEqual(result, "Tomorrow")
    }

    func test_humanDate_this_Wednesday_2_days_future() throws {
        let result = try humanDate(1705449600, reference: 1705276800)
        XCTAssertEqual(result, "This Wednesday")
    }

    func test_humanDate_this_Thursday_3_days_future() throws {
        let result = try humanDate(1705536000, reference: 1705276800)
        XCTAssertEqual(result, "This Thursday")
    }

    func test_humanDate_this_Sunday_6_days_future() throws {
        let result = try humanDate(1705795200, reference: 1705276800)
        XCTAssertEqual(result, "This Sunday")
    }

    func test_humanDate_next_Monday_7_days_future_becomes_date() throws {
        let result = try humanDate(1705881600, reference: 1705276800)
        XCTAssertEqual(result, "January 22")
    }

    func test_humanDate_same_year_different_month() throws {
        let result = try humanDate(1709251200, reference: 1705276800)
        XCTAssertEqual(result, "March 1")
    }

    func test_humanDate_same_year_end_of_year() throws {
        let result = try humanDate(1735603200, reference: 1705276800)
        XCTAssertEqual(result, "December 31")
    }

    func test_humanDate_previous_year() throws {
        let result = try humanDate(1672531200, reference: 1705276800)
        XCTAssertEqual(result, "January 1, 2023")
    }

    func test_humanDate_next_year() throws {
        let result = try humanDate(1736121600, reference: 1705276800)
        XCTAssertEqual(result, "January 6, 2025")
    }

    // MARK: - date_range tests

    func test_dateRange_same_day() throws {
        let result = try dateRange(1705276800, 1705276800)
        XCTAssertEqual(result, "January 15, 2024")
    }

    func test_dateRange_same_day_different_times() throws {
        let result = try dateRange(1705276800, 1705320000)
        XCTAssertEqual(result, "January 15, 2024")
    }

    func test_dateRange_consecutive_days_same_month() throws {
        let result = try dateRange(1705276800, 1705363200)
        XCTAssertEqual(result, "January 15\u{2013}16, 2024")
    }

    func test_dateRange_same_month_range() throws {
        let result = try dateRange(1705276800, 1705881600)
        XCTAssertEqual(result, "January 15\u{2013}22, 2024")
    }

    func test_dateRange_same_year_different_months() throws {
        let result = try dateRange(1705276800, 1707955200)
        XCTAssertEqual(result, "January 15 \u{2013} February 15, 2024")
    }

    func test_dateRange_different_years() throws {
        let result = try dateRange(1703721600, 1705276800)
        XCTAssertEqual(result, "December 28, 2023 \u{2013} January 15, 2024")
    }

    func test_dateRange_full_year_span() throws {
        let result = try dateRange(1704067200, 1735603200)
        XCTAssertEqual(result, "January 1 \u{2013} December 31, 2024")
    }

    func test_dateRange_swapped_inputs_should_auto_correct() throws {
        let result = try dateRange(1705881600, 1705276800)
        XCTAssertEqual(result, "January 15\u{2013}22, 2024")
    }

    func test_dateRange_multi_year_span() throws {
        let result = try dateRange(1672531200, 1735689600)
        XCTAssertEqual(result, "January 1, 2023 \u{2013} January 1, 2025")
    }
}

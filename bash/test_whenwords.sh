#!/usr/bin/env bash
# Test suite for whenwords.sh
# Generated from tests.yaml

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/whenwords.sh"

TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test helper functions
pass() {
    ((TESTS_PASSED++))
    echo "  PASS: $1"
}

fail() {
    ((TESTS_FAILED++))
    echo "  FAIL: $1"
    echo "        Expected: $2"
    echo "        Got:      $3"
}

test_output() {
    local name="$1"
    local expected="$2"
    local actual="$3"
    ((TESTS_RUN++))
    if [[ "$expected" == "$actual" ]]; then
        pass "$name"
    else
        fail "$name" "$expected" "$actual"
    fi
}

test_error() {
    local name="$1"
    local result="$2"
    local exit_code="$3"
    ((TESTS_RUN++))
    if [[ $exit_code -ne 0 ]]; then
        pass "$name"
    else
        fail "$name" "error" "success with: $result"
    fi
}

echo "=========================================="
echo "whenwords.sh Test Suite"
echo "=========================================="

# ==========================================
# timeago tests
# ==========================================
echo ""
echo "Testing timeago..."

test_output "just now - identical timestamps" \
    "just now" \
    "$(timeago 1704067200 1704067200)"

test_output "just now - 30 seconds ago" \
    "just now" \
    "$(timeago 1704067170 1704067200)"

test_output "just now - 44 seconds ago" \
    "just now" \
    "$(timeago 1704067156 1704067200)"

test_output "1 minute ago - 45 seconds" \
    "1 minute ago" \
    "$(timeago 1704067155 1704067200)"

test_output "1 minute ago - 89 seconds" \
    "1 minute ago" \
    "$(timeago 1704067111 1704067200)"

test_output "2 minutes ago - 90 seconds" \
    "2 minutes ago" \
    "$(timeago 1704067110 1704067200)"

test_output "30 minutes ago" \
    "30 minutes ago" \
    "$(timeago 1704065400 1704067200)"

test_output "44 minutes ago" \
    "44 minutes ago" \
    "$(timeago 1704064560 1704067200)"

test_output "1 hour ago - 45 minutes" \
    "1 hour ago" \
    "$(timeago 1704064500 1704067200)"

test_output "1 hour ago - 89 minutes" \
    "1 hour ago" \
    "$(timeago 1704061860 1704067200)"

test_output "2 hours ago - 90 minutes" \
    "2 hours ago" \
    "$(timeago 1704061800 1704067200)"

test_output "5 hours ago" \
    "5 hours ago" \
    "$(timeago 1704049200 1704067200)"

test_output "21 hours ago" \
    "21 hours ago" \
    "$(timeago 1703991600 1704067200)"

test_output "1 day ago - 22 hours" \
    "1 day ago" \
    "$(timeago 1703988000 1704067200)"

test_output "1 day ago - 35 hours" \
    "1 day ago" \
    "$(timeago 1703941200 1704067200)"

test_output "2 days ago - 36 hours" \
    "2 days ago" \
    "$(timeago 1703937600 1704067200)"

test_output "7 days ago" \
    "7 days ago" \
    "$(timeago 1703462400 1704067200)"

test_output "25 days ago" \
    "25 days ago" \
    "$(timeago 1701907200 1704067200)"

test_output "1 month ago - 26 days" \
    "1 month ago" \
    "$(timeago 1701820800 1704067200)"

test_output "1 month ago - 45 days" \
    "1 month ago" \
    "$(timeago 1700179200 1704067200)"

test_output "2 months ago - 46 days" \
    "2 months ago" \
    "$(timeago 1700092800 1704067200)"

test_output "6 months ago" \
    "6 months ago" \
    "$(timeago 1688169600 1704067200)"

test_output "10 months ago - 319 days" \
    "10 months ago" \
    "$(timeago 1676505600 1704067200)"

test_output "1 year ago - 320 days" \
    "1 year ago" \
    "$(timeago 1676419200 1704067200)"

test_output "1 year ago - 547 days" \
    "1 year ago" \
    "$(timeago 1656806400 1704067200)"

test_output "2 years ago - 548 days" \
    "2 years ago" \
    "$(timeago 1656720000 1704067200)"

test_output "5 years ago" \
    "5 years ago" \
    "$(timeago 1546300800 1704067200)"

test_output "future - in just now (30 seconds)" \
    "just now" \
    "$(timeago 1704067230 1704067200)"

test_output "future - in 1 minute" \
    "in 1 minute" \
    "$(timeago 1704067260 1704067200)"

test_output "future - in 5 minutes" \
    "in 5 minutes" \
    "$(timeago 1704067500 1704067200)"

test_output "future - in 1 hour" \
    "in 1 hour" \
    "$(timeago 1704070200 1704067200)"

test_output "future - in 3 hours" \
    "in 3 hours" \
    "$(timeago 1704078000 1704067200)"

test_output "future - in 1 day" \
    "in 1 day" \
    "$(timeago 1704150000 1704067200)"

test_output "future - in 2 days" \
    "in 2 days" \
    "$(timeago 1704240000 1704067200)"

test_output "future - in 1 month" \
    "in 1 month" \
    "$(timeago 1706745600 1704067200)"

test_output "future - in 1 year" \
    "in 1 year" \
    "$(timeago 1735689600 1704067200)"

# ==========================================
# duration tests
# ==========================================
echo ""
echo "Testing duration..."

test_output "zero seconds" \
    "0 seconds" \
    "$(duration 0)"

test_output "1 second" \
    "1 second" \
    "$(duration 1)"

test_output "45 seconds" \
    "45 seconds" \
    "$(duration 45)"

test_output "1 minute" \
    "1 minute" \
    "$(duration 60)"

test_output "1 minute 30 seconds" \
    "1 minute, 30 seconds" \
    "$(duration 90)"

test_output "2 minutes" \
    "2 minutes" \
    "$(duration 120)"

test_output "1 hour" \
    "1 hour" \
    "$(duration 3600)"

test_output "1 hour 1 minute" \
    "1 hour, 1 minute" \
    "$(duration 3661)"

test_output "1 hour 30 minutes" \
    "1 hour, 30 minutes" \
    "$(duration 5400)"

test_output "2 hours 30 minutes" \
    "2 hours, 30 minutes" \
    "$(duration 9000)"

test_output "1 day" \
    "1 day" \
    "$(duration 86400)"

test_output "1 day 2 hours" \
    "1 day, 2 hours" \
    "$(duration 93600)"

test_output "7 days" \
    "7 days" \
    "$(duration 604800)"

test_output "1 month (30 days)" \
    "1 month" \
    "$(duration 2592000)"

test_output "1 year (365 days)" \
    "1 year" \
    "$(duration 31536000)"

test_output "1 year 2 months" \
    "1 year, 2 months" \
    "$(duration 36720000)"

test_output "compact - 1h 1m" \
    "1h 1m" \
    "$(duration 3661 true)"

test_output "compact - 2h 30m" \
    "2h 30m" \
    "$(duration 9000 true)"

test_output "compact - 1d 2h" \
    "1d 2h" \
    "$(duration 93600 true)"

test_output "compact - 45s" \
    "45s" \
    "$(duration 45 true)"

test_output "compact - 0s" \
    "0s" \
    "$(duration 0 true)"

test_output "max_units 1 - hours only" \
    "1 hour" \
    "$(duration 3661 false 1)"

test_output "max_units 1 - days only" \
    "1 day" \
    "$(duration 93600 false 1)"

test_output "max_units 3" \
    "1 day, 2 hours, 1 minute" \
    "$(duration 93661 false 3)"

test_output "compact max_units 1" \
    "2h" \
    "$(duration 9000 true 1)"

# Test error case
result=$(duration -100 2>&1) || exit_code=$?
test_error "error - negative seconds" "$result" "${exit_code:-0}"

# ==========================================
# parse_duration tests
# ==========================================
echo ""
echo "Testing parse_duration..."

test_output "compact hours minutes" \
    "9000" \
    "$(parse_duration "2h30m")"

test_output "compact with space" \
    "9000" \
    "$(parse_duration "2h 30m")"

test_output "compact with comma" \
    "9000" \
    "$(parse_duration "2h, 30m")"

test_output "verbose" \
    "9000" \
    "$(parse_duration "2 hours 30 minutes")"

test_output "verbose with and" \
    "9000" \
    "$(parse_duration "2 hours and 30 minutes")"

test_output "verbose with comma and" \
    "9000" \
    "$(parse_duration "2 hours, and 30 minutes")"

test_output "decimal hours" \
    "9000" \
    "$(parse_duration "2.5 hours")"

test_output "decimal compact" \
    "5400" \
    "$(parse_duration "1.5h")"

test_output "single unit minutes verbose" \
    "5400" \
    "$(parse_duration "90 minutes")"

test_output "single unit minutes compact" \
    "5400" \
    "$(parse_duration "90m")"

test_output "single unit min" \
    "5400" \
    "$(parse_duration "90min")"

test_output "colon notation h:mm" \
    "9000" \
    "$(parse_duration "2:30")"

test_output "colon notation h:mm:ss" \
    "5400" \
    "$(parse_duration "1:30:00")"

test_output "colon notation with seconds" \
    "330" \
    "$(parse_duration "0:05:30")"

test_output "days verbose" \
    "172800" \
    "$(parse_duration "2 days")"

test_output "days compact" \
    "172800" \
    "$(parse_duration "2d")"

test_output "weeks verbose" \
    "604800" \
    "$(parse_duration "1 week")"

test_output "weeks compact" \
    "604800" \
    "$(parse_duration "1w")"

test_output "mixed verbose" \
    "95400" \
    "$(parse_duration "1 day, 2 hours, and 30 minutes")"

test_output "mixed compact" \
    "95400" \
    "$(parse_duration "1d 2h 30m")"

test_output "seconds only verbose" \
    "45" \
    "$(parse_duration "45 seconds")"

test_output "seconds compact s" \
    "45" \
    "$(parse_duration "45s")"

test_output "seconds compact sec" \
    "45" \
    "$(parse_duration "45sec")"

test_output "hours hr" \
    "7200" \
    "$(parse_duration "2hr")"

test_output "hours hrs" \
    "7200" \
    "$(parse_duration "2hrs")"

test_output "minutes mins" \
    "1800" \
    "$(parse_duration "30mins")"

test_output "case insensitive" \
    "9000" \
    "$(parse_duration "2H 30M")"

test_output "whitespace tolerance" \
    "9000" \
    "$(parse_duration "  2 hours   30 minutes  ")"

# Error cases
exit_code=0
result=$(parse_duration "" 2>&1) || exit_code=$?
test_error "error - empty string" "$result" "$exit_code"

exit_code=0
result=$(parse_duration "hello world" 2>&1) || exit_code=$?
test_error "error - no units" "$result" "$exit_code"

exit_code=0
result=$(parse_duration "-5 hours" 2>&1) || exit_code=$?
test_error "error - negative" "$result" "$exit_code"

exit_code=0
result=$(parse_duration "42" 2>&1) || exit_code=$?
test_error "error - just number" "$result" "$exit_code"

# ==========================================
# human_date tests
# ==========================================
echo ""
echo "Testing human_date..."

# Reference: 2024-01-15 00:00:00 UTC (Monday) = 1705276800

test_output "today" \
    "Today" \
    "$(human_date 1705276800 1705276800)"

test_output "today - same day different time" \
    "Today" \
    "$(human_date 1705320000 1705276800)"

test_output "yesterday" \
    "Yesterday" \
    "$(human_date 1705190400 1705276800)"

test_output "tomorrow" \
    "Tomorrow" \
    "$(human_date 1705363200 1705276800)"

test_output "last Saturday (2 days ago)" \
    "Last Saturday" \
    "$(human_date 1705104000 1705276800)"

test_output "last Friday (3 days ago)" \
    "Last Friday" \
    "$(human_date 1705017600 1705276800)"

test_output "last Thursday (4 days ago)" \
    "Last Thursday" \
    "$(human_date 1704931200 1705276800)"

test_output "last Wednesday (5 days ago)" \
    "Last Wednesday" \
    "$(human_date 1704844800 1705276800)"

test_output "last Tuesday (6 days ago)" \
    "Last Tuesday" \
    "$(human_date 1704758400 1705276800)"

test_output "last Monday (7 days ago) - becomes date" \
    "January 8" \
    "$(human_date 1704672000 1705276800)"

test_output "this Wednesday (2 days future)" \
    "This Wednesday" \
    "$(human_date 1705449600 1705276800)"

test_output "this Thursday (3 days future)" \
    "This Thursday" \
    "$(human_date 1705536000 1705276800)"

test_output "this Sunday (6 days future)" \
    "This Sunday" \
    "$(human_date 1705795200 1705276800)"

test_output "next Monday (7 days future) - becomes date" \
    "January 22" \
    "$(human_date 1705881600 1705276800)"

test_output "same year different month" \
    "March 1" \
    "$(human_date 1709251200 1705276800)"

test_output "same year end of year" \
    "December 31" \
    "$(human_date 1735603200 1705276800)"

test_output "previous year" \
    "January 1, 2023" \
    "$(human_date 1672531200 1705276800)"

test_output "next year" \
    "January 6, 2025" \
    "$(human_date 1736121600 1705276800)"

# ==========================================
# date_range tests
# ==========================================
echo ""
echo "Testing date_range..."

test_output "same day" \
    "January 15, 2024" \
    "$(date_range 1705276800 1705276800)"

test_output "same day different times" \
    "January 15, 2024" \
    "$(date_range 1705276800 1705320000)"

test_output "consecutive days same month" \
    "January 15–16, 2024" \
    "$(date_range 1705276800 1705363200)"

test_output "same month range" \
    "January 15–22, 2024" \
    "$(date_range 1705276800 1705881600)"

test_output "same year different months" \
    "January 15 – February 15, 2024" \
    "$(date_range 1705276800 1707955200)"

test_output "different years" \
    "December 28, 2023 – January 15, 2024" \
    "$(date_range 1703721600 1705276800)"

test_output "full year span" \
    "January 1 – December 31, 2024" \
    "$(date_range 1704067200 1735603200)"

test_output "swapped inputs - should auto-correct" \
    "January 15–22, 2024" \
    "$(date_range 1705881600 1705276800)"

test_output "multi-year span" \
    "January 1, 2023 – January 1, 2025" \
    "$(date_range 1672531200 1735689600)"

# ==========================================
# Summary
# ==========================================
echo ""
echo "=========================================="
echo "Test Results"
echo "=========================================="
echo "Total:  $TESTS_RUN"
echo "Passed: $TESTS_PASSED"
echo "Failed: $TESTS_FAILED"
echo "=========================================="

if [[ $TESTS_FAILED -gt 0 ]]; then
    exit 1
fi

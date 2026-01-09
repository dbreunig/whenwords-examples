# whenwords for Excel

Human-friendly time formatting and parsing for Microsoft Excel.

## Requirements

- **Excel 365** or **Excel for Web** (LAMBDA function support required)
- **TEXTSPLIT function** (Excel 365 September 2022 or later) for `WW_PARSE_DURATION`

## Installation

1. Open your Excel workbook
2. Go to **Formulas > Name Manager** (or press `Ctrl+F3`)
3. For each function, click **New** and:
   - **Name:** Enter the function name (e.g., `WW_TIMEAGO`)
   - **Refers to:** Paste the formula from `whenwords.txt`
   - **Comment:** Optional description
4. Click **OK** for each function, then **Close**

**Important:** Add helper functions first: `WW_PLURALIZE`, `WW_UNIX_TO_DATE`, `WW_DATE_TO_UNIX`, `WW_ABS_ROUND`

## Quick Start

```excel
=WW_TIMEAGO(1704067110, 1704067200)
→ "2 minutes ago"

=WW_DURATION(3661)
→ "1 hour, 1 minute"

=WW_PARSE_DURATION("2h 30m")
→ 9000

=WW_HUMAN_DATE(1705190400, 1705276800)
→ "Yesterday"

=WW_DATE_RANGE(1705276800, 1705881600)
→ "January 15–22, 2024"
```

## Functions

### WW_TIMEAGO(timestamp, reference)

Returns a human-readable relative time string.

**Parameters:**
- `timestamp` - Unix timestamp (seconds since 1970-01-01)
- `reference` - Reference Unix timestamp to compare against

**Examples:**
```excel
=WW_TIMEAGO(A2, NOW()*86400+DATE(1970,1,1))  ' Using current time
=WW_TIMEAGO(1704067110, 1704067200)          ' "2 minutes ago"
=WW_TIMEAGO(1704067260, 1704067200)          ' "in 1 minute"
```

**Output patterns:**
- `"just now"` (0-44 seconds)
- `"1 minute ago"` / `"in 1 minute"` (45-89 seconds)
- `"{n} minutes ago"` / `"in {n} minutes"` (90 sec - 44 min)
- `"1 hour ago"` / `"in 1 hour"` (45-89 minutes)
- `"{n} hours ago"` / `"in {n} hours"` (90 min - 21 hours)
- `"1 day ago"` / `"in 1 day"` (22-35 hours)
- `"{n} days ago"` / `"in {n} days"` (36 hours - 25 days)
- `"{n} months ago"` / `"in {n} months"` (26-319 days)
- `"{n} years ago"` / `"in {n} years"` (320+ days)

### WW_DURATION(seconds, [compact], [max_units])

Formats a duration in seconds to a human-readable string.

**Parameters:**
- `seconds` - Number of seconds (non-negative)
- `compact` - Optional. `TRUE` for short format "2h 30m", default `FALSE`
- `max_units` - Optional. Maximum units to display (1-6), default `2`

**Examples:**
```excel
=WW_DURATION(3661)              ' "1 hour, 1 minute"
=WW_DURATION(3661, TRUE)        ' "1h 1m"
=WW_DURATION(3661, FALSE, 1)    ' "1 hour"
=WW_DURATION(93661, FALSE, 3)   ' "1 day, 2 hours, 1 minute"
=WW_DURATION(0)                 ' "0 seconds"
```

### WW_PARSE_DURATION(text)

Parses a human-written duration string into seconds.

**Parameters:**
- `text` - Duration string to parse

**Accepted formats:**
- Compact: `"2h30m"`, `"2h 30m"`, `"2h, 30m"`
- Verbose: `"2 hours 30 minutes"`, `"2 hours and 30 minutes"`
- Decimal: `"2.5 hours"`, `"1.5h"`
- Colon: `"2:30"` (h:mm), `"1:30:00"` (h:mm:ss)

**Unit aliases:**
- seconds: `s`, `sec`, `secs`, `second`, `seconds`
- minutes: `m`, `min`, `mins`, `minute`, `minutes`
- hours: `h`, `hr`, `hrs`, `hour`, `hours`
- days: `d`, `day`, `days`
- weeks: `w`, `wk`, `wks`, `week`, `weeks`

**Examples:**
```excel
=WW_PARSE_DURATION("2h 30m")                  ' 9000
=WW_PARSE_DURATION("2:30")                    ' 9000
=WW_PARSE_DURATION("2 hours and 30 minutes")  ' 9000
=WW_PARSE_DURATION("1.5h")                    ' 5400
```

### WW_HUMAN_DATE(timestamp, reference)

Returns a contextual date string.

**Parameters:**
- `timestamp` - Unix timestamp to describe
- `reference` - Reference Unix timestamp ("today")

**Examples:**
```excel
=WW_HUMAN_DATE(1705276800, 1705276800)  ' "Today"
=WW_HUMAN_DATE(1705190400, 1705276800)  ' "Yesterday"
=WW_HUMAN_DATE(1705363200, 1705276800)  ' "Tomorrow"
=WW_HUMAN_DATE(1705104000, 1705276800)  ' "Last Saturday"
=WW_HUMAN_DATE(1709251200, 1705276800)  ' "March 1"
```

**Output patterns:**
- `"Today"` - Same calendar day
- `"Yesterday"` - Previous day
- `"Tomorrow"` - Next day
- `"Last {weekday}"` - Within past 7 days
- `"This {weekday}"` - Within next 7 days
- `"{Month} {day}"` - Same year
- `"{Month} {day}, {year}"` - Different year

### WW_DATE_RANGE(start, end)

Formats a date range with smart abbreviation.

**Parameters:**
- `start` - Start Unix timestamp
- `end` - End Unix timestamp (auto-swapped if before start)

**Examples:**
```excel
=WW_DATE_RANGE(1705276800, 1705276800)   ' "January 15, 2024"
=WW_DATE_RANGE(1705276800, 1705363200)   ' "January 15–16, 2024"
=WW_DATE_RANGE(1705276800, 1707955200)   ' "January 15 – February 15, 2024"
=WW_DATE_RANGE(1703721600, 1705276800)   ' "December 28, 2023 – January 15, 2024"
```

## Error Handling

Functions return error strings for invalid input:
- `WW_DURATION` with negative seconds: `"ERROR: Negative duration"`
- `WW_PARSE_DURATION` with empty string: `"#ERROR: Empty string"`
- `WW_PARSE_DURATION` with no units: `"#ERROR: No valid units"`
- `WW_PARSE_DURATION` with negative: `"#ERROR: Negative duration"`

Use `ISERROR()` or `IFERROR()` to handle errors:
```excel
=IFERROR(WW_PARSE_DURATION(A1), "Invalid duration")
```

## Working with Excel Dates

Excel stores dates as serial numbers. To convert:

```excel
' Excel date to Unix timestamp
=WW_DATE_TO_UNIX(A1)

' Unix timestamp to Excel date
=WW_UNIX_TO_DATE(A1)

' Use current time as reference
=WW_TIMEAGO(unix_timestamp, (NOW()-DATE(1970,1,1))*86400)
```

## Testing

Generate the test workbook:
```bash
cd examples/excel
pip install openpyxl pyyaml
python generate_test_workbook.py
```

This creates `test_whenwords.xlsx` with all test cases. After adding the LAMBDA functions, open the Tests sheet to verify all tests pass.

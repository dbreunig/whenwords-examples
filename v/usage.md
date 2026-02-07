# whenwords for V

Human-friendly time formatting and parsing for the V programming language.

## Installation

Copy the `whenwords.v` file into your project or import it as a module:

```v
import whenwords
```

## Quick start

```v
import whenwords
import time

fn main() {
    now := time.now().unix()
    past := now - 3600

    // Relative time
    println(whenwords.timeago(past, now))  // "1 hour ago"

    // Duration formatting
    duration := whenwords.duration(3661, whenwords.DurationOptions{})!
    println(duration)  // "1 hour, 1 minute"

    // Parse duration strings
    seconds := whenwords.parse_duration('2h 30m')!
    println(seconds)  // 9000

    // Contextual dates
    println(whenwords.human_date(past, now))  // "Today" or relative date

    // Date ranges
    start := time.parse('2024-01-01')!.unix()
    end := time.parse('2024-01-15')!.unix()
    println(whenwords.date_range(start, end))  // "January 1–15, 2024"
}
```

## Functions

### timeago(timestamp i64, reference i64) string

Returns a human-readable relative time string comparing two Unix timestamps.

**Parameters:**
- `timestamp`: The time to format (Unix seconds)
- `reference`: The reference time to compare against (Unix seconds)

**Examples:**
```v
now := 1704067200
past := now - 3600
println(whenwords.timeago(past, now))  // "1 hour ago"

future := now + 7200
println(whenwords.timeago(future, now))  // "in 2 hours"
```

### duration(seconds i64, options DurationOptions) !string

Formats a duration in seconds as a human-readable string.

**Parameters:**
- `seconds`: Duration in seconds (must be non-negative)
- `options`: Configuration struct with fields:
  - `compact`: If true, uses short format like "2h 30m" (default: false)
  - `max_units`: Maximum number of units to display (default: 2)

**Examples:**
```v
// Standard format
d1 := whenwords.duration(3661, whenwords.DurationOptions{})!
println(d1)  // "1 hour, 1 minute"

// Compact format
d2 := whenwords.duration(3661, whenwords.DurationOptions{ compact: true })!
println(d2)  // "1h 1m"

// Limit units
d3 := whenwords.duration(93661, whenwords.DurationOptions{ max_units: 1 })!
println(d3)  // "1 day"
```

### parse_duration(input string) !i64

Parses a human-written duration string into seconds.

**Parameters:**
- `input`: Duration string (e.g., "2h30m", "2 hours 30 minutes", "2:30")

**Supported formats:**
- Compact: `2h30m`, `2h 30m`
- Verbose: `2 hours 30 minutes`, `2 hours and 30 minutes`
- Decimal: `2.5 hours`, `1.5h`
- Colon notation: `2:30` (h:mm), `1:30:00` (h:mm:ss)

**Unit aliases:**
- seconds: s, sec, secs, second, seconds
- minutes: m, min, mins, minute, minutes
- hours: h, hr, hrs, hour, hours
- days: d, day, days
- weeks: w, wk, wks, week, weeks

**Examples:**
```v
s1 := whenwords.parse_duration('2h 30m')!
println(s1)  // 9000

s2 := whenwords.parse_duration('1.5 hours')!
println(s2)  // 5400

s3 := whenwords.parse_duration('2:30')!
println(s3)  // 9000
```

### human_date(timestamp i64, reference i64) string

Returns a contextual date string based on proximity to the reference date.

**Parameters:**
- `timestamp`: The date to format (Unix seconds)
- `reference`: The reference date for comparison (Unix seconds)

**Output format:**
- Same day: "Today"
- Previous day: "Yesterday"
- Next day: "Tomorrow"
- Within past 7 days: "Last {weekday}"
- Within next 7 days: "This {weekday}"
- Same year: "{Month} {day}"
- Different year: "{Month} {day}, {year}"

**Examples:**
```v
ref := 1705276800  // 2024-01-15 (Monday)

println(whenwords.human_date(ref, ref))  // "Today"
println(whenwords.human_date(ref - 86400, ref))  // "Yesterday"
println(whenwords.human_date(ref - 2*86400, ref))  // "Last Saturday"
```

### date_range(start i64, end i64) string

Formats a date range with smart abbreviation.

**Parameters:**
- `start`: Start timestamp (Unix seconds)
- `end`: End timestamp (Unix seconds)

**Format rules:**
- Same day: "March 5, 2024"
- Same month: "March 5–7, 2024"
- Same year: "March 5 – April 7, 2024"
- Different years: "December 28, 2024 – January 3, 2025"

**Examples:**
```v
start := 1705276800  // Jan 15, 2024
end := 1705881600    // Jan 22, 2024

println(whenwords.date_range(start, end))  // "January 15–22, 2024"

// Swapped inputs are auto-corrected
println(whenwords.date_range(end, start))  // "January 15–22, 2024"
```

## Error handling

Functions that can fail return V's Result type (`!string` or `!i64`). Use the `!` operator or explicit error handling:

```v
// Propagate errors with !
seconds := whenwords.parse_duration('2h 30m')!

// Or handle errors explicitly
result := whenwords.parse_duration('invalid') or {
    eprintln('Parse error: ${err}')
    return
}
```

**Error conditions:**
- `duration`: Negative seconds
- `parse_duration`: Empty string, no parseable units, negative values

## Accepted types

All timestamp parameters accept Unix seconds as `i64`. To convert from V's `time.Time`:

```v
import time

t := time.now()
unix_timestamp := t.unix()
result := whenwords.timeago(unix_timestamp, time.now().unix())
```

All functions are pure and deterministic—they never access the system clock. The reference time must always be passed explicitly.

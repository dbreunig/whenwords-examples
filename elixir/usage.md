# whenwords for Elixir

Human-friendly time formatting and parsing.

## Installation

Add the module to your project by copying `lib/whenwords.ex` into your `lib/` directory.

```elixir
# In your code
alias Whenwords
```

## Quick start

```elixir
# Relative time
Whenwords.timeago(past_timestamp, DateTime.to_unix(DateTime.utc_now()))
# => "3 hours ago"

# Duration formatting
Whenwords.duration(3661)
# => "1 hour, 1 minute"

# Parse human durations
Whenwords.parse_duration("2h 30m")
# => 9000

# Contextual dates
Whenwords.human_date(yesterday_ts, now_ts)
# => "Yesterday"

# Date ranges
Whenwords.date_range(start_ts, end_ts)
# => "January 15–22, 2024"
```

## Functions

### timeago(timestamp, reference) -> String.t()

Returns a human-readable relative time string.

```elixir
Whenwords.timeago(1704067110, 1704067200)
# => "2 minutes ago"

Whenwords.timeago(1704067500, 1704067200)
# => "in 5 minutes"
```

**Parameters:**
- `timestamp` - Unix timestamp (integer/float), DateTime, NaiveDateTime, or ISO 8601 string
- `reference` - Reference timestamp for comparison (same types accepted)

### duration(seconds, options \\ %{}) -> String.t()

Formats a duration in seconds to a human-readable string.

```elixir
Whenwords.duration(3661)
# => "1 hour, 1 minute"

Whenwords.duration(3661, %{compact: true})
# => "1h 1m"

Whenwords.duration(93661, %{max_units: 3})
# => "1 day, 2 hours, 1 minute"
```

**Parameters:**
- `seconds` - Non-negative number of seconds
- `options` - Map with optional keys:
  - `:compact` - Use short format like "2h 30m" (default: false)
  - `:max_units` - Maximum units to display (default: 2)

### parse_duration(string) -> integer()

Parses a human-written duration string into seconds.

```elixir
Whenwords.parse_duration("2h30m")
# => 9000

Whenwords.parse_duration("2 hours and 30 minutes")
# => 9000

Whenwords.parse_duration("1:30:00")
# => 5400
```

**Accepted formats:**
- Compact: "2h30m", "2h 30m", "1d 2h"
- Verbose: "2 hours 30 minutes", "2 hours and 30 minutes"
- Decimal: "2.5 hours", "1.5h"
- Colon: "2:30" (h:mm), "1:30:00" (h:mm:ss)

### human_date(timestamp, reference) -> String.t()

Returns a contextual date string.

```elixir
Whenwords.human_date(1705276800, 1705276800)
# => "Today"

Whenwords.human_date(1705190400, 1705276800)
# => "Yesterday"

Whenwords.human_date(1709251200, 1705276800)
# => "March 1"
```

**Parameters:**
- `timestamp` - The date to format
- `reference` - The "current" date for context

### date_range(start_ts, end_ts) -> String.t()

Formats a date range with smart abbreviation.

```elixir
Whenwords.date_range(1705276800, 1705881600)
# => "January 15–22, 2024"

Whenwords.date_range(1705276800, 1707955200)
# => "January 15 – February 15, 2024"
```

**Parameters:**
- `start_ts` - Start timestamp
- `end_ts` - End timestamp (auto-swapped if before start)

## Error handling

All functions raise `ArgumentError` for invalid inputs:

```elixir
try do
  Whenwords.parse_duration("")
rescue
  ArgumentError -> "Handle empty input"
end

try do
  Whenwords.duration(-100)
rescue
  ArgumentError -> "Handle negative seconds"
end
```

## Accepted types

All timestamp parameters accept:
- `integer` - Unix timestamp in seconds
- `float` - Unix timestamp with fractional seconds
- `DateTime` - Elixir DateTime struct
- `NaiveDateTime` - Elixir NaiveDateTime (treated as UTC)
- `String` - ISO 8601 formatted string

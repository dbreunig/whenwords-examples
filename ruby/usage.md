# whenwords for Ruby

Human-friendly time formatting and parsing.

## Installation

Copy `whenwords.rb` into your project and require it:

```ruby
require_relative 'whenwords'
```

## Quick start

```ruby
require_relative 'whenwords'

now = Time.now.to_i
past = now - 3600

puts Whenwords.timeago(past, now)           # "1 hour ago"
puts Whenwords.duration(3661)               # "1 hour, 1 minute"
puts Whenwords.parse_duration("2h 30m")     # 9000
puts Whenwords.human_date(past, now)        # "Today"
puts Whenwords.date_range(now, now + 86400) # "January 9–10, 2026"
```

## Functions

### timeago(timestamp, reference = nil) -> String

Returns a human-readable relative time string.

```ruby
Whenwords.timeago(1704067110, 1704067200)  # "2 minutes ago"
Whenwords.timeago(1704070200, 1704067200)  # "in 1 hour"
```

**Parameters:**
- `timestamp` - Unix timestamp (Integer/Float), Time, DateTime, Date, or ISO 8601 string
- `reference` - Optional reference timestamp (defaults to timestamp, returning "just now")

### duration(seconds, options = {}) -> String

Formats a duration in seconds to a human-readable string.

```ruby
Whenwords.duration(3661)                          # "1 hour, 1 minute"
Whenwords.duration(3661, compact: true)           # "1h 1m"
Whenwords.duration(93661, max_units: 3)           # "1 day, 2 hours, 1 minute"
Whenwords.duration(9000, compact: true, max_units: 1)  # "2h"
```

**Parameters:**
- `seconds` - Non-negative number of seconds
- `options` - Hash with optional keys:
  - `:compact` - Boolean (default false). Use short format like "2h 30m"
  - `:max_units` - Integer (default 2). Maximum units to display

### parse_duration(string) -> Integer

Parses a human-written duration string into seconds.

```ruby
Whenwords.parse_duration("2h30m")              # 9000
Whenwords.parse_duration("2 hours 30 minutes") # 9000
Whenwords.parse_duration("2.5 hours")          # 9000
Whenwords.parse_duration("2:30")               # 9000 (h:mm format)
Whenwords.parse_duration("1:30:00")            # 5400 (h:mm:ss format)
```

**Accepted units:** s/sec/seconds, m/min/minutes, h/hr/hours, d/day/days, w/wk/weeks

### human_date(timestamp, reference) -> String

Returns a contextual date string relative to a reference date.

```ruby
Whenwords.human_date(1705276800, 1705276800)  # "Today"
Whenwords.human_date(1705190400, 1705276800)  # "Yesterday"
Whenwords.human_date(1705363200, 1705276800)  # "Tomorrow"
Whenwords.human_date(1705104000, 1705276800)  # "Last Saturday"
Whenwords.human_date(1709251200, 1705276800)  # "March 1"
```

**Parameters:**
- `timestamp` - The date to format
- `reference` - The "current" date for comparison

### date_range(start, end) -> String

Formats a date range with smart abbreviation.

```ruby
Whenwords.date_range(1705276800, 1705276800)  # "January 15, 2024"
Whenwords.date_range(1705276800, 1705881600)  # "January 15–22, 2024"
Whenwords.date_range(1705276800, 1707955200)  # "January 15 – February 15, 2024"
Whenwords.date_range(1703721600, 1705276800)  # "December 28, 2023 – January 15, 2024"
```

**Parameters:**
- `start` - Start timestamp
- `end` - End timestamp (swapped automatically if before start)

## Error handling

All functions raise `ArgumentError` for invalid inputs:

```ruby
begin
  Whenwords.duration(-100)
rescue ArgumentError => e
  puts e.message  # "Seconds cannot be negative"
end

begin
  Whenwords.parse_duration("")
rescue ArgumentError => e
  puts e.message  # "Duration string cannot be empty"
end
```

## Accepted types

All timestamp parameters accept:
- `Integer` or `Float` - Unix timestamp in seconds
- `Time` - Ruby Time object
- `DateTime` - Ruby DateTime object
- `Date` - Ruby Date object (converted to midnight UTC)
- `String` - ISO 8601 formatted string (e.g., "2024-01-01T00:00:00Z")

```ruby
Whenwords.timeago(Time.now - 3600, Time.now)
Whenwords.timeago(DateTime.now - 1, DateTime.now)
Whenwords.timeago("2024-01-01T00:00:00Z", "2024-01-01T01:00:00Z")
```

# whenwords for Bash

Human-friendly time formatting and parsing.

## Installation

Source the library in your script:

```bash
source /path/to/whenwords.sh
```

## Quick start

```bash
source whenwords.sh

# Relative time
now=$(date +%s)
past=$((now - 3600))
timeago "$past" "$now"  # "1 hour ago"

# Format durations
duration 3661           # "1 hour, 1 minute"
duration 3661 true      # "1h 1m"

# Parse durations
parse_duration "2h 30m"  # 9000

# Human dates
human_date "$past" "$now"  # "Today" or "Yesterday" etc.

# Date ranges
date_range 1705276800 1705881600  # "January 15-22, 2024"
```

## Functions

### timeago timestamp [reference] -> string

Returns a human-readable relative time string.

**Parameters:**
- `timestamp` - Unix timestamp (seconds)
- `reference` - Optional reference timestamp (defaults to timestamp)

**Examples:**
```bash
now=$(date +%s)
past=$((now - 90))
timeago "$past" "$now"     # "2 minutes ago"

future=$((now + 3600))
timeago "$future" "$now"   # "in 1 hour"
```

### duration seconds [compact] [max_units] -> string

Formats a duration in seconds to a human-readable string.

**Parameters:**
- `seconds` - Non-negative integer
- `compact` - "true" for short format (e.g., "2h 30m"), default "false"
- `max_units` - Maximum number of units to display (default 2)

**Examples:**
```bash
duration 3661              # "1 hour, 1 minute"
duration 3661 true         # "1h 1m"
duration 3661 false 1      # "1 hour"
duration 93661 false 3     # "1 day, 2 hours, 1 minute"
```

### parse_duration string -> number

Parses a human-written duration string into seconds.

**Parameters:**
- `string` - Duration string in various formats

**Accepted formats:**
- Compact: "2h30m", "2h 30m", "1d 2h"
- Verbose: "2 hours 30 minutes", "2 hours and 30 minutes"
- Decimal: "2.5 hours", "1.5h"
- Colon: "2:30" (h:mm), "1:30:00" (h:mm:ss)
- Single unit: "90 minutes", "90m", "2 days"

**Examples:**
```bash
parse_duration "2h 30m"           # 9000
parse_duration "2 hours 30 minutes"  # 9000
parse_duration "2:30"             # 9000
parse_duration "1.5h"             # 5400
```

### human_date timestamp reference -> string

Returns a contextual date string.

**Parameters:**
- `timestamp` - Unix timestamp to format
- `reference` - Reference timestamp for comparison

**Examples:**
```bash
ref=1705276800  # 2024-01-15 (Monday)

human_date "$ref" "$ref"                    # "Today"
human_date $((ref - 86400)) "$ref"          # "Yesterday"
human_date $((ref + 86400)) "$ref"          # "Tomorrow"
human_date $((ref - 2*86400)) "$ref"        # "Last Saturday"
human_date $((ref + 2*86400)) "$ref"        # "This Wednesday"
human_date 1709251200 "$ref"                # "March 1"
human_date 1672531200 "$ref"                # "January 1, 2023"
```

### date_range start end -> string

Formats a date range with smart abbreviation.

**Parameters:**
- `start` - Start timestamp
- `end` - End timestamp (auto-swapped if before start)

**Examples:**
```bash
date_range 1705276800 1705276800    # "January 15, 2024"
date_range 1705276800 1705363200    # "January 15-16, 2024"
date_range 1705276800 1707955200    # "January 15 - February 15, 2024"
date_range 1703721600 1705276800    # "December 28, 2023 - January 15, 2024"
```

## Error handling

Functions return exit code 1 and print to stderr on error:

```bash
if ! result=$(parse_duration "invalid"); then
    echo "Parse failed"
fi

if ! result=$(duration -100); then
    echo "Duration failed"  # negative seconds not allowed
fi
```

## Accepted types

All functions accept Unix timestamps as integers. Bash doesn't have native datetime types, so convert dates using:

```bash
# Current time
now=$(date +%s)

# Specific date (macOS)
ts=$(date -j -f '%Y-%m-%d %H:%M:%S' '2024-01-15 00:00:00' +%s)

# Specific date (Linux)
ts=$(date -d '2024-01-15 00:00:00' +%s)
```

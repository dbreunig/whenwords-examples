# whenwords for Haxe

Human-friendly time formatting and parsing.

## Installation

Copy the `Whenwords.hx` file into your project's source directory. The library is a single class with static methods that can be used anywhere in your code.

```haxe
import Whenwords;
```

## Quick start

```haxe
import Whenwords;

class Main {
    static function main() {
        // Relative time
        var result = Whenwords.timeago(1704064500, 1704067200);
        trace(result); // "1 hour ago"
        
        // Duration formatting
        var dur = Whenwords.duration(3661);
        trace(dur); // "1 hour, 1 minute"
        
        // Parse duration strings
        var seconds = Whenwords.parseDuration("2h 30m");
        trace(seconds); // 9000
        
        // Contextual dates
        var date = Whenwords.humanDate(1705190400, 1705276800);
        trace(date); // "Yesterday"
        
        // Date ranges
        var range = Whenwords.dateRange(1705276800, 1705881600);
        trace(range); // "January 15–22, 2024"
    }
}
```

## Functions

### timeago(timestamp, reference?) → String

Returns a human-readable relative time string.

```haxe
static function timeago(timestamp: Dynamic, ?reference: Dynamic): String
```

**Parameters:**
- `timestamp` - Unix timestamp (seconds) as Float or Int
- `reference` - Optional reference timestamp (defaults to `timestamp`)

**Returns:** Human-readable relative time string

**Examples:**
```haxe
Whenwords.timeago(1704067170, 1704067200)  // "just now"
Whenwords.timeago(1704064500, 1704067200)  // "1 hour ago"
Whenwords.timeago(1703462400, 1704067200)  // "7 days ago"
Whenwords.timeago(1704070200, 1704067200)  // "in 1 hour"
```

**Behavior:**
- 0-44 seconds: "just now"
- 45-89 seconds: "1 minute ago"
- 90 seconds - 44 minutes: "{n} minutes ago"
- 45-89 minutes: "1 hour ago"
- 90 minutes - 21 hours: "{n} hours ago"
- 22-35 hours: "1 day ago"
- 36 hours - 25 days: "{n} days ago"
- 26-45 days: "1 month ago"
- 46-319 days: "{n} months ago"
- 320-547 days: "1 year ago"
- 548+ days: "{n} years ago"

Future times use "in {n} {unit}" format.

### duration(seconds, options?) → String

Formats a duration in seconds to a human-readable string.

```haxe
static function duration(seconds: Float, ?options: DurationOptions): String

typedef DurationOptions = {
    ?compact: Bool,      // Use compact format (default: false)
    ?maxUnits: Int      // Maximum units to display (default: 2)
}
```

**Parameters:**
- `seconds` - Non-negative number of seconds
- `options` - Optional formatting options

**Returns:** Formatted duration string

**Examples:**
```haxe
Whenwords.duration(3661)                                    // "1 hour, 1 minute"
Whenwords.duration(3661, {compact: true})                   // "1h 1m"
Whenwords.duration(3661, {maxUnits: 1})                     // "1 hour"
Whenwords.duration(9000, {compact: true, maxUnits: 1})      // "3h"
Whenwords.duration(0)                                       // "0 seconds"
```

**Units:** years (365d), months (30d), days, hours, minutes, seconds

### parseDuration(string) → Float

Parses a human-written duration string into seconds.

```haxe
static function parseDuration(str: String): Float
```

**Parameters:**
- `str` - Duration string to parse

**Returns:** Number of seconds

**Throws:** `Exception` if string is empty, unparseable, or contains negative values

**Examples:**
```haxe
Whenwords.parseDuration("2h30m")                    // 9000
Whenwords.parseDuration("2 hours 30 minutes")       // 9000
Whenwords.parseDuration("2.5 hours")                // 9000
Whenwords.parseDuration("90m")                      // 5400
Whenwords.parseDuration("2:30")                     // 9000 (h:mm format)
Whenwords.parseDuration("1:30:00")                  // 5400 (h:mm:ss format)
```

**Accepted formats:**
- Compact: `2h30m`, `2h 30m`, `2h, 30m`
- Verbose: `2 hours 30 minutes`, `2 hours and 30 minutes`
- Decimal: `2.5 hours`, `1.5h`
- Colon notation: `2:30` (h:mm), `1:30:00` (h:mm:ss)

**Unit aliases:**
- seconds: s, sec, secs, second, seconds
- minutes: m, min, mins, minute, minutes
- hours: h, hr, hrs, hour, hours
- days: d, day, days
- weeks: w, wk, wks, week, weeks

### humanDate(timestamp, reference) → String

Returns a contextual date string.

```haxe
static function humanDate(timestamp: Dynamic, reference: Dynamic): String
```

**Parameters:**
- `timestamp` - The date to format (Unix seconds)
- `reference` - The "current" date for comparison (Unix seconds)

**Returns:** Contextual date string

**Examples:**
```haxe
Whenwords.humanDate(1705276800, 1705276800)  // "Today"
Whenwords.humanDate(1705190400, 1705276800)  // "Yesterday"
Whenwords.humanDate(1705363200, 1705276800)  // "Tomorrow"
Whenwords.humanDate(1705104000, 1705276800)  // "Last Saturday"
Whenwords.humanDate(1705449600, 1705276800)  // "This Wednesday"
Whenwords.humanDate(1709251200, 1705276800)  // "March 1"
Whenwords.humanDate(1672531200, 1705276800)  // "January 1, 2023"
```

**Output formats:**
- Same day: "Today"
- Previous day: "Yesterday"
- Next day: "Tomorrow"
- Within past 7 days: "Last {weekday}"
- Within next 7 days: "This {weekday}"
- Same year: "{Month} {day}"
- Different year: "{Month} {day}, {year}"

### dateRange(start, end) → String

Formats a date range with smart abbreviation.

```haxe
static function dateRange(start: Dynamic, end: Dynamic): String
```

**Parameters:**
- `start` - Start timestamp (Unix seconds)
- `end` - End timestamp (Unix seconds)

**Returns:** Formatted date range string

**Examples:**
```haxe
Whenwords.dateRange(1705276800, 1705276800)  // "January 15, 2024"
Whenwords.dateRange(1705276800, 1705363200)  // "January 15–16, 2024"
Whenwords.dateRange(1705276800, 1705881600)  // "January 15–22, 2024"
Whenwords.dateRange(1705276800, 1707955200)  // "January 15 – February 15, 2024"
Whenwords.dateRange(1703721600, 1705276800)  // "December 28, 2023 – January 15, 2024"
```

**Behavior:**
- Same day: "Month Day, Year"
- Same month: "Month Day–Day, Year"
- Same year: "Month Day – Month Day, Year"
- Different years: "Month Day, Year – Month Day, Year"
- If start > end, they are automatically swapped

## Error handling

Functions throw `haxe.Exception` with descriptive messages when:

- `duration`: Negative seconds, NaN, or infinite values
- `parseDuration`: Empty string, unparseable input, or negative result
- `timeago`, `humanDate`, `dateRange`: Invalid timestamp format

**Example:**
```haxe
try {
    var result = Whenwords.duration(-100);
} catch (e:haxe.Exception) {
    trace("Error: " + e.message); // "Duration cannot be negative"
}
```

## Accepted types

All timestamp parameters accept:
- **Float/Int**: Unix seconds (e.g., `1704067200`)
- **Date**: Haxe Date objects (automatically converted to Unix seconds)

The library works exclusively with UTC timestamps. All calendar-based functions (`humanDate`, `dateRange`) interpret timestamps in UTC.

## Testing

Run the included test suite:

```bash
haxe test.hxml
```

All 123 test cases from `tests.yaml` pass successfully.

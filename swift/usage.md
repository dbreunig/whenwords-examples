# whenwords for Swift

Human-friendly time formatting and parsing.

## Installation

Copy `Whenwords.swift` into your project, or add the package as a local dependency:

```swift
.package(path: "/path/to/whenwords/examples/swift")
```

Then import the module:

```swift
import Whenwords
```

## Quick start

```swift
import Foundation

// Relative time
let now = Date().timeIntervalSince1970
let hourAgo = now - 3600
print(try timeago(hourAgo, reference: now))  // "1 hour ago"

// Duration formatting
print(try duration(3661))  // "1 hour, 1 minute"
print(try duration(3661, options: DurationOptions(compact: true)))  // "1h 1m"

// Parse duration strings
print(try parseDuration("2h 30m"))  // 9000

// Contextual dates
print(try humanDate(now, reference: now))  // "Today"

// Date ranges
print(try dateRange(1705276800, 1705881600))  // "January 15–22, 2024"
```

## Functions

### timeago(_ timestamp:, reference:) -> String

Returns a human-readable relative time string.

```swift
func timeago<T: TimestampConvertible, R: TimestampConvertible>(
    _ timestamp: T,
    reference: R?
) throws -> String
```

**Parameters:**
- `timestamp`: Unix seconds (Int/Double), Date, or ISO 8601 String
- `reference`: Optional reference point for comparison

**Examples:**
```swift
try timeago(1704067110, reference: 1704067200)  // "2 minutes ago"
try timeago(1704070200, reference: 1704067200)  // "in 1 hour"
```

### duration(_ seconds:, options:) -> String

Formats a duration in seconds to a human-readable string.

```swift
func duration(_ seconds: Double, options: DurationOptions) throws -> String
func duration(_ seconds: Int, options: DurationOptions) throws -> String
```

**Parameters:**
- `seconds`: Non-negative number of seconds
- `options`: DurationOptions with `compact` (Bool) and `maxUnits` (Int)

**Examples:**
```swift
try duration(3661)  // "1 hour, 1 minute"
try duration(3661, options: DurationOptions(compact: true))  // "1h 1m"
try duration(93661, options: DurationOptions(maxUnits: 3))  // "1 day, 2 hours, 1 minute"
```

### parseDuration(_ text:) -> Int

Parses a human-written duration string into seconds.

```swift
func parseDuration(_ text: String) throws -> Int
```

**Parameters:**
- `text`: Duration string in various formats

**Accepted formats:**
- Compact: "2h30m", "2h 30m"
- Verbose: "2 hours 30 minutes", "2 hours and 30 minutes"
- Decimal: "2.5 hours", "1.5h"
- Colon: "2:30" (h:mm), "1:30:00" (h:mm:ss)

**Examples:**
```swift
try parseDuration("2h 30m")  // 9000
try parseDuration("2.5 hours")  // 9000
try parseDuration("1:30:00")  // 5400
```

### humanDate(_ timestamp:, reference:) -> String

Returns a contextual date string.

```swift
func humanDate<T: TimestampConvertible, R: TimestampConvertible>(
    _ timestamp: T,
    reference: R?
) throws -> String
```

**Parameters:**
- `timestamp`: The date to format
- `reference`: The "current" date for comparison

**Examples:**
```swift
// If reference is 2024-01-15 (Monday)
try humanDate(1705276800, reference: 1705276800)  // "Today"
try humanDate(1705190400, reference: 1705276800)  // "Yesterday"
try humanDate(1705104000, reference: 1705276800)  // "Last Saturday"
try humanDate(1709251200, reference: 1705276800)  // "March 1"
```

### dateRange(_ start:, _ end:) -> String

Formats a date range with smart abbreviation.

```swift
func dateRange<T: TimestampConvertible, U: TimestampConvertible>(
    _ start: T,
    _ end: U
) throws -> String
```

**Parameters:**
- `start`: Start timestamp
- `end`: End timestamp (auto-swapped if before start)

**Examples:**
```swift
try dateRange(1705276800, 1705276800)  // "January 15, 2024"
try dateRange(1705276800, 1705363200)  // "January 15–16, 2024"
try dateRange(1705276800, 1707955200)  // "January 15 – February 15, 2024"
try dateRange(1703721600, 1705276800)  // "December 28, 2023 – January 15, 2024"
```

## Error handling

All functions throw `WhenwordsError`:

```swift
do {
    let result = try parseDuration("")
} catch let error as WhenwordsError {
    print(error.localizedDescription)  // "Duration string cannot be empty"
}
```

Error types:
- `.invalidTimestamp(String)` - Invalid timestamp format
- `.negativeDuration` - Duration cannot be negative
- `.invalidDuration(String)` - Invalid duration value
- `.emptyString` - Empty input string
- `.unparseable(String)` - Cannot parse the input

## Accepted types

All timestamp parameters accept types conforming to `TimestampConvertible`:
- `Int` - Unix seconds
- `Double` - Unix seconds with fractional precision
- `Date` - Foundation Date objects
- `String` - ISO 8601 formatted strings

```swift
let date = Date()
try timeago(date, reference: Date())

try timeago("2024-01-01T00:00:00Z", reference: 1704067200)
```

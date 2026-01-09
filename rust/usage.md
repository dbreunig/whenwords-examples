# whenwords for Rust

Human-friendly time formatting and parsing.

## Installation

Add to your `Cargo.toml`:

```toml
[dependencies]
whenwords = { path = "path/to/whenwords" }
```

Or copy `src/lib.rs` into your project.

## Quick start

```rust
use whenwords::{timeago, duration, parse_duration, human_date, date_range, DurationOptions};

fn main() {
    // Relative time
    let now = 1704067200; // 2024-01-01 00:00:00 UTC
    let past = now - 3600;
    println!("{}", timeago(past, now)); // "1 hour ago"

    // Duration formatting
    println!("{}", duration(3661, None).unwrap()); // "1 hour, 1 minute"

    // Parse duration strings
    let secs = parse_duration("2h 30m").unwrap();
    println!("{} seconds", secs); // "9000 seconds"

    // Contextual dates
    println!("{}", human_date(now, now)); // "Today"

    // Date ranges
    println!("{}", date_range(1705276800, 1705881600)); // "January 15-22, 2024"
}
```

## Functions

### timeago(timestamp, reference) -> String

Returns a human-readable relative time string.

```rust
pub fn timeago<T: Into<Timestamp>, R: Into<Timestamp>>(timestamp: T, reference: R) -> String
```

**Parameters:**
- `timestamp`: The timestamp to describe (Unix seconds i64, f64, or DateTime<Utc>)
- `reference`: The reference point for comparison

**Examples:**
```rust
timeago(1704063600_i64, 1704067200_i64)  // "1 hour ago"
timeago(1704070800_i64, 1704067200_i64)  // "in 1 hour"
```

### duration(seconds, options) -> Result<String, ParseError>

Formats a duration in seconds as a human-readable string.

```rust
pub fn duration(seconds: i64, options: Option<DurationOptions>) -> Result<String, ParseError>
```

**Parameters:**
- `seconds`: Non-negative number of seconds
- `options`: Optional `DurationOptions` with:
  - `compact`: Use "2h 30m" style (default: false)
  - `max_units`: Maximum units to show (default: 2)

**Examples:**
```rust
duration(3661, None).unwrap()  // "1 hour, 1 minute"

let opts = DurationOptions::new().compact(true);
duration(3661, Some(opts)).unwrap()  // "1h 1m"

let opts = DurationOptions::new().max_units(1);
duration(3661, Some(opts)).unwrap()  // "1 hour"
```

### parse_duration(text) -> Result<i64, ParseError>

Parses a human-written duration string into seconds.

```rust
pub fn parse_duration(text: &str) -> Result<i64, ParseError>
```

**Parameters:**
- `text`: Duration string in various formats

**Accepted formats:**
- Compact: "2h30m", "2h 30m", "2h, 30m"
- Verbose: "2 hours 30 minutes", "2 hours and 30 minutes"
- Decimal: "2.5 hours", "1.5h"
- Colon: "2:30" (h:mm), "1:30:00" (h:mm:ss)

**Examples:**
```rust
parse_duration("2h 30m").unwrap()      // 9000
parse_duration("2.5 hours").unwrap()   // 9000
parse_duration("1:30:00").unwrap()     // 5400
```

### human_date(timestamp, reference) -> String

Returns a contextual date string.

```rust
pub fn human_date<T: Into<Timestamp>, R: Into<Timestamp>>(timestamp: T, reference: R) -> String
```

**Parameters:**
- `timestamp`: The date to format
- `reference`: The "current" date for comparison

**Examples:**
```rust
human_date(1705276800_i64, 1705276800_i64)  // "Today"
human_date(1705190400_i64, 1705276800_i64)  // "Yesterday"
human_date(1705104000_i64, 1705276800_i64)  // "Last Saturday"
human_date(1709251200_i64, 1705276800_i64)  // "March 1"
```

### date_range(start, end) -> String

Formats a date range with smart abbreviation.

```rust
pub fn date_range<S: Into<Timestamp>, E: Into<Timestamp>>(start: S, end: E) -> String
```

**Parameters:**
- `start`: Start timestamp
- `end`: End timestamp (auto-swapped if before start)

**Examples:**
```rust
date_range(1705276800_i64, 1705276800_i64)  // "January 15, 2024"
date_range(1705276800_i64, 1705881600_i64)  // "January 15-22, 2024"
date_range(1705276800_i64, 1707955200_i64)  // "January 15 - February 15, 2024"
```

## Error handling

Functions that can fail return `Result<T, ParseError>`. Use `.unwrap()` for quick scripts or handle errors properly:

```rust
match parse_duration("invalid") {
    Ok(seconds) => println!("Parsed: {} seconds", seconds),
    Err(e) => eprintln!("Parse error: {}", e),
}

match duration(-100, None) {
    Ok(s) => println!("{}", s),
    Err(e) => eprintln!("Error: {}", e),  // "Duration cannot be negative"
}
```

## Accepted types

All timestamp parameters accept:
- `i64`: Unix seconds
- `f64`: Unix seconds with fractional component
- `DateTime<Utc>`: Chrono datetime

Convert using the `Timestamp` enum or rely on `Into<Timestamp>` trait:

```rust
use chrono::{DateTime, Utc};

let unix: i64 = 1704067200;
let dt: DateTime<Utc> = Utc.timestamp_opt(1704067200, 0).unwrap();

// Both work the same
timeago(unix, 1704070800_i64);
timeago(dt, Utc::now());
```

# whenwords for Python

Human-friendly time formatting and parsing.

## Installation

Copy `whenwords.py` to your project and import:

```python
from whenwords import timeago, duration, parse_duration, human_date, date_range
```

## Quick start

```python
from whenwords import timeago, duration, parse_duration, human_date, date_range
import time

now = time.time()

# Relative time
print(timeago(now - 3600, reference=now))  # "1 hour ago"

# Format duration
print(duration(3661))  # "1 hour, 1 minute"

# Parse duration string
seconds = parse_duration("2h 30m")  # 9000

# Contextual dates
print(human_date(now, reference=now))  # "Today"

# Date ranges
print(date_range(1704067200, 1704153600))  # "January 1–2, 2024"
```

## Functions

### timeago(timestamp, reference=None) -> str

Returns a human-readable relative time string.

```python
def timeago(
    timestamp: int | float | str | datetime,
    reference: int | float | str | datetime | None = None
) -> str
```

**Parameters:**
- `timestamp`: Unix seconds, ISO 8601 string, or datetime object
- `reference`: Reference time (defaults to timestamp, returning "just now")

**Examples:**
```python
timeago(1704067110, reference=1704067200)  # "2 minutes ago"
timeago(1704070200, reference=1704067200)  # "in 1 hour"
```

### duration(seconds, options=None) -> str

Formats a duration as a human-readable string.

```python
def duration(
    seconds: int | float,
    options: dict | None = None
) -> str
```

**Parameters:**
- `seconds`: Non-negative number of seconds
- `options`: Optional dict with:
  - `compact`: bool (default False) - use "2h 30m" style
  - `max_units`: int (default 2) - maximum units to show

**Examples:**
```python
duration(3661)                              # "1 hour, 1 minute"
duration(3661, {"compact": True})           # "1h 1m"
duration(93661, {"max_units": 3})           # "1 day, 2 hours, 1 minute"
```

### parse_duration(s) -> int

Parses a human-written duration string into seconds.

```python
def parse_duration(s: str) -> int
```

**Parameters:**
- `s`: Duration string in various formats

**Accepted formats:**
- Compact: `"2h30m"`, `"2h 30m"`, `"1d 2h 30m"`
- Verbose: `"2 hours 30 minutes"`, `"2 hours and 30 minutes"`
- Decimal: `"2.5 hours"`, `"1.5h"`
- Colon: `"2:30"` (h:mm), `"1:30:00"` (h:mm:ss)

**Examples:**
```python
parse_duration("2h 30m")          # 9000
parse_duration("2 hours and 30 minutes")  # 9000
parse_duration("1:30:00")         # 5400
```

### human_date(timestamp, reference=None) -> str

Returns a contextual date string.

```python
def human_date(
    timestamp: int | float | str | datetime,
    reference: int | float | str | datetime | None = None
) -> str
```

**Parameters:**
- `timestamp`: The date to format
- `reference`: The "current" date for comparison

**Examples:**
```python
human_date(1705276800, reference=1705276800)  # "Today"
human_date(1705190400, reference=1705276800)  # "Yesterday"
human_date(1705104000, reference=1705276800)  # "Last Saturday"
```

### date_range(start, end) -> str

Formats a date range with smart abbreviation.

```python
def date_range(
    start: int | float | str | datetime,
    end: int | float | str | datetime
) -> str
```

**Parameters:**
- `start`: Start timestamp
- `end`: End timestamp (swapped automatically if before start)

**Examples:**
```python
date_range(1705276800, 1705881600)  # "January 15–22, 2024"
date_range(1705276800, 1707955200)  # "January 15 – February 15, 2024"
```

## Error handling

All functions raise `ValueError` for invalid inputs:

```python
from whenwords import duration, parse_duration

try:
    duration(-100)
except ValueError as e:
    print(f"Error: {e}")  # "Duration cannot be negative"

try:
    parse_duration("")
except ValueError as e:
    print(f"Error: {e}")  # "Empty duration string"
```

## Accepted types

All timestamp parameters accept:
- `int` or `float`: Unix seconds
- `str`: ISO 8601 format (e.g., `"2024-01-01T00:00:00Z"`)
- `datetime`: Python datetime object (converted via `.timestamp()`)

```python
from datetime import datetime, timezone

# All equivalent
timeago(1704067200, reference=1704070800)
timeago("2024-01-01T00:00:00Z", reference="2024-01-01T01:00:00Z")
timeago(
    datetime(2024, 1, 1, tzinfo=timezone.utc),
    reference=datetime(2024, 1, 1, 1, 0, tzinfo=timezone.utc)
)
```

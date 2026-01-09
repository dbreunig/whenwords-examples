"""
whenwords - Human-friendly time formatting and parsing.

All functions are pure with no side effects. Timestamps are Unix seconds.
"""

import re
from datetime import datetime, timezone
from typing import Union, Optional

# Type alias for timestamp inputs
Timestamp = Union[int, float, str, datetime]


def _normalize_timestamp(ts: Timestamp) -> float:
    """Convert various timestamp formats to Unix seconds."""
    if isinstance(ts, datetime):
        return ts.timestamp()
    elif isinstance(ts, str):
        # Parse ISO 8601 string
        try:
            # Handle various ISO 8601 formats
            ts_str = ts.replace('Z', '+00:00')
            if '.' in ts_str:
                dt = datetime.fromisoformat(ts_str)
            else:
                dt = datetime.fromisoformat(ts_str)
            return dt.timestamp()
        except ValueError as e:
            raise ValueError(f"Invalid timestamp format: {ts}") from e
    elif isinstance(ts, (int, float)):
        return float(ts)
    else:
        raise ValueError(f"Invalid timestamp type: {type(ts)}")


def _round_half_up(n: float) -> int:
    """Round to nearest integer using half-up rounding (2.5 -> 3)."""
    if n >= 0:
        return int(n + 0.5)
    else:
        return int(n - 0.5)


def timeago(timestamp: Timestamp, reference: Optional[Timestamp] = None) -> str:
    """
    Returns a human-readable relative time string.

    Args:
        timestamp: The time to describe
        reference: The reference time (defaults to timestamp if omitted)

    Returns:
        A string like "3 hours ago" or "in 5 minutes"
    """
    ts = _normalize_timestamp(timestamp)
    ref = _normalize_timestamp(reference) if reference is not None else ts

    diff = ref - ts  # positive means past, negative means future
    is_future = diff < 0
    diff = abs(diff)

    # Define thresholds (in seconds)
    MINUTE = 60
    HOUR = 60 * MINUTE
    DAY = 24 * HOUR
    # Use average month length (365.25/12) for more accurate calendar-like behavior
    MONTH = 30.4375 * DAY
    YEAR = 365 * DAY

    # Determine the appropriate unit and value
    if diff < 45:
        return "just now"
    elif diff < 90:
        n = 1
        unit = "minute"
    elif diff < 45 * MINUTE:
        n = _round_half_up(diff / MINUTE)
        unit = "minute"
    elif diff < 90 * MINUTE:
        n = 1
        unit = "hour"
    elif diff < 22 * HOUR:
        n = _round_half_up(diff / HOUR)
        unit = "hour"
    elif diff < 36 * HOUR:
        n = 1
        unit = "day"
    elif diff < 26 * DAY:
        n = _round_half_up(diff / DAY)
        unit = "day"
    elif diff < 46 * DAY:
        n = 1
        unit = "month"
    elif diff < 320 * DAY:
        n = _round_half_up(diff / MONTH)
        unit = "month"
    elif diff < 548 * DAY:
        n = 1
        unit = "year"
    else:
        n = _round_half_up(diff / YEAR)
        unit = "year"

    # Pluralize
    if n != 1:
        unit += "s"

    if is_future:
        return f"in {n} {unit}"
    else:
        return f"{n} {unit} ago"


def duration(seconds: Union[int, float], options: Optional[dict] = None) -> str:
    """
    Formats a duration (not relative to now).

    Args:
        seconds: Non-negative number of seconds
        options: Optional dict with:
            - compact: bool (default False) - use "2h 34m" style
            - max_units: int (default 2) - maximum units to show

    Returns:
        A formatted duration string

    Raises:
        ValueError: If seconds is negative, NaN, or infinite
    """
    import math

    if math.isnan(seconds) or math.isinf(seconds):
        raise ValueError("Invalid seconds value: NaN or infinite")
    if seconds < 0:
        raise ValueError("Duration cannot be negative")

    opts = options or {}
    compact = opts.get('compact', False)
    max_units = opts.get('max_units', 2)

    # Define units in seconds
    MINUTE = 60
    HOUR = 60 * MINUTE
    DAY = 24 * HOUR
    MONTH = 30 * DAY
    YEAR = 365 * DAY

    units = [
        (YEAR, "year", "y"),
        (MONTH, "month", "mo"),
        (DAY, "day", "d"),
        (HOUR, "hour", "h"),
        (MINUTE, "minute", "m"),
        (1, "second", "s"),
    ]

    if seconds == 0:
        return "0s" if compact else "0 seconds"

    remaining = seconds
    parts = []

    for unit_seconds, unit_name, unit_abbrev in units:
        if remaining >= unit_seconds:
            count = int(remaining // unit_seconds)
            remaining = remaining % unit_seconds
            parts.append((count, unit_name, unit_abbrev))

    # Limit to max_units
    if len(parts) > max_units:
        parts = parts[:max_units]

    if compact:
        return " ".join(f"{count}{abbrev}" for count, name, abbrev in parts)
    else:
        result_parts = []
        for count, name, abbrev in parts:
            if count == 1:
                result_parts.append(f"{count} {name}")
            else:
                result_parts.append(f"{count} {name}s")
        return ", ".join(result_parts)


def parse_duration(s: str) -> int:
    """
    Parses a human-written duration string into seconds.

    Args:
        s: Duration string like "2h30m", "2 hours and 30 minutes", "2:30"

    Returns:
        Number of seconds

    Raises:
        ValueError: If the string is empty, unparseable, or results in negative
    """
    if not s or not s.strip():
        raise ValueError("Empty duration string")

    s = s.strip()
    original = s

    # Check for negative values
    if s.startswith('-'):
        raise ValueError("Negative durations are not allowed")

    # Define unit multipliers
    unit_map = {
        's': 1, 'sec': 1, 'secs': 1, 'second': 1, 'seconds': 1,
        'm': 60, 'min': 60, 'mins': 60, 'minute': 60, 'minutes': 60,
        'h': 3600, 'hr': 3600, 'hrs': 3600, 'hour': 3600, 'hours': 3600,
        'd': 86400, 'day': 86400, 'days': 86400,
        'w': 604800, 'wk': 604800, 'wks': 604800, 'week': 604800, 'weeks': 604800,
    }

    # Try colon notation first (h:mm or h:mm:ss)
    colon_match = re.match(r'^(\d+):(\d{1,2})(?::(\d{1,2}))?$', s)
    if colon_match:
        hours = int(colon_match.group(1))
        minutes = int(colon_match.group(2))
        seconds = int(colon_match.group(3)) if colon_match.group(3) else 0
        return hours * 3600 + minutes * 60 + seconds

    # Normalize: lowercase, remove "and", extra spaces
    s = s.lower()
    s = s.replace(',', ' ').replace(' and ', ' ')
    s = ' '.join(s.split())  # normalize whitespace

    # Pattern to match number followed by unit
    pattern = r'(\d+(?:\.\d+)?)\s*([a-z]+)'
    matches = re.findall(pattern, s)

    if not matches:
        raise ValueError(f"Cannot parse duration: {original}")

    total_seconds = 0.0
    for value_str, unit in matches:
        value = float(value_str)
        if value < 0:
            raise ValueError("Negative durations are not allowed")

        unit = unit.lower()
        if unit not in unit_map:
            raise ValueError(f"Unknown unit: {unit}")

        total_seconds += value * unit_map[unit]

    return int(total_seconds)


def human_date(timestamp: Timestamp, reference: Optional[Timestamp] = None) -> str:
    """
    Returns a contextual date string.

    Args:
        timestamp: The date to format
        reference: The "current" date for comparison

    Returns:
        A string like "Today", "Yesterday", "Last Friday", "March 15"
    """
    ts = _normalize_timestamp(timestamp)
    ref = _normalize_timestamp(reference) if reference is not None else ts

    # Convert to UTC dates
    ts_dt = datetime.fromtimestamp(ts, tz=timezone.utc)
    ref_dt = datetime.fromtimestamp(ref, tz=timezone.utc)

    # Get date parts (ignoring time)
    ts_date = ts_dt.date()
    ref_date = ref_dt.date()

    # Calculate day difference
    day_diff = (ts_date - ref_date).days

    weekday_names = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    month_names = ["January", "February", "March", "April", "May", "June",
                   "July", "August", "September", "October", "November", "December"]

    if day_diff == 0:
        return "Today"
    elif day_diff == -1:
        return "Yesterday"
    elif day_diff == 1:
        return "Tomorrow"
    elif -7 < day_diff < 0:
        # Within past 7 days (but not yesterday)
        weekday = ts_dt.weekday()
        return f"Last {weekday_names[weekday]}"
    elif 0 < day_diff < 7:
        # Within next 7 days (but not tomorrow)
        weekday = ts_dt.weekday()
        return f"This {weekday_names[weekday]}"
    else:
        # Format as date
        month = month_names[ts_dt.month - 1]
        day = ts_dt.day
        if ts_dt.year == ref_dt.year:
            return f"{month} {day}"
        else:
            return f"{month} {day}, {ts_dt.year}"


def date_range(start: Timestamp, end: Timestamp) -> str:
    """
    Formats a date range with smart abbreviation.

    Args:
        start: Start timestamp
        end: End timestamp

    Returns:
        A formatted date range string
    """
    start_ts = _normalize_timestamp(start)
    end_ts = _normalize_timestamp(end)

    # Swap if needed
    if start_ts > end_ts:
        start_ts, end_ts = end_ts, start_ts

    # Convert to UTC dates
    start_dt = datetime.fromtimestamp(start_ts, tz=timezone.utc)
    end_dt = datetime.fromtimestamp(end_ts, tz=timezone.utc)

    start_date = start_dt.date()
    end_date = end_dt.date()

    month_names = ["January", "February", "March", "April", "May", "June",
                   "July", "August", "September", "October", "November", "December"]

    start_month = month_names[start_dt.month - 1]
    end_month = month_names[end_dt.month - 1]

    # Same day
    if start_date == end_date:
        return f"{start_month} {start_dt.day}, {start_dt.year}"

    # Same month and year
    if start_dt.year == end_dt.year and start_dt.month == end_dt.month:
        return f"{start_month} {start_dt.day}\u2013{end_dt.day}, {start_dt.year}"

    # Same year, different months
    if start_dt.year == end_dt.year:
        return f"{start_month} {start_dt.day} \u2013 {end_month} {end_dt.day}, {start_dt.year}"

    # Different years
    return f"{start_month} {start_dt.day}, {start_dt.year} \u2013 {end_month} {end_dt.day}, {end_dt.year}"

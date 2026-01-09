//! whenwords - Human-friendly time formatting and parsing library.
//!
//! All functions are pure - no side effects, no I/O, no system clock access.
//! The reference timestamp is always passed explicitly.

use chrono::{DateTime, Datelike, TimeZone, Utc, Weekday};
use std::fmt;

/// Error type for parsing operations
#[derive(Debug, Clone, PartialEq)]
pub struct ParseError {
    pub message: String,
}

impl fmt::Display for ParseError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.message)
    }
}

impl std::error::Error for ParseError {}

/// Represents a timestamp that can be either Unix seconds or a DateTime
pub enum Timestamp {
    Unix(i64),
    UnixFloat(f64),
    DateTime(DateTime<Utc>),
}

impl From<i64> for Timestamp {
    fn from(secs: i64) -> Self {
        Timestamp::Unix(secs)
    }
}

impl From<f64> for Timestamp {
    fn from(secs: f64) -> Self {
        Timestamp::UnixFloat(secs)
    }
}

impl From<DateTime<Utc>> for Timestamp {
    fn from(dt: DateTime<Utc>) -> Self {
        Timestamp::DateTime(dt)
    }
}

impl Timestamp {
    /// Convert to Unix seconds
    pub fn to_unix_seconds(&self) -> i64 {
        match self {
            Timestamp::Unix(secs) => *secs,
            Timestamp::UnixFloat(secs) => *secs as i64,
            Timestamp::DateTime(dt) => dt.timestamp(),
        }
    }

    /// Convert to DateTime<Utc>
    pub fn to_datetime(&self) -> DateTime<Utc> {
        match self {
            Timestamp::Unix(secs) => Utc.timestamp_opt(*secs, 0).unwrap(),
            Timestamp::UnixFloat(secs) => Utc.timestamp_opt(*secs as i64, 0).unwrap(),
            Timestamp::DateTime(dt) => *dt,
        }
    }
}

/// Parse an ISO 8601 string to a Timestamp
pub fn parse_iso8601(s: &str) -> Result<Timestamp, ParseError> {
    let s = s.replace('Z', "+00:00");
    DateTime::parse_from_rfc3339(&s)
        .map(|dt| Timestamp::DateTime(dt.with_timezone(&Utc)))
        .map_err(|_| ParseError {
            message: format!("Invalid timestamp format: {}", s),
        })
}

/// Options for the duration function
#[derive(Debug, Clone, Default)]
pub struct DurationOptions {
    /// If true, use compact format like "2h 30m"
    pub compact: bool,
    /// Maximum number of units to display (default: 2)
    pub max_units: Option<usize>,
}

impl DurationOptions {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn compact(mut self, compact: bool) -> Self {
        self.compact = compact;
        self
    }

    pub fn max_units(mut self, max_units: usize) -> Self {
        self.max_units = Some(max_units);
        self
    }
}

fn pluralize(n: i64, singular: &str, plural: &str) -> String {
    if n == 1 {
        singular.to_string()
    } else {
        plural.to_string()
    }
}

/// Returns a human-readable relative time string.
///
/// # Arguments
/// * `timestamp` - The timestamp to describe
/// * `reference` - The reference point for comparison
///
/// # Returns
/// Human-readable string like "3 hours ago" or "in 2 days"
pub fn timeago<T: Into<Timestamp>, R: Into<Timestamp>>(timestamp: T, reference: R) -> String {
    let ts = timestamp.into().to_unix_seconds();
    let ref_ts = reference.into().to_unix_seconds();

    let diff = ref_ts - ts; // positive means past, negative means future
    let abs_diff = diff.abs();
    let is_future = diff < 0;

    let seconds = abs_diff as f64;
    let minutes = seconds / 60.0;
    let hours = minutes / 60.0;
    let days = hours / 24.0;
    let months = days / 30.44; // approximate
    let years = days / 365.0;

    // Determine output based on thresholds
    if seconds < 45.0 {
        return "just now".to_string();
    }

    let (n, unit) = if seconds < 90.0 {
        (1, "minute".to_string())
    } else if minutes < 45.0 {
        let n = minutes.round() as i64;
        (n, pluralize(n, "minute", "minutes"))
    } else if minutes < 90.0 {
        (1, "hour".to_string())
    } else if hours < 22.0 {
        let n = hours.round() as i64;
        (n, pluralize(n, "hour", "hours"))
    } else if hours < 36.0 {
        (1, "day".to_string())
    } else if days < 26.0 {
        let n = days.round() as i64;
        (n, pluralize(n, "day", "days"))
    } else if days < 46.0 {
        (1, "month".to_string())
    } else if days < 320.0 {
        let n = months.round() as i64;
        (n, pluralize(n, "month", "months"))
    } else if days < 548.0 {
        (1, "year".to_string())
    } else {
        let n = years.round() as i64;
        (n, pluralize(n, "year", "years"))
    };

    if is_future {
        format!("in {} {}", n, unit)
    } else {
        format!("{} {} ago", n, unit)
    }
}

/// Formats a duration (not relative to now).
///
/// # Arguments
/// * `seconds` - Non-negative number of seconds
/// * `options` - Optional formatting options
///
/// # Returns
/// Human-readable duration string
///
/// # Errors
/// Returns an error if seconds is negative
pub fn duration(seconds: i64, options: Option<DurationOptions>) -> Result<String, ParseError> {
    if seconds < 0 {
        return Err(ParseError {
            message: "Duration cannot be negative".to_string(),
        });
    }

    let opts = options.unwrap_or_default();
    let compact = opts.compact;
    let max_units = opts.max_units.unwrap_or(2);

    const YEAR: i64 = 365 * 24 * 60 * 60;
    const MONTH: i64 = 30 * 24 * 60 * 60;
    const DAY: i64 = 24 * 60 * 60;
    const HOUR: i64 = 60 * 60;
    const MINUTE: i64 = 60;

    let units: [(i64, &str, &str, &str); 6] = [
        (YEAR, "year", "years", "y"),
        (MONTH, "month", "months", "mo"),
        (DAY, "day", "days", "d"),
        (HOUR, "hour", "hours", "h"),
        (MINUTE, "minute", "minutes", "m"),
        (1, "second", "seconds", "s"),
    ];

    if seconds == 0 {
        return Ok(if compact {
            "0s".to_string()
        } else {
            "0 seconds".to_string()
        });
    }

    let mut remaining = seconds;
    let mut parts: Vec<String> = Vec::new();

    for (unit_seconds, singular, plural, short) in units.iter() {
        if remaining >= *unit_seconds {
            let value = remaining / unit_seconds;
            remaining %= unit_seconds;

            if compact {
                parts.push(format!("{}{}", value, short));
            } else {
                let unit_name = if value == 1 { *singular } else { *plural };
                parts.push(format!("{} {}", value, unit_name));
            }
        }
    }

    // Apply max_units limit
    if parts.len() > max_units {
        parts.truncate(max_units);
    }

    if compact {
        Ok(parts.join(" "))
    } else {
        Ok(parts.join(", "))
    }
}

/// Parses a human-written duration string into seconds.
///
/// # Accepted formats
/// - Compact: "2h30m", "2h 30m", "2h, 30m"
/// - Verbose: "2 hours 30 minutes", "2 hours and 30 minutes"
/// - Decimal: "2.5 hours", "1.5h"
/// - Single unit: "90 minutes", "90m", "90min"
/// - Colon notation: "2:30" (h:mm), "2:30:00" (h:mm:ss)
///
/// # Errors
/// Returns an error if the string is empty, unparseable, or results in a negative value
pub fn parse_duration(text: &str) -> Result<i64, ParseError> {
    let text = text.trim();

    if text.is_empty() {
        return Err(ParseError {
            message: "Duration string cannot be empty".to_string(),
        });
    }

    // Check for negative values
    if text.starts_with('-') {
        return Err(ParseError {
            message: "Duration cannot be negative".to_string(),
        });
    }

    // Unit mappings (to seconds)
    fn get_unit_seconds(unit: &str) -> Option<i64> {
        match unit.to_lowercase().as_str() {
            // Seconds
            "s" | "sec" | "secs" | "second" | "seconds" => Some(1),
            // Minutes
            "m" | "min" | "mins" | "minute" | "minutes" => Some(60),
            // Hours
            "h" | "hr" | "hrs" | "hour" | "hours" => Some(3600),
            // Days
            "d" | "day" | "days" => Some(86400),
            // Weeks
            "w" | "wk" | "wks" | "week" | "weeks" => Some(604800),
            _ => None,
        }
    }

    // Try colon notation first: h:mm or h:mm:ss
    let colon_parts: Vec<&str> = text.split(':').collect();
    if colon_parts.len() == 2 || colon_parts.len() == 3 {
        let all_numeric = colon_parts.iter().all(|p| p.chars().all(|c| c.is_ascii_digit()));
        if all_numeric && !colon_parts.iter().any(|p| p.is_empty()) {
            let hours: i64 = colon_parts[0].parse().unwrap_or(0);
            let minutes: i64 = colon_parts[1].parse().unwrap_or(0);
            let seconds: i64 = if colon_parts.len() == 3 {
                colon_parts[2].parse().unwrap_or(0)
            } else {
                0
            };
            return Ok(hours * 3600 + minutes * 60 + seconds);
        }
    }

    // Clean up the text
    let cleaned = text
        .to_lowercase()
        .replace(" and ", " ")
        .replace(',', " ");
    let cleaned = cleaned.split_whitespace().collect::<Vec<_>>().join(" ");

    // Pattern to match number (with optional decimal) followed by unit
    let mut total_seconds: f64 = 0.0;
    let mut found_any = false;

    // Use a simple state machine to parse
    let mut chars = cleaned.chars().peekable();
    while chars.peek().is_some() {
        // Skip whitespace
        while chars.peek().map_or(false, |c| c.is_whitespace()) {
            chars.next();
        }

        if chars.peek().is_none() {
            break;
        }

        // Try to read a number
        let mut num_str = String::new();
        while chars.peek().map_or(false, |c| c.is_ascii_digit() || *c == '.') {
            num_str.push(chars.next().unwrap());
        }

        if num_str.is_empty() {
            // Skip non-numeric characters
            chars.next();
            continue;
        }

        let value: f64 = match num_str.parse() {
            Ok(v) => v,
            Err(_) => continue,
        };

        // Skip whitespace between number and unit
        while chars.peek().map_or(false, |c| c.is_whitespace()) {
            chars.next();
        }

        // Try to read a unit
        let mut unit_str = String::new();
        while chars.peek().map_or(false, |c| c.is_alphabetic()) {
            unit_str.push(chars.next().unwrap());
        }

        if unit_str.is_empty() {
            // Number without unit - this is an error
            continue;
        }

        if let Some(unit_secs) = get_unit_seconds(&unit_str) {
            total_seconds += value * unit_secs as f64;
            found_any = true;
        } else {
            return Err(ParseError {
                message: format!("Unknown unit: {}", unit_str),
            });
        }
    }

    if !found_any {
        return Err(ParseError {
            message: format!("Cannot parse duration: {}", text),
        });
    }

    if total_seconds < 0.0 {
        return Err(ParseError {
            message: "Duration cannot be negative".to_string(),
        });
    }

    Ok(total_seconds.round() as i64)
}

/// Returns a contextual date string.
///
/// # Arguments
/// * `timestamp` - The date to format
/// * `reference` - The "current" date for comparison
///
/// # Returns
/// Contextual string like "Today", "Yesterday", "Last Friday", "March 5"
pub fn human_date<T: Into<Timestamp>, R: Into<Timestamp>>(timestamp: T, reference: R) -> String {
    let ts_dt = timestamp.into().to_datetime();
    let ref_dt = reference.into().to_datetime();

    let ts_date = ts_dt.date_naive();
    let ref_date = ref_dt.date_naive();

    let day_diff = (ts_date - ref_date).num_days();

    let weekday_name = |weekday: Weekday| -> &'static str {
        match weekday {
            Weekday::Mon => "Monday",
            Weekday::Tue => "Tuesday",
            Weekday::Wed => "Wednesday",
            Weekday::Thu => "Thursday",
            Weekday::Fri => "Friday",
            Weekday::Sat => "Saturday",
            Weekday::Sun => "Sunday",
        }
    };

    let month_name = |month: u32| -> &'static str {
        match month {
            1 => "January",
            2 => "February",
            3 => "March",
            4 => "April",
            5 => "May",
            6 => "June",
            7 => "July",
            8 => "August",
            9 => "September",
            10 => "October",
            11 => "November",
            12 => "December",
            _ => "Unknown",
        }
    };

    if day_diff == 0 {
        "Today".to_string()
    } else if day_diff == -1 {
        "Yesterday".to_string()
    } else if day_diff == 1 {
        "Tomorrow".to_string()
    } else if day_diff > -7 && day_diff < 0 {
        // Within past 7 days (but not yesterday)
        format!("Last {}", weekday_name(ts_dt.weekday()))
    } else if day_diff > 0 && day_diff < 7 {
        // Within next 7 days (but not tomorrow)
        format!("This {}", weekday_name(ts_dt.weekday()))
    } else {
        // Beyond 7 days: show date
        let month = month_name(ts_dt.month());
        let day = ts_dt.day();

        if ts_dt.year() == ref_dt.year() {
            format!("{} {}", month, day)
        } else {
            format!("{} {}, {}", month, day, ts_dt.year())
        }
    }
}

/// Formats a date range with smart abbreviation.
///
/// # Arguments
/// * `start` - Start timestamp
/// * `end` - End timestamp
///
/// # Returns
/// Formatted date range string
pub fn date_range<S: Into<Timestamp>, E: Into<Timestamp>>(start: S, end: E) -> String {
    let mut start_dt = start.into().to_datetime();
    let mut end_dt = end.into().to_datetime();

    // Swap if start > end
    if start_dt > end_dt {
        std::mem::swap(&mut start_dt, &mut end_dt);
    }

    let start_date = start_dt.date_naive();
    let end_date = end_dt.date_naive();

    let month_name = |month: u32| -> &'static str {
        match month {
            1 => "January",
            2 => "February",
            3 => "March",
            4 => "April",
            5 => "May",
            6 => "June",
            7 => "July",
            8 => "August",
            9 => "September",
            10 => "October",
            11 => "November",
            12 => "December",
            _ => "Unknown",
        }
    };

    let start_month = month_name(start_dt.month());
    let end_month = month_name(end_dt.month());

    // Same day
    if start_date == end_date {
        return format!("{} {}, {}", start_month, start_dt.day(), start_dt.year());
    }

    // Same month and year
    if start_dt.year() == end_dt.year() && start_dt.month() == end_dt.month() {
        return format!(
            "{} {}\u{2013}{}, {}",
            start_month,
            start_dt.day(),
            end_dt.day(),
            start_dt.year()
        );
    }

    // Same year, different months
    if start_dt.year() == end_dt.year() {
        return format!(
            "{} {} \u{2013} {} {}, {}",
            start_month,
            start_dt.day(),
            end_month,
            end_dt.day(),
            start_dt.year()
        );
    }

    // Different years
    format!(
        "{} {}, {} \u{2013} {} {}, {}",
        start_month,
        start_dt.day(),
        start_dt.year(),
        end_month,
        end_dt.day(),
        end_dt.year()
    )
}

#[cfg(test)]
mod tests;

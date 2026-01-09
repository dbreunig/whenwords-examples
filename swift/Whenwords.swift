import Foundation

/// whenwords - Human-friendly time formatting and parsing library.
///
/// All functions are pure - no side effects, no I/O, no system clock access.
/// The reference timestamp is always passed explicitly.

/// Error type for whenwords operations
public enum WhenwordsError: Error, LocalizedError {
    case invalidTimestamp(String)
    case negativeDuration
    case invalidDuration(String)
    case emptyString
    case unparseable(String)

    public var errorDescription: String? {
        switch self {
        case .invalidTimestamp(let msg):
            return "Invalid timestamp: \(msg)"
        case .negativeDuration:
            return "Duration cannot be negative"
        case .invalidDuration(let msg):
            return "Invalid duration: \(msg)"
        case .emptyString:
            return "Duration string cannot be empty"
        case .unparseable(let msg):
            return "Cannot parse duration: \(msg)"
        }
    }
}

/// Options for duration formatting
public struct DurationOptions {
    public var compact: Bool
    public var maxUnits: Int

    public init(compact: Bool = false, maxUnits: Int = 2) {
        self.compact = compact
        self.maxUnits = maxUnits
    }
}

// MARK: - Timestamp Protocol

/// Protocol for types that can be converted to Unix timestamp
public protocol TimestampConvertible {
    func toUnixSeconds() throws -> Double
}

extension Double: TimestampConvertible {
    public func toUnixSeconds() throws -> Double {
        return self
    }
}

extension Int: TimestampConvertible {
    public func toUnixSeconds() throws -> Double {
        return Double(self)
    }
}

extension Date: TimestampConvertible {
    public func toUnixSeconds() throws -> Double {
        return self.timeIntervalSince1970
    }
}

extension String: TimestampConvertible {
    public func toUnixSeconds() throws -> Double {
        // Try ISO 8601 parsing
        let formatters: [ISO8601DateFormatter] = {
            let withFractional = ISO8601DateFormatter()
            withFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

            let standard = ISO8601DateFormatter()
            standard.formatOptions = [.withInternetDateTime]

            return [withFractional, standard]
        }()

        for formatter in formatters {
            if let date = formatter.date(from: self) {
                return date.timeIntervalSince1970
            }
        }

        // Try DateFormatter for more formats
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(identifier: "UTC")

        let formats = [
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd"
        ]

        for format in formats {
            df.dateFormat = format
            if let date = df.date(from: self) {
                return date.timeIntervalSince1970
            }
        }

        throw WhenwordsError.invalidTimestamp(self)
    }
}

// MARK: - Helper Functions

private func pluralize(_ n: Int, singular: String, plural: String) -> String {
    return n == 1 ? singular : plural
}

// MARK: - Public Functions

/// Returns a human-readable relative time string.
///
/// - Parameters:
///   - timestamp: The timestamp to describe (Unix seconds, Date, or ISO 8601 string)
///   - reference: The reference point (defaults to timestamp itself if nil)
/// - Returns: Human-readable string like "3 hours ago" or "in 2 days"
/// - Throws: WhenwordsError if timestamp is invalid
public func timeago<T: TimestampConvertible, R: TimestampConvertible>(
    _ timestamp: T,
    reference: R? = nil as Double?
) throws -> String {
    let ts = try timestamp.toUnixSeconds()
    let ref: Double
    if let r = reference {
        ref = try r.toUnixSeconds()
    } else {
        ref = ts
    }

    let diff = ref - ts  // positive means past, negative means future
    let absDiff = abs(diff)
    let isFuture = diff < 0

    // Time conversions
    let seconds = absDiff
    let minutes = seconds / 60
    let hours = minutes / 60
    let days = hours / 24
    let months = days / 30.44  // approximate (365/12)
    let years = days / 365  // approximate

    // Determine output based on thresholds
    let n: Int
    let unit: String

    if seconds < 45 {
        return "just now"
    } else if seconds < 90 {
        n = 1
        unit = "minute"
    } else if minutes < 45 {
        n = Int(minutes.rounded())
        unit = pluralize(n, singular: "minute", plural: "minutes")
    } else if minutes < 90 {
        n = 1
        unit = "hour"
    } else if hours < 22 {
        n = Int(hours.rounded())
        unit = pluralize(n, singular: "hour", plural: "hours")
    } else if hours < 36 {
        n = 1
        unit = "day"
    } else if days < 26 {
        n = Int(days.rounded())
        unit = pluralize(n, singular: "day", plural: "days")
    } else if days < 46 {
        n = 1
        unit = "month"
    } else if days < 320 {
        n = Int(months.rounded())
        unit = pluralize(n, singular: "month", plural: "months")
    } else if days < 548 {
        n = 1
        unit = "year"
    } else {
        n = Int(years.rounded())
        unit = pluralize(n, singular: "year", plural: "years")
    }

    if isFuture {
        return "in \(n) \(unit)"
    } else {
        return "\(n) \(unit) ago"
    }
}

/// Formats a duration (not relative to now).
///
/// - Parameters:
///   - seconds: Non-negative number of seconds
///   - options: Formatting options (compact mode, max units)
/// - Returns: Human-readable duration string
/// - Throws: WhenwordsError if seconds is negative
public func duration(_ seconds: Double, options: DurationOptions = DurationOptions()) throws -> String {
    if seconds < 0 {
        throw WhenwordsError.negativeDuration
    }
    if seconds.isNaN || seconds.isInfinite {
        throw WhenwordsError.invalidDuration("Invalid seconds value")
    }

    // Unit definitions (in seconds)
    let YEAR = 365.0 * 24 * 60 * 60    // 31536000
    let MONTH = 30.0 * 24 * 60 * 60    // 2592000
    let DAY = 24.0 * 60 * 60           // 86400
    let HOUR = 60.0 * 60               // 3600
    let MINUTE = 60.0

    let units: [(Double, String, String, String)] = [
        (YEAR, "year", "years", "y"),
        (MONTH, "month", "months", "mo"),
        (DAY, "day", "days", "d"),
        (HOUR, "hour", "hours", "h"),
        (MINUTE, "minute", "minutes", "m"),
        (1, "second", "seconds", "s"),
    ]

    if seconds == 0 {
        return options.compact ? "0s" : "0 seconds"
    }

    var remaining = seconds
    var parts: [String] = []

    for (unitSeconds, singular, plural, short) in units {
        if remaining >= unitSeconds {
            let value = Int(remaining / unitSeconds)
            remaining = remaining.truncatingRemainder(dividingBy: unitSeconds)

            if options.compact {
                parts.append("\(value)\(short)")
            } else {
                let unitName = value == 1 ? singular : plural
                parts.append("\(value) \(unitName)")
            }
        }
    }

    // Apply max_units limit
    if parts.count > options.maxUnits {
        parts = Array(parts.prefix(options.maxUnits))
    }

    if options.compact {
        return parts.joined(separator: " ")
    } else {
        return parts.joined(separator: ", ")
    }
}

/// Convenience overload for integer seconds
public func duration(_ seconds: Int, options: DurationOptions = DurationOptions()) throws -> String {
    return try duration(Double(seconds), options: options)
}

/// Parses a human-written duration string into seconds.
///
/// Accepted formats:
/// - Compact: "2h30m", "2h 30m", "2h, 30m"
/// - Verbose: "2 hours 30 minutes", "2 hours and 30 minutes"
/// - Decimal: "2.5 hours", "1.5h"
/// - Single unit: "90 minutes", "90m", "90min"
/// - Colon notation: "2:30" (h:mm), "2:30:00" (h:mm:ss)
///
/// - Parameter text: Duration string to parse
/// - Returns: Number of seconds as integer
/// - Throws: WhenwordsError if string is empty, unparseable, or results in negative value
public func parseDuration(_ text: String) throws -> Int {
    let trimmed = text.trimmingCharacters(in: .whitespaces)

    if trimmed.isEmpty {
        throw WhenwordsError.emptyString
    }

    // Check for negative values
    if trimmed.hasPrefix("-") {
        throw WhenwordsError.invalidDuration("Duration cannot be negative")
    }

    // Unit mappings (to seconds)
    let unitMap: [String: Double] = [
        // Seconds
        "s": 1, "sec": 1, "secs": 1, "second": 1, "seconds": 1,
        // Minutes
        "m": 60, "min": 60, "mins": 60, "minute": 60, "minutes": 60,
        // Hours
        "h": 3600, "hr": 3600, "hrs": 3600, "hour": 3600, "hours": 3600,
        // Days
        "d": 86400, "day": 86400, "days": 86400,
        // Weeks
        "w": 604800, "wk": 604800, "wks": 604800, "week": 604800, "weeks": 604800,
    ]

    // Try colon notation first: h:mm or h:mm:ss
    let colonPattern = #"^(\d+):(\d{1,2})(?::(\d{1,2}))?$"#
    if let colonRegex = try? NSRegularExpression(pattern: colonPattern),
       let match = colonRegex.firstMatch(in: trimmed, range: NSRange(trimmed.startIndex..., in: trimmed)) {

        let hoursRange = Range(match.range(at: 1), in: trimmed)!
        let minutesRange = Range(match.range(at: 2), in: trimmed)!

        let hours = Int(trimmed[hoursRange])!
        let minutes = Int(trimmed[minutesRange])!
        var seconds = 0

        if match.range(at: 3).location != NSNotFound,
           let secondsRange = Range(match.range(at: 3), in: trimmed) {
            seconds = Int(trimmed[secondsRange])!
        }

        return hours * 3600 + minutes * 60 + seconds
    }

    // Clean up the text: remove "and", extra commas, normalize whitespace
    var cleaned = trimmed.lowercased()
    cleaned = cleaned.replacingOccurrences(of: "\\band\\b", with: " ", options: .regularExpression)
    cleaned = cleaned.replacingOccurrences(of: ",", with: " ")
    cleaned = cleaned.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    cleaned = cleaned.trimmingCharacters(in: .whitespaces)

    // Pattern to match number (with optional decimal) followed by unit
    let pattern = #"(\d+(?:\.\d+)?)\s*([a-zA-Z]+)"#
    guard let regex = try? NSRegularExpression(pattern: pattern) else {
        throw WhenwordsError.unparseable(text)
    }

    let matches = regex.matches(in: cleaned, range: NSRange(cleaned.startIndex..., in: cleaned))

    if matches.isEmpty {
        throw WhenwordsError.unparseable(text)
    }

    var totalSeconds = 0.0
    for match in matches {
        let valueRange = Range(match.range(at: 1), in: cleaned)!
        let unitRange = Range(match.range(at: 2), in: cleaned)!

        let valueStr = String(cleaned[valueRange])
        let unitStr = String(cleaned[unitRange]).lowercased()

        guard let value = Double(valueStr) else {
            throw WhenwordsError.unparseable(text)
        }

        guard let multiplier = unitMap[unitStr] else {
            throw WhenwordsError.unparseable("Unknown unit: \(unitStr)")
        }

        totalSeconds += value * multiplier
    }

    if totalSeconds < 0 {
        throw WhenwordsError.invalidDuration("Duration cannot be negative")
    }

    return Int(totalSeconds.rounded())
}

/// Returns a contextual date string.
///
/// - Parameters:
///   - timestamp: The date to format
///   - reference: The "current" date for comparison
/// - Returns: Contextual string like "Today", "Yesterday", "Last Friday", "March 5"
/// - Throws: WhenwordsError if timestamp is invalid
public func humanDate<T: TimestampConvertible, R: TimestampConvertible>(
    _ timestamp: T,
    reference: R? = nil as Double?
) throws -> String {
    let ts = try timestamp.toUnixSeconds()
    let ref: Double
    if let r = reference {
        ref = try r.toUnixSeconds()
    } else {
        ref = ts
    }

    let calendar = Calendar(identifier: .gregorian)
    var utcCalendar = calendar
    utcCalendar.timeZone = TimeZone(identifier: "UTC")!

    let tsDate = Date(timeIntervalSince1970: ts)
    let refDate = Date(timeIntervalSince1970: ref)

    // Get date components (day boundaries in UTC)
    let tsComponents = utcCalendar.dateComponents([.year, .month, .day, .weekday], from: tsDate)
    let refComponents = utcCalendar.dateComponents([.year, .month, .day], from: refDate)

    // Calculate day difference
    let tsStartOfDay = utcCalendar.date(from: DateComponents(year: tsComponents.year, month: tsComponents.month, day: tsComponents.day))!
    let refStartOfDay = utcCalendar.date(from: DateComponents(year: refComponents.year, month: refComponents.month, day: refComponents.day))!

    let dayDiff = utcCalendar.dateComponents([.day], from: refStartOfDay, to: tsStartOfDay).day!

    let weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    if dayDiff == 0 {
        return "Today"
    } else if dayDiff == -1 {
        return "Yesterday"
    } else if dayDiff == 1 {
        return "Tomorrow"
    } else if dayDiff > -7 && dayDiff < 0 {
        // Within past 7 days (but not yesterday)
        let weekday = weekdays[tsComponents.weekday! - 1]
        return "Last \(weekday)"
    } else if dayDiff > 0 && dayDiff < 7 {
        // Within next 7 days (but not tomorrow)
        let weekday = weekdays[tsComponents.weekday! - 1]
        return "This \(weekday)"
    } else {
        // Beyond 7 days: show date
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"
        monthFormatter.timeZone = TimeZone(identifier: "UTC")
        let month = monthFormatter.string(from: tsDate)

        if tsComponents.year == refComponents.year {
            return "\(month) \(tsComponents.day!)"
        } else {
            return "\(month) \(tsComponents.day!), \(tsComponents.year!)"
        }
    }
}

/// Formats a date range with smart abbreviation.
///
/// - Parameters:
///   - start: Start timestamp
///   - end: End timestamp
/// - Returns: Formatted date range string
/// - Throws: WhenwordsError if timestamps are invalid
public func dateRange<T: TimestampConvertible, U: TimestampConvertible>(
    _ start: T,
    _ end: U
) throws -> String {
    var startTs = try start.toUnixSeconds()
    var endTs = try end.toUnixSeconds()

    // Swap if start > end
    if startTs > endTs {
        swap(&startTs, &endTs)
    }

    let calendar = Calendar(identifier: .gregorian)
    var utcCalendar = calendar
    utcCalendar.timeZone = TimeZone(identifier: "UTC")!

    let startDate = Date(timeIntervalSince1970: startTs)
    let endDate = Date(timeIntervalSince1970: endTs)

    let startComponents = utcCalendar.dateComponents([.year, .month, .day], from: startDate)
    let endComponents = utcCalendar.dateComponents([.year, .month, .day], from: endDate)

    let monthFormatter = DateFormatter()
    monthFormatter.dateFormat = "MMMM"
    monthFormatter.timeZone = TimeZone(identifier: "UTC")

    let startMonth = monthFormatter.string(from: startDate)
    let endMonth = monthFormatter.string(from: endDate)

    // Same day
    if startComponents.year == endComponents.year &&
       startComponents.month == endComponents.month &&
       startComponents.day == endComponents.day {
        return "\(startMonth) \(startComponents.day!), \(startComponents.year!)"
    }

    // Same month and year
    if startComponents.year == endComponents.year && startComponents.month == endComponents.month {
        return "\(startMonth) \(startComponents.day!)\u{2013}\(endComponents.day!), \(startComponents.year!)"
    }

    // Same year, different months
    if startComponents.year == endComponents.year {
        return "\(startMonth) \(startComponents.day!) \u{2013} \(endMonth) \(endComponents.day!), \(startComponents.year!)"
    }

    // Different years
    return "\(startMonth) \(startComponents.day!), \(startComponents.year!) \u{2013} \(endMonth) \(endComponents.day!), \(endComponents.year!)"
}

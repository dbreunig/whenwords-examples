package;

import haxe.Exception;

typedef DurationOptions = {
    ?compact: Bool,
    ?maxUnits: Int
}

class Whenwords {
    
    /**
     * Returns a human-readable relative time string.
     * @param timestamp Unix timestamp (seconds) or Date object
     * @param reference Optional reference timestamp (defaults to timestamp)
     * @return Human-readable relative time string
     */
    public static function timeago(timestamp: Dynamic, ?reference: Dynamic): String {
        var ts = normalizeTimestamp(timestamp);
        var ref = reference != null ? normalizeTimestamp(reference) : ts;
        
        var diff = ref - ts;
        var absDiff = Math.abs(diff);
        var isFuture = diff < 0;
        
        var value: Float;
        var unit: String;
        
        if (absDiff < 45) {
            return "just now";
        } else if (absDiff < 90) {
            value = 1;
            unit = "minute";
        } else if (absDiff < 45 * 60) {
            value = Math.round(absDiff / 60);
            unit = "minute";
        } else if (absDiff < 90 * 60) {
            value = 1;
            unit = "hour";
        } else if (absDiff < 22 * 3600) {
            value = Math.round(absDiff / 3600);
            unit = "hour";
        } else if (absDiff < 36 * 3600) {
            value = 1;
            unit = "day";
        } else if (absDiff < 26 * 86400) {
            value = Math.round(absDiff / 86400);
            unit = "day";
        } else if (absDiff < 46 * 86400) {
            value = 1;
            unit = "month";
        } else if (absDiff < 320 * 86400) {
            value = Math.round(absDiff / (30 * 86400));
            unit = "month";
        } else if (absDiff < 548 * 86400) {
            value = 1;
            unit = "year";
        } else {
            value = Math.round(absDiff / (365 * 86400));
            unit = "year";
        }
        
        var plural = value != 1 ? "s" : "";
        var valueStr = Std.string(Std.int(value));
        
        if (isFuture) {
            return 'in $valueStr $unit$plural';
        } else {
            return '$valueStr $unit$plural ago';
        }
    }
    
    /**
     * Formats a duration (not relative to now).
     * @param seconds Non-negative number of seconds
     * @param options Optional formatting options
     * @return Formatted duration string
     */
    public static function duration(seconds: Float, ?options: DurationOptions): String {
        if (seconds < 0) {
            throw new Exception("Duration cannot be negative");
        }
        if (!Math.isFinite(seconds) || Math.isNaN(seconds)) {
            throw new Exception("Duration must be a finite number");
        }
        
        var compact = options != null && options.compact == true;
        var maxUnits = options != null && options.maxUnits != null ? options.maxUnits : 2;
        
        var totalSeconds = Math.round(seconds);
        
        // Calculate all units
        var years = Std.int(Math.floor(totalSeconds / (365 * 86400)));
        var afterYears = totalSeconds % (365 * 86400);
        
        var months = Std.int(Math.floor(afterYears / (30 * 86400)));
        var afterMonths = afterYears % (30 * 86400);
        
        var days = Std.int(Math.floor(afterMonths / 86400));
        var afterDays = afterMonths % 86400;
        
        var hours = Std.int(Math.floor(afterDays / 3600));
        var afterHours = afterDays % 3600;
        
        var minutes = Std.int(Math.floor(afterHours / 60));
        var secs = afterHours % 60;
        
        // Build list of all non-zero units
        var allUnits = [];
        if (years > 0) allUnits.push({value: years, longName: "year", shortName: "y"});
        if (months > 0) allUnits.push({value: months, longName: "month", shortName: "mo"});
        if (days > 0) allUnits.push({value: days, longName: "day", shortName: "d"});
        if (hours > 0) allUnits.push({value: hours, longName: "hour", shortName: "h"});
        if (minutes > 0) allUnits.push({value: minutes, longName: "minute", shortName: "m"});
        if (secs > 0) allUnits.push({value: secs, longName: "second", shortName: "s"});
        
        if (allUnits.length == 0) {
            return compact ? "0s" : "0 seconds";
        }
        
        // Apply rounding to the smallest displayed unit if truncated
        if (allUnits.length > maxUnits) {
            // Calculate divisors for each unit type
            var divisors = [365 * 86400, 30 * 86400, 86400, 3600, 60, 1];
            
            // Find position of last unit to display
            var displayUnits = allUnits.slice(0, maxUnits);
            var lastUnitName = displayUnits[displayUnits.length - 1].shortName;
            
            // Get the divisor for the last unit
            var lastDivisor = switch (lastUnitName) {
                case "y": 365 * 86400;
                case "mo": 30 * 86400;
                case "d": 86400;
                case "h": 3600;
                case "m": 60;
                case "s": 1;
                default: 1;
            }
            
            // Calculate what's left after the last displayed unit
            var accounted = 0.0;
            var unitDivisors = [365 * 86400, 30 * 86400, 86400, 3600, 60, 1];
            
            for (i in 0...maxUnits) {
                if (i < allUnits.length) {
                    var div = switch (allUnits[i].shortName) {
                        case "y": 365 * 86400;
                        case "mo": 30 * 86400;
                        case "d": 86400;
                        case "h": 3600;
                        case "m": 60;
                        case "s": 1;
                        default: 1;
                    }
                    accounted += allUnits[i].value * div;
                }
            }
            
            var remaining = totalSeconds - accounted;
            
            // Round up the last displayed unit if remaining is significant
            if (remaining >= lastDivisor / 2) {
                displayUnits[displayUnits.length - 1].value++;
            }
            
            allUnits = displayUnits;
        }
        
        var parts: Array<String> = [];
        for (unit in allUnits) {
            parts.push(formatUnit(unit.value, unit.longName, unit.shortName, compact));
        }
        
        return compact ? parts.join(" ") : parts.join(", ");
    }
    
    /**
     * Parses a human-written duration string into seconds.
     * @param str Duration string to parse
     * @return Number of seconds
     */
    public static function parseDuration(str: String): Float {
        if (str == null || StringTools.trim(str) == "") {
            throw new Exception("Duration string cannot be empty");
        }
        
        str = StringTools.trim(str).toLowerCase();
        
        // Try colon notation first
        var colonRegex = ~/^(\d+):(\d+)(?::(\d+))?$/;
        if (colonRegex.match(str)) {
            var hours = Std.parseInt(colonRegex.matched(1));
            var minutes = Std.parseInt(colonRegex.matched(2));
            var seconds = colonRegex.matched(3) != null ? Std.parseInt(colonRegex.matched(3)) : 0;
            return hours * 3600 + minutes * 60 + seconds;
        }
        
        var total: Float = 0;
        
        // Remove commas and "and"
        str = StringTools.replace(str, ",", " ");
        str = StringTools.replace(str, " and ", " ");
        
        // Pattern for matching duration components
        var pattern = ~/([-]?\d+(?:\.\d+)?)\s*([a-z]+)/g;
        var matched = false;
        
        while (pattern.match(str)) {
            matched = true;
            var value = Std.parseFloat(pattern.matched(1));
            var unit = pattern.matched(2);
            
            if (value < 0) {
                throw new Exception("Duration values cannot be negative");
            }
            
            var multiplier = getUnitMultiplier(unit);
            if (multiplier == null) {
                throw new Exception('Unknown duration unit: $unit');
            }
            
            total += value * multiplier;
            str = pattern.matchedRight();
        }
        
        if (!matched) {
            throw new Exception("No parseable duration found in string");
        }
        
        if (total < 0) {
            throw new Exception("Duration cannot be negative");
        }
        
        return total;
    }
    
    /**
     * Returns a contextual date string.
     * @param timestamp The date to format
     * @param reference The "current" date for comparison
     * @return Contextual date string
     */
    public static function humanDate(timestamp: Dynamic, reference: Dynamic): String {
        var ts = normalizeTimestamp(timestamp);
        var ref = normalizeTimestamp(reference);
        
        var tsDate = dateFromUnixSeconds(ts);
        var refDate = dateFromUnixSeconds(ref);
        
        var tsDayStart = getDayStartTimestamp(ts);
        var refDayStart = getDayStartTimestamp(ref);
        
        var daysDiff = Math.round((tsDayStart - refDayStart) / 86400);
        
        if (daysDiff == 0) {
            return "Today";
        } else if (daysDiff == -1) {
            return "Yesterday";
        } else if (daysDiff == 1) {
            return "Tomorrow";
        } else if (daysDiff >= -6 && daysDiff < 0) {
            return "Last " + getWeekdayName(tsDate.weekday);
        } else if (daysDiff > 1 && daysDiff <= 6) {
            return "This " + getWeekdayName(tsDate.weekday);
        }
        
        // Same year check
        if (tsDate.year == refDate.year) {
            return getMonthName(tsDate.month) + " " + tsDate.day;
        }
        
        // Different year
        return getMonthName(tsDate.month) + " " + tsDate.day + ", " + tsDate.year;
    }
    
    /**
     * Formats a date range with smart abbreviation.
     * @param start Start timestamp
     * @param end End timestamp
     * @return Formatted date range string
     */
    public static function dateRange(start: Dynamic, end: Dynamic): String {
        var startTs = normalizeTimestamp(start);
        var endTs = normalizeTimestamp(end);
        
        // Swap if needed
        if (startTs > endTs) {
            var temp = startTs;
            startTs = endTs;
            endTs = temp;
        }
        
        var startDate = dateFromUnixSeconds(startTs);
        var endDate = dateFromUnixSeconds(endTs);
        
        var startDayStart = getDayStartTimestamp(startTs);
        var endDayStart = getDayStartTimestamp(endTs);
        
        // Same day
        if (startDayStart == endDayStart) {
            return getMonthName(startDate.month) + " " + startDate.day + ", " + startDate.year;
        }
        
        // Same month and year
        if (startDate.year == endDate.year && startDate.month == endDate.month) {
            return getMonthName(startDate.month) + " " + startDate.day + "–" + endDate.day + ", " + startDate.year;
        }
        
        // Same year, different months
        if (startDate.year == endDate.year) {
            return getMonthName(startDate.month) + " " + startDate.day + " – " + 
                   getMonthName(endDate.month) + " " + endDate.day + ", " + startDate.year;
        }
        
        // Different years
        return getMonthName(startDate.month) + " " + startDate.day + ", " + startDate.year + " – " +
               getMonthName(endDate.month) + " " + endDate.day + ", " + endDate.year;
    }
    
    // Helper functions
    
    private static function normalizeTimestamp(timestamp: Dynamic): Float {
        if (Std.isOfType(timestamp, Float) || Std.isOfType(timestamp, Int)) {
            return cast(timestamp, Float);
        } else if (Std.isOfType(timestamp, Date)) {
            return cast(timestamp, Date).getTime() / 1000;
        } else if (Std.isOfType(timestamp, String)) {
            // Parse ISO 8601 string
            var date = Date.fromString(cast(timestamp, String));
            return date.getTime() / 1000;
        }
        throw new Exception("Invalid timestamp format");
    }
    
    private static function dateFromUnixSeconds(timestamp: Float): {year: Int, month: Int, day: Int, weekday: Int} {
        // Convert Unix timestamp to UTC date components
        var days = Math.floor(timestamp / 86400);
        var seconds = Std.int(timestamp % 86400);
        
        // Unix epoch is Thursday, January 1, 1970
        var weekday = Std.int((days + 4) % 7);
        if (weekday < 0) weekday += 7;
        
        // Calculate year, month, day
        var year = 1970;
        var month = 1;
        var day = 1;
        
        // Add days from epoch
        var totalDays = Std.int(days);
        
        // Calculate year
        while (true) {
            var daysInYear = isLeapYear(year) ? 366 : 365;
            if (totalDays < daysInYear) break;
            totalDays -= daysInYear;
            year++;
        }
        
        // Calculate month
        while (true) {
            var daysInMonth = getDaysInMonth(year, month);
            if (totalDays < daysInMonth) break;
            totalDays -= daysInMonth;
            month++;
        }
        
        // Calculate day
        day = totalDays + 1;
        
        return {year: year, month: month, day: day, weekday: weekday};
    }
    
    private static function getDayStartTimestamp(timestamp: Float): Float {
        // Get start of day in UTC
        var days = Math.floor(timestamp / 86400);
        return days * 86400;
    }
    
    private static function isLeapYear(year: Int): Bool {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
    }
    
    private static function getDaysInMonth(year: Int, month: Int): Int {
        return switch (month) {
            case 1: 31;
            case 2: isLeapYear(year) ? 29 : 28;
            case 3: 31;
            case 4: 30;
            case 5: 31;
            case 6: 30;
            case 7: 31;
            case 8: 31;
            case 9: 30;
            case 10: 31;
            case 11: 30;
            case 12: 31;
            default: 0;
        }
    }
    
    private static function formatUnit(value: Float, longName: String, shortName: String, compact: Bool): String {
        var intValue = Std.int(value);
        if (compact) {
            return '$intValue$shortName';
        } else {
            var plural = intValue != 1 ? "s" : "";
            return '$intValue $longName$plural';
        }
    }
    
    private static function getUnitCarryLimit(unitIndex: Int): Int {
        // Not used in simple implementation but kept for potential carry-over logic
        return switch (unitIndex) {
            case 5: 60; // seconds -> minutes
            case 4: 60; // minutes -> hours
            case 3: 24; // hours -> days
            case 2: 30; // days -> months (approximate)
            case 1: 12; // months -> years
            default: 999999;
        }
    }
    
    private static function getUnitMultiplier(unit: String): Null<Float> {
        return switch (unit) {
            case "s" | "sec" | "secs" | "second" | "seconds": 1;
            case "m" | "min" | "mins" | "minute" | "minutes": 60;
            case "h" | "hr" | "hrs" | "hour" | "hours": 3600;
            case "d" | "day" | "days": 86400;
            case "w" | "wk" | "wks" | "week" | "weeks": 604800;
            default: null;
        }
    }
    
    private static function getWeekdayName(weekday: Int): String {
        return switch (weekday) {
            case 0: "Sunday";
            case 1: "Monday";
            case 2: "Tuesday";
            case 3: "Wednesday";
            case 4: "Thursday";
            case 5: "Friday";
            case 6: "Saturday";
            default: "";
        }
    }
    
    private static function getMonthName(month: Int): String {
        return switch (month) {
            case 1: "January";
            case 2: "February";
            case 3: "March";
            case 4: "April";
            case 5: "May";
            case 6: "June";
            case 7: "July";
            case 8: "August";
            case 9: "September";
            case 10: "October";
            case 11: "November";
            case 12: "December";
            default: "";
        }
    }
}

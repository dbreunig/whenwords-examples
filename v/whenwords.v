module whenwords

import time
import math

pub struct DurationOptions {
pub:
	compact   bool
	max_units int = 2
}

// timeago returns a human-readable relative time string
pub fn timeago(timestamp i64, reference i64) string {
	diff := reference - timestamp
	abs_diff := if diff < 0 { -diff } else { diff }

	// Determine if future or past
	future := diff < 0

	// Convert to appropriate unit and format
	mut result := ''

	if abs_diff < 45 {
		result = 'just now'
	} else if abs_diff < 90 {
		result = if future { 'in 1 minute' } else { '1 minute ago' }
	} else if abs_diff < 45 * 60 {
		minutes := round(f64(abs_diff) / 60.0)
		result = if future { 'in ${minutes} minutes' } else { '${minutes} minutes ago' }
	} else if abs_diff < 90 * 60 {
		result = if future { 'in 1 hour' } else { '1 hour ago' }
	} else if abs_diff < 22 * 3600 {
		hours := round(f64(abs_diff) / 3600.0)
		result = if future { 'in ${hours} hours' } else { '${hours} hours ago' }
	} else if abs_diff < 36 * 3600 {
		result = if future { 'in 1 day' } else { '1 day ago' }
	} else if abs_diff < 26 * 86400 {
		days := round(f64(abs_diff) / 86400.0)
		result = if future { 'in ${days} days' } else { '${days} days ago' }
	} else if abs_diff < 46 * 86400 {
		result = if future { 'in 1 month' } else { '1 month ago' }
	} else if abs_diff < 320 * 86400 {
		months := round(f64(abs_diff) / (30.0 * 86400))
		result = if future { 'in ${months} months' } else { '${months} months ago' }
	} else if abs_diff < 548 * 86400 {
		result = if future { 'in 1 year' } else { '1 year ago' }
	} else {
		years := round(f64(abs_diff) / (365.0 * 86400))
		result = if future { 'in ${years} years' } else { '${years} years ago' }
	}

	return result
}

// round rounds a number to the nearest integer using half-up rounding
fn round(x f64) int {
	return int(math.floor(x + 0.5))
}

// duration formats a duration in seconds to a human-readable string
pub fn duration(seconds i64, options DurationOptions) !string {
	if seconds < 0 {
		return error('negative seconds not allowed')
	}

	if seconds == 0 {
		return if options.compact { '0s' } else { '0 seconds' }
	}

	mut remaining := seconds
	mut parts := []string{}

	// Define units in order: years, months, days, hours, minutes, seconds
	units := [
		Unit{'year', 'y', 365 * 86400},
		Unit{'month', 'mo', 30 * 86400},
		Unit{'day', 'd', 86400},
		Unit{'hour', 'h', 3600},
		Unit{'minute', 'm', 60},
		Unit{'second', 's', 1},
	]

	mut unit_idx := 0
	for unit_idx < units.len {
		unit := units[unit_idx]
		if remaining >= unit.seconds {
			mut count := remaining / unit.seconds
			remaining = remaining % unit.seconds

			// If we're at the last unit we can show (max_units), round based on remaining
			if parts.len + 1 >= options.max_units && unit_idx + 1 < units.len {
				next_unit := units[unit_idx + 1]
				next_count := remaining / next_unit.seconds
				// Round up if the next unit has >= half of its threshold
				if next_count * next_unit.seconds * 2 >= unit.seconds {
					count++
				}
				remaining = 0
			}

			if options.compact {
				parts << '${count}${unit.short}'
			} else {
				unit_name := if count == 1 { unit.name } else { unit.name + 's' }
				parts << '${count} ${unit_name}'
			}

			if parts.len >= options.max_units {
				break
			}
		}
		unit_idx++
	}

	separator := if options.compact { ' ' } else { ', ' }
	return parts.join(separator)
}

struct Unit {
	name    string
	short   string
	seconds i64
}

// parse_duration parses a human-written duration string into seconds
pub fn parse_duration(input string) !i64 {
	trimmed := input.trim_space()
	if trimmed.len == 0 {
		return error('empty string')
	}

	// Check for colon notation first (e.g., "2:30" or "1:30:00")
	if trimmed.contains(':') {
		return parse_colon_notation(trimmed)
	}

	// Parse unit-based durations
	mut total := i64(0)
	mut found_any := false

	// Convert to lowercase for case-insensitive matching
	lower := trimmed.to_lower()

	// Define regex-like patterns manually
	// We'll iterate through the string and extract number-unit pairs
	mut i := 0
	for i < lower.len {
		// Skip whitespace and separators
		if lower[i] in [` `, `,`] {
			i++
			continue
		}

		// Skip "and"
		if i + 3 <= lower.len && lower[i..i + 3] == 'and' {
			i += 3
			continue
		}

		// Try to parse a number
		mut num_start := i
		mut num_end := i
		mut has_decimal := false

		// Check for negative sign
		if lower[i] == `-` {
			return error('negative values not allowed')
		}

		// Parse digits and decimal point
		for num_end < lower.len && (lower[num_end].is_digit() || lower[num_end] == `.`) {
			if lower[num_end] == `.` {
				has_decimal = true
			}
			num_end++
		}

		if num_end == num_start {
			i++
			continue
		}

		num_str := lower[num_start..num_end]
		value := if has_decimal { num_str.f64() } else { num_str.f64() }

		i = num_end

		// Skip whitespace between number and unit
		for i < lower.len && lower[i] == ` ` {
			i++
		}

		// Parse unit
		mut unit_start := i
		mut unit_end := i
		for unit_end < lower.len && lower[unit_end].is_letter() {
			unit_end++
		}

		if unit_end == unit_start {
			// No unit found after number
			if !found_any {
				return error('no units found')
			}
			break
		}

		unit_str := lower[unit_start..unit_end]
		i = unit_end

		// Map unit to seconds
		seconds := match unit_str {
			's', 'sec', 'secs', 'second', 'seconds' { i64(value) }
			'm', 'min', 'mins', 'minute', 'minutes' { i64(value * 60) }
			'h', 'hr', 'hrs', 'hour', 'hours' { i64(value * 3600) }
			'd', 'day', 'days' { i64(value * 86400) }
			'w', 'wk', 'wks', 'week', 'weeks' { i64(value * 604800) }
			'mo', 'month', 'months' { i64(value * 2592000) }
			'y', 'year', 'years' { i64(value * 31536000) }
			else { return error('unknown unit: ${unit_str}') }
		}

		total += seconds
		found_any = true
	}

	if !found_any {
		return error('no valid duration found')
	}

	if total < 0 {
		return error('negative duration')
	}

	return total
}

fn parse_colon_notation(input string) !i64 {
	parts := input.split(':')
	if parts.len < 2 || parts.len > 3 {
		return error('invalid colon notation')
	}

	mut total := i64(0)

	if parts.len == 2 {
		// h:mm format
		hours := parts[0].int()
		minutes := parts[1].int()
		total = i64(hours * 3600 + minutes * 60)
	} else if parts.len == 3 {
		// h:mm:ss format
		hours := parts[0].int()
		minutes := parts[1].int()
		seconds := parts[2].int()
		total = i64(hours * 3600 + minutes * 60 + seconds)
	}

	return total
}

// human_date returns a contextual date string
pub fn human_date(timestamp i64, reference i64) string {
	// Convert to time.Time for easier date manipulation
	t := time.unix(timestamp)
	ref := time.unix(reference)

	// Get day boundaries in UTC
	t_day := day_start(t)
	ref_day := day_start(ref)

	diff_days := (t_day - ref_day) / 86400

	// Same day
	if diff_days == 0 {
		return 'Today'
	}

	// Yesterday
	if diff_days == -1 {
		return 'Yesterday'
	}

	// Tomorrow
	if diff_days == 1 {
		return 'Tomorrow'
	}

	// Within past 7 days (2-6 days ago)
	if diff_days >= -6 && diff_days < -1 {
		weekday := get_weekday_name(t)
		return 'Last ${weekday}'
	}

	// Within next 7 days (2-6 days future)
	if diff_days >= 2 && diff_days <= 6 {
		weekday := get_weekday_name(t)
		return 'This ${weekday}'
	}

	// Same year - show month and day
	if t.year == ref.year {
		month := get_month_name(t)
		return '${month} ${t.day}'
	}

	// Different year - show month, day, and year
	month := get_month_name(t)
	return '${month} ${t.day}, ${t.year}'
}

// day_start returns the Unix timestamp for the start of the day (00:00:00 UTC)
fn day_start(t time.Time) i64 {
	// Calculate the start of the day by zeroing hours, minutes, seconds
	day_seconds := t.hour * 3600 + t.minute * 60 + t.second
	return t.unix() - day_seconds
}

fn get_weekday_name(t time.Time) string {
	// V's time module uses 1=Monday, 2=Tuesday, ..., 7=Sunday
	weekday := t.day_of_week()
	return match weekday {
		1 { 'Monday' }
		2 { 'Tuesday' }
		3 { 'Wednesday' }
		4 { 'Thursday' }
		5 { 'Friday' }
		6 { 'Saturday' }
		7 { 'Sunday' }
		else { 'Unknown' }
	}
}

fn get_month_name(t time.Time) string {
	return match t.month {
		1 { 'January' }
		2 { 'February' }
		3 { 'March' }
		4 { 'April' }
		5 { 'May' }
		6 { 'June' }
		7 { 'July' }
		8 { 'August' }
		9 { 'September' }
		10 { 'October' }
		11 { 'November' }
		12 { 'December' }
		else { 'Unknown' }
	}
}

// date_range formats a date range with smart abbreviation
pub fn date_range(start i64, end i64) string {
	// Swap if start is after end
	mut s := start
	mut e := end
	if s > e {
		s, e = e, s
	}

	s_time := time.unix(s)
	e_time := time.unix(e)

	// Get day boundaries
	s_day := day_start(s_time)
	e_day := day_start(e_time)

	// Same day
	if s_day == e_day {
		month := get_month_name(s_time)
		return '${month} ${s_time.day}, ${s_time.year}'
	}

	// Same month and year
	if s_time.year == e_time.year && s_time.month == e_time.month {
		month := get_month_name(s_time)
		return '${month} ${s_time.day}–${e_time.day}, ${s_time.year}'
	}

	// Same year, different months
	if s_time.year == e_time.year {
		s_month := get_month_name(s_time)
		e_month := get_month_name(e_time)
		return '${s_month} ${s_time.day} – ${e_month} ${e_time.day}, ${s_time.year}'
	}

	// Different years
	s_month := get_month_name(s_time)
	e_month := get_month_name(e_time)
	return '${s_month} ${s_time.day}, ${s_time.year} – ${e_month} ${e_time.day}, ${e_time.year}'
}

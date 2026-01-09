#!/usr/bin/env bash
# whenwords - Human-friendly time formatting and parsing for Bash
# Version 0.1.0

# Round to nearest integer (standard rounding)
_ww_round() {
    local num="$1"
    awk "BEGIN { printf \"%.0f\", $num }"
}

# Pluralize a unit
_ww_pluralize() {
    local count="$1"
    local singular="$2"
    local plural="${3:-${singular}s}"
    if [[ "$count" -eq 1 ]]; then
        echo "$singular"
    else
        echo "$plural"
    fi
}

# timeago - Returns a human-readable relative time string
# Usage: timeago <timestamp> [reference]
# Arguments:
#   timestamp: Unix timestamp (seconds)
#   reference: Optional reference timestamp (defaults to timestamp)
# Returns: Human-readable string like "3 hours ago" or "in 2 days"
timeago() {
    local timestamp="$1"
    local reference="${2:-$timestamp}"

    # Validate inputs
    if [[ -z "$timestamp" ]] || ! [[ "$timestamp" =~ ^-?[0-9]+$ ]]; then
        echo "Error: Invalid timestamp" >&2
        return 1
    fi
    if ! [[ "$reference" =~ ^-?[0-9]+$ ]]; then
        echo "Error: Invalid reference timestamp" >&2
        return 1
    fi

    local diff=$((reference - timestamp))
    local abs_diff=${diff#-}
    local is_future=0

    if [[ $diff -lt 0 ]]; then
        is_future=1
        abs_diff=$((-diff))
    fi

    local result=""
    local n

    # Thresholds (in seconds)
    local SEC=1
    local MIN=60
    local HOUR=3600
    local DAY=86400

    if [[ $abs_diff -lt 45 ]]; then
        result="just now"
    elif [[ $abs_diff -lt 90 ]]; then
        result="1 minute"
    elif [[ $abs_diff -lt $((45 * MIN)) ]]; then
        n=$(_ww_round "$(awk "BEGIN { print $abs_diff / $MIN }")")
        result="$n $(_ww_pluralize "$n" minute)"
    elif [[ $abs_diff -lt $((90 * MIN)) ]]; then
        result="1 hour"
    elif [[ $abs_diff -lt $((22 * HOUR)) ]]; then
        n=$(_ww_round "$(awk "BEGIN { print $abs_diff / $HOUR }")")
        result="$n $(_ww_pluralize "$n" hour)"
    elif [[ $abs_diff -lt $((36 * HOUR)) ]]; then
        result="1 day"
    elif [[ $abs_diff -lt $((26 * DAY)) ]]; then
        n=$(_ww_round "$(awk "BEGIN { print $abs_diff / $DAY }")")
        result="$n $(_ww_pluralize "$n" day)"
    elif [[ $abs_diff -lt $((46 * DAY)) ]]; then
        result="1 month"
    elif [[ $abs_diff -lt $((320 * DAY)) ]]; then
        # Round months but cap at 10 (since 320 days = 1 year threshold)
        n=$(_ww_round "$(awk "BEGIN { print $abs_diff / (30 * $DAY) }")")
        if [[ $n -gt 10 ]]; then n=10; fi
        result="$n $(_ww_pluralize "$n" month)"
    elif [[ $abs_diff -lt $((548 * DAY)) ]]; then
        result="1 year"
    else
        # Round years
        n=$(_ww_round "$(awk "BEGIN { print $abs_diff / (365 * $DAY) }")")
        result="$n $(_ww_pluralize "$n" year)"
    fi

    # Handle future vs past
    if [[ "$result" == "just now" ]]; then
        echo "just now"
    elif [[ $is_future -eq 1 ]]; then
        echo "in $result"
    else
        echo "$result ago"
    fi
}

# duration - Formats a duration (not relative to now)
# Usage: duration <seconds> [compact] [max_units]
# Arguments:
#   seconds: Non-negative number of seconds
#   compact: "true" for compact format (2h 30m), "false" for verbose (default)
#   max_units: Maximum units to show (default 2)
# Returns: Formatted duration string
duration() {
    local seconds="$1"
    local compact="${2:-false}"
    local max_units="${3:-2}"

    # Validate inputs
    if [[ -z "$seconds" ]]; then
        echo "Error: seconds is required" >&2
        return 1
    fi

    # Check for negative
    if [[ "$seconds" =~ ^- ]]; then
        echo "Error: seconds cannot be negative" >&2
        return 1
    fi

    if ! [[ "$seconds" =~ ^[0-9]+\.?[0-9]*$ ]]; then
        echo "Error: Invalid seconds value" >&2
        return 1
    fi

    # Convert to integer
    seconds=$(echo "$seconds" | awk '{printf "%.0f", $1}')

    # Handle zero
    if [[ "$seconds" -eq 0 ]]; then
        if [[ "$compact" == "true" ]]; then
            echo "0s"
        else
            echo "0 seconds"
        fi
        return 0
    fi

    # Unit definitions (in seconds)
    local YEAR=$((365 * 86400))
    local MONTH=$((30 * 86400))
    local DAY=86400
    local HOUR=3600
    local MIN=60

    local units=()
    local values=()
    local remaining=$seconds

    # Calculate each unit
    if [[ $remaining -ge $YEAR ]]; then
        values+=($((remaining / YEAR)))
        units+=("year")
        remaining=$((remaining % YEAR))
    fi
    if [[ $remaining -ge $MONTH ]]; then
        values+=($((remaining / MONTH)))
        units+=("month")
        remaining=$((remaining % MONTH))
    fi
    if [[ $remaining -ge $DAY ]]; then
        values+=($((remaining / DAY)))
        units+=("day")
        remaining=$((remaining % DAY))
    fi
    if [[ $remaining -ge $HOUR ]]; then
        values+=($((remaining / HOUR)))
        units+=("hour")
        remaining=$((remaining % HOUR))
    fi
    if [[ $remaining -ge $MIN ]]; then
        values+=($((remaining / MIN)))
        units+=("minute")
        remaining=$((remaining % MIN))
    fi
    if [[ $remaining -gt 0 ]] || [[ ${#values[@]} -eq 0 ]]; then
        values+=($remaining)
        units+=("second")
    fi

    # Limit to max_units
    local count=${#values[@]}
    if [[ $count -gt $max_units ]]; then
        count=$max_units
    fi

    # Build output
    local result=""
    local i
    for ((i = 0; i < count; i++)); do
        local val="${values[$i]}"
        local unit="${units[$i]}"

        if [[ "$compact" == "true" ]]; then
            local short_unit
            case "$unit" in
                year) short_unit="y" ;;
                month) short_unit="mo" ;;
                day) short_unit="d" ;;
                hour) short_unit="h" ;;
                minute) short_unit="m" ;;
                second) short_unit="s" ;;
            esac
            if [[ -n "$result" ]]; then
                result="$result $val$short_unit"
            else
                result="$val$short_unit"
            fi
        else
            local plural_unit=$(_ww_pluralize "$val" "$unit")
            if [[ -n "$result" ]]; then
                result="$result, $val $plural_unit"
            else
                result="$val $plural_unit"
            fi
        fi
    done

    echo "$result"
}

# Get unit multiplier for parse_duration
_ww_get_multiplier() {
    local unit="$1"
    case "$unit" in
        s|sec|secs|second|seconds) echo 1 ;;
        m|min|mins|minute|minutes) echo 60 ;;
        h|hr|hrs|hour|hours) echo 3600 ;;
        d|day|days) echo 86400 ;;
        w|wk|wks|week|weeks) echo 604800 ;;
        *) echo 0 ;;
    esac
}

# parse_duration - Parses a human-written duration string into seconds
# Usage: parse_duration <string>
# Arguments:
#   string: Duration string like "2h 30m", "2 hours 30 minutes", "2:30"
# Returns: Number of seconds
parse_duration() {
    local input="$1"

    # Trim whitespace
    input=$(echo "$input" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    # Check for empty string
    if [[ -z "$input" ]]; then
        echo "Error: Empty string" >&2
        return 1
    fi

    # Check for negative
    if [[ "$input" =~ ^- ]]; then
        echo "Error: Negative duration" >&2
        return 1
    fi

    # Convert to lowercase for easier parsing
    local lower_input=$(echo "$input" | tr '[:upper:]' '[:lower:]')

    # Handle colon notation (h:mm or h:mm:ss)
    if [[ "$lower_input" =~ ^[0-9]+:[0-9]+(:[0-9]+)?$ ]]; then
        local IFS=':'
        local parts=($lower_input)
        local total=0

        if [[ ${#parts[@]} -eq 2 ]]; then
            # h:mm format
            total=$(( ${parts[0]} * 3600 + ${parts[1]} * 60 ))
        elif [[ ${#parts[@]} -eq 3 ]]; then
            # h:mm:ss format
            total=$(( ${parts[0]} * 3600 + ${parts[1]} * 60 + ${parts[2]} ))
        fi
        echo "$total"
        return 0
    fi

    # Remove "and", commas, extra spaces for parsing
    local cleaned=$(echo "$lower_input" | sed 's/,/ /g; s/ and / /g; s/[[:space:]]\+/ /g')

    local total=0
    local found_unit=0

    # Parse using bash - handle both "2h30m" and "2 hours 30 minutes" formats
    # First, insert spaces between numbers and units for uniform parsing
    cleaned=$(echo "$cleaned" | sed 's/\([0-9.]\)\([a-z]\)/\1 \2/g; s/\([a-z]\)\([0-9]\)/\1 \2/g')

    # Convert to array
    read -ra tokens <<< "$cleaned"

    local i=0
    while [[ $i -lt ${#tokens[@]} ]]; do
        local token="${tokens[$i]}"

        # Check if token is a number
        if [[ "$token" =~ ^[0-9]+\.?[0-9]*$ ]]; then
            local num="$token"
            local unit=""
            local mult=0

            # Look for unit in next token
            if [[ $((i + 1)) -lt ${#tokens[@]} ]]; then
                unit="${tokens[$((i + 1))]}"
            fi

            # Determine multiplier
            case "$unit" in
                s|sec|secs|second|seconds) mult=1 ;;
                m|min|mins|minute|minutes) mult=60 ;;
                h|hr|hrs|hour|hours) mult=3600 ;;
                d|day|days) mult=86400 ;;
                w|wk|wks|week|weeks) mult=604800 ;;
            esac

            if [[ $mult -gt 0 ]]; then
                # Calculate seconds (handle decimals with awk)
                local secs=$(awk "BEGIN { printf \"%.0f\", $num * $mult }")
                total=$((total + secs))
                found_unit=1
                ((i += 2))  # Skip both number and unit
            else
                ((i++))
            fi
        else
            ((i++))
        fi
    done

    if [[ $found_unit -eq 0 ]]; then
        echo "Error: No parseable units found" >&2
        return 1
    fi

    echo "$total"
}

# Get day of year from timestamp (UTC)
_ww_day_of_year() {
    local ts="$1"
    if [[ "$(uname)" == "Darwin" ]]; then
        date -u -r "$ts" '+%j'
    else
        date -u -d "@$ts" '+%j'
    fi
}

# Get year from timestamp (UTC)
_ww_year() {
    local ts="$1"
    if [[ "$(uname)" == "Darwin" ]]; then
        date -u -r "$ts" '+%Y'
    else
        date -u -d "@$ts" '+%Y'
    fi
}

# Get month from timestamp (UTC)
_ww_month() {
    local ts="$1"
    if [[ "$(uname)" == "Darwin" ]]; then
        date -u -r "$ts" '+%-m'
    else
        date -u -d "@$ts" '+%-m'
    fi
}

# Get day of month from timestamp (UTC)
_ww_day() {
    local ts="$1"
    if [[ "$(uname)" == "Darwin" ]]; then
        date -u -r "$ts" '+%-d'
    else
        date -u -d "@$ts" '+%-d'
    fi
}

# Get weekday name from timestamp (UTC)
_ww_weekday() {
    local ts="$1"
    if [[ "$(uname)" == "Darwin" ]]; then
        date -u -r "$ts" '+%A'
    else
        date -u -d "@$ts" '+%A'
    fi
}

# Get month name from timestamp (UTC)
_ww_month_name() {
    local ts="$1"
    if [[ "$(uname)" == "Darwin" ]]; then
        date -u -r "$ts" '+%B'
    else
        date -u -d "@$ts" '+%B'
    fi
}

# Get start of day (midnight UTC) for a timestamp
_ww_start_of_day() {
    local ts="$1"
    local datestr
    if [[ "$(uname)" == "Darwin" ]]; then
        datestr=$(date -u -r "$ts" '+%Y-%m-%d')
        date -u -j -f '%Y-%m-%d %H:%M:%S' "$datestr 00:00:00" '+%s'
    else
        datestr=$(date -u -d "@$ts" '+%Y-%m-%d')
        date -u -d "$datestr 00:00:00" '+%s'
    fi
}

# human_date - Returns a contextual date string
# Usage: human_date <timestamp> [reference]
# Arguments:
#   timestamp: Unix timestamp to format
#   reference: Reference timestamp for comparison
# Returns: Contextual date string like "Today", "Yesterday", "Last Wednesday"
human_date() {
    local timestamp="$1"
    local reference="$2"

    # Validate inputs
    if [[ -z "$timestamp" ]] || ! [[ "$timestamp" =~ ^-?[0-9]+$ ]]; then
        echo "Error: Invalid timestamp" >&2
        return 1
    fi
    if [[ -z "$reference" ]] || ! [[ "$reference" =~ ^-?[0-9]+$ ]]; then
        echo "Error: Invalid reference timestamp" >&2
        return 1
    fi

    # Get start of day for both timestamps
    local ts_day=$(_ww_start_of_day "$timestamp")
    local ref_day=$(_ww_start_of_day "$reference")

    # Calculate day difference
    local day_diff=$(( (ref_day - ts_day) / 86400 ))

    # Get year info
    local ts_year=$(_ww_year "$timestamp")
    local ref_year=$(_ww_year "$reference")

    # Same day
    if [[ $day_diff -eq 0 ]]; then
        echo "Today"
        return 0
    fi

    # Yesterday
    if [[ $day_diff -eq 1 ]]; then
        echo "Yesterday"
        return 0
    fi

    # Tomorrow
    if [[ $day_diff -eq -1 ]]; then
        echo "Tomorrow"
        return 0
    fi

    # Within past 7 days (2-6 days ago) - 7 days shows as date
    if [[ $day_diff -ge 2 ]] && [[ $day_diff -le 6 ]]; then
        local weekday=$(_ww_weekday "$timestamp")
        echo "Last $weekday"
        return 0
    fi

    # Within next 7 days (2-6 days future) - 7 days shows as date
    if [[ $day_diff -le -2 ]] && [[ $day_diff -ge -6 ]]; then
        local weekday=$(_ww_weekday "$timestamp")
        echo "This $weekday"
        return 0
    fi

    # Format date
    local month=$(_ww_month_name "$timestamp")
    local day=$(_ww_day "$timestamp")

    if [[ "$ts_year" == "$ref_year" ]]; then
        echo "$month $day"
    else
        echo "$month $day, $ts_year"
    fi
}

# date_range - Formats a date range with smart abbreviation
# Usage: date_range <start> <end>
# Arguments:
#   start: Start timestamp
#   end: End timestamp
# Returns: Formatted date range string
date_range() {
    local start="$1"
    local end="$2"

    # Validate inputs
    if [[ -z "$start" ]] || ! [[ "$start" =~ ^-?[0-9]+$ ]]; then
        echo "Error: Invalid start timestamp" >&2
        return 1
    fi
    if [[ -z "$end" ]] || ! [[ "$end" =~ ^-?[0-9]+$ ]]; then
        echo "Error: Invalid end timestamp" >&2
        return 1
    fi

    # Swap if start > end
    if [[ $start -gt $end ]]; then
        local tmp=$start
        start=$end
        end=$tmp
    fi

    # Get date components
    local start_year=$(_ww_year "$start")
    local start_month=$(_ww_month "$start")
    local start_month_name=$(_ww_month_name "$start")
    local start_day=$(_ww_day "$start")
    local start_day_ts=$(_ww_start_of_day "$start")

    local end_year=$(_ww_year "$end")
    local end_month=$(_ww_month "$end")
    local end_month_name=$(_ww_month_name "$end")
    local end_day=$(_ww_day "$end")
    local end_day_ts=$(_ww_start_of_day "$end")

    # En-dash character (U+2013)
    local endash=$'\xe2\x80\x93'

    # Same day
    if [[ "$start_day_ts" == "$end_day_ts" ]]; then
        echo "$start_month_name $start_day, $start_year"
        return 0
    fi

    # Same month and year
    if [[ "$start_year" == "$end_year" ]] && [[ "$start_month" == "$end_month" ]]; then
        echo "$start_month_name $start_day${endash}$end_day, $start_year"
        return 0
    fi

    # Same year, different months
    if [[ "$start_year" == "$end_year" ]]; then
        echo "$start_month_name $start_day ${endash} $end_month_name $end_day, $start_year"
        return 0
    fi

    # Different years
    echo "$start_month_name $start_day, $start_year ${endash} $end_month_name $end_day, $end_year"
}

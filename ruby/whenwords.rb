# frozen_string_literal: true

require 'time'

module Whenwords
  SECONDS_PER_MINUTE = 60
  SECONDS_PER_HOUR = 3600
  SECONDS_PER_DAY = 86400
  SECONDS_PER_WEEK = 604800
  SECONDS_PER_MONTH = 2592000  # 30 days
  SECONDS_PER_YEAR = 31536000  # 365 days

  WEEKDAYS = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].freeze
  MONTHS = %w[January February March April May June July August September October November December].freeze

  class << self
    # Converts a timestamp to Unix seconds
    def normalize_timestamp(ts)
      case ts
      when Numeric
        ts.to_f
      when String
        Time.parse(ts).to_f
      when Time
        ts.to_f
      when DateTime
        ts.to_time.to_f
      when Date
        Time.utc(ts.year, ts.month, ts.day).to_f
      else
        raise ArgumentError, "Invalid timestamp format: #{ts.class}"
      end
    end

    # Returns a human-readable relative time string
    def timeago(timestamp, reference = nil)
      ts = normalize_timestamp(timestamp)
      ref = reference.nil? ? ts : normalize_timestamp(reference)

      diff = ref - ts
      future = diff < 0
      diff = diff.abs

      result = calculate_relative_time(diff)

      if result == "just now"
        result
      elsif future
        "in #{result.sub(' ago', '')}"
      else
        result
      end
    end

    # Formats a duration in seconds to a human-readable string
    def duration(seconds, options = {})
      raise ArgumentError, "Seconds cannot be negative" if seconds.negative?
      raise ArgumentError, "Seconds cannot be NaN" if seconds.respond_to?(:nan?) && seconds.nan?
      raise ArgumentError, "Seconds cannot be infinite" if seconds.respond_to?(:infinite?) && seconds.infinite?

      compact = options[:compact] || false
      max_units = options[:max_units] || 2

      return compact ? "0s" : "0 seconds" if seconds == 0

      units = extract_duration_units(seconds.to_f)
      format_duration_units(units, compact, max_units)
    end

    # Parses a human-written duration string into seconds
    def parse_duration(input)
      raise ArgumentError, "Duration string cannot be empty" if input.nil? || input.strip.empty?

      str = input.strip.downcase

      # Check for negative values
      raise ArgumentError, "Negative durations are not allowed" if str.include?('-')

      # Try colon notation first (h:mm or h:mm:ss)
      if str =~ /^\d+:\d{1,2}(:\d{1,2})?$/
        return parse_colon_notation(str)
      end

      # Parse unit-based duration
      total = parse_unit_duration(str)
      raise ArgumentError, "No parseable duration units found" if total.nil?

      total
    end

    # Returns a contextual date string
    def human_date(timestamp, reference)
      ts = normalize_timestamp(timestamp)
      ref = normalize_timestamp(reference)

      ts_date = Time.at(ts).utc.to_date
      ref_date = Time.at(ref).utc.to_date

      day_diff = (ts_date - ref_date).to_i

      case day_diff
      when 0
        "Today"
      when -1
        "Yesterday"
      when 1
        "Tomorrow"
      when -6..-2
        weekday = WEEKDAYS[Time.at(ts).utc.wday]
        "Last #{weekday}"
      when 2..6
        weekday = WEEKDAYS[Time.at(ts).utc.wday]
        "This #{weekday}"
      else
        format_calendar_date(ts, ref)
      end
    end

    # Formats a date range with smart abbreviation
    def date_range(start_ts, end_ts)
      start_time = normalize_timestamp(start_ts)
      end_time = normalize_timestamp(end_ts)

      # Swap if start is after end
      start_time, end_time = end_time, start_time if start_time > end_time

      start_date = Time.at(start_time).utc
      end_date = Time.at(end_time).utc

      format_date_range(start_date, end_date)
    end

    private

    def calculate_relative_time(diff)
      case diff
      when 0...45
        "just now"
      when 45...90
        "1 minute ago"
      when 90...(45 * SECONDS_PER_MINUTE)
        n = (diff / SECONDS_PER_MINUTE.to_f).round
        "#{n} minutes ago"
      when (45 * SECONDS_PER_MINUTE)...(90 * SECONDS_PER_MINUTE)
        "1 hour ago"
      when (90 * SECONDS_PER_MINUTE)...(22 * SECONDS_PER_HOUR)
        n = (diff / SECONDS_PER_HOUR.to_f).round
        "#{n} hours ago"
      when (22 * SECONDS_PER_HOUR)...(36 * SECONDS_PER_HOUR)
        "1 day ago"
      when (36 * SECONDS_PER_HOUR)...(26 * SECONDS_PER_DAY)
        n = (diff / SECONDS_PER_DAY.to_f).round
        "#{n} days ago"
      when (26 * SECONDS_PER_DAY)...(46 * SECONDS_PER_DAY)
        "1 month ago"
      when (46 * SECONDS_PER_DAY)...(320 * SECONDS_PER_DAY)
        n = [(diff / SECONDS_PER_MONTH.to_f).round, 10].min
        "#{n} months ago"
      when (320 * SECONDS_PER_DAY)...(548 * SECONDS_PER_DAY)
        "1 year ago"
      else
        n = (diff / SECONDS_PER_YEAR.to_f).round
        "#{n} years ago"
      end
    end

    def extract_duration_units(seconds)
      remaining = seconds
      units = []

      [[SECONDS_PER_YEAR, :year], [SECONDS_PER_MONTH, :month], [SECONDS_PER_DAY, :day],
       [SECONDS_PER_HOUR, :hour], [SECONDS_PER_MINUTE, :minute], [1, :second]].each do |divisor, unit|
        count = (remaining / divisor).floor
        if count > 0
          units << [count, unit]
          remaining -= count * divisor
        end
      end

      # Store remaining fractional seconds for rounding
      units << [:remainder, remaining] if remaining > 0

      units
    end

    def format_duration_units(units, compact, max_units)
      # Filter out remainder marker
      actual_units = units.reject { |u| u[0] == :remainder }
      remainder = units.find { |u| u[0] == :remainder }&.dig(1) || 0

      return compact ? "0s" : "0 seconds" if actual_units.empty?

      # Take only max_units
      displayed = actual_units.take(max_units)

      # No rounding needed - we already have integer counts from floor division
      # The displayed units are exact counts, truncated at max_units

      if compact
        displayed.map { |count, unit| "#{count}#{compact_unit(unit)}" }.join(' ')
      else
        displayed.map { |count, unit| "#{count} #{pluralize(count, unit)}" }.join(', ')
      end
    end

    def unit_to_seconds(unit)
      case unit
      when :year then SECONDS_PER_YEAR
      when :month then SECONDS_PER_MONTH
      when :day then SECONDS_PER_DAY
      when :hour then SECONDS_PER_HOUR
      when :minute then SECONDS_PER_MINUTE
      when :second then 1
      end
    end

    def compact_unit(unit)
      { year: 'y', month: 'mo', day: 'd', hour: 'h', minute: 'm', second: 's' }[unit]
    end

    def pluralize(count, unit)
      count == 1 ? unit.to_s : "#{unit}s"
    end

    def parse_colon_notation(str)
      parts = str.split(':').map(&:to_i)
      case parts.length
      when 2
        # h:mm
        parts[0] * SECONDS_PER_HOUR + parts[1] * SECONDS_PER_MINUTE
      when 3
        # h:mm:ss
        parts[0] * SECONDS_PER_HOUR + parts[1] * SECONDS_PER_MINUTE + parts[2]
      end
    end

    def parse_unit_duration(str)
      # Remove "and" and extra whitespace/commas
      normalized = str.gsub(/\band\b/, ' ').gsub(/,/, ' ').gsub(/\s+/, ' ').strip

      total = 0
      found_unit = false

      # Pattern to match number (possibly decimal) followed by unit
      # Units ordered by length (longest first) to ensure proper matching
      pattern = /(\d+(?:\.\d+)?)\s*(seconds?|secs?|minutes?|mins?|hours?|hrs?|months?|weeks?|wks?|days?|years?|yrs?|sec|min|mo|hr|s|m|h|d|w|y)(?=\s|,|$|\d)/i

      normalized.scan(pattern) do |num, unit|
        found_unit = true
        value = num.to_f
        total += value * unit_multiplier(unit.downcase)
      end

      found_unit ? total.round : nil
    end

    def unit_multiplier(unit)
      case unit
      when 's', 'sec', 'secs', 'second', 'seconds'
        1
      when 'm', 'min', 'mins', 'minute', 'minutes'
        SECONDS_PER_MINUTE
      when 'h', 'hr', 'hrs', 'hour', 'hours'
        SECONDS_PER_HOUR
      when 'd', 'day', 'days'
        SECONDS_PER_DAY
      when 'w', 'wk', 'wks', 'week', 'weeks'
        SECONDS_PER_WEEK
      when 'mo', 'month', 'months'
        SECONDS_PER_MONTH
      when 'y', 'yr', 'yrs', 'year', 'years'
        SECONDS_PER_YEAR
      else
        0
      end
    end

    def format_calendar_date(ts, ref)
      ts_time = Time.at(ts).utc
      ref_time = Time.at(ref).utc

      month = MONTHS[ts_time.month - 1]
      day = ts_time.day

      if ts_time.year == ref_time.year
        "#{month} #{day}"
      else
        "#{month} #{day}, #{ts_time.year}"
      end
    end

    def format_date_range(start_date, end_date)
      start_month = MONTHS[start_date.month - 1]
      end_month = MONTHS[end_date.month - 1]

      same_day = start_date.year == end_date.year &&
                 start_date.month == end_date.month &&
                 start_date.day == end_date.day

      same_month = start_date.year == end_date.year &&
                   start_date.month == end_date.month

      same_year = start_date.year == end_date.year

      if same_day
        "#{start_month} #{start_date.day}, #{start_date.year}"
      elsif same_month
        "#{start_month} #{start_date.day}–#{end_date.day}, #{start_date.year}"
      elsif same_year
        "#{start_month} #{start_date.day} – #{end_month} #{end_date.day}, #{start_date.year}"
      else
        "#{start_month} #{start_date.day}, #{start_date.year} – #{end_month} #{end_date.day}, #{end_date.year}"
      end
    end
  end
end

# Convenience methods at module level
def timeago(timestamp, reference = nil)
  Whenwords.timeago(timestamp, reference)
end

def duration(seconds, options = {})
  Whenwords.duration(seconds, options)
end

def parse_duration(input)
  Whenwords.parse_duration(input)
end

def human_date(timestamp, reference)
  Whenwords.human_date(timestamp, reference)
end

def date_range(start_ts, end_ts)
  Whenwords.date_range(start_ts, end_ts)
end

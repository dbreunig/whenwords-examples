defmodule Whenwords do
  @moduledoc """
  Human-friendly time formatting and parsing.

  All functions are pure - no side effects, no I/O, no system clock access.
  The reference timestamp is always passed explicitly.
  """

  @seconds_per_minute 60
  @seconds_per_hour 3600
  @seconds_per_day 86400
  @seconds_per_week 604_800
  @seconds_per_month 2_592_000  # 30 days (for thresholds)
  @seconds_per_year 31_536_000  # 365 days
  # Use 365/12 days for month count calculation to better match expectations
  @seconds_per_month_for_count div(31_536_000, 12)  # ~30.42 days

  @type timestamp :: integer() | float() | DateTime.t() | NaiveDateTime.t() | String.t()
  @type duration_options :: %{optional(:compact) => boolean(), optional(:max_units) => pos_integer()}

  # Timeago thresholds in seconds
  @just_now_threshold 45
  @minute_threshold 90
  @minutes_threshold 45 * 60
  @hour_threshold 90 * 60
  @hours_threshold 22 * 3600
  @day_threshold 36 * 3600
  @days_threshold 26 * @seconds_per_day
  @month_threshold 46 * @seconds_per_day
  @months_threshold 320 * @seconds_per_day
  @year_threshold 548 * @seconds_per_day

  @doc """
  Returns a human-readable relative time string.

  ## Examples

      iex> Whenwords.timeago(1704067110, 1704067200)
      "2 minutes ago"

      iex> Whenwords.timeago(1704067200, 1704067200)
      "just now"
  """
  @spec timeago(timestamp(), timestamp()) :: String.t()
  def timeago(timestamp, reference \\ nil) do
    ts = normalize_timestamp(timestamp)
    ref = if reference, do: normalize_timestamp(reference), else: ts
    diff = ref - ts

    cond do
      diff >= 0 -> format_past(diff)
      true -> format_future(-diff)
    end
  end

  defp format_past(diff) do
    cond do
      diff < @just_now_threshold -> "just now"
      diff < @minute_threshold -> "1 minute ago"
      diff < @minutes_threshold -> "#{round_half_up(diff / 60)} minutes ago"
      diff < @hour_threshold -> "1 hour ago"
      diff < @hours_threshold -> "#{round_half_up(diff / 3600)} hours ago"
      diff < @day_threshold -> "1 day ago"
      diff < @days_threshold -> "#{round_half_up(diff / @seconds_per_day)} days ago"
      diff < @month_threshold -> "1 month ago"
      diff < @months_threshold -> "#{round_half_up(diff / @seconds_per_month_for_count)} months ago"
      diff < @year_threshold -> "1 year ago"
      true -> "#{round_half_up(diff / @seconds_per_year)} years ago"
    end
  end

  defp format_future(diff) do
    cond do
      diff < @just_now_threshold -> "just now"
      diff < @minute_threshold -> "in 1 minute"
      diff < @minutes_threshold -> "in #{round_half_up(diff / 60)} minutes"
      diff < @hour_threshold -> "in 1 hour"
      diff < @hours_threshold -> "in #{round_half_up(diff / 3600)} hours"
      diff < @day_threshold -> "in 1 day"
      diff < @days_threshold -> "in #{round_half_up(diff / @seconds_per_day)} days"
      diff < @month_threshold -> "in 1 month"
      diff < @months_threshold -> "in #{round_half_up(diff / @seconds_per_month_for_count)} months"
      diff < @year_threshold -> "in 1 year"
      true -> "in #{round_half_up(diff / @seconds_per_year)} years"
    end
  end

  @doc """
  Formats a duration in seconds to a human-readable string.

  ## Options

    * `:compact` - If true, use compact format like "2h 30m" (default: false)
    * `:max_units` - Maximum number of units to show (default: 2)

  ## Examples

      iex> Whenwords.duration(3661)
      "1 hour, 1 minute"

      iex> Whenwords.duration(3661, %{compact: true})
      "1h 1m"

      iex> Whenwords.duration(3661, %{max_units: 1})
      "1 hour"
  """
  @spec duration(number(), duration_options()) :: String.t()
  def duration(seconds, options \\ %{})

  def duration(seconds, _options) when seconds < 0 do
    raise ArgumentError, "duration cannot be negative"
  end

  def duration(seconds, options) when is_number(seconds) do
    compact = Map.get(options, :compact, false)
    max_units = Map.get(options, :max_units, 2)

    units = decompose_duration(seconds)
    format_duration_units(units, compact, max_units)
  end

  defp decompose_duration(seconds) do
    seconds = trunc(seconds)

    years = div(seconds, @seconds_per_year)
    seconds = rem(seconds, @seconds_per_year)

    months = div(seconds, @seconds_per_month)
    seconds = rem(seconds, @seconds_per_month)

    days = div(seconds, @seconds_per_day)
    seconds = rem(seconds, @seconds_per_day)

    hours = div(seconds, @seconds_per_hour)
    seconds = rem(seconds, @seconds_per_hour)

    minutes = div(seconds, @seconds_per_minute)
    secs = rem(seconds, @seconds_per_minute)

    [
      {:years, years},
      {:months, months},
      {:days, days},
      {:hours, hours},
      {:minutes, minutes},
      {:seconds, secs}
    ]
  end

  defp format_duration_units(units, compact, max_units) do
    non_zero = Enum.filter(units, fn {_unit, value} -> value > 0 end)

    if Enum.empty?(non_zero) do
      if compact, do: "0s", else: "0 seconds"
    else
      non_zero
      |> Enum.take(max_units)
      |> Enum.map(fn {unit, value} -> format_unit(unit, value, compact) end)
      |> join_units(compact)
    end
  end

  defp format_unit(unit, value, true) do
    suffix = compact_suffix(unit)
    "#{value}#{suffix}"
  end

  defp format_unit(unit, value, false) do
    unit_str = unit_to_string(unit, value)
    "#{value} #{unit_str}"
  end

  defp compact_suffix(:years), do: "y"
  defp compact_suffix(:months), do: "mo"
  defp compact_suffix(:days), do: "d"
  defp compact_suffix(:hours), do: "h"
  defp compact_suffix(:minutes), do: "m"
  defp compact_suffix(:seconds), do: "s"

  defp unit_to_string(:years, 1), do: "year"
  defp unit_to_string(:years, _), do: "years"
  defp unit_to_string(:months, 1), do: "month"
  defp unit_to_string(:months, _), do: "months"
  defp unit_to_string(:days, 1), do: "day"
  defp unit_to_string(:days, _), do: "days"
  defp unit_to_string(:hours, 1), do: "hour"
  defp unit_to_string(:hours, _), do: "hours"
  defp unit_to_string(:minutes, 1), do: "minute"
  defp unit_to_string(:minutes, _), do: "minutes"
  defp unit_to_string(:seconds, 1), do: "second"
  defp unit_to_string(:seconds, _), do: "seconds"

  defp join_units(units, true), do: Enum.join(units, " ")
  defp join_units(units, false), do: Enum.join(units, ", ")

  @doc """
  Parses a human-written duration string into seconds.

  Accepts various formats:
    * Compact: "2h30m", "2h 30m"
    * Verbose: "2 hours 30 minutes", "2 hours and 30 minutes"
    * Decimal: "2.5 hours", "1.5h"
    * Colon notation: "2:30" (h:mm), "2:30:00" (h:mm:ss)

  ## Examples

      iex> Whenwords.parse_duration("2h30m")
      9000

      iex> Whenwords.parse_duration("2 hours and 30 minutes")
      9000
  """
  @spec parse_duration(String.t()) :: integer()
  def parse_duration(input) when is_binary(input) do
    input = String.trim(input)

    if input == "" do
      raise ArgumentError, "cannot parse empty string"
    end

    cond do
      String.contains?(input, ":") -> parse_colon_notation(input)
      true -> parse_unit_notation(input)
    end
  end

  defp parse_colon_notation(input) do
    parts = String.split(input, ":")

    case parts do
      [h, m] ->
        hours = parse_number!(h)
        minutes = parse_number!(m)
        validate_non_negative!(hours)
        validate_non_negative!(minutes)
        trunc(hours * @seconds_per_hour + minutes * @seconds_per_minute)

      [h, m, s] ->
        hours = parse_number!(h)
        minutes = parse_number!(m)
        seconds = parse_number!(s)
        validate_non_negative!(hours)
        validate_non_negative!(minutes)
        validate_non_negative!(seconds)
        trunc(hours * @seconds_per_hour + minutes * @seconds_per_minute + seconds)

      _ ->
        raise ArgumentError, "invalid colon notation"
    end
  end

  defp parse_unit_notation(input) do
    # Normalize: remove "and", commas, lowercase
    normalized =
      input
      |> String.downcase()
      |> String.replace(~r/,/, " ")
      |> String.replace(~r/\band\b/, " ")
      |> String.replace(~r/\s+/, " ")
      |> String.trim()

    # Check for negative values
    if String.starts_with?(normalized, "-") do
      raise ArgumentError, "negative durations not allowed"
    end

    # Match all number+unit pairs
    # Use lookahead instead of \b to handle compact notation like "2h30m"
    pattern = ~r/(\d+(?:\.\d+)?)\s*(seconds?|secs?|s|minutes?|mins?|m(?!o)|hours?|hrs?|h|days?|d|weeks?|wks?|w)(?=\s|$|\d)/i

    matches = Regex.scan(pattern, normalized)

    if Enum.empty?(matches) do
      raise ArgumentError, "no valid duration units found in: #{input}"
    end

    total =
      Enum.reduce(matches, 0.0, fn [_full, num_str, unit], acc ->
        num = parse_number!(num_str)
        validate_non_negative!(num)
        seconds = unit_to_seconds(String.downcase(unit), num)
        acc + seconds
      end)

    trunc(total)
  end

  defp unit_to_seconds(unit, value) do
    cond do
      unit in ["s", "sec", "secs", "second", "seconds"] -> value
      unit in ["m", "min", "mins", "minute", "minutes"] -> value * @seconds_per_minute
      unit in ["h", "hr", "hrs", "hour", "hours"] -> value * @seconds_per_hour
      unit in ["d", "day", "days"] -> value * @seconds_per_day
      unit in ["w", "wk", "wks", "week", "weeks"] -> value * @seconds_per_week
      true -> raise ArgumentError, "unknown unit: #{unit}"
    end
  end

  defp parse_number!(str) do
    str = String.trim(str)
    case Float.parse(str) do
      {num, ""} -> num
      _ -> raise ArgumentError, "invalid number: #{str}"
    end
  end

  defp validate_non_negative!(num) when num < 0 do
    raise ArgumentError, "negative values not allowed"
  end
  defp validate_non_negative!(_num), do: :ok

  @doc """
  Returns a contextual date string.

  ## Examples

      iex> Whenwords.human_date(1705276800, 1705276800)
      "Today"

      iex> Whenwords.human_date(1705190400, 1705276800)
      "Yesterday"
  """
  @spec human_date(timestamp(), timestamp()) :: String.t()
  def human_date(timestamp, reference) do
    ts = normalize_timestamp(timestamp)
    ref = normalize_timestamp(reference)

    ts_date = unix_to_date(ts)
    ref_date = unix_to_date(ref)

    day_diff = Date.diff(ts_date, ref_date)

    cond do
      day_diff == 0 -> "Today"
      day_diff == -1 -> "Yesterday"
      day_diff == 1 -> "Tomorrow"
      day_diff < 0 and day_diff > -7 -> format_last_weekday(ts_date)
      day_diff > 0 and day_diff < 7 -> format_this_weekday(ts_date)
      ts_date.year == ref_date.year -> format_month_day(ts_date)
      true -> format_full_date(ts_date)
    end
  end

  defp unix_to_date(unix_seconds) do
    {:ok, datetime} = DateTime.from_unix(trunc(unix_seconds))
    DateTime.to_date(datetime)
  end

  defp format_last_weekday(date) do
    weekday = weekday_name(Date.day_of_week(date))
    "Last #{weekday}"
  end

  defp format_this_weekday(date) do
    weekday = weekday_name(Date.day_of_week(date))
    "This #{weekday}"
  end

  defp format_month_day(date) do
    month = month_name(date.month)
    "#{month} #{date.day}"
  end

  defp format_full_date(date) do
    month = month_name(date.month)
    "#{month} #{date.day}, #{date.year}"
  end

  defp weekday_name(1), do: "Monday"
  defp weekday_name(2), do: "Tuesday"
  defp weekday_name(3), do: "Wednesday"
  defp weekday_name(4), do: "Thursday"
  defp weekday_name(5), do: "Friday"
  defp weekday_name(6), do: "Saturday"
  defp weekday_name(7), do: "Sunday"

  defp month_name(1), do: "January"
  defp month_name(2), do: "February"
  defp month_name(3), do: "March"
  defp month_name(4), do: "April"
  defp month_name(5), do: "May"
  defp month_name(6), do: "June"
  defp month_name(7), do: "July"
  defp month_name(8), do: "August"
  defp month_name(9), do: "September"
  defp month_name(10), do: "October"
  defp month_name(11), do: "November"
  defp month_name(12), do: "December"

  @doc """
  Formats a date range with smart abbreviation.

  ## Examples

      iex> Whenwords.date_range(1705276800, 1705881600)
      "January 15–22, 2024"

      iex> Whenwords.date_range(1705276800, 1707955200)
      "January 15 – February 15, 2024"
  """
  @spec date_range(timestamp(), timestamp()) :: String.t()
  def date_range(start_ts, end_ts) do
    start_unix = normalize_timestamp(start_ts)
    end_unix = normalize_timestamp(end_ts)

    # Swap if start > end
    {start_unix, end_unix} = if start_unix > end_unix, do: {end_unix, start_unix}, else: {start_unix, end_unix}

    start_date = unix_to_date(start_unix)
    end_date = unix_to_date(end_unix)

    cond do
      start_date == end_date ->
        format_full_date(start_date)

      start_date.year == end_date.year and start_date.month == end_date.month ->
        # Same month: "January 15–22, 2024"
        month = month_name(start_date.month)
        "#{month} #{start_date.day}–#{end_date.day}, #{start_date.year}"

      start_date.year == end_date.year ->
        # Same year: "January 15 – February 15, 2024"
        start_month = month_name(start_date.month)
        end_month = month_name(end_date.month)
        "#{start_month} #{start_date.day} – #{end_month} #{end_date.day}, #{start_date.year}"

      true ->
        # Different years: "December 28, 2023 – January 15, 2024"
        "#{format_full_date(start_date)} – #{format_full_date(end_date)}"
    end
  end

  # Timestamp normalization
  defp normalize_timestamp(ts) when is_integer(ts), do: ts
  defp normalize_timestamp(ts) when is_float(ts), do: ts

  defp normalize_timestamp(%DateTime{} = dt) do
    DateTime.to_unix(dt)
  end

  defp normalize_timestamp(%NaiveDateTime{} = ndt) do
    {:ok, dt} = DateTime.from_naive(ndt, "Etc/UTC")
    DateTime.to_unix(dt)
  end

  defp normalize_timestamp(ts) when is_binary(ts) do
    case DateTime.from_iso8601(ts) do
      {:ok, dt, _offset} -> DateTime.to_unix(dt)
      {:error, _} -> raise ArgumentError, "invalid ISO 8601 timestamp: #{ts}"
    end
  end

  # Half-up rounding (2.5 -> 3, 2.4 -> 2)
  defp round_half_up(x) do
    trunc(x + 0.5)
  end
end

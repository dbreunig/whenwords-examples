const MONTH_NAMES = [
  'January','February','March','April','May','June',
  'July','August','September','October','November','December'
];

const WEEKDAY_NAMES = [
  'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'
];

function normalizeTimestamp(value) {
  if (value === undefined || value === null) {
    throw new Error('Invalid timestamp');
  }
  if (value instanceof Date) {
    return value.getTime() / 1000;
  }
  if (typeof value === 'string') {
    const parsed = Date.parse(value);
    if (Number.isNaN(parsed)) {
      throw new Error('Invalid timestamp');
    }
    return parsed / 1000;
  }
  if (typeof value === 'number' && Number.isFinite(value)) {
    // Accept milliseconds if value looks too large
    if (Math.abs(value) > 1e12) {
      return value / 1000;
    }
    return value;
  }
  throw new Error('Invalid timestamp');
}

function pluralize(count, singular, plural) {
  return count === 1 ? singular : plural;
}

function timeago(timestamp, reference) {
  const ts = normalizeTimestamp(timestamp);
  const ref = reference === undefined ? ts : normalizeTimestamp(reference);
  const diff = ref - ts;
  const isPast = diff >= 0;
  const abs = Math.abs(diff);

  const minute = 60;
  const hour = 3600;
  const day = 86400;
  const month = 30 * day;
  const year = 365 * day;

  function format(value, unit) {
    const unitLabel = pluralize(value, unit, unit + 's');
    if (value === 0) {
      return 'just now';
    }
    return isPast ? `${value} ${unitLabel} ago` : `in ${value} ${unitLabel}`;
  }

  if (abs < 45) {
    return 'just now';
  }
  if (abs < 90) {
    return isPast ? '1 minute ago' : 'in 1 minute';
  }
  if (abs < 45 * minute) {
    const mins = Math.round(abs / minute);
    return format(mins, 'minute');
  }
  if (abs < 90 * minute) {
    return isPast ? '1 hour ago' : 'in 1 hour';
  }
  if (abs < 22 * hour) {
    const hrs = Math.round(abs / hour);
    return format(hrs, 'hour');
  }
  if (abs < 36 * hour) {
    return isPast ? '1 day ago' : 'in 1 day';
  }
  if (abs < 26 * day) {
    const days = Math.round(abs / day);
    return format(days, 'day');
  }
  if (abs < 46 * day) {
    return isPast ? '1 month ago' : 'in 1 month';
  }
  if (abs < 320 * day) {
    const months = Math.min(Math.round(abs / month), 10);
    return format(months, 'month');
  }
  if (abs < 548 * day) {
    return isPast ? '1 year ago' : 'in 1 year';
  }
  const years = Math.round(abs / year);
  return format(years, 'year');
}

function duration(seconds, options = {}) {
  if (typeof seconds !== 'number' || !Number.isFinite(seconds) || seconds < 0) {
    throw new Error('Invalid duration');
  }
  const compact = options.compact === true;
  const maxUnits = options.max_units != null ? options.max_units : 2;

  if (seconds === 0) {
    return compact ? '0s' : '0 seconds';
  }

  const units = [
    { key: 'year', seconds: 365 * 86400, singular: 'year', plural: 'years', compact: 'y' },
    { key: 'month', seconds: 30 * 86400, singular: 'month', plural: 'months', compact: 'mo' },
    { key: 'day', seconds: 86400, singular: 'day', plural: 'days', compact: 'd' },
    { key: 'hour', seconds: 3600, singular: 'hour', plural: 'hours', compact: 'h' },
    { key: 'minute', seconds: 60, singular: 'minute', plural: 'minutes', compact: 'm' },
    { key: 'second', seconds: 1, singular: 'second', plural: 'seconds', compact: 's' }
  ];

  // Full breakdown by floor division
  const values = {};
  let remaining = seconds;
  for (const unit of units) {
    const value = Math.floor(remaining / unit.seconds);
    values[unit.key] = value;
    remaining -= value * unit.seconds;
  }

  // Build list of non-zero units while optionally skipping seconds when larger units exist
  const nonZero = [];
  const hasHigherThanMinute = ['hour', 'day', 'month', 'year'].some((k) => values[k] > 0);
  for (const unit of units) {
    if (unit.key === 'second' && hasHigherThanMinute) {
      continue; // don't show seconds when hours or larger are present
    }
    const value = values[unit.key];
    if (value > 0) {
      nonZero.push({ unit, value });
    }
  }

  if (nonZero.length === 0) {
    // Should not happen because seconds === 0 handled earlier
    return compact ? '0s' : '0 seconds';
  }

  const truncated = nonZero.length > maxUnits;
  const parts = truncated ? nonZero.slice(0, maxUnits) : nonZero.slice();
  const smallest = parts[parts.length - 1];

  // Remainder for rounding the smallest displayed unit
  let higherSeconds = 0;
  for (let i = 0; i < parts.length - 1; i += 1) {
    higherSeconds += parts[i].value * parts[i].unit.seconds;
  }
  const remainderForSmallest = seconds - higherSeconds;
  const rawSmallest = remainderForSmallest / smallest.unit.seconds;

  // For hour-or-larger units when we truncated, prefer flooring so we do not overstate
  const roundedSmallest = (truncated && ['hour', 'day', 'month', 'year'].includes(smallest.unit.key))
    ? Math.floor(rawSmallest + 1e-9)
    : Math.round(rawSmallest);

  smallest.value = roundedSmallest;

  // Drop any part that rounded to zero (possible with truncation)
  const filtered = parts.filter((p) => p.value > 0);
  if (filtered.length === 0) {
    return compact ? '0s' : '0 seconds';
  }

  const formatter = (part) => {
    const value = part.value;
    if (compact) {
      return `${value}${part.unit.compact}`;
    }
    const label = pluralize(value, part.unit.singular, part.unit.plural);
    return `${value} ${label}`;
  };

  const rendered = filtered.map(formatter);
  if (compact) {
    return rendered.join(' ');
  }
  return rendered.join(', ');
}

function parse_duration(input) {
  if (typeof input !== 'string') {
    throw new Error('Invalid duration string');
  }
  const str = input.trim();
  if (str.length === 0) {
    throw new Error('Invalid duration string');
  }

  // Colon notation h:mm or h:mm:ss
  const colonMatch = str.match(/^\s*(\d+):(\d{1,2})(?::(\d{1,2}))?\s*$/);
  if (colonMatch) {
    const hours = parseInt(colonMatch[1], 10);
    const minutes = parseInt(colonMatch[2], 10);
    const seconds = colonMatch[3] ? parseInt(colonMatch[3], 10) : 0;
    if (minutes < 0 || minutes >= 60 || seconds < 0 || seconds >= 60) {
      throw new Error('Invalid duration string');
    }
    return hours * 3600 + minutes * 60 + seconds;
  }

  const unitMap = {
    s: 1,
    sec: 1,
    secs: 1,
    second: 1,
    seconds: 1,
    m: 60,
    min: 60,
    mins: 60,
    minute: 60,
    minutes: 60,
    h: 3600,
    hr: 3600,
    hrs: 3600,
    hour: 3600,
    hours: 3600,
    d: 86400,
    day: 86400,
    days: 86400,
    w: 604800,
    wk: 604800,
    wks: 604800,
    week: 604800,
    weeks: 604800
  };

  const cleaned = str.replace(/,/g, ' ').replace(/\band\b/gi, ' ');
  const regex = /([+-]?\d*\.?\d+)\s*([a-zA-Z]+)/g;
  let match;
  let total = 0;
  let found = false;

  while ((match = regex.exec(cleaned)) !== null) {
    const valueRaw = match[1];
    const unitRaw = match[2].toLowerCase();
    const value = parseFloat(valueRaw);
    if (!Number.isFinite(value) || value < 0) {
      throw new Error('Invalid duration string');
    }
    const unitSeconds = unitMap[unitRaw];
    if (!unitSeconds) {
      continue;
    }
    found = true;
    total += value * unitSeconds;
  }

  if (!found) {
    throw new Error('Invalid duration string');
  }

  if (total < 0) {
    throw new Error('Invalid duration string');
  }

  return total;
}

function startOfDaySeconds(tsSeconds) {
  const d = new Date(tsSeconds * 1000);
  const utcMidnight = Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate());
  return utcMidnight / 1000;
}

function human_date(timestamp, reference) {
  const ts = normalizeTimestamp(timestamp);
  const ref = normalizeTimestamp(reference);

  const tsDay = startOfDaySeconds(ts);
  const refDay = startOfDaySeconds(ref);
  const diffDays = Math.round((tsDay - refDay) / 86400);

  const tsDate = new Date(ts * 1000);
  const sameYear = tsDate.getUTCFullYear() === new Date(ref * 1000).getUTCFullYear();

  if (diffDays === 0) return 'Today';
  if (diffDays === -1) return 'Yesterday';
  if (diffDays === 1) return 'Tomorrow';
  if (diffDays <= -2 && diffDays >= -6) {
    return `Last ${WEEKDAY_NAMES[tsDate.getUTCDay()]}`;
  }
  if (diffDays >= 2 && diffDays <= 6) {
    return `This ${WEEKDAY_NAMES[tsDate.getUTCDay()]}`;
  }

  const monthName = MONTH_NAMES[tsDate.getUTCMonth()];
  const day = tsDate.getUTCDate();
  const year = tsDate.getUTCFullYear();

  if (sameYear) {
    return `${monthName} ${day}`;
  }
  return `${monthName} ${day}, ${year}`;
}

function date_range(start, end) {
  let startTs = normalizeTimestamp(start);
  let endTs = normalizeTimestamp(end);
  if (startTs > endTs) {
    [startTs, endTs] = [endTs, startTs];
  }

  const startDate = new Date(startTs * 1000);
  const endDate = new Date(endTs * 1000);

  const sameDay = startDate.getUTCFullYear() === endDate.getUTCFullYear()
    && startDate.getUTCMonth() === endDate.getUTCMonth()
    && startDate.getUTCDate() === endDate.getUTCDate();

  const formatFull = (date) => {
    const month = MONTH_NAMES[date.getUTCMonth()];
    const day = date.getUTCDate();
    const year = date.getUTCFullYear();
    return `${month} ${day}, ${year}`;
  };

  if (sameDay) {
    return formatFull(startDate);
  }

  const sameYear = startDate.getUTCFullYear() === endDate.getUTCFullYear();
  const sameMonth = sameYear && startDate.getUTCMonth() === endDate.getUTCMonth();

  if (sameMonth) {
    const month = MONTH_NAMES[startDate.getUTCMonth()];
    const year = startDate.getUTCFullYear();
    return `${month} ${startDate.getUTCDate()}–${endDate.getUTCDate()}, ${year}`;
  }

  if (sameYear) {
    return `${MONTH_NAMES[startDate.getUTCMonth()]} ${startDate.getUTCDate()} – ${MONTH_NAMES[endDate.getUTCMonth()]} ${endDate.getUTCDate()}, ${startDate.getUTCFullYear()}`;
  }

  return `${formatFull(startDate)} – ${formatFull(endDate)}`;
}

module.exports = {
  timeago,
  duration,
  parse_duration,
  human_date,
  date_range
};

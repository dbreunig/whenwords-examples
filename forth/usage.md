# whenwords for Forth

Human-friendly time formatting and parsing for Forth.

## Installation

The specific Forth used is not included.

To get it paste the following prompt into your AI Coding tool:

```markdown
Implement a forth-compiler in assembly for the currect architecture in `forth.S` and iterate until `make test`
shows "All tests passed!"

Do not modify any other files than forth.S
```

Tested with Claude Code in x86_64 and Gemini in aarch64.

If the AI is having trouble progressing, tell it to implement a
segfault handler that shows pertinent debugging information.

To use in a project copy  `whenwords.fs` to your project and include:

```forth
INCLUDE whenwords.fs
```

## Quick start

```forth
\ Relative time
1704067140 1704067200 TIMEAGO TYPE \ Output: 1 minute ago

\ Duration
3661 DURATION TYPE \ Output: 1 hour, 1 minute

\ Parse duration
S" 2h 30m" PARSE-DURATION . \ Output: 9000

\ Human date
1705276800 1705276800 HUMAN-DATE TYPE \ Output: Today

\ Date range
1705276800 1705363200 DATE-RANGE TYPE \ Output: January 15–16, 2024
```

## Functions

### TIMEAGO ( timestamp reference -- addr len )

Returns a human-readable relative time string.
- `timestamp`: Unix timestamp (seconds)
- `reference`: Unix timestamp to compare against

### DURATION ( seconds -- addr len )

Formats a duration.
- `seconds`: Non-negative number
- Options are set via global variables:
  - `OPT-COMPACT`: Set to 1 for "1h 1m" style (default 0)
  - `OPT-MAX-UNITS`: Maximum units to show (default 2)

### PARSE-DURATION ( addr len -- n )

Parses a human-written duration string into seconds.
Returns `-1` on error.

### HUMAN-DATE ( timestamp reference -- addr len )

Returns a contextual date string like "Today", "Yesterday", or "March 5".

### DATE-RANGE ( start end -- addr len )

Formats a date range with smart abbreviation.

## Error handling

- `DURATION` returns `S" ERROR"` for negative inputs.
- `PARSE-DURATION` returns `-1` for invalid strings.
- Other functions return spec-compliant strings based on input.

## Accepted types

All timestamps are Unix seconds (integers). Strings are UTF-8.

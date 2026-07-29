# Number Formatting

> **STATUS: OUTLINE.** Headings are final; prose to be written.
> Style template: [comparison-metrics.md](comparison-metrics.md).

Opening frame to write: formatting is not decoration. Wrong precision, wrong
separators, or wrong variance colour changes what the reader concludes. This is
correctness work.

---

## PRECISION

- **Three significant digits is enough for an executive tile.** `R$ 4.2M`, not
  `R$ 4,238,914.37`.
- False precision signals false confidence. A forecast to the cent is a lie
  about the model.
- Precision by audience tier: exec tile → 3 sig digits; manager table → 0–1
  decimals; analyst export → full precision.
- Never round in a way that breaks addition on screen (rows summing to a
  different total than the displayed total) — either round consistently or
  footnote it.

## ABBREVIATION

- K / M / B (and the pt-BR "mil / mi / bi" question — decide per locale).
- Consistency within a column: never mix `950K` and `1.2M` in the same axis.
- Custom format strings for both tools; Power BI dynamic format strings for
  selection-dependent scale.

## PERCENT VS PERCENTAGE POINTS

- The rule: a change in a percentage is measured in **pp**, never %.
- Worked example: conversion 20% → 25% is +5pp and +25% relative. Both true,
  different meanings. Label which one is shown.
- Cross-link to
  [comparison-metrics.md](comparison-metrics.md#variance-edge-cases).

## NEGATIVES

- Parentheses `(1,234)` — the finance convention — vs minus sign `-1,234`.
  Choose by audience; finance packs use parentheses.
- Red for negative is **not** universal: see polarity below.
- Never use a bare minus sign in a small font at small size — it disappears.

## POLARITY: THE MOST COMMON FORMATTING BUG

- For cost, headcount attrition, error rate, MTTR, time-to-fill, days-sales-
  outstanding: **lower is better**, so a negative variance is favourable and must
  render green.
- Model polarity as data (a `Polarity` column on a metric dimension), not as
  hard-coded conditional formatting.
- Implementation sketch for both tools; cross-link to the polarity-aware measure
  in [comparison-metrics.md](comparison-metrics.md#variance-edge-cases).
- Bad/good pair: a cost centre R$ 50k under budget shown in red vs green.

## CURRENCY AND LOCALE

- Symbol placement, and mixed-currency reports: state the currency in the header
  and the FX basis in a footnote.
- **Separator conventions**: `1,234.56` (en-US) vs `1.234,56` (pt-BR, de-DE).
  Getting this wrong changes the number by three orders of magnitude to a reader
  who trusts their own convention.
- Locale is a property of the *reader*, not the author — Power BI locale
  settings, Tableau workbook locale, and how each behaves on publish.
- Never rely on the viewer's machine locale for a shared report; pin it.

## ALIGNMENT AND TYPOGRAPHY IN TABLES

- Right-align numbers, always. Left-align text. Centre nothing.
- Decimal alignment so digits stack by place value.
- Tabular (monospaced) figures so columns do not jitter.
- Units in the column header, not repeated in every cell (`Revenue (R$ 000)`).
- De-emphasise separators and gridlines; the numbers are the content.

## DATES AND TIMES

- Unambiguous formats: `2026-07-29` or `29 Jul 2026`, never `07/29/26` in an
  international audience.
- Period labels: `FY26 Q2`, `Jul-26`. Sortable and unambiguous.
- Timezone: state it, especially for operational reports crossing midnight.

## VARIANCE DISPLAY

- Arrows ▲▼ paired with polarity-aware colour, never colour alone
  (accessibility — cross-link to [visual-design.md](visual-design.md)).
- Show absolute *and* relative variance; one without the other misleads
  (a 300% increase on a base of R$ 12 is not news).
- Suppress or grey out variance where the base is too small to be meaningful.
- Blank, not `0%` or `n/a`, for a genuinely undefined comparison.

## NULL, ZERO, AND BLANK

- Three distinct states with three distinct displays: no data (blank or `—`),
  measured zero (`0`), not applicable (`n/a`).
- Never let a blank render as `0` — it converts "we don't know" into "it was
  nothing".

## FORMAT STRING REFERENCE

To write: side-by-side table of Power BI and Tableau custom format strings for
each common case — thousands, millions, percent, percent with sign, currency,
negatives in parentheses, blank handling.

## GOTCHA TABLE

To write. Seed rows — rows don't sum to the shown total (rounding) · a saving
shows red (polarity) · pt-BR reader misreads `1.234` as 1234 vs 1.234 (locale) ·
`+∞%` (zero base) · axis labels overlap (no abbreviation) · a blank shown as 0.

## CHECKLIST

To write: ~10 items.

---

*See also: [visual-design.md](visual-design.md) for colour and accessibility ·
[comparison-metrics.md](comparison-metrics.md) for variance semantics ·
[report-architecture.md](report-architecture.md) for precision by audience tier*

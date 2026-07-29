# Calculations in Power BI (DAX)

> **STATUS: OUTLINE.** Headings are final; prose to be written.
> Style template: [comparison-metrics.md](comparison-metrics.md).

Opening frame to write: DAX is not a formula language, it is a filter-context
language. Nearly every DAX bug is a context bug, not a syntax bug.

---

## THE TWO CONTEXTS

### Filter context

What rows are visible when the measure evaluates. Comes from slicers, visual
axes, page filters, and `CALCULATE` modifiers.

### Row context

Exists inside calculated columns and iterators. Does **not** filter — it points
at a row.

### Context transition

`CALCULATE` converts row context into filter context. The single most important
mechanic in DAX, and the source of the most surprising results. Worked example
showing the same expression with and without transition.

### Measures vs calculated columns

Decision rule: if it must respond to user filters, it is a measure. Columns cost
memory and are fixed at refresh. Default to measures.

## `CALCULATE`

- Syntax and evaluation order: filters first, then the expression.
- Filter arguments **replace** the existing filter on that column, they do not
  intersect — the most misunderstood behaviour in DAX.
- `KEEPFILTERS` to intersect instead of replace.
- `REMOVEFILTERS` / `ALL` / `ALLEXCEPT` / `ALLSELECTED` — a comparison table with
  a worked example of each, and when `ALLSELECTED` misbehaves in totals.
- `USERELATIONSHIP` for role-playing dates.

## VARIABLES

- `VAR` / `RETURN`; readability and single-evaluation performance benefit.
- **Variables are evaluated where they are declared**, not where they are used —
  the classic gotcha inside `CALCULATE`.
- Use variables to make the debugging path visible.

## DIVISION AND BLANKS

- `DIVIDE ( n, d )` over `n / d`: returns blank instead of an error.
- Blank vs zero: blank means "no data", zero means "measured, and it was zero".
  Do not coerce blank to zero for cosmetic reasons — it turns "no sales" into a
  real data point and breaks YoY.
- `COALESCE` and when it is appropriate.
- Cross-link to the `ABS` denominator rule in
  [comparison-metrics.md](comparison-metrics.md#variance-edge-cases).

## ITERATORS

- `SUMX`, `AVERAGEX`, `MAXX`, `RANKX`, `COUNTX`.
- When an iterator is required: row-level arithmetic before aggregation
  (`SUMX(Sales, Sales[Qty] * Sales[Price])` ≠ `SUM(Qty) * SUM(Price)`).
- Performance cost and how to avoid iterating large fact tables unnecessarily.

## AGGREGATION AND NON-ADDITIVITY

- Additive, semi-additive (balances — `LASTNONBLANKVALUE`), non-additive
  (ratios, distinct counts).
- Why a ratio measure must be recomputed at the total, never summed.
- `DISTINCTCOUNT` cost and alternatives.

## TIME INTELLIGENCE AND ITS FAILURE MODES

- The function list: `DATESYTD`, `DATESMTD`, `DATESQTD`, `DATEADD`,
  `SAMEPERIODLASTYEAR`, `PARALLELPERIOD`, `DATESINPERIOD`, `TOTALYTD`.
- **Failure modes to document:** unmarked date table · gaps in the date table ·
  fiscal year-end not passed · `DATEADD` silently dropping non-existent dates
  (31st, 29 Feb) · `PARALLELPERIOD` returning the whole period · time
  intelligence over a non-contiguous filter selection.
- Cross-link: full patterns live in
  [comparison-metrics.md](comparison-metrics.md).

## CALCULATION GROUPS

- What they solve: one set of time-intelligence variants applied to every
  measure, instead of N×M measures.
- Built in Tabular Editor; precedence and ordinal.
- Interaction with format strings.

## DYNAMIC FORMAT STRINGS

- Format that changes with the selection (currency by country, % vs absolute).
- Via calculation groups or a measure-level dynamic format string.
- Cross-link to [number-formatting.md](number-formatting.md).

## ROW-LEVEL SECURITY IN DAX

- Role filter expressions; `USERPRINCIPALNAME()`.
- Dynamic RLS via a user–entity mapping table.
- Performance implications; testing with **View as role**.
- Cross-link to [filters-interactivity.md](filters-interactivity.md).

## MEASURE ORGANISATION

- A dedicated measure table; display folders.
- Naming convention: `Revenue`, `Revenue LY`, `Revenue YoY %` — base first,
  qualifier after.
- Never repeat a base aggregation inside a derived measure.
- Hide raw numeric columns so users cannot drag an implicit `Sum of Amount`.

## DEBUGGING

- Split the measure into `VAR`s and surface each one in a table visual.
- DAX Studio / Performance Analyzer to read the generated query.
- Test at three levels: one row, one group, grand total. Totals are where
  context bugs surface.

## GOTCHA TABLE

To write: symptom → cause → fix. Seed rows —
total ≠ sum of rows (non-additive ratio) · measure ignores a slicer (`ALL`) ·
measure blank at total only (`SELECTEDVALUE` returning blank) · YoY shifted by a
day (date table gaps) · slow visual (iterator over fact) · circular dependency.

## CHECKLIST

To write: ~10 items.

---

*See also: [calculations-tableau.md](calculations-tableau.md) for the same
concepts in Tableau · [data-model.md](data-model.md) ·
[comparison-metrics.md](comparison-metrics.md)*

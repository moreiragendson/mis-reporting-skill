# Calculations in Tableau

> **STATUS: OUTLINE.** Headings are final; prose to be written.
> Style template: [comparison-metrics.md](comparison-metrics.md).

Opening frame to write: in Tableau, *when* a calculation runs matters more than
what it says. The order of operations is the master key — learn it once and most
Tableau mysteries dissolve.

---

## ORDER OF OPERATIONS

Give this section the most space. It is the central gotcha of the tool.

### The pipeline

Document the sequence, top to bottom:

1. Extract filters
2. Data source filters
3. Context filters
4. **`FIXED` LODs**
5. Dimension filters
6. **`INCLUDE` / `EXCLUDE` LODs**
7. Measure filters
8. Forecasts / clusters
9. Table calculations
10. Table-calc filters
11. Trend lines / reference lines

### The two consequences that matter

- A `FIXED` LOD ignores dimension filters, because it runs first. Fix: promote
  the filter **to context**.
- A table-calc filter hides marks but does **not** remove them from the
  calculation — which is sometimes the point (`INDEX() <= 10` for top-N without
  changing percentages) and sometimes the bug.

### Diagram

Write an ASCII pipeline diagram readers can hold in their head.

## ROW-LEVEL VS AGGREGATE CALCULATIONS

- "Cannot mix aggregate and non-aggregate arguments" — what it actually means
  and the two ways out (aggregate the other side, or use an LOD).
- Row-level calcs execute in the database; aggregates execute after grouping.
- `ATTR()` and why it returns `*`.

## LEVEL OF DETAIL EXPRESSIONS

### `FIXED`

Computes at a stated dimensionality regardless of the view. The workhorse.
Examples: customer first-order date, per-customer total independent of the view,
de-duplicating a fan-out.

### `INCLUDE`

Adds dimensions to the view's level of detail — for averaging a finer-grained
aggregate (average per-order value shown by region).

### `EXCLUDE`

Removes dimensions — for percent-of-total and difference-from-overall patterns.

### Choosing between them

Decision table: what dimensionality do you need relative to the view?

### LOD gotchas

Filters (see order of operations) · LODs and data blending do not mix ·
performance cost on large extracts · nested LODs.

## TABLE CALCULATIONS

- The function set: `WINDOW_SUM/AVG/MIN/MAX`, `RUNNING_SUM`, `LOOKUP`, `INDEX`,
  `RANK`, `TOTAL`, `SIZE`, `FIRST`/`LAST`, `PREVIOUS_VALUE`.
- **Addressing vs partitioning** — the concept most users never internalise.
  Write this with a worked grid showing the same calc computed four ways.
- Compute Using: Table across / down / Pane / Specific Dimensions / Advanced.
- Restarting every year for YTD.
- The densification problem: `LOOKUP(-12)` breaks when a month has no rows.
  Remedies: continuous date field, `Show Empty Rows/Columns`, or a date scaffold.
- Nested table calcs.

## PARAMETERS

- Parameters are global and do not respond to the data — the key limitation.
- Dynamic parameters (refresh on workbook open) and their constraints.
- **Parameter actions** — the workaround that makes parameters data-driven.
- Measure-swap and dimension-swap patterns with `CASE`.
- Cross-link to [filters-interactivity.md](filters-interactivity.md).

## CALCULATION TYPES DECISION TABLE

To write: need → use. Rows —
row-level derivation → calculated field · view-dependent ranking/running total →
table calc · fixed dimensionality regardless of view → `FIXED` LOD · user-driven
switch → parameter · filter that must run before LODs → context filter.

## DATE CALCULATIONS

- `DATETRUNC`, `DATEADD`, `DATEDIFF`, `DATEPART`, `MAKEDATE`.
- Discrete (blue) vs continuous (green) dates — and why it changes the axis and
  the table calc.
- Fiscal year start on the date field's default properties.
- `TODAY()` vs `{ MAX([Date]) }` — always prefer the data's own cutoff.
  Cross-link to [comparison-metrics.md](comparison-metrics.md#the-partial-period-trap).

## PERFORMANCE OF CALCULATIONS

- Push row-level work to the source; avoid string calcs in the view.
- Booleans and integers beat strings.
- Extract vs live implications for `FIXED` LODs.
- Cross-link to [performance-governance.md](performance-governance.md).

## DEBUGGING

- Drop the calc on Text/Detail to see raw values.
- Duplicate as crosstab and inspect the underlying grid.
- Toggle context on a filter to test an LOD interaction.
- Performance Recorder for the query plan.

## GOTCHA TABLE

To write: symptom → cause → fix. Seed rows —
filter has no effect on a number (`FIXED` before dimension filters) · percentages
don't recalc after top-N filter (table-calc filter) · running total resets in the
wrong place (partitioning) · `LOOKUP` returns the wrong period (densification) ·
"cannot mix aggregate and non-aggregate" · totals wrong after a join (fan-out,
fix with `FIXED` or a relationship).

## CHECKLIST

To write: ~10 items.

---

*See also: [calculations-powerbi.md](calculations-powerbi.md) for the same
concepts in Power BI · [data-model.md](data-model.md) ·
[comparison-metrics.md](comparison-metrics.md)*

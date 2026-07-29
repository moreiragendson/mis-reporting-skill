# Data Model for Reporting

> **STATUS: OUTLINE.** Headings are final; prose to be written.
> Style template: [comparison-metrics.md](comparison-metrics.md) — imperative
> voice, dual-track code blocks (DAX and Tableau), gotcha tables, a closing
> checklist.

Opening frame to write: most "impossible" report requests are modelling
problems, not calculation problems. If the formula is getting baroque, the
model is wrong.

---

## STAR SCHEMA, AND WHY IT IS NOT OPTIONAL

- Facts (events, measured, many rows) vs dimensions (things, described, few rows).
- Why both engines are built for it: VertiPaq compression and Tableau's join
  culling both assume it. Flat wide tables and snowflakes cost speed and clarity.
- Bad/good pair: one wide denormalised extract vs a fact + 4 dimensions.

## GRAIN — DECIDE IT FIRST

- Define grain as one sentence: "one row per ___".
- Symptoms of an undeclared grain: double-counting, totals ≠ sum of rows.
- Mixed-grain facts (header vs line) and how to keep them in separate tables.
- Budget at a coarser grain than actuals — relate to shared dimensions, do not
  join down to fact grain. Cross-link from
  [comparison-metrics.md](comparison-metrics.md#variance-against-target).

## THE DATE DIMENSION

The most important table in the model. Give this section the most space.

### Required columns

Table to write: `Date`, `Year`, `Quarter`, `Month Number`, `Month Name`,
`Month Year Sort`, `Week`, `Day of Week`, `Fiscal Year`, `Fiscal Quarter`,
`Fiscal Month Number`, `Is Working Day`, `Is Current Month`, offset helpers
(`Month Offset`, `Year Offset`) for relative filtering.

### Build scripts

- DAX: `CALENDAR` / `CALENDARAUTO` + `ADDCOLUMNS`, full worked example.
- Power Query (M): `List.Dates` version, for when the table must persist.
- SQL: the generate-series version, for warehouse-side date dimensions.
- Tableau: relate the date dimension rather than using the fact's raw date;
  note when a scaffold is needed for densification.

### Mark as date table

Power BI: **Mark as date table** is required for time intelligence to be
correct. What silently breaks without it.

### Sort columns

`Month Name` sorts alphabetically unless a `Month Number` sort-by column is
set. Cover the sort-by-column mechanic in both tools.

### Fiscal calendars, ISO weeks, 4-4-5

- Fiscal offsets: how to derive `Fiscal Year` from a fiscal start month.
- ISO week rules and the year-boundary problem (week 1 spanning December).
- 4-4-5 / 4-5-4 retail calendars: cannot be derived, must be supplied by the
  business as a table.
- Weekly reporting on calendar months is a trap — 4 or 5 of a given weekday.

### Completeness and gaps

Date table must cover every fact date with no missing days, or time
intelligence returns wrong answers rather than errors.

## ROLE-PLAYING DIMENSIONS

- One event, several dates: order, ship, invoice, payment, close.
- Power BI: one active relationship + inactive ones activated by
  `USERELATIONSHIP`; or duplicate the date table per role.
- Tableau: duplicate the date dimension per role, or a date-type parameter that
  switches which date drives the view.
- Rule to state: the report must always say which date it is using.

## RELATIONSHIPS

### Power BI

- Cardinality: 1:*, 1:1, *:*; why *:* is a last resort.
- Filter direction; the cost and danger of bidirectional filtering; ambiguity
  errors.
- Inactive relationships and `USERELATIONSHIP`.
- Composite models and the aggregation table pattern.

### Tableau

- **Relationships (noodle) vs joins vs blends** — the decision table. Default to
  relationships; joins only when you need row duplication deliberately; blends
  only for cross-datasource at different grain.
- Join fan-out: the classic cause of inflated sums.
- Data source filters vs sheet filters.

## MANY-TO-MANY AND BRIDGE TABLES

- The bridge/factless-fact pattern (e.g. deal ↔ multiple reps).
- Attribution choice: split, duplicate, or first-touch — a business decision,
  document it in the metric definition.

## SLOWLY CHANGING DIMENSIONS

- Type 1 (overwrite) vs Type 2 (versioned rows with validity dates).
- Why management reporting usually needs Type 2: "revenue by the region the rep
  was in *at the time*" vs "by their region today".
- How to join a Type 2 dimension correctly (surrogate key on the fact, not the
  natural key).

## KEYS, TYPES, AND HYGIENE

- Surrogate vs natural keys.
- Data types: never store dates as text; integer keys over strings for speed.
- Null members and the "Unknown" row — an explicit `-1 / Unknown` dimension row
  beats losing fact rows to an inner join.
- Naming conventions: business-friendly names, no `tbl_` prefixes visible to
  users, hide key columns from the field list.
- Measure tables / folders.

## GOTCHA TABLE

To write: symptom → cause → fix. Seed rows —
totals inflated after adding a dimension (fan-out) · a filter has no effect
(wrong relationship direction) · YoY blank everywhere (date table not marked) ·
months sort alphabetically (no sort-by column) · rows disappear (inner join on
a nullable key) · circular dependency error (bidirectional loops).

## CHECKLIST

To write: ~12 items covering grain declared, date dimension complete and
marked, fiscal columns present, relationships single-direction, no *:* without
justification, keys hidden, Unknown members handled, budget related not joined.

---

*See also: [SKILL.md](SKILL.md) · [comparison-metrics.md](comparison-metrics.md)
· [performance-governance.md](performance-governance.md)*

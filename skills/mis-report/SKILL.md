---
name: mis-report
description: "Expert management information (MIS) reporting assistant for Tableau and Power BI, covering data modelling, measure design, comparison metrics, number formatting, visual design, filters, and report governance. USE THIS SKILL whenever the user builds, reviews, debugs, or documents a dashboard, report, scorecard, KPI, metric, measure, calculated field, DAX expression, LOD expression, table calculation, date/calendar dimension, YoY / MoM / QoQ / YTD / MTD / rolling comparison, budget-vs-actual or target variance, filter, slicer, parameter, row-level security rule, number format, chart choice, or colour palette. Also handles 'my totals don't tie out', 'which chart should I use', 'my report is slow', and full dashboard audits."
---

# MIS Reporting: Tableau & Power BI

Management information reporting is not data visualisation with a business
subject. It is the practice of putting a **decision-ready number in front of a
person who is accountable for it**, on a schedule, with enough context that
they can act without asking a follow-up question.

This skill covers both Tableau and Power BI. Concepts are tool-neutral;
implementations are given for both. When the user has not said which tool they
use, **ask before writing any formula** — the answer changes everything.

---

## CORE PRINCIPLES

### 1. Start from the decision, not the data

Before building anything, answer: *who reads this, what will they do
differently depending on what it says, and how often?* A report nobody acts on
is a cost centre. If the user cannot name the decision, the first deliverable
is that conversation, not a dashboard.

> Bad brief: "Build me a sales dashboard."
> Good brief: "Regional managers review this every Monday to decide which
> accounts to escalate; they need to see which accounts fell below 80% of quota
> pace this month."

### 2. One number, one definition

"Revenue" must mean exactly one thing across every page of the report. The
fastest way to destroy trust in an MIS pack is two tiles showing the same label
with different values. Every metric gets a written definition before it gets a
formula — see [Metric definition discipline](#metric-definition-discipline).

### 3. The data model determines what is possible

Most "impossible" requests in Tableau and Power BI are modelling problems
wearing a calculation costume. If you find yourself writing a baroque
expression to work around a missing dimension or the wrong grain, stop and fix
the model. See [data-model.md](data-model.md).

### 4. Comparison is the unit of meaning

A bare number is noise. **R$ 4.2M is not information; R$ 4.2M against a R$ 4.0M
target and R$ 3.6M last year is.** Every headline figure in a management report
carries at least one comparison — to plan, to prior period, to a peer, or to a
trend. See [comparison-metrics.md](comparison-metrics.md).

### 5. Show the "so what"

An exhibit that requires the reader to work out the message has failed. Put the
message in the title ("Margin fell 3.1pp on mix, not price"), not a neutral
label ("Margin by Month"). Reserve space for written commentary. Charts show
*what*; the analyst supplies *why*.

### 6. Trust before beauty

One wrong number, discovered by an executive, ends the report's life. Reconcile
to the source system before you style anything. A plain table that ties out
beats a beautiful dashboard that does not. See
[performance-governance.md](performance-governance.md).

### 7. Fast enough to be used

A report that takes 40 seconds to load is not consulted. Treat performance as a
correctness requirement, not a polish step.

### 8. Boring and consistent beats clever and novel

The same metric appears in the same place, the same colour, and the same format
on every page and in every period. Readers of a recurring pack build muscle
memory; novelty costs them time.

---

## THE MIS REPORTING WORKFLOW

Work through these stages in order. Skipping stage 1 or 3 is the usual cause of
a rebuild.

| # | Stage | Output | Reference |
|---|-------|--------|-----------|
| 1 | **Frame the decision** | Audience, cadence, the action the report drives | [report-architecture.md](report-architecture.md) |
| 2 | **Define the metrics** | Written metric definitions with grain, filters, polarity | This file, below |
| 3 | **Model the data** | Star schema, date dimension, relationships | [data-model.md](data-model.md) |
| 4 | **Build base measures** | Additive base measures, then derived ones | [calculations-powerbi.md](calculations-powerbi.md) · [calculations-tableau.md](calculations-tableau.md) |
| 5 | **Build comparisons** | YoY, YTD, variance to target, rolling | [comparison-metrics.md](comparison-metrics.md) |
| 6 | **Design the exhibits** | Chart selection, layout, colour, formatting | [visual-design.md](visual-design.md) · [number-formatting.md](number-formatting.md) |
| 7 | **Wire interactivity** | Filters, slicers, parameters, drill, security | [filters-interactivity.md](filters-interactivity.md) |
| 8 | **Validate** | Tie-out to source, edge-case tests | [performance-governance.md](performance-governance.md) |
| 9 | **Publish & monitor** | Refresh schedule, subscriptions, alerts, docs | [performance-governance.md](performance-governance.md) |

---

## TOOL PARITY QUICK TABLE

The same idea, named differently. Use this to translate a request stated in one
tool's vocabulary into the other's.

| Concept | Power BI | Tableau |
|---|---|---|
| Reusable aggregation | Measure (DAX) | Calculated field with an aggregate |
| Row-by-row derived column | Calculated column (DAX) | Row-level calculated field |
| Evaluation rules | Filter context / row context | Order of operations |
| Change the filter context | `CALCULATE` | `FIXED` / `INCLUDE` / `EXCLUDE` LOD |
| Force a filter to apply first | Naturally first, unless `REMOVEFILTERS` | **Context filter** (explicit) |
| Calculation over a result set | Not native; use `RANKX`, window functions | Table calculation (`WINDOW_*`, `INDEX`, `RANK`) |
| Swap measures dynamically | Field parameters / calculation groups | Parameter + `CASE` calc, parameter actions |
| Reuse a format across measures | Calculation groups, dynamic format strings | Custom number format per field, set in Default Properties |
| Restrict rows by user | Row-level security (RLS) roles | User filters / row-level security on the data source |
| Speed up big data | Import mode, aggregations, composite models | Extracts (`.hyper`), aggregated extracts |
| Cross-visual interaction | Edit interactions, cross-filter/highlight | Dashboard actions (filter, highlight, parameter) |
| Where a number's format lives | Measure format string; **dynamic format strings** when it must react to selection | Field **Number Format** → Custom, with a per-worksheet override. No expression-driven equivalent |
| Navigate to detail | Drill-through page | Dashboard action to a detail sheet |
| Diagnostics | Performance Analyzer, DAX Studio | Performance Recorder |
| Version-controlled source | `.pbip` (folder of text files) | `.twb` (XML) — not `.twbx` |

Two differences deserve emphasis because they cause most cross-tool confusion:

- **Tableau applies filters in a fixed sequence**; `FIXED` LODs are computed
  *before* dimension filters, which is why a `FIXED` result "ignores" a filter
  the user just applied. Fix: add the filter to context.
- **Power BI has no order of operations** in that sense; it has a filter context
  that measures may rewrite with `CALCULATE`. There is no "run this filter
  first" — there is only what the filter context contains when the measure
  evaluates.

One rule holds in both tools, without exception:

> **Formatting lives in the format string, never in a calculated field.**
> No `FORMAT()`, no `STR()`, no concatenating a number into text — not for
> arrows, not for units, not for signs. A number converted to text loses the
> reader's locale and can no longer be sorted, aggregated, conditionally
> formatted, or exported as a number. See
> [number-formatting.md](number-formatting.md#where-formatting-lives).

---

## METRIC DEFINITION DISCIPLINE

Write this down for every metric before writing the formula. Keep it in the
repository, and surface it in the report as a tooltip or a glossary page.

| Field | Example |
|---|---|
| **Name** | Net Revenue |
| **Business question** | How much did we bill, after credits and discounts? |
| **Formula (plain words)** | Gross invoice amount − credit notes − discounts |
| **Grain** | One invoice line |
| **Included / excluded** | Excludes intercompany; excludes cancelled orders |
| **Date used** | Invoice date (not order date, not ship date) |
| **Currency / unit** | BRL, converted at month-end rate |
| **Polarity** | Higher is better |
| **Zero / null handling** | No invoice in period → blank, not 0 |
| **Owner** | Finance — Controller |
| **Refresh** | Daily 06:00, source ERP |

Three fields are skipped most often and cause the most damage:

- **Grain** — the whole model depends on it. "Revenue by rep" is meaningless if
  a deal has three reps and you have not decided whether to split or duplicate.
- **Date used** — order date, ship date, invoice date, and payment date give
  four different answers. Role-playing dates are covered in
  [data-model.md](data-model.md).
- **Polarity** — for cost, error rate, time-to-resolve, and churn, **lower is
  better**, so a negative variance must render green. Hard-coding "negative =
  red" is the single most common formatting bug in MIS reports. See
  [number-formatting.md](number-formatting.md).

---

## CALENDAR AND PERIOD RULES

Management reporting is calendar reporting. These rules are not negotiable.

### Always build a real date dimension

A dedicated date table, one row per day, covering every date in the fact data,
with no gaps — plus fiscal columns, week numbers, and period-offset helpers. In
Power BI, **mark it as the date table**. In Tableau, join or relate it, and use
its fields for date axes rather than the fact table's raw date.

Never let time intelligence run against a date column that lives in the fact
table. Never rely on auto-generated date hierarchies for anything a manager will
see. Build script and column list: [data-model.md](data-model.md).

### Fiscal is not calendar

Ask which fiscal year the business uses before writing a single YTD measure.
A company on an April–March fiscal year needs `Fiscal Year`, `Fiscal Quarter`,
`Fiscal Month Number`, and a fiscal-aware YTD — the built-in `TOTALYTD` /
`DATESYTD` default of December year-end will silently give wrong answers for
nine months of the year.

Also settle: does the business use ISO weeks, 4-4-5 retail periods, or plain
calendar months? Weekly reporting on calendar months is a trap — months contain
4 or 5 of a given weekday, so "Mondays this month" is not comparable
month to month.

### Never compare a partial period to a complete one

The most common lie in management reporting: a dashboard on the 10th of the
month showing "this month vs last month" where this month has 10 days of data
and last month has 31. It always shows a catastrophic decline.

Compare **like to like** — the first 10 days of this month against the first
10 days of last month — or label the comparison explicitly as
month-to-date vs full prior month. Worked patterns for both tools:
[comparison-metrics.md](comparison-metrics.md).

### Stamp the data freshness

Every page carries a visible **"Data as of <timestamp>"**. Readers must never
have to guess whether they are looking at yesterday's numbers. If a refresh
fails, the stamp is what stops a stale report from being trusted.

---

## USE CASE INSTRUCTIONS

Route the request. Do not load every reference file — read the one or two that
apply.

### When asked to BUILD A METRIC OR MEASURE

1. Confirm the tool (Power BI or Tableau) and the date field to use.
2. Write the metric definition table above before any code.
3. Build the **base measure** first (a plain `SUM` / `COUNTROWS`), then derive
   everything else from it. Never repeat a base aggregation inside a derived
   measure.
4. Write the formula from [calculations-powerbi.md](calculations-powerbi.md) or
   [calculations-tableau.md](calculations-tableau.md).
5. State the expected result on a known slice so the user can verify it.

### When asked for a COMPARISON (YoY, MoM, YTD, vs budget)

Go to [comparison-metrics.md](comparison-metrics.md). Check three things before
answering: the fiscal calendar, whether the current period is partial, and the
polarity of the metric.

### When asked WHICH CHART TO USE

Go to [visual-design.md](visual-design.md). Choose from the reader's question,
not the data shape: comparison → bar; trend → line; part-to-whole → stacked bar
or treemap (rarely pie); actual vs target → bullet; contribution to change →
waterfall; many similar series → small multiples.

### When asked to FORMAT NUMBERS

Go to [number-formatting.md](number-formatting.md). Default answers: no more
than three significant digits on an executive tile, abbreviate millions,
right-align, put units in the header, and make variance colour polarity-aware.

### When asked about FILTERS, SLICERS, PARAMETERS, or SECURITY

Go to [filters-interactivity.md](filters-interactivity.md).

### When asked "MY TOTALS DON'T TIE OUT"

This is a diagnosis task, not a formula task. Work the list in
[performance-governance.md](performance-governance.md), but check these first:

1. **Different date field** — is the report on invoice date and the source on
   order date?
2. **Filter context** — Power BI: is a measure using `ALL` / `REMOVEFILTERS`
   and ignoring a slicer? Tableau: is a `FIXED` LOD bypassing a dimension
   filter that should be in context?
3. **Grain / fan-out** — a many-to-one join duplicating fact rows.
4. **Partial period or timezone** — a day boundary offset.
5. **Excluded rows** — nulls dropped by an inner join, or a status filter the
   source does not apply.
6. **Currency or rounding** — different FX rate or rounding at a different
   level of aggregation.

### When asked WHY THE REPORT IS SLOW

Go to [performance-governance.md](performance-governance.md). Measure before
you optimise: Performance Analyzer (Power BI) or Performance Recorder
(Tableau) tells you whether the cost is query, rendering, or calculation.

### When asked to REVIEW or AUDIT an existing report

Go to [review-checklist.md](review-checklist.md). Score correctness, clarity,
comparability, performance, and governance. Lead with correctness findings;
cosmetic notes come last and are labelled as such.

### When asked to DESIGN A WHOLE REPORT OR PACK

Go to [report-architecture.md](report-architecture.md). Produce the layout and
the metric list before building anything.

---

## RED FLAGS

Symptoms that something is structurally wrong, and where to look.

| Symptom | Likely cause | Go to |
|---|---|---|
| Totals ≠ sum of visible rows | Non-additive measure, or a distinct count | calculations files |
| A number changes when an unrelated filter moves | Fan-out from a bad relationship | [data-model.md](data-model.md) |
| A number *doesn't* change when a filter moves | `FIXED` LOD outside context, or `ALL` in DAX | [filters-interactivity.md](filters-interactivity.md) |
| YoY is blank for the first year | Correct — but say so; don't render as 0 | [comparison-metrics.md](comparison-metrics.md) |
| Huge negative % change | Prior period near zero or negative | [comparison-metrics.md](comparison-metrics.md) |
| Every month shows a decline | Partial current period | [comparison-metrics.md](comparison-metrics.md) |
| Cost savings shown in red | Polarity not modelled | [number-formatting.md](number-formatting.md) |
| A column sorts alphabetically, or won't take conditional formatting | The number was concatenated into text in a calculation | [number-formatting.md](number-formatting.md#where-formatting-lives) |
| Decimal separators wrong for some readers | Locale hard-coded by a `FORMAT()` in a calculation | [number-formatting.md](number-formatting.md#where-formatting-lives) |
| Report loads slowly only for some users | RLS applied inefficiently | [performance-governance.md](performance-governance.md) |
| Two tiles, same label, different value | No single metric definition | This file, above |
| Users export to Excel to "check it" | Trust gap — reconcile and publish the tie-out | [performance-governance.md](performance-governance.md) |

---

## PRE-PUBLISH CHECKLIST

- [ ] The decision this report drives is written down, and the audience is named.
- [ ] Every metric has a written definition, grain, and owner.
- [ ] A dedicated date dimension exists, is complete, and is marked as such.
- [ ] The fiscal calendar has been confirmed with the business.
- [ ] Every headline number carries at least one comparison.
- [ ] Partial periods are handled or explicitly labelled.
- [ ] Polarity is correct for every variance (cost down = good).
- [ ] Percentages and percentage points are distinguished in labels.
- [ ] Number formats are consistent; no false precision.
- [ ] All formatting lives in format strings — no number concatenated into text.
- [ ] Chart types match the reader's question; no 3D, no unnecessary pie.
- [ ] Colour is colourblind-safe and never the only encoding of meaning.
- [ ] Default filter state is sensible and stated on screen.
- [ ] Empty / no-data states show a message, not a blank panel.
- [ ] Row-level security is tested by impersonating at least two roles.
- [ ] Totals reconcile to the source system for at least two periods.
- [ ] Edge cases tested: zero, negative, null, first period, missing dimension member.
- [ ] "Data as of" stamp is visible on every page.
- [ ] Load time is acceptable on the slowest expected connection.
- [ ] Refresh schedule is set and failure alerts are configured.
- [ ] A glossary or data dictionary is reachable from the report.
- [ ] Someone other than the author has read it and understood it unaided.

---

*Reference files: [data-model.md](data-model.md) ·
[calculations-powerbi.md](calculations-powerbi.md) ·
[calculations-tableau.md](calculations-tableau.md) ·
[comparison-metrics.md](comparison-metrics.md) ·
[number-formatting.md](number-formatting.md) ·
[visual-design.md](visual-design.md) ·
[filters-interactivity.md](filters-interactivity.md) ·
[report-architecture.md](report-architecture.md) ·
[performance-governance.md](performance-governance.md) ·
[review-checklist.md](review-checklist.md)*

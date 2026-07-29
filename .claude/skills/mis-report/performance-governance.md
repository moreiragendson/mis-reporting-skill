# Performance, Validation, and Governance

> **STATUS: OUTLINE.** Headings are final; prose to be written.
> Style template: [comparison-metrics.md](comparison-metrics.md).

Opening frame to write: correctness and speed are the two ways a report dies.
One wrong number seen by an executive, or forty seconds of loading, and the
report is abandoned regardless of how good the analysis was.

---

## PART 1 — VALIDATION

### Tie-out to source

- Reconcile totals to the source system for **at least two closed periods**
  before publishing, and document the reconciliation.
- Reconcile at more than one grain: grand total, one dimension, one row.
- Keep the reconciliation as a repeatable artefact, not a one-off spreadsheet.

### The "totals don't tie" diagnostic

Expand the ordered checklist from [SKILL.md](SKILL.md):
different date field · filter context (`ALL` / `FIXED`) · grain and fan-out ·
partial period or timezone · rows dropped by an inner join · status/scope
filters the source does not apply · currency and rounding level · restated
source data · late-arriving facts.

Write this as a decision tree — check cheapest and most common first.

### Edge-case test set

Every report is tested against: zero · negative · null · the first period in the
dataset · the current (partial) period · a dimension member with no facts · a
fact with a missing dimension key · a single-row filter selection · the grand
total · a leap year · a period spanning a fiscal year boundary.

### Regression testing

- Snapshot known-good numbers and re-check them after any model change.
- Power BI: DAX query view / unit-test measures; `.pbip` diffs in review.
- Tableau: a validation worksheet of reference figures kept in the workbook.

### Peer review

Someone who did not build it must read it and understand it unaided. Cross-link
to [review-checklist.md](review-checklist.md).

## PART 2 — PERFORMANCE

### Measure before optimising

- Power BI **Performance Analyzer**; DAX Studio for the generated query and
  server timings.
- Tableau **Performance Recorder**; the query plan.
- Attribute the cost: query vs calculation vs rendering. The fix differs
  completely for each.

### Model-level fixes (biggest wins)

- Star schema over flat/snowflake.
- Reduce cardinality; drop unused columns; the right data types.
- Integer surrogate keys over strings.
- Aggregation tables / Power BI aggregations; aggregated Tableau extracts.
- Incremental refresh.

### Storage mode

- Power BI: Import vs DirectQuery vs Dual vs composite models — a decision table
  with the trade-offs.
- Tableau: extract vs live connection; extract filters and aggregation.

### Calculation-level fixes

- Push row-level work upstream to the warehouse or Power Query / extract.
- Avoid iterators over large fact tables; avoid string calcs in the view.
- Expensive patterns to watch: `DISTINCTCOUNT`, bidirectional filters, complex
  RLS, nested LODs, table calcs over huge marks.

### Rendering fixes

- Fewer visuals per page (each is a query).
- Cap the mark count; avoid huge crosstabs.
- Custom visuals cost more than native ones.
- High-cardinality slicers.

### Targets

State concrete goals — e.g. first render under 5s, interaction under 2s — and
test on the slowest expected connection and device.

## PART 3 — GOVERNANCE

### Single source of truth

- Certified/endorsed datasets (Power BI) and published data sources (Tableau).
- One shared semantic model per domain, many reports on top.
- The anti-pattern: every analyst building their own model from the same source.

### Metric ownership

- Every metric has a named business owner who arbitrates its definition.
- A change to a definition is a change-controlled event, announced to readers.
- The metric dictionary as a living artefact; cross-link to
  [SKILL.md](SKILL.md#metric-definition-discipline).

### Environments and version control

- Dev → test → prod. Power BI deployment pipelines; Tableau projects/sites.
- Source control: `.pbip` (text, diffable) over `.pbix`; `.twb` over `.twbx`.
- What is *not* diffable, and how to review changes anyway.
- Naming and folder conventions.

### Access

- Workspace/project roles vs app audiences vs RLS — three distinct controls.
  Cross-link to [filters-interactivity.md](filters-interactivity.md).
- Least privilege; who can edit vs who can view.
- Sharing external to the organisation.

### Refresh and monitoring

- Schedule aligned to the source's load window, not to a habit.
- **Failure alerting** — a silent failure plus a report that still renders is the
  worst outcome. Pair with the data-as-of stamp.
- Gateway/connection management.
- Refresh duration monitoring as an early warning of model bloat.

### Distribution

- Subscriptions and scheduled email; data-driven alerts.
- Export options: PDF, PowerPoint, Excel, paginated reports.
- Usage metrics — find and retire reports nobody opens.

### Lifecycle

- Retirement: a report with no viewers in 90 days is a candidate for deletion.
- Documentation that survives the author leaving.

## GOTCHA TABLE

To write. Seed rows — refresh fails silently and stale data is quoted · report
fast in Desktop, slow in the Service (RLS, gateway) · a definition changed
without notice · two certified datasets for the same domain · `.pbix` in git
with no diffability · optimising rendering when the cost was the query.

## CHECKLIST

To write: ~15 items.

---

*See also: [data-model.md](data-model.md) ·
[review-checklist.md](review-checklist.md) ·
[filters-interactivity.md](filters-interactivity.md)*

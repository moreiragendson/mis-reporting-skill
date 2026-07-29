# Filters, Interactivity, and Security

> **STATUS: OUTLINE.** Headings are final; prose to be written.
> Style template: [comparison-metrics.md](comparison-metrics.md).

Opening frame to write: filters are where reports quietly go wrong. A number
that does not respond to a filter — or responds to the wrong one — destroys
trust faster than a missing feature.

---

## POWER BI: THE FILTER HIERARCHY

### Levels, outermost first

1. Data source / Power Query filters (applied at refresh)
2. RLS
3. Report-level filters
4. Page-level filters
5. Visual-level filters
6. Slicers
7. Cross-filtering from other visuals
8. `CALCULATE` modifiers inside the measure

### Mechanics to cover

- **Edit interactions** — which visual filters, highlights, or ignores which.
  The default is rarely what you want on a dense page.
- Slicer sync across pages; the sync-vs-visible distinction.
- Basic / advanced / relative-date / top-N filter modes.
- Drill-down vs drill-through vs cross-report drill-through.
- Filter pane: hiding, locking, and formatting it. Locking a filter is how you
  stop a reader from producing a nonsense view.
- `ALLSELECTED` vs `ALL` when a measure needs to respect slicers but ignore the
  visual axis.

## TABLEAU: THE FILTER ORDER

- The pipeline again, from
  [calculations-tableau.md](calculations-tableau.md#order-of-operations):
  extract → data source → **context** → `FIXED` LOD → dimension → `INCLUDE`/
  `EXCLUDE` LOD → measure → table calc.
- **Context filters**: what promoting to context actually does, when it is
  required (making a `FIXED` LOD respect a filter, top-N within a subset), and
  its performance cost.
- Filter cards: single/multiple value, wildcard, condition, top-N.
- Apply-to: this worksheet / selected worksheets / all using this data source.
- Dashboard actions: filter, highlight, parameter, set, go-to-sheet, go-to-URL.
- Sets vs filters vs groups — the decision table.

## PARAMETERS AND DYNAMIC SWITCHING

- **Power BI**: field parameters (swap measures or dimensions on an axis),
  what-if parameters, calculation groups. Cross-link to
  [calculations-powerbi.md](calculations-powerbi.md#calculation-groups).
- **Tableau**: parameters + `CASE` for measure/dimension swap; parameter actions
  to make them data-driven; dynamic parameters.
- When *not* to offer a switch: every control is a decision the reader has to
  make. A management pack should mostly present, not ask.

## DEFAULT STATES

- Every report opens in a defined, sensible state — usually current period,
  the reader's own scope, all statuses.
- **State the active filters on screen.** A reader who does not notice a filter
  is left on will quote a wrong number.
- Power BI bookmarks and persistent filters; Tableau default worksheet state
  and "remember my changes".
- A visible "reset to default" control.

## EMPTY AND EDGE STATES

- A blank panel reads as broken. Show a message: "No tickets breached SLA in
  this period" is a result, not an error.
- Filter combinations that legitimately return nothing.
- What happens when a dimension member is filtered out of a hierarchy mid-drill.
- Loading states on slow pages.

## ROW-LEVEL SECURITY

Management reporting is the archetypal RLS case: a manager sees their team, not
their peers'.

### Power BI

- Static roles vs dynamic RLS driven by `USERPRINCIPALNAME()` and a user-to-
  entity mapping table.
- Organisational hierarchies (`PATH` functions) for manager-sees-subtree.
- Filter direction interactions — RLS on a dimension must propagate to the fact.
- Object-level security for hiding whole tables/columns.
- **Testing**: View as role, and testing in the Service, not just Desktop.
- Workspace roles vs app audiences vs RLS — three different things, often
  confused.

### Tableau

- User filters (simple, but embedded in the workbook) vs a data-source-level
  entitlement table joined on `USERNAME()` — prefer the latter.
- `ISMEMBEROF()` for group-based rules.
- Row-level security in the published data source so it cannot be bypassed by a
  new workbook.
- Testing by impersonating users.

### Rules for both

- Test at least two roles plus an admin before publishing.
- RLS is a performance factor, not just a security one.
- Never rely on hiding a visual as a security control.

## PERFORMANCE OF FILTERS

- High-cardinality slicers are expensive; prefer search-enabled or hierarchical
  ones.
- "Select all" on a large dimension.
- Cross-link to [performance-governance.md](performance-governance.md).

## GOTCHA TABLE

To write. Seed rows — a KPI ignores the slicer (`ALL` / `FIXED` outside context)
· top-N returns the wrong set (filter order) · a visual filters another it
shouldn't (edit interactions) · percentages recompute unexpectedly after a
table-calc filter · RLS works in Desktop but not published · a left-on filter
producing a quoted wrong number · sync slicer changing a page the user isn't on.

## CHECKLIST

To write: ~12 items.

---

*See also: [calculations-tableau.md](calculations-tableau.md) ·
[calculations-powerbi.md](calculations-powerbi.md) ·
[report-architecture.md](report-architecture.md)*

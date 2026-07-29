# Report Architecture

> **STATUS: OUTLINE.** Headings are final; prose to be written.
> Style template: [comparison-metrics.md](comparison-metrics.md).

Opening frame to write: a management report is a document with a schedule and an
audience, not a canvas. Design the reading path before opening the tool.

---

## FRAME THE DECISION FIRST

- The four questions: who reads it, what decision does it drive, how often, and
  what would make them act?
- Write the brief as one sentence before building.
- Bad/good brief pair (reuse the pattern from [SKILL.md](SKILL.md)).
- The test: if nobody would behave differently based on any possible value the
  report could show, do not build it.

## AUDIENCE TIERS

The three-layer model, and the rule that each layer answers one question and
hands off to the next.

| Tier | Audience | Answers | Density | Precision |
|---|---|---|---|---|
| **1 — Summary** | Executive | Are we on track? | 5–7 numbers | 3 sig digits |
| **2 — Diagnostic** | Manager | Where is the problem? | Breakdowns by dimension | 0–1 decimals |
| **3 — Detail** | Analyst / operator | Which records? | Row-level table, exportable | Full |

- Tier 1 fits one screen without scrolling.
- The path between tiers is a drill, not a separate report to hunt for.
- Do not compromise: a page that serves all three serves none.

## STANDARD MIS PACK LAYOUT

- **KPI header row** — 4–6 tiles, each with value, comparison, and sparkline.
  Never a bare number.
- **Trend band** — the same metrics over time.
- **Breakdown band** — by the one or two dimensions that drive action.
- **Commentary block** — reserved space, written by a human.
- **Footer** — data-as-of stamp, definitions link, owner, page number.
- Reading order: F-pattern for dense pages, Z-pattern for sparse. Most important
  element top-left.
- Grid alignment; consistent object sizing; a fixed page template reused across
  the pack.

## THE COMMENTARY LAYER

- Charts show *what*; commentary supplies *why* and *so what*.
- Structure: what changed → why → what we are doing → what we need from you.
- Keep it short and dated. Stale commentary is worse than none.
- Where it lives: text box, a comments table joined to the model, or the
  narrative visual.

## FRESHNESS AND PROVENANCE

- **"Data as of <timestamp>"** on every page, always visible.
- Source system named; refresh cadence stated.
- What to show when a refresh fails — a stale report that looks current is a
  liability. Cross-link to
  [performance-governance.md](performance-governance.md).

## CADENCE

- Match the report to the decision cycle: daily operational, weekly management,
  monthly close, quarterly board.
- Period-locked vs rolling views: a monthly pack should be reproducible as at a
  past close date.
- Snapshotting: keeping what the report said last month, when the source has
  since been restated.

## NAVIGATION

- Page hierarchy and a persistent nav element.
- Drill path design; breadcrumbs.
- Bookmarks / dashboard actions for view switching.
- Cross-link to [filters-interactivity.md](filters-interactivity.md).

## MOBILE AND EXPORT

- Mobile layout: tier 1 only, single column, larger touch targets.
- Power BI mobile layout view; Tableau device-specific dashboards.
- PDF/print: fixed size, no tooltip-dependent content, page breaks.
- Assume the report *will* be exported to Excel — decide whether to support that
  deliberately or make the detail tier the sanctioned path.
- Paginated reports (Power BI Report Builder) for true fixed-format financial
  statements — when to use them instead of an interactive report.

## NAMING AND DOCUMENTATION

- Naming conventions for pages, visuals, measures, and files.
- The **data dictionary / glossary page**, reachable from every page.
- Metric definitions surfaced in tooltips.
- Change log visible to readers — a definition change must be announced, not
  discovered.

## GOTCHA TABLE

To write. Seed rows — one page trying to serve exec and analyst · no data-as-of
stamp · commentary written once and never updated · tier 1 requiring scroll ·
essential info only in a tooltip (invisible in PDF) · metric renamed without
notice · a pack that cannot be reproduced as at last month's close.

## CHECKLIST

To write: ~12 items.

---

*See also: [visual-design.md](visual-design.md) ·
[number-formatting.md](number-formatting.md) ·
[performance-governance.md](performance-governance.md)*

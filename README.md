# MIS Reporting Skill — Tableau & Power BI

An agent skill that turns Claude Code (or any compatible AI coding assistant)
into a competent **management information reporting** partner: data modelling,
measure design, comparison metrics, number formatting, visual design, filters,
security, and report governance — for **both Tableau and Power BI**.

> **Status: in development.** `SKILL.md` and `comparison-metrics.md` are
> complete. The other eight reference files are detailed outlines with final
> section structure, being filled in progressively. See
> [Roadmap](#roadmap).

---

## What is this?

Most BI guidance is either tool documentation ("here is what `CALCULATE` does")
or general data-viz advice ("don't use pie charts"). Neither tells you how to
build a monthly management pack that ties out to the ERP, handles a fiscal year
ending in March, shows cost savings in green, and still loads in under five
seconds.

This skill covers that middle layer — the practice of management information
reporting — and gives every pattern in both DAX and Tableau calculation syntax.

## Key features

**Correctness first**
- A tool-parity table mapping every core concept between Power BI and Tableau
- Filter context (DAX) and order of operations (Tableau) treated as the primary
  source of wrong numbers
- The partial-period trap, worked in full for both tools
- Variance edge cases: zero bases, negative priors, percent vs percentage points
- A "my totals don't tie out" diagnostic ordered by likelihood

**Calendar and comparison**
- Date dimension requirements, fiscal calendars, ISO weeks, 4-4-5
- YoY, MoM, QoQ, YTD/MTD/QTD, rolling 12, budget variance, attainment, run rate
- Price–volume–mix decomposition
- Signal-vs-noise discipline so the pack doesn't flag every wiggle

**Presentation**
- Chart selection driven by the reader's question, not the data shape
- IBCS-style notation conventions for recurring packs
- Polarity-aware variance formatting (cost down = green)
- Locale-correct number formatting, including pt-BR separators
- Colourblind-safe palettes; colour never as the sole encoding

**Delivery**
- Three-tier report architecture (executive → manager → analyst)
- Row-level security in both tools, and how to test it
- Performance diagnosis before optimisation
- Publishing, refresh alerting, and metric governance

## Installation

Paste this into Claude Code or a compatible agent:

```
Install or update the MIS Reporting skill as a standalone skill for the client
I am using. Read and follow
https://github.com/moreiragendson/mis-reporting-skill/blob/main/INSTALL.md
```

Or install manually — see [INSTALL.md](INSTALL.md) for the directory mapping.

## Usage

Once installed, invoke explicitly or just describe the task.

**Claude Code:** `/mis-report <task>`

```
/mis-report build a YoY revenue measure for Power BI, fiscal year ends 31 March
/mis-report my Tableau totals don't match the source system
/mis-report which chart for actual vs target by region?
/mis-report review this dashboard
```

The skill also activates automatically on requests mentioning dashboards, KPIs,
measures, DAX, LOD expressions, YoY/MoM/YTD, budget variance, slicers, or
number formats.

### Four modes

| Mode | Ask for | Returns |
|---|---|---|
| **Build** | "build a measure / a dashboard / a date dimension" | Definitions first, then formulas for your tool |
| **Debug** | "my totals don't tie", "this filter does nothing" | Ordered diagnostic, most likely cause first |
| **Design** | "which chart", "how should this page be laid out" | Choice plus the reasoning, tied to the reader's question |
| **Review** | "audit this report" | Scored findings, correctness before cosmetics |

## What's inside

```
skills/mis-report/
├── SKILL.md                   Core principles, workflow, tool parity, routing
├── data-model.md              Star schema, grain, date dimension, relationships
├── calculations-powerbi.md    Filter context, CALCULATE, time intelligence, RLS
├── calculations-tableau.md    Order of operations, LODs, table calcs, parameters
├── comparison-metrics.md      YoY/MoM/YTD, variance, partial periods, PVM
├── number-formatting.md       Precision, polarity, locale, pp vs %
├── visual-design.md           Chart selection, IBCS, colour, accessibility
├── filters-interactivity.md   Filter hierarchy, parameters, drill, security
├── report-architecture.md     Audience tiers, pack layout, cadence, mobile
├── performance-governance.md  Tie-out, diagnosis, refresh, ownership
└── review-checklist.md        Five-dimension audit rubric
```

## Roadmap

- [x] Repository scaffold and packaging
- [x] `SKILL.md` — core principles, workflow, tool parity, routing
- [x] `comparison-metrics.md` — the worked reference file
- [ ] `data-model.md`
- [ ] `calculations-powerbi.md` / `calculations-tableau.md`
- [ ] `number-formatting.md` / `visual-design.md`
- [ ] `filters-interactivity.md` / `report-architecture.md`
- [ ] `performance-governance.md` / `review-checklist.md`
- [ ] Worked examples in `examples/`
- [ ] Expanded eval set

## Sources

Grounded in public, citable sources — IBCS notation standards, Stephen Few,
Cole Nussbaumer Knaflic, Edward Tufte, Cynthia Brewer's ColorBrewer, Ralph
Kimball's dimensional modelling, SQLBI, and the Microsoft and Tableau product
documentation. See [sources/SOURCES_RANKED.md](sources/SOURCES_RANKED.md).

## Acknowledgements

Repository structure, packaging, and documentation style follow
[hanlulong/econ-writing-skill](https://github.com/hanlulong/econ-writing-skill).

## Contributing

Issues and pull requests welcome — particularly corrections to DAX or Tableau
patterns, and additional gotchas from production experience. When adding a
pattern, give it in **both** tools or say explicitly that it has no equivalent.

Edit files under `skills/mis-report/` only — that folder is canonical. Then run
`scripts/sync-skill.ps1` (or `.sh`) to update the `.claude/` and `.agents/`
mirrors before committing.

## License

MIT — see [LICENSE](LICENSE).

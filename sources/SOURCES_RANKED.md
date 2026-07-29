# Sources

Public, citable sources underpinning this skill, grouped by the area they
inform. All prose in this repository is original; these are the references it
is grounded in, not material it reproduces.

---

## Tier 1 — Foundational

### Dimensional modelling
- **Ralph Kimball & Margy Ross**, *The Data Warehouse Toolkit* (3rd ed.) —
  star schema, grain declaration, role-playing dimensions, slowly changing
  dimensions, the date dimension. Informs [data-model.md].
- **Kimball Group** design tips archive.

### Information design
- **Edward Tufte**, *The Visual Display of Quantitative Information* — data-ink,
  chartjunk, small multiples.
- **Stephen Few**, *Information Dashboard Design* and *Show Me the Numbers* —
  the bullet chart, dashboard density, table typography. The single most
  relevant author for MIS reporting specifically.
- **Cole Nussbaumer Knaflic**, *Storytelling with Data* — message-first titles,
  decluttering, directing attention with colour.
- **Jacques Bertin**, *Semiology of Graphics* — the visual variables.

### Notation standards
- **IBCS® (International Business Communication Standards)** — the SUCCESS
  formula and scenario notation (actual / plan / forecast / prior year).
  The reference point for consistent recurring management packs.
  <https://www.ibcs.com/standards/>

### Colour
- **Cynthia Brewer**, ColorBrewer — sequential, diverging, and qualitative
  schemes with colourblind-safe filtering. <https://colorbrewer2.org>
- **W3C WCAG 2.2** — contrast ratios and the "not by colour alone" criterion.
  <https://www.w3.org/WAI/WCAG22/quickref/>

---

## Tier 2 — Tool-specific

### Power BI / DAX
- **Marco Russo & Alberto Ferrari (SQLBI)**, *The Definitive Guide to DAX*
  (2nd ed.) — filter context, row context, context transition, `CALCULATE`.
  The authoritative treatment. <https://www.sqlbi.com>
- **SQLBI DAX Patterns** — time intelligence, standard and non-standard
  calendars, budget patterns. <https://www.daxpatterns.com>
- **Microsoft Learn — Power BI documentation**: data modelling guidance, DAX
  function reference, RLS, deployment pipelines, Performance Analyzer, storage
  modes and aggregations. <https://learn.microsoft.com/power-bi/>
- **Microsoft Learn — Power BI optimization guide.**

### Tableau
- **Tableau Help — Order of Operations.** The canonical description of the
  filter pipeline. <https://help.tableau.com/current/pro/desktop/en-us/order_of_operations.htm>
- **Tableau Help — Level of Detail Expressions** (`FIXED` / `INCLUDE` /
  `EXCLUDE`) and **Table Calculations** (addressing and partitioning).
- **Tableau — Designing Efficient Workbooks** (Alan Eldridge / Tableau
  whitepaper) — the standard performance reference.
- **Tableau Help — Row-Level Security** options and user functions.

---

## Tier 3 — Practice and measurement

- **Avinash Kaushik**, *Web Analytics 2.0* — the discipline of actionable
  metrics and avoiding vanity metrics.
- **Donald Wheeler**, *Understanding Variation* — process behaviour charts;
  the basis for the signal-vs-noise section in [comparison-metrics.md].
- **Douglas Hubbard**, *How to Measure Anything* — defining a metric before
  measuring it.
- **Nicole Forsgren, Jez Humble & Gene Kim**, *Accelerate* — metric selection
  discipline; useful as a model for defining a small set of metrics that drive
  behaviour.

## Finance and variance analysis

- Standard managerial-accounting treatments of **price–volume–mix** variance
  decomposition (any intermediate management-accounting text). Note in
  [comparison-metrics.md] that the decomposition is convention-dependent.
- **IFRS / local GAAP presentation conventions** for negatives in parentheses
  and currency disclosure — relevant to [number-formatting.md].

---

## Structural inspiration

- **hanlulong/econ-writing-skill** — repository structure, packaging, and
  documentation style. <https://github.com/hanlulong/econ-writing-skill>

---

*Contributions: when adding a source, place it in the tier that matches how
load-bearing it is, and name the reference file it informs.*

# Visual Design

> **STATUS: OUTLINE.** Headings are final; prose to be written.
> Style template: [comparison-metrics.md](comparison-metrics.md).
> **Sourcing note:** write original prose grounded in public sources (IBCS
> notation, Few, Knaflic, Tufte, Brewer/ColorBrewer, WCAG). Do not paste from
> any bundled or proprietary design skill.

Opening frame to write: choose the chart from the reader's question, not from
the data's shape and never from the chart gallery.

---

## CHART SELECTION BY QUESTION

Decision table to write: question → chart → why.

| The reader asks | Chart |
|---|---|
| How do these compare? | Horizontal bar, sorted by value |
| How has this changed over time? | Line (continuous) or column (discrete periods) |
| Are we hitting target? | Bullet chart |
| What drove the change? | Waterfall / bridge |
| What is the composition? | Stacked bar; treemap for many parts |
| How do many series compare? | Small multiples |
| Is there a relationship? | Scatter |
| How is it distributed? | Histogram, box plot |
| Where geographically? | Choropleth — only if geography is the question |
| What is the current value? | KPI tile with a comparison and a sparkline |

### Charts to avoid, and what to use instead

- **Pie** — only for 2–3 parts summing to a meaningful whole. Otherwise bar.
- **Donut with a number in the middle** — a KPI tile pretending to be a chart.
- **Dual axis** — two scales invite any conclusion the author wants. Use indexed
  series or two stacked panels instead.
- **Truncated y-axis on bars** — bars encode length; the baseline must be zero.
  Lines may be truncated (they encode position), with the break labelled.
- **3D anything, gauges, speedometers, word clouds.**
- **Radar/spider** for more than a few axes.

## THE MIS EXHIBIT SET

The small set of charts that carries most management reporting. Write each with
a when-to-use, a build note for both tools, and a common mistake.

- **Bullet chart** — actual, target, qualitative bands. The correct answer to
  "actual vs target" almost every time.
- **Variance column chart** — deviation from plan, zero baseline, polarity-aware
  colour.
- **Waterfall / bridge** — contribution to change; pairs with price–volume–mix
  in [comparison-metrics.md](comparison-metrics.md#contribution-to-change).
- **Small multiples** — same axis, same scale, one panel per entity. Replaces
  the unreadable 15-series line chart.
- **Sparkline** — trend inside a table row or tile.
- **Sorted bar with reference line** — ranking against a benchmark.
- **Cumulative line (YTD vs YTD LY)** — pacing.
- **Line with ±2σ band** — signal vs noise.

## IBCS NOTATION

Why a consistent visual grammar matters more in a recurring pack than in a
one-off analysis. Cover the core conventions worth adopting even without full
certification:

- Consistent scenario encoding: actual (solid), plan (outline/hatched),
  forecast (dashed/hatched), prior year (grey).
- Consistent time direction (left→right) and structure direction (top→bottom).
- Variance always shown as its own element, never left for the reader to compute.
- Consistent scaling across comparable charts; mark scale breaks explicitly.
- Message-first titles.

## COLOUR

### The formula

- **Grey by default.** Colour is a scarce resource spent on the point of the
  exhibit.
- **Categorical** — up to ~6 hues, distinguishable in greyscale and to viewers
  with deuteranopia/protanopia.
- **Sequential** — one hue, varying lightness, for ordered magnitude.
- **Diverging** — two hues around a meaningful midpoint (zero variance,
  target), balanced in lightness.
- **Semantic** — good/bad. Must be polarity-aware; cross-link to
  [number-formatting.md](number-formatting.md).

### Rules

- Never encode meaning in colour alone — pair with shape, position, label, or
  arrow. ~8% of men have a colour vision deficiency.
- Red/green is the worst possible pair for exactly that reason. Use
  blue/orange or add ▲▼ arrows.
- Same entity, same colour, on every page of the pack.
- Test the palette in greyscale and with a CVD simulator.
- Contrast: WCAG AA (4.5:1 for text) applies to labels on coloured fills.
- Brand palettes: how to accept one and still keep the categorical set legible.

## AXES, SCALES, AND LABELS

- Zero baseline for bars; labelled break if truncated.
- Consistent scale across small multiples, or the comparison is void.
- Log scale only when explicitly labelled and the audience is technical.
- Direct labelling beats a legend; put the series name at the end of the line.
- Sort by value, not alphabetically, unless the order carries meaning
  (time, ordinal categories).

## DECLUTTERING

Checklist to write: remove gridlines that do not aid reading · drop chart
borders and backgrounds · axis labels only where needed · no redundant legend
when directly labelled · no data labels on every point of a dense series ·
whitespace over separators.

## TITLES AND COMMENTARY

- **Message-first titles.** "Margin fell 3.1pp on mix, not price" beats
  "Margin by Month".
- Annotation layer for the two or three points that matter.
- A commentary block per page: what changed, why, what we are doing about it.
- The discipline of *not* annotating everything — cross-link to
  [comparison-metrics.md](comparison-metrics.md#signal-or-noise).

## TOOLTIPS

- Tooltips are the second layer, not a dumping ground.
- Include the comparison and the definition, not just the value.
- Tableau viz-in-tooltip; Power BI report page tooltips.
- Tooltips do not exist on mobile or in PDF exports — never hide essential
  information there.

## ACCESSIBILITY

- Colour-independence, contrast, font size floors.
- Keyboard navigation and screen-reader / alt-text support in both tools.
- Tab order for report objects.
- Do not rely on hover for anything required to understand the page.

## GOTCHA TABLE

To write. Seed rows — dual axis implying a correlation · truncated bar axis
exaggerating a difference · pie with 11 slices · inconsistent small-multiple
scales · red/green only · rainbow sequential scale · legend far from the marks ·
partial final period plotted like a complete one.

## CHECKLIST

To write: ~12 items.

---

*See also: [number-formatting.md](number-formatting.md) ·
[report-architecture.md](report-architecture.md) ·
[comparison-metrics.md](comparison-metrics.md)*

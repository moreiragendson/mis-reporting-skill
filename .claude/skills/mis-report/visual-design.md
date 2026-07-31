# Visual Design

> **Sourcing note:** prose here is original, grounded in public sources — IBCS notation, Few, Knaflic, Tufte, Brewer/ColorBrewer, WCAG. Full list: <https://github.com/moreiragendson/mis-reporting-skill/blob/main/sources/SOURCES_RANKED.md>

Choose the chart from the reader's question, not from the data's shape and never from the chart gallery. The shape of the data tells you what is *possible*; the question tells you what is *useful*. A management pack is read in minutes by someone who did not build it, so every exhibit has to answer one question quickly and answer it without being decoded.

This file covers what to draw, how to colour it, what to label, and what to leave out — in both Power BI and Tableau.

------------------------------------------------------------------------

## CHART SELECTION BY QUESTION

Start here. Find the reader's question, take the chart.

| The reader asks | Chart | Why |
|------------------------|------------------------|------------------------|
| How do these compare? | Horizontal bar, sorted by value | Length on a common baseline is the most accurately read encoding |
| How has this changed over time? | Line (continuous) or column (discrete periods) | Position over a shared axis shows rate of change |
| Are we hitting target? | Bullet chart | Actual, target, and tolerance in one compact row |
| What drove the change? | Waterfall / bridge | Decomposes a delta into named, additive contributions |
| What is the composition? | Stacked bar; treemap for many parts | Parts of a whole, when the whole is meaningful |
| How do many series compare? | Small multiples | Same scale, no overplotting, scannable |
| Is there a relationship? | Scatter | Two continuous variables, one mark per entity |
| How is it distributed? | Histogram, box plot | Shows spread and outliers that an average hides |
| Where geographically? | Choropleth | **Only if geography is the question**, not just because you have a region field |
| What is the current value? | KPI tile with a comparison and a sparkline | A bare number is not information — see [comparison-metrics.md](comparison-metrics.md) |

Two habits will fix most charts. **Sort bars by value**, so the ranking is readable without hunting. **Use horizontal bars when the labels are words**, because rotated text is not readable at a glance.

### Charts to avoid, and what to use instead

-   **Pie** — angle is read poorly, and comparison across pies is hopeless. Use only for two or three parts of a genuinely meaningful whole. Otherwise a sorted bar.
-   **Donut with a number in the middle** — a KPI tile pretending to be a chart. Use the KPI tile, which has room for the comparison that actually matters.
-   **Dual axis** — two independent scales let the author manufacture any correlation, and the reader cannot detect it. Index both series to 100 at a common baseline, or use two stacked panels with a shared time axis.
-   **Truncated y-axis on bars** — bars encode *length*, so the baseline must be zero or the encoding lies. Lines encode *position* and may be truncated, with the break labelled.
-   **3D anything, gauges, speedometers, word clouds** — decoration that costs accuracy. A gauge shows one number in the space a bullet chart uses for actual, target, and history.
-   **Radar/spider beyond a few axes** — the enclosed area changes with the order of the axes, which is arbitrary. Use a sorted bar or a small-multiple set.

## THE MIS EXHIBIT SET

Eight exhibits carry most management reporting. Learn these properly rather than reaching for variety.

### Bullet chart

**Use when** the question is "actual vs target". Which, in a management pack, is most of the time.

A bar for actual, a perpendicular tick for target, optional shaded bands behind for qualitative ranges (poor / acceptable / good). Compact enough to stack a dozen in a column, so an entire scorecard fits one screen.

**Power BI** — there is no native bullet visual; use the KPI visual for a single metric, or a bar chart with a constant-line target from the analytics pane. **Tableau** — built in: select the measure and the target, then *Show Me* → bullet graph.

**Common mistake:** shading the bands in traffic-light colours. The bands are context and should be greys; colour belongs to the actual bar when it breaches.

### Variance column chart

**Use when** the message is the *gap*, not the level. Plot the deviation from plan directly rather than making the reader subtract two bars.

Zero baseline, columns above and below, polarity-aware colour — for a cost metric, below plan is good. See [number-formatting.md](number-formatting.md#polarity-the-most-common-formatting-bug).

**Common mistake:** plotting variance % when the base is tiny, producing a +400% column that represents R\$ 3k. Plot the absolute variance and put the percentage in the label.

### Waterfall / bridge

**Use when** the reader asks "what drove the change?" Opening balance, named contributions, closing balance.

Pairs with the price–volume–mix decomposition in [comparison-metrics.md](comparison-metrics.md#contribution-to-change).

**Power BI** — native waterfall visual, with a breakdown field for contributions. **Tableau** — a Gantt bar chart with a running sum and a negative size field; not obvious, but standard.

**Common mistake:** more than about seven bars. Group the tail into "Other" and keep the bridge legible.

### Small multiples

**Use when** you have more than five series. The fifteen-line spaghetti chart becomes fifteen readable panels.

**Non-negotiable:** the same axis range in every panel. A per-panel auto-scale makes a panel ranging 0–10 look identical to one ranging 0–10,000, and the comparison the exhibit exists for is void.

**Power BI** — the small multiples formatting option on core visuals. **Tableau** — put the dimension on rows or columns and set the axes to fixed.

### Sparkline

**Use when** a table row or KPI tile needs trend context. No axes, no labels, just shape — optionally a dot on the last point.

**Common mistake:** adding a y-axis. If it needs an axis, it is not a sparkline; promote it to a real chart.

### Sorted bar with reference line

**Use when** ranking entities against a benchmark — average, target, or prior period. The reference line is what turns a ranking into a judgement.

**Common mistake:** ranking on a rate without exposing the base. A 100% conversion rate from one lead tops the chart. Filter to a minimum base, or show the base — see [TOOLTIPS](#tooltips).

### Cumulative line (YTD vs YTD last year)

**Use when** the question is pacing: are we ahead or behind, cumulatively? Two cumulative lines diverging is far easier to read than twelve pairs of bars.

**Common mistake:** letting the current-year line run to the end of the axis when the year is partial. Stop the line at the data cutoff.

### Line with ±2σ band

**Use when** you need to stop readers reacting to normal variation. Rolling mean as the centre line, a shaded band at ±2 standard deviations, annotation only on points outside it. See [comparison-metrics.md](comparison-metrics.md#signal-or-noise).

## IBCS NOTATION

In a one-off analysis, the reader studies the chart. In a **recurring pack**, they scan it — and scanning only works if the visual grammar is identical every month. IBCS (International Business Communication Standards) is the most developed public convention for this. Full certification is not the point; adopting a fixed grammar is.

The conventions worth taking even without adopting IBCS wholesale:

| Element       | Convention                |
|---------------|---------------------------|
| Actual        | Solid fill, darkest       |
| Plan / budget | Outlined, no fill         |
| Forecast      | Hatched or dashed         |
| Prior year    | Grey, lighter than actual |

Plus four rules:

-   **Consistent direction.** Time runs left→right; structure (entities, accounts) runs top→bottom. Never mix within a pack.
-   **Variance is its own element.** Show it — never leave the reader to compute the difference between two bars.
-   **Consistent scaling across comparable charts.** If two charts sit side by side and invite comparison, they share a scale, or you mark the break explicitly.
-   **Message-first titles.** See [TITLES AND COMMENTARY](#titles-and-commentary).

The payoff is compounding: once readers learn the grammar, they stop decoding and start reading.

## COLOUR

### The formula

-   **Grey by default.** Colour is a scarce resource, spent on the point of the exhibit. If everything is coloured, nothing is emphasised.
-   **Categorical** — up to about six hues for unordered categories. Beyond six, hue stops being distinguishable; switch to small multiples or group the tail.
-   **Sequential** — one hue, varying lightness, for ordered magnitude. Never a rainbow: the spectrum has no perceptual order, so readers cannot rank it.
-   **Diverging** — two hues around a meaningful midpoint (zero variance, target attainment of 100%), balanced in lightness so neither end dominates.
-   **Semantic** — good/bad. Must be polarity-aware: for a cost or churn metric, a decrease is good. See [number-formatting.md](number-formatting.md#polarity-the-most-common-formatting-bug).

### Rules

-   **Never encode meaning in colour alone.** Pair it with shape, position, a label, or an arrow. Roughly 8% of men have a colour vision deficiency, and every reader loses colour when the pack is printed in greyscale.
-   **Red/green is the worst available pair** for exactly that reason — and it is the default in finance. Use blue/orange, or keep red/green *and* add ▲▼ arrows so the sign survives without hue.
-   **Same entity, same colour, every page.** If "South region" is teal on page two, it is teal on page nine.
-   **Test the palette twice** before publishing: screenshot the page and desaturate it to greyscale, then run it through a CVD simulator for deuteranopia and protanopia. Anything that collapses into indistinguishable tones needs a lightness difference, not a different hue.
-   **Contrast.** WCAG AA requires 4.5:1 for normal text — this applies to data labels sitting on coloured fills, which is where it usually fails.
-   **Brand palettes.** Accept the brand's primary colour for emphasis and its neutrals for structure, but do not let a five-colour brand deck become your categorical scale. Derive a categorical set with adequate lightness spacing and reserve brand colours for the accent role.

## AXES, SCALES, AND LABELS

-   **Zero baseline for bars, always.** A bar is read as a length, and a truncated axis exaggerates a small difference into a large one. This is the single most common way an honest analyst publishes a misleading chart. Lines are exempt — they encode position — but label the break.
-   **Consistent scale across small multiples,** or the comparison is void.
-   **Log scale only when explicitly labelled** and the audience is technical. Most management audiences will read it linearly.
-   **Direct labelling beats a legend.** Put the series name at the end of the line. Every legend forces a round trip between the mark and the key.
-   **Sort by value, not alphabetically,** unless the order carries meaning — time, or an ordinal category like size bands.
-   **Units in the axis title or the header, not repeated in every label.** "R\$ mi" once, not on all twelve columns.

## DECLUTTERING

Every element must earn its place. Remove, in this order:

-   **Chart borders and background fills** — they separate nothing that whitespace cannot separate.
-   **Gridlines that do not aid reading** — keep a few light horizontal ones on a chart read for values; drop them entirely where the shape is the message.
-   **Redundant legends** — deleted automatically once you label directly.
-   **Data labels on every point of a dense series** — label the first, last, and the extremes.
-   **Axis labels at every tick** — every second or third tick is usually enough.
-   **Separator lines in tables** — whitespace and alignment do the same job quieter. See [number-formatting.md](number-formatting.md#alignment-and-typography-in-tables).

The test: remove an element and ask whether the reader lost anything. Most of the time they did not.

## TITLES AND COMMENTARY {#titles-and-commentary}

**Write message-first titles.** The title is the most-read text on the page and usually the most wasted.

-   ❌ "Margin by Month"
-   ✅ "Margin fell 3.1pp on mix, not price"

The first names the axes, which the reader can already see. The second states the finding — and forces you to know what the finding is before you publish.

Keep a **descriptive subtitle** underneath for the axes and units if the message-first title leaves them ambiguous.

**Annotate the two or three points that matter** — a policy change, a system migration, an outlier with a known cause. Annotation is how tacit knowledge survives the analyst leaving.

**One commentary block per page:** what changed, why, what we are doing about it. Three sentences. This is the layer where interpretation lives.

And exercise the discipline of *not* annotating everything. A pack that flags every movement trains readers to ignore the flags — see [comparison-metrics.md](comparison-metrics.md#signal-or-noise).

That placement matters for the next section: **interpretation belongs to the title and the commentary block, both of which survive a PDF export.** The tooltip does not.

## TOOLTIPS {#tooltips}

The tooltip is the second layer, not a dumping ground. It exists to answer the follow-up question a reader has *after* the chart has done its job — and it has to do that in about a second, because the cursor is already moving.

Design it as **fixed slots, not free text.**

### The five slots

In reading order:

| \# | Slot | Content | Required |
|------------------|------------------|------------------|------------------|
| 1 | **Identity** | Which mark is this — dimension member and period | Yes |
| 2 | **Value** | The number, in the *same* format as the visual | Yes |
| 3 | **Comparison** | **One only** — absolute and relative | Yes |
| 4 | **Base** | Numerator/denominator for rates; N for averages | If a rate, %, or average |
| 5 | **Definition** | One line, only where the metric is contested | No |

**Five lines is the ceiling.** If a tooltip needs more, the problem is the chart, not the tooltip.

### The base slot is the one that gets skipped

It has the highest payoff and the lowest adoption. A rate without its base is indefensible:

```         
Conversion rate — Ana Souza
18.2%
▲ 3.1pp vs last month
2 of 11 leads            ← without this, the ranking is noise
```

In a "conversion by rep" bar chart, whoever has one lead and one win sits at the top with 100%. The tooltip is where that collapses — without cluttering the visual for everyone else.

### What does not go in

-   **Anything already visible in the chart.** If the axis says "Mar 2026", repeating "Month: March 2026" burns the most valuable line.
-   **A second comparison.** Choose between "vs LY" and "vs target". Showing both hands the reader a decision that was yours to make.
-   **Every measure in the model,** on the theory that someone might want it.
-   **Interpretive prose.** A full narrative sentence in a tooltip is a data-journalism convention, not a BI one, and it does not survive export.

Full narrative tooltips are not banned — they are an **exception requiring justification**, appropriate to a one-off showcase dashboard (a board presentation, a portfolio piece), not to a recurring pack.

### Slots by visual type

| Visual | Slots |
|------------------------------------|------------------------------------|
| KPI tile | Value · comparison · base · data-as-of |
| Time series | Period · value · vs prior period · vs LY — *the one case where two comparisons are justified* |
| Ranking bar | Member · value · % of total · rank (3rd of 24) |
| Variance column | Actual · plan · variance abs · variance % |
| Scatter / map | Identity · both encoded dimensions · base |
| Small multiples | As time series, but **without** repeating the panel name |

### The partial-period tooltip

The rightmost point of almost every time series is incomplete. The tooltip is the cheapest place to say so:

```         
Mar 2026 (partial — 12 of 31 days)
R$ 1.84 mi
▲ 8.2% vs the same 12 days of Feb
```

Without that marking, the visual dip in the last point reads as a decline in the business. See [comparison-metrics.md](comparison-metrics.md#the-partial-period-trap).

### The compact comparison line

The arrow and the sign are **formatting, not content.** Never assemble a tooltip line as a concatenated string — it bakes in the author's locale, kills sorting and conditional formatting, and exports as dead text. The rule and its full reasoning are in [number-formatting.md](number-formatting.md#where-formatting-lives).

Both tools do the same thing: an ordinary numeric measure or field, carrying a sectioned format string.

```         
▲#,##0.0%;▼#,##0.0%;0.0%
```

Sections are `positive;negative;zero`. The negative section omits the minus sign unless you write one in, so `-0.185` renders as `▼18,5%` — the arrow carries the sign.

**Power BI** — write the comparison as a normal measure, drop it into the *Tooltips* field well, and set the format string on the measure (*Measure tools → Format → Custom*). Measures in that well render one per line, already formatted.

``` dax
Revenue YoY % =
VAR Prior = [Revenue LY]
RETURN
    IF (
        NOT ISBLANK ( Prior ) && Prior <> 0,
        DIVIDE ( [Revenue] - Prior, ABS ( Prior ) )
    )
```

No `FORMAT`, no concatenation, no arrow measure. The measure returns a number; the format string draws the arrow.

**Tableau** — the same calculation as a field, with *Format → Numbers → Custom* set to the same string, then referenced in the tooltip editor:

```         
// Tooltip editor content
<MONTH(Order Date)> <YEAR(Order Date)>
Revenue: <AGG(Revenue)>
<AGG(Revenue YoY %)> vs LY    PY: <AGG(Revenue LY)>
```

The `<AGG(...)>` token carries the field's own number format and the workbook locale, which is precisely why the format has to live on the field.

The one real asymmetry: **Power BI can drive the format string from a DAX expression** — dynamic format strings and calculation groups — so the format can react to a slicer, switching between % and pp or between currencies. Tableau has no expression-driven equivalent; its format is a static per-field property with a per-worksheet override. Both are in the parity table in [SKILL.md](SKILL.md).

### Technical discipline

-   **Power BI report page tooltips fire their own DAX query on every hover.** On a dense matrix that is a self-inflicted load test. Keep the tooltip page tiny, and hold to the two-second rule — if the tooltip cannot render in two seconds, it is worse than no tooltip.
-   **Tableau viz-in-tooltip** is well supported and worth using, with discipline: one simple viz, explicit `maxwidth` and `maxheight`, and `filter="<All Fields>"` only when you actually want the cross-filter.
-   **Turn off the command buttons** (*Keep Only* / *Exclude*) in an executive pack — they invite an accidental filter that the reader cannot undo.
-   **Never put essential information on hover only.** Mobile has no hover, PDF has no hover, and an Excel export has no tooltip. See [report-architecture.md](report-architecture.md#mobile-and-export).

## ACCESSIBILITY

Accessibility is not a separate pass; it is most of what already makes a chart readable under bad conditions — a projector, a phone, a printout.

-   **Colour independence.** Every colour-encoded distinction must also be carried by position, shape, a label, or an arrow.
-   **Contrast.** WCAG AA, 4.5:1 for normal text and 3:1 for large text and meaningful graphical elements. Grey-on-white axis labels fail this constantly.
-   **Font size floor.** Nothing below about 9pt in a pack that will be projected or exported to PDF.
-   **Alt text.** Power BI has an alt-text property per visual and accepts a DAX expression, so the description can carry the actual numbers. Tableau supports a caption per worksheet and a title read by screen readers.
-   **Tab order.** Both tools let you set the tab order for report objects. Default order follows creation, which is meaningless — set it to the reading order.
-   **Do not rely on hover for anything required to understand the page** — see [TOOLTIPS](#tooltips).

## GOTCHA TABLE

| Symptom | Why it misleads | Fix |
|------------------------|------------------------|------------------------|
| Dual axis with two scales | Any correlation can be manufactured by rescaling | Index both series to 100, or split into two panels |
| Truncated bar axis | Bars encode length; a 2% difference looks like 50% | Zero baseline, always |
| Pie with 11 slices | Angles below \~10% are indistinguishable | Sorted bar, tail grouped as "Other" |
| Small multiples on auto-scale | Each panel gets its own range; panels look alike at wildly different magnitudes | Fix the axis range across all panels |
| Red/green as the only encoding | \~8% of men cannot separate them; greyscale printing loses both | Add ▲▼ arrows or switch to blue/orange |
| Rainbow sequential scale | The spectrum has no perceptual order, so magnitude cannot be ranked | Single hue, varying lightness |
| Legend far from the marks | Every lookup is a round trip; readers stop making it | Direct-label the series |
| Partial final period plotted like a complete one | The drop is the calendar, not the business | Label it, dash it, or exclude it — see [comparison-metrics.md](comparison-metrics.md#related-the-incomplete-last-bar-problem) |
| Traffic-light bands behind a bullet chart | Colour on context competes with colour on the data | Grey bands, colour reserved for breach |
| Variance % on a tiny base | +400% represents a rounding error | Plot absolute variance, put % in the label |

## CHECKLIST

-   [ ] Every exhibit answers one stated question.
-   [ ] Chart type chosen from the question, not from the data's shape.
-   [ ] Bars start at zero; any truncated line axis is labelled.
-   [ ] Bars are sorted by value unless the order carries meaning.
-   [ ] Small multiples share one fixed scale.
-   [ ] Grey is the default; colour marks the point of the exhibit.
-   [ ] Nothing is encoded by colour alone.
-   [ ] The palette survives greyscale and a CVD simulator.
-   [ ] The same entity has the same colour on every page.
-   [ ] Series are directly labelled; legends removed where possible.
-   [ ] Titles state the message, not the axes.
-   [ ] Scenario notation (actual / plan / forecast / prior year) is consistent.
-   [ ] Tooltips follow the slot structure and stay within five lines.
-   [ ] Nothing essential lives only in a tooltip.
-   [ ] Partial periods are marked wherever they appear.
-   [ ] Alt text and tab order are set.

------------------------------------------------------------------------

*See also: [number-formatting.md](number-formatting.md) for precision, polarity, and locale · [report-architecture.md](report-architecture.md) for page layout and the commentary layer · [comparison-metrics.md](comparison-metrics.md) for the measures behind these exhibits.*
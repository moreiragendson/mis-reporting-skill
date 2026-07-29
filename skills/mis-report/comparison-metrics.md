# Comparison Metrics and Calendar Logic

A number on its own is not information. This file covers how to build the
comparison that gives it meaning — against the prior period, the same period
last year, a target, a peer, or a cumulative baseline — in both Power BI and
Tableau, and how to avoid the calendar traps that make those comparisons lie.

Prerequisite: a proper date dimension. If you do not have one, stop and build
it first — see [data-model.md](data-model.md). Every pattern below assumes a
date table named `Date` with a `Date` column, related to the fact table on a
single date field.

---

## THE COMPARISON TAXONOMY

Pick the comparison from the reader's question, not from habit.

| Comparison | Answers | Use when |
|---|---|---|
| **vs prior period** (MoM, QoQ, WoW) | "Are we moving?" | Short cycles, operational reporting |
| **vs same period last year** (YoY) | "Are we growing?" | Anything seasonal |
| **vs target / budget / plan** | "Are we on track?" | The core of management reporting |
| **vs forecast** | "Will we land?" | Mid-period, when plan is already stale |
| **vs peer / benchmark** | "Who is doing better?" | Rep, region, store, team comparisons |
| **vs cumulative** (YTD, MTD, rolling 12) | "How is the year going?" | Smoothing noisy periods |

Two rules govern the choice:

**Use YoY, not MoM, for anything seasonal.** Retail December against November is
not a business signal, it is a calendar signal. If the metric has a weekly or
annual rhythm, compare it to the same point in the previous cycle.

**Use rolling 12 months to see the trend, period-over-period to see the event.**
A rolling 12-month line strips seasonality and shows direction. A monthly bar
chart shows what happened in March. Management packs usually need both.

---

## PERIOD-OVER-PERIOD PATTERNS

### Year over year

The base measure comes first. Every derived measure references it — never
repeat `SUM(Sales[Amount])` inside a derived measure.

**Power BI (DAX)**

```dax
Revenue = SUM ( Sales[Amount] )

Revenue LY =
CALCULATE ( [Revenue], SAMEPERIODLASTYEAR ( 'Date'[Date] ) )

Revenue YoY % =
VAR Curr = [Revenue]
VAR Prior = [Revenue LY]
RETURN
    IF (
        NOT ISBLANK ( Prior ) && Prior <> 0,
        DIVIDE ( Curr - Prior, ABS ( Prior ) )
    )
```

`ABS ( Prior )` in the denominator is deliberate — see
[Variance edge cases](#variance-edge-cases). `DIVIDE` returns blank on a zero
denominator instead of raising an error, and blank is the honest answer.

`SAMEPERIODLASTYEAR` requires a marked date table and a contiguous date range.
If your fiscal year is not January–December, it still works for
month/quarter-level shifts, but **`DATESYTD` does not** — see
[Fiscal calendars](#fiscal-calendars).

**Tableau**

Tableau offers two routes. Prefer the LOD/lookup route over the quick table
calculation, because table calcs depend on what is visible in the view.

```
// Row-level flag approach — robust, works regardless of view layout
Revenue: SUM([Amount])

Revenue LY:
SUM(
  IF DATEDIFF('year', [Order Date], TODAY()) = 1
  THEN [Amount] END
)
```

For a proper same-period alignment driven by the view's date field, use a
table calculation with an explicit compute-along direction:

```
Revenue YoY %:
(SUM([Amount]) - LOOKUP(SUM([Amount]), -12))
/ ABS(LOOKUP(SUM([Amount]), -12))
```

Set **Compute Using → Table (across)** on the monthly date field. The `-12`
offset assumes twelve monthly marks with no gaps — if a month has no data, the
offset silently points at the wrong month. **Densify the view by using the date
dimension's continuous month field, or use the row-level flag approach instead.**

### Month over month

Same structure, one period back.

**Power BI**

```dax
Revenue PM =
CALCULATE ( [Revenue], DATEADD ( 'Date'[Date], -1, MONTH ) )

Revenue MoM % =
DIVIDE ( [Revenue] - [Revenue PM], ABS ( [Revenue PM] ) )
```

`DATEADD` is the general-purpose shifter: `-1, MONTH`, `-1, QUARTER`,
`-7, DAY`. `PARALLELPERIOD` shifts to the *whole* period and is usually not
what you want for a partial current month.

**Tableau**

```
Revenue PM:
LOOKUP(SUM([Amount]), -1)     // Compute Using: Table (across) on Month
```

### Rolling 12 months

**Power BI**

```dax
Revenue R12M =
CALCULATE (
    [Revenue],
    DATESINPERIOD ( 'Date'[Date], MAX ( 'Date'[Date] ), -12, MONTH )
)
```

**Tableau**

```
Revenue R12M:
WINDOW_SUM(SUM([Amount]), -11, 0)   // Compute Using: Month, ascending
```

Note the asymmetry: DAX's `-12, MONTH` from the last date covers twelve months;
Tableau's `WINDOW_SUM(-11, 0)` covers the current mark plus eleven prior — also
twelve. Off-by-one here is a common bug; verify against a hand-summed year.

---

## CUMULATIVE PATTERNS (YTD, MTD, QTD)

**Power BI**

```dax
Revenue YTD  = CALCULATE ( [Revenue], DATESYTD ( 'Date'[Date] ) )
Revenue MTD  = CALCULATE ( [Revenue], DATESMTD ( 'Date'[Date] ) )
Revenue QTD  = CALCULATE ( [Revenue], DATESQTD ( 'Date'[Date] ) )

// Prior-year YTD, for a YTD-vs-YTD comparison
Revenue YTD LY =
CALCULATE ( [Revenue YTD], SAMEPERIODLASTYEAR ( 'Date'[Date] ) )
```

**Tableau**

```
Revenue YTD:
RUNNING_SUM(SUM([Amount]))   // Compute Using: Month, restarting every Year
```

Set the restart via **Compute Using → Advanced**, partitioning on Year and
addressing on Month. Alternatively, filter to `YEAR([Order Date]) = YEAR(TODAY())`
and aggregate — simpler, but then the view cannot show multiple years.

### Fiscal calendars

If the business does not run on a January–December year, `DATESYTD` defaults
are wrong. Pass the fiscal year-end:

```dax
// Fiscal year ending 31 March
Revenue FYTD = CALCULATE ( [Revenue], DATESYTD ( 'Date'[Date], "03-31" ) )
```

In Tableau, set the fiscal year start on the date field
(**right-click the date field → Default Properties → Fiscal Year Start**), or
carry explicit `Fiscal Year` / `Fiscal Month Number` columns in the date
dimension and use those. Carrying the columns is more reliable and portable.

**Always confirm the fiscal calendar with the business before writing a YTD
measure.** A wrong fiscal year-end produces plausible-looking numbers that are
wrong for most of the year — the worst kind of bug.

---

## THE PARTIAL-PERIOD TRAP

This is the most common defect in management reporting, and it is worth the
space.

On the 10th of the month, a tile comparing "this month" to "last month" is
comparing 10 days to 31 days. It shows a 65% collapse. The report is wrong, the
reader panics, and the analyst spends a morning explaining the calendar.

There are three legitimate answers. Choose one and label it.

### Option A — Compare like to like (usually correct)

Compare month-to-date against the same number of days in the prior period.

**Power BI**

```dax
Revenue PM (same days) =
VAR LastDate     = MAX ( 'Date'[Date] )
VAR DayOfMonth   = DAY ( LastDate )
VAR PriorMonthEnd =
    EOMONTH ( LastDate, -1 )
VAR PriorStart   = EOMONTH ( LastDate, -2 ) + 1
VAR PriorCutoff  =
    -- clamp to the prior month's length (e.g. 31 Mar -> 28/29 Feb)
    MIN ( PriorStart + DayOfMonth - 1, PriorMonthEnd )
RETURN
    CALCULATE (
        [Revenue],
        REMOVEFILTERS ( 'Date' ),
        'Date'[Date] >= PriorStart,
        'Date'[Date] <= PriorCutoff
    )
```

The `MIN (..., PriorMonthEnd)` clamp matters: on 31 March, day-of-month 31 does
not exist in February. Without the clamp the filter silently returns the whole
of February anyway — right answer by accident — but on a 30-day prior month it
would overrun into the next month if written with a raw date offset.

The same clamp logic applies to the year-over-year case, where 29 February
exists only in leap years.

**Tableau**

```
Revenue PM (same days):
SUM(
  IF DATETRUNC('month', [Order Date]) = DATEADD('month', -1, DATETRUNC('month', TODAY()))
     AND DAY([Order Date]) <= DAY(TODAY())
  THEN [Amount] END
)
```

Replace `TODAY()` with a `{ MAX([Order Date]) }` LOD if the data lags real
time — which it almost always does:

```
Data Cutoff: { MAX([Order Date]) }
```

Using `TODAY()` when the warehouse loads two days late understates the current
period by two days, every day.

### Option B — Compare full prior periods only

Exclude the incomplete current period from the comparison entirely. Show
"February vs January" until March closes. Honest, and the standard choice for a
monthly close pack.

### Option C — Show both, labelled

Show MTD alongside the full prior month, but label the columns
`MTD (10 days)` and `Jan (full)`. Acceptable only if the labels are unmissable.

**What is never acceptable** is an unlabelled comparison of unequal periods.

### Related: the incomplete-last-bar problem

A monthly trend line whose final point is a partial month always plummets.
Either exclude the current period from the trend, or render it in a distinct
style (dashed line, hollow bar) with a note. Never let a partial bar sit in a
series of complete ones looking identical.

---

## VARIANCE AGAINST TARGET

Budget-vs-actual is the spine of management reporting. Two measures, both
needed: absolute variance for materiality, percentage variance for scale.

**Power BI**

```dax
Budget          = SUM ( Budget[Amount] )
Variance        = [Revenue] - [Budget]
Variance %      = DIVIDE ( [Variance], ABS ( [Budget] ) )
Attainment %    = DIVIDE ( [Revenue], [Budget] )
```

`Attainment %` (actual ÷ target, where 100% = on plan) is often more readable on
a tile than `Variance %`. Pick one per report and use it everywhere — mixing
"we are at 94%" and "we are −6%" on the same page makes readers do arithmetic.

**Tableau**

```
Budget:       SUM([Budget Amount])
Variance:     SUM([Amount]) - SUM([Budget Amount])
Variance %:   (SUM([Amount]) - SUM([Budget Amount])) / ABS(SUM([Budget Amount]))
```

Budget data usually arrives at a coarser grain than actuals — monthly budget
against daily actuals, or regional budget against per-rep actuals. **Do not join
budget to fact at the fact's grain**; relate both to shared dimensions
(date, region) at the grain each one has. Handling this correctly is a modelling
task, not a calculation one — see [data-model.md](data-model.md).

### Pace / prorated target

Comparing MTD actuals to a full-month target has the same partial-period defect.
Prorate:

```dax
Target Pace =
VAR DaysElapsed = COUNTROWS ( DATESMTD ( 'Date'[Date] ) )
VAR DaysInMonth = DAY ( EOMONTH ( MAX ( 'Date'[Date] ), 0 ) )
RETURN [Budget] * DIVIDE ( DaysElapsed, DaysInMonth )
```

Straight-line proration assumes even distribution across the month. For a
business with month-end spikes, prorate on the prior year's daily curve instead
of on day count.

---

## VARIANCE EDGE CASES

Every one of these has shipped to production somewhere and embarrassed someone.

| Case | Naive result | Correct handling |
|---|---|---|
| Prior period = 0 | Divide-by-zero error or ∞ | Show blank or "n/a"; never 0%, never 100% |
| Prior period is blank (no data) | Treated as 0 → +∞% growth | Blank, not zero. `DIVIDE` returns blank by default |
| Prior is negative, current positive (loss → profit) | `(10 − −5)/−5 = −300%` — sign inverted | Use `ABS(prior)` in the denominator → +300% |
| Both negative, loss shrinking | Sign confusion | `ABS` denominator; label as "loss reduced by X" |
| Very small prior period | +4,000% swamps the chart | Cap the axis, or show absolute variance instead |
| Comparing two percentages | "Margin rose 5%" — from 20% to 21%? or to 25%? | Use **percentage points (pp)**: 20% → 25% is +5pp |
| Cost, error rate, time-to-resolve | Negative variance shown red | **Polarity**: lower is better → negative is green |
| First period in the dataset | YoY renders as 0 or −100% | Blank. There is no prior year |

Two of these deserve their own note.

### `ABS` in the denominator

`DIVIDE ( Curr - Prior, Prior )` breaks when `Prior` is negative: a loss of 5
improving to a profit of 10 gives −300%, implying a collapse. Using
`ABS ( Prior )` gives +300%, which reads correctly. Make this the house rule for
every percentage-change measure — profit, margin, and net income all go negative.

### Percent vs percentage point

If the metric is itself a percentage, its change is measured in **percentage
points**, never percent. Write `+5pp`, not `+5%`. Conversion rate moving from
20% to 25% is +5pp *and* +25% relative — both are true and they mean different
things, so state which one you are showing. This distinction is enforced in
[number-formatting.md](number-formatting.md).

### Polarity, concretely

```dax
// Polarity-aware variance: +1 where higher is better, -1 where lower is better
Variance (favourable) = [Variance] * SELECTEDVALUE ( Metric[Polarity], 1 )
```

Or carry a `Polarity` column in a metric dimension and drive conditional
formatting from `Variance (favourable)` rather than from `Variance`. A cost
centre R$ 50k under budget must render green.

---

## CONTRIBUTION TO CHANGE

When a total moves, management's next question is always *what moved it*.

### Price–volume–mix

Decomposes a revenue change into three drivers:

- **Volume effect** — `(Qty₁ − Qty₀) × Price₀`
- **Price effect** — `(Price₁ − Price₀) × Qty₁`
- **Mix effect** — the residual, from the shift in product/customer composition

```dax
Volume Effect = ( [Qty] - [Qty LY] ) * [Avg Price LY]
Price Effect  = ( [Avg Price] - [Avg Price LY] ) * [Qty]
Mix Effect    = [Revenue] - [Revenue LY] - [Volume Effect] - [Price Effect]
```

The decomposition is not unique — the order in which you attribute price and
volume changes the split. Pick one convention, document it in the metric
definition, and never change it mid-year. Feed the result into a **waterfall
chart**: opening balance, one bar per driver, closing balance. See
[visual-design.md](visual-design.md).

### Top contributors

For "which accounts drove the decline", rank by *change*, not by *level*:

```dax
Revenue Change = [Revenue] - [Revenue LY]
```

Sort ascending to surface the biggest declines. Ranking by current revenue
answers a different question and hides the small account that collapsed.

---

## FORWARD-LOOKING METRICS

| Metric | Formula | Caveat |
|---|---|---|
| **Run rate** | MTD ÷ days elapsed × days in period | Assumes flat distribution — wrong for month-end-loaded businesses |
| **Forecast to year end** | YTD + (run rate × remaining periods) | Naive; state that it is naive |
| **CAGR** | `(End / Start) ^ (1 / Years) − 1` | Meaningless if Start ≤ 0 |
| **Index to baseline** | `Value / Value_base × 100` | Good for comparing series with different units |

```dax
Run Rate =
VAR DaysElapsed = COUNTROWS ( DATESMTD ( 'Date'[Date] ) )
VAR DaysInMonth = DAY ( EOMONTH ( MAX ( 'Date'[Date] ), 0 ) )
RETURN DIVIDE ( [Revenue MTD], DaysElapsed ) * DaysInMonth
```

Label projections unambiguously. A forecast rendered in the same style as an
actual will be quoted as an actual within a week. Dashed lines, lighter fill,
and an explicit "forecast" label are the minimum.

---

## SIGNAL OR NOISE?

Management reports invite over-reaction to normal variation. A metric that
bounces ±8% month to month has not "dropped sharply" when it falls 6%.

Before flagging a movement, ask whether it is outside the metric's normal range.
The cheap version: show a rolling mean and ±2 standard deviations behind the
line, and only annotate points outside the band.

```dax
Rolling Mean 12M =
AVERAGEX (
    DATESINPERIOD ( 'Date'[Date], MAX ( 'Date'[Date] ), -12, MONTH ),
    [Revenue]
)
```

The discipline matters more than the technique: **do not write commentary on
every movement.** Reserve annotation for changes that are large relative to the
metric's own history, or that cross a decision threshold. A pack that flags
everything trains readers to ignore the flags.

---

## PATTERN SELECTION TABLE

| The reader asks | Comparison | Measure | Exhibit |
|---|---|---|---|
| "Are we hitting plan?" | vs target | Attainment %, Variance | Bullet chart, KPI tile |
| "Are we growing?" | YoY | Revenue YoY % | Bar with prior-year reference line |
| "What changed this month?" | MoM + drivers | Revenue Change by driver | Waterfall |
| "What's the trend?" | Rolling 12M | Revenue R12M | Line |
| "How is the year tracking?" | YTD vs YTD LY | Revenue YTD, YTD LY | Cumulative line, two series |
| "Who is over/under?" | vs peer or vs target | Variance by entity | Sorted bar, ranked by variance |
| "Will we land the year?" | Forecast | YTD + run rate | Line, forecast segment dashed |
| "Is this normal?" | vs own history | Value vs rolling mean ±2σ | Line with shaded band |
| "Where did the money go?" | Contribution | Price / Volume / Mix | Waterfall |
| "Is this month bad, or just short?" | Like-for-like | MTD vs prior MTD | Paired bar, labelled |

---

## CHECKLIST FOR ANY COMPARISON MEASURE

- [ ] Base measure exists and is referenced, not duplicated.
- [ ] The date dimension is marked/related, complete, and gap-free.
- [ ] The fiscal calendar is confirmed and applied.
- [ ] Partial current periods are handled or explicitly labelled.
- [ ] The denominator uses `ABS` so negative priors do not invert the sign.
- [ ] Divide-by-zero returns blank, not zero and not an error.
- [ ] The first period correctly shows blank, not −100%.
- [ ] Polarity is applied — for cost metrics, down is green.
- [ ] Percentage-point changes are labelled `pp`, not `%`.
- [ ] Forecast and projected values are visually distinct from actuals.
- [ ] The measure has been verified against a hand-calculated slice.

---

*See also: [data-model.md](data-model.md) for the date dimension ·
[calculations-powerbi.md](calculations-powerbi.md) and
[calculations-tableau.md](calculations-tableau.md) for the underlying evaluation
rules · [number-formatting.md](number-formatting.md) for variance display ·
[visual-design.md](visual-design.md) for the exhibits named above.*

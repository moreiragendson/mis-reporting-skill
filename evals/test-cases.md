# Evaluation Test Cases

Prompts for checking that the skill activates, routes to the right reference
file, and applies its non-negotiable rules. Each case states the prompt, what
the response must contain, and what would count as a failure.

Cases marked **[outline]** target reference files that are not yet written —
they are expected to route correctly but may not yet return full detail.

---

## Activation

### A1 — Explicit invocation
**Prompt:** `/mis-report build a YoY revenue measure`
**Pass:** Skill loads; asks which tool before writing a formula.
**Fail:** Writes DAX without establishing the tool.

### A2 — Implicit activation
**Prompt:** "My dashboard shows revenue down 65% this month, is that right?"
**Pass:** Skill activates; raises the partial-period trap.
**Fail:** Accepts the number at face value.

### A3 — Non-trigger
**Prompt:** "Write a Python script to parse a CSV."
**Pass:** Skill does not activate.

---

## Routing

| # | Prompt | Must route to |
|---|---|---|
| R1 | "Which chart for actual vs target by region?" | `visual-design.md` → bullet chart |
| R2 | "My Tableau totals don't match the ERP" | `performance-governance.md` diagnostic |
| R3 | "How do I show R$ 4,238,914 on an exec tile?" | `number-formatting.md` |
| R4 | "My FIXED LOD ignores my filter" | `calculations-tableau.md` → context filter |
| R5 | "Managers should only see their own team" | `filters-interactivity.md` → RLS |
| R6 | "Audit this dashboard" | `review-checklist.md`, correctness first |
| R7 | "The report takes 40 seconds to load" | `performance-governance.md`, measure first |
| R8 | "Design a monthly management pack" | `report-architecture.md`, tiers |

---

## Correctness rules

### C1 — Fiscal calendar
**Prompt:** "Build a YTD sales measure in Power BI. Our fiscal year ends 31 March."
**Pass:** Uses `DATESYTD ( 'Date'[Date], "03-31" )`.
**Fail:** Plain `DATESYTD` or `TOTALYTD` with a December default.

### C2 — Negative prior period
**Prompt:** "YoY % where last year was a loss of R$ 5k and this year a profit of R$ 10k."
**Pass:** Uses `ABS` in the denominator; result +300%, explained.
**Fail:** −300%, or no mention of the sign inversion.

### C3 — Partial period
**Prompt:** "Compare this month to last month. Today is the 10th."
**Pass:** Offers like-for-like day-clamped comparison, or explicit labelling.
**Fail:** Plain full-month `DATEADD` comparison with no warning.

### C4 — Polarity
**Prompt:** "Format the budget variance. This is an IT cost centre, we're R$ 50k under budget."
**Pass:** Renders favourable (green); explains polarity.
**Fail:** Red because the number is negative.

### C5 — Percentage points
**Prompt:** "Conversion rate went from 20% to 25%. How do I label the change?"
**Pass:** `+5pp`; notes +25% relative is a different statement.
**Fail:** Labels it `+5%` unqualified.

### C6 — Blank vs zero
**Prompt:** "YoY shows blank for 2022, our first year. Should I make it 0?"
**Pass:** No — blank is correct; zero fabricates a data point.
**Fail:** Suggests `COALESCE(..., 0)` for cosmetics.

### C7 — Date dimension
**Prompt:** "Time intelligence returns wrong numbers."
**Pass:** Checks for a marked, gap-free, dedicated date table first.
**Fail:** Debugs the formula without checking the model.

### C8 — Data cutoff vs TODAY()
**Prompt:** "Tableau MTD using TODAY(), but our warehouse loads two days late."
**Pass:** Recommends `{ MAX([Order Date]) }` instead of `TODAY()`.

---

## Design rules

### D1 — Colour only
**Prompt:** "I'll show good/bad with red and green."
**Pass:** Flags colour-vision deficiency; pairs colour with arrows or labels.

### D2 — Dual axis
**Prompt:** "Put revenue and margin % on the same chart with two axes."
**Pass:** Pushes back; offers indexed series or stacked panels.

### D3 — Truncated axis
**Prompt:** "Start the bar chart y-axis at 80 so the difference is visible."
**Pass:** Refuses for bars (length encoding); offers a variance chart instead.

### D4 — Locale **[outline]**
**Prompt:** "Report for a Brazilian audience showing 1,234.56."
**Pass:** Raises pt-BR separators (`1.234,56`) and pinning the locale.

---

## Anti-patterns the skill must resist

| # | Prompt | Expected pushback |
|---|---|---|
| X1 | "Just make a pie chart of the 12 regions" | Sorted bar instead |
| X2 | "Build a sales dashboard" (no brief) | Asks who reads it and what decision it drives |
| X3 | "Copy this measure and change SUM to AVERAGE" | Base-measure reuse, not duplication |
| X4 | "Hide the visual so they can't see other teams' data" | Not a security control — use RLS |
| X5 | "Round everything to 2 decimals on the exec tile" | False precision; 3 significant digits |

---

## Scoring

Run the suite after any material edit to `SKILL.md`. Routing (R) and
correctness (C) cases are blocking; design (D) and anti-pattern (X) cases are
advisory while reference files remain outlines.

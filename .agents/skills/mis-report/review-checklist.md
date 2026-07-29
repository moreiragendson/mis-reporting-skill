# Report Review and Audit Checklist

> **STATUS: OUTLINE.** Headings are final; prose and rubric text to be written.
> Style template: [comparison-metrics.md](comparison-metrics.md).

Use this when asked to review, audit, or critique an existing dashboard or
report pack. Opening frame to write: **lead with correctness.** A finding that
a number is wrong outranks every design observation. Cosmetic notes come last
and are labelled as cosmetic.

---

## HOW TO RUN A REVIEW

1. Ask what decision the report drives and who reads it — review against its
   purpose, not against a generic ideal.
2. Ask which tool, and get access to the model, not just the screenshots.
3. Score the five dimensions below.
4. Report findings **severity-first**: blocking → significant → minor →
   cosmetic.
5. For each finding: what is wrong, why it matters to the reader, and the fix.

## THE FIVE DIMENSIONS

Each scored 1–5, with written anchors to be drafted for each level.

### 1. Correctness (weight: highest)

- Numbers tie out to the source for at least two periods.
- Grain is declared and totals are not inflated by fan-out.
- Date dimension present, complete, marked; correct date field used.
- Fiscal calendar correct.
- Partial periods handled or labelled.
- Divide-by-zero, blanks, and negative bases handled.
- Non-additive measures correct at totals.
- RLS tested against multiple roles.

### 2. Clarity

- Message-first titles; the reader gets the point in under five seconds.
- Chart types match the questions.
- No dual axes, truncated bar axes, or decorative chart types.
- Number formatting consistent, correct precision, correct locale.
- Colour is meaningful, consistent, and not the sole encoding.
- Commentary present and current.

### 3. Comparability

- Every headline number carries a comparison.
- Comparison type suits the metric (YoY for seasonal, not MoM).
- Polarity correct — cost savings are green.
- Percent vs percentage points distinguished.
- Scales consistent across comparable exhibits.
- Definitions stable over time, or changes announced.

### 4. Performance

- First render and interaction times measured, not guessed.
- Storage mode and model design appropriate to the volume.
- No obviously expensive patterns left in place.
- Acceptable on the slowest expected device and connection.

### 5. Governance

- Metric definitions written, owned, and reachable from the report.
- Built on a certified/published shared dataset where one exists.
- Data-as-of stamp present; refresh scheduled with failure alerting.
- Access model appropriate; version control in place.
- Someone other than the author can maintain it.

## SCORING

Rubric table to write: dimension → weight → score → weighted score, with a
verdict band (ship / fix-then-ship / rebuild) and guidance that **any
correctness score below 3 blocks publication regardless of the total**.

## FINDING TEMPLATE

Template to write:

```
[SEVERITY] Dimension — one-line summary
What: ...
Why it matters: ...
Fix: ...
Reference: <file>.md#<section>
```

## THE TWENTY-QUESTION FAST PASS

A short version to write, for when a full audit is not warranted — the highest-
yield questions, drawn from the pre-publish checklist in [SKILL.md](SKILL.md).

## COMMON FINDINGS

To write, with the reference file for each: partial-period comparison ·
polarity inverted on cost · no data-as-of stamp · pie chart with many slices ·
dual axis · `FIXED` LOD ignoring a filter · measure ignoring a slicer via `ALL` ·
two tiles with the same label and different values · red/green only · one page
serving three audiences · no metric definitions · RLS untested.

---

*See also: [SKILL.md](SKILL.md) ·
[performance-governance.md](performance-governance.md) ·
[comparison-metrics.md](comparison-metrics.md)*

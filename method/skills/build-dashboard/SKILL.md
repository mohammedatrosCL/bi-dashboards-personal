---
description: Step 3 of a new dashboard, when the analyst says "build it", "build the pricing dashboard" or «ابنِ اللوحة». Builds the reports, checks, page and definitions from the approved business rules only, verifies them on the data, and reports in plain words. Also after rules or requirements change.
argument-hint: <dashboard, e.g. pricing>
arguments: [dashboard]
---

# Build the $dashboard dashboard

If the title above shows no dashboard name, use the dashboard the analyst is talking about wherever this
text leaves the name out (a path such as `docs//rules.md` means `docs/<that dashboard>/rules.md`).

This is step 3 of 3. Read `AGENTS.md` first: its rules hold for every file you write. Work on the
dashboard's branch: run `bash <private>/tools/branch.sh $dashboard` first.

Your private repository is the folder three levels above this skill's folder (Claude Code shows the skill's
base directory when it loads); below it is called `<private>`. It holds the analyst's own notes per
dashboard (`<private>/notes/<dashboard>/`) and work history (`<private>/history/`), which never go into the
shared repository.

## 0. Check that you may build

- Read `docs/$dashboard/requirements.md`, `docs/$dashboard/rules.md`, and the private notes in
  `<private>/notes/$dashboard/` if there are any.
- Use only rules marked `approved`, the confirmed rules in `AGENTS.md`, and what the analyst says in this
  conversation. If a card needs a rule that is proposed, rejected or missing, don't build that card: add
  the missing rule to `rules.md` as `proposed`, build the other cards, and list it at the end.
- If no rule is approved yet, stop and say so.
- If the dashboard is already built, this is a change: read what exists and change only what the new or
  changed rules and requirements need.

## 1. Reports in `reports/sql/$dashboard/`

- `corrected/<card>.sql`: one file per card, named after what it shows (snake_case). The first comment
  lines say what it counts and which rules it applies (`-- Rules: $dashboard-02, $dashboard-05`).
- `current/<card>.sql`: when today's dashboard has the card, reproduce today's query exactly, mistakes
  included, and cite the code it copies (`file:line`), so the page can show today's number beside the
  corrected one for the same period.
- Follow `AGENTS.md`: read only; only `:start_date` and `:end_date`; Riyadh day bounds; enums compared as
  text; totals only; soft deletes; counts cast with `::int` and amounts with `::float8`.
- A breakdown (by stage, employee or city) returns one row per group; a single figure returns one row. When
  the page will filter a breakdown, return the "all" rows too (`GROUPING SETS`), so the page never adds up.
- **Values the department may change** (limits, time windows such as 10 minutes, 24 hours or 7 days, the
  days counted in a daily average) are written once, in a named CTE at the top of the file that uses them,
  each beside the rule id that sets it. Return the limits with the result when the page draws them.
- **Levels** (excellent, attention, at risk) are decided in the SQL from those limits and returned as keys
  (`excellent`, `attention`, `at_risk`), so the page only colours what it receives. A value without
  approved limits returns no level.

## 2. Checks in `reports/sql/$dashboard/checks/`

At least one check for each corrected card. A check file returns one row per check with the columns
`key` (kebab-case), `label` (a short Arabic sentence), `expected` and `actual` (numbers), and `passed` (a
boolean) only for checks that are not equalities, such as "no more than"; in a file that mixes both, give
the equality rows `NULL::boolean AS passed`. Good checks: the groups add up to the total; the total matches
a recount written another way (another date logic or join, as in
`reports/sql/checks/independent_counts.sql`); two cards agree over the same rows; no record falls in two
groups; every person has exactly one level per indicator. A check that is true by construction proves
nothing; don't add one.

## 3. Design: what the page shows, and in what order, is your call

The requirements say what the department needs answered, not how to lay it out. Choose the visualizations,
grouping and order that answer the department's questions fastest. You may merge, split, regroup or reorder
what the notes list, as long as every question is answered and every number comes from an approved rule.

- **Order** by what the reader acts on first. Group by audience (for pricing: field pricers, phone sales,
  deals and employees, general indicators); sections or tabs per audience are fine. Within a group, lead
  with who or what needs attention, then the breakdowns, then the detail tables. The checks card goes
  last. The page shows the numbers only: never a note on how or when it was built.
- **Pick the form from the question:**
  - one number: a number tile, with today's number beside it when `current` has the card;
  - a number with limits: the value, its level as a coloured label with its word, and the limits in view
    (a bullet bar with the three zones, or the limits under the value);
  - several people with limits: one table sorted with the worst level first, a level chip per indicator,
    and the limits in the column headers;
  - stages that narrow (created, assigned, with action, paid): a funnel or horizontal bars, each with its
    share of the stage before;
  - parts of a whole (lost reasons): horizontal bars sorted by count, with counts and shares; no pie with
    more than five slices;
  - field against phone: side by side, on the same scale;
  - over time: a line, and only when the period is longer than two weeks.
- An indicator without approved limits shows its number without a level and «لم تُحدد حدود التقييم بعد».
- Levels use one colour family on every page (green, amber, red) and always carry their word, never colour
  alone. Their names come from the approved rules, in one place in the page's code.
- Charts use `chart.js` with `react-chartjs-2`, as NewDashboard does (see
  `refs/NewDashboard/src/app/home/components/charts/`). Right to left: the category axis on the right, the
  value axis reversed so bars grow from the right, and `rtl: true` for legends and tooltips. If the
  packages are missing, ask the analyst to run `npm install chart.js@4.5.0 react-chartjs-2@5.3.0 -w dashboard`.

## 4. Built to change

The analyst will ask for changes in plain words ("put lost reasons first", "show phone sales as a table",
"the excellent limit is now 4%"). Build so each is small:
- One component per card in `dashboard/components/$dashboard/`. The page lists the cards in one place, in
  display order, so moving, adding or removing a card is a one-line change.
- A changed limit or time window is a new approved rule and one line in the CTE that holds it.
- Changes to the design (form, order, grouping, wording) need no rule approval; changes to what a number
  counts do.

## 5. The page: `dashboard/app/$dashboard/page.tsx`

- Load the numbers with `useDashboardReport("$dashboard", start, end)` from
  `dashboard/lib/use-dashboard-report.ts`, and read them with `reportRows`, `reportRow`, `numberAt` and
  `textAt` from `dashboard/lib/dashboard-report.ts`.
- Keep the control panel's look: take the frame of `dashboard/app/page.tsx` (header with the refresh button
  and the Riyadh time of the last update, the notice, `PeriodBar`, the error box, `ChecksCard`) and reuse
  the components in `dashboard/components/`.
- Start on the default period the requirements give (pricing: this month).
- Arabic, right to left, Latin digits, Riyadh time. The page computes nothing: no sums, ratios or
  classifications. A filter only picks among rows the report returns.
- Where `current` has the card, show today's number beside the corrected one with the reason for the
  difference (the rule's "Today's dashboard" line), as the control panel does with `CompareBox`.
- Link the dashboards to each other: if there is no shared navigation yet, add a small one in
  `dashboard/components/` and use it in every page's header.

## 6. Definitions: `docs/$dashboard/definitions.md`

In Arabic, in the shape of `docs/definitions.md`: for each card, what today's dashboard shows, what the
corrected card shows, and its query file. Then the open questions for the department.

## 7. Verify, and fix until it passes

Never weaken a check to make it pass.
- `npm run check`
- `bash scripts/test.sh`
- `bash scripts/report.sh $dashboard <first day of last month> <last day of last month>`, then again for
  this month to date. Every check passes, no card is empty unless it should be, and numbers come as numbers.

If the service does not answer, say so and leave these to the analyst.

## 8. Report to the analyst

Short and in plain words: the cards built, in the order you chose and why; last month's corrected and
today's numbers side by side; the checks and how many pass; the rules each card uses; anything not built
and why; what to look at on http://localhost:3100/$dashboard; and which numbers to compare with the live
app for the same period. Save the dashboard (`bash <private>/tools/save.sh "Build the $dashboard dashboard"`), then
add a line to `<private>/history/build-log.md` and save it (`bash <private>/save.sh "Build log: $dashboard"`).
When the analyst is happy with the page, "send it for review" opens the review request.

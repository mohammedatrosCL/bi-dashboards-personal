---
description: Step 1 of a new dashboard, when the analyst says "propose the rules for pricing" or «اقترح القواعد». Works out the business rules its cards need from the session notes, development's code, the Archive and the data, with evidence, and writes them for the analyst to approve. Builds nothing.
argument-hint: <dashboard, e.g. pricing>
arguments: [dashboard]
---

# Propose the business rules for the $dashboard dashboard

If the title above shows no dashboard name, use the dashboard the analyst is talking about wherever this
text leaves the name out (a path such as `docs//rules.md` means `docs/<that dashboard>/rules.md`).

This is step 1 of 3: the rules, then the analyst's approval, then the build. In this step you write only
under `docs/$dashboard/` and in the analyst's private notes: no report SQL in `reports/`, no page in
`dashboard/`. Work on the dashboard's branch: run `bash <private>/tools/branch.sh $dashboard` first.

Your private repository is the folder three levels above this skill's folder (Claude Code shows the skill's
base directory when it loads); below it is called `<private>`. The analyst's own notes are in
`<private>/notes/<dashboard>/`, and never go into the shared repository.

## 1. Read what is already decided

- `docs/$dashboard/requirements.md`, the department's session. If the file is missing, copy
  `docs/templates/requirements.md` there and stop: ask the analyst to paste the session notes into it. If
  its "Session notes" section is still empty, stop and ask the same.
- `<private>/notes/$dashboard/context.md` and `reading-notes.md` if they exist: where today's dashboard
  lives, what is already known, and what in the session notes is still open.
- The confirmed rules in `AGENTS.md`. They hold here too; don't propose them again.
- `docs/$dashboard/rules.md` if it exists. Never reword an approved rule; to change one, propose a new rule
  that replaces it and say which one.

If `refs/` is missing or empty, stop and tell the analyst that saying "set me up" downloads it.

## 2. List what the cards depend on

From the session notes, list the cards and questions the department asked for. For each card, list every
decision its number depends on: which records count; which date puts a record in the period; how statuses
and stages group; what is left out (test teams, deleted rows, cancelled or lost records); how amounts are
summed (VAT, discounts, payment state); and who a record belongs to (employee, team, city). Each decision
becomes a rule. Each value the department may change later (a limit, a time window, the days counted in an
average) and the names of the levels get a rule of their own, so a change is one approval. How the page
looks is not a rule: leave the design to the build.

## 3. Find the evidence for each decision

- **Today's dashboard**, if the department has one: the page under `refs/NewDashboard/src/app/` and the
  backend query it calls under `refs/booking_api/src/modules/`. Note exactly how it counts today, with
  `file:line`.
- **The code**: the entity (tables are the plural snake_case of the entity name, columns the snake_case of
  the property), its enums, and the services that write the record. Who sets a status, and when, is what
  the status means.
- **The Archive** in `knowledge/archive/catalog/` (`AGENTS.md`, "Knowledge", says which file holds what):
  the table's meaning, grain, time column, personal columns, business rules and status labels. Where the
  Archive and the code disagree, the code wins; say so.
- **Zoho-era rules** in `knowledge/zoho/business_rules.yml`, as hints only.
- **The data**: test each rule with explore questions (`AGENTS.md`, "Asking the data") over full recent
  months, such as last month and the month before. Look at every value a status, stage or type column
  really takes and how often; how many records break the rule (a rule that many records break is not a
  rule yet); and the known traps listed in `AGENTS.md`.

If explore is off or the service does not answer, go on without the data: mark the rule's data evidence
"not checked yet" and leave its question file ready for the analyst to run. Results from the practice
database are not evidence.

## 4. Write `docs/$dashboard/rules.md`

Follow `rules-template.md` in this skill's folder: one section per rule, numbered `$dashboard-01`, `$dashboard-02` and so on,
continuing from the highest number already used and never reusing one. Each rule has: the rule in one or
two plain sentences the department would recognise; status `proposed`; the cards it affects; the evidence
(code `file:line`, the Archive entry, the explore file with the period and the totals it returned);
confidence (high, medium or low, and why); and what it changes compared with today's dashboard, with
numbers where you have them.

End with the questions only the department can answer, in Arabic, each tied to its rule id. Leave out
anything the code or the data can settle.

## 5. Reply, then stop

In a few lines: how many rules; those that change today's numbers most, with the numbers; the
low-confidence ones; and the questions for the department. Save the work (`bash <private>/tools/save.sh "Proposed
rules for $dashboard"`), and the private notes if you changed them (`bash <private>/save.sh "Notes for
$dashboard"`). Then wait: the analyst approves in their own words or with
`/mohammed:approve-rules $dashboard ...`, or tells you what to change.

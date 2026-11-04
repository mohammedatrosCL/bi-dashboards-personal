---
description: Step 2 of a new dashboard. Records the analyst's own decision on proposed business rules in docs/<dashboard>/rules.md, when they approve, change or reject rules in a command or in their own words ("approve all but 4", «اعتمد القواعد عدا الرابعة»). Never approves anything on its own.
argument-hint: <dashboard> <rule ids | all> [changes in plain words]
arguments: [dashboard]
---

# Record the analyst's decision on the $dashboard rules

Your private repository is the folder three levels above this skill's folder (Claude Code shows the skill's
base directory when it loads); below it is called `<private>`. Its `tools/` hold the scripts this skill runs
from inside the BI-Dashboards folder.

The analyst wrote: $ARGUMENTS

If that is empty, the decision is in the analyst's own last message. Record only what the analyst decided
in this conversation, in their words; if they decided nothing, ask, and never approve a rule on your own.
Work on the dashboard's branch: run `bash <private>/tools/branch.sh <dashboard>` first.

The first word is the dashboard. After it come the ids of the rules to approve (for example
`$dashboard-01 $dashboard-04`) or `all` for every proposed rule, and possibly changes or rejections in plain
words.

1. Open `docs/$dashboard/rules.md`.
2. For each rule the analyst named, or each `proposed` rule when they wrote `all`:
   - if the analyst changed it, first rewrite the rule as they said, keeping its id, and add a line under it
     saying what changed;
   - set its status to `approved (<today's date in Riyadh>, analyst)`.
3. A rule the analyst rejected gets the status `rejected (<date>): <their reason>`.
4. Change nothing else. Don't approve a rule the analyst did not name, and don't reword an approved rule
   unless the analyst asked for it in this message. If an id does not exist, say so.
5. If an approved rule holds for CleanOS in general, not just this dashboard, say so and offer to add it to
   the confirmed list in `AGENTS.md`. Add it only if the analyst says yes.
6. Save (`bash <private>/tools/save.sh "Rule decisions for <dashboard>"`), then reply with three short lists
   (approved, still proposed, rejected) and say whether every rule the requested cards need is approved, so
   the dashboard can be built, or which ones are missing.

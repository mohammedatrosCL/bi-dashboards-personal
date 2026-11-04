---
description: Saves the analyst's work and sends it to GitHub when they say "save my work", "save it", «احفظ عملي», or before switching to another dashboard. Saves on the dashboard's own branch, never on main.
---

# Save the work

Your private repository is the folder three levels above this skill's folder (Claude Code shows the skill's
base directory when it loads); below it is called `<private>`. Its `tools/` hold the scripts this skill runs
from inside the BI-Dashboards folder.

1. See what changed: `git status --short`. If nothing did, say so and stop.
2. Be on the right branch. On `main`, run `bash <private>/tools/branch.sh <dashboard>` for the dashboard whose
   folders changed; a change to shared parts only gets a short branch of its own, such as
   `shared-city-filter`. If the changes belong to two dashboards, or to a dashboard other than the current
   branch's, ask the analyst how to split them before saving.
3. Run `bash <private>/tools/save.sh "<what changed, in a few plain words>"`.
4. Tell the analyst in a sentence or two what was saved and that it is on GitHub, on branch `<name>`. If it
   couldn't be sent, say it is saved on the laptop and what to check.

---
description: Sends a dashboard's work (or a shared change) for review into main when the analyst says "send it for review", "it's ready", «أرسلها للمراجعة» - checks it, saves it, and opens GitHub's review request page already filled in.
---

# Send for review

Your private repository is the folder three levels above this skill's folder (Claude Code shows the skill's
base directory when it loads); below it is called `<private>`. Its `tools/` hold the scripts this skill runs
from inside the BI-Dashboards folder.

1. Check the work. For a dashboard: `npm run check`, `bash scripts/test.sh`, and
   `bash scripts/report.sh <dashboard> <first day of last month> <last day of last month>`. Every check must
   pass. If something fails, or the service isn't running so the numbers can't be checked, say so and stop.
2. Bring in the latest main with `bash <private>/tools/update.sh` (save first if needed), then save with
   `bash <private>/tools/save.sh "<what changed>"`.
3. Run `bash <private>/tools/review.sh "<title>" "<description>"`. The title says in plain words what the change
   does. The description, in a few short lines: what changed, the business rules it relies on, how many
   checks pass, and what the reviewer should look at. The script adds the shared rules' checklist under
   it, for the reviewer.
4. Tell the analyst that GitHub opened in the browser with the request filled in, and that they click
   **Create pull request**. The dashboard's owner merges it on GitHub, and the BI lead for shared parts.

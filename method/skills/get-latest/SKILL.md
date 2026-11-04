---
description: Brings in what teammates merged on GitHub and refreshes the packages and development's code, when the analyst says "get the latest", "update", «حدّث» or «هات آخر التحديثات».
---

# Get the latest

Your private repository is the folder three levels above this skill's folder (Claude Code shows the skill's
base directory when it loads); below it is called `<private>`. Its `tools/` hold the scripts this skill runs
from inside the BI-Dashboards folder.

1. If there is unsaved work, save it first (the `save-work` skill).
2. Run `bash <private>/tools/update.sh`.
3. Tell the analyst in plain words what came in (the changes it lists). If the packages changed and the
   servers are running, ask the analyst to stop them (Ctrl+C in their terminal) and start them again.
4. If it stops on a conflict, open each file it lists, explain in plain words what each side changed, and
   settle it with the analyst: by default keep their dashboard's work and take shared parts from `main`.
   Then save with `bash <private>/tools/save.sh "Bring in the latest main"`. To back out instead, run
   `git merge --abort`.

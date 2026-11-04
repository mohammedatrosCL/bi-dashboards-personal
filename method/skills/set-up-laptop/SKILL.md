---
description: Sets up this laptop for the BI dashboards, or checks it still is, when someone says "set me up", "set up my laptop", «جهّز جهازي», or a start or an update fails because something is missing.
---

# Set up this laptop

Your private repository is the folder three levels above this skill's folder (Claude Code shows the skill's
base directory when it loads); below it is called `<private>`. Its `tools/` hold the scripts this skill runs
from inside the BI-Dashboards folder.

1. Run `bash <private>/tools/setup.sh`. Add `practice` only if the person wants the practice database too.
2. Go through what it reports, in plain words, one fix at a time:
   - **Node.js missing or too old:** they install Node.js 22 LTS from https://nodejs.org with the macOS
     installer, then ask you to run setup again. You can't install it for them.
   - **Git doesn't know their name:** ask for their full name and work e-mail, run
     `git config --global user.name "<name>"` and `git config --global user.email "<e-mail>"`, and run setup
     again.
   - **Development's code can't be downloaded:** their GitHub account needs read access to
     `CleanLifeCom/booking_api` and `CleanLifeCom/NewDashboard`; development grants it.
   - **The replica can't be reached:** development must allow the laptop's internet address (setup prints
     it), or give VPN access. Until then the dashboards run on the practice database
     (`bash <private>/tools/setup.sh practice`, then `npm start --prefix dev` and `bash scripts/start-local.sh dev`
     in two terminals, which the person runs).
3. When everything passes, tell them how to start, since the servers are theirs to run: in VS Code,
   **Terminal → Run Task… → "Start dashboards: live data, edit mode"**, then type the replica password in
   that terminal. To only look at the dashboards, they double-click **Start Dashboards.command** in the
   project folder. Then they can talk to you in plain words (`<private>/guide-ar.md` has examples).
4. If `.claude/settings.local.json` in the BI-Dashboards folder doesn't yet have their Claude Code settings
   (`claudeMdExcludes` and the permissions in `<private>/settings/claude-local.json`), ask them to run this in
   the BI-Dashboards folder's terminal themselves, since you don't change your own permissions:
   `node <private>/tools/apply-settings.js`. The settings take effect in their next conversation.

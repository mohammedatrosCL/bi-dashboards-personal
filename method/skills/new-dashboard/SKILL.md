---
description: Starts a new dashboard when the analyst says something like "let's start the B2B dashboard" or «ابدأ لوحة المخزون» - its branch, its folders and documents, and where today's version lives in development's code - then takes the session notes.
argument-hint: <dashboard, e.g. b2b>
---

# Start a new dashboard

The analyst wrote: $ARGUMENTS

Your private repository is the folder three levels above this skill's folder (Claude Code shows the skill's
base directory when it loads); below it is called `<private>`. The analyst's own notes go there, never into
the shared repository.

1. Choose the dashboard's key: short, lower-case English with `-` (for example `b2b`, `inventory`). Ask the
   analyst if it isn't obvious. Check it isn't taken: no `docs/<key>/` and no `reports/sql/<key>/`.
2. Run `bash <private>/tools/update.sh`, then `bash <private>/tools/branch.sh <key>`.
3. Create `docs/<key>/requirements.md` from `docs/templates/requirements.md`. The owner is the person you
   are working with (`git config user.name`) unless they name someone else; fill in the department and the
   session date if you know them.
4. Create `<private>/notes/<key>/context.md` in the shape of `<private>/notes/pricing/context.md`: find today's dashboard for
   this department in `refs/NewDashboard/src/app/` (the page, its hooks, its API routes) and its backend
   in `refs/booking_api/src/modules/` (the controller, the services and their queries, the entities they
   read). Write pointers with `file:line` and the facts to verify; no rules yet.
5. Take the session notes. The analyst can paste them, or give a file's path: for a Word file run
   `textutil -convert txt -stdout "<path>"` (built into macOS); read a PDF directly. Copy them into
   "Session notes" in `docs/<key>/requirements.md` as written, with the department's answers in bold as
   given. List anything still open or unclear in `<private>/notes/<key>/reading-notes.md`, as
   `<private>/notes/pricing/reading-notes.md` does.
6. Save the dashboard with `bash <private>/tools/save.sh "Start the <key> dashboard"` and the notes with
   `bash <private>/save.sh "Notes for <key>"`. Tell the analyst it is started and that the next step is
   proposing the rules ("propose the rules for <key>").

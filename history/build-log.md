# Build log: corrected main dashboard

Times are Riyadh time.

| When | What |
| --- | --- |
| 29 Oct, 17:35 | Request: build the corrected main dashboard for the management demo |
| 29 Oct, 17:45 | AI read the app's code: the home page's three calls, nine queries, twelve tables |
| 29 Oct, 17:50 | Today's logic reproduced and the corrected definitions written as SQL (6 + 6 reports, 7 checks) |
| 29 Oct, 17:56 | Reports service running; every query ran against a practice database with the same tables |
| 29 Oct, 18:01 | Page in the app's look running; all 13 automatic checks passed on practice data |
| 29 Oct, 18:05 | Fixes after looking at the page: badge for "same total, different breakdown", spacing in the territory list, plain-language database errors |
| 29 Oct, 18:15 | Tests (9 passing), AI instructions, start scripts, card definitions and the Sunday checklist |
| 29 Oct, 18:35 | Independent AI review against the app's code: today's numbers reproduced exactly except team requests' time zone; found VAT read from the wrong place, test teams left in tasks and requests, three checks that could never fail |
| 29 Oct, 18:50 | All fixed; 16 checks that can fail, all passing on practice data; packaged |
| 31 Oct | The start script asks for the read-only password; nothing uses Google Cloud any more |
| 31 Oct | First run on the replica: connected read-only in Riyadh time; all 16 checks pass for October; numbers match the live app within the minutes between the two |
| 31 Oct | Edit mode for working with AI in plain words: `start-replica.sh dev`; the page and the service pick up saved changes by themselves, and a build by the AI can no longer break the running page |
| 1 Nov | Run on the replica, compare with the live app, fix what real data shows |
| 2 Nov | Review with operations in their session |
| 5 Nov | Demo to management |
| 2 Nov | v0.4, Claude Code setup: a new dashboard in three steps (proposed business rules with evidence, the analyst approves, then the build); explore questions to the replica in edit mode, totals only; a general route for every new dashboard; pricing first |
| 3 Nov | v0.4.1: the pricing session notes in `docs/pricing/requirements.md`; Claude Code chooses the visualizations and the order of the cards; charts with chart.js as in NewDashboard; limits and time windows written once, so changes stay small |
| 3 Nov | The kit moves to the company repository `CleanLifeCom/BI-Dashboards`; the Archive and the Zoho-era rules in `knowledge/`; organized by dashboard, with an owner per dashboard |
| 3 Nov | v0.5: set up any Mac in one step (`scripts/setup.sh`, Setup.command, or "set me up"); start from a VS Code task or Start Dashboards.command; plain-language skills for a new dashboard, saving, getting the latest and sending for review, with a branch per dashboard; an Arabic guide (`docs/guide-ar.md`) |
| 3 Nov | Pricing dashboard built from the analyst's approved rules (pricing-01 to pricing-42; pricing-42 found during the build and approved by the analyst): 7 corrected reports, 4 of today's dashboard reproduced, 12 checks in 6 files, all passing for October and November to date on the replica; page at /pricing with links between the dashboards |

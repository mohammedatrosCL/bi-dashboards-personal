---
description: Runs a dashboard's numbers and checks on the running reports service for a period and explains any failure. Use it when the analyst asks whether a dashboard's numbers are right.
argument-hint: <dashboard> [start end]
arguments: [dashboard]
---

# Check the $dashboard dashboard

The analyst wrote: $ARGUMENTS

1. The dates after the dashboard name are the period (`YYYY-MM-DD`). With no dates, check last month and
   this month to date, in Riyadh time.
2. For each period run `bash scripts/report.sh $dashboard <start> <end>`. For the control panel (`home`) run
   `bash scripts/checks.sh <start> <end>` instead.
3. Report where the data came from (replica or practice database) and the checks. For each failed check,
   read the check and the reports it compares, find the cause (ask the data with explore questions when
   needed), and propose a fix. Change no files unless the analyst asks.

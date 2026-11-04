---
description: Answers a question about CleanOS data (how many, how much, which statuses exist, whether a rule holds) with a totals-only explore question on the replica, and says exactly how the number was counted.
argument-hint: <question in plain words>
---

# Answer from the data

Question: $ARGUMENTS

1. Pick the folder the question belongs to: the dashboard it is about (`pricing`, `home`, ...) or `general`.
2. Find the tables, columns and rules: the confirmed rules in `AGENTS.md`, the dashboard's agreed rules in
   `docs/<folder>/`, the code in `refs/booking_api` and the Archive in `knowledge/archive/catalog/`.
3. Write `docs/<folder>/explore/<short_name>.sql` as `AGENTS.md` ("Asking the data") says, and run
   `bash scripts/explore.sh <folder> <short_name> <start> <end>`. If the analyst gave no period, use last
   month and say so.
4. Answer in two or three sentences: the number, the period, where the data came from, and exactly what was
   counted (filters and rules). Say so if the answer rests on a rule that is neither confirmed nor agreed.

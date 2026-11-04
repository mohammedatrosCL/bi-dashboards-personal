# My way of building dashboards

A Claude Code plugin that only I turn on. The rules every dashboard meets are in the shared repository's
`AGENTS.md`, and they hold here too.

Each dashboard goes through three steps after its session:

| Step | Say, for example | Skill | What happens |
| --- | --- | --- | --- |
| Start | "let's start the B2B dashboard", «ابدأ لوحة بي تو بي» | `new-dashboard` | Its branch and `requirements.md` with the session notes in the shared repository; my notes on today's version (`notes/<dashboard>/context.md`) and what is still open (`reading-notes.md`) here |
| 1 | "propose the rules for b2b", «اقترح القواعد» | `propose-rules` | The business rules the cards need, with evidence from the code, the Archive and the data, in `docs/<dashboard>/rules.md` as `proposed`. Builds nothing |
| 2 | "approve all but 4", «اعتمد القواعد عدا الرابعة» | `approve-rules` | Records my own decision; Claude Code never approves a rule |
| 3 | "build it", «ابنِ اللوحة» | `build-dashboard` | Reports, checks, page and Arabic definitions from approved rules only, verified on the data; a line in `history/build-log.md` here |

Also part of this way:

- Claude Code chooses the charts, the grouping and the order of the cards. Design changes need no approval.
- A change to what a number counts, such as a limit or a time window, is a new rule to approve. Each such
  value is written once in its SQL file.
- Where the department has a dashboard today, its numbers are reproduced in `current/` and shown beside the
  corrected ones, with the reason for each difference.
- `rules.md` follows `skills/propose-rules/rules-template.md`: each rule with its evidence, confidence and
  status.
- Pages show the numbers only; how and when something was built stays in `history/` here.

Slash commands carry the plugin's name, for example `/mohammed:propose-rules b2b`. Plain words work too.

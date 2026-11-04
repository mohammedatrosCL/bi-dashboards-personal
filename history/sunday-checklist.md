# Sunday 1 November: from practice data to the real replica

Goal: by Sunday evening the dashboard runs on the replica, every automatic check passes, and the
"today's dashboard" numbers match what the live app shows for the same period. Operations sees it on
Monday 2 November; management on Thursday 5 November.

## 0. Before Sunday (5 minutes, any day)

Check that your laptop can reach the replica with the read-only login. The first line asks for the
password without showing it:

```bash
read -r -s -p "Password: " PGPASSWORD && echo && export PGPASSWORD
psql "host=8.213.126.255 port=5432 dbname=cleanOsV2 user=read_only sslmode=require connect_timeout=10" -c "select now(), pg_is_in_recovery();"
```

It should print the time and `t`. If it times out, ask development on Sunday morning to allow your
address on the replica (or give you the VPN early).

## 1. Install and start (once)

Needs Node.js 22 or newer (`node --version`).

```bash
cd cleanos-bi-dashboards
npm install
bash scripts/start-replica.sh
```

If you have the Alibaba CA file, put it at `certs/ApsaraDB-CA-Chain.pem` first; the script then verifies
the server's certificate. Without it the connection is still encrypted.

Open http://localhost:3100.

## 2. Run the checks (second terminal)

```bash
cd cleanos-bi-dashboards
bash scripts/checks.sh 2026-10-01 2026-10-31
bash scripts/checks.sh 2026-11-01 2026-11-01
REPORTS_URL=http://127.0.0.1:4100 npm test -w reports
```

What to read in the output:

| Check | What a good result looks like | If not |
| --- | --- | --- |
| `connection` | `is_replica: true`, `read_only: on`, and note `session_timezone` | today's request numbers are reproduced in Riyadh time, as the app's code says its sessions run; if the replica shows another zone, ask development which zone the app's own sessions use |
| automatic checks | every line `PASS` (16 checks) | the failing line names the card; ask the AI to fix that query |
| `vat-from-zoho` | passes: most invoices carry Zoho's VAT | Zoho's VAT is stored somewhere else; the VAT figure is an estimate until fixed |
| `status_values` | every status and work type is one the rules know | a new value means a rule to add |
| `team_rules` | the `test` list holds only test teams; the `pricing` list only S- teams | correct the name rule |
| `follow_up_cannot_complete` | terminated follow-ups are a small share | if large, confirm the rule with operations |
| `lead_team_consistency` | `lead_differs_from_team_list` is small | if large, tell development |
| `invoice_vat` | most invoices have Zoho VAT; the estimate is close to Zoho's | if far apart, VAT needs another source |
| `team_rules` for tasks | test-team requests and tasks are a small share | if a real team is caught, correct the name rule |

## 3. Compare with the live app

For **yesterday** and for **this month**, open the current home dashboard in the app and note its
numbers. With "المقارنة مع اللوحة الحالية" ticked, each card's grey box must show the same numbers as
the live app. If one differs, the reproduction in `reports/sql/home/current/` needs a fix, not the
corrected number. Use the month for team requests: on a single day both show 0, so only a longer period
tests the reproduction.

## 4. Record the build

Fill in `dashboard/lib/build-note.ts` (`buildTime`, `verifiedOn`) with the real times, and keep
`docs/build-log.md` up to date. Management will ask how long it took.

## If something goes wrong

- The page says the service does not answer: the reports terminal shows why. A database message there
  in plain words names the problem (no network, login refused, query too slow).
- Port in use: another copy is running; close its terminal.
- "password authentication failed": the password was mistyped; start again and it asks once more.

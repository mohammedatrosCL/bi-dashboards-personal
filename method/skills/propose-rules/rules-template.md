# Business rules: <dashboard>

Each rule says how the dashboard counts something. Claude Code proposes rules with their evidence; only the
analyst approves them; the build uses approved rules only. A status is `proposed`,
`approved (<date>, analyst)` or `rejected (<date>): <reason>`.

## <dashboard>-01 · <short name>

- **Rule:** <one or two plain sentences the department would recognise>
- **Status:** proposed
- **Cards:** <the cards that depend on it>
- **Evidence:**
  - Code: `refs/booking_api/src/...:<line>`: <what it shows>
  - Archive: `<file or table entry>`: <what it says>
  - Data: `docs/<dashboard>/explore/<name>.sql`, <period>, replica: <the totals it returned>
- **Confidence:** <high, medium or low>, because <reason>
- **Today's dashboard:** <how today's dashboard does it, and what changes, with numbers where known>

## أسئلة للقسم

1. (`<dashboard>-NN`) <سؤال لا تجيب عنه البيانات ولا الكود>

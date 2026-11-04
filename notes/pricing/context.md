# Pricing dashboard: starting points

Written by BI on 2 Nov 2026, before step 1. These are places to look and things to verify, not approved
rules.

## Today's pricing dashboard

- **Page:** `refs/NewDashboard/src/app/(marketplaces)/pricing/home/`: `components/body/PricingHomeDashboard.tsx`
  and the admin cards beside it, `hooks/usePricingHomeDashboard.ts`, `hooks/useEmployeePerformance.ts`,
  `lib/dashboard-data.ts`, `lib/employee-performance.ts`, `lib/assignment-performance.ts`,
  `constants/dashboard.ts`.
- **Its API routes:** `refs/NewDashboard/src/app/api/marketplaces/pricing/pricing-dashboard/` (`overview`,
  `employee-performance`, `assignment-performance`, `my-overview`), passed on by `_lib/pricing-dashboard-proxy.ts`.
- **Backend:** `refs/booking_api/src/modules/pricing-system/pricing-dashboard/`: the controller's four
  routes, `services/pricing-dashboard.service.ts` (overview, employee performance, an employee's own
  overview), `services/assignment-performance.service.ts`, `helpers/resolve-ksa-date-range.helper.ts` and
  `helpers/build-assignment-performance-metrics.helper.ts`.
- **The records behind it:** `refs/booking_api/src/modules/pricing-system/`: `deals`, `deal-stages`,
  `deal-stage-history`, `deal-assignments`, `deal-assignment-cycles`, `deal-assignment-types`, `deal-actions`,
  `deal-payment`, `quotations`, and the enums in `enums/` and `pricing-enums/`.

## What we already know (verify each before relying on it)

- **Period:** today's overview filters deals on `deal.date`, from the start of the first day to the end of
  the last day in Riyadh time (`applyDateFilter`). Which event `deal.date` records is worth confirming.
- **Deals at risk:** today's card counts deals whose status is `crucial` (`getDealsAtRisk`). The 29 Oct
  review found 3,405 such deals (7.1M SAR), of which at most 755 are really at risk: the count includes deals
  that are already lost.
- **Employee wins** are matched by the text of `deal_payment.createdName` against the employee's name, with
  the payment status paid or successful (`getEmployeeWinStats`). A name match is fragile; check how many
  payments match no employee.
- **Employee performance:** the pricing department measures employees by their assignments and by whether
  the employee took an action in each one, so counting assignments is the intended basis (the analyst,
  31 Oct).
- **Employee names:** an employee performance card needs them, and today's dashboard shows them, but
  `AGENTS.md` rule 5 allows team names only. Propose a rule for the analyst to decide.
- **Pricing visits** (appointments whose lead team's name starts with `S-`) are already a confirmed rule in
  `AGENTS.md`, used by the control panel.

## Cards planned for the first version (the plan for management)

الصفقات الجديدة · التوزيع حسب المرحلة · المعرّضة للخطر فعلًا · التحصيل · أداء الموظفين: الإسنادات، وهل
اتخذ الموظف إجراءً فيها. The session notes in `requirements.md` decide; this list is only what the plan
expected.

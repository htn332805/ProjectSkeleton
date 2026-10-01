# TECHNICAL_DEBT_MANAGEMENT
Debt register with impact/effort/priority.
> How this project identifies, records, prioritizes, and pays down technical debt.
>
> Goal: keep the codebase easy to change while balancing delivery needs.

---

## 1) Definition

Technical debt is any design/implementation shortcut that:
- increases the cost of future change, or
- increases reliability/security/performance risk, or
- reduces clarity/testability.

Debt is not inherently “bad,” but it must be visible and managed.

---

## 2) Debt categories

- Code debt: complexity, duplication, poor boundaries.
- Test debt: missing/slow/flaky tests.
- Architecture debt: layering violations, coupling.
- Documentation debt: outdated or missing docs.
- Operational debt: missing observability/runbooks.
- Security debt: weak controls, unmanaged dependencies.

---

## 3) Where debt is tracked

Choose the system(s) used in this repo:
- GitHub Issues (preferred)
- Project board
- A backlog file: `/Future_or_potential_improvements/TECHNICAL_DEBT_BACKLOG.md`

Rule: debt must have an owner and acceptance criteria.

---

## 4) Debt item template

Copy/paste when logging debt:

- Title:
- Category: (code/test/arch/docs/ops/security)
- Location (module/path):
- Symptom:
- Root cause (hypothesis):
- Why it matters (impact):
- Risk level: (low/medium/high)
- Proposed approach:
- Acceptance criteria:
- Evidence/links:
- Owner:

---

## 5) Prioritization rubric

Score 1–5 for each:
- User impact (bugs/incidents avoided)
- Developer impact (time saved, easier changes)
- Risk reduction (security/reliability)
- Effort (inverse: easier = higher score)

Priority guidance:
- High impact + low effort → schedule next
- High risk reduction → schedule soon
- Low impact + high effort → defer

---

## 6) Payment strategies (how we reduce debt)

### 6.1 Opportunistic (boy scout rule)
When touching code, improve small local issues if:
- it is low risk
- it does not expand scope
- it keeps PR reviewable

### 6.2 Planned refactoring
Use when debt is systemic or high-risk.

Links:
- `/Refactoring_Approach/REFACTORING_FRAMEWORK.md`
- `/Refactoring_Approach/INCREMENTAL_REFACTORING_STRATEGY.md`

### 6.3 Dedicated debt sprints (optional)
Use when debt is blocking delivery or causing incidents.

---

## 7) Debt budgets and guardrails

Define how the team prevents uncontrolled debt:
- “No new debt without a ticket.”
- “Refactor-only PRs must have measurable objectives.”
- “Any new public API must include docs + tests.”

---

## 8) Measuring progress

Track at least one of:
- Hotspot churn reduction
- Complexity reduction in critical modules
- Coverage improvement
- Flaky tests reduced
- Incident rate reduction

Link:
- `/Refactoring_Approach/METRICS_AND_SUCCESS_CRITERIA.md`

---

## 9) Review cadence

- Weekly: triage new debt items.
- Monthly: review top 10 debt items.
- Quarterly: reassess architecture hotspots.

---

## 10) Change log

- YYYY-MM-DD — Created/updated technical debt management policy.


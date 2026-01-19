# ARCHITECTURE_DESIGN_CRITERIA
 Scoring rubric for architecture.
 > Detailed scoring criteria for architecture design.
>
> Goal: provide a consistent rubric for evaluating architecture quality with evidence.

---

## 1) How to use this rubric

- Score each criterion from 1–5 using the shared scale in:
  - `/Project_implementation_evaluation/Scoring_criteria/PROJECT_EVALUATION_SCORE.md`
- Provide evidence links for each score.
- If evidence is missing, score conservatively.

---

## 2) Criteria and scoring

### A1) Modularity and boundaries
What to look for:
- Clear component/module responsibilities
- Encapsulation of internals
- Stable public surfaces

Scoring hints:
- 5: Boundaries are explicit; changes are localized.
- 3: Boundaries exist but leak; some cross-cutting edits required.
- 1: No meaningful boundaries; widespread ripple effects.

Evidence examples:
- Architecture diagram
- Module templates
- Dependency graph

Score: 
Evidence:
Notes:

---

### A2) Coupling and dependency direction
What to look for:
- Dependencies flow in the intended direction (layering)
- Minimal circular dependencies
- High-level policy not dependent on low-level details

Scoring hints:
- 5: Dependency rules are enforced; minimal cycles.
- 3: Some coupling hotspots; occasional layering violations.
- 1: Tight coupling dominates; cycles are common.

Score:
Evidence:
Notes:

---

### A3) Cohesion
What to look for:
- Modules grouped by domain/responsibility
- Minimal “god modules”

Scoring hints:
- 5: High cohesion across major modules.
- 3: Mixed responsibilities in a few areas.
- 1: Responsibility is unclear; modules are catch-alls.

Score:
Evidence:
Notes:

---

### A4) Data flow and contract clarity
What to look for:
- Clear data ownership and boundaries
- Explicit schemas/contracts
- Predictable transformation pipelines

Scoring hints:
- 5: Contracts are explicit and validated; flow is documented.
- 3: Contracts exist but enforcement is uneven.
- 1: Implicit data shapes; frequent integration breakages.

Score:
Evidence:
Notes:

---

### A5) Scalability and performance architecture
What to look for:
- Hot paths identified and measured
- Appropriate caching, async work, queueing
- Resource-aware design

Scoring hints:
- 5: Targets met with guardrails; scalable patterns in place.
- 3: Works under normal load; risks under growth.
- 1: Performance/scalability issues frequent and unmanaged.

Score:
Evidence:
Notes:

---

### A6) Reliability and fault tolerance
What to look for:
- Timeouts/retries/idempotency
- Isolation (bulkheads)
- Degradation strategies
- Recovery/runbooks

Scoring hints:
- 5: Failure modes addressed; recovery is tested.
- 3: Some safeguards; recovery is partially manual.
- 1: Failure causes cascading outages; recovery unclear.

Score:
Evidence:
Notes:

---

### A7) Security architecture
What to look for:
- Trust boundaries defined
- AuthN/AuthZ at boundaries
- Secrets management
- Least privilege

Scoring hints:
- 5: Threat model + controls + scanning; risks tracked.
- 3: Basic controls; gaps in validation/supply chain.
- 1: Unclear boundaries; weak access control.

Score:
Evidence:
Notes:

---

### A8) Maintainability and evolvability
What to look for:
- Easy to add features with minimal edits
- Low cognitive load
- Consistent patterns

Scoring hints:
- 5: Change is straightforward; patterns well-established.
- 3: Moderate friction; some hotspots.
- 1: Change is risky; refactors are frequent firefighting.

Score:
Evidence:
Notes:

---

### A9) Observability and operational fit
What to look for:
- Metrics/tracing/logs
- Dashboards/alerts
- Runbooks

Scoring hints:
- 5: Strong observability; issues detected early.
- 3: Basic metrics/logging; gaps in alerts/runbooks.
- 1: Problems detected by users; little telemetry.

Score:
Evidence:
Notes:

---

## 3) Roll-up scoring (optional)

- Architecture score can be the average of A1–A9, or weighted if desired.

| Criterion | Weight (%) | Score |
|---|---:|---:|
| A1 Modularity |  |  |
| A2 Coupling |  |  |
| A3 Cohesion |  |  |
| A4 Data flow/contracts |  |  |
| A5 Scalability/perf |  |  |
| A6 Reliability |  |  |
| A7 Security |  |  |
| A8 Maintainability |  |  |
| A9 Observability |  |  |

---

## 4) Change log

- YYYY-MM-DD — Created/updated architecture design criteria.


# RELIABILITY_CRITERIA
Scoring rubric for reliability.
> Detailed scoring criteria for reliability.
>
> Goal: provide a consistent rubric for evaluating reliability with evidence.

---

## 1) How to use this rubric

- Score each criterion from 1–5 using the shared scale in:
  - `/Project_implementation_evaluation/Scoring_criteria/PROJECT_EVALUATION_SCORE.md`
- Provide evidence links for each score.
- If evidence is missing, score conservatively.

---

## 2) Criteria and scoring

### R1) Reliability goals and SLOs
What to look for:
- SLIs/SLOs defined for critical paths
- Clear availability/error-rate/latency reliability targets

Scoring hints:
- 5: SLOs defined, monitored, and used for decisions.
- 3: Some targets exist but incomplete or not consistently used.
- 1: No explicit goals; success is subjective.

Score:
Evidence:
Notes:

---

### R2) Failure mode awareness
What to look for:
- Failure modes enumerated for key components
- Dependencies and their failure behavior understood

Scoring hints:
- 5: Failure modes are documented with mitigations and tests where feasible.
- 3: Common failures understood; documentation partial.
- 1: Failures discovered only in incidents.

Score:
Evidence:
Notes:

---

### R3) Resilience patterns
What to look for:
- Timeouts
- Retries with backoff + jitter
- Circuit breakers
- Bulkheads/isolation
- Idempotency
- Rate limiting
- Graceful degradation

Scoring hints:
- 5: Patterns are applied consistently; tuned and validated.
- 3: Some patterns exist; gaps or inconsistent tuning.
- 1: Little to no resilience; cascading failures likely.

Score:
Evidence:
Notes:

---

### R4) Observability for reliability
What to look for:
- Metrics and alerts for failures
- Tracing/logs sufficient for diagnosis
- Dashboards for critical paths

Scoring hints:
- 5: Issues detected early; diagnosis is fast; alerting is actionable.
- 3: Basic monitoring exists; gaps in coverage/alert quality.
- 1: Problems detected by users; little telemetry.

Score:
Evidence:
Notes:

---

### R5) Incident response and recoverability
What to look for:
- Runbooks
- On-call/ownership model
- Postmortem process
- MTTR improvements over time

Scoring hints:
- 5: Strong operational process; recovery is repeatable and improving.
- 3: Some runbooks; recovery depends on key individuals.
- 1: Recovery is ad hoc; no learning loop.

Score:
Evidence:
Notes:

---

### R6) Testing for reliability
What to look for:
- Contract/integration tests for critical paths
- Load/soak tests (if relevant)
- Chaos testing (optional)

Scoring hints:
- 5: Reliability is tested regularly; regressions are prevented.
- 3: Some testing exists; gaps in high-risk areas.
- 1: Little reliability testing; regressions common.

Score:
Evidence:
Notes:

---

### R7) Dependency risk management
What to look for:
- External dependency timeouts
- Fallback strategies
- Rate limits and quotas handled
- Third-party outages mitigated

Scoring hints:
- 5: Dependency failures are isolated and mitigated.
- 3: Some safeguards exist; partial isolation.
- 1: Dependency failures cause major outages.

Score:
Evidence:
Notes:

---

## 3) Roll-up scoring (optional)

- Reliability score can be the average of R1–R7, or weighted if desired.

| Criterion | Weight (%) | Score |
|---|---:|---:|
| R1 Goals/SLOs |  |  |
| R2 Failure modes |  |  |
| R3 Resilience patterns |  |  |
| R4 Observability |  |  |
| R5 Incident response |  |  |
| R6 Reliability testing |  |  |
| R7 Dependency risk |  |  |

---

## 4) Change log

- YYYY-MM-DD — Created/updated reliability criteria.


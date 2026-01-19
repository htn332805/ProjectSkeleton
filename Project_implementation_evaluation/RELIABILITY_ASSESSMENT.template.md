# RELIABILITY_ASSESSMENT
Failure testing, resilience posture.
> Evaluation of the system’s reliability characteristics.
>
> Goal: document expected reliability, current risks, evidence, and a practical improvement plan.

---

## 1) Assessment metadata

- Assessment date:
- Assessed by:
- Version/commit:
- Environment(s) assessed (dev/stage/prod):
- Related guidelines:
  - `/Guidelines/RELIABILITY_STANDARDS.md` (if present)
  - `/Guidelines/TESTING_STANDARDS.md`
  - `/Guidelines/SECURITY.md`

---

## 2) Reliability goals (what “reliable” means)

Define the reliability targets/SLOs that matter.

- Availability target (e.g., 99.9%):
- Error rate target:
- Latency reliability (e.g., p95 within target %):
- Recovery targets (RTO/RPO if applicable):

---

## 3) System critical paths

List the flows where reliability matters most.

| Critical path | User impact if broken | Dependencies | Current safeguards | Evidence |
|---|---|---|---|---|
|  |  |  |  |  |

---

## 4) Failure mode analysis

For each major component, list likely failures and mitigations.

Failure mode template:
- Component:
- Failure mode:
- Cause(s):
- Detection:
- Mitigation:
- Recovery/runbook:
- Residual risk:

---

## 5) Resilience patterns in use

Check what applies and provide evidence:
- Timeouts
- Retries with backoff + jitter
- Circuit breakers
- Bulkheads / isolation
- Idempotency
- Rate limiting
- Graceful degradation
- Dead-letter queues (if messaging)

Evidence links:
- Code locations:
- Configs:
- Docs:

---

## 6) Data reliability

- Data validation rules:
- Schema/contract enforcement:
- Exactly-once / at-least-once assumptions:
- Handling duplicates and ordering:

Link: `/Documentations/DATA_MODELS_AND_CONTRACTS.md`.

---

## 7) Observability and incident response

### Monitoring
- Key SLIs tracked:
- Dashboards:
- Alert thresholds:

### Incident response
- On-call model:
- Runbooks:
- Postmortem process:

Link (if applicable): `/Guidelines/OBSERVABILITY.md`.

---

## 8) Evidence (what proves reliability)

- Load/soak tests:
- Chaos testing (if any):
- Incident history summary:
- Automated recovery tests:

---

## 9) Risk register and improvement plan

### 9.1 Risk register
| Risk | Impact | Likelihood | Evidence | Mitigation | Owner | Target date |
|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |

### 9.2 Improvement plan
| Item | Objective | Approach | Expected benefit | Risk | Owner | Target date |
|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |

---

## 10) Scoring (if used)

| Dimension | Score (1–5) | Rationale | Evidence |
|---|---:|---|---|
| Availability |  |  |  |
| Fault tolerance |  |  |  |
| Recoverability |  |  |  |
| Observability |  |  |  |

Link:
- `/Project_implementation_evaluation/Scoring_criteria/PROJECT_EVALUATION_SCORE.md`

---

## 11) Change log

- YYYY-MM-DD — Created/updated reliability assessment.


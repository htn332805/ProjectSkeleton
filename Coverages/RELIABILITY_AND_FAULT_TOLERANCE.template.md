# RELIABILITY_AND_FAULT_TOLERANCE
Failure modes, retries, degradation strategy, recovery.
> Canonical reliability expectations and fault-tolerance behavior.
>
> Goal: predictable behavior under failure, minimal data loss/corruption, and fast recovery.

---

## 1) How to use this document

### Rules
- Every major workflow must define failure behavior.
- External dependency failures must map to canonical error categories.
- Retry behavior must be explicit and safe (idempotent or deduped).

### Traceability
Link reliability requirements to:
- Functional requirements: `/Coverages/FUNCTIONAL_REQUIREMENTS.md`
- Error taxonomy: `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`
- Observability: `/Documentations/OBSERVABILITY_LOGGING_TRACING.md`
- Evaluation: `/Project_implementation_evaluation/RELIABILITY_ASSESSMENT.md`

---

## 2) Reliability goals

- Availability target (optional):
- Error budget (optional):
- Recovery targets:
  - MTTR target:
  - RTO/RPO (if applicable):

---

## 3) Definitions

- **Fault tolerance**: ability to continue operating when failures occur.
- **Graceful degradation**: reduced functionality rather than total failure.
- **Idempotency**: repeated operations produce the same outcome.
- **Retry**: reattempt after a failure (must avoid making things worse).

---

## 4) Failure mode catalog

> Identify what can go wrong.

| Failure mode | Example | Likely cause | Detection signal | Expected behavior |
|---|---|---|---|---|
| External timeout | API call hangs | Provider latency | timeout counter | retry/backoff or degrade |
| Rate limit | 429 responses | quotas | rate_limit metric | backoff + retry |
| Partial failure | step 2 fails | network | error logs | rollback or compensation |
| Data corruption risk | invalid schema | contract drift | validation errors | reject + alert |

---

## 5) Retry and backoff policy

### Global retry rules
- Retryable categories:
  - `TimeoutError`
  - `RateLimitError`
  - `ExternalDependencyError` (sometimes)

- Non-retryable categories:
  - `ValidationError`
  - `UnauthorizedError`/`ForbiddenError`
  - `InvariantViolationError`

### Backoff strategy
- Exponential backoff?
- Jitter?
- Max attempts?
- Max total time?

### Idempotency requirements
- Which operations must be idempotent:
- Idempotency keys/dedup rules:

---

## 6) Circuit breakers and timeouts

### Timeouts
- Default timeouts:
- Per-integration overrides:

### Circuit breaker policy
- Open conditions:
- Half-open test strategy:
- Close conditions:

Link to: `/Coverages/INTEGRATION_SCENARIOS.md`.

---

## 7) Graceful degradation rules

Define what should happen when dependencies fail.

- Degraded mode behavior:
- Fallback data sources:
- User-visible messaging:
- Feature flags (if used):

---

## 8) Data consistency and recovery

### Consistency model
- Strong consistency vs eventual consistency:

### Recovery strategies
- Replay events:
- Rebuild state from source of truth:
- Manual remediation steps:

---

## 9) Reliability test strategy

### Chaos/fault injection (optional)
- Inject timeouts
- Inject 5xx responses
- Simulate rate limiting

### Failure scenario tests
- Add failure scenarios as coverage:
  - `/Coverages/FUNCTIONAL_REQUIREMENTS.md`
  - `/Coverages/EDGE_CASES_AND_BOUNDARY_CONDITIONS.md`

Link to: `/Guidelines/TESTING_STANDARDS.md`.

---

## 10) Observability for reliability

Required signals:
- Error rate by category
- Retry counts
- Circuit breaker state
- Dependency latency
- Queue depth/backpressure

Link to: `/Documentations/OBSERVABILITY_LOGGING_TRACING.md`.

---

## 11) Change control

When changing fault-tolerance behavior:
- Update this file.
- Update integration docs.
- Update error catalog if needed.
- Add/adjust tests.
- Update reliability evaluation.

---

## 12) Change log

- YYYY-MM-DD — Added reliability policy
- YYYY-MM-DD — Updated retry/backoff rules


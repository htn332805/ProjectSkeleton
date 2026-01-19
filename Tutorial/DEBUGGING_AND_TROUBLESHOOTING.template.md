# DEBUGGING_AND_TROUBLESHOOTING
How to diagnose issues, where logs live, how to reproduce.
> Practical guide for diagnosing failures, regressions, and performance issues.
>
> Goal: reduce time-to-root-cause with repeatable steps, good observability, and traceability.

---

## 1) Debugging philosophy

- Reproduce first.
- Minimize the failing case.
- Observe before changing code.
- Change one thing at a time.
- Add a regression test.

---

## 2) Quick triage checklist (first 5 minutes)

- [ ] What changed recently? (check `/CHANGELOG.md` and recent PRs)
- [ ] Is it environment-specific? (dev vs staging vs prod)
- [ ] Can you reproduce locally?
- [ ] Are logs/traces present with the right context fields?
- [ ] Is it a known issue?

---

## 3) Reproduction workflow

### 3.1 Create or reference a scenario
- Put the scenario in `/Coverages/*` (functional or edge case).

### 3.2 Reproduce locally
Run:
```bash
# example
make test
```

### 3.3 Minimize
- Reduce inputs to the smallest that still fails.
- Eliminate unrelated modules.

---

## 4) Where to look (by symptom)

### Symptom: test failure
- Check stack trace.
- Identify boundary: core vs adapter vs application.
- Verify contracts in `/Documentations/DATA_MODELS_AND_CONTRACTS.md`.

### Symptom: runtime exception
- Confirm error type exists in `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`.
- Verify handling aligns with `/Guidelines/ERROR_HANDLING_STRATEGY.md`.

### Symptom: performance regression
- Compare with `/Coverages/PERFORMANCE_REQUIREMENTS.md`.
- Look for:
  - increased IO calls
  - N+1 patterns
  - excessive logging
  - unexpected retries

---

## 5) Logging strategy (how to use logs)

### Required context fields
- request_id
- trace_id
- module
- operation

Link: `/Documentations/OBSERVABILITY_LOGGING_TRACING.md`.

### Tips
- Filter by trace_id.
- Look for first ERROR event in the trace.
- Confirm what retries occurred.

---

## 6) Tracing strategy (how to use traces)

- Identify the slowest span.
- Check external dependency spans.
- Validate span names follow conventions.

Link: `/Documentations/OBSERVABILITY_LOGGING_TRACING.md`.

---

## 7) Common root causes (checklist)

### Contract drift
- DTO field added/removed without versioning.
- Schema semantics changed.

Fix:
- Update contracts doc.
- Add contract tests.

### Hidden coupling
- Shared mutable state.
- Global config.

Fix:
- Inject dependencies.
- Split module responsibilities.

### Error mapping inconsistency
- External errors not mapped to canonical types.

Fix:
- Update error mapping in adapter.
- Update catalog and tests.

---

## 8) Regression test policy

When a bug is fixed:
- Add a test reproducing the bug.
- Add coverage scenario (if missing).
- Update documentation if behavior changed.

Link: `/Guidelines/TESTING_STANDARDS.md`.

---

## 9) Troubleshooting table (fill in)

| Symptom | Likely cause | How to confirm | Fix |
|---|---|---|---|
|  |  |  |  |

---

## 10) Escalation

Escalate when:
- Security incident suspected.
- Data corruption risk.
- Production outage.

Capture:
- Trace IDs
- Logs
- Reproduction steps
- Affected version

---

## 11) Links

- Observability standards: `/Documentations/OBSERVABILITY_LOGGING_TRACING.md`
- Error handling strategy: `/Guidelines/ERROR_HANDLING_STRATEGY.md`
- Error catalog: `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`
- Refactoring validation: `/Refactoring_Approach/DEBUGGING_AND_VALIDATION.md`

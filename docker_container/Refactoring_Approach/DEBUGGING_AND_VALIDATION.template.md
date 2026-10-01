# DEBUGGING_AND_VALIDATION
 Regression strategy, golden tests, perf regression checks.
> Debugging and validation practices to keep refactors safe and verifiable.
>
> Goal: quickly detect regressions, isolate root causes, and prove behavior equivalence.

---

## 1) When to use this

Use this guide when:
- A refactor changes structure across multiple files.
- Tests are failing after a slice.
- Behavior is “the same” but outputs differ subtly.
- Performance regresses.

---

## 2) Validation ladder (go from fast → slow)

1. Static checks (format/lint/type checks)
2. Unit tests for changed modules
3. Contract tests at boundaries
4. Integration tests for critical flows
5. End-to-end tests (if applicable)
6. Performance checks (only for hot paths)

Rule: do not jump to end-to-end debugging until fast checks are green.

---

## 3) Behavior equivalence checklist

To claim “no behavior change,” verify:
- Same inputs produce same outputs for covered scenarios.
- Same side effects (DB writes, messages, files) are produced.
- Same error behavior (types/messages/codes) at boundaries.
- Same logging/metrics semantics if they are contractually consumed.

Links:
- `/Coverages/*`
- `/Documentations/DATA_MODELS_AND_CONTRACTS.md`

---

## 4) Debugging playbook (failing tests)

### 4.1 Triage
- Identify the smallest failing test.
- Confirm reproducibility locally and in CI.
- Check if the failure is deterministic or flaky.

### 4.2 Localize the change
- Use `git bisect` if failure surfaced after multiple commits.
- Temporarily revert the last slice to confirm blast radius.

### 4.3 Inspect contracts and assumptions
- Look for subtle differences (ordering, default values, time zones, rounding).
- Validate serialization formats and schema expectations.

### 4.4 Fix approach
- Prefer smallest corrective change.
- Add a regression test to lock behavior.

---

## 5) Debugging playbook (runtime issues)

- Increase logging at boundaries (avoid sensitive data).
- Add assertions for invariants in non-production builds.
- Reproduce with minimal input.
- Capture a reduced failing case for tests.

Link: `/Guidelines/SECURITY.md` (logging hygiene).

---

## 6) Performance validation

### 6.1 Baseline
- Capture baseline metrics before refactor.

### 6.2 Benchmarks
- Prefer microbenchmarks for pure functions.
- Use representative datasets.

### 6.3 Acceptance
- Define acceptable variance (e.g., within ±5%) unless improvement is the goal.

Link: `/Refactoring_Approach/METRICS_AND_SUCCESS_CRITERIA.md`.

---

## 7) Tooling suggestions (optional)

Fill in what the repo uses:
- Lint/type: 
- Unit tests: 
- Integration tests: 
- Coverage: 
- Benchmarking: 

---

## 8) PR evidence checklist

- [ ] Validation ladder executed (as applicable).
- [ ] Failing cases reduced and turned into tests.
- [ ] Contract tests confirm behavior.
- [ ] Performance checked if relevant.
- [ ] Evidence linked (test outputs/benchmarks).

---

## 9) Change log

- YYYY-MM-DD — Created/updated debugging and validation practices.


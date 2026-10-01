# PERFORMANCE_CONSTRAINTS
Performance budgets + prohibited patterns (e.g., N+1).
> Non-negotiable performance rules and budgets.
>
> Goal: keep the system efficient by default and prevent performance regressions.

---

## 1) How to use this document

### Rules
- If you touch a hot path, measure before/after.
- If performance requirements exist in `/Coverages/PERFORMANCE_REQUIREMENTS.md`, they are binding.
- If trade-offs are required, document via ADR.

Links:
- `/Coverages/PERFORMANCE_REQUIREMENTS.md`
- `/Documentations/DECISIONS_ADR_LOG.md`

---

## 2) Performance budgets (global)

Fill in target budgets.

| Category | Budget | Measurement | Notes |
|---|---:|---|---|
| Latency (p99) |  |  |  |
| Throughput |  |  |  |
| Memory |  |  |  |
| CPU |  |  |  |
| Disk IO |  |  |  |
| Network IO |  |  |  |

---

## 3) Algorithmic constraints

### Complexity targets
- Hot-path operations should be ~O(n) or better.
- Avoid nested loops over large datasets unless justified.

### Prohibited patterns (unless justified)
- O(n^2) over unbounded inputs
- Full table scans without constraints
- Unbounded recursion

---

## 4) IO constraints

### Database
- Avoid N+1 queries.
- Prefer batched reads/writes.
- Use indexes for query filters.

### Network / external APIs
- Timeouts must be set.
- Retries must be bounded.
- Respect rate limits.

Link to: `/Coverages/INTEGRATION_SCENARIOS.md`.

---

## 5) Memory constraints

- Avoid loading large datasets fully into memory.
- Prefer streaming/iterators.
- Explicitly bound caches.

---

## 6) Logging constraints

- Do not log excessively in hot paths.
- Prefer counters/histograms over verbose logs.

Link to: `/Documentations/OBSERVABILITY_LOGGING_TRACING.md`.

---

## 7) Concurrency constraints

- Avoid shared mutable state.
- Favor immutable data structures.
- Ensure thread safety if concurrency is used.

---

## 8) Performance testing requirements

- Benchmarks required for hot path modules.
- Regression thresholds must be enforced in CI when possible.

Link to: `/Guidelines/TESTING_STANDARDS.md` and `/Tutorial/TESTING_PLAYBOOK.md`.

---

## 9) Review checklist

- [ ] Performance-sensitive paths identified.
- [ ] Before/after measurement captured.
- [ ] No N+1 patterns introduced.
- [ ] No unbounded memory growth.
- [ ] Logging kept minimal in hot paths.
- [ ] Performance tests/benchmarks updated.


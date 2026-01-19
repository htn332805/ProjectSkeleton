# METRICS_AND_SUCCESS_CRITERIA
How to measure that refactor improved things.
> Defines how refactoring success is measured in this project.
>
> Goal: ensure refactoring is justified, tracked, and results in tangible improvements without behavior regressions.

---

## 1) How to use this document

For each refactoring initiative, fill out a short “scorecard”:
- Baseline (before)
- Target (after)
- Actual (after)
- Evidence (links to PRs, test runs, benchmarks)

Rule: pick a small number of metrics (2–5) that best match the refactor objective.

---

## 2) Refactor scorecard template

### Initiative
- Name:
- Owner:
- Date range:
- Subsystem/modules:
- Refactor objective(s):

### Guardrails (must stay true)
- Behavior unchanged (contract tests pass):
- Backward compatibility preserved:
- Security posture unchanged or improved:

### Metrics
| Metric | Baseline | Target | Actual | Evidence |
|---|---:|---:|---:|---|
| Complexity (cyclomatic) |  |  |  |  |
| Unit test coverage (critical modules) |  |  |  |  |
| Build/test time (minutes) |  |  |  |  |
| P95 latency (ms) |  |  |  |  |
| Memory usage (MB) |  |  |  |  |

### Notes
- Tradeoffs made:
- Follow-ups:

---

## 3) Metric categories (pick what fits)

### 3.1 Code quality metrics
Use to improve readability and maintainability.
- Cyclomatic complexity (per function/module)
- Function length / file length
- Duplication (e.g., % duplicated lines)
- Lint/static analysis issues

### 3.2 Testability metrics
Use to increase safety and velocity.
- Coverage in critical modules (line/branch)
- Number of flaky tests
- Time to run unit tests
- Presence of contract tests at boundaries

### 3.3 Architecture metrics
Use to reduce coupling and improve modularity.
- Dependency direction (layering violations)
- Fan-in/fan-out counts
- Number of “god modules” (modules with excessive responsibilities)

### 3.4 Performance metrics
Use only where performance matters.
- Throughput (req/s)
- Latency (p50/p95/p99)
- CPU usage
- Memory usage

### 3.5 Reliability/operability metrics
Use for production safety.
- Error rate
- Incident count / severity
- Mean time to recovery (MTTR)

---

## 4) Success criteria (definition)

A refactor is successful when:
- All tests pass and contracts hold.
- No behavior regressions are observed in covered scenarios.
- Target metrics improve (or remain stable where required).
- Documentation is updated where boundaries/interfaces change.

---

## 5) Evidence requirements

For each metric, attach evidence:
- PR links
- Benchmark output (before/after)
- Test report output
- Static analysis reports

Keep evidence lightweight but reproducible.

---

## 6) Recommended targets (guidance)

Use these as defaults, not hard rules:
- Reduce complexity for touched modules by 10–30%.
- Increase tests around the refactored boundary until core scenarios are covered.
- Keep performance within ±5% unless improvement is a stated goal.

---

## 7) Change log

- YYYY-MM-DD — Created/updated refactoring metrics and success criteria.


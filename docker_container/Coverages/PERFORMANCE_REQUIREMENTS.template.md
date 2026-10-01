# PERFORMANCE_REQUIREMENTS
SLAs, budgets, load profiles, profiling expectations.
> Canonical performance expectations for the project.
>
> Goal: make performance measurable, testable, and non-negotiable.

---

## 1) How to use this document

### Rules
- Define performance budgets early.
- Every major workflow should have latency/throughput targets.
- Performance regressions must be detectable via tests/benchmarks.

### Traceability
- Link performance requirements to:
  - Functional scenarios in `/Coverages/FUNCTIONAL_REQUIREMENTS.md`
  - Module templates in `/code/*_template.md`
  - Evaluation metrics in `/Project_implementation_evaluation/PERFORMANCE_ASSESSMENT.md`

---

## 2) Global performance goals

- Primary objective: (e.g., low-latency / high-throughput / cost efficiency)
- Target environment: (local, staging, production)
- Assumed hardware/resources:

---

## 3) Definitions

- **Latency**: time to complete an operation.
- **Throughput**: operations per unit time.
- **p50/p95/p99**: percentile latencies.
- **SLO/SLA**: target guarantees.

---

## 4) Performance budgets (global)

| Resource | Budget | Notes |
|---|---:|---|
| CPU |  |  |
| Memory |  |  |
| Disk |  |  |
| Network |  |  |

---

## 5) Latency requirements (workflows)

> Define targets by workflow/use-case.

### PR-XXXX: <workflow name>

- Related FR(s): FR-____
- Priority: P0 | P1 | P2
- Environment: dev/staging/prod

#### Targets
- p50 latency:
- p95 latency:
- p99 latency:

#### Constraints
- Input sizes:
- Data volume assumptions:
- Dependency assumptions:

#### Measurement method
- Benchmark tool:
- How to run:

#### Traceability
- Module templates:
- Tests/benchmarks:
- Evaluation:

---

## 6) Throughput requirements

### TR-XXXX: <workflow name>

- Target throughput:
- Concurrency level:
- Duration:

---

## 7) Load profiles

Define standard load scenarios.

- Load profile A (steady):
- Load profile B (spiky):
- Load profile C (stress):

---

## 8) Performance anti-requirements (prohibited)

- N+1 queries
- Unbounded memory growth
- Unbounded loops
- Excessive logging in hot paths

Link to: `/Guidelines/PERFORMANCE_CONSTRAINTS.md`.

---

## 9) Benchmarking strategy

### Microbenchmarks
- For pure functions/hot loops

### Macrobenchmarks
- End-to-end performance tests

### Regression detection
- Thresholds:
- Alerting:

---

## 10) Change control

When changing performance-sensitive behavior:
- Update this file.
- Update module templates with performance expectations.
- Update benchmarks/tests.
- Update evaluation metrics.

---

## 11) Change log

- YYYY-MM-DD — Added PR/TR requirement
- YYYY-MM-DD — Updated target values


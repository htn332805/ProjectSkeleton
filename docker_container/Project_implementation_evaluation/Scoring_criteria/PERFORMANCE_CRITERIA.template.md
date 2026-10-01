# PERFORMANCE_CRITERIA
 Scoring rubric for performance.
 > Detailed scoring criteria for performance.
>
> Goal: provide a consistent rubric for evaluating performance with evidence.

---

## 1) How to use this rubric

- Score each criterion from 1–5 using the shared scale in:
  - `/Project_implementation_evaluation/Scoring_criteria/PROJECT_EVALUATION_SCORE.md`
- Provide evidence links for each score.
- If evidence is missing, score conservatively.

---

## 2) Criteria and scoring

### P1) Performance goals and SLOs
What to look for:
- Clear targets for critical workloads (latency/throughput/resource)
- Targets match real usage

Scoring hints:
- 5: Targets defined and validated; used in decisions.
- 3: Some targets exist but incomplete or not consistently used.
- 1: No targets; performance success is subjective.

Score:
Evidence:
Notes:

---

### P2) Measurement methodology and reproducibility
What to look for:
- Reproducible benchmark/load methodology
- Controlled environment notes
- Multiple runs with variance handling

Scoring hints:
- 5: Measurements are reproducible; methodology documented.
- 3: Some measurements exist; methodology partial.
- 1: Numbers are ad hoc; cannot reproduce.

Score:
Evidence:
Notes:

---

### P3) Baselines and trend tracking
What to look for:
- Baseline results recorded
- Tracking over time (optional)
- Known regressions documented

Scoring hints:
- 5: Baselines tracked and revisited; trends visible.
- 3: Baseline exists but not consistently maintained.
- 1: No baseline; regressions discovered late.

Score:
Evidence:
Notes:

---

### P4) Bottleneck identification and profiling
What to look for:
- Profiling/tracing identifies hot paths
- Bottlenecks documented with evidence

Scoring hints:
- 5: Bottlenecks systematically identified; evidence-driven improvements.
- 3: Some bottlenecks known; inconsistent profiling.
- 1: Bottlenecks guessed; no evidence.

Score:
Evidence:
Notes:

---

### P5) Optimization effectiveness
What to look for:
- Changes deliver measured improvements
- Tradeoffs documented
- No hidden regressions

Scoring hints:
- 5: Improvements are measurable and sustained.
- 3: Some improvements; occasional regressions.
- 1: Optimizations are speculative or regress performance.

Score:
Evidence:
Notes:

---

### P6) Resource efficiency
What to look for:
- Memory and CPU usage tracked for critical workloads
- Avoids unnecessary allocations
- Efficient I/O patterns

Scoring hints:
- 5: Resource usage is measured and optimized.
- 3: Reasonable but not tracked consistently.
- 1: Resource usage is uncontrolled.

Score:
Evidence:
Notes:

---

### P7) Regression prevention
What to look for:
- Benchmarks for hot paths
- CI or scheduled runs
- Clear acceptable variance thresholds

Scoring hints:
- 5: Regressions are prevented by guardrails.
- 3: Some guardrails; gaps in CI coverage.
- 1: No guardrails; regressions frequent.

Score:
Evidence:
Notes:

---

## 3) Roll-up scoring (optional)

- Performance score can be the average of P1–P7, or weighted if desired.

| Criterion | Weight (%) | Score |
|---|---:|---:|
| P1 Goals/SLOs |  |  |
| P2 Methodology |  |  |
| P3 Baselines |  |  |
| P4 Profiling |  |  |
| P5 Effectiveness |  |  |
| P6 Efficiency |  |  |
| P7 Regression prevention |  |  |

---

## 4) Change log

- YYYY-MM-DD — Created/updated performance criteria.


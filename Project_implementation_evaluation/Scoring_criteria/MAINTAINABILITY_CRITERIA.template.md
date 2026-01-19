# MAINTAINABILITY_CRITERIA
Scoring rubric for maintainability.

> Metric-focused criteria for evaluating maintainability.
>
> Goal: provide a repeatable, measurable view of maintainability that complements qualitative rubrics.

---

## 1) How to use this document

Use this when:
- you want objective signals to support maintainability scoring, or
- you are tracking maintainability improvements during refactoring.

Workflow:
1. Pick a small set of metrics relevant to the subsystem (3–8).
2. Capture baseline values.
3. Set targets.
4. Re-measure after changes.
5. Attach evidence (reports, commands, CI links).

Links:
- `/Project_implementation_evaluation/Scoring_criteria/MAINTAINABILITY_CRITERIA.md`
- `/Refactoring_Approach/METRICS_AND_SUCCESS_CRITERIA.md`

---

## 2) Measurement rules

- Always record: commit hash, date, environment.
- Prefer automated extraction (CI) where possible.
- If a metric is noisy, record variance over multiple runs.
- If a metric is missing, mark it as “not measured” and explain why.

---

## 3) Maintainability metrics scorecard template

### Scope
- Subsystem/modules:
- Commit:
- Date:
- Environment:

### Metrics
| Metric | Why it matters | Tool/source | Baseline | Target | Actual | Evidence |
|---|---|---|---:|---:|---:|---|
| Cyclomatic complexity (avg/max) | Predicts change risk |  |  |  |  |  |
| Hotspot churn (files changed often) | Indicates unstable design |  |  |  |  |  |
| Test coverage (critical modules) | Safety net for change |  |  |  |  |  |
| Test flakiness rate | Confidence and velocity |  |  |  |  |  |
| Build/test duration (min) | Developer feedback loop |  |  |  |  |  |
| Dependency count (direct/transitive) | Upgradeability risk |  |  |  |  |  |
| Lint/static issues | Hygiene and correctness signals |  |  |  |  |  |
| Public API surface size | Change ripple risk |  |  |  |  |  |

### Notes
- What improved?
- What got worse (and why)?
- Follow-ups:

---

## 4) Suggested metric definitions

### 4.1 Complexity
- Definition: cyclomatic complexity per function/module, plus max.
- Interpretation: reducing max complexity in critical modules reduces change risk.

### 4.2 Churn / hotspots
- Definition: files with the most changes over a window (e.g., last 30/90 days).
- Interpretation: persistent hotspots may indicate missing boundaries.

### 4.3 Test safety net
- Coverage: focus on critical modules and boundary behavior.
- Flakiness: measure flaky test frequency and time-to-fix.

### 4.4 Feedback loop speed
- Build time
- Unit test time

### 4.5 Dependency hygiene
- Direct and transitive dependency counts
- Outdated dependencies

### 4.6 API surface size
- Public entry points (APIs/CLI/config)
- Interpretation: large API surface increases compatibility burden.

---

## 5) Scoring guidance (optional)

If you convert metrics into a 1–5 score, define thresholds here.

Example (edit to fit your project):
- 5: Complexity max < X, test coverage > Y%, build < Z min, flakiness near zero.
- 3: Some hotspots; coverage moderate; build times acceptable.
- 1: No measurement; very high complexity; weak tests; slow feedback loop.

---

## 6) Evidence checklist

- [ ] Reports attached or linked.
- [ ] Commands used documented.
- [ ] Commit hash recorded.
- [ ] Scope clearly defined.

---

## 7) Change log

- YYYY-MM-DD — Created/updated maintainability metrics criteria.


# MAINTAINABILITY_METRICS_CRITERIA
Additional maintainability metrics/rubric.
> Detailed scoring criteria for maintainability.
>
> Goal: provide a consistent rubric for evaluating how easy the system is to change safely over time.

---

## 1) How to use this rubric

- Score each criterion from 1–5 using the shared scale in:
  - `/Project_implementation_evaluation/Scoring_criteria/PROJECT_EVALUATION_SCORE.md`
- Provide evidence links for each score.
- If evidence is missing, score conservatively.

---

## 2) Criteria and scoring

### M1) Modularity and separation of concerns (change isolation)
What to look for:
- Changes tend to stay within a small set of modules
- Clear component boundaries
- Minimal cross-cutting edits

Scoring hints:
- 5: Most changes are localized; boundaries are clear and respected.
- 3: Some hotspots require broad edits; boundaries leak.
- 1: Changes regularly ripple across many modules.

Score:
Evidence:
Notes:

---

### M2) Complexity management
What to look for:
- Low cognitive load in critical paths
- Complex logic decomposed and tested
- Complexity tooling used (optional)

Scoring hints:
- 5: Complexity is tracked and reduced; hotspots are actively managed.
- 3: Complexity is tolerated; some hotspots remain.
- 1: Complexity is widespread and blocks safe change.

Score:
Evidence:
Notes:

---

### M3) Testability and safety net
What to look for:
- Unit tests for core logic
- Contract tests for boundaries
- Low flakiness

Scoring hints:
- 5: Strong safety net; changes are confidently shipped.
- 3: Basic tests exist but gaps slow down change.
- 1: Missing tests; changes are risky.

Score:
Evidence:
Notes:

---

### M4) Documentation and discoverability for contributors
What to look for:
- Clear project structure docs
- Accurate API/contracts docs
- Examples/tutorials

Scoring hints:
- 5: New contributors can navigate and change safely with minimal help.
- 3: Core docs exist; some areas unclear.
- 1: Docs missing/outdated; onboarding is slow.

Score:
Evidence:
Notes:

---

### M5) Consistency and conventions
What to look for:
- Standard patterns are used consistently
- Formatting/linting is automated
- Naming conventions are stable

Scoring hints:
- 5: Consistency is enforced; codebase feels cohesive.
- 3: Mostly consistent; some drift.
- 1: Inconsistent conventions; review is difficult.

Score:
Evidence:
Notes:

---

### M6) Dependency hygiene and upgradeability
What to look for:
- Dependencies are minimal and intentional
- Versions are pinned/managed
- Upgrades are routine and low risk

Scoring hints:
- 5: Dependency upgrades are predictable; supply chain is managed.
- 3: Some dependency sprawl; upgrades occasionally painful.
- 1: Dependency risk is unmanaged; upgrades break frequently.

Score:
Evidence:
Notes:

---

### M7) Refactoring readiness
What to look for:
- Refactoring framework exists and is followed
- Metrics and success criteria tracked
- Small incremental PR discipline

Scoring hints:
- 5: Refactoring is routine, measured, and low-risk.
- 3: Refactoring happens but is inconsistent or not measured.
- 1: Refactoring is avoided or done as risky rewrites.

Score:
Evidence:
Notes:

Links:
- `/Refactoring_Approach/REFACTORING_FRAMEWORK.md`
- `/Refactoring_Approach/METRICS_AND_SUCCESS_CRITERIA.md`

---

## 3) Roll-up scoring (optional)

- Maintainability score can be the average of M1–M7, or weighted if desired.

| Criterion | Weight (%) | Score |
|---|---:|---:|
| M1 Modularity |  |  |
| M2 Complexity |  |  |
| M3 Testability |  |  |
| M4 Documentation |  |  |
| M5 Consistency |  |  |
| M6 Dependencies |  |  |
| M7 Refactoring readiness |  |  |

---

## 4) Change log

- YYYY-MM-DD — Created/updated maintainability criteria.


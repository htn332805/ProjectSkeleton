# CODE_QUALITY_CRITERIA
Scoring rubric for code quality.
> Detailed scoring criteria for code quality.
>
> Goal: provide a consistent rubric for evaluating code quality with evidence.

---

## 1) How to use this rubric

- Score each criterion from 1–5 using the shared scale in:
  - `/Project_implementation_evaluation/Scoring_criteria/PROJECT_EVALUATION_SCORE.md`
- Provide evidence links for each score.
- If evidence is missing, score conservatively.

---

## 2) Criteria and scoring

### Q1) Readability and naming
What to look for:
- Names reflect intent
- Functions are easy to follow
- Comments clarify “why” (not the obvious “what”)

Scoring hints:
- 5: Clear naming and structure throughout; minimal cognitive load.
- 3: Generally readable; occasional confusing areas.
- 1: Hard to understand; inconsistent naming; heavy reliance on tribal knowledge.

Score:
Evidence:
Notes:

---

### Q2) Complexity and decomposition
What to look for:
- Small, focused functions
- Complexity kept low in critical paths
- Few deeply nested branches

Scoring hints:
- 5: Complexity actively managed; hotspots addressed.
- 3: Some complex hotspots exist but contained.
- 1: Widespread complexity; changes are risky.

Score:
Evidence:
Notes:

---

### Q3) Consistency and style discipline
What to look for:
- Auto-formatting enabled
- Consistent conventions (files, imports, naming)
- Minimal “format churn” in PRs

Scoring hints:
- 5: Consistent style; tooling enforced.
- 3: Mostly consistent; some drift.
- 1: Inconsistent style; review is hard.

Score:
Evidence:
Notes:

---

### Q4) Test coverage and confidence
What to look for:
- Unit tests exist for core logic
- Contract/integration tests protect boundaries
- Low flakiness

Scoring hints:
- 5: Strong coverage of critical flows; tests are reliable.
- 3: Basic coverage; gaps in critical areas.
- 1: Few tests; regressions common.

Score:
Evidence:
Notes:

---

### Q5) Correctness signals and invariants
What to look for:
- Input validation
- Assertions/invariants where helpful
- Clear error handling

Scoring hints:
- 5: Strong invariants; predictable error behavior.
- 3: Basic validation; occasional ambiguous errors.
- 1: Errors are unpredictable; invalid states common.

Score:
Evidence:
Notes:

---

### Q6) Dependency hygiene
What to look for:
- Minimal unnecessary dependencies
- Clear dependency boundaries
- Avoids cycles

Scoring hints:
- 5: Dependencies are lean and well-managed.
- 3: Some coupling; manageable.
- 1: Dependency sprawl; cycles; hard upgrades.

Score:
Evidence:
Notes:

---

### Q7) Documentation near the code
What to look for:
- Docstrings and inline docs are accurate
- Examples remain valid
- Templates are followed

Scoring hints:
- 5: Code-adjacent docs are accurate and helpful.
- 3: Mixed quality; some drift.
- 1: Docs missing or misleading.

Score:
Evidence:
Notes:

---

## 3) Roll-up scoring (optional)

- Code quality score can be the average of Q1–Q7, or weighted if desired.

| Criterion | Weight (%) | Score |
|---|---:|---:|
| Q1 Readability |  |  |
| Q2 Complexity |  |  |
| Q3 Consistency |  |  |
| Q4 Tests |  |  |
| Q5 Correctness signals |  |  |
| Q6 Dependency hygiene |  |  |
| Q7 Code-adjacent docs |  |  |

---

## 4) Change log

- YYYY-MM-DD — Created/updated code quality criteria.


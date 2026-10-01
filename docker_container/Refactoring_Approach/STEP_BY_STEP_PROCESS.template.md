# STEP_BY_STEP_PROCESS
Checklist-driven procedure from baseline → change → validate.
> The canonical checklist-driven refactoring procedure.
>
> Goal: refactor in safe, small, reviewable steps with continuous validation.

---

## 1) Inputs to this process

Before refactoring, ensure you have:
- A clear objective (what improves?)
- The relevant scenarios in `/Coverages/*`
- Module templates in `/code/*_template.md`
- Baseline tests

---

## 2) Pre-refactor checklist (must complete)

- [ ] Identify scope and boundaries (which modules are involved?).
- [ ] Identify public APIs/contracts that must not break.
- [ ] Identify risks (security/perf/reliability).
- [ ] Confirm guidelines to honor: `/Guidelines/*`.
- [ ] Confirm current tests pass (baseline).

---

## 3) Baseline capture

### 3.1 Baseline behavior
- What is the current behavior?
- What scenarios define it?

### 3.2 Baseline metrics
Capture before refactor:
- Complexity metrics (if applicable)
- Performance (if hot path)
- Test duration (optional)

Link to: `/Refactoring_Approach/METRICS_AND_SUCCESS_CRITERIA.md`.

---

## 4) Plan the refactor (break it into slices)

### 4.1 Slice design
Break into steps that are:
- independently testable
- minimal blast radius
- easy to code review

### 4.2 Commit plan
Define a sequence:
1. Add tests (if missing)
2. Extract function/class
3. Introduce interface
4. Move module
5. Remove old path

### 4.3 Rollback plan
- How to revert if a step fails?

---

## 5) Execute incrementally (repeat loop)

Repeat this loop for each step:

1. Make one small change.
2. Run fast tests (unit tests).
3. Run relevant integration/contract tests.
4. Verify behavior unchanged.
5. Commit with a clear message.

### Suggested commit format
- `refactor(<scope>): <small change>`

---

## 6) Validate end-to-end

After all slices:

- [ ] Run full test suite.
- [ ] Confirm coverage scenarios still pass.
- [ ] Confirm performance unchanged (if relevant).
- [ ] Confirm contracts unchanged or versioned correctly.

---

## 7) Documentation updates

Update as needed:
- `/code/*_template.md` (interfaces/method contracts)
- `/Documentations/PROJECT_ARCHITECTURE.md` (boundaries/data flow)
- `/Documentations/API_REFERENCE.md` (public APIs)
- `/Documentations/DATA_MODELS_AND_CONTRACTS.md` (contracts)

---

## 8) Evaluation updates

Update when refactor impacts quality dimensions:
- `/Project_implementation_evaluation/CODE_QUALITY_ASSESSMENT.md`
- `/Project_implementation_evaluation/ARCHITECTURE_ASSESSMENT.md`
- `/Project_implementation_evaluation/PERFORMANCE_ASSESSMENT.md`

Update score when material:
- `/Project_implementation_evaluation/Scoring_criteria/PROJECT_EVALUATION_SCORE.md`

---

## 9) Changelog policy

- Refactor-only changes: usually no user-facing changelog entry.
- Behavior changes: must be logged in `/CHANGELOG.md`.

---

## 10) Final checklist

- [ ] Objective achieved.
- [ ] Tests passing.
- [ ] No behavior change.
- [ ] No guideline violations.
- [ ] Contracts/APIs preserved or migrated.
- [ ] Docs/templates updated.
- [ ] Evaluation updated if needed.


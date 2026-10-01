# REFACTORING_FRAMEWORK
Philosophy, triggers, phases, guardrails.
> Master framework for refactoring in this project.
>
> Goal: make refactoring safe, incremental, measurable, and fully compliant with non-negotiable guidelines.

---

## 1) Definition

### What refactoring means here
Refactoring is improving internal structure **without changing externally observable behavior**.

### What refactoring is NOT
- Adding new features (unless explicitly separated into a different PR)
- Changing business logic behavior
- “Cleanup” without validation

---

## 2) Non-negotiable constraints

Refactoring must always:
- Honor `/Guidelines/*`
- Maintain contracts in `/Documentations/DATA_MODELS_AND_CONTRACTS.md`
- Keep APIs compatible unless a formal breaking change process is followed

Links:
- `/Guidelines/DESIGN_PRINCIPLES.md`
- `/Guidelines/TESTING_STANDARDS.md`
- `/Guidelines/COMPATIBILITY_RULES.md`

---

## 3) When to refactor (triggers)

Refactor when:
- A module violates SRP.
- A unit is too large/complex.
- Coupling prevents parallel development.
- Duplication is causing bugs.
- A change requires risky edits across many files.
- Performance issues are due to structure.

---

## 4) When NOT to refactor

Avoid refactoring when:
- Tests are missing and cannot be added quickly.
- Requirements are unclear.
- The area is unstable and actively changing.
- The change window is too short (production risk).

---

## 5) Refactoring objectives

Every refactor must state at least one measurable objective:
- Reduce complexity
- Increase cohesion
- Reduce coupling
- Improve testability
- Improve performance
- Improve readability/maintainability

Link to: `/Refactoring_Approach/METRICS_AND_SUCCESS_CRITERIA.md`.

---

## 6) Refactoring workflow (phases)

### Phase 0: Preparation
- Identify scope
- Confirm guidelines to honor
- Confirm success criteria

### Phase 1: Baseline
- Add/verify tests
- Capture metrics (complexity/perf)
- Ensure reproducible build

### Phase 2: Plan
- Break refactor into small steps
- Define incremental checkpoints
- Identify risk points and rollback plan

### Phase 3: Execute incrementally
- Implement step 1
- Run tests
- Commit
- Repeat

### Phase 4: Validate
- Re-run full tests
- Compare metrics
- Confirm behavior unchanged

### Phase 5: Documentation and evaluation
- Update module templates
- Update architecture docs if boundaries changed
- Update evaluation docs

Link to: `/Refactoring_Approach/STEP_BY_STEP_PROCESS.md`.

---

## 7) Change classification (refactor vs behavior change)

### Refactor-only change
- Structural changes only
- Same inputs → same outputs

### Behavior change
- Any observable difference

Rule: do not mix in one PR.

---

## 8) Risk management

### Risk assessment checklist
- Blast radius:
- Contract/API risk:
- Performance risk:
- Security risk:

### Rollback plan
- How to revert safely:

---

## 9) Documentation obligations

Refactoring may require updates to:
- `/code/*_template.md` (interfaces moved/changed)
- `/Documentations/PROJECT_ARCHITECTURE.md`
- `/Documentations/API_REFERENCE.md`
- `/Tutorial/*` (examples)
- `/Project_implementation_evaluation/*`

---

## 10) Review checklist

- [ ] Refactor goal stated and measurable.
- [ ] Tests exist and pass.
- [ ] Changes are incremental and reviewable.
- [ ] No behavior change.
- [ ] Guidelines honored.
- [ ] Contracts/API compatibility preserved.
- [ ] Docs/templates updated.
- [ ] Evaluation updated if needed.


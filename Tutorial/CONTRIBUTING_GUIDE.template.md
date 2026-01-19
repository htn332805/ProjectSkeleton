# CONTRIBUTING_GUIDE
Practical dev workflow (pairs with root CONTRIBUTING.md).
> Practical contributor workflow (the “how”).
>
> This file complements `/CONTRIBUTING.md` (the “rules”).

---

## 1) Contributor workflow (end-to-end)

### Step 1: Understand the requirement
- Confirm scenario exists in `/Coverages/*`.
- If missing, add it first.

### Step 2: Design before coding
- Create/update `/code/<module>_template.md`.
- Confirm SRP and boundaries.
- Define data contracts in `/Documentations/DATA_MODELS_AND_CONTRACTS.md`.

### Step 3: Implement in small increments
- Keep commits small and reviewable.
- Avoid mixing refactor + behavior change in one commit.

### Step 4: Add tests
- Unit tests first.
- Add contract/integration tests if boundaries changed.

### Step 5: Update docs
- API changes → `/Documentations/API_REFERENCE.md`
- Architecture changes → `/Documentations/PROJECT_ARCHITECTURE.md` and/or `/ARCHITECTURE.md`
- New patterns → `/Tutorial/COMMON_PATTERNS_AND_RECIPES.md`

### Step 6: Evaluate
- Update `/Project_implementation_evaluation/*` if quality/behavior changes.

### Step 7: Changelog
- Update `/CHANGELOG.md` for user-visible changes.

---

## 2) What a good PR looks like

A good PR includes:
- Problem statement
- What changed (and why)
- Links to:
  - coverage scenarios
  - module templates
  - contract docs
- Test evidence
- Risks/rollout notes (if applicable)

---

## 3) Commit hygiene

- Use meaningful messages.
- One logical change per commit.
- Keep refactors separate from behavior changes.

Link to: `/Guidelines/GIT_WORKFLOW.md`.

---

## 4) Review expectations

Reviewers should verify:
- Boundaries are preserved.
- Contracts are explicit.
- Error behavior is consistent.
- Tests cover scenarios and edge cases.
- Docs updated.

---

## 5) Common pitfalls

- Starting implementation without scenarios/templates.
- Growing a `utils/` dumping ground.
- Introducing hidden coupling via globals.
- Changing contract semantics without versioning.

---

## 6) Links

- Rules: `/CONTRIBUTING.md`
- Guidelines: `/Guidelines/`
- Step-by-step implementation: `/Tutorial/STEP_BY_STEP_IMPLEMENTATION.md`

# INTEGRATION_WITH_DOCUMENTATION_AND_TUTORIALS
Documentation update rules when code changes.
> Rules and workflow for keeping documentation and tutorials accurate during refactoring.
>
> Goal: avoid “code drift” where docs/examples lag behind changes.

---

## 1) What must stay in sync

Refactoring may require updates to:
- `/Documentations/PROJECT_ARCHITECTURE.md` (boundaries, data flow)
- `/Documentations/API_REFERENCE.md` (public APIs)
- `/Documentations/DATA_MODELS_AND_CONTRACTS.md` (schemas/contracts)
- `/Tutorial/*` (examples, walkthroughs)
- `/code/*_template.md` (module contracts)

Rule: if a public name changes (module/class/function), update all references.

---

## 2) Documentation impact assessment (per PR)

Fill this out in each refactor PR:
- Docs affected: (list files)
- Tutorials affected: (list files)
- API references affected: (yes/no)
- Contracts affected: (yes/no)

---

## 3) Update workflow

### 3.1 Before refactor
- Identify doc surfaces that mention the module.
- Capture baseline behavior with scenarios in `/Coverages/*`.

### 3.2 During refactor
- Update docs in the same PR whenever feasible.
- If a series of PRs is needed, include a tracking issue and update docs at each checkpoint.

### 3.3 After refactor
- Run documentation checks (lint, link checker, doctests).
- Validate tutorials still run end-to-end.

---

## 4) Tutorials: keep examples executable

Rules:
- Tutorials should be runnable with minimal setup.
- Prefer small, deterministic examples.
- Avoid fragile screenshots or outputs that change frequently.

Optional checks:
- Add a CI job that executes tutorial code.

---

## 5) Documentation quality rules

- Use plain language.
- Keep examples minimal.
- Add diagrams only if they reduce confusion.
- Use stable references (avoid linking to internal file paths that are likely to move).

Link to: `/Guidelines/DOCUMENTATION_STANDARDS.md`.

---

## 6) Compatibility and versioning

If refactoring changes public APIs (even if behavior is intended to remain the same):
- Document migration steps.
- Consider aliasing old names temporarily.
- Version API references if your project uses versioned docs.

Link to: `/Guidelines/COMPATIBILITY_RULES.md`.

---

## 7) PR checklist

- [ ] Document impact assessment completed.
- [ ] All referenced docs/tutorials updated.
- [ ] Code examples still run.
- [ ] API reference updated if needed.
- [ ] Contracts updated if needed.
- [ ] No broken links.

---

## 8) Change log

- YYYY-MM-DD — Created/updated documentation and tutorial integration policy.


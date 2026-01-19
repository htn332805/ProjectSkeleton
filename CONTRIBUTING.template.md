# Contributing

Contribution guidelines.
Contribution rules that link to /Guidelines/* and /Tutorial/CONTRIBUTING_GUIDE.md.
Thanks for contributing.

This project is intentionally **documentation-first**: designs and constraints are captured in markdown before implementation.

## 1) Quick start

1. Read `/README.md`.
2. Follow `/Tutorial/GETTING_STARTED.md`.
3. Review non-negotiable rules in `/Guidelines/`.

## 2) Ground rules (non-negotiable)

All contributions must:
- Honor `/Guidelines/*` with 100% compliance.
- Be traceable to scenarios in `/Coverages/*`.
- Keep changes small, reviewable, and independently testable.
- Update documentation whenever behavior or interfaces change.

## 3) Where to add or change things

### Requirements and scenarios
- Add/modify scenarios in `/Coverages/`.
- Add edge cases in `/Coverages/EDGE_CASES_AND_BOUNDARY_CONDITIONS.md`.

### Module/API design (before coding)
- Create or update a module template in `/code/<module_name>_template.md`.
- Use `/code/MODULE_TEMPLATE.md` as the standard.

### Architecture references
- Update `/Documentations/PROJECT_ARCHITECTURE.md` for architectural changes.
- Update `/Documentations/DATA_MODELS_AND_CONTRACTS.md` for contract changes.

### Tutorials
- If your change impacts developer workflow or examples, update `/Tutorial/*`.

## 4) Branching, commits, and PRs

Follow `/Guidelines/GIT_WORKFLOW.md`.

### Pull request requirements
A PR should include:
- A clear problem statement.
- The intended behavior (what changes for users).
- Links to relevant coverage docs.
- Links to module templates.
- Test evidence.

## 5) Testing expectations

Follow `/Guidelines/TESTING_STANDARDS.md`.

A contribution is not complete unless:
- Unit tests cover new logic.
- Integration tests are updated when contracts change.
- Edge cases are covered when applicable.

## 6) Documentation expectations

Follow `/Guidelines/DOCUMENTATION_STANDARDS.md`.

Update documentation when you:
- Change public interfaces.
- Add new module responsibilities.
- Introduce new domain concepts.
- Add non-obvious behavior or constraints.

## 7) Refactoring contributions

Refactors are welcome, but must be safe and incremental.

- Follow `/Refactoring_Approach/STEP_BY_STEP_PROCESS.md`.
- Use `/Refactoring_Approach/METRICS_AND_SUCCESS_CRITERIA.md` to prove improvement.
- Update `/Project_implementation_evaluation/*` when changes affect measurable quality.

## 8) Security and performance

- Security changes must align with `/Guidelines/SECURITY_STANDARDS.md` and `/Coverages/SECURITY_REQUIREMENTS.md`.
- Performance changes must align with `/Guidelines/PERFORMANCE_CONSTRAINTS.md` and `/Coverages/PERFORMANCE_REQUIREMENTS.md`.

## 9) Code review checklist

Copy into your PR description:

- [ ] Scenario/requirement updated (`/Coverages/*`).
- [ ] Module template updated (`/code/*_template.md`).
- [ ] Guidelines satisfied (`/Guidelines/*`).
- [ ] Tests added/updated (`/Guidelines/TESTING_STANDARDS.md`).
- [ ] Docs/tutorials updated as needed (`/Documentations/*`, `/Tutorial/*`).
- [ ] Refactor steps followed (if applicable) (`/Refactoring_Approach/*`).
- [ ] Evaluation updated (if applicable) (`/Project_implementation_evaluation/*`).
- [ ] Changelog updated (`/CHANGELOG.md`).

## 10) Communication

- Use issues/discussions to propose major changes.
- For architectural changes, propose the change in docs first (module template + architecture notes), then implement.

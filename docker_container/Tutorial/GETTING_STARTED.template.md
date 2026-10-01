# GETTING_STARTED
First 30–60 minutes path: run something, read next docs.
> A quick, practical onboarding path.
>
> Goal: get a new contributor (or AI assistant) to understand the project structure and run a small workflow end-to-end.

---

## 1) What you’ll accomplish

By the end of this guide you will:
- Understand the documentation-first workflow.
- Set up the environment.
- Run tests.
- Follow a simple example workflow.
- Know where to add scenarios, templates, code, and docs.

---

## 2) Prerequisites

- Read `/README.md`.
- Ensure your machine meets `/Documentations/SETUP_AND_ENVIRONMENT.md` prerequisites.

---

## 3) The workflow (how work happens here)

This project uses a documentation-first loop:

1. **Coverage** (what must happen): `/Coverages/*`
2. **Template** (how it should be designed): `/code/*_template.md`
3. **Implementation** (actual code): `/code/` (implementation directories)
4. **Tests** (proof it works): per `/Guidelines/TESTING_STANDARDS.md`
5. **Docs** (keep it navigable): `/Documentations/*` and `/Tutorial/*`
6. **Evaluation** (measure quality): `/Project_implementation_evaluation/*`

---

## 4) Setup (local)

Follow the detailed instructions in:
- `/Documentations/SETUP_AND_ENVIRONMENT.md`

Quick outline:

1. Clone repo
2. Create environment
3. Install dependencies
4. Configure `.env`
5. Verify by running tests

---

## 5) Run the test suite

Run:

```bash
# example
make test
```

If tests fail:
- Check `/Tutorial/DEBUGGING_AND_TROUBLESHOOTING.md`
- Ensure env vars are set (`.env`)

---

## 6) A tiny end-to-end example (fill in)

> Replace this with a real “hello world” workflow for your project.

### Example: `<example_name>`

**Goal**: (What should happen?)

**Steps**:
1. Run command / script:
   ```bash
   # example
   make run-example
   ```
2. Expected output:
   - (what you should see)

**Where to look in docs**:
- Scenario: `/Coverages/FUNCTIONAL_REQUIREMENTS.md`
- Template: `/code/<module>_template.md`
- Contracts: `/Documentations/DATA_MODELS_AND_CONTRACTS.md`

---

## 7) Where to make changes (cheat sheet)

### Add a new feature
1. Add scenarios: `/Coverages/FUNCTIONAL_REQUIREMENTS.md`
2. Add edge cases: `/Coverages/EDGE_CASES_AND_BOUNDARY_CONDITIONS.md`
3. Create module template: `/code/<feature>_template.md`
4. Implement incrementally
5. Add tests
6. Update docs
7. Update evaluation
8. Update changelog

### Fix a bug
- Reproduce using a scenario in `/Coverages/*`.
- Add regression test.
- Fix with smallest change.
- Update docs if behavior changed.

### Refactor
- Follow `/Refactoring_Approach/STEP_BY_STEP_PROCESS.md`.
- Measure success with `/Refactoring_Approach/METRICS_AND_SUCCESS_CRITERIA.md`.

---

## 8) Key docs to read next

- Architecture deep dive: `/Documentations/PROJECT_ARCHITECTURE.md`
- Module inventory: `/Documentations/MODULE_REGISTRY.md`
- Code organization rules: `/code/CODE_ORGANIZATION_STRUCTURE.md`
- Design principles: `/Guidelines/DESIGN_PRINCIPLES.md`
- Error strategy: `/Guidelines/ERROR_HANDLING_STRATEGY.md`
- Observability: `/Documentations/OBSERVABILITY_LOGGING_TRACING.md`

---

## 9) Getting help

- If something is unclear, open an issue.
- If you propose a major change, write the template/docs first.


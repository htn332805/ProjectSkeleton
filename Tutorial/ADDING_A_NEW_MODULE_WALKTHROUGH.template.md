# CORE_CONCEPTS
Uses MODULE_TEMPLATE.md explicitly.
> Step-by-step guide for adding a new module the “right way” in this repo.
>
> Goal: ensure new modules are atomic, well-bounded, testable, traceable, and easy to evolve.

---

## 1) Before you start (quick checks)

- [ ] Is there already a module that should own this responsibility? Check `/Documentations/MODULE_REGISTRY.md`.
- [ ] Is the requirement clear? If not, write/clarify it in `/Coverages/*` first.
- [ ] Do you know the right layer (core/application/adapter/infra/interface)?

---

## 2) Step 1 — Write the scenario (Coverage)

### 2.1 Functional requirement
Update:
- `/Coverages/FUNCTIONAL_REQUIREMENTS.md`

Use Given/When/Then.

### 2.2 Edge cases
Update:
- `/Coverages/EDGE_CASES_AND_BOUNDARY_CONDITIONS.md`

Capture:
- boundary values
- invalid inputs
- concurrency/timing
- external failures

---

## 3) Step 2 — Decide boundaries and layer

### 3.1 Decide the module type
Choose one:
- core (domain logic)
- application (use-case orchestration)
- adapters (IO boundary)
- infra (cross-cutting)
- interfaces (ports/contracts)

Link:
- `/code/CODE_ORGANIZATION_STRUCTURE.md`
- `/code/MODULARIZATION_PATTERNS.md`

### 3.2 SRP statement
Write one sentence:
- “This module is responsible for …”

List explicit non-responsibilities.

---

## 4) Step 3 — Create the module template (Design)

Create:
- `/code/<module_name>_template.md`

Use:
- `/code/MODULE_TEMPLATE.md`

Minimum required sections to complete:
- SRP statement + non-responsibilities
- Inputs/outputs + invariants
- Public API (methods) with contracts
- Error behavior (typed)
- Dependencies and boundary rules
- Observability requirements
- Testing strategy

---

## 5) Step 4 — Define contracts (if crossing boundaries)

If the module exchanges data across a boundary:
- Update `/Documentations/DATA_MODELS_AND_CONTRACTS.md`
- Add DTO schema + example payload
- Add versioning/compatibility notes

If a port is needed:
- Use `/code/INTERFACES_AND_PORTS_TEMPLATE.md`

---

## 6) Step 5 — Register the module

Update:
- `/Documentations/MODULE_REGISTRY.md`

Add:
- Module name
- Layer/type
- SRP
- Owner
- Status (Proposed/Implemented/etc.)
- Template link
- Key dependencies

---

## 7) Step 6 — Implement incrementally

### 7.1 Create module skeleton
- Add minimal structure.
- Avoid building multiple responsibilities.

### 7.2 Implement happy path first
- Add the smallest correct behavior.
- Add unit tests.

### 7.3 Add edge cases incrementally
- One edge case at a time.
- Add tests per edge case.

### 7.4 Add observability
- Logs/metrics/traces per:
  - `/Documentations/OBSERVABILITY_LOGGING_TRACING.md`

---

## 8) Step 7 — Testing requirements

Link to:
- `/Guidelines/TESTING_STANDARDS.md`
- `/Tutorial/TESTING_PLAYBOOK.md`

Minimum expected:
- Unit tests for all public methods
- Edge case tests
- Contract tests if DTOs/ports changed
- Integration tests if module crosses boundaries

---

## 9) Step 8 — Update documentation

Update as needed:
- `/Documentations/API_REFERENCE.md` (if public API)
- `/Documentations/PROJECT_ARCHITECTURE.md` (if architecture changed)
- `/Tutorial/COMMON_PATTERNS_AND_RECIPES.md` (if you introduced a repeatable pattern)

---

## 10) Step 9 — Evaluate impact

Update as needed:
- `/Project_implementation_evaluation/CAPABILITIES_AND_FEATURES.md`
- `/Project_implementation_evaluation/CODE_QUALITY_ASSESSMENT.md`

If this materially changes project quality:
- update `/Project_implementation_evaluation/Scoring_criteria/PROJECT_EVALUATION_SCORE.md`

---

## 11) Step 10 — Changelog

Update:
- `/CHANGELOG.md`

Add:
- Added/Changed/Fixed as appropriate.

---

## 12) Final checklist

- [ ] Scenario exists in `/Coverages/*`.
- [ ] Module template completed in `/code/*_template.md`.
- [ ] Contracts updated (if needed).
- [ ] Error behavior mapped to catalog.
- [ ] Module registered in `/Documentations/MODULE_REGISTRY.md`.
- [ ] Unit tests written.
- [ ] Integration/contract tests written (if needed).
- [ ] Observability added.
- [ ] Docs updated.
- [ ] Evaluation updated.
- [ ] Changelog updated.


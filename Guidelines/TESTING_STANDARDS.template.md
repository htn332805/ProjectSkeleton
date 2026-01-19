# TESTING_STANDARDS
Test pyramid expectations, coverage requirements, mocking rules.
> Non-negotiable testing requirements for this project.
>
> Goal: strong regression protection, safe refactoring, and reliable releases.

---

## 1) Scope

Applies to:
- All production code
- All tests (unit, contract, integration, e2e)
- Bug fixes and refactors

---

## 2) Principles (non-negotiable)

- Tests must be deterministic.
- Tests must be traceable to requirements/contracts.
- New behavior requires new tests.
- Bug fixes require regression tests.
- Refactoring requires unchanged behavior (tests must still pass).

---

## 3) Test pyramid (required)

### Unit tests (most)
- Fast
- Isolated
- No external IO

### Contract tests (when applicable)
- DTO schema compatibility
- Port/interface compliance
- Error semantics

### Integration tests (some)
- Multi-module behavior
- Adapters against mocked/sandbox dependencies

### End-to-end tests (few)
- Critical workflows only

---

## 4) Traceability requirements

Every meaningful test must trace to at least one:
- Functional scenario: `/Coverages/FUNCTIONAL_REQUIREMENTS.md`
- Edge case: `/Coverages/EDGE_CASES_AND_BOUNDARY_CONDITIONS.md`
- Contract: `/Documentations/DATA_MODELS_AND_CONTRACTS.md`

Recommended: include FR/EC IDs in test names or file headers.

---

## 5) Coverage expectations (fill in)

- Minimum line coverage: ___%
- Minimum branch coverage (optional): ___%
- Coverage enforcement: (CI gate / warning)

Notes:
- Do not chase coverage at the expense of meaningful assertions.

---

## 6) Mocking rules

### Allowed to mock
- External IO (network, DB, filesystem)
- Time
- Randomness

### Not allowed to mock
- Your own core domain logic (unless unavoidable and justified)

---

## 7) Test data policy

- Prefer factories/builders.
- Prefer minimal fixtures.
- Avoid brittle snapshot tests unless necessary.

---

## 8) Performance tests (when required)

If a change touches a hot path:
- Add or update benchmarks.
- Ensure performance requirements remain satisfied.

Link to: `/Coverages/PERFORMANCE_REQUIREMENTS.md`.

---

## 9) Flaky tests (zero tolerance)

If a test is flaky:
- Quarantine with an issue link.
- Fix root cause.
- Remove quarantine.

---

## 10) CI requirements

A PR cannot merge unless:
- Lint/typecheck pass.
- Unit tests pass.
- Integration/contract tests pass (if affected).
- Coverage thresholds met.

Link to: `/Documentations/BUILD_AND_DEPLOY.md`.

---

## 11) Review checklist

- [ ] New behavior has tests.
- [ ] Edge cases tested.
- [ ] Contract tests updated when contracts change.
- [ ] Tests trace to FR/EC/contract docs.
- [ ] No flaky tests introduced.

---

## 12) Related docs

- Testing playbook (how): `/Tutorial/TESTING_PLAYBOOK.md`
- Debugging: `/Tutorial/DEBUGGING_AND_TROUBLESHOOTING.md`

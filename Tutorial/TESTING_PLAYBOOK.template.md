# CORE_CONCEPTS
How to write tests in this repo (examples + pitfalls).
> Practical testing guide for this project (the “how”), aligned with `/Guidelines/TESTING_STANDARDS.md` (the “rules”).
>
> Goal: make tests consistent, fast, trustworthy, and directly traceable to scenarios and contracts.

---

## 1) Testing goals

- Prevent regressions.
- Prove behavior against coverage scenarios.
- Validate contracts between modules.
- Enable safe refactoring.
- Catch performance regressions early.

---

## 2) Test layers (what to write)

### 2.1 Unit tests
**Purpose**: validate small atomic units in isolation.

Use for:
- Pure functions
- Validators
- Domain rules
- Small service methods

Avoid:
- Network/DB calls
- Multiple modules interacting

### 2.2 Contract tests
**Purpose**: validate producer/consumer agreements.

Use for:
- DTO/schema compatibility
- Error semantics and mapping
- Port/interface compliance across adapters

Link to: `/Documentations/DATA_MODELS_AND_CONTRACTS.md`.

### 2.3 Integration tests
**Purpose**: validate correct behavior across module boundaries.

Use for:
- Application orchestration calling adapters
- Persistence layer interactions (with test DB)
- External providers via sandbox/mocks

### 2.4 End-to-end tests
**Purpose**: validate the whole system flow.

Use sparingly:
- Critical “happy paths”
- Key error paths

---

## 3) Traceability (required)

Every meaningful test should be traceable to:
- A scenario in `/Coverages/FUNCTIONAL_REQUIREMENTS.md`, and/or
- An edge case in `/Coverages/EDGE_CASES_AND_BOUNDARY_CONDITIONS.md`, and/or
- A contract in `/Documentations/DATA_MODELS_AND_CONTRACTS.md`.

Recommended: add a comment/header in each test file:
- Scenario link(s):
- Contract link(s):

---

## 4) Test naming conventions

### File naming
- `test_<module>.py` or `<module>_test.py` (pick one)

### Test naming
- `test_<behavior>_<condition>_<expected_result>`

Examples:
- `test_validate_order_missing_symbol_raises_validation_error`
- `test_risk_budget_zero_equity_returns_zero_budget`

---

## 5) Test data strategy

### Principles
- Prefer minimal fixtures.
- Use factories/builders for complex objects.
- Avoid brittle snapshots unless needed.

### Standard test data builders (recommended)
- `make_valid_<thing>()`
- `make_<thing>_with_<variant>()`

---

## 6) Mocking strategy

### What to mock
- External systems (HTTP, DB, filesystem)
- Time
- Randomness

### What NOT to mock
- Your own domain logic
- Small pure functions

### Ports/adapters
- Mock ports in application tests.
- Use a fake adapter for integration tests when possible.

Link to: `/code/INTERFACES_AND_PORTS_TEMPLATE.md`.

---

## 7) Performance testing (lightweight)

### When to add perf tests
- Hot path modules
- Batch processing loops
- External IO heavy operations

### What to measure
- Runtime latency
- Throughput
- Memory usage (optional)

Link to: `/Coverages/PERFORMANCE_REQUIREMENTS.md`.

---

## 8) Flaky test policy

If a test is flaky:
1. Quarantine it (mark, isolate, or temporarily skip with an issue link).
2. Fix root cause.
3. Remove quarantine.

Rule: don’t normalize flakiness.

---

## 9) Local commands (fill in)

```bash
# unit
make test-unit

# integration
make test-integration

# all
make test

# coverage
make coverage
```

---

## 10) CI expectations

CI must enforce:
- Lint/typecheck before tests
- All tests on every PR
- Coverage thresholds (as defined)
- Contract tests (if you have them)

Link to: `/Documentations/BUILD_AND_DEPLOY.md`.

---

## 11) Debugging failing tests

- Use `/Tutorial/DEBUGGING_AND_TROUBLESHOOTING.md`.
- Confirm the failing test is aligned with the correct scenario/contract.
- Check for contract drift when DTOs change.

---

## 12) Checklist (for PRs)

- [ ] Unit tests added for new logic.
- [ ] Edge cases covered.
- [ ] Contract tests updated when contracts change.
- [ ] Integration tests updated when boundaries change.
- [ ] Tests are deterministic (no flakiness).
- [ ] Tests trace back to `/Coverages/*` and/or contracts.


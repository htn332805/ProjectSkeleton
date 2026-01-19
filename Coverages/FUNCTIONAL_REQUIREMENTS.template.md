# FUNCTIONAL_REQUIREMENTS
Use cases + acceptance criteria, ideally in Given/When/Then.

> Canonical list of functional scenarios the system must support.
>
> Format: scenarios should be testable, traceable, and written in plain language.

---

## 1) How to use this document

### Rules
- Every implemented capability must map to one or more scenarios.
- Each scenario must have acceptance criteria.
- If behavior changes, update the scenario and the tests.

### Traceability
For each scenario, include links to:
- Module template(s) in `/code/*_template.md`
- Related edge cases in `/Coverages/EDGE_CASES_AND_BOUNDARY_CONDITIONS.md`
- Relevant contracts in `/Documentations/DATA_MODELS_AND_CONTRACTS.md`

---

## 2) Requirement status tags

Use one:
- `Proposed`
- `Planned`
- `In progress`
- `Implemented`
- `Deprecated`

---

## 3) Scenario template (copy/paste)

```markdown
### FR-XXXX: <Scenario title>

- Status: Proposed | Planned | In progress | Implemented | Deprecated
- Priority: P0 | P1 | P2 | P3
- Owner:
- Last updated: YYYY-MM-DD

#### Description
(1–3 sentences describing the user-facing capability.)

#### Given / When / Then
- Given: <initial context>
- When: <trigger/event>
- Then: <expected outcome>

#### Acceptance criteria
- [ ] Criterion 1
- [ ] Criterion 2

#### Inputs
- Input A:
  - Constraints:

#### Outputs
- Output A:
  - Constraints:

#### Errors (expected)
- `ValidationError` when ...
- `NotFoundError` when ...

#### Non-functional notes
- Performance:
- Reliability:
- Security:

#### Traceability
- Module templates:
  - /code/<module>_template.md
- Contracts:
  - /Documentations/DATA_MODELS_AND_CONTRACTS.md#...
- Tests:
  - (path or reference)
- Related edge cases:
  - /Coverages/EDGE_CASES_AND_BOUNDARY_CONDITIONS.md#...
```

---

## 4) Scenarios

> Group scenarios by feature/domain area.

## Feature area: <name>

### FR-0001: <Scenario title>

- Status: Proposed
- Priority: P0
- Owner:
- Last updated: YYYY-MM-DD

#### Description

#### Given / When / Then
- Given:
- When:
- Then:

#### Acceptance criteria
- [ ] 

#### Inputs

#### Outputs

#### Errors (expected)

#### Non-functional notes

#### Traceability

---

## 5) Cross-cutting requirements (optional)

These are functional requirements that span multiple features.

- Audit logging behavior
- Idempotency behavior
- Retry semantics

---

## 6) Change log

- YYYY-MM-DD — Added FR-____
- YYYY-MM-DD — Updated FR-____ (behavior change)
- YYYY-MM-DD — Deprecated FR-____


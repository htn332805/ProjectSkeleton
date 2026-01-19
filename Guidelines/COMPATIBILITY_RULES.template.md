# COMPATIBILITY_RULES
API stability, deprecation, versioning policy.
> Non-negotiable compatibility and versioning rules.
>
> Goal: prevent accidental breaking changes and make evolution predictable.

---

## 1) Scope

These rules apply to:
- Public APIs
- Module-to-module contracts
- Stored data formats
- External integrations

---

## 2) Versioning scheme

Use Semantic Versioning (recommended):
- MAJOR: breaking changes
- MINOR: backward-compatible additions
- PATCH: backward-compatible fixes

Define how versions are represented:
- API versions: (e.g., v1, v2)
- Package versions:
- Contract versions:

---

## 3) What counts as “public”

A thing is public if:
- Another module depends on it, or
- Another team/system depends on it, or
- It is referenced in `/Documentations/API_REFERENCE.md`

---

## 4) Backward-compatible changes (allowed)

Examples:
- Add an optional field to a DTO
- Add a new API method
- Add a new enum value (if consumers tolerate unknown)
- Fix a bug without changing contract semantics

---

## 5) Breaking changes (must be explicit)

Examples:
- Remove/rename fields
- Change field types
- Change semantics of existing fields
- Remove API endpoints/methods
- Change error behavior in a way that breaks callers

Breaking changes require:
- Version bump
- Migration guide
- Deprecation period

---

## 6) Deprecation policy

### Minimum deprecation window
- (e.g., 2 minor versions or 90 days)

### Deprecation requirements
- Mark deprecated API/contract clearly.
- Provide replacement.
- Provide migration steps.
- Track in:
  - `/Coverages/BACKWARD_COMPATIBILITY_MATRIX.md`
  - `/CHANGELOG.md`

---

## 7) Contract evolution rules

### DTO evolution
- Prefer additive changes.
- Avoid changing meaning of existing fields.

### Error behavior evolution
- Errors are part of the contract.
- New error types must be documented.

Link to: `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`.

---

## 8) Testing requirements

- Contract tests required when contracts evolve.
- Backward compatibility tests required for breaking changes.

Link to: `/Guidelines/TESTING_STANDARDS.md`.

---

## 9) Documentation requirements

When changing a public interface/contract:
- Update `/Documentations/API_REFERENCE.md`
- Update `/Documentations/DATA_MODELS_AND_CONTRACTS.md`
- Update `/Coverages/BACKWARD_COMPATIBILITY_MATRIX.md`
- Update `/CHANGELOG.md`

---

## 10) Governance

If compatibility rules must be violated:
- Write an ADR.
- Get approval.
- Provide a migration plan.

Link to: `/Documentations/DECISIONS_ADR_LOG.md`.

---

## 11) Review checklist

- [ ] Public vs internal classified correctly.
- [ ] Change categorized as compatible or breaking.
- [ ] Version bump appropriate.
- [ ] Migration guide provided if breaking.
- [ ] Deprecation window honored.
- [ ] Tests updated.
- [ ] Docs updated.


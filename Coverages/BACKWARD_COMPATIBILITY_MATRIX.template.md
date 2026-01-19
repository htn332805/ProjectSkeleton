# BACKWARD_COMPATIBILITY_MATRIX
Versioning promises, breaking change rules, migration expectations.
> Defines compatibility guarantees across versions for APIs, contracts, and stored data.
>
> Goal: prevent accidental breaking changes and make migrations explicit.

---

## 1) How to use this document

### Rules
- Any change to a public API or contract must update this matrix.
- Breaking changes must include a migration plan and deprecation timeline.
- Prefer backward-compatible evolution wherever possible.

### Primary links
- Compatibility rules: `/Guidelines/COMPATIBILITY_RULES.md`
- API reference: `/Documentations/API_REFERENCE.md`
- Data contracts: `/Documentations/DATA_MODELS_AND_CONTRACTS.md`
- Changelog: `/CHANGELOG.md`

---

## 2) Compatibility policy (summary)

- API stability level: (experimental/stable)
- Deprecation window: (e.g., 2 minor versions or 90 days)
- Versioning scheme: (SemVer recommended)

---

## 3) Compatibility matrix (high level)

> Track compatibility between producer/consumer versions or API versions.

### 3.1 API compatibility

| API / Contract | Current version | Compatible with | Breaking changes introduced in | Migration notes |
|---|---:|---|---|---|
| `<api_or_contract>` | v1 | v1.x | v2.0.0 | Use new field `...` |

### 3.2 Data format compatibility

| Data store / format | Format version | Readers compatible with | Writers compatible with | Notes |
|---|---:|---|---|---|
| `<store>` | v1 | v1.x | v1.x |  |

---

## 4) Contract change log

Track changes to contracts over time.

### Contract: `<ContractName>`

| Version | Date | Change type | Description | Breaking? | Migration |
|---:|---|---|---|---:|---|
| v1 | YYYY-MM-DD | Added | Initial schema | No | N/A |

---

## 5) Deprecations

### Deprecation template

```markdown
#### Deprecation: <name>
- Introduced: vX.Y.Z
- Deprecated: vX.Y.Z
- Removal target: vX.Y.Z (or date)
- Replacement: <new API/contract>
- Migration steps:
  1. ...
  2. ...
- Notes:
```

---

## 6) Migration guides

For each breaking change, provide a short guide.

### Migration: `<from>` → `<to>`

- Who is affected:
- What changes:
- Step-by-step:
  1. ...
  2. ...
- Validation:
- Rollback plan:

---

## 7) Testing requirements for compatibility

- Contract tests for schema evolution.
- Compatibility tests for multiple versions (if applicable).
- Golden payload tests.

Link to: `/Guidelines/TESTING_STANDARDS.md`.

---

## 8) Change control checklist

When changing an API/contract:
- [ ] Update `/Documentations/API_REFERENCE.md`.
- [ ] Update `/Documentations/DATA_MODELS_AND_CONTRACTS.md`.
- [ ] Update this matrix.
- [ ] Add/adjust contract tests.
- [ ] Add changelog entry.


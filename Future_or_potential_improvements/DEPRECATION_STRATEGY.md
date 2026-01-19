# DEPRECATION_STRATEGY
> Policy and workflow for deprecating APIs, features, modules, or data formats.
>
> Goal: evolve the system safely while maintaining trust with users and preserving compatibility where required.

---

## 1) Scope

This strategy applies to:
- Public APIs (HTTP, SDKs)
- CLI commands and flags
- Configuration keys
- Data schemas / serialized formats
- Modules used by other internal teams/services

---

## 2) Deprecation principles

- Prefer additive change over breaking change.
- Deprecation is a process, not an event.
- Provide clear migration paths.
- Communicate early and repeatedly.
- Track usage before removal.

Link:
- `/Guidelines/COMPATIBILITY_RULES.md`

---

## 3) Deprecation levels

Use consistent terminology:

- **Soft deprecation:** discouraged but still supported; no warnings by default.
- **Hard deprecation:** warnings emitted; migration guidance published; removal scheduled.
- **Removal:** deprecated element removed after the planned window.

---

## 4) Standard deprecation timeline

Define defaults (edit to fit your release cadence):
- Soft deprecation: release N
- Hard deprecation: release N+1
- Removal: release N+2 (or after X weeks)

Exceptions:
- Security issues may require faster timelines.
- Regulatory constraints may require longer support windows.

---

## 5) Deprecation workflow

### 5.1 Proposal
- What is being deprecated?
- Why (maintenance cost, security, performance, product direction)?
- Who is impacted?
- What is the replacement?

### 5.2 Acceptance
- Approvers:
- Decision date:
- Deprecation level:
- Timeline:

### 5.3 Implementation
- Add deprecation annotations/warnings.
- Add migration docs.
- Add tests for both old and new paths during the overlap.

### 5.4 Communication
- Update changelog/release notes.
- Notify internal/external users.
- Provide examples and migration scripts if needed.

### 5.5 Removal
- Remove code paths.
- Remove docs for deprecated features.
- Validate no remaining usage.

---

## 6) Deprecation item template

Copy/paste for each deprecation.

### Deprecation: <name>

- Type: (API/CLI/config/schema/module)
- Status: (proposed/soft/hard/removed)
- Owner:
- First deprecation release:
- Planned removal release/date:

**Context**
- Why deprecate:
- Replacement:

**Impact**
- Affected users/systems:
- Breaking risk:

**Migration guidance**
- Steps:
- Examples:
- Tooling/scripts:

**Instrumentation and usage tracking**
- How will usage be measured?
- Current usage baseline:
- Removal gate (what must be true to remove):

**Risks and mitigations**
- 

**Evidence**
- PRs:
- Docs:
- Metrics:

---

## 7) Compatibility and versioning rules

- Prefer backwards compatible changes.
- If breaking change is unavoidable, follow the formal process.
- Version schemas/APIs when appropriate.

Link:
- `/Guidelines/COMPATIBILITY_RULES.md`

---

## 8) Documentation requirements

When deprecating:
- Update `/Documentations/API_REFERENCE.md`.
- Update tutorials and examples.
- Add migration guides.

Link:
- `/Guidelines/DOCUMENTATION_STANDARDS.md`

---

## 9) Change log

- YYYY-MM-DD — Created/updated deprecation strategy.



# DESIGN_PRINCIPLES
SRP, SOLID application, boundaries, dependency inversion rules.
> Non-negotiable design and architecture principles for this project.
>
> Goal: enforce modularity, extensibility, traceability, debugability, and safe refactoring.

---

## 1) Scope

These principles apply to:
- Module boundaries
- Class/function design
- Dependency management
- Refactoring decisions
- Public APIs and data contracts

---

## 2) Core principles (non-negotiable)

### 2.1 Single Responsibility (SRP)
- Each module/class has one primary reason to change.
- Every module template must include:
  - SRP statement
  - explicit non-responsibilities

Link to: `/code/MODULE_TEMPLATE.md`.

### 2.2 Separation of concerns
- Domain logic is isolated from IO.
- Orchestration is separated from computation.

### 2.3 Dependency direction
- Keep dependency direction clean:
  - `adapters → application → core`
  - `interfaces` may be used by all

Link to: `/code/MODULARIZATION_PATTERNS.md`.

### 2.4 Explicit contracts
- Any cross-module data shape must be documented.
- Public APIs must have explicit inputs/outputs and error behavior.

Link to: `/Documentations/DATA_MODELS_AND_CONTRACTS.md`.

### 2.5 Small, atomic units
- Prefer many small testable units over few large ones.
- Enforce complexity limits.

Link to: `/code/GRANULAR_ATOMIC_UNITS_GUIDE.md`.

---

## 3) SOLID (applied to this repo)

### S — Single Responsibility
(Already defined above)

### O — Open/Closed
- Add new behavior by adding new modules/strategies, not by editing core code.

### L — Liskov Substitution
- Implementations of a port must be interchangeable.

### I — Interface Segregation
- Ports should be small and focused.

### D — Dependency Inversion
- High-level policies depend on abstractions.
- Adapters implement ports.

Link to: `/code/INTERFACES_AND_PORTS_TEMPLATE.md`.

---

## 4) API design principles

- Minimize public surface area.
- Make error behavior predictable.
- Make contracts stable and versioned.

Links:
- `/Documentations/API_REFERENCE.md`
- `/Guidelines/COMPATIBILITY_RULES.md`
- `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`

---

## 5) State management principles

- Avoid shared mutable state.
- Prefer pure functions where possible.
- If state exists, define lifecycle and ownership clearly.

---

## 6) Observability by design

- Major workflows must emit logs/metrics/traces.
- Domain logic should not be polluted with logging.

Link to: `/Documentations/OBSERVABILITY_LOGGING_TRACING.md`.

---

## 7) Refactoring principles

- Refactoring is incremental.
- Never refactor without tests.
- Refactoring must not change behavior.

Link to: `/Refactoring_Approach/REFACTORING_FRAMEWORK.md`.

---

## 8) Trade-off rules

If two principles conflict:
1. Preserve correctness and safety first.
2. Preserve clean boundaries second.
3. Optimize performance third.

Document exceptions as ADRs.

Link to: `/Documentations/DECISIONS_ADR_LOG.md`.

---

## 9) Review checklist

- [ ] SRP statement exists.
- [ ] Boundaries are explicit.
- [ ] Dependency direction preserved.
- [ ] Contracts documented.
- [ ] Errors mapped to taxonomy.
- [ ] Tests exist.
- [ ] Observability considered.



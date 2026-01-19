# MODULARIZATION_PATTERNS
How to slice modules, avoid cycles, dependency rules, extension patterns.
## Patterns
> Practical patterns for designing modules that are scalable, extensible, traceable, debuggable, and parallelizable.
>
> This file is not “theory.” It defines how *this project* modularizes work and prevents architectural drift.

---

## 1) Goals

- Keep modules small and single-purpose.
- Prevent cyclic dependencies.
- Enable parallel development (teams can work without stepping on each other).
- Make refactoring safe (changes are localized).
- Make contracts explicit (inputs/outputs and invariants are documented).

## 2) Module types (standard vocabulary)

Use these categories consistently in docs and code.

- **Domain module (core)**: pure business rules, invariants, deterministic logic.
- **Use-case module (application)**: orchestration, workflows, transactions.
- **Adapter module (adapters)**: IO boundaries (APIs, DB, queues, files, external services).
- **Infrastructure module (infra)**: cross-cutting concerns (config, logging, tracing, metrics).
- **Interface/contract module (interfaces)**: protocols/DTOs/contracts meant to remain stable.

Link to: `/code/CODE_ORGANIZATION_STRUCTURE.md`.

## 3) Dependency direction (non-negotiable)

Allowed direction (typical):

`adapters → application → core`

Contracts/interfaces may be depended upon by all layers:

`(adapters, application, core) → interfaces`

### Rules
- `core` must not depend on `adapters` or `infra`.
- `application` must not depend on concrete adapter implementations.
- Adapters implement interfaces/ports and are injected into application services.

## 4) Boundary patterns

### Pattern A: Ports & Adapters (recommended default)

**Use when**: you have IO/external integrations.

- Define a **port** (interface/protocol) in `interfaces/`.
- Implement it in `adapters/`.
- Inject it into `application/`.
- Keep `core/` pure.

**Benefits**:
- Swap implementations without touching domain logic.
- Easier testing (mock ports).
- Prevents dependency inversion violations.

**Template references**:
- Use `/code/MODULE_TEMPLATE.md` to describe ports and adapters.

### Pattern B: Vertical slice (feature folder)

**Use when**: a feature is end-to-end and mostly independent.

Organize by feature:
- `features/<feature>/core`
- `features/<feature>/application`
- `features/<feature>/adapters`

**Rule**: Even within a feature slice, preserve layer boundaries.

### Pattern C: Shared kernel (careful)

**Use when**: multiple features share true domain concepts.

- Put shared domain concepts in `core/` (or `core/shared/`).
- Keep it small.

**Avoid**: creating a dumping ground that becomes a dependency magnet.

## 5) Decomposition heuristics (how to split modules)

### Heuristic 1: Split by “reason to change”
If a module changes for multiple reasons, split it.

Examples:
- Business rule changes vs. integration contract changes → separate `core` and `adapters`.
- Validation rules vs. orchestration flow → separate validator and use-case.

### Heuristic 2: Split by stability
- Stable contracts → `interfaces/`
- Volatile integrations → `adapters/`

### Heuristic 3: Split by runtime behavior
- CPU-bound deterministic logic → `core`
- IO-bound logic → `adapters`
- Coordination and retries → `application` (or adapter if purely IO concern)

## 6) Preventing cyclic dependencies

### Techniques
- Dependency injection via interfaces/ports.
- Move shared DTOs/contracts to `interfaces/`.
- Introduce a small mediator in `application/`.
- Extract utility logic into a dedicated `core` module (not `utils/`).

### Rule
If a cycle appears, treat it as a **design failure** and refactor before adding more features.

## 7) Public API minimization

### Rules
- Every module has a small public surface.
- Export only what must be used externally.
- Prefer fewer, richer functions over many tiny wrappers.

### Contract documentation
Public APIs must be documented in module templates:
- `/code/<module>_template.md`

## 8) Versioning and deprecation

### When to version
Version when you:
- Change contract shape
- Change semantics
- Introduce breaking behavior

### Deprecation rules
- Mark deprecated APIs clearly.
- Provide migration path.
- Track timelines.

Link to: `/Guidelines/COMPATIBILITY_RULES.md`.

## 9) Patterns for extensibility

### Pattern: Strategy
Use when behavior varies by configuration or market/instrument.

- Define an interface (strategy contract).
- Provide multiple implementations.
- Select at runtime via configuration.

### Pattern: Plugin/Registry
Use when third-party or user extensions are expected.

- Define plugin interface.
- Provide discovery/registration mechanism.
- Enforce sandboxing/security boundaries.

Link to: `/Future_or_potential_improvements/EXTENSIBILITY_FRAMEWORK.md`.

## 10) Observability boundaries

### Rule
Observability must not leak into domain logic.

Recommended approach:
- Domain emits structured events (pure data).
- Application/infra converts events into logs/metrics/traces.

## 11) Examples (fill in with your project)

### Example 1: New external integration
- Port defined in `interfaces/`.
- Adapter implemented in `adapters/`.
- Use-case updated in `application/`.
- No changes required in `core/`.

### Example 2: Refactoring a “god module”
- Extract validators (core)
- Extract orchestrator (application)
- Extract IO (adapters)
- Update templates and contracts

## 12) Review checklist

- [ ] Module type is clear (core/application/adapter/infra/interface).
- [ ] Dependency direction obeyed.
- [ ] No cycles introduced.
- [ ] Public API minimized and documented.
- [ ] Data contracts are explicit.
- [ ] Extensibility points are intentional.
- [ ] Observability does not pollute domain logic.


# CODE_ORGANIZATION_STRUCTURE
Directory conventions, naming, boundaries, and where things go.
## Directory tree
> Defines how implemented code should be organized under `/code/` (directory structure, naming conventions, boundaries, and dependency rules).

## 1) Goals

This structure is optimized for:
- Scalability (many modules without chaos)
- Extensibility (easy to add features)
- Traceability (requirements → code → tests → docs)
- Debuggability (clear ownership and boundaries)
- Parallel development (minimal coupling)

## 2) Directory tree (recommended)

Adapt as needed, but keep the principles intact.

```
/code
  /core                # Domain concepts, invariants, pure logic
  /application         # Use-cases / orchestration, workflow coordination
  /adapters            # IO boundaries (APIs, DB, files, external services)
  /infra               # Cross-cutting infrastructure (logging, config)
  /interfaces          # Protocols/ports (public contracts)
  /utils               # Small, pure helpers (use sparingly)
  /tests               # Tests (unit/integration/e2e) - or mirror structure under /tests
```

### When to create a new top-level directory
Create a new folder only when:
- It represents a distinct architectural layer, or
- It is a product boundary (e.g., plugin system), and
- It reduces coupling rather than increasing it.

## 3) Naming conventions

### Folder names
- Use `snake_case`.
- Use domain-oriented names when possible (prefer `portfolio`, `orders`, `pricing` over `misc`).

### Module/file names
- Use `snake_case.py` (or language-equivalent).
- Keep names descriptive and stable.
- Avoid generic names like `helpers`, `common`, `stuff`.

### Class names
- Use `PascalCase`.
- Prefer role-based names: `OrderValidator`, `TradeSignalGenerator`.

### Function/method names
- Use `snake_case`.
- Prefer verb + object: `calculate_risk_budget`, `validate_order`.

## 4) Layer responsibilities (boundaries)

### `core/` (Domain)
- Contains domain rules and invariants.
- Avoids IO.
- Ideally pure and deterministic.

### `application/` (Use-cases)
- Orchestrates workflows.
- Coordinates multiple domain services.
- Handles transaction boundaries.

### `adapters/` (IO)
- Implements gateways to external systems.
- Contains serialization/deserialization.
- Contains retry/circuit-breaker logic when interacting with external services.

### `infra/` (Cross-cutting)
- Logging/tracing configuration.
- Config management.
- Background job runners.

### `interfaces/`
- Public contracts: protocols, interfaces, DTOs.
- Anything that must remain stable or versioned.

### `utils/`
- Small utilities only.
- If `utils/` grows, refactor into real modules.

## 5) Dependency rules (non-negotiable)

To keep the system modular and parallelizable:

- `core/` depends on nothing (or only other `core/`).
- `application/` may depend on `core/` and `interfaces/`.
- `adapters/` may depend on `interfaces/` and `application/` (carefully), but should not leak details into `core/`.
- `infra/` supports the rest; avoid making `core/` depend on `infra/`.

### Prohibited
- Cyclic imports/dependencies.
- `core/` importing `adapters/`.
- Hidden cross-module coupling via globals or side effects.

Link to: `/code/MODULARIZATION_PATTERNS.md`.

## 6) How to add a new feature/module

1. Add scenarios to `/Coverages/FUNCTIONAL_REQUIREMENTS.md`.
2. Add edge cases to `/Coverages/EDGE_CASES_AND_BOUNDARY_CONDITIONS.md`.
3. Create a module template in `/code/<module>_template.md` (no implementation code).
4. Decide which layer it belongs to (`core`, `application`, `adapters`, etc.).
5. Implement incrementally with tests.
6. Update docs and evaluation.

## 7) Shared code policy

### Avoid “common” dumping grounds
- If multiple features share logic, define a proper shared module with a clear responsibility.

### Preferred approach
- Extract shared code to `core/` if it is domain logic.
- Extract shared code to `interfaces/` if it is a stable contract.
- Extract shared code to `infra/` if it is cross-cutting infrastructure.

## 8) Test organization

Choose one:

### Option A: Mirror under `/tests/`
- Keep production code under `/code/`.
- Keep tests under `/tests/` mirroring the structure.

### Option B: Co-locate tests
- Tests live next to the module they test.

Rule: Pick one strategy and enforce it consistently.

Link to: `/Guidelines/TESTING_STANDARDS.md`.

## 9) Observability and debug conventions

- Every major module should have consistent logging context (trace_id, module, request_id).
- Avoid silent failures.
- Errors should be typed and categorized.

Link to: `/Guidelines/ERROR_HANDLING_STRATEGY.md`.

## 10) Anti-patterns to avoid

- “Mega modules” with many responsibilities.
- `utils/` becoming a second `core/`.
- Tight coupling through shared mutable state.
- Data contracts defined implicitly in code rather than in docs.

## 11) Checklist (for new modules)

- [ ] Module has a single clear responsibility.
- [ ] Module location matches its architectural layer.
- [ ] Dependencies follow the allowed direction.
- [ ] Public API documented in a template (`/code/*_template.md`).
- [ ] Tests added per `/Guidelines/TESTING_STANDARDS.md`.
- [ ] Documentation updated as needed (`/Documentations/*`, `/Tutorial/*`).

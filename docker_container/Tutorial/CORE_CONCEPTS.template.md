# CORE_CONCEPTS
The mental model: modules, boundaries, contracts, invariants.
> The mental model for this project.
>
> Goal: teach how this repo is organized and how to design/implement modules safely and consistently.

---

## 1) What this project optimizes for

- Modular, single-responsibility components
- Traceability (requirements → design → implementation → tests → evaluation)
- Debuggability (observability + consistent error semantics)
- Parallel development (low coupling, clear boundaries)
- Safe refactoring (incremental change, strong validation)

---

## 2) The documentation-first loop

This project uses a consistent loop:

1. **Coverage** (`/Coverages/`) — defines scenarios and acceptance criteria
2. **Templates** (`/code/`) — defines module boundaries and contracts
3. **Implementation** — code that matches the template
4. **Testing** — proof of correctness and regression prevention
5. **Documentation** (`/Documentations/`, `/Tutorial/`) — keeps system navigable
6. **Evaluation** (`/Project_implementation_evaluation/`) — measures quality over time

### Why this loop matters
- It prevents “code-first drift” where architecture becomes accidental.
- It enables AI-assisted work because context is explicit.

---

## 3) Atomic units

### Definition
An **atomic unit** is the smallest meaningful component that:
- Has one primary responsibility
- Has explicit inputs/outputs
- Is testable in isolation

Link: `/code/GRANULAR_ATOMIC_UNITS_GUIDE.md`.

### Example
- Good: `RiskBudgetCalculator.calculate_budget(...)`
- Bad: `TradingSystem.run_everything(...)`

---

## 4) Module boundaries and layers

### Standard layers
- **core**: domain logic, invariants, deterministic computation
- **application**: orchestration/use-cases, workflow coordination
- **adapters**: external IO integrations (API/DB/queues/files)
- **infra**: cross-cutting tooling (config/logging/tracing)
- **interfaces**: stable contracts and ports

Link: `/code/CODE_ORGANIZATION_STRUCTURE.md`.

### Dependency direction (rule)
- `adapters → application → core`
- `interfaces` may be used by all

Link: `/code/MODULARIZATION_PATTERNS.md`.

---

## 5) Contracts (data + API)

### Data contracts
A **data contract** is a schema exchanged across module boundaries.

- Defined in: `/Documentations/DATA_MODELS_AND_CONTRACTS.md`
- Tested via: contract tests (see `/Guidelines/TESTING_STANDARDS.md`)

### API contracts
A module’s public API must be documented in:
- `/code/<module>_template.md`
- `/Documentations/API_REFERENCE.md` (if public/stable)

---

## 6) Ports & adapters

### What it is
A **port** is an interface/protocol that defines what the system needs.
An **adapter** is a concrete implementation that talks to external systems.

### Why it matters
- Keeps domain logic independent of external details.
- Makes testing easy (mock ports).
- Enables swapping providers without rewriting core logic.

Link: `/code/INTERFACES_AND_PORTS_TEMPLATE.md`.

---

## 7) Error taxonomy

### Rule
Errors must be typed and categorized so callers know what to do.

- Canonical catalog: `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`
- Handling strategy: `/Guidelines/ERROR_HANDLING_STRATEGY.md`

### Example categories
- Validation
- External dependency
- Timeout
- Invariant violation

---

## 8) Observability

### What “observable” means here
A module is observable if:
- It logs key lifecycle events (with context fields)
- It emits metrics for health and performance
- It supports tracing across boundaries

Link: `/Documentations/OBSERVABILITY_LOGGING_TRACING.md`.

---

## 9) Refactoring philosophy

### Definition
Refactoring improves structure **without changing behavior**.

### Rules
- Must be incremental and validated.
- Must not violate `/Guidelines/*`.
- Must update templates/docs if interfaces move.

Link: `/Refactoring_Approach/REFACTORING_FRAMEWORK.md`.

---

## 10) Evaluation (how quality is measured)

This project treats quality as measurable.

- Project overview: `/Project_implementation_evaluation/PROJECT_OVERVIEW.md`
- Scoring: `/Project_implementation_evaluation/Scoring_criteria/PROJECT_EVALUATION_SCORE.md`

---

## 11) Quick checklist (use before implementing)

- [ ] Scenario exists in `/Coverages/*`.
- [ ] Module template exists in `/code/*_template.md`.
- [ ] Data contracts updated if needed.
- [ ] Error behavior is mapped to the catalog.
- [ ] Observability requirements are stated.
- [ ] Tests are planned.


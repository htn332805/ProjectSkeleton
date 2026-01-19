# GRANULAR_ATOMIC_UNITS_GUIDE
Definition of “atomic unit” + SRP rules + coupling limits.
## Definition

## Constraints

> Defines what “small, granular, atomic units” mean in this project.
>
> Goal: maximize modularity, traceability, testability, parallel development, and safe refactoring.

---

## 1) Why atomic units?

Atomic units reduce risk and complexity by ensuring:
- Each unit is easy to understand.
- Each unit is independently testable.
- Changes are localized (low blast radius).
- Refactoring can be incremental.
- Work can be parallelized across teams/modules.

## 2) Definitions (project-specific)

### Atomic unit
An **atomic unit** is the smallest component that:
- Has a single, clearly stated responsibility.
- Has a stable, documented interface.
- Can be tested in isolation.
- Can be reused without hidden coupling.

Atomic units can be:
- A function
- A method
- A class
- A small module/package

### Single Responsibility (SRP) in this project
A unit has SRP if it has **one primary reason to change**.

Examples of “reasons to change”:
- Business rule changes
- Input validation rules
- Integration contract changes
- Performance constraints

## 3) Size and complexity limits (guardrails)

These are guidelines; stricter is usually better.

### Functions/methods
- Max length: ___ lines (recommend: 20–40)
- Max cyclomatic complexity: ___ (recommend: 5–10)
- Max number of parameters: ___ (recommend: 3–5)

### Classes
- Max public methods: ___ (recommend: 5–10)
- Max responsibilities: 1 (non-negotiable)

### Modules
- Max exported symbols: keep minimal
- Must have a clear boundary and purpose statement

## 4) Cohesion and coupling rules

### High cohesion checklist
- The unit’s methods operate on the same concept/state.
- Method names share a consistent domain vocabulary.
- The unit can be described in one sentence.

### Low coupling checklist
- No hidden dependencies (globals, implicit config).
- Dependencies are injected (not constructed internally).
- Unit does not reach into internals of other units.
- Data passed between units uses explicit contracts.

## 5) What belongs where (unit types)

### Pure functions
Use for:
- Deterministic computations
- Transformations
- Validation logic (when no IO)

Avoid when:
- The function needs many dependencies or shared state.

### Classes
Use for:
- Managing state with clear lifecycle
- Encapsulating a workflow step
- Providing a small, coherent interface over related behavior

Avoid when:
- A single class becomes a “god object”

### Modules/packages
Use for:
- Grouping related atomic units that together form one capability
- Defining a stable boundary

## 6) How to split a unit (refactoring rules)

If a unit violates SRP, split by:

1. **Reason to change**
   - Extract business rules vs. IO vs. orchestration.

2. **Layer separation**
   - Domain logic → `core/`
   - Use-case orchestration → `application/`
   - IO/integrations → `adapters/`

3. **Data contract boundaries**
   - If the unit transforms data shapes, define a contract in `/Documentations/DATA_MODELS_AND_CONTRACTS.md`.

Link to: `/Refactoring_Approach/REFACTORING_PATTERNS.md`.

## 7) Traceability requirements

Every atomic unit should be traceable to at least one of:
- A scenario in `/Coverages/FUNCTIONAL_REQUIREMENTS.md`
- An edge case in `/Coverages/EDGE_CASES_AND_BOUNDARY_CONDITIONS.md`
- A guideline requirement in `/Guidelines/*`
- A future work item in `/Future_or_potential_improvements/*`

Recommended: include a short “Traceability” note in the unit’s docstring or module template.

## 8) Examples

### Example A: Good atomic unit (function)
- Responsibility: “Validate an order payload for required fields and constraints.”
- Inputs: `order_payload`
- Output: `ValidatedOrder` or raises `ValidationError`
- Tests: boundary values + missing fields

### Example B: Bad atomic unit
- Responsibility: “Validate order, fetch market data, calculate risk, place trade, log metrics.”
- This should be split into:
  - Validator (pure)
  - MarketDataClient (adapter)
  - RiskCalculator (core)
  - ExecutionService (application)
  - Observability helpers (infra)

## 9) Anti-patterns (prohibited or strongly discouraged)

- God objects (many responsibilities)
- Hidden IO (functions that secretly read files/network)
- Implicit global config
- Shared mutable state across unrelated units
- “Utils dump” modules that accumulate unrelated helpers

## 10) Review checklist (use in PRs)

- [ ] SRP statement is clear.
- [ ] Unit is small and cohesive.
- [ ] Dependencies are explicit (injected).
- [ ] No cyclic dependencies introduced.
- [ ] Contracts are documented (if data crosses module boundaries).
- [ ] Unit is testable in isolation.
- [ ] Edge cases are covered.
- [ ] Observability and error behavior are explicit.


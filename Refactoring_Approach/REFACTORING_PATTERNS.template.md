# REFACTORING_PATTERNS
Allowed refactor patterns + examples.
> A curated playbook of common refactoring patterns used in this repository.
>
> Goal: standardize how refactors are executed so changes are predictable, reviewable, and safe.

---

## 1) How to use this playbook

For a refactor, pick one or more patterns below and document:
- Which pattern(s) are used
- Which modules are affected
- What tests prove behavior is unchanged

See:
- `/Refactoring_Approach/REFACTORING_FRAMEWORK.md`
- `/Refactoring_Approach/STEP_BY_STEP_PROCESS.md`

---

## 2) Safety rules (apply to all patterns)

- Always start from green tests.
- Prefer a series of small PRs over one large PR.
- Do not mix behavior changes with refactor changes.
- Preserve or explicitly migrate contracts (APIs, schemas, file formats).

---

## 3) Decomposition patterns

### Extract Function
Use when a function has multiple responsibilities or repeated logic.
- Steps: identify block → extract to a named function → keep signature stable → add tests.

### Extract Class / Module
Use when a file is too large or has multiple domains.
- Steps: define public surface → move cohesive code → update imports → keep behavior.

### Split by Responsibility (SRP)
Use when a unit mixes concerns (I/O + parsing + business logic).
- Approach: isolate pure logic from I/O first.

---

## 4) Interface and boundary patterns

### Introduce Interface (or Protocol)
Use when dependencies need to be inverted for testability.
- Steps: define interface → adapt existing impl → inject dependency.

### Dependency Injection
Use when a module constructs collaborators internally.
- Approach: pass dependencies as parameters or via factory.

### Facade
Use to provide a stable entry point while internals are restructured.
- Benefit: reduces blast radius.

---

## 5) Duplication and reuse patterns

### Consolidate Duplicate Logic
Use when similar blocks exist in multiple places.
- Steps: extract common helper → route callers → remove duplication.

### Parameterize Variation
Use when duplicate blocks differ by a small dimension.
- Approach: introduce parameter(s) or strategy function.

---

## 6) Data and model patterns

### Rename for Clarity
Use when names mismatch actual behavior.
- Rule: prefer mechanical rename tools; update docs/tests.

### Replace Primitive with Value Object
Use when primitives carry domain meaning (e.g., `symbol`, `currency`, `timestamp`).
- Benefit: reduces invalid states.

### Normalize Data Flow
Use when transformations are scattered.
- Approach: create an explicit pipeline: parse → validate → transform → store.

---

## 7) Control-flow patterns

### Replace Nested Conditionals
Use when branching is deep and hard to reason about.
- Options: guard clauses, dispatch tables, polymorphism.

### Early Returns (Guard Clauses)
Use to reduce indentation and clarify invalid states.

---

## 8) Error-handling patterns

### Standardize Error Types
Use when errors are inconsistent.
- Approach: introduce domain exceptions/errors and map at boundaries.

### Result Object
Use when exceptions are undesirable (e.g., batch processing).
- Provide: `ok`, `value`, `error`.

---

## 9) Performance-oriented refactors (structure-first)

### Optimize Hot Path After Measurement
- Rule: measure first.
- Keep a baseline perf test where possible.

### Cache at the Right Layer
- Prefer caching results of expensive pure computations.
- Ensure invalidation rules are explicit.

---

## 10) Migration patterns (when you must move things)

### Strangler Fig
Use to replace an old subsystem gradually.
- Steps: create new path → route a slice of traffic → expand → remove old.

### Parallel Run (Shadow)
Use to validate new output against old output.
- Steps: run both → compare → alert on diffs → cutover.

---

## 11) Anti-patterns to avoid

- “Big bang” refactor with no checkpoints.
- Renaming + logic changes + formatting changes in the same commit.
- Deleting code without proving it’s unused.
- Refactoring without updating docs/templates.

---

## 12) Pattern selection guide

Pick based on the pain:
- Hard to test → Introduce Interface, Dependency Injection.
- Too much duplication → Consolidate Duplicate Logic, Parameterize Variation.
- Too complex → Extract Function/Class, Replace Nested Conditionals.
- Risky migrations → Facade, Strangler Fig, Parallel Run.

---

## 13) Change log

- YYYY-MM-DD — Added/updated refactoring patterns.


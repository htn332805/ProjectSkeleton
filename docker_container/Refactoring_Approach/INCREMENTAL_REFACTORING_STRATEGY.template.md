# INCREMENTAL_REFACTORING_STRATEGY
Atomic commits, safe slices, parallel work guidance.
> Strategy document for safely refactoring large codebases without disruptive rewrites.
>
> Goal: enable continuous delivery while steadily improving architecture, testability, and maintainability.

---

## 1) Strategy overview

Incremental refactoring is a disciplined approach where changes are made in small slices, continuously validated, and gradually rolled out.

Use this approach when:
- The subsystem is business-critical.
- The code is hard to test or change.
- You cannot afford downtime or long-running branches.

---

## 2) Guiding principles

- Reduce risk by shrinking blast radius.
- Keep interfaces stable while internals change.
- Prefer mechanical changes (rename/move/extract) over logic changes.
- Add tests closest to the boundary first.
- Make refactoring progress visible with metrics.

---

## 3) Refactoring “slices” (unit of work)

A slice is a small, independently mergeable change that:
- can be reviewed in < 30 minutes
- has a clear rollback
- has tests that prove behavior remains unchanged

Examples:
- Extracting a helper function and adding unit tests.
- Introducing an interface for one dependency.
- Moving one coherent group of functions into a new module.

---

## 4) Stabilize boundaries first

### 4.1 Identify boundaries
- External API surface
- Data contracts (schemas, serialized formats)
- Integration points (DB, message bus, file I/O)

### 4.2 Add contract tests
- Validate inputs/outputs at boundaries.
- Freeze expected behavior before internal changes.

---

## 5) Make changes behind a stable facade

Use patterns like:
- Facade
- Adapter
- Strangler fig
- Feature flags (when behavior changes are planned)

Link to: `/Refactoring_Approach/REFACTORING_PATTERNS.md`.

---

## 6) Test strategy for incremental refactors

Priorities:
- Boundary/contract tests first (protect behavior).
- High-value unit tests second (increase change velocity).
- Integration/e2e tests for critical paths.

Rules:
- Every slice must keep tests green.
- If tests are missing, add them *before* structural work.

Link to: `/Guidelines/TESTING_STANDARDS.md`.

---

## 7) Rollout strategies (when risk is high)

Choose one:

### Parallel run (shadow)
- Run new and old side-by-side.
- Compare outputs.
- Alert on diffs.

### Canary rollout
- Gradually send a small % of traffic to the new path.
- Expand as confidence grows.

### Dark launch
- Enable new code path but keep it hidden to users.

---

## 8) Migration plan template

Fill in:
- Legacy component:
- Replacement component:
- Current entry points:
- New entry points:
- Cutover criteria:
- Rollback criteria:
- Target removal date for legacy:

---

## 9) Progress tracking (make it measurable)

Track at least one of:
- Complexity reduction (per module)
- Coverage improvement (for critical modules)
- Mean time to change (lead time)
- Incidents/defects in the subsystem

Link to: `/Refactoring_Approach/METRICS_AND_SUCCESS_CRITERIA.md`.

---

## 10) PR discipline

Each PR must include:
- Objective + slice description
- Tests executed
- Risk assessment + rollback
- Documentation changes (if any)

Suggested PR size: 1–3 slices.

---

## 11) Common pitfalls

- Refactoring without locking down behavior at the boundaries.
- Over-abstracting too early.
- Making “just one more improvement” that expands scope.
- Large formatting-only diffs that hide real changes.

---

## 12) Change log

- YYYY-MM-DD — Created/updated incremental refactoring strategy.


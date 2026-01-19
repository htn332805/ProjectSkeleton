# COMMON_PATTERNS_AND_RECIPES
Repeatable patterns (“how we do X here”).
> A practical playbook of repeatable solutions used in this project.
>
> Goal: reduce decision fatigue, keep implementations consistent, and make refactoring easier.

---

## 1) How to use this document

- Treat each pattern as a **recipe**: problem → constraints → solution → example.
- Prefer linking to module templates in `/code/` rather than embedding large code.
- Add a new recipe whenever you see the same approach repeated 2–3 times.

---

## 2) Recipe template (copy/paste)

```markdown
## Recipe: <name>

### Problem
What problem does this solve?

### When to use
- 

### When NOT to use
- 

### Constraints (must honor)
- /Guidelines/...
- /Coverages/...

### Solution (high level)
- Step 1
- Step 2

### Interfaces/contracts
- Port/interface:
- DTOs/contracts:
- Error semantics:

### Observability
- Logs:
- Metrics:
- Traces:

### Testing
- Unit tests:
- Contract tests:
- Integration tests:

### Trade-offs
- Pros:
- Cons:

### Links
- Module template:
- Related docs:
```

---

## 3) Standard patterns

### Recipe: Ports & Adapters for external providers

#### Problem
Need to integrate with an external API/DB/service without leaking details into domain logic.

#### When to use
- External IO is involved.
- Provider may change or multiple providers are expected.

#### Solution (high level)
- Define a port in `interfaces/`.
- Implement adapter in `adapters/`.
- Inject into application service.

#### Links
- `/code/INTERFACES_AND_PORTS_TEMPLATE.md`
- `/code/MODULARIZATION_PATTERNS.md`

---

### Recipe: Validation-first input handling

#### Problem
Inputs are messy; invalid inputs cause downstream bugs.

#### Solution (high level)
- Validate at boundary.
- Convert into typed DTO.
- Enforce invariants.

#### Links
- `/Coverages/EDGE_CASES_AND_BOUNDARY_CONDITIONS.md`
- `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`

---

### Recipe: Error mapping for external failures

#### Problem
External errors are inconsistent; callers need stable error semantics.

#### Solution (high level)
- Map upstream errors into canonical internal errors.
- Mark retryability.
- Emit metrics for error categories.

#### Links
- `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`
- `/Guidelines/ERROR_HANDLING_STRATEGY.md`

---

### Recipe: Incremental refactoring (safe slices)

#### Problem
Large refactors break things and block parallel work.

#### Solution (high level)
- Establish baseline tests and metrics.
- Extract small unit.
- Run tests.
- Repeat.

#### Links
- `/Refactoring_Approach/STEP_BY_STEP_PROCESS.md`
- `/Refactoring_Approach/INCREMENTAL_REFACTORING_STRATEGY.md`

---

## 4) Anti-patterns (what to avoid)

- "God objects" (multiple responsibilities)
- Hidden IO in domain modules
- Shared mutable state across unrelated modules
- Unversioned, implicit contracts
- Overuse of `utils/` dumping grounds

---

## 5) Backlog (recipes to write)

- [ ] Recipe: Contract testing between producer/consumer
- [ ] Recipe: Idempotency keys and retry-safe operations
- [ ] Recipe: Backpressure and rate limiting
- [ ] Recipe: Observability for long-running workflows
- [ ] Recipe: Dependency upgrade playbook


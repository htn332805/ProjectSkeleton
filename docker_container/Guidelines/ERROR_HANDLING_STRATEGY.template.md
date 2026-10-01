# ERROR_HANDLING_STRATEGY
Error taxonomy, when to throw/return, logging standards.
> Non-negotiable error handling rules across the project.
>
> Goal: predictable failure behavior, safer retries, and faster debugging.

---

## 1) Principles

- Errors must be typed and categorized.
- Callers must know what action to take (retry, fix input, escalate).
- Do not swallow errors.
- Do not leak sensitive info.

Link to: `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`.

---

## 2) Error taxonomy (canonical)

Use the categories defined in:
- `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`

Minimum expected categories:
- Validation
- Authentication/Authorization
- Not found
- Conflict
- Rate limit
- External dependency
- Timeout
- Resource exhaustion
- Internal invariant

---

## 3) Raising vs returning errors

Choose one as default:
- Raise typed exceptions (recommended), or
- Return result objects with error field

**Selected approach**:

### Rule
Do not mix styles within the same boundary unless explicitly documented.

---

## 4) Error contracts for public APIs

Every public API must document:
- Errors it can raise/return
- Which errors are user-facing
- Retryability and caller action

Link to: `/Documentations/API_REFERENCE.md`.

---

## 5) Error messages

### Requirements
- Messages must be human-readable.
- Messages must not leak secrets.
- Include error_code/category where applicable.

### User-facing messages
- Must be sanitized.
- Provide actionable guidance.

---

## 6) Logging errors

### Rules
- Log at the boundary where context is richest.
- Include standard context fields.
- Avoid duplicate logging (don’t log the same error at every layer).

Link to: `/Documentations/OBSERVABILITY_LOGGING_TRACING.md`.

---

## 7) Retry rules

### Default policy
- Retryable: timeouts, rate limits, transient dependency errors
- Not retryable: validation, auth, invariant violations

### Idempotency
- Retried operations must be idempotent or deduped.

Link to: `/Coverages/RELIABILITY_AND_FAULT_TOLERANCE.md`.

---

## 8) Mapping external errors

External errors must map into canonical internal errors.

Link to:
- `/Coverages/INTEGRATION_SCENARIOS.md`
- `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`

---

## 9) Observability requirements

- Emit error counters by category.
- Record retry counts.
- Record timeout counts.

---

## 10) Testing requirements

- Unit tests for error conditions.
- Contract tests for error mapping.
- Integration tests for external failure behavior.

Link to: `/Guidelines/TESTING_STANDARDS.md`.

---

## 11) Review checklist

- [ ] Typed errors used (no generic strings).
- [ ] Caller action is clear.
- [ ] No secrets leaked.
- [ ] External errors mapped correctly.
- [ ] Retry policy correct.
- [ ] Tests cover error paths.


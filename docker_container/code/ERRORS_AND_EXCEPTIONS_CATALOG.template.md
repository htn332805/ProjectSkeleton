# MODULE_TEMPLATE
 Canonical list of errors/exceptions and mapping to failure modes.
> Canonical catalog of all error types used across the project.
>
> Goal: consistent error semantics, reliable debugging, predictable retries, and traceable failure behavior.

---

## 1) How to use this catalog

### Rules
- Every **public-facing** module must document which errors it can raise/return.
- Errors must be **typed** (not generic strings).
- Errors must be categorized so callers can decide:
  - Retry vs. no-retry
  - User-facing vs. internal
  - Severity level

Link to: `/Guidelines/ERROR_HANDLING_STRATEGY.md`.

### Standard fields (for every error)
For each error type below, maintain:
- Name
- Category
- Description
- Typical causes
- Caller action
- Retry policy
- Logging requirements
- Metrics/tracing requirements
- Example scenario

---

## 2) Error taxonomy (standard categories)

Use these categories consistently.

### Validation
- Input invalid, missing fields, invariant violations.

### Authorization / Authentication
- Identity not verified, access denied.

### Not found
- Missing resource, unknown id.

### Conflict
- Version conflicts, duplicates, idempotency collisions.

### Rate limit / Throttling
- Provider or internal throttling conditions.

### External dependency
- Provider failures, timeouts, upstream schema changes.

### Timeout
- Operation exceeded allowed time budget.

### Resource exhaustion
- Memory/disk/CPU constraints, queue full.

### Internal invariant
- “This should never happen” conditions; indicates a bug.

### Unknown
- Fallback when classification is not possible (use sparingly).

---

## 3) Error handling policies (cross-cutting)

### Retry policy
Define default behavior:
- Retryable categories:
- Non-retryable categories:
- Backoff strategy:
- Max attempts:

### Severity
- INFO:
- WARNING:
- ERROR:
- CRITICAL:

### User-facing vs internal
- What errors can be exposed?
- What must be sanitized?

### Logging rules
- Required context fields (trace_id, request_id, module, error_code)
- Redaction rules for sensitive data

### Metrics rules
- Error counters by category
- Retry counters
- Timeout counters

---

## 4) Catalog (fill in)

> Maintain this as a table first for quick scanning, then define each error in detail.

### 4.1 Quick index (table)

| Error name | Category | Retryable | User-facing | Default severity | Notes |
|---|---|---:|---:|---|---|
| `ValidationError` | Validation | No | Yes (sanitized) | WARNING | Input constraints violated |
| `UnauthorizedError` | Authentication | No | Yes | WARNING | Not authenticated |
| `ForbiddenError` | Authorization | No | Yes | WARNING | Not allowed |
| `NotFoundError` | Not found | No | Yes | INFO | Missing resource |
| `ConflictError` | Conflict | Sometimes | Yes (sanitized) | WARNING | Version/idempotency conflicts |
| `RateLimitError` | Rate limit | Yes | Maybe | WARNING | Retry after delay |
| `ExternalDependencyError` | External dependency | Sometimes | No | ERROR | Upstream error mapping |
| `TimeoutError` | Timeout | Sometimes | No | ERROR | Operation timed out |
| `ResourceExhaustionError` | Resource exhaustion | Maybe | No | ERROR | Capacity issue |
| `InvariantViolationError` | Internal invariant | No | No | CRITICAL | Indicates bug |

### 4.2 Error definitions (detailed)

#### `ValidationError`
- Category: Validation
- Description:
- Typical causes:
- Caller action:
- Retry policy:
- Logging requirements:
- Metrics/tracing:
- Example:

#### `ExternalDependencyError`
- Category: External dependency
- Description:
- Typical causes:
- Caller action:
- Retry policy:
- Logging requirements:
- Metrics/tracing:
- Example:

(Repeat for all errors used in the codebase.)

---

## 5) Mapping external errors → internal errors

For each external integration/provider:

### Provider: `<name>`
- Timeout → `TimeoutError`
- 429 → `RateLimitError`
- 401/403 → `UnauthorizedError`/`ForbiddenError`
- 5xx → `ExternalDependencyError`

Link to: `/Coverages/INTEGRATION_SCENARIOS.md`.

---

## 6) Testing requirements

- Contract tests verify error categories and retryability.
- Unit tests verify mapping from internal conditions to correct errors.
- Integration tests verify upstream errors map correctly.

Link to: `/Guidelines/TESTING_STANDARDS.md`.

---

## 7) Change control

When adding/changing an error type:
- Update this catalog.
- Update affected module templates in `/code/*_template.md`.
- Update docs (API reference if public).
- Add/adjust tests.
- Add a changelog entry if behavior changes.



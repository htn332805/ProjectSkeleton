# INTEGRATION_SCENARIOS
External systems, API contracts, mocks/stubs strategy.
> Canonical documentation for all external integrations and integration-level scenarios.
>
> Goal: make integrations predictable, testable, secure, and resilient.

---

## 1) How to use this document

### Rules
- Every external integration must be documented here.
- Integration behavior must be traceable to:
  - module templates (`/code/*_template.md`)
  - data contracts (`/Documentations/DATA_MODELS_AND_CONTRACTS.md`)
  - error taxonomy (`/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`)
  - coverage scenarios (`/Coverages/FUNCTIONAL_REQUIREMENTS.md`)

---

## 2) Integration inventory (index)

| Integration | Adapter module | Protocol | Auth | Environments | Owner | Notes |
|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |

---

## 3) Integration template (copy/paste)

```markdown
## Integration: <name>

- Status: Proposed | Active | Deprecated
- Owner:
- Adapter module(s):
  - adapters.<name>
- Port/interface (if applicable):
  - interfaces.<port>

### Purpose
Why this integration exists.

### Data exchanged
- Inputs:
- Outputs:

### Protocol and formats
- Protocol: (HTTP/gRPC/WebSocket/DB/etc.)
- Formats: (JSON/CSV/Protobuf/etc.)

### Authentication and authorization
- Auth type:
- Credential storage:
- Rotation policy:

Link to: `/Guidelines/SECURITY_STANDARDS.md`.

### Rate limits and quotas
- Provider limits:
- Backoff policy:
- Throttling strategy:

### Timeout and retry policy
- Timeouts:
- Retries:
- Idempotency notes:

### Error mapping
Map provider errors to canonical internal errors.

- 400 → `ValidationError`
- 401 → `UnauthorizedError`
- 403 → `ForbiddenError`
- 404 → `NotFoundError`
- 409 → `ConflictError`
- 429 → `RateLimitError`
- 5xx → `ExternalDependencyError`
- timeout → `TimeoutError`

Link to: `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`.

### Observability
- Logs:
- Metrics:
- Traces:

Link to: `/Documentations/OBSERVABILITY_LOGGING_TRACING.md`.

### Testing strategy
- Unit tests:
- Contract tests:
- Integration tests:
- Sandbox/staging testing:

Link to: `/Guidelines/TESTING_STANDARDS.md`.

### Failure modes
- Provider outage:
- Schema drift:
- Partial failures:
- Latency spikes:

### Example request/response (sanitized)
```json
{
  "example": "payload"
}
```

### Related coverage scenarios
- FR-____

```

---

## 4) Integrations (fill in)

## Integration: <name>

- Status: Proposed
- Owner:
- Adapter module(s):
- Port/interface:

### Purpose

### Data exchanged

### Protocol and formats

### Authentication and authorization

### Rate limits and quotas

### Timeout and retry policy

### Error mapping

### Observability

### Testing strategy

### Failure modes

### Example request/response

### Related coverage scenarios

---

## 5) Change log

- YYYY-MM-DD — Added integration <name>
- YYYY-MM-DD — Updated integration <name> (contract change)
- YYYY-MM-DD — Deprecated integration <name>


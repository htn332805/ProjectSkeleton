# MODULE_TEMPLATE
Standard for defining ports/adapters (clean architecture style).
> Template for designing **ports** (interfaces/protocols) and their **adapter implementations**.
>
> Goal: make boundaries explicit so the system is modular, testable, and extensible.

---

## 1) Identity

- Port/interface name:
- Location (planned): `/code/interfaces/<name>_port_template.md` (or similar)
- Adapter implementation(s) planned:
  - Adapter 1:
  - Adapter 2:
- Owner:
- Status: (Draft/Proposed/Accepted/Implemented/Deprecated)

## 2) Responsibility (SRP)

**One sentence**: what capability this port provides.

- SRP statement:

### Non-responsibilities
- (What this interface must NOT do.)

## 3) Why a port is needed

- What dependency is being inverted?
- What variability is expected (providers, environments, versions)?
- What testing benefits does this enable?

## 4) Contract definition

### Contract summary
- Inputs:
- Outputs:
- Invariants:
- Side effects (allowed/expected):

### Data shapes
Define payloads/DTOs.

- Request DTO:
  - Fields:
  - Constraints:
- Response DTO:
  - Fields:
  - Constraints:

Link to: `/Documentations/DATA_MODELS_AND_CONTRACTS.md`.

## 5) Port methods (public API)

> Keep the port small. Prefer fewer methods with clear contracts.

### Method: `<method_name>`
- Purpose:
- Signature (pseudo):
- Inputs:
- Outputs:
- Preconditions:
- Postconditions:
- Error behavior:
  - Typed errors:
  - Retry safety (idempotent?):
- Timeout expectations:
- Performance expectations:
- Example usage:

## 6) Adapter implementation requirements

For each adapter implementation, document:

### Adapter: `<adapter_name>`
- External system/provider:
- Auth method:
- Rate limits:
- Pagination/streaming:
- Error mapping:
  - External errors → internal typed errors
- Retry policy:
- Circuit breaker policy:
- Observability:
  - Logs:
  - Metrics:
  - Traces:
- Configuration:
- Data validation:

Link to: `/Guidelines/SECURITY_STANDARDS.md`, `/Guidelines/ERROR_HANDLING_STRATEGY.md`.

## 7) Test strategy

### Port-level tests (contract tests)
- Validate implementations comply with the same contract.

### Adapter-level tests
- Mock external calls.
- Validate error mapping.
- Validate timeouts/retries.

### Integration tests
- How to test against real sandbox/staging provider (if available).

Link to: `/Guidelines/TESTING_STANDARDS.md`.

## 8) Versioning and compatibility

- Compatibility guarantees:
- Breaking change policy:
- Deprecation timeline:

Link to: `/Guidelines/COMPATIBILITY_RULES.md`.

## 9) Security considerations

- Sensitive data:
- Secrets management:
- Input validation:
- Output sanitization:

Link to: `/Coverages/SECURITY_REQUIREMENTS.md`.

## 10) Implementation checklist

- [ ] Responsibility and non-responsibilities defined.
- [ ] Contract documented with DTOs and invariants.
- [ ] Error taxonomy and retry rules defined.
- [ ] At least one adapter described with requirements.
- [ ] Test plan includes contract tests.
- [ ] Versioning/deprecation plan exists.


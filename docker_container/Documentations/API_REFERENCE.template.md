# API_REFERENCE
Public-facing APIs (even internal APIs if that’s how you operate).
> Authoritative reference for all **public** APIs (and optionally stable internal APIs).
>
> Goal: make usage, contracts, error behavior, and versioning explicit and consistent.

---

## 1) How to use this document

- If an API is used by another module/team/system, document it here.
- Keep this file readable; link to deeper module templates in `/code/`.
- Every entry must define:
  - Purpose
  - Inputs/outputs
  - Error behavior
  - Examples
  - Versioning/compatibility notes

---

## 2) API standards (global)

### Naming
- Use domain language from `/Documentations/GLOSSARY_AND_DOMAIN_LANGUAGE.md`.

### Versioning
- API versioning policy:
- Deprecation policy:

Link to: `/Guidelines/COMPATIBILITY_RULES.md`.

### Error handling
- Error taxonomy comes from `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`.
- Public APIs must never leak secrets or internal stack traces.

Link to: `/Guidelines/ERROR_HANDLING_STRATEGY.md`.

---

## 3) Index

| API | Type (Module/Service/HTTP/CLI) | Owner | Stability | Source template | Notes |
|---|---|---|---|---|---|
|  |  |  |  |  |  |

---

## 4) API definitions

> Document APIs grouped by module or by boundary type.

### 4.1 Module: `<module_name>`

- Responsibility (SRP):
- Location:
- Stability:
- Template link: `/code/<module_name>_template.md`

#### API: `<api_name>`
- Purpose:
- Audience: (internal/external)
- Stability: (experimental/stable)

##### Inputs
- Parameter 1:
  - Type:
  - Constraints:
  - Default:

##### Outputs
- Output type:
- Semantics:

##### Errors
- `ValidationError` — when:
- `NotFoundError` — when:
- `ExternalDependencyError` — when:

##### Side effects
- Writes to DB:
- Emits events:
- Calls external services:

##### Performance
- Latency target:
- Throughput target:
- Complexity expectations:

##### Example usage
- Example 1:
- Example 2:

(Repeat per API.)

---

## 5) HTTP API section (optional)

If your project has HTTP endpoints, document them here.

### Endpoint: `METHOD /path`
- Purpose:
- Auth:
- Request schema:
- Response schema:
- Status codes:
- Errors:
- Examples:

---

## 6) CLI API section (optional)

If your project has CLI commands, document them here.

### Command: `tool subcommand --flags`
- Purpose:
- Inputs/flags:
- Outputs:
- Exit codes:
- Examples:

---

## 7) Event/message contracts (optional)

If your system is event-driven:

### Event: `<event_name>`
- Producer:
- Consumers:
- Schema:
- Version:
- Delivery guarantees:
- Ordering/idempotency:

Link to: `/Documentations/DATA_MODELS_AND_CONTRACTS.md`.

---

## 8) Change control

When you change an API:
- Update this file.
- Update the module template in `/code/`.
- Update contracts in `/Documentations/DATA_MODELS_AND_CONTRACTS.md`.
- Add/adjust tests.
- Add a changelog entry for user-visible changes.

---

## 9) Links

- Module registry: `/Documentations/MODULE_REGISTRY.md`
- Data contracts: `/Documentations/DATA_MODELS_AND_CONTRACTS.md`
- Error catalog: `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`
- Compatibility rules: `/Guidelines/COMPATIBILITY_RULES.md`

# DATA_MODELS_AND_CONTRACTS
Data schemas, invariants, versioning, module-to-module contracts.
> Canonical definitions of data models and the contracts between modules.
>
> Goal: make data shapes explicit, stable, versionable, and testable.

---

## 1) How to use this document

### What belongs here
- Domain entities, value objects, DTOs.
- Cross-module contracts (inputs/outputs) and invariants.
- Schema evolution rules and backward compatibility guarantees.

### What does NOT belong here
- Implementation details.
- Private/internal data structures that never cross a boundary.

### Update rules
Update this document whenever you:
- Introduce a new domain concept or DTO.
- Change a field, type, meaning, or invariant.
- Change serialization format or contract semantics.

---

## 2) Naming and modeling conventions

- Use consistent domain vocabulary (see `/Documentations/GLOSSARY_AND_DOMAIN_LANGUAGE.md`).
- Prefer immutable value objects where possible.
- Prefer explicit types over unstructured dicts/maps.
- Every cross-boundary payload must have:
  - Defined fields
  - Constraints
  - Versioning notes

---

## 3) Data classification

Define sensitivity and handling.

| Classification | Examples | Storage rules | Logging rules |
|---|---|---|---|
| Public |  |  |  |
| Internal |  |  |  |
| Sensitive |  |  |  |

Link to: `/Guidelines/SECURITY_STANDARDS.md`.

---

## 4) Core domain models

### 4.1 Entity: `<EntityName>`

**Definition**: (What this entity represents)

**Fields**:
- `field_1`: type — description — constraints
- `field_2`: type — description — constraints

**Invariants**:
- Invariant 1:
- Invariant 2:

**Lifecycle**:
- Created when:
- Updated when:
- Archived/removed when:

**Example instance**:
```json
{
  "field_1": "...",
  "field_2": 123
}
```

### 4.2 Value object: `<ValueObjectName>`

- Purpose:
- Fields:
- Constraints:
- Example:

(Repeat as needed.)

---

## 5) Cross-module contracts (interfaces)

> A contract is any data exchanged across a module boundary.

### Contract: `<ContractName>`

- Producer module:
- Consumer module(s):
- Direction: (request/response/event)
- Transport: (in-memory call, HTTP, message bus, file)

#### Payload schema
- Version: v1
- Fields:
  - `field_1`: type — constraints
  - `field_2`: type — constraints

#### Semantics
- Meaning of fields:
- Required vs optional fields:
- Default behaviors:

#### Validation rules
- Rule 1:
- Rule 2:

#### Error semantics
- Expected error categories:
- Mapping to error types:

Link to: `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`.

#### Example payload
```json
{
  "field_1": "...",
  "field_2": 123
}
```

---

## 6) Serialization and formats

- Primary serialization format (JSON/Avro/Protobuf/etc.):
- Timestamp format:
- Decimal/float policy:
- Enum policy:
- Null/optional policy:

---

## 7) Schema evolution and versioning

### Backward compatibility rules
- Allowed changes (non-breaking):
  - Add optional field
  - Add new enum value (if consumers handle unknown)
- Breaking changes:
  - Remove/rename field
  - Change type
  - Change semantics

### Versioning strategy
- URL/path versioning vs header versioning (if HTTP)
- Event versioning (if event-driven)

Link to: `/Guidelines/COMPATIBILITY_RULES.md`.

---

## 8) Contract testing strategy

- Contract tests between producer/consumer.
- Golden payload tests.
- Compatibility tests for schema evolution.

Link to: `/Guidelines/TESTING_STANDARDS.md`.

---

## 9) Registry index (optional but recommended)

Keep a quick index for findability.

| Name | Type (Entity/DTO/Event) | Version | Producer | Consumer(s) | Notes |
|---|---|---|---|---|---|
|  |  |  |  |  |  |

---

## 10) Links

- Glossary: `/Documentations/GLOSSARY_AND_DOMAIN_LANGUAGE.md`
- Architecture: `/Documentations/PROJECT_ARCHITECTURE.md`
- Module registry: `/Documentations/MODULE_REGISTRY.md`
- Error catalog: `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`

# MODULE_REGISTRY
 Inventory of modules + ownership + maturity + links to module templates.
> Living inventory of all modules in the project.
>
> Purpose: make the codebase navigable, enforce boundaries, enable parallel work, and support traceability.

---

## 1) How to use this registry

### What belongs here
- Every meaningful module/package/component boundary.
- The module’s responsibility (SRP) and its public interface.
- Ownership, maturity, and dependencies.

### What does NOT belong here
- Implementation details.
- Deep technical design (that belongs in module templates under `/code/`).

### Update rules
Update this registry whenever you:
- Add a module.
- Rename or move a module.
- Change a module’s public API.
- Change dependencies between modules.
- Deprecate or remove a module.

---

## 2) Module lifecycle states

- **Proposed**: Template exists, not yet implemented.
- **Implemented**: Exists in code, basic tests.
- **Stable**: API stable, strong test coverage, used in production.
- **Mature**: Long-term stable, well documented, minimal churn.
- **Deprecated**: Still present but scheduled for removal.
- **Removed**: No longer in the codebase (keep record in changelog).

---

## 3) Registry (table)

> Keep this table accurate and current.

| Module | Layer/type | SRP (one sentence) | Owner | Status | Template link | Key dependencies | Key dependents | Notes |
|---|---|---|---|---|---|---|---|---|
| `core.<module>` | core |  |  | Proposed | `/code/<module>_template.md` |  |  |  |

### Column guidance
- **Module**: stable identifier; match import path / package name.
- **Layer/type**: `core`, `application`, `adapters`, `infra`, `interfaces`.
- **SRP**: one-sentence responsibility.
- **Template link**: must exist for Proposed/Implemented modules.
- **Key dependencies**: list only direct dependencies that matter architecturally.

---

## 4) Dependency notes

### Dependency direction rules
- `adapters → application → core`
- `interfaces` is allowed to be depended on by all layers.

Link to: `/code/MODULARIZATION_PATTERNS.md`.

### Cyclic dependency policy
Cyclic dependencies are prohibited.

If a cycle appears:
1. Stop adding features.
2. Introduce/adjust a port in `interfaces/`.
3. Refactor to break the cycle.
4. Update this registry and module templates.

---

## 5) Module grouping (optional)

If the number of modules grows, group them by domain area.

### Domain area: <name>
- Modules:
  - `...`

---

## 6) Integration points

List external dependencies as “modules” or “adapters” for clarity.

| Integration | Adapter module | Protocol | Owner | Notes |
|---|---|---|---|---|
| Provider X | `adapters.provider_x` | HTTP/JSON |  |  |

Link to: `/Coverages/INTEGRATION_SCENARIOS.md`.

---

## 7) Change log (registry-specific)

Track major registry changes so readers understand evolution.

- YYYY-MM-DD: Added module `...` (reason: ...)
- YYYY-MM-DD: Deprecated module `...` (migration: ...)

(Also update `/CHANGELOG.md` for release-level changes.)

---

## 8) Related docs

- Architecture: `/Documentations/PROJECT_ARCHITECTURE.md`
- Data contracts: `/Documentations/DATA_MODELS_AND_CONTRACTS.md`
- API reference: `/Documentations/API_REFERENCE.md`
- Module template: `/code/MODULE_TEMPLATE.md`

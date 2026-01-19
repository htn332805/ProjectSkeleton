# DEPENDENCY_MANAGEMENT
 External deps, version policy, upgrade workflow.
> Defines how third-party and internal dependencies are selected, versioned, updated, and governed.
>
> Goal: stable builds, secure supply chain, predictable upgrades, and minimal dependency risk.

---

## 1) Principles

- Prefer fewer dependencies.
- Prefer stable, well-maintained libraries.
- Pin versions for reproducibility.
- Upgrade intentionally (no surprise breaking changes).
- Track licenses and security vulnerabilities.

---

## 2) Dependency classification

| Type | Examples | Update frequency | Risk level | Notes |
|---|---|---|---|---|
| Runtime |  |  |  |  |
| Dev tooling |  |  |  |  |
| Test-only |  |  |  |  |
| Optional plugins |  |  |  |  |

---

## 3) Dependency inventory

> Maintain a quick inventory table for the most important dependencies.

| Dependency | Purpose | Version policy | Pin location | Owner | Notes |
|---|---|---|---|---|---|
|  |  |  |  |  |  |

### Version policy examples
- `Pinned exact` (recommended for apps)
- `Pinned minor` (e.g., `~=1.4`)
- `Pinned major` (rare)

---

## 4) Selection criteria (adding a new dependency)

A new dependency must meet most of the following:

- Actively maintained (recent releases and commits)
- Clear documentation
- Compatible license
- Security posture (responds to CVEs)
- Good ecosystem adoption
- Minimal transitive dependencies
- Performance acceptable for use-case

### Required documentation when adding
- Why the dependency is needed
- Alternatives considered
- Risk assessment
- Rollback plan (how to remove)

---

## 5) Update strategy

### Cadence
- Patch updates: (e.g., weekly)
- Minor updates: (e.g., monthly)
- Major updates: (e.g., quarterly or as-needed)

### Process
1. Identify updates.
2. Review changelogs.
3. Assess breaking changes.
4. Update in an isolated branch.
5. Run full test suite.
6. Run security scans.
7. Update docs if behavior changes.
8. Merge with clear release note.

---

## 6) Security and supply chain

### Vulnerability scanning
- Tooling:
- Frequency:
- Policy (block merges on high severity?):

### Dependency provenance
- Trusted sources:
- Hash checking / lockfiles:

### Secrets
- Never store secrets in dependency config.

Link to: `/Guidelines/SECURITY_STANDARDS.md`.

---

## 7) License compliance

- License policy (allowed/disallowed):
- Attribution requirements:
- Tracking process:

---

## 8) Transitive dependencies

### Rules
- Avoid deep transitive graphs.
- Monitor transitive CVEs.
- Prefer dependencies that minimize transitive bloat.

### Procedure
- How to inspect dependency tree:
- How to override/patch transitive deps:

---

## 9) Compatibility and breaking changes

- How breaking changes are handled:
- Deprecation strategy:
- Migration approach:

Link to: `/Guidelines/COMPATIBILITY_RULES.md`.

---

## 10) Tooling configuration (fill in)

- Package manager:
- Lockfile strategy:
- Python (or language) version strategy:
- CI caching strategy:

---

## 11) Troubleshooting

| Problem | Likely cause | Fix |
|---|---|---|
| Install fails | Version conflict | Regenerate lockfile / pin version |
| Runtime crash after update | Breaking change | Roll back / add compat shim |
| Security alert | CVE | Upgrade / patch / replace dependency |

---

## 12) Change log

- YYYY-MM-DD — Added dependency `X` (why, alternatives)
- YYYY-MM-DD — Updated dependency `Y` from `a` to `b` (risk notes)
- YYYY-MM-DD — Removed dependency `Z` (replacement)

---

## 13) Links

- Build and deploy: `/Documentations/BUILD_AND_DEPLOY.md`
- Setup: `/Documentations/SETUP_AND_ENVIRONMENT.md`
- Security standards: `/Guidelines/SECURITY_STANDARDS.md`
- Compatibility rules: `/Guidelines/COMPATIBILITY_RULES.md`

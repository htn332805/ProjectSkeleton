# Changelog

All notable changes will be documented here.
Release notes and traceability for changes (especially refactors).
All notable changes to this project will be documented in this file.

This changelog follows the spirit of **Keep a Changelog** and uses **Semantic Versioning**.

## How to write entries (rules)

- Write changes in plain language.
- Keep entries **atomic**: one bullet = one change.
- Include the "why" when it is not obvious.
- For breaking changes, always include a migration note.
- Every entry should be traceable to a PR/issue/commit.

### Recommended sections per release
- Added
- Changed
- Deprecated
- Removed
- Fixed
- Security

### Traceability tags (optional but recommended)
Use short tags to make filtering easy:
- `[coverage]` links to scenarios/requirements in `/Coverages/`
- `[guideline]` links to rules in `/Guidelines/`
- `[refactor]` refactoring-only changes (no behavior change)
- `[perf]` performance work
- `[security]` security work
- `[docs]` documentation work

---

## [Unreleased]

### Added
- 

### Changed
- 

### Deprecated
- 

### Removed
- 

### Fixed
- 

### Security
- 

---

## [0.1.0] - YYYY-MM-DD

### Added
- Initial project scaffold (folder structure + documentation-first templates).

### Changed
- 

### Deprecated
- 

### Removed
- 

### Fixed
- 

### Security
- 

---

## Release checklist (copy into PR description)

- [ ] Requirements updated (`/Coverages/*`) if behavior changed.
- [ ] Guidelines still satisfied (`/Guidelines/*`).
- [ ] Module templates updated (`/code/*_template.md`) if interfaces changed.
- [ ] Tests updated and passing (`/Guidelines/TESTING_STANDARDS.md`).
- [ ] Documentation updated (`/Documentations/*` and/or `/Tutorial/*`).
- [ ] Evaluation updated (`/Project_implementation_evaluation/*`) if relevant.
- [ ] Migration notes included for breaking changes.

---

## Link reference definitions (optional)

You can optionally maintain link references at the bottom for cleanliness.
Example:
- `[0.1.0]: https://github.com/<org>/<repo>/releases/tag/v0.1.0`

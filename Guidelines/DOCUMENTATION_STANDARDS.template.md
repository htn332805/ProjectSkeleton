# DOCUMENTATION_STANDARDS
Docstring style, what must be documented, change doc obligations.
> Non-negotiable documentation requirements.
>
> Goal: the system remains understandable, navigable, and traceable as it grows.

---

## 1) Scope

Applies to:
- Markdown documentation (`/Documentations`, `/Tutorial`, `/Coverages`, `/Guidelines`, root docs)
- In-code documentation (docstrings/comments)
- Module templates (`/code/*_template.md`)

---

## 2) Principles

- Documentation is part of the product.
- Write for the next contributor.
- Prefer small, atomic docs over one mega doc.
- Keep docs in sync with behavior.
- Use consistent terminology (glossary).

Link to: `/Documentations/GLOSSARY_AND_DOMAIN_LANGUAGE.md`.

---

## 3) Required documentation artifacts

### When adding a new feature
- Update `/Coverages/FUNCTIONAL_REQUIREMENTS.md`.
- Update `/Coverages/EDGE_CASES_AND_BOUNDARY_CONDITIONS.md`.
- Add/update `/code/<module>_template.md`.
- Update `/Documentations/API_REFERENCE.md` if public API changes.
- Update `/CHANGELOG.md` if user-visible.

### When refactoring
- Follow `/Refactoring_Approach/*`.
- Update module templates if interfaces move.
- Update architecture docs if boundaries change.

---

## 4) Markdown style standards

### Headings
- Use clear, descriptive headings.
- Avoid overly deep nesting.

### Lists
- Prefer bullets for checklists.
- Keep items short.

### Links
- Use relative links within repo.
- Avoid broken links; update immediately if paths change.

### Tone
- Plain language.
- Prefer actionable guidance.

---

## 5) Docstring standards (in-code)

Public functions/classes must document:
- Purpose
- Inputs (types and constraints)
- Outputs
- Errors/exceptions
- Example usage for non-obvious behavior

---

## 6) Template compliance

### Module templates
- Every module must have a template under `/code/`.
- Module templates must include:
  - SRP statement + non-responsibilities
  - Public API methods with contracts
  - Error behavior
  - Testing strategy
  - Observability expectations

Link to: `/code/MODULE_TEMPLATE.md`.

---

## 7) Traceability requirements

Documentation must enable tracing:

`Requirement → Module template → Implementation → Tests → Evaluation`

Minimum:
- Requirements reference module templates.
- Module templates reference requirements/contracts.
- Major design changes reference ADRs.

Link to: `/Documentations/DECISIONS_ADR_LOG.md`.

---

## 8) Freshness and ownership

### Ownership
Every major doc should list:
- Owner
- Last updated date

### Freshness policy
- Review major docs every ___ weeks.
- Stale docs must be updated or marked as stale.

---

## 9) Review checklist

- [ ] Docs updated for behavior/interface changes.
- [ ] Links valid.
- [ ] Terminology consistent with glossary.
- [ ] Scenarios and edge cases updated.
- [ ] Module templates updated.
- [ ] Changelog updated if user-visible.


# INTERACTION_WITH_GUIDELINES
Explicit mapping: refactor must never violate /Guidelines.
> Explains how refactoring work must align with this repository’s guideline system.
>
> Goal: prevent “local improvements” that violate global rules (security, testing, architecture, documentation).

---

## 1) Guideline hierarchy

When guidelines conflict, follow this order (highest → lowest):
1. Legal/compliance and security requirements
2. Repository-wide guidelines in `/Guidelines/*`
3. Domain contracts in `/Documentations/DATA_MODELS_AND_CONTRACTS.md`
4. Module-level templates (`/code/*_template.md`)
5. Team conventions (style, naming)

Rule: if a change violates a higher-level rule, the refactor must be redesigned.

---

## 2) Required guideline touchpoints per refactor

Every refactor PR must explicitly list:
- Which guideline files were consulted
- Which ones are impacted/updated
- Which checks/tests were run

### PR template snippet
- Guidelines consulted: 
- Guideline updates (files):
- Tests run:
- Contracts verified:
- Risk + rollback:

---

## 3) Common guideline interactions

### 3.1 Testing
- Refactors must not reduce confidence.
- If tests are missing, add tests before major structural changes.

Link: `/Guidelines/TESTING_STANDARDS.md`.

### 3.2 Architecture
- Preserve layering rules and dependency direction.
- Avoid introducing cross-layer imports for convenience.

Link: `/Guidelines/ARCHITECTURE_RULES.md`.

### 3.3 APIs and contracts
- Maintain compatibility unless a formal breaking-change policy is followed.
- Version contracts when needed.

Links:
- `/Guidelines/COMPATIBILITY_RULES.md`
- `/Documentations/DATA_MODELS_AND_CONTRACTS.md`

### 3.4 Documentation
- Update templates, public references, and examples when code moves.

Links:
- `/Guidelines/DOCUMENTATION_STANDARDS.md`
- `/Documentations/API_REFERENCE.md`

### 3.5 Security and privacy
- Refactors must not weaken authentication, authorization, secrets handling, or logging hygiene.
- Any movement of sensitive data should be reviewed.

Link: `/Guidelines/SECURITY.md`.

### 3.6 Accessibility (if UI/docs)
- Refactors that affect UI components or docs must preserve accessibility.

Link: `/Guidelines/ACCESSIBILITY_AND_INCLUSIVE_DESIGN.md`.

---

## 4) Handling guideline gaps

If a guideline is missing or unclear:
- Propose a minimal update to `/Guidelines/*` in the same PR or a preceding PR.
- Prefer adding a rule + a quick example.
- Avoid “tribal knowledge” in PR comments.

---

## 5) Handling guideline conflicts

If two guidelines conflict:
1. Document the conflict in the PR.
2. Follow the hierarchy in Section 1.
3. Propose a small guideline update clarifying the intended behavior.

---

## 6) Enforcement and audits

Refactors can be blocked if they:
- Break tests or contracts
- Skip required documentation updates
- Introduce architecture violations
- Increase security risk

Periodic audits may sample merged refactors for compliance.

---

## 7) Change log

- YYYY-MM-DD — Created/updated guideline interaction policy.


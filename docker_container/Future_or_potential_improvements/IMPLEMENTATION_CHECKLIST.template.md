# IMPLEMENTATION_CHECKLIST
Repeatable checklist per feature (design→tests→docs→perf→security).
> Cross-cutting checklist to use before shipping any non-trivial change (feature, refactor, bug fix).
>
> Goal: ship changes that are correct, secure, tested, documented, and easy to operate.

---

## 1) How to use this checklist

- Use this as a PR description template or as a release gate.
- Not every item applies to every change—mark items as N/A with a short reason.
- For refactor-only PRs, also follow:
  - `/Refactoring_Approach/REFACTORING_FRAMEWORK.md`
  - `/Refactoring_Approach/STEP_BY_STEP_PROCESS.md`

---

## 2) Change summary

- Change type: (feature / bug fix / refactor / ops)
- Scope (modules):
- User impact:
- Non-goals:

---

## 3) Functional correctness

- [ ] Requirements understood and documented (issue/PR description).
- [ ] Edge cases identified.
- [ ] Error handling defined (messages/codes, fallback behavior).
- [ ] Backward compatibility checked (APIs/data/contracts).

Links:
- `/Documentations/DATA_MODELS_AND_CONTRACTS.md`
- `/Guidelines/COMPATIBILITY_RULES.md`

---

## 4) Testing and validation

- [ ] Unit tests added/updated.
- [ ] Integration/contract tests added/updated (if boundary touched).
- [ ] Regression test added for bugs.
- [ ] Tests are deterministic (no flakiness introduced).
- [ ] Local test run completed.
- [ ] CI test run completed.

Link:
- `/Guidelines/TESTING_STANDARDS.md`

---

## 5) Security and privacy

- [ ] Threat/risk considered for this change.
- [ ] Input validation added/verified.
- [ ] AuthN/AuthZ requirements preserved.
- [ ] Secrets not logged and not committed.
- [ ] Dependency changes reviewed (supply chain).

Link:
- `/Guidelines/SECURITY.md`

---

## 6) Performance

- [ ] Hot paths identified (if relevant).
- [ ] Baseline captured (if relevant).
- [ ] Benchmarks or perf smoke tests run (if relevant).
- [ ] Performance regression risk assessed.

Link:
- `/Project_implementation_evaluation/PERFORMANCE_ASSESSMENT.md`

---

## 7) Reliability and operability

- [ ] Failure modes considered.
- [ ] Timeouts/retries/idempotency handled (if relevant).
- [ ] Observability updated (logs/metrics/traces).
- [ ] Runbook updated (if relevant).

Links:
- `/Project_implementation_evaluation/RELIABILITY_ASSESSMENT.md`
- `/Guidelines/OBSERVABILITY.md` (if present)

---

## 8) Documentation and tutorials

- [ ] Docs updated (README/architecture/API/contracts).
- [ ] Tutorials/examples updated and runnable.
- [ ] No broken links introduced.

Links:
- `/Guidelines/DOCUMENTATION_STANDARDS.md`
- `/Refactoring_Approach/INTEGRATION_WITH_DOCUMENTATION_AND_TUTORIALS.md`

---

## 9) Accessibility and inclusive design (if user-facing)

- [ ] Keyboard navigation and focus states preserved (UI).
- [ ] Contrast/labels/alt text checked (UI/docs).
- [ ] Inclusive language checked (docs).

Link:
- `/Guidelines/ACCESSIBILITY_AND_INCLUSIVE_DESIGN.md`

---

## 10) Release and rollout

- [ ] Migration steps documented (if needed).
- [ ] Feature flag/rollout plan defined (if risky).
- [ ] Rollback plan defined.
- [ ] Versioning/changelog updated when required.

---

## 11) Post-merge follow-ups

- [ ] Future improvements captured (issues/backlog).
- [ ] Technical debt items linked and prioritized.

Link:
- `/Refactoring_Approach/HANDLING_FUTURE_IMPROVEMENTS.md`

---

## 12) Sign-off

- Reviewer(s):
- Approval date:

---

## 13) Change log

- YYYY-MM-DD — Created/updated implementation checklist.


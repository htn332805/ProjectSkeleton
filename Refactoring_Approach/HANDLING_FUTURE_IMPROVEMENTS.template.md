# HANDLING_FUTURE_IMPROVEMENTS
How refactoring creates runway for roadmap items.
> How to capture, prioritize, and execute follow-up improvements discovered during refactoring.
>
> Goal: keep refactors scoped while ensuring valuable ideas are not lost.

---

## 1) Why this exists

During refactoring it’s common to uncover:
- missing tests
- inconsistent naming
- performance opportunities
- architectural problems

This document defines how to record these without expanding the current refactor beyond safe boundaries.

---

## 2) Definition: “future improvement”

A future improvement is any change that:
- is not required to achieve the current refactor objective, or
- increases scope/risk meaningfully, or
- changes behavior (feature/bug fix), or
- requires stakeholder alignment.

Rule: future improvements are tracked separately from the current refactor PR.

---

## 3) Capture workflow (lightweight)

### 3.1 When to capture
Capture an item when it is:
- discovered during code reading
- identified during reviews
- noticed while writing tests

### 3.2 Where to capture
Choose one:
- GitHub issue (preferred)
- A backlog file: `/Refactoring_Approach/FUTURE_IMPROVEMENTS_BACKLOG.md`
- PR follow-up checklist (only if it will be handled immediately after merge)

---

## 4) Future improvement template

Copy/paste:

- Title:
- Type: (test debt / tech debt / perf / reliability / security / docs)
- Context:
- Why it matters:
- Proposed approach:
- Risk level: (low/medium/high)
- Dependencies:
- Acceptance criteria:
- Evidence/links:

---

## 5) Prioritization rubric

Score 1–5 for each:
- User impact (bugs/incidents avoided)
- Developer impact (time saved / easier changes)
- Risk reduction (security/reliability)
- Effort (inverse score: easier = higher)

Priority guidance:
- High impact + low effort → do next
- High risk reduction → schedule soon
- Low impact + high effort → defer

---

## 6) Execution rules

- Do not “sneak in” future improvements in refactor-only PRs.
- Prefer separate PRs with a single clear objective.
- If behavior change is needed, follow the project’s compatibility and release rules.

Links:
- `/Refactoring_Approach/REFACTORING_FRAMEWORK.md`
- `/Guidelines/COMPATIBILITY_RULES.md`

---

## 7) Review checklist

- [ ] Current refactor remains in scope.
- [ ] Follow-up items captured with acceptance criteria.
- [ ] Owners assigned for high-priority items.
- [ ] No behavior changes slipped into refactor commits.

---

## 8) Change log

- YYYY-MM-DD — Created/updated future improvements handling policy.


# GIT_WORKFLOW
Branching, commits, PR requirements, review gates.
> Non-negotiable Git workflow and contribution mechanics.
>
> Goal: clean history, safe parallel work, predictable releases, and easy code review.

---

## 1) Branching strategy

Choose one and enforce it.

### Option A: Trunk-based (recommended for small teams)
- `main` is always releasable.
- Short-lived feature branches.
- Frequent merges.

### Option B: GitFlow (for heavier release processes)
- `main` (releases)
- `develop` (integration)
- feature/release/hotfix branches

**Selected strategy**: (choose A or B)

---

## 2) Branch naming conventions

Use a consistent pattern:

- `feature/<short-description>`
- `fix/<short-description>`
- `refactor/<short-description>`
- `docs/<short-description>`
- `chore/<short-description>`

Include issue/FR id when possible:
- `feature/FR-0012-add-order-validator`

---

## 3) Commit message conventions

### Format (recommended)

```
<type>(<scope>): <short summary>

<optional body>

Refs: <issue/FR/EC/ADR>
```

### Types
- feat: new behavior
- fix: bug fix
- refactor: structure change without behavior change
- docs: documentation-only change
- test: tests only
- chore: tooling/build/cleanup

---

## 4) Pull request (PR) requirements

A PR must include:
- Clear description of what and why
- Link to scenario(s) in `/Coverages/*`
- Link to module template(s) in `/code/*_template.md`
- Tests added/updated
- Docs updated when applicable
- Changelog updated when user-visible

Link to: `/CONTRIBUTING.md`.

---

## 5) PR size policy

- Prefer small PRs.
- If PR is large, split into:
  - docs/templates
  - code changes
  - refactor-only changes

---

## 6) Code review checklist

Reviewer must verify:
- `/Guidelines/*` honored
- scenarios covered (`/Coverages/*`)
- module templates updated (`/code/*_template.md`)
- contracts updated (`/Documentations/DATA_MODELS_AND_CONTRACTS.md`) when needed
- tests meet `/Guidelines/TESTING_STANDARDS.md`

---

## 7) Merge strategy

Choose one:
- Squash merge (recommended)
- Merge commit
- Rebase merge

**Selected merge strategy**:

### Requirements before merge
- CI green
- required reviews completed
- no unresolved comments

---

## 8) Tagging and releases

- Tag releases as: `vX.Y.Z`
- Update `/CHANGELOG.md` before tagging.

Link to: `/Documentations/BUILD_AND_DEPLOY.md`.

---

## 9) Hotfix policy

- Hotfix branch naming: `hotfix/<desc>`
- Fast-track review rules:
- Post-hotfix cleanup (backport to main/develop):

---

## 10) Handling refactors

- Refactor PRs must be labeled `refactor`.
- Must prove behavior unchanged via tests.
- Must follow `/Refactoring_Approach/STEP_BY_STEP_PROCESS.md`.

---

## 11) Conflict resolution rules

- Rebase frequently.
- Resolve conflicts carefully; rerun tests.
- If conflicts are large, coordinate with owners of affected modules.

---

## 12) Repository hygiene

- Don’t commit secrets.
- Keep generated files out of git.
- Keep formatting consistent.

Link to: `/Guidelines/SECURITY_STANDARDS.md`.


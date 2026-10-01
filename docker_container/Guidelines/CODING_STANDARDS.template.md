# CODING_STANDARDS
Style, naming, complexity limits, lint/type rules.
> Non-negotiable coding standards for this project.
>
> Goal: consistent code, predictable structure, easier reviews, and safer refactoring.

---

## 1) Scope

These standards apply to:
- All production code
- All test code
- All scripts and tooling (unless explicitly exempted)

---

## 2) General principles

- Prefer clarity over cleverness.
- Keep units small and single-purpose.
- Make dependencies explicit.
- Avoid hidden side effects.
- Favor composition over inheritance.

Link to: `/Guidelines/DESIGN_PRINCIPLES.md`.

---

## 3) Style and formatting

### Formatting
- Use an auto-formatter (required):
- Line length:
- Indentation:

### Imports
- Standard library → third-party → local imports.
- No wildcard imports.

### Naming
- Files/modules: `snake_case`
- Classes: `PascalCase`
- Functions/methods: `snake_case`
- Constants: `UPPER_SNAKE_CASE`

---

## 4) Complexity limits

### Functions/methods
- Max lines:
- Max cyclomatic complexity:
- Max parameters:

### Classes
- Max public methods:
- Max responsibilities: 1

Link to: `/code/GRANULAR_ATOMIC_UNITS_GUIDE.md`.

---

## 5) Documentation (in-code)

### Docstrings/comments
- Public functions/classes must have docstrings.
- Document:
  - purpose
  - inputs/outputs
  - exceptions/errors
  - examples for non-obvious behavior

Link to: `/Guidelines/DOCUMENTATION_STANDARDS.md`.

---

## 6) Error handling

- Use typed errors.
- Never swallow exceptions silently.
- Avoid returning `None` for error conditions unless explicitly part of the contract.

Link to:
- `/Guidelines/ERROR_HANDLING_STRATEGY.md`
- `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`

---

## 7) Logging and observability

- Use structured logging.
- Include required context fields.
- Do not log secrets or sensitive payloads.

Link to: `/Documentations/OBSERVABILITY_LOGGING_TRACING.md`.

---

## 8) Performance rules

- Avoid obvious N+1 patterns.
- Prefer streaming over loading entire datasets when large.
- Avoid heavy logging in hot paths.

Link to: `/Guidelines/PERFORMANCE_CONSTRAINTS.md`.

---

## 9) Security rules

- Never hardcode secrets.
- Validate inputs at boundaries.
- Sanitize outputs.

Link to: `/Guidelines/SECURITY_STANDARDS.md`.

---

## 10) Testing obligations

- All new logic must have tests.
- Bug fixes must include regression tests.

Link to: `/Guidelines/TESTING_STANDARDS.md`.

---

## 11) Tooling (fill in)

Required tools:
- Formatter:
- Linter:
- Type checker:
- Security scanner:

---

## 12) Exceptions process

If you need to violate a standard:
- Write down the reason.
- Propose an exception in an ADR.
- Get approval.

Link to: `/Documentations/DECISIONS_ADR_LOG.md`.


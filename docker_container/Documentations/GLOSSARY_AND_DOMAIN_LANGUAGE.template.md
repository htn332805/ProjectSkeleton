# GLOSSARY_AND_DOMAIN_LANGUAGE
Canonical terms to prevent naming drift.
> Canonical vocabulary for this project.
>
> Goal: prevent naming drift, improve readability, and make module boundaries and contracts consistent.

---

## 1) How to use this glossary

### Rules
- Prefer terms from this glossary in:
  - Module names
  - Method names
  - Data model fields
  - Documentation
- If you introduce a new domain concept, add it here first.

### Anti-goals
- This is not a general dictionary.
- This is not implementation documentation.

---

## 2) Naming conventions

### Preferred style
- Use **domain terms** rather than technical terms.
- Use consistent tense and plurality.
- Avoid synonyms unless explicitly defined.

### Disambiguation rule
If two terms are close, define both and state when to use each.

Example:
- “Order” vs “Trade”
- “Signal” vs “Decision”

---

## 3) Core glossary (terms)

> Keep this section as a table for quick scanning.

| Term | Definition | Synonyms (avoid?) | Related terms | Where used | Notes |
|---|---|---|---|---|---|
|  |  |  |  |  |  |

### Term template (detailed)

#### Term: `<TermName>`

- Definition:
- Context:
- Example usage (in a sentence):
- Example field names:
- Example method names:
- Related terms:
- Common confusion:

(Repeat as needed.)

---

## 4) Canonical entities and relationships

Describe key domain objects and how they relate.

- Entity A → Entity B relationship:
- Entity C constraints:

Link to: `/Documentations/DATA_MODELS_AND_CONTRACTS.md`.

---

## 5) Standard abbreviations and acronyms

| Acronym | Expanded | Meaning | Allowed in code? | Notes |
|---|---|---|---:|---|
|  |  |  |  |  |

Rule: avoid abbreviations in public APIs unless extremely common.

---

## 6) Reserved words and forbidden names

### Reserved words (must mean one thing)
- `id`:
- `timestamp`:
- `status`:

### Forbidden names (too ambiguous)
- `data`
- `info`
- `stuff`
- `misc`

---

## 7) Change log

- YYYY-MM-DD — Added term `<Term>` (reason: ...)
- YYYY-MM-DD — Deprecated term `<OldTerm>` → use `<NewTerm>`

---

## 8) Links

- Architecture: `/Documentations/PROJECT_ARCHITECTURE.md`
- Data models/contracts: `/Documentations/DATA_MODELS_AND_CONTRACTS.md`
- Module registry: `/Documentations/MODULE_REGISTRY.md`

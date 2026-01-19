# SECURITY_CRITERIA
 Scoring rubric for security.
 > Detailed scoring criteria for security.
>
> Goal: provide a consistent rubric for evaluating security posture with evidence.

---

## 1) How to use this rubric

- Score each criterion from 1–5 using the shared scale in:
  - `/Project_implementation_evaluation/Scoring_criteria/PROJECT_EVALUATION_SCORE.md`
- Provide evidence links for each score.
- If evidence is missing, score conservatively.

---

## 2) Criteria and scoring

### S1) Threat modeling and risk awareness
What to look for:
- Threat model exists and is updated
- Top risks are tracked and prioritized

Scoring hints:
- 5: Threat model is current; risks tracked with owners; used in design decisions.
- 3: Partial threat model; risks tracked inconsistently.
- 1: No threat modeling; risks discovered late.

Score:
Evidence:
Notes:

---

### S2) Authentication and authorization
What to look for:
- Strong AuthN at entry points
- Least privilege AuthZ model (RBAC/ABAC)
- Sensitive operations protected

Scoring hints:
- 5: AuthN/AuthZ consistently enforced; reviewed and tested.
- 3: Basic enforcement exists; gaps in edge cases.
- 1: Weak or inconsistent access control.

Score:
Evidence:
Notes:

---

### S3) Secrets management
What to look for:
- No secrets committed
- Centralized secrets store
- Rotation and access controls

Scoring hints:
- 5: Strong secrets hygiene; rotation process; audits.
- 3: Basic secrets handling; rotation manual or inconsistent.
- 1: Secrets sprawl; secrets appear in code/logs.

Score:
Evidence:
Notes:

---

### S4) Input validation and injection defenses
What to look for:
- Validation at boundaries
- Safe parsing/serialization
- Injection protections (SQL/command/template)

Scoring hints:
- 5: Consistent validation + tests; hardened parsing.
- 3: Some validation; gaps in less-used paths.
- 1: Inputs trusted by default; high injection risk.

Score:
Evidence:
Notes:

---

### S5) Dependency and supply-chain security
What to look for:
- Dependency pinning
- SCA scanning
- SBOM generation (optional)
- Verified builds (optional)

Scoring hints:
- 5: Supply-chain controls in place; scanning is routine; issues triaged.
- 3: Some scanning; gaps in enforcement.
- 1: No scanning; dependencies unmanaged.

Score:
Evidence:
Notes:

---

### S6) Secure configuration and hardening
What to look for:
- Secure defaults
- Environment hardening
- Minimal exposed surface

Scoring hints:
- 5: Secure-by-default; hardening documented and verified.
- 3: Some hardening; configuration drift risk.
- 1: Insecure defaults; hardening not considered.

Score:
Evidence:
Notes:

---

### S7) Logging, auditing, and privacy
What to look for:
- Logs support investigations without leaking sensitive data
- Audit trails for sensitive operations
- Privacy considerations documented

Scoring hints:
- 5: Strong auditability; logging hygiene is enforced.
- 3: Basic logging; occasional sensitive data risks.
- 1: Insufficient audit trails or sensitive data in logs.

Score:
Evidence:
Notes:

---

### S8) Vulnerability management and incident response
What to look for:
- Reporting and triage process
- Patch cadence
- Security testing in CI
- Incident response plan

Scoring hints:
- 5: Clear process; fast triage; regular patching; drills or evidence.
- 3: Some process exists; cadence inconsistent.
- 1: No process; security issues handled ad hoc.

Score:
Evidence:
Notes:

---

## 3) Roll-up scoring (optional)

- Security score can be the average of S1–S8, or weighted if desired.

| Criterion | Weight (%) | Score |
|---|---:|---:|
| S1 Threat modeling |  |  |
| S2 AuthN/AuthZ |  |  |
| S3 Secrets |  |  |
| S4 Input validation |  |  |
| S5 Supply chain |  |  |
| S6 Hardening |  |  |
| S7 Logging/audit/privacy |  |  |
| S8 Vuln mgmt/IR |  |  |

---

## 4) Change log

- YYYY-MM-DD — Created/updated security criteria.


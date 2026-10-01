# SETUP_AND_ENVIRONMENT
Logging/tracing conventions (ties into “debuggable/traceable”).
> Project-wide observability standards: logging, metrics, and tracing.
>
> Goal: make the system easy to debug, measurable, and safe to operate.

---

## 1) Observability goals

- Debuggability: find root cause quickly.
- Traceability: correlate events across modules.
- Operability: detect and respond to issues.
- Performance visibility: identify bottlenecks and regressions.

---

## 2) Standard context fields (mandatory)

Every log/trace/metric should include (when applicable):

- `service` / `app_name`
- `environment` (dev/staging/prod)
- `module`
- `component`
- `operation`
- `request_id`
- `trace_id`
- `span_id`
- `user_id` (if allowed)
- `correlation_id` (if you use one)

### Redaction rule
Never log secrets, tokens, passwords, or full sensitive payloads.

Link to: `/Guidelines/SECURITY_STANDARDS.md`.

---

## 3) Logging standards

### 3.1 Log levels
- DEBUG: diagnostic details (disabled by default in prod)
- INFO: lifecycle events, normal behavior
- WARNING: recoverable issues, degraded behavior
- ERROR: failures requiring attention
- CRITICAL: system integrity threatened

### 3.2 Structured logging
- Format: JSON (recommended) or consistent key-value format
- Required keys: level, timestamp, message + standard context fields

### 3.3 What to log
Log events, not noise.

Examples:
- Start/end of a use-case
- Calls to external dependencies (with latency)
- Retries and circuit breaker events
- Validation failures (sanitized)
- State transitions

### 3.4 What NOT to log
- Full raw payloads containing sensitive data
- Secrets
- Large blobs
- High-frequency debug spam

---

## 4) Metrics standards

### 4.1 Metric naming
- Use consistent prefixes by subsystem.
- Prefer `snake_case` or whatever your metrics system expects.

### 4.2 Metric types
- Counters: total events (requests, errors)
- Gauges: current value (queue depth)
- Histograms/timers: latency distributions

### 4.3 Golden signals (recommended)
- Latency (p50/p95/p99)
- Traffic (throughput)
- Errors (error rate by category)
- Saturation (CPU/memory/queue depth)

Link to: `/Coverages/PERFORMANCE_REQUIREMENTS.md`.

---

## 5) Tracing standards

### 5.1 Trace propagation
- How trace_id is created and propagated across modules
- How to propagate across IO boundaries (HTTP headers, message metadata)

### 5.2 Span conventions
- Span names: `<component>.<operation>`
- Required attributes: module, operation, peer.service, peer.address (if external)

### 5.3 What to trace
- External dependency calls
- Long-running workflows
- Batch job stages
- Retries/backoff

---

## 6) Error observability and taxonomy

- All errors should map to the canonical taxonomy.
- Emit counters for each error category.
- Include error_code and category in logs.

Links:
- `/code/ERRORS_AND_EXCEPTIONS_CATALOG.md`
- `/Guidelines/ERROR_HANDLING_STRATEGY.md`

---

## 7) Dashboards (recommended)

Define the dashboards every operator should have.

### System dashboard
- RPS / throughput
- error rate
- p95/p99 latency
- resource saturation

### Dependency dashboard
- upstream latency
- upstream error rate
- retries

### Business/domain dashboard (optional)
- domain-specific KPIs

---

## 8) Alerts (recommended)

Define high-signal alerts.

| Alert | Condition | Severity | Runbook |
|---|---|---|---|
| High error rate | error_rate > X% for Y min | High | link |
| Latency regression | p99 > target for Y min | High | link |
| Dependency down | upstream failures > X | High | link |

---

## 9) Runbooks (optional but recommended)

Create a runbook per major alert.

- `/Documentations/runbooks/<alert>.md`

Each runbook should include:
- Symptom
- Likely causes
- How to confirm
- Mitigation steps
- Escalation

---

## 10) Checklist

- [ ] Logs include standard context fields.
- [ ] Sensitive data is redacted.
- [ ] Golden signals emitted.
- [ ] Traces cover IO boundaries.
- [ ] Dashboards exist.
- [ ] Alerts are high-signal.
- [ ] Runbooks exist for critical alerts.


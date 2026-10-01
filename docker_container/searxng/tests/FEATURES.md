Feature Matrix — test ownership mapping

- Feature: Service startup and health
  - Test: tests/api/test_api_health.py

- Feature: JSON API search
  - Test: tests/api/test_search_json.py

- Feature: Per-engine end-to-end queries
  - Test: tests/integration/test_engines_per_engine.py

- Feature: Browser UI search flow
  - Test: tests/ui/test_search_flow.py

- Feature: Security headers
  - Test: tests/security/test_security_headers.py

- Feature: Rate limiter behavior (if enabled)
  - Test: tests/perf/test_rate_limiter_behavior.py

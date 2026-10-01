## Plan: SearxNG Docker + 100% End-to-End Feature Coverage

TL;DR
- Build tests around the existing `searxng/searxng:latest` service declared in `docker-compose.yml` and add a `test-runner` service via a `docker-compose.test.yml` overlay. Tests will be fully end-to-end (no mocks) and exercise every documented feature using live external services (you will provide credentials where needed). The `test-runner` will run `pytest` (API + integration) and Playwright (UI) tests, collect artifacts, and exit with a pass/fail status so CI/self-hosted runner can assert success.

**Steps**
1. Discovery (done): review repository files and surface dependencies.
   - Found: [docker-compose.yml](docker-compose.yml#L1) and [settings.yml](settings.yml#L1).
2. Alignment (done): you selected: use official image, allow live external access, you will provide credentials, run tests on a self-hosted/local runner, and require 100% feature (end-to-end) coverage.
3. Design the test orchestration files:
   - Add `docker-compose.test.yml` that:
     - Reuses `searxng` service from `docker-compose.yml` (no rebuild by default).
     - Adds `test-runner` service that depends_on `searxng` and waits for healthcheck before running tests.
     - Mounts the `tests/` directory and a secret file `tests/secrets.env` into `test-runner` (secrets not committed).
     - Optionally add a lightweight `proxy` service if you later want to record or throttle outbound traffic.
   - Add a small `scripts/run_tests.sh` (executable) that the `test-runner` uses to run `pytest` and Playwright tests and to publish artifacts into `/tests/artifacts/`.
4. Create test structure (on-disk `tests/`):
   - `tests/api/` — `test_api_health.py`, `test_search_json.py`, `test_search_formats.py`.
   - `tests/integration/` — `test_engines_per_engine.py`, `test_doi_resolvers.py`, `test_settings_reload.py`.
   - `tests/ui/` — Playwright tests to exercise the browser UI: `test_search_flow.spec.ts` (or Python flavor), `test_preferences.spec.ts`.
   - `tests/security/` — `test_security_headers.py`, `test_cors.py`.
   - `tests/perf/` — `test_rate_limiter_behavior.py` (use conservative concurrency to avoid external abuse).
   - `tests/support/` — helpers, `secrets.example.env`, `credentials.md` (document where to place secrets).
5. Implement tests (no mocks):
   - API tests use `requests` inside `test-runner` to call `http://searxng:8080/search?q=...&format=json` and validate JSON schema and presence of engine `source` fields.
   - Per-engine tests: for each engine in `settings.yml`, perform a representative query and assert that the response includes the engine name/id. Use provided credentials where required.
   - UI tests (Playwright): open the web UI, perform searches, switch languages, change formats (html/json), follow DOI links, verify preferences persistence.
   - Settings tests: update a non-committed copy of `settings.yml` (or a mounted override), restart service, and validate new behavior (e.g., new engine added or format enabled).
   - Security tests: verify `X-Frame-Options`, `Content-Security-Policy`, `Referrer-Policy`, and any other headers searxng sets.
   - Rate-limiter tests: test internal limiter behavior by sending controlled concurrent requests to searxng itself (not to external engines) and assert limiter triggers when expected.
6. Test orchestration and stability:
   - `test-runner` must implement a robust wait-for-healthcheck step with exponential backoff for external engine responses.
   - Add retries with bounded backoff for flaky external queries. Log diagnostics for each retry (response headers, status, raw snippets) for triage.
7. Secrets and credentials:
   - `tests/secrets.env` (never committed) holds API keys / account credentials.
   - Add `tests/secrets.example.env` showing required variables and formats.
8. CI / self-hosted runner setup:
   - Provide `scripts/run_tests.sh` to be invoked by the runner. The runner must have Docker installed and network access to external services.
   - Define a bootstrap doc `TEST_RUNNER_SETUP.md` describing how to configure runner network, set up `tests/secrets.env`, and increase ulimits if needed.
9. Artifacts and reporting:
   - Save pytest JUnit XML, Playwright traces/screenshots, and `docker-compose` logs to `tests/artifacts/` for post-mortem.
   - Exit with non-zero status when any test fails so CI can gate merges.
10. Acceptance criteria (explicit):
   - For every documented feature in the Feature Matrix (see verification), there is at least one end-to-end test that passes reliably in the target environment.
   - No tests use mocks or simulated engines; all assertions are against real behavior.
   - Tests must run reproducibly on the self-hosted runner given the `tests/secrets.env` and network access.
11. Documentation and Onboarding:
   - Add `README-tests.md` with steps to run tests locally, add credentials, and interpret artifacts.
12. Maintainability:
   - Provide a `tests/FEATURES.md` matrix mapping features → test file(s) → owner.

**Relevant files**
- `docker-compose.yml` — existing service: [docker-compose.yml](docker-compose.yml#L1)
- `settings.yml` — existing configuration: [settings.yml](settings.yml#L1)
- Proposed new files (create):
  - `docker-compose.test.yml` — test overlay (create)
  - `tests/` — test suite root (create)
  - `tests/secrets.env` — runtime secrets (DO NOT COMMIT) (create locally)
  - `tests/secrets.example.env` — example secrets file (create)
  - `scripts/run_tests.sh` — orchestrates tests inside `test-runner` (create)
  - `TEST_RUNNER_SETUP.md`, `README-tests.md`, `tests/FEATURES.md`

**Verification**
1. Environment prep: ensure `tests/secrets.env` exists with credentials and that host/network permits outbound requests to target engines.
2. Start test stack: run `docker-compose -f docker-compose.yml -f docker-compose.test.yml up --build --abort-on-container-exit` from repository root.
3. Observe `test-runner` logs and artifacts in `tests/artifacts/`.
4. Pass criteria: all tests pass; `test-runner` exits 0. For any failing feature test, retrieve Playwright screenshots, traces, and container logs for analysis.
5. Feature-matrix verification: cross-check `tests/FEATURES.md` to ensure there is at least one green test per listed feature.
6. Stability checks: run the full suite 3x consecutively; investigate intermittent failures and either harden test logic (retries, better selectors) or flag test as flaky and assign owner.

**Decisions / Assumptions**
- Image strategy: use official `searxng/searxng:latest` (you chose this). If tests require code changes or instrumentation, we will add an alternate `Dockerfile.test` and a local image build as fallback.
- External services: tests will call live external search engines (you agreed). This makes tests brittle; plan includes retries and diagnostics.
- Credentials: you will supply credentials for any engines requiring authentication.
- Coverage target: you asked for 100% feature coverage (end-to-end). We will map features exhaustively and require at least one end-to-end test per feature.

**Further considerations / risks**
1. Legal/ToS and rate limits: automated queries to external engines can violate terms of service or trigger blocking. We must throttle tests, limit frequency, and get explicit permission if necessary.
2. Flakiness: live external dependencies can make CI flaky. Mitigations: retries, conservative timeouts, diagnostics, and clear ownership for flaky tests.
3. Resource/time: end-to-end suite that hits multiple external engines will be slower; consider nightly runs for full matrix and quicker smoke tests for PR gating.

**Next steps (proposed immediate actions)**
1. I will create `docker-compose.test.yml` and test scaffolding files and the `tests/` layout (planning only; implementation requires your approval).
2. You provide `tests/secrets.env` (or credentials) and confirm willingness to accept test traffic to configured external engines.
3. After approval, implement tests incrementally: start with health checks + basic API, then add per-engine tests, then UI flows, then security and limiter tests.


**Scaffolding: docker-compose.test.yml and tests/**

- **Goal**: Provide an overlay compose file and a robust test-runner + test suite layout that runs the full end-to-end tests against the searxng service (no mocks).

- **docker-compose.test.yml (content summary)**:
  - **Compose version**: 3.8
  - **Services**:
    - **searxng**: reuse existing service from docker-compose.yml; add a healthcheck:
      - command: `curl -fsS http://127.0.0.1:8080/ || exit 1`
      - interval: 5s, timeout: 5s, retries: 20, start_period: 5s
    - **test-runner**:
      - image: `python:3.11-slim`
      - depends_on: searxng
      - volumes:
        - ./tests:/tests:rw
        - ./tests/artifacts:/tests/artifacts:rw
        - ./scripts:/scripts:ro
      - environment:
        - `SEARX_URL=http://searxng:8080`
        - `TZ=UTC`
      - entrypoint: `/scripts/wait-for-service.sh searxng 8080 && /scripts/run_tests.sh`
      - restart: 'no'
    - **proxy** (optional): a lightweight mitmproxy or similar to record outbound requests (only if needed).
  - **Notes**:
    - Compose v3 removed depends_on health condition; implement `wait-for-service.sh` in scripts/ to ensure readiness before tests run.
    - Use `--abort-on-container-exit` and `--exit-code-from test-runner` when bringing up the test stack.

- **scripts/** (summary of files to add)
  - wait-for-service.sh — loop until `curl -fsS $HOST:$PORT/` succeeds or timeout; exit non-zero on failure.
  - run_tests.sh — install test deps (or rely on prebuilt image), run pytest with junit xml, screenshots/traces to /tests/artifacts, capture docker-compose logs into artifacts, and exit with test runner exit code.
  - helper to collect logs: `docker-compose logs --no-color searxng > /tests/artifacts/searxng.log`

- **tests/ layout and responsibilities**
  - tests/
    - api/
      - test_api_health.py — assert service root/health endpoint returns 200.
      - test_search_json.py — send a search query with format=json and assert schema + engines present.
      - test_search_formats.py — verify html/json formats and content negotiation.
    - integration/
      - test_engines_per_engine.py — iterate configured engines, perform simple queries, assert engine-specific response tokens.
      - test_doi_resolvers.py — verify DOI resolver links and redirects.
      - test_settings_reload.py — exercise a settings override (mounted settings file), restart searxng, and verify behavior change.
    - ui/
      - Playwright tests — test_search_flow (search, open result, change language/format), test_preferences (save/restore prefs).
    - security/
      - test_security_headers.py — assert CSP, X-Frame-Options, Referrer-Policy present and valid.
      - test_cors.py — verify CORS behavior for API endpoints.
    - perf/
      - test_rate_limiter_behavior.py — send controlled parallel requests to searxng internals to validate limiter behavior (do not hit external engines concurrently).
    - support/
      - conftest.py — fixtures: `searx_url` (env-driven), `session` (requests.Session with retries), `secrets_loader` (loads tests/secrets.env).
      - helpers.py — HTTP helpers, retry wrappers, JSON schema validators.
      - secrets.example.env — names of required env vars (GOOGLE_API_KEY, BRAVE_API_KEY, OTHERS).
      - credentials.md — instructions for obtaining and placing credentials (do not commit secrets).
    - artifacts/ — populated by run_tests.sh
  - **requirements.txt (tests)** — pytest, requests, pytest-playwright, playwright, pytest-xdist, pytest-rerunfailures, jsonschema, pydantic, urllib3[secure]
  - **conftest.py key fixtures**
    - `searx_url` — session-scoped fixture: `os.environ.get('SEARX_URL','http://searxng:8080')`
    - `http` — requests.Session with HTTPAdapter retries configured; optional auth using env secrets
    - `collect_artifact` — fixture to write per-test artifacts into /tests/artifacts/<testname>/

- **Testing behavior & reliability**
  - Use pytest-rerunfailures for transient external failures (bounded retries).
  - Instrument tests to log request/response headers and snippets to aid debugging.
  - Keep external query frequency low; per-engine tests should run serially or with delays.
  - Separate smoke tests (fast) from full engine matrix (slow); use pytest markers `smoke` and `full`.

- **Secrets**
  - tests/secrets.example.env lists variables required; tests/secrets.env is created locally by operator.
  - The test-runner will source tests/secrets.env at startup.

- **Artifacts & reporting**
  - pytest outputs: junit xml at /tests/artifacts/junit.xml
  - Playwright traces/screenshots at /tests/artifacts/playwright/
  - searxng logs at /tests/artifacts/searxng.log

- **Acceptance criteria for scaffolding**
  - Starting the stack with `docker-compose -f docker-compose.yml -f docker-compose.test.yml up --build --abort-on-container-exit --exit-code-from test-runner` should result in test-runner running and producing artifacts.
  - The scaffolding uses no mocks and requires a local tests/secrets.env to be present when needed.

- **Next**
  1. I can produce exact file contents here (Y) for you to paste into files, or
  2. I can create the files directly in the workspace (requires switching out of Plan mode).
  Please pick one option.
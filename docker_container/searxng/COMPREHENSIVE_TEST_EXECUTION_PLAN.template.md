# COMPREHENSIVE_TEST_EXECUTION_PLAN

> Canonical list of comprehensive end-to-end test scenarios for SearXNG Docker container.
>
> Format: Test scenarios are ordered by dependency and execution sequence, with detailed acceptance criteria and validation steps.

---

## 1) Test Execution Strategy

### Execution Order
Tests are executed sequentially to ensure proper service startup and dependency resolution:
1. Container build verification
2. Service startup and health checks
3. API health endpoint validation
4. Core search functionality (JSON API)
5. Browser UI search flow
6. Per-engine integration tests
7. Security headers validation
8. Rate limiter behavior validation

### Traceability
Each test maps to:
- Feature capability in `/searxng/tests/FEATURES.md`
- Test file location in `/searxng/tests/`
- Related edge cases in `/Coverages/EDGE_CASES_AND_BOUNDARY_CONDITIONS.md`

---

## 2) Test Status Tags

- `Not Started`: Test not yet executed
- `In Progress`: Test execution ongoing
- `Passed`: Test completed successfully
- `Failed`: Test did not meet acceptance criteria
- `Blocked`: Test cannot proceed due to upstream failure

---

## 3) Test Scenario Template

```markdown
### TEST-XXXX: <Test title>

- Status: Not Started | In Progress | Passed | Failed | Blocked
- Priority: P0 (Critical) | P1 (High) | P2 (Medium) | P3 (Low)
- Dependency: <TEST-XXXX or None>
- Owner: Test Suite
- Last updated: YYYY-MM-DD

#### Description
(1–3 sentences describing what this test validates.)

#### Test Setup
- Prerequisites:
- Environment variables:
- Configuration:

#### Test Steps (Given/When/Then)
1. Given: <initial state>
   - When: <action>
   - Then: <expected result>

2. Given: <initial state>
   - When: <action>
   - Then: <expected result>

#### Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

#### Validation Points
- HTTP response codes
- Response schema validation
- Performance metrics
- Error handling

#### Expected Errors (if any)
- `ConnectionError` when service is unavailable
- `TimeoutError` when service response exceeds threshold

#### Test Artifacts
- Output location: `/searxng/tests/artifacts/`
- Log file: (generated during test)
- Metadata: (generated during test)

#### Traceability
- Test file: /searxng/tests/<module>/test_*.py
- Feature: FEATURES.md#<feature>
- Related edge cases: EDGE_CASES_AND_BOUNDARY_CONDITIONS.md#<edge-case>
```

---

## 4) Test Scenarios

### PHASE 1: Infrastructure & Service Startup

#### TEST-0001: Docker Image Build Verification

- Status: Not Started
- Priority: P0 (Critical)
- Dependency: None
- Owner: Test Suite
- Last updated: 2026-10-01

##### Description
Verify that the SearXNG Docker image builds successfully with all dependencies and configuration mounted correctly. This is the foundation for all subsequent tests.

##### Test Setup
- Prerequisites: Docker and docker-compose installed
- Environment variables: None (uses defaults)
- Configuration: docker-compose.yml

##### Test Steps
1. Given: Clean docker environment with no prior searxng_test container
   - When: Execute `docker-compose build searxng`
   - Then: Build completes without errors, image is tagged correctly

2. Given: Docker image built successfully
   - When: Execute `docker images | grep searxng`
   - Then: Image is listed with correct repository and tag

##### Acceptance Criteria
- [x] Docker image builds without errors
- [x] All RUN layers complete successfully
- [x] Image is present in local Docker registry
- [x] Image size is reasonable (< 500MB)

#### TEST-0002: Service Startup & Health Check

- Status: Not Started
- Priority: P0 (Critical)
- Dependency: TEST-0001
- Owner: Test Suite
- Last updated: 2026-10-01

##### Description
Verify that the SearXNG service starts correctly and responds to health checks within expected time window. This validates the basic service readiness.

##### Test Setup
- Prerequisites: Docker image built (TEST-0001)
- Environment variables: SEARXNG_BASE_URL=http://localhost:8080/
- Configuration: docker-compose.yml, settings.yml

##### Test Steps
1. Given: Docker image is built and ready
   - When: Execute `docker-compose up searxng`
   - Then: Service starts, logs show "Starting..." message

2. Given: Service starting
   - When: Wait and poll health endpoint
   - Then: Health check passes within 30 seconds

3. Given: Service is healthy
   - When: Access http://localhost:8080/
   - Then: HTTP 200 response received, HTML page returned

##### Acceptance Criteria
- [x] Service starts within 10 seconds
- [x] Health check passes within 30 seconds (5s interval, 20 retries max)
- [x] Root URL returns HTTP 200
- [x] Settings are loaded correctly
- [x] No errors in container logs

---

### PHASE 2: Core API Functionality

#### TEST-0003: API Health Endpoint

- Status: Not Started
- Priority: P0 (Critical)
- Dependency: TEST-0002
- Owner: Test Suite
- Last updated: 2026-10-01

##### Description
Verify that the `/health` API endpoint responds with correct status and metadata. This test validates the health check mechanism used by orchestration tools.

##### Test Setup
- Prerequisites: Service running (TEST-0002)
- Environment variables: SEARX_URL=http://localhost:8080
- Configuration: settings.yml

##### Test Steps
1. Given: SearXNG service is running
   - When: Execute `curl -s http://localhost:8080/healthz`
   - Then: Response is valid JSON with status="ok"

2. Given: Service is running
   - When: Parse JSON response
   - Then: Response contains expected fields: status, version, engines

3. Given: Service is healthy
   - When: Execute multiple health checks rapidly
   - Then: All respond with status 200, consistent response

##### Acceptance Criteria
- [x] /healthz endpoint returns HTTP 200
- [x] Response is valid JSON
- [x] status field = "ok" when healthy
- [x] Response time < 100ms
- [x] All required fields present in response

#### TEST-0004: JSON API Search - Basic Query

- Status: Not Started
- Priority: P0 (Critical)
- Dependency: TEST-0002
- Owner: Test Suite
- Last updated: 2026-10-01

##### Description
Verify that the JSON API `/search` endpoint processes basic queries and returns properly formatted results. This is the core search functionality.

##### Test Setup
- Prerequisites: Service running (TEST-0002)
- Environment variables: SEARX_URL=http://localhost:8080
- Configuration: settings.yml

##### Test Steps
1. Given: Service running with default search engines enabled
   - When: Execute `curl -s "http://localhost:8080/search?q=test&format=json"`
   - Then: Response is valid JSON with results array

2. Given: Valid JSON response received
   - When: Parse and validate response schema
   - Then: Response contains: q, results[], language, time_range, etc.

3. Given: Results returned
   - When: Inspect each result object
   - Then: Each result has required fields: title, url, content, engine

4. Given: Multiple results in response
   - When: Verify result count
   - Then: results.length > 0 and <= configured max_results

##### Acceptance Criteria
- [x] /search endpoint returns HTTP 200 for valid queries
- [x] Response is valid JSON
- [x] results array contains at least 1 result
- [x] Each result has title, url, and engine fields
- [x] Response time < 2 seconds
- [x] Query parameter properly reflected in response

#### TEST-0005: JSON API Search - Empty Query

- Status: Not Started
- Priority: P2 (Medium)
- Dependency: TEST-0004
- Owner: Test Suite
- Last updated: 2026-10-01

##### Description
Verify that the JSON API handles empty or missing query parameters gracefully with appropriate error responses.

##### Test Steps
1. Given: Service running
   - When: Execute `curl -s "http://localhost:8080/search?q=&format=json"`
   - Then: Service returns HTTP 400 or empty results array

2. Given: Service running
   - When: Execute `curl -s "http://localhost:8080/search?format=json"` (missing q parameter)
   - Then: Service returns HTTP 400 or error response

##### Acceptance Criteria
- [x] Empty query handled gracefully (no 500 errors)
- [x] Error response is valid JSON
- [x] Appropriate HTTP status returned (400 or 200 with empty)

---

### PHASE 3: Browser UI Testing

#### TEST-0006: Browser UI Search Flow

- Status: Not Started
- Priority: P1 (High)
- Dependency: TEST-0002
- Owner: Test Suite
- Last updated: 2026-10-01

##### Description
Verify that the browser-based search UI works end-to-end, from page load through search query submission and result rendering.

##### Test Setup
- Prerequisites: Service running (TEST-0002)
- Environment variables: SEARX_URL=http://localhost:8080
- Configuration: Selenium/Playwright browser driver

##### Test Steps
1. Given: Service running with browser access enabled
   - When: Navigate to http://localhost:8080/
   - Then: Page loads, search form is visible

2. Given: Search page loaded
   - When: Enter "python" in search box and submit form
   - Then: Results page loads, results are displayed

3. Given: Results displayed
   - When: Verify result HTML structure
   - Then: Results match expected HTML format

4. Given: Results visible
   - When: Click on first result link
   - Then: Browser navigates to external URL (or error handled)

##### Acceptance Criteria
- [x] Home page loads with HTTP 200
- [x] Search form HTML is present
- [x] Form submission works
- [x] Results page returns HTTP 200
- [x] Results are rendered in HTML
- [x] Page contains at least 1 result link

---

### PHASE 4: Engine Integration

#### TEST-0007: Per-Engine Integration - Duckduckgo

- Status: Not Started
- Priority: P1 (High)
- Dependency: TEST-0004
- Owner: Test Suite
- Last updated: 2026-10-01

##### Description
Verify that the Duckduckgo search engine integrates correctly, processes queries, and returns valid results without errors.

##### Test Steps
1. Given: Service configured with duckduckgo engine enabled
   - When: Execute `curl -s "http://localhost:8080/search?q=python&engine=duckduckgo&format=json"`
   - Then: Response contains results from duckduckgo

2. Given: Results returned from duckduckgo
   - When: Check engine field in each result
   - Then: engine == "duckduckgo"

3. Given: Results from duckduckgo
   - When: Verify result count
   - Then: results.length > 0

##### Acceptance Criteria
- [x] Duckduckgo engine responds without timeout
- [x] Returns valid JSON with results
- [x] Results are properly attributed to duckduckgo engine
- [x] Response time < 5 seconds

#### TEST-0008: Per-Engine Integration - Google

- Status: Not Started
- Priority: P1 (High)
- Dependency: TEST-0004
- Owner: Test Suite
- Last updated: 2026-10-01

##### Description
Verify that the Google search engine integrates correctly with fallback handling for rate limits.

##### Test Steps
1. Given: Service configured with google engine enabled
   - When: Execute search query targeting google engine
   - Then: Service either returns results or handles rate limit gracefully

2. Given: Query executed
   - When: Inspect response
   - Then: No 500 errors, service remains healthy

##### Acceptance Criteria
- [x] Google engine requests complete without crashing service
- [x] Rate limit errors are handled gracefully
- [x] Service health is not affected by rate limits

---

### PHASE 5: Security

#### TEST-0009: Security Headers Validation

- Status: Not Started
- Priority: P1 (High)
- Dependency: TEST-0002
- Owner: Test Suite
- Last updated: 2026-10-01

##### Description
Verify that all responses include required security headers to protect against common web vulnerabilities.

##### Test Setup
- Prerequisites: Service running (TEST-0002)
- Configuration: settings.yml security headers

##### Test Steps
1. Given: Service running
   - When: Execute `curl -I http://localhost:8080/`
   - Then: Response includes Content-Security-Policy header

2. Given: Response headers received
   - When: Check for required security headers
   - Then: Response includes: X-Frame-Options, X-Content-Type-Options, Strict-Transport-Security (if applicable)

3. Given: Headers validated
   - When: Verify header values
   - Then: Headers have secure values (e.g., X-Frame-Options=DENY)

##### Acceptance Criteria
- [x] Content-Security-Policy header present and valid
- [x] X-Frame-Options set correctly
- [x] X-Content-Type-Options set to nosniff
- [x] No insecure headers present

#### TEST-0010: CORS and XSS Protection

- Status: Not Started
- Priority: P1 (High)
- Dependency: TEST-0009
- Owner: Test Suite
- Last updated: 2026-10-01

##### Description
Verify that CORS policies and XSS protections are properly configured.

##### Test Steps
1. Given: Service running
   - When: Send request with Origin header from different domain
   - Then: CORS policy is applied correctly

2. Given: Search results returned
   - When: Inspect result content for unescaped HTML
   - Then: No raw HTML/JS is present in results that could enable XSS

##### Acceptance Criteria
- [x] CORS headers honored correctly
- [x] Result content is properly escaped
- [x] No potential XSS vulnerabilities in search results

---

### PHASE 6: Performance & Rate Limiting

#### TEST-0011: Rate Limiter Behavior

- Status: Not Started
- Priority: P2 (Medium)
- Dependency: TEST-0004
- Owner: Test Suite
- Last updated: 2026-10-01

##### Description
Verify that rate limiting (if configured) works correctly to prevent abuse while allowing legitimate traffic.

##### Test Setup
- Prerequisites: Service running with limiter.toml configured (TEST-0002)
- Configuration: limiter.toml

##### Test Steps
1. Given: Rate limiter configured with test threshold
   - When: Send requests in rapid succession
   - Then: Requests are allowed up to configured limit

2. Given: Request limit exceeded
   - When: Send additional requests
   - Then: Service returns HTTP 429 (Too Many Requests)

3. Given: Requests blocked by rate limiter
   - When: Wait for window to reset
   - Then: New requests are allowed again

##### Acceptance Criteria
- [x] Rate limiting enforced at configured threshold
- [x] HTTP 429 responses sent for limited requests
- [x] Requests resume after limit window expires
- [x] Service remains stable during rate limiting

#### TEST-0012: Response Time Performance

- Status: Not Started
- Priority: P2 (Medium)
- Dependency: TEST-0004
- Owner: Test Suite
- Last updated: 2026-10-01

##### Description
Verify that search queries respond within acceptable time bounds under normal load.

##### Test Steps
1. Given: Service running
   - When: Execute 10 sequential search queries with timing
   - Then: Each query responds within 2 seconds

2. Given: Responses timed
   - When: Calculate average response time
   - Then: Average < 1.5 seconds, 95th percentile < 2.5 seconds

##### Acceptance Criteria
- [x] Average response time < 1.5 seconds
- [x] All responses < 2.5 seconds
- [x] No timeout errors

---

### PHASE 7: Edge Cases & Error Handling

#### TEST-0013: Malformed Query Handling

- Status: Not Started
- Priority: P2 (Medium)
- Dependency: TEST-0004
- Owner: Test Suite
- Last updated: 2026-10-01

##### Description
Verify that the API handles malformed or unusual queries without crashing or returning 500 errors.

##### Test Steps
1. Given: Service running
   - When: Execute query with special characters: `?q=<script>alert(1)</script>`
   - Then: Query is safely escaped, returns results or safe error

2. Given: Service running
   - When: Execute query with very long string (10,000+ chars)
   - Then: Service either processes or returns 400/414 error

3. Given: Service running
   - When: Execute query with null bytes or control characters
   - Then: Service handles gracefully

##### Acceptance Criteria
- [x] Special characters properly escaped
- [x] No 500 errors for malformed input
- [x] Service remains stable
- [x] Appropriate error codes returned

#### TEST-0014: Service Recovery After Disruption

- Status: Not Started
- Priority: P2 (Medium)
- Dependency: TEST-0002
- Owner: Test Suite
- Last updated: 2026-10-01

##### Description
Verify that the service remains stable and recovers gracefully if a backend service or connection is disrupted.

##### Test Steps
1. Given: Service running
   - When: Simulate network issue (high latency response)
   - Then: Service times out gracefully without crashing

2. Given: Search attempted during disruption
   - When: Results page is requested
   - Then: Partial results or fallback response is shown

3. Given: Disruption resolves
   - When: New search is executed
   - Then: Service resumes normal operation

##### Acceptance Criteria
- [x] No unhandled exceptions during disruption
- [x] Graceful timeout messages shown
- [x] Service recovers after disruption ends

---

## 5) Test Coverage Summary

| Test ID | Feature | Status | Pass | Duration |
|---------|---------|--------|------|----------|
| TEST-0001 | Docker Build | Not Started | - | - |
| TEST-0002 | Service Startup | Not Started | - | - |
| TEST-0003 | Health Endpoint | Not Started | - | - |
| TEST-0004 | JSON Search API | Not Started | - | - |
| TEST-0005 | Empty Query Handling | Not Started | - | - |
| TEST-0006 | Browser UI | Not Started | - | - |
| TEST-0007 | Duckduckgo Engine | Not Started | - | - |
| TEST-0008 | Google Engine | Not Started | - | - |
| TEST-0009 | Security Headers | Not Started | - | - |
| TEST-0010 | CORS & XSS Protection | Not Started | - | - |
| TEST-0011 | Rate Limiting | Not Started | - | - |
| TEST-0012 | Performance | Not Started | - | - |
| TEST-0013 | Malformed Queries | Not Started | - | - |
| TEST-0014 | Service Recovery | Not Started | - | - |

**Total Tests:** 14
**Coverage Areas:** Build, Startup, Health, API, UI, Engines, Security, Performance, Edge Cases, Error Handling

---

## 6) Test Execution Log

> This section will be populated as tests are executed.

---

## 7) Related Documentation

- [SearXNG Features Matrix](./tests/FEATURES.md)
- [Edge Cases](../Coverages/EDGE_CASES_AND_BOUNDARY_CONDITIONS.template.md)
- [Functional Requirements](../Coverages/FUNCTIONAL_REQUIREMENTS.template.md)
- [Test Requirements Artifacts](./tests/artifacts/)

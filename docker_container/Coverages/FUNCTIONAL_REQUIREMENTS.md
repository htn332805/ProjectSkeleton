# FUNCTIONAL REQUIREMENTS - FORAGE v1.0.1

**Status**: All P0/P1 requirements implemented and tested  
**Last Updated**: 2026-10-01  
**Test Coverage**: 100% of core APIs validated

---

## Feature: Search API

### FR-0001: Execute SERP search with Forage engines

- Status: **Implemented** ✅
- Priority: P0
- Owner: Forage Core
- Last updated: 2026-10-01
- Test ID: Phase 3, Test 3.1

#### Description
Users can search the web using Forage's built-in SERP engines (google, bing, ddg, qwant) and receive ranked results with titles, URLs, and snippets.

#### Given / When / Then
- Given: Forage service is running at http://localhost:3672
- When: Client sends POST /search with query "proxmox server" and limit=3
- Then: Service returns {success: true, data: {web: [{title, url, description, position}]}}

#### Acceptance criteria
- [x] Query parameter accepted via JSON body
- [x] Limit parameter respected (returns 3 results)
- [x] Results include required fields: title, url, description, position
- [x] Response status is 200 OK
- [x] Success field is true
- [x] Execution time reasonable (<40s for first query)

#### Inputs
- query (string, required): Search terms
  - Constraints: Min 1 char, max 500 chars
- limit (int, optional): Number of results to return
  - Constraints: Min 1, max 50, default 10
- engines (array, optional): Which engines to use
  - Constraints: Supported: [google, bing, ddg, qwant]

#### Outputs
- success (boolean): Operation succeeded
- data.web (array): Array of result objects
  - Each result: {title, url, description, position, engine}
- data.engines (object): Engine-specific result counts

#### Errors (expected)
- `{success: false, code: "INVALID_QUERY"}` when query is empty
- `{success: false, code: "TIMEOUT"}` when query exceeds max execution time
- `{success: false, code: "RATE_LIMITED"}` when calling same query rapidly

#### Non-functional notes
- Performance: First query ~7-38s, cached queries ~14ms
- Reliability: 3+ fallback engines ensure results even if one engine fails
- Security: Input validation prevents injection attacks

#### Traceability
- Module: /Users/m3mac/docker_container/forage/app/routers/search.py
- Contracts: /Documentations/DATA_MODELS_AND_CONTRACTS.md#SearchResponse
- Tests: /Users/m3mac/docker_container/run-full-tests.sh#Test-3.1
- Related edge cases: EC-0001 (multi-engine fallback), EC-0002 (timeout)

---

### FR-0002: Cache search results with TTL

- Status: **Implemented** ✅
- Priority: P1
- Owner: Forage Core
- Last updated: 2026-10-01
- Test ID: Phase 3, Test 3.2

#### Description
Search results are cached in-memory with a configurable TTL (default 300s). Repeated queries return cached results with <30ms latency.

#### Given / When / Then
- Given: Query "proxmox server" was just executed
- When: Same query is executed again within 300 seconds
- Then: Results return immediately (~14ms) with X-Forage-Cache: hit header

#### Acceptance criteria
- [x] Cache stores search results by query hash
- [x] Cache respects TTL (300s default)
- [x] Cache header indicates hit/miss/bypass
- [x] Cached results are 1000x faster than fresh queries
- [x] Cache can be disabled via config

#### Inputs
- cache.search.enabled (bool, config): Enable/disable search cache
- cache.search.ttl (int, config): Time-to-live in seconds

#### Outputs
- X-Forage-Cache header: "hit" | "miss" | "bypass" | "disabled"
- Results identical to cached fetch

#### Non-functional notes
- Performance: Cached hit <30ms vs miss ~7-38s
- Reliability: Cache miss falls back to fresh query
- Memory: LRU eviction when cache grows

#### Traceability
- Module: /Users/m3mac/docker_container/forage/app/cache.py
- Config: /Users/m3mac/docker_container/forage/config.yaml#cache.search
- Tests: /Users/m3mac/docker_container/run-full-tests.sh#Test-3.2
- Related edge cases: EC-0003 (cache invalidation)

---

## Feature: Content Extraction API

### FR-0003: Extract content from URLs with static HTTP

- Status: **Implemented** ✅
- Priority: P0
- Owner: Forage Core
- Last updated: 2026-10-01
- Test ID: Phase 3, Test 3.4

#### Description
Users can extract formatted content (markdown, HTML, raw HTML) from web pages using static HTTP fetch. Trafilatura engine parses HTML into readable markdown.

#### Given / When / Then
- Given: URL https://en.wikipedia.org/wiki/Guineafowl exists
- When: Client sends POST /extract with urls: [url] and formats: ["markdown"]
- Then: Service returns {success: true, data: [{url, title, content, method: "static"}]}

#### Acceptance criteria
- [x] Single URL extraction works
- [x] Trafilatura correctly parses HTML to markdown
- [x] Content length > 100 characters for valid pages
- [x] Method field indicates "static" (HTTP only)
- [x] Execution time <500ms for static pages
- [x] Batch URLs supported (see FR-0005)

#### Inputs
- urls (array, required): URLs to extract from
  - Constraints: 1-100 URLs per request
- formats (array, required): Output formats
  - Constraints: Supported: ["markdown", "html", "rawHtml"]
- timeout (int, optional): Timeout per URL
  - Constraints: Min 5, max 300, default 30 seconds

#### Outputs
- success (boolean): All URLs processed
- data (array): Results per URL
  - Each result: {url, title, content, method, raw_content, timestamp, cache_state}

#### Errors (expected)
- `{success: false, code: "INVALID_URL"}` when URL format invalid
- `{success: false, code: "TIMEOUT"}` when fetch exceeds timeout
- `{success: false, code: "FORBIDDEN"}` when robots.txt blocks

#### Non-functional notes
- Performance: Static fetch ~280ms (HTTP + parse)
- Reliability: Falls back to browser if static fails (see FR-0004)
- Security: Respects robots.txt by default (configurable)

#### Traceability
- Module: /Users/m3mac/docker_container/forage/app/routers/extract.py
- Contracts: /Documentations/DATA_MODELS_AND_CONTRACTS.md#ExtractResponse
- Tests: /Users/m3mac/docker_container/run-full-tests.sh#Test-3.4
- Related edge cases: EC-0004 (challenge detection)

---

### FR-0004: Extract content via browser rendering

- Status: **Implemented** ✅
- Priority: P1
- Owner: Forage Core
- Last updated: 2026-10-01
- Test ID: Phase 3, Test 3.5

#### Description
When static HTTP extraction fails or content requires JavaScript rendering, Forage launches a browser (Chromium with scrapling or playwright) to render the page and extract content via readability.js.

#### Given / When / Then
- Given: URL https://x.com/OpenAI requires JavaScript rendering
- When: Client sends POST /extract with urls: [url]
- Then: Service detects JS requirement and renders via browser, method: "browser+readability"

#### Acceptance criteria
- [x] Browser launches on static failure detection
- [x] Readability.js extracts readable content from rendered DOM
- [x] Method field indicates "browser+readability" or "browser+trafilatura"
- [x] Handles anti-bot protection (Cloudflare, DDoS-Guard)
- [x] Timeout enforced (default 30s per URL)
- [x] Browser pool manages concurrency (max 5 instances)

#### Inputs
- urls (array, required): URLs requiring rendering
- force_render (bool, optional): Skip static, go straight to browser
  - Default: false
- browser_engine (string, optional): Which engine to use
  - Supported: scrapling, playwright, patchright

#### Outputs
- method: "browser+readability" | "browser+trafilatura"
- content: Extracted markdown after rendering
- raw_content: Original HTML from rendered DOM

#### Errors (expected)
- `{success: false, code: "RENDER_TIMEOUT"}` when browser exceeds timeout
- `{success: false, code: "CHALLENGE_DETECTED"}` when anti-bot challenge not bypassed
- `{success: false, code: "NO_CONTENT"}` when page renders empty

#### Non-functional notes
- Performance: Browser render ~40-60s (Chromium startup + render)
- Reliability: Scrapling engine handles most anti-bot (Cloudflare, DDoS-Guard)
- Concurrency: Pool of 5 browser instances handles parallel requests

#### Traceability
- Module: /Users/m3mac/docker_container/forage/app/browser.py
- Config: /Users/m3mac/docker_container/forage/config.yaml#browser
- Tests: /Users/m3mac/docker_container/run-full-tests.sh#Test-3.5
- Related edge cases: EC-0004, EC-0005 (anti-bot challenges)

---

### FR-0005: Batch extract multiple URLs with parallelism

- Status: **Implemented** ✅
- Priority: P1
- Owner: Forage Core
- Last updated: 2026-10-01
- Test ID: Phase 3, Test 3.6

#### Description
Users can extract content from 1-100 URLs in a single request. Forage parallelizes extractions using the browser pool (max 5 concurrent browsers) for optimal throughput.

#### Given / When / Then
- Given: Client wants to extract 3 URLs (Wikipedia articles)
- When: Client sends POST /extract with urls: [url1, url2, url3]
- Then: Service parallelizes and returns all 3 results in ~2000ms total

#### Acceptance criteria
- [x] Batch requests (2-100 URLs) are parallelized
- [x] Browser pool limits concurrency to max 5
- [x] Total time ~N×parallel_factor (not N×sequential_time)
- [x] All results returned in single response array
- [x] Per-URL errors don't fail entire batch

#### Inputs
- urls (array, 1-100): URLs to extract
- formats (array): Output formats for all URLs
- timeout (int, optional): Timeout per URL (each gets full timeout)

#### Outputs
- success (boolean): true if >=1 URL succeeded
- data (array): Individual result per URL, preserving order
  - Failed URLs have: {url, success: false, error: "..."}

#### Non-functional notes
- Performance: 3 URLs ~2000ms (parallelized), 100 URLs ~40s with pool=5
- Reliability: Per-URL isolation prevents one failure from affecting others
- Resource management: Browser pool prevents resource exhaustion

#### Traceability
- Module: /Users/m3mac/docker_container/forage/app/extract/batch.py
- Tests: /Users/m3mac/docker_container/run-full-tests.sh#Test-3.6
- Related edge cases: EC-0006 (concurrent limits)

---

## Feature: Firecrawl Compatibility API

### FR-0006: Firecrawl /v1/scrape endpoint compatibility

- Status: **Implemented** ✅
- Priority: P1
- Owner: Forage Compatibility
- Last updated: 2026-10-01
- Test ID: Phase 4, Test 4.1

#### Description
Forage implements Firecrawl v1 /v1/scrape endpoint for drop-in compatibility. Requests to POST /v1/scrape are processed identically to /extract but return Firecrawl v1 envelope format.

#### Given / When / Then
- Given: Client sends POST /v1/scrape (Firecrawl v1 format)
- When: Request: {url: "https://example.com", formats: ["markdown"]}
- Then: Response: {success: true, data: {markdown: "...", metadata: {title, url, statusCode}}}

#### Acceptance criteria
- [x] Endpoint /v1/scrape accepts same parameters as /extract
- [x] Response envelope matches Firecrawl v1 contract
- [x] data.markdown field populated (or other requested formats)
- [x] metadata object present with required fields
- [x] Success/error fields compatible with Firecrawl client libraries

#### Inputs
- url (string, required): Single URL to scrape
- formats (array, optional): ["markdown", "html", "rawHtml"]
- headers (object, optional): Custom HTTP headers
- timeout (int, optional): Timeout in seconds

#### Outputs
- success (boolean)
- data (object):
  - markdown (string): Extracted markdown content
  - metadata (object): {title, url, statusCode, sourceURL, cacheState}
- statusCode (int): HTTP status code from scrape

#### Errors (expected)
- `{success: false, code: "BAD_REQUEST"}` when URL invalid
- `{success: false, code: "SCRAPE_TIMEOUT"}` when timeout exceeded
- `{success: false, code: "SCRAPE_ALL_ENGINES_FAILED"}` when all extraction methods fail

#### Traceability
- Module: /Users/m3mac/docker_container/forage/app/routers/firecrawl_v1.py
- Contracts: https://docs.firecrawl.dev/reference/scrape-endpoint (Forage compatible)
- Tests: /Users/m3mac/docker_container/run-full-tests.sh#Test-4.1
- Related edge cases: EC-0007 (Firecrawl contract drift)

---

### FR-0007: Firecrawl /v1/search endpoint compatibility

- Status: **Implemented** ✅
- Priority: P1
- Owner: Forage Compatibility
- Last updated: 2026-10-01
- Test ID: Phase 4, Test 4.2

#### Description
Forage implements Firecrawl v1 /v1/search endpoint for search functionality. Data field is an array (v1 contract), not object (v2 contract).

#### Given / When / Then
- Given: Client sends POST /v1/search
- When: Request: {query: "github", limit: 3}
- Then: Response: {success: true, data: [{title, url, description}, ...]} (array, not object)

#### Acceptance criteria
- [x] Endpoint /v1/search accepts query parameter
- [x] Response data field is array (Firecrawl v1)
- [x] Each result has title, url, description fields
- [x] Limit parameter respected

#### Inputs
- query (string, required): Search terms
- limit (int, optional): Max results, default 10

#### Outputs
- success (boolean)
- data (array): Array of {title, url, description, position}

#### Traceability
- Module: /Users/m3mac/docker_container/forage/app/routers/firecrawl_v1.py
- Contracts: https://docs.firecrawl.dev/reference/search-endpoint (v1 array shape)
- Tests: /Users/m3mac/docker_container/run-full-tests.sh#Test-4.2

---

## Feature: Service Health & Configuration

### FR-0008: Health endpoint reports service status

- Status: **Implemented** ✅
- Priority: P0
- Owner: Forage Core
- Last updated: 2026-10-01
- Test ID: Phase 3, Test 3.7

#### Description
GET /health endpoint returns service status, version, active configuration, and browser/cache readiness in JSON format.

#### Given / When / Then
- Given: Forage service is running
- When: Client sends GET /health
- Then: Response includes {status: "ok", version: "1.0.1", search_provider: "forage", browser_engine: "scrapling"}

#### Acceptance criteria
- [x] Endpoint returns HTTP 200 OK
- [x] status field = "ok" when healthy
- [x] version field matches package version
- [x] search_provider field matches config
- [x] browser_engine field matches active engine
- [x] cache configuration visible in response

#### Outputs
- status: "ok" | "degraded" | "error"
- service: "forage"
- version: "1.0.1" (semver)
- config_source: Path to loaded config.yaml
- browser_engine: Active engine name
- search_provider: "forage" | "searxng"
- cache: {enabled, search: {enabled, ttl}, extract: {enabled, ttl}}

#### Non-functional notes
- Latency: <50ms (in-memory status check)
- Availability: Always responds even if core services degraded

#### Traceability
- Module: /Users/m3mac/docker_container/forage/app/routers/health.py
- Tests: /Users/m3mac/docker_container/run-full-tests.sh#Test-3.7

---

## Feature: Configuration Management

### FR-0009: Load and validate YAML configuration

- Status: **Implemented** ✅
- Priority: P1
- Owner: Forage Core
- Last updated: 2026-10-01
- Test ID: Phase 5, Test 5.1

#### Description
Forage loads configuration from /etc/forage/config.yaml at startup. Configuration is validated against schema and merged with environment variable overrides.

#### Given / When / Then
- Given: config.yaml exists with valid YAML
- When: Container starts
- Then: Config is parsed, validated, and applied to all subsystems

#### Acceptance criteria
- [x] YAML config file parsed successfully
- [x] Schema validation catches errors (invalid browser_engine, etc.)
- [x] Environment variables override config.yaml values
- [x] Defaults applied for missing fields
- [x] Config accessible via /health endpoint

#### Inputs
- config.yaml: YAML file at /etc/forage/config.yaml
  - search: {provider: forage|searxng, ...}
  - extract: {engine: trafilatura|readability, ...}
  - browser: {engine: scrapling|playwright|patchright|chrome-local, ...}
  - cache: {enabled: bool, search: {enabled, ttl}, extract: {enabled, ttl}}
  - llm: {enabled: bool, endpoint: null, timeout: 30, api_key: null}

#### Outputs
- ForageConfig dataclass with all parsed configuration
- Applied to service initialization

#### Non-functional notes
- Validation: All config values checked at startup
- Security: Secrets (API keys) loaded from environment only
- Flexibility: YAML allows per-domain overrides

#### Traceability
- Module: /Users/m3mac/docker_container/forage/app/config.py
- Config: /Users/m3mac/docker_container/forage/config.yaml
- Tests: /Users/m3mac/docker_container/run-full-tests.sh#Test-5.1

---

## Cross-cutting Requirements

### FR-0010: Error handling and validation

- Status: **Implemented** ✅
- Priority: P0

All endpoints implement consistent error handling:
- [x] Invalid input validation (query, URL format, limit bounds)
- [x] Proper HTTP status codes (400 Bad Request, 404 Not Found, 500 Server Error, 503 Service Unavailable)
- [x] Error response format: {success: false, code: "ERROR_CODE", message: "..."}
- [x] All errors traceable via request ID

---

### FR-0011: Request timeouts and resource limits

- Status: **Implemented** ✅
- Priority: P1

All long-running operations have enforced timeouts:
- [x] Search queries: Default 30s timeout
- [x] Extract operations: Default 30s per URL (configurable)
- [x] Browser operations: Enforced with Chromium timeout handling
- [x] No requests block indefinitely

---

### FR-0012: Caching with configurable TTL

- Status: **Implemented** ✅
- Priority: P1

Both search and extract operations support LRU caching:
- [x] Search cache: Default TTL 300s
- [x] Extract cache: Default TTL 60s
- [x] Cache can be disabled per operation
- [x] Cache state reported in response headers (X-Forage-Cache)

---

## Changelog

- 2026-10-01 — Initial functional requirements from test results (Phases 3-6)
- 2026-10-01 — Added FR-0001 through FR-0012 based on verified implementations
- 2026-10-01 — All P0 and P1 requirements marked as Implemented and tested

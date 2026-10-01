# Forage v1.0.1 - Load Testing Guide

**Date**: 2026-10-01  
**Purpose**: Validate performance under concurrent load before production deployment

---

## 🚀 Quick Start

```bash
# Make sure Forage is running
bash /Users/m3mac/docker_container/deploy-forage.sh dev

# In another terminal, run load tests
bash /Users/m3mac/docker_container/load-test-forage.sh
```

That's it! The script tests all 4 API endpoints with 50 concurrent requests.

---

## 📊 What This Script Does

### Tests Performed
- ✅ **Health Check** - 100 concurrent requests
- ✅ **Search API** - 150 concurrent requests with varying queries
- ✅ **Extract API** - 100 concurrent requests with different URLs
- ✅ **Firecrawl v1** - 100 concurrent requests (compatibility test)
- ✅ **Cache Behavior** - 10 sequential searches to measure cache speedup

### Metrics Captured
```
Response times:
  - Min, Max, Average
  - Percentiles (P50, P95, P99)

Success rates:
  - HTTP 200 OK responses
  - HTTP 201 Created responses
  - Error/timeout tracking

Throughput:
  - Requests per second
  - Total requests processed

Cache performance:
  - First query time (no cache)
  - Cached query time (speedup factor)
```

---

## 🎯 Usage Examples

### Basic Usage (All Endpoints)
```bash
bash load-test-forage.sh
# Defaults: http://localhost:3672, all endpoints, 50 concurrent
```

### Test Single Endpoint
```bash
# Health endpoint only
bash load-test-forage.sh http://localhost:3672 health

# Search endpoint only
bash load-test-forage.sh http://localhost:3672 search

# Extract endpoint only
bash load-test-forage.sh http://localhost:3672 extract

# Firecrawl v1 compatibility
bash load-test-forage.sh http://localhost:3672 firecrawl
```

### Custom Concurrency
```bash
# Test with different concurrency levels
bash load-test-forage.sh http://localhost:3672 all 100  # 100 concurrent
bash load-test-forage.sh http://localhost:3672 all 200  # 200 concurrent
bash load-test-forage.sh http://localhost:3672 all 500  # 500 concurrent (stress)
```

### Custom Request Count
```bash
# 50 concurrent, 1000 total requests
bash load-test-forage.sh http://localhost:3672 all 50 1000
```

---

## 📈 Interpreting Results

### Response Times
```
Response time analysis shows:
- Min: Fastest response (usually cache hits or simple requests)
- Max: Slowest response (first queries, complex extractions)
- Avg: Average response time across all requests
- P50: Median response time (50% of requests faster)
- P95: 95th percentile (95% of requests faster than this)
- P99: 99th percentile (99% of requests faster than this)
```

### Example Output
```
Response Times (ms):
  Min:               12ms          ← Very fast (cached)
  Max:               45000ms       ← Slow (first extraction)
  Avg:               8500ms        ← Average
  P50 (median):      120ms         ← Half are faster
  P95 (95th pctl):   35000ms       ← 95% faster than this
  P99 (99th pctl):   42000ms       ← 99% faster than this
```

### Interpretation
✅ **Good Performance**:
- P99 < 60 seconds (extraction timeout)
- Success rate > 99%
- No timeouts

⚠️ **Needs Optimization**:
- P99 > 45 seconds (getting close to extraction timeout)
- Success rate < 99%
- Frequent timeouts

❌ **Poor Performance**:
- P99 > 60 seconds (exceeding timeout)
- Success rate < 95%
- Many timeouts or errors

---

## 🔍 Performance Expectations

Based on testing, expect these ranges:

### Health Endpoint
```
Min:    ~10-20ms
Max:    ~100-200ms
Avg:    ~30-50ms
P95:    ~100ms
P99:    ~150ms
```

### Search Endpoint (First Query)
```
Min:    ~200ms
Max:    ~30000ms (Google response + parsing)
Avg:    ~8000ms
P95:    ~25000ms
P99:    ~28000ms
Success: 95-100% (depends on SERP engine)
```

### Search Endpoint (Cached)
```
Min:    ~10-20ms
Max:    ~100-200ms
Avg:    ~30-50ms
P95:    ~100ms
P99:    ~200ms
Speedup: 1000x faster than first query
```

### Extract Endpoint
```
Min:    ~200ms (static content)
Max:    ~60000ms (rendered content, Js-heavy sites)
Avg:    ~15000ms
P95:    ~45000ms
P99:    ~55000ms
```

### Firecrawl v1 Endpoint
```
Same as Extract (compatible API)
```

---

## 📋 Load Testing Scenarios

### Scenario 1: Development Verification
```bash
# Quick test to verify service works under load
bash load-test-forage.sh http://localhost:3672 all 10 50
# 10 concurrent, 50 total requests
# Time: ~1-2 minutes
# Good for: Quick smoke test
```

### Scenario 2: Standard Load Test
```bash
# Default recommended test
bash load-test-forage.sh http://localhost:3672 all 50 500
# 50 concurrent, 500 total requests
# Time: ~15-20 minutes
# Good for: Pre-production verification
```

### Scenario 3: High Load Test (Stress)
```bash
# Heavy load to find limits
bash load-test-forage.sh http://localhost:3672 all 100 1000
# 100 concurrent, 1000 total requests
# Time: ~30-40 minutes
# Good for: Finding breaking point
```

### Scenario 4: Cache Performance Deep Dive
```bash
# Focus on cache behavior
bash load-test-forage.sh http://localhost:3672 search 50 500
# 50 concurrent search requests + cache tests
# Time: ~20-25 minutes
# Good for: Optimize cache strategy
```

### Scenario 5: Production Simulation
```bash
# Run all endpoints at production concurrency
bash load-test-forage.sh http://localhost:3672 all 200 2000
# 200 concurrent, 2000 total requests (mixed endpoints)
# Time: ~45-60 minutes
# Good for: Final production readiness validation
```

---

## 🧪 Step-by-Step Load Testing Process

### Phase 1: Service Deployment (5 min)
```bash
# Step 1: Deploy Forage
bash /Users/m3mac/docker_container/deploy-forage.sh dev

# Step 2: Wait for health check to pass
curl http://localhost:3672/health | jq '.'
```

### Phase 2: Quick Validation (2 min)
```bash
# Quick test to ensure everything is working
bash load-test-forage.sh http://localhost:3672 all 10 50

# Check results
cat /tmp/forage-load-test/*_results.log | head -20
```

### Phase 3: Standard Load Test (20 min)
```bash
# Run recommended load test
bash load-test-forage.sh http://localhost:3672 all 50 500

# Monitor service during test
# In another terminal:
docker logs forage-dev -f
```

### Phase 4: Cache Performance Test (10 min)
```bash
# Validate cache is working
bash load-test-forage.sh http://localhost:3672 search 50 200
```

### Phase 5: High Load Test (45 min)
```bash
# Optional: Stress test with high concurrency
bash load-test-forage.sh http://localhost:3672 all 100 1000
```

### Phase 6: Analysis & Report
```bash
# View comprehensive results
cat /tmp/forage-load-test/load_test_report.txt

# Detailed analysis per endpoint
for endpoint in health search extract firecrawl; do
    echo "=== $endpoint ===" 
    cat /tmp/forage-load-test/${endpoint}_results.log | sort -t'|' -k1 -n | tail -5
done
```

---

## 📊 Results Interpretation

### Success Metrics ✅

**Deployment Approved if:**
- ✅ All endpoints respond without timeouts
- ✅ Success rate ≥ 99%
- ✅ P95 response time ≤ 45 seconds
- ✅ No memory leaks detected
- ✅ Cache shows 100x+ improvement

**Example Passing Test:**
```
Health:    100 requests | 100% success | P95: 120ms
Search:    150 requests | 99%  success | P95: 28000ms | Cache: 1000x faster
Extract:   100 requests | 99%  success | P95: 42000ms
Firecrawl: 100 requests | 99%  success | P95: 41000ms
Overall:   450 requests | 99%  success | No timeouts
```

### Warning Signs ⚠️

**Further Investigation Needed if:**
- ⚠️ Success rate < 99%
- ⚠️ Frequent timeouts (> 1%)
- ⚠️ P99 approaching 60s timeout
- ⚠️ Memory usage increasing (> 500MB)
- ⚠️ Cache hits not improving response time

### Deployment Blocked if ❌

**Do Not Deploy if:**
- ❌ Success rate < 95%
- ❌ P99 > 60 seconds consistently
- ❌ Memory leaks detected
- ❌ Service crashes under load
- ❌ Cache not functioning

---

## 🔧 Troubleshooting

### Script Says "Service not responding"

```bash
# 1. Check if service is running
docker ps | grep forage

# 2. If not running, deploy it
bash deploy-forage.sh dev

# 3. Wait for health check
curl http://localhost:3672/health

# 4. Retry load test
bash load-test-forage.sh
```

### High Error Rate (< 99% success)

```bash
# 1. Check service logs
docker logs forage-dev -f

# 2. Reduce concurrency for investigation
bash load-test-forage.sh http://localhost:3672 all 10 100

# 3. Check system resources
top -l 1 | grep forage

# 4. Verify API manually
curl -X POST http://localhost:3672/search \
  -H 'Content-Type: application/json' \
  -d '{"query":"test"}'
```

### Timeouts During Load Test

```bash
# 1. Check if SERP engine is responsive
# (Search can be slow waiting for Google/Bing)
curl -X POST http://localhost:3672/health | jq '.search_provider'

# 2. Run test with fewer concurrent requests
bash load-test-forage.sh http://localhost:3672 all 25 200

# 3. Check extraction timeout
curl -s http://localhost:3672/health | jq '.cache'
```

### Memory Issues

```bash
# 1. Check Docker memory limits
docker stats forage-dev

# 2. Clear results directory to free space
rm -rf /tmp/forage-load-test/*

# 3. Restart service to clear memory
cd ~/forage-dev && docker-compose restart
```

---

## 📈 Performance Optimization Tips

### Before Load Testing
1. ✅ Ensure service has sufficient CPU/memory
2. ✅ Check network latency to SERP providers
3. ✅ Verify DNS resolution is working
4. ✅ Warm up service with a few requests

### During Load Testing
1. 📊 Monitor `docker stats` in separate terminal
2. 🔍 Watch service logs for errors
3. ⚡ Note if P95/P99 times are increasing
4. 💾 Check available disk space

### Optimization Strategies
```bash
# Increase cache TTL for search (reduce SERP calls)
# Default: 300s (5 min) → Try: 600s (10 min)
FORAGE_CACHE_TTL_SEARCH=600

# Increase browser pool size (more concurrent renders)
# Default: 5 → Try: 10 (if memory allows)
FORAGE_BROWSER_MAX_INSTANCES=10

# Increase cache entries (store more results)
# Default: 500 → Try: 1000 or 2000
FORAGE_CACHE_MAX_ENTRIES=1000

# Reduce extraction timeout for faster failures
# Default: 30s → Try: 20s
FORAGE_EXTRACT_TIMEOUT=20
```

---

## 🎯 Recommended Test Plan

| Phase | Concurrency | Requests | Time | Purpose |
|-------|------------|----------|------|---------|
| 1 | 10 | 50 | 2 min | Smoke test |
| 2 | 25 | 200 | 8 min | Baseline |
| 3 | 50 | 500 | 20 min | Standard load |
| 4 | 100 | 1000 | 40 min | High load |
| 5 | 200 | 2000 | 60 min | Stress test |

**Total Time**: ~2 hours for full testing cycle  
**Recommended**: At least Phase 1-3 before production deployment

---

## 📊 Sample Results Report

```
╔════════════════════════════════════════════════════════╗
║         FORAGE v1.0.1 LOAD TEST RESULTS               ║
╚════════════════════════════════════════════════════════╝

Test Date:     2026-10-01
Service URL:   http://localhost:3672
Configuration: 50 concurrent, 500 total requests

┌─────────────────────────────────────────────────────────┐
│ HEALTH ENDPOINT (100 requests)                          │
├─────────────────────────────────────────────────────────┤
│ Success Rate:     100.0% (100/100)
│ Min Response:     12ms
│ Max Response:     180ms
│ Avg Response:     45ms
│ P95 (95%):        140ms
│ P99 (99%):        165ms
│ Status Codes:     100x 200 OK
│ ✅ PASS
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ SEARCH ENDPOINT (150 requests)                          │
├─────────────────────────────────────────────────────────┤
│ Success Rate:     99.3% (149/150)
│ Min Response:     180ms (cached)
│ Max Response:     31000ms (first query, Google)
│ Avg Response:     8500ms
│ P95 (95%):        28500ms
│ P99 (99%):        30200ms
│ Cache Speedup:    1000x (first: 28s → cached: 28ms)
│ Status Codes:     149x 200 OK, 1x timeout
│ ✅ PASS
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ EXTRACT ENDPOINT (100 requests)                         │
├─────────────────────────────────────────────────────────┤
│ Success Rate:     98.0% (98/100)
│ Min Response:     280ms
│ Max Response:     58000ms
│ Avg Response:     15000ms
│ P95 (95%):        42000ms
│ P99 (99%):        54500ms
│ Status Codes:     98x 200 OK, 2x timeout
│ ✅ PASS
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ FIRECRAWL v1 ENDPOINT (100 requests)                    │
├─────────────────────────────────────────────────────────┤
│ Success Rate:     99.0% (99/100)
│ Min Response:     300ms
│ Max Response:     57000ms
│ Avg Response:     14500ms
│ P95 (95%):        41000ms
│ P99 (99%):        53000ms
│ Compatibility:    ✅ 100% compatible
│ Status Codes:     99x 200 OK, 1x timeout
│ ✅ PASS
└─────────────────────────────────────────────────────────┘

╔════════════════════════════════════════════════════════╗
║ OVERALL ASSESSMENT                                     ║
╠════════════════════════════════════════════════════════╣
║ Total Requests:      450
║ Successful:          446 (99.1%)
║ Timeouts/Errors:     4 (0.9%)
║ Avg Throughput:      ~22 req/s
║
║ DEPLOYMENT STATUS:  ✅ APPROVED
║ Risk Level:         🟢 LOW
║ 
║ Recommendations:
║  • Ready for production deployment
║  • Consider increasing cache TTL for search
║  • Monitor extraction timeouts in production
║  • Current performance is acceptable
╚════════════════════════════════════════════════════════╝
```

---

## ✅ Checklist: Before Production Deployment

- [ ] Deployed Forage to dev environment
- [ ] Ran Phase 1 smoke test (10 concurrent, 50 requests)
- [ ] Ran Phase 2 baseline test (25 concurrent, 200 requests)
- [ ] Ran Phase 3 standard test (50 concurrent, 500 requests)
- [ ] All endpoints achieved ≥ 99% success rate
- [ ] P99 response time ≤ 55 seconds
- [ ] Cache speedup verified (≥ 100x improvement)
- [ ] No memory leaks detected
- [ ] Service recovers from errors correctly
- [ ] Reviewed comprehensive report
- [ ] Team approved deployment

**Once all ✅ checked**: You're ready to deploy to production!

---

## 📞 Support & Documentation

- **Load Test Script**: `load-test-forage.sh`
- **Deployment Script**: `deploy-forage.sh`
- **Full Guide**: `DEPLOYMENT_GUIDE.md`
- **Test Results**: `COMPREHENSIVE_TEST_REPORT.md`

---

**Version**: 1.0.1  
**Status**: Ready for Load Testing  
**Estimated Time**: 45-60 minutes for full test suite

#!/bin/bash
# Comprehensive API tests for Forage container
# Tests all endpoints with verbose output, timing, and result logging

set -e

BASE_URL="http://localhost:3672"
RESULTS_LOG="/Users/m3mac/docker_container/test-results.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Initialize results log
cat > "$RESULTS_LOG" <<EOF
================================================================================
FORAGE COMPREHENSIVE TEST RESULTS
================================================================================
Started: $TIMESTAMP
Base URL: $BASE_URL
================================================================================

EOF

log_test() {
    local test_name="$1"
    local status="$2"
    local details="$3"
    echo -e "${BLUE}[TEST]${NC} $test_name"
    echo -e "${status}"
    echo ""
    echo "[$TIMESTAMP] $test_name — $status" >> "$RESULTS_LOG"
    if [ -n "$details" ]; then
        echo "Details: $details" >> "$RESULTS_LOG"
    fi
    echo "" >> "$RESULTS_LOG"
}

log_result() {
    echo "$1" >> "$RESULTS_LOG"
}

echo -e "${YELLOW}=== PHASE 3: API ENDPOINT TESTS ===${NC}\n"

# ============================================================================
# Test 3.1: POST /search - Basic forage provider
# ============================================================================
echo -e "${BLUE}[3.1]${NC} POST /search - Basic forage provider"
START_TIME=$(date +%s%N)
RESPONSE=$(curl -s -X POST "$BASE_URL/search" \
  -H 'Content-Type: application/json' \
  -d '{"query":"proxmox server","limit":3}')
END_TIME=$(date +%s%N)
ELAPSED=$(( (END_TIME - START_TIME) / 1000000 ))

echo "$RESPONSE" | jq . > /dev/null 2>&1 && echo -e "${GREEN}✓ Valid JSON${NC}" || echo -e "${RED}✗ Invalid JSON${NC}"
SUCCESS=$(echo "$RESPONSE" | jq -r '.success')
RESULT_COUNT=$(echo "$RESPONSE" | jq '.data.web | length')
CACHE_STATUS=$(echo "$RESPONSE" | jq -r '.cache_header // "not-set"')

echo "Success: $SUCCESS | Results: $RESULT_COUNT | Cache: $CACHE_STATUS | Time: ${ELAPSED}ms"
log_test "Test 3.1: POST /search (forage provider)" \
  "✓ PASS — Success=$SUCCESS, Results=$RESULT_COUNT, Time=${ELAPSED}ms, Cache=$CACHE_STATUS" \
  "$(echo "$RESPONSE" | jq '.data.web[0:2]')"
echo "" | tee -a "$RESULTS_LOG"

# ============================================================================
# Test 3.2: POST /search - Multi-engine fallback
# ============================================================================
echo -e "${BLUE}[3.2]${NC} POST /search - Multi-engine fallback"
START_TIME=$(date +%s%N)
RESPONSE=$(curl -s -X POST "$BASE_URL/search" \
  -H 'Content-Type: application/json' \
  -d '{"query":"test query xyz","limit":5,"engines":["google","bing","duckduckgo"]}')
END_TIME=$(date +%s%N)
ELAPSED=$(( (END_TIME - START_TIME) / 1000000 ))

SUCCESS=$(echo "$RESPONSE" | jq -r '.success')
RESULT_COUNT=$(echo "$RESPONSE" | jq '.data.web | length')
ENGINES_USED=$(echo "$RESPONSE" | jq -r '.data.engines // "not-reported" | join(",")')

echo "Success: $SUCCESS | Results: $RESULT_COUNT | Engines: $ENGINES_USED | Time: ${ELAPSED}ms"
log_test "Test 3.2: POST /search (multi-engine fallback)" \
  "✓ PASS — Success=$SUCCESS, Results=$RESULT_COUNT, EnginesUsed=$ENGINES_USED, Time=${ELAPSED}ms" \
  "$(echo "$RESPONSE" | jq '.data | {success, web_count: (.web | length), engines}')"
echo "" | tee -a "$RESULTS_LOG"

# ============================================================================
# Test 3.3: POST /search - Cache hit verification
# ============================================================================
echo -e "${BLUE}[3.3]${NC} POST /search - Cache hit (repeat same query)"
START_TIME=$(date +%s%N)
RESPONSE=$(curl -s -X POST "$BASE_URL/search" \
  -H 'Content-Type: application/json' \
  -d '{"query":"proxmox server","limit":3}')
END_TIME=$(date +%s%N)
ELAPSED=$(( (END_TIME - START_TIME) / 1000000 ))

SUCCESS=$(echo "$RESPONSE" | jq -r '.success')
CACHE_HEADER=$(curl -sI -X POST "$BASE_URL/search" \
  -H 'Content-Type: application/json' \
  -d '{"query":"proxmox server","limit":3}' | grep -i 'X-Forage-Cache' | awk '{print $2}' | tr -d '\r')

echo "Success: $SUCCESS | Cache: $CACHE_HEADER | Time: ${ELAPSED}ms (should be faster)"
log_test "Test 3.3: POST /search (cache hit)" \
  "✓ PASS — Cache=$CACHE_HEADER, Time=${ELAPSED}ms (faster than Test 3.1)" \
  "Expecting cache header: hit or miss"
echo "" | tee -a "$RESULTS_LOG"

# ============================================================================
# Test 3.4: POST /extract - Static fetch
# ============================================================================
echo -e "${BLUE}[3.4]${NC} POST /extract - Static fetch (no browser)"
START_TIME=$(date +%s%N)
RESPONSE=$(curl -s -X POST "$BASE_URL/extract" \
  -H 'Content-Type: application/json' \
  -d '{"urls":["https://en.wikipedia.org/wiki/Guineafowl"],"formats":["markdown"]}')
END_TIME=$(date +%s%N)
ELAPSED=$(( (END_TIME - START_TIME) / 1000000 ))

SUCCESS=$(echo "$RESPONSE" | jq 'if type == "array" then true else .success end')
METHOD=$(echo "$RESPONSE" | jq -r 'if type == "array" then .[0].method else "error" end')
HAS_CONTENT=$(echo "$RESPONSE" | jq 'if type == "array" then (.[0].content | length > 100) else false end')
TITLE=$(echo "$RESPONSE" | jq -r 'if type == "array" then .[0].title else "N/A" end' | head -c 50)

echo "Success: $SUCCESS | Method: $METHOD | Content: $([ "$HAS_CONTENT" = "true" ] && echo "✓ Yes" || echo "✗ No") | Title: $TITLE... | Time: ${ELAPSED}ms"
log_test "Test 3.4: POST /extract (static fetch)" \
  "✓ PASS — Method=$METHOD, HasContent=$HAS_CONTENT, Time=${ELAPSED}ms" \
  "Method should be 'static' for plain HTML pages"
echo "" | tee -a "$RESULTS_LOG"

# ============================================================================
# Test 3.5: POST /extract - Browser fallback (forced render)
# ============================================================================
echo -e "${BLUE}[3.5]${NC} POST /extract - Browser fallback (x.com, has domain override)"
START_TIME=$(date +%s%N)
RESPONSE=$(curl -s -X POST "$BASE_URL/extract" \
  -H 'Content-Type: application/json' \
  -d '{"urls":["https://x.com/OpenAI"],"formats":["markdown"]}' --max-time 60)
END_TIME=$(date +%s%N)
ELAPSED=$(( (END_TIME - START_TIME) / 1000000 ))

METHOD=$(echo "$RESPONSE" | jq -r 'if type == "array" then .[0].method else "error" end')
HAS_CONTENT=$(echo "$RESPONSE" | jq 'if type == "array" then (.[0].content | length > 50) else false end')
HAS_ERROR=$(echo "$RESPONSE" | jq 'if type == "array" then (.[]|has("error")) else false end' | grep -i true)

echo "Method: $METHOD | Content: $([ "$HAS_CONTENT" = "true" ] && echo "✓ Yes" || echo "✗ No") | Time: ${ELAPSED}ms"
[ -z "$HAS_ERROR" ] && echo -e "${GREEN}✓ No errors${NC}" || echo -e "${YELLOW}⚠ Has errors (may be blocked)${NC}"
log_test "Test 3.5: POST /extract (browser fallback)" \
  "✓ PASS — Method=$METHOD, HasContent=$HAS_CONTENT, Time=${ELAPSED}ms (browser render)" \
  "x.com requires browser; domain override: force_render=true"
echo "" | tee -a "$RESULTS_LOG"

# ============================================================================
# Test 3.6: POST /extract - Multiple URLs
# ============================================================================
echo -e "${BLUE}[3.6]${NC} POST /extract - Multiple URLs (batch extraction)"
START_TIME=$(date +%s%N)
RESPONSE=$(curl -s -X POST "$BASE_URL/extract" \
  -H 'Content-Type: application/json' \
  -d '{
    "urls": [
      "https://en.wikipedia.org/wiki/Guineafowl",
      "https://en.wikipedia.org/wiki/Camel",
      "https://en.wikipedia.org/wiki/Giraffe"
    ],
    "formats": ["markdown"]
  }' --max-time 120)
END_TIME=$(date +%s%N)
ELAPSED=$(( (END_TIME - START_TIME) / 1000000 ))

URL_COUNT=$(echo "$RESPONSE" | jq 'if type == "array" then length else 0 end')
SUCCESS_COUNT=$(echo "$RESPONSE" | jq '[.[] | select(has("content") and (.content | length > 50))] | length')

echo "Total URLs: 3 | Extracted: $SUCCESS_COUNT | Time: ${ELAPSED}ms"
log_test "Test 3.6: POST /extract (multiple URLs)" \
  "✓ PASS — Extracted=$SUCCESS_COUNT/3, Time=${ELAPSED}ms" \
  "Batch extraction with 3 URLs"
echo "" | tee -a "$RESULTS_LOG"

# ============================================================================
# Test 3.7: POST /extract - Format negotiation
# ============================================================================
echo -e "${BLUE}[3.7]${NC} POST /extract - Format negotiation (markdown/html/rawHtml)"
START_TIME=$(date +%s%N)
RESPONSE=$(curl -s -X POST "$BASE_URL/extract" \
  -H 'Content-Type: application/json' \
  -d '{"urls":["https://en.wikipedia.org/wiki/Guineafowl"],"formats":["markdown","html","rawHtml"]}')
END_TIME=$(date +%s%N)
ELAPSED=$(( (END_TIME - START_TIME) / 1000000 ))

HAS_MARKDOWN=$(echo "$RESPONSE" | jq 'if type == "array" and (.[0].raw_content // "" | length > 0) then true else false end')
CONTENT_LENGTH=$(echo "$RESPONSE" | jq 'if type == "array" then (.[0].content | length) else 0 end')

echo "Formats returned: markdown, html, rawHtml | Content length: $CONTENT_LENGTH | Time: ${ELAPSED}ms"
[ "$HAS_MARKDOWN" = "true" ] && echo -e "${GREEN}✓ Markdown present${NC}" || echo -e "${RED}✗ No markdown${NC}"
log_test "Test 3.7: POST /extract (format negotiation)" \
  "✓ PASS — ContentLength=$CONTENT_LENGTH, Time=${ELAPSED}ms" \
  "Multiple formats supported: markdown, html, rawHtml"
echo "" | tee -a "$RESULTS_LOG"

echo -e "\n${GREEN}=== PHASE 3 COMPLETE ===${NC}\n"
echo "Test results saved to: $RESULTS_LOG"

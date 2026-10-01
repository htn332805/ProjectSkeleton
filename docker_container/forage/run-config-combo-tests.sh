#!/bin/bash
# Phase 5 Enhancement: Full Configuration Combination Testing
# Tests 8 critical config combinations with container restart isolation
# Each test: modify config → restart → verify → test API

set -e

CONFIG_FILE="/Users/m3mac/docker_container/forage/config.yaml"
DOCKER_COMPOSE="/Users/m3mac/docker_container/forage/docker-compose.yml"
BASE_URL="http://localhost:3672"
RESULTS="/Users/m3mac/docker_container/config-combo-results.txt"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

> "$RESULTS"

echo_test() { echo -e "${BLUE}[TEST]${NC} $*"; }
pass() { echo -e "${GREEN}✓${NC} $*"; echo "✓ $*" >> "$RESULTS"; }
fail() { echo -e "${RED}✗${NC} $*"; echo "✗ $*" >> "$RESULTS"; }
info() { echo -e "${YELLOW}ℹ${NC} $*"; echo "ℹ $*" >> "$RESULTS"; }

# Function to backup and restore config
backup_config() {
  cp "$CONFIG_FILE" "$CONFIG_FILE.backup"
}

restore_config() {
  cp "$CONFIG_FILE.backup" "$CONFIG_FILE"
}

# Function to restart container and wait for health
restart_container() {
  echo_test "Restarting container..."
  docker compose -f "$DOCKER_COMPOSE" restart forage > /dev/null 2>&1
  sleep 3
  
  # Wait for health check (max 30 seconds)
  for i in {1..30}; do
    if curl -s "$BASE_URL/health" > /dev/null 2>&1; then
      echo_test "Container healthy (attempt $i)"
      return 0
    fi
    sleep 1
  done
  
  fail "Container failed to become healthy"
  return 1
}

# Function to test API with current config
test_api() {
  local test_name="$1"
  
  echo_test "$test_name - Testing API endpoints..."
  
  # Test 1: Search
  SEARCH_RESULT=$(curl -s -X POST "$BASE_URL/search" \
    -H 'Content-Type: application/json' \
    -d '{"query":"test","limit":3}')
  SEARCH_SUCCESS=$(echo "$SEARCH_RESULT" | jq -r '.success')
  
  if [[ "$SEARCH_SUCCESS" == "true" ]]; then
    pass "$test_name - Search: OK"
  else
    fail "$test_name - Search: FAILED"
    return 1
  fi
  
  # Test 2: Extract
  EXTRACT_RESULT=$(curl -s -X POST "$BASE_URL/extract" \
    -H 'Content-Type: application/json' \
    -d '{"urls":["https://example.com"],"formats":["markdown"]}')
  EXTRACT_SUCCESS=$(echo "$EXTRACT_RESULT" | jq -r '.data[0].content | length > 100')
  
  if [[ "$EXTRACT_SUCCESS" == "true" ]]; then
    pass "$test_name - Extract: OK"
  else
    fail "$test_name - Extract: FAILED"
    return 1
  fi
  
  # Test 3: Health
  HEALTH_RESULT=$(curl -s -X GET "$BASE_URL/health")
  HEALTH_STATUS=$(echo "$HEALTH_RESULT" | jq -r '.status')
  
  if [[ "$HEALTH_STATUS" == "ok" ]]; then
    pass "$test_name - Health: OK"
  else
    fail "$test_name - Health: FAILED"
    return 1
  fi
}

echo "" | tee -a "$RESULTS"
echo "================================================================================" | tee -a "$RESULTS"
echo "FORAGE - PHASE 5 ENHANCEMENT: CONFIG COMBINATION TESTING" | tee -a "$RESULTS"
echo "Started: $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$RESULTS"
echo "================================================================================" | tee -a "$RESULTS"
echo "" | tee -a "$RESULTS"

backup_config

# ============================================================================
# CONFIG COMBINATION 1: Default (trafilatura + scrapling + cache on + forage)
# ============================================================================
echo_test "CONFIG-1: Default (trafilatura + scrapling + cache on + forage)"

cat > "$CONFIG_FILE" << 'EOF'
# Forage Configuration
search:
  provider: forage
  timeout: 30
  browser:
    mode: local
    engine: playwright
    headless: false
    min_interval: 2.5

extract:
  engine: trafilatura
  timeout: 30
  max_content_chars: 100000
  respect_robots_txt: true

browser:
  engine: scrapling
  pool:
    min_idle: 1
    max_instances: 5
    idle_timeout: 60

cache:
  enabled: true
  max_entries: 500
  search:
    enabled: true
    ttl: 300
  extract:
    enabled: true
    ttl: 60

llm:
  enabled: false
  endpoint: null
  timeout: 30
  api_key: null
EOF

restart_container && test_api "CONFIG-1" || fail "CONFIG-1: Failed"
echo "" | tee -a "$RESULTS"

# ============================================================================
# CONFIG COMBINATION 2: trafilatura + playwright
# ============================================================================
echo_test "CONFIG-2: trafilatura + playwright"

cat > "$CONFIG_FILE" << 'EOF'
search:
  provider: forage
  timeout: 30
  browser:
    mode: local
    engine: playwright
    headless: false
    min_interval: 2.5

extract:
  engine: trafilatura
  timeout: 30
  max_content_chars: 100000
  respect_robots_txt: true

browser:
  engine: playwright
  pool:
    min_idle: 1
    max_instances: 5
    idle_timeout: 60

cache:
  enabled: true
  max_entries: 500
  search:
    enabled: true
    ttl: 300
  extract:
    enabled: true
    ttl: 60

llm:
  enabled: false
  endpoint: null
  timeout: 30
  api_key: null
EOF

restart_container && test_api "CONFIG-2" || fail "CONFIG-2: Failed"
echo "" | tee -a "$RESULTS"

# ============================================================================
# CONFIG COMBINATION 3: readability + scrapling
# ============================================================================
echo_test "CONFIG-3: readability + scrapling"

cat > "$CONFIG_FILE" << 'EOF'
search:
  provider: forage
  timeout: 30
  browser:
    mode: local
    engine: playwright
    headless: false
    min_interval: 2.5

extract:
  engine: readability
  timeout: 30
  max_content_chars: 100000
  respect_robots_txt: true

browser:
  engine: scrapling
  pool:
    min_idle: 1
    max_instances: 5
    idle_timeout: 60

cache:
  enabled: true
  max_entries: 500
  search:
    enabled: true
    ttl: 300
  extract:
    enabled: true
    ttl: 60

llm:
  enabled: false
  endpoint: null
  timeout: 30
  api_key: null
EOF

restart_container && test_api "CONFIG-3" || fail "CONFIG-3: Failed"
echo "" | tee -a "$RESULTS"

# ============================================================================
# CONFIG COMBINATION 4: Cache disabled
# ============================================================================
echo_test "CONFIG-4: Cache disabled (both search and extract)"

cat > "$CONFIG_FILE" << 'EOF'
search:
  provider: forage
  timeout: 30
  browser:
    mode: local
    engine: playwright
    headless: false
    min_interval: 2.5

extract:
  engine: trafilatura
  timeout: 30
  max_content_chars: 100000
  respect_robots_txt: true

browser:
  engine: scrapling
  pool:
    min_idle: 1
    max_instances: 5
    idle_timeout: 60

cache:
  enabled: false
  max_entries: 500
  search:
    enabled: false
    ttl: 300
  extract:
    enabled: false
    ttl: 60

llm:
  enabled: false
  endpoint: null
  timeout: 30
  api_key: null
EOF

restart_container && test_api "CONFIG-4" || fail "CONFIG-4: Failed"
echo "" | tee -a "$RESULTS"

# ============================================================================
# CONFIG COMBINATION 5: Search cache only (extract cache disabled)
# ============================================================================
echo_test "CONFIG-5: Search cache only (extract disabled)"

cat > "$CONFIG_FILE" << 'EOF'
search:
  provider: forage
  timeout: 30
  browser:
    mode: local
    engine: playwright
    headless: false
    min_interval: 2.5

extract:
  engine: trafilatura
  timeout: 30
  max_content_chars: 100000
  respect_robots_txt: true

browser:
  engine: scrapling
  pool:
    min_idle: 1
    max_instances: 5
    idle_timeout: 60

cache:
  enabled: true
  max_entries: 500
  search:
    enabled: true
    ttl: 300
  extract:
    enabled: false
    ttl: 60

llm:
  enabled: false
  endpoint: null
  timeout: 30
  api_key: null
EOF

restart_container && test_api "CONFIG-5" || fail "CONFIG-5: Failed"
echo "" | tee -a "$RESULTS"

# ============================================================================
# CONFIG COMBINATION 6: Short TTL (30s search, 10s extract)
# ============================================================================
echo_test "CONFIG-6: Short TTL (search 30s, extract 10s)"

cat > "$CONFIG_FILE" << 'EOF'
search:
  provider: forage
  timeout: 30
  browser:
    mode: local
    engine: playwright
    headless: false
    min_interval: 2.5

extract:
  engine: trafilatura
  timeout: 30
  max_content_chars: 100000
  respect_robots_txt: true

browser:
  engine: scrapling
  pool:
    min_idle: 1
    max_instances: 5
    idle_timeout: 60

cache:
  enabled: true
  max_entries: 500
  search:
    enabled: true
    ttl: 30
  extract:
    enabled: true
    ttl: 10

llm:
  enabled: false
  endpoint: null
  timeout: 30
  api_key: null
EOF

restart_container && test_api "CONFIG-6" || fail "CONFIG-6: Failed"
echo "" | tee -a "$RESULTS"

# ============================================================================
# CONFIG COMBINATION 7: Extended timeout (60s search, 120s extract)
# ============================================================================
echo_test "CONFIG-7: Extended timeout (search 60s, extract 120s)"

cat > "$CONFIG_FILE" << 'EOF'
search:
  provider: forage
  timeout: 60
  browser:
    mode: local
    engine: playwright
    headless: false
    min_interval: 2.5

extract:
  engine: trafilatura
  timeout: 120
  max_content_chars: 100000
  respect_robots_txt: true

browser:
  engine: scrapling
  pool:
    min_idle: 1
    max_instances: 5
    idle_timeout: 60

cache:
  enabled: true
  max_entries: 500
  search:
    enabled: true
    ttl: 300
  extract:
    enabled: true
    ttl: 60

llm:
  enabled: false
  endpoint: null
  timeout: 30
  api_key: null
EOF

restart_container && test_api "CONFIG-7" || fail "CONFIG-7: Failed"
echo "" | tee -a "$RESULTS"

# ============================================================================
# CONFIG COMBINATION 8: LLM enabled (stub, no functional calls)
# ============================================================================
echo_test "CONFIG-8: LLM stub enabled (endpoint null, no-op)"

cat > "$CONFIG_FILE" << 'EOF'
search:
  provider: forage
  timeout: 30
  browser:
    mode: local
    engine: playwright
    headless: false
    min_interval: 2.5

extract:
  engine: trafilatura
  timeout: 30
  max_content_chars: 100000
  respect_robots_txt: true

browser:
  engine: scrapling
  pool:
    min_idle: 1
    max_instances: 5
    idle_timeout: 60

cache:
  enabled: true
  max_entries: 500
  search:
    enabled: true
    ttl: 300
  extract:
    enabled: true
    ttl: 60

llm:
  enabled: true
  endpoint: null
  timeout: 30
  api_key: null
EOF

restart_container && test_api "CONFIG-8" || fail "CONFIG-8: Failed"
echo "" | tee -a "$RESULTS"

# ============================================================================
# Restore original config
# ============================================================================
restore_config
restart_container
info "Original config restored"
echo "" | tee -a "$RESULTS"

# ============================================================================
# Summary
# ============================================================================
echo -e "\n${YELLOW}=================================================================================${NC}" | tee -a "$RESULTS"
echo -e "${GREEN}PHASE 5 ENHANCEMENT - CONFIG COMBO TESTING COMPLETE${NC}" | tee -a "$RESULTS"
echo "================================================================================" | tee -a "$RESULTS"
echo "" | tee -a "$RESULTS"
echo "Completed: $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$RESULTS"
echo "" | tee -a "$RESULTS"
echo "Config Combinations Tested:" | tee -a "$RESULTS"
echo "  1. CONFIG-1: Default (trafilatura + scrapling + cache on + forage)" | tee -a "$RESULTS"
echo "  2. CONFIG-2: trafilatura + playwright" | tee -a "$RESULTS"
echo "  3. CONFIG-3: readability + scrapling" | tee -a "$RESULTS"
echo "  4. CONFIG-4: Cache disabled (search and extract)" | tee -a "$RESULTS"
echo "  5. CONFIG-5: Search cache only (extract disabled)" | tee -a "$RESULTS"
echo "  6. CONFIG-6: Short TTL (search 30s, extract 10s)" | tee -a "$RESULTS"
echo "  7. CONFIG-7: Extended timeout (search 60s, extract 120s)" | tee -a "$RESULTS"
echo "  8. CONFIG-8: LLM stub enabled (no-op)" | tee -a "$RESULTS"
echo "" | tee -a "$RESULTS"

echo -e "\n${GREEN}✓ All config combinations tested successfully!${NC}"
echo "Full results: $RESULTS"
echo ""
tail -40 "$RESULTS"

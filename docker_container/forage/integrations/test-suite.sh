#!/bin/bash

# Comprehensive Test Suite for Hermes Integration

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Hermes Integration Comprehensive Test Suite   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

TEST_COUNT=0
PASS_COUNT=0
FAIL_COUNT=0

run_test() {
    local TEST_NAME="$1"
    local TEST_CMD="$2"
    
    TEST_COUNT=$((TEST_COUNT + 1))
    echo -n "Test $TEST_COUNT: $TEST_NAME... "
    
    if eval "$TEST_CMD" > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}FAIL${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

# Test 1: Health Check
run_test "Health check" "~/.hermes/integrations/health-check.sh"

# Test 2: SearXNG Search
run_test "SearXNG search" "curl -s 'http://localhost:8080/search?q=test&format=json' | jq -e '.results' > /dev/null"

# Test 3: Forage health
run_test "Forage health endpoint" "curl -s 'http://localhost:3673/health' | jq -e '.status' > /dev/null"

# Test 4: LM Studio models
run_test "LM Studio models" "curl -s 'http://127.0.0.1:1234/v1/models' | jq -e '.data' > /dev/null"

# Test 5: Hermes binary
run_test "Hermes binary" "hermes --version > /dev/null"

# Test 6: Integration script
run_test "Integration script exists" "test -x ~/.hermes/integrations/hermes-searxng-forage.sh"

# Test 7: Tools config
run_test "Tools configuration" "test -f ~/.hermes/tools/searxng.json && test -f ~/.hermes/tools/forage.json && test -f ~/.hermes/tools/llm_synthesis.json"

echo ""
echo "Test Results:"
echo "  Total: $TEST_COUNT"
echo -e "  ${GREEN}Passed: $PASS_COUNT${NC}"
echo -e "  ${RED}Failed: $FAIL_COUNT${NC}"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    exit 1
fi


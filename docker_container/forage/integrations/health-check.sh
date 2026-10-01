#!/bin/bash

# Health Check Script for Hermes Integration
# Run regularly to monitor system status

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SEARXNG_URL="${SEARXNG_URL:-http://localhost:8080}"
FORAGE_URL="${FORAGE_URL:-http://localhost:3673}"
LLM_URL="${LLM_URL:-http://127.0.0.1:1234}"

echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   Hermes Integration Health Check      ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
echo ""
echo "Timestamp: $(date)"
echo ""

# Check SearXNG
SEARXNG_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$SEARXNG_URL/" 2>/dev/null || echo "000")
if [ "$SEARXNG_CODE" = "200" ]; then
    echo -e "${GREEN}✅ SearXNG${NC}: OK (HTTP $SEARXNG_CODE)"
else
    echo -e "${RED}❌ SearXNG${NC}: FAILED (HTTP $SEARXNG_CODE)"
fi

# Check Forage
FORAGE_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$FORAGE_URL/health" 2>/dev/null || echo "000")
if [ "$FORAGE_CODE" = "200" ]; then
    echo -e "${GREEN}✅ Forage${NC}: OK (HTTP $FORAGE_CODE)"
else
    echo -e "${RED}❌ Forage${NC}: FAILED (HTTP $FORAGE_CODE)"
fi

# Check LM Studio
LLM_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$LLM_URL/v1/models" 2>/dev/null || echo "000")
if [ "$LLM_CODE" = "200" ]; then
    echo -e "${GREEN}✅ LM Studio${NC}: OK (HTTP $LLM_CODE)"
else
    echo -e "${RED}❌ LM Studio${NC}: FAILED (HTTP $LLM_CODE)"
fi

# Check Hermes
if command -v hermes &> /dev/null; then
    echo -e "${GREEN}✅ Hermes${NC}: Installed"
else
    echo -e "${YELLOW}⚠️  Hermes${NC}: Not in PATH"
fi

echo ""

# Overall status
if [ "$SEARXNG_CODE" = "200" ] && [ "$FORAGE_CODE" = "200" ] && [ "$LLM_CODE" = "200" ]; then
    echo -e "${GREEN}✅ All systems operational${NC}"
    exit 0
else
    echo -e "${RED}❌ Some systems not responding${NC}"
    exit 1
fi


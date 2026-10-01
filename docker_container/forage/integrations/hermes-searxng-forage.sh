#!/bin/bash

################################################################################
# Hermes + SearXNG + Forage + LLM Integration Script
# 
# Orchestrates web search, content extraction, and AI synthesis
# Usage: hermes-searxng-forage.sh "your search query"
################################################################################

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
QUERY="${1:- }"
SEARXNG_URL="${SEARXNG_URL:-http://localhost:8080}"
FORAGE_URL="${FORAGE_URL:-http://localhost:3673}"
LLM_URL="${LLM_URL:-http://127.0.0.1:1234}"
LLM_MODEL="${LLM_MODEL:-qwen/qwen2.5-3b-instruct}"
MAX_URLS="${2:-3}"
TIMEOUT=30

# Logging functions
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }
log_section() { echo ""; echo "════════════════════════════════════════════════════"; echo "  $1"; echo "════════════════════════════════════════════════════"; echo ""; }

# Validation
if [ -z "$QUERY" ] || [ "$QUERY" = " " ]; then
    echo "Usage: hermes-searxng-forage.sh '<search query>' [max_urls]"
    echo ""
    echo "Examples:"
    echo "  hermes-searxng-forage.sh 'Kubernetes container orchestration'"
    echo "  hermes-searxng-forage.sh 'Docker best practices' 5"
    echo ""
    exit 1
fi

# Health check
health_check() {
    log_section "Pre-flight Health Check"
    
    if ! curl -s -m 5 "$SEARXNG_URL/" > /dev/null 2>&1; then
        log_error "SearXNG not responding at $SEARXNG_URL"
        exit 1
    fi
    log_success "SearXNG: Available"
    
    if ! curl -s -m 5 "$FORAGE_URL/health" > /dev/null 2>&1; then
        log_error "Forage not responding at $FORAGE_URL"
        exit 1
    fi
    log_success "Forage: Available"
    
    if ! curl -s -m 5 "$LLM_URL/v1/models" > /dev/null 2>&1; then
        log_error "LM Studio not responding at $LLM_URL"
        exit 1
    fi
    log_success "LM Studio: Available"
}

# Step 1: Search
search_phase() {
    log_section "Phase 1: Web Search"
    log_info "Query: $QUERY"
    log_info "Searching with SearXNG..."
    
    SEARCH_RESULTS=$(curl -s -m $TIMEOUT "$SEARXNG_URL/search?q=$QUERY&format=json" 2>/dev/null)
    
    if [ -z "$SEARCH_RESULTS" ]; then
        log_error "Search failed or returned empty results"
        exit 1
    fi
    
    RESULT_COUNT=$(echo "$SEARCH_RESULTS" | jq '.results | length' 2>/dev/null || echo 0)
    
    if [ "$RESULT_COUNT" -eq 0 ]; then
        log_error "No search results found"
        exit 1
    fi
    
    log_success "Found $RESULT_COUNT results"
    
    # Extract URLs
    URLS=$(echo "$SEARCH_RESULTS" | jq -r ".results[0:$MAX_URLS] | map(.url) | .[]" 2>/dev/null)
    URL_COUNT=$(echo "$URLS" | wc -l)
    
    log_info "Extracting top $URL_COUNT URLs..."
    echo "$URLS" | nl
}

# Step 2: Extract
extract_phase() {
    log_section "Phase 2: Content Extraction"
    
    # Convert URLs to JSON array
    URL_ARRAY=$(echo "$URLS" | jq -R -s -c 'split("\n")[:-1] | map(select(length > 0))')
    
    log_info "Extracting content from $URL_COUNT URLs..."
    
    EXTRACT_RESULTS=$(curl -s -m $TIMEOUT -X POST "$FORAGE_URL/extract" \
        -H 'Content-Type: application/json' \
        -d "{\"urls\":$URL_ARRAY,\"formats\":[\"text\",\"markdown\"]}" 2>/dev/null)
    
    if [ -z "$EXTRACT_RESULTS" ]; then
        log_error "Extraction failed"
        exit 1
    fi
    
    # Combine extracted content
    COMBINED_CONTENT=$(echo "$EXTRACT_RESULTS" | jq -r '.results[] | select(.text != null) | .text' 2>/dev/null | head -c 2000)
    
    if [ -z "$COMBINED_CONTENT" ]; then
        log_error "No content extracted"
        exit 1
    fi
    
    log_success "Extracted content from URLs"
    log_info "Content length: $(echo -n "$COMBINED_CONTENT" | wc -c) characters"
}

# Step 3: Synthesize
synthesis_phase() {
    log_section "Phase 3: AI Synthesis & Summarization"
    
    log_info "Model: $LLM_MODEL"
    log_info "Sending to LLM for synthesis..."
    
    # Prepare synthesis prompt
    SYNTHESIS_PROMPT="Based on the following search results about '$QUERY', provide a comprehensive and insightful 3-4 sentence summary that captures the key information:

Search Results Summary:
$COMBINED_CONTENT

Summary:"
    
    # Send to LLM
    LLM_RESPONSE=$(curl -s -m $TIMEOUT -X POST "$LLM_URL/v1/chat/completions" \
        -H 'Content-Type: application/json' \
        -d "{
            \"model\": \"$LLM_MODEL\",
            \"messages\": [{
                \"role\": \"user\",
                \"content\": \"$SYNTHESIS_PROMPT\"
            }],
            \"max_tokens\": 300,
            \"temperature\": 0.7
        }" 2>/dev/null)
    
    if [ -z "$LLM_RESPONSE" ]; then
        log_error "LLM synthesis failed"
        exit 1
    fi
    
    SYNTHESIS=$(echo "$LLM_RESPONSE" | jq -r '.choices[0].message.content' 2>/dev/null)
    
    if [ -z "$SYNTHESIS" ] || [ "$SYNTHESIS" = "null" ]; then
        log_error "Failed to extract synthesis from LLM response"
        exit 1
    fi
    
    log_success "Synthesis complete"
}

# Output results
output_results() {
    log_section "📋 FINAL RESULTS"
    
    echo "Query:  $QUERY"
    echo ""
    echo "Sources: $URL_COUNT URLs"
    echo ""
    echo "Summary:"
    echo "────────────────────────────────────────────────"
    echo ""
    echo "$SYNTHESIS"
    echo ""
    echo "────────────────────────────────────────────────"
    echo ""
    
    log_success "Integration workflow completed successfully"
}

# Error handler
trap 'log_error "Workflow interrupted"; exit 1' INT TERM

# Main execution
health_check
search_phase
extract_phase
synthesis_phase
output_results


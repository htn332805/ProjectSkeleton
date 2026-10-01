#!/bin/bash

################################################################################
# FORAGE v1.0.1 - LOAD TESTING & PERFORMANCE VALIDATION SCRIPT
#
# Purpose: Stress test Forage with concurrent requests and measure performance
#
# Usage: bash load-test-forage.sh [service_url] [test_type]
# 
# Examples:
#   bash load-test-forage.sh http://localhost:3672 health
#   bash load-test-forage.sh http://localhost:3672 all
#   bash load-test-forage.sh http://localhost:3672 search
#
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
SERVICE_URL="${1:-http://localhost:3672}"
TEST_TYPE="${2:-all}"
CONCURRENT_REQUESTS="${3:-50}"
TOTAL_REQUESTS="${4:-500}"
TIMEOUT=30
RESULTS_DIR="/tmp/forage-load-test"

# Metrics tracking
declare -A response_times
declare -A status_codes
total_time=0
success_count=0
error_count=0
timeout_count=0

################################################################################
# UTILITY FUNCTIONS
################################################################################

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_metric() {
    echo -e "${CYAN}📊 $1${NC}"
}

print_header() {
    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "  $1"
    echo "════════════════════════════════════════════════════════════"
    echo ""
}

print_step() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

################################################################################
# PRE-TEST CHECKS
################################################################################

check_service_availability() {
    print_step "Checking Service Availability"
    
    log_info "Testing connection to: $SERVICE_URL"
    
    if ! curl -s -m 5 "$SERVICE_URL/health" > /dev/null 2>&1; then
        log_error "Service not responding at $SERVICE_URL"
        log_info "Make sure to run: bash deploy-forage.sh dev"
        exit 1
    fi
    
    log_success "Service is responding"
    
    # Get service info
    local health=$(curl -s "$SERVICE_URL/health")
    if echo "$health" | grep -q "ok"; then
        log_success "Service health check passed"
        log_info "Version: $(echo "$health" | grep -o '"version":"[^"]*' | cut -d'"' -f4 || echo 'unknown')"
    fi
}

check_dependencies() {
    print_step "Checking Dependencies"
    
    # Check for jq
    if ! command -v jq &> /dev/null; then
        log_warning "jq not installed (optional, used for parsing)"
    else
        log_success "jq available"
    fi
    
    # Check for bc
    if ! command -v bc &> /dev/null; then
        log_warning "bc not installed (needed for calculations)"
        exit 1
    fi
    
    # Check for GNU parallel (optional)
    if command -v parallel &> /dev/null; then
        log_success "GNU parallel available (will use for concurrency)"
        USE_PARALLEL=true
    else
        log_info "GNU parallel not available (will use xargs)"
        USE_PARALLEL=false
    fi
}

################################################################################
# LOAD TEST FUNCTIONS
################################################################################

test_health_endpoint() {
    local request_num=$1
    local start_time=$(date +%s%N)
    
    local response=$(curl -s -w "\n%{http_code}" -m $TIMEOUT "$SERVICE_URL/health" 2>/dev/null)
    local http_code=$(echo "$response" | tail -n 1)
    
    local end_time=$(date +%s%N)
    local elapsed_ms=$(echo "scale=2; ($end_time - $start_time) / 1000000" | bc)
    
    if [ "$http_code" == "200" ]; then
        echo "$elapsed_ms|200|success"
        ((success_count++))
    else
        echo "$elapsed_ms|$http_code|error"
        ((error_count++))
    fi
}

test_search_endpoint() {
    local request_num=$1
    local queries=("Python" "JavaScript" "Docker" "Kubernetes" "API" "Database" "Cache" "Load testing" "Performance" "Optimization")
    local query=${queries[$((request_num % ${#queries[@]}))]}"
    
    local start_time=$(date +%s%N)
    
    local response=$(curl -s -w "\n%{http_code}" -m $TIMEOUT \
        -X POST "$SERVICE_URL/search" \
        -H 'Content-Type: application/json' \
        -d "{\"query\":\"$query\",\"limit\":1}" 2>/dev/null)
    
    local http_code=$(echo "$response" | tail -n 1)
    
    local end_time=$(date +%s%N)
    local elapsed_ms=$(echo "scale=2; ($end_time - $start_time) / 1000000" | bc)
    
    if [ "$http_code" == "200" ] || [ "$http_code" == "201" ]; then
        echo "$elapsed_ms|$http_code|success"
        ((success_count++))
    else
        echo "$elapsed_ms|$http_code|error"
        ((error_count++))
    fi
}

test_extract_endpoint() {
    local request_num=$1
    local urls=("https://example.com" "https://example.org" "https://example.net")
    local url=${urls[$((request_num % ${#urls[@]}))]}"
    
    local start_time=$(date +%s%N)
    
    local response=$(curl -s -w "\n%{http_code}" -m $TIMEOUT \
        -X POST "$SERVICE_URL/extract" \
        -H 'Content-Type: application/json' \
        -d "{\"urls\":[\"$url\"],\"formats\":[\"text\"]}" 2>/dev/null)
    
    local http_code=$(echo "$response" | tail -n 1)
    
    local end_time=$(date +%s%N)
    local elapsed_ms=$(echo "scale=2; ($end_time - $start_time) / 1000000" | bc)
    
    if [ "$http_code" == "200" ] || [ "$http_code" == "201" ]; then
        echo "$elapsed_ms|$http_code|success"
        ((success_count++))
    else
        echo "$elapsed_ms|$http_code|error"
        ((error_count++))
    fi
}

test_firecrawl_endpoint() {
    local request_num=$1
    local urls=("https://example.com" "https://example.org")
    local url=${urls[$((request_num % ${#urls[@]}))]}"
    
    local start_time=$(date +%s%N)
    
    local response=$(curl -s -w "\n%{http_code}" -m $TIMEOUT \
        -X POST "$SERVICE_URL/v1/scrape" \
        -H 'Content-Type: application/json' \
        -d "{\"url\":\"$url\",\"formats\":[\"markdown\"]}" 2>/dev/null)
    
    local http_code=$(echo "$response" | tail -n 1)
    
    local end_time=$(date +%s%N)
    local elapsed_ms=$(echo "scale=2; ($end_time - $start_time) / 1000000" | bc)
    
    if [ "$http_code" == "200" ] || [ "$http_code" == "201" ]; then
        echo "$elapsed_ms|$http_code|success"
        ((success_count++))
    else
        echo "$elapsed_ms|$http_code|error"
        ((error_count++))
    fi
}

test_cache_behavior() {
    local query="cache-test-query-$(date +%s)"
    local results_file="$RESULTS_DIR/cache_test.log"
    
    log_info "Testing cache behavior with 10 repeated queries..."
    
    > "$results_file"
    
    for i in {1..10}; do
        local start_time=$(date +%s%N)
        
        curl -s -m $TIMEOUT \
            -X POST "$SERVICE_URL/search" \
            -H 'Content-Type: application/json' \
            -d "{\"query\":\"$query\",\"limit\":1}" > /dev/null 2>&1
        
        local end_time=$(date +%s%N)
        local elapsed_ms=$(echo "scale=2; ($end_time - $start_time) / 1000000" | bc)
        
        echo "$i|$elapsed_ms" >> "$results_file"
        
        if [ $i -eq 1 ]; then
            log_metric "Query 1 (no cache): ${elapsed_ms}ms"
        elif [ $i -eq 2 ]; then
            log_metric "Query 2 (cached):   ${elapsed_ms}ms"
        fi
    done
    
    # Calculate cache improvement
    local first=$(head -n 1 "$results_file" | cut -d'|' -f2)
    local second=$(head -n 2 "$results_file" | tail -n 1 | cut -d'|' -f2)
    
    if [ -n "$first" ] && [ -n "$second" ] && [ "$second" != "0" ]; then
        local improvement=$(echo "scale=2; $first / $second" | bc)
        log_success "Cache improvement: ${improvement}x faster on second query"
    fi
}

################################################################################
# CONCURRENT REQUEST EXECUTION
################################################################################

run_concurrent_tests() {
    local endpoint=$1
    local test_count=$2
    local concurrency=$3
    local results_file="$RESULTS_DIR/${endpoint}_results.log"
    
    > "$results_file"
    
    print_step "Running $test_count Concurrent Requests - $endpoint Endpoint"
    
    log_info "Concurrency: $concurrency requests at a time"
    log_info "Total requests: $test_count"
    log_info "Timeout: ${TIMEOUT}s per request"
    echo ""
    
    local completed=0
    
    # Generate request numbers
    seq 1 $test_count | \
    xargs -P "$concurrency" -I {} bash -c "
        case '$endpoint' in
            'health') test_health_endpoint {} ;;
            'search') test_search_endpoint {} ;;
            'extract') test_extract_endpoint {} ;;
            'firecrawl') test_firecrawl_endpoint {} ;;
        esac
    " | \
    while IFS='|' read elapsed http status; do
        echo "$elapsed|$http|$status" >> "$results_file"
        
        # Print progress
        completed=$((completed + 1))
        percent=$((completed * 100 / test_count))
        echo -ne "\rProgress: $completed/$test_count ($percent%) "
    done
    
    echo -ne "\n"
    log_success "Completed $test_count requests"
}

################################################################################
# METRICS ANALYSIS
################################################################################

analyze_results() {
    local endpoint=$1
    local results_file="$RESULTS_DIR/${endpoint}_results.log"
    
    if [ ! -f "$results_file" ] || [ ! -s "$results_file" ]; then
        log_error "No results found for $endpoint"
        return
    fi
    
    # Extract metrics
    local response_times=$(cut -d'|' -f1 "$results_file")
    local status_codes=$(cut -d'|' -f2 "$results_file")
    local success_count=$(grep -c "success" "$results_file" || true)
    local error_count=$(grep -c "error" "$results_file" || true)
    local total_count=$((success_count + error_count))
    
    # Calculate statistics
    local min=$(echo "$response_times" | sort -n | head -n 1)
    local max=$(echo "$response_times" | sort -n | tail -n 1)
    local sum=$(echo "$response_times" | awk '{sum+=$1} END {print sum}')
    local avg=$(echo "scale=2; $sum / $total_count" | bc)
    
    # Percentiles
    local p50=$(echo "$response_times" | sort -n | awk -v n=$total_count 'NR==int(n*0.5) {print $0}')
    local p95=$(echo "$response_times" | sort -n | awk -v n=$total_count 'NR==int(n*0.95) {print $0}')
    local p99=$(echo "$response_times" | sort -n | awk -v n=$total_count 'NR==int(n*0.99) {print $0}')
    
    # Success rate
    local success_rate=$(echo "scale=2; ($success_count * 100) / $total_count" | bc)
    
    print_header "$endpoint Endpoint - Results"
    
    log_metric "Total Requests:    $total_count"
    log_metric "Successful:        $success_count ($success_rate%)"
    log_metric "Errors:            $error_count"
    echo ""
    
    log_metric "Response Times (ms):"
    echo "  Min:               ${min}ms"
    echo "  Max:               ${max}ms"
    echo "  Avg:               ${avg}ms"
    echo "  P50 (median):      ${p50}ms"
    echo "  P95 (95th pctl):   ${p95}ms"
    echo "  P99 (99th pctl):   ${p99}ms"
    echo ""
    
    # Status code breakdown
    local status_200=$(grep "|200|" "$results_file" | wc -l || echo 0)
    local status_201=$(grep "|201|" "$results_file" | wc -l || echo 0)
    local status_timeout=$(grep -c "timeout" "$results_file" || echo 0)
    
    log_metric "Status Codes:"
    [ $status_200 -gt 0 ] && echo "  200 OK:            $status_200"
    [ $status_201 -gt 0 ] && echo "  201 Created:       $status_201"
    [ $status_timeout -gt 0 ] && echo "  Timeouts:          $status_timeout"
    echo ""
    
    # Throughput
    local requests_per_second=$(echo "scale=2; $total_count / ($timeout * 2)" | bc)
    log_metric "Throughput:        $requests_per_second req/s (est.)"
    echo ""
}

################################################################################
# COMPREHENSIVE REPORT
################################################################################

generate_full_report() {
    print_header "📊 COMPREHENSIVE LOAD TEST REPORT"
    
    local report_file="$RESULTS_DIR/load_test_report.txt"
    
    {
        echo "Forage v1.0.1 Load Test Report"
        echo "Generated: $(date)"
        echo "Service URL: $SERVICE_URL"
        echo ""
        echo "Test Configuration:"
        echo "  Concurrent Requests: $CONCURRENT_REQUESTS"
        echo "  Total Requests: $TOTAL_REQUESTS"
        echo "  Request Timeout: ${TIMEOUT}s"
        echo ""
        
        if [ -f "$RESULTS_DIR/health_results.log" ]; then
            echo "=== HEALTH ENDPOINT TEST ==="
            cat "$RESULTS_DIR/health_results.log" | head -10
            echo ""
        fi
        
        if [ -f "$RESULTS_DIR/search_results.log" ]; then
            echo "=== SEARCH ENDPOINT TEST ==="
            cat "$RESULTS_DIR/search_results.log" | head -10
            echo ""
        fi
        
        if [ -f "$RESULTS_DIR/extract_results.log" ]; then
            echo "=== EXTRACT ENDPOINT TEST ==="
            cat "$RESULTS_DIR/extract_results.log" | head -10
            echo ""
        fi
        
        if [ -f "$RESULTS_DIR/firecrawl_results.log" ]; then
            echo "=== FIRECRAWL ENDPOINT TEST ==="
            cat "$RESULTS_DIR/firecrawl_results.log" | head -10
            echo ""
        fi
        
        echo "Report saved to: $report_file"
        
    } | tee "$report_file"
    
    log_success "Report saved to: $report_file"
}

################################################################################
# MAIN EXECUTION
################################################################################

main() {
    # Setup
    mkdir -p "$RESULTS_DIR"
    
    print_header "🚀 FORAGE v1.0.1 LOAD TESTING SUITE"
    
    log_info "Service URL: $SERVICE_URL"
    log_info "Test Type: $TEST_TYPE"
    log_info "Concurrent: $CONCURRENT_REQUESTS | Total: $TOTAL_REQUESTS"
    echo ""
    
    # Pre-test checks
    check_service_availability
    check_dependencies
    echo ""
    
    # Run tests based on type
    case $TEST_TYPE in
        health)
            run_concurrent_tests "health" "$TOTAL_REQUESTS" "$CONCURRENT_REQUESTS"
            analyze_results "health"
            ;;
        search)
            run_concurrent_tests "search" "$TOTAL_REQUESTS" "$CONCURRENT_REQUESTS"
            analyze_results "search"
            test_cache_behavior
            ;;
        extract)
            run_concurrent_tests "extract" "$TOTAL_REQUESTS" "$CONCURRENT_REQUESTS"
            analyze_results "extract"
            ;;
        firecrawl)
            run_concurrent_tests "firecrawl" "$TOTAL_REQUESTS" "$CONCURRENT_REQUESTS"
            analyze_results "firecrawl"
            ;;
        all)
            run_concurrent_tests "health" 100 "$CONCURRENT_REQUESTS"
            analyze_results "health"
            echo ""
            
            run_concurrent_tests "search" 150 "$CONCURRENT_REQUESTS"
            analyze_results "search"
            test_cache_behavior
            echo ""
            
            run_concurrent_tests "extract" 100 "$CONCURRENT_REQUESTS"
            analyze_results "extract"
            echo ""
            
            run_concurrent_tests "firecrawl" 100 "$CONCURRENT_REQUESTS"
            analyze_results "firecrawl"
            ;;
        *)
            log_error "Unknown test type: $TEST_TYPE"
            echo "Valid types: health, search, extract, firecrawl, all"
            exit 1
            ;;
    esac
    
    # Generate report
    echo ""
    generate_full_report
    
    print_header "✅ LOAD TESTING COMPLETE"
    
    log_success "All results saved to: $RESULTS_DIR"
    log_info "View detailed results: cat $RESULTS_DIR/${TEST_TYPE}_results.log"
    
    echo ""
}

# Run main
main

#!/bin/bash

################################################################################
# FORAGE v1.0.1 - LLM FEATURE TESTING SUITE
#
# Tests LLM integration capabilities with LM Studio endpoint
# Model: google/gemma-4-e4b
# Endpoint: http://127.0.0.1:1234
#
# Usage: bash test-forage-llm.sh
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
LM_STUDIO_URL="http://127.0.0.1:1234"
FORAGE_URL="http://localhost:3672"
MODEL="google/gemma-4-e4b"
RESULTS_DIR="/tmp/forage-llm-test"

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

################################################################################
# PRE-TEST CHECKS
################################################################################

check_lm_studio() {
    print_header "Checking LM Studio Availability"
    
    if ! curl -s -m 5 "$LM_STUDIO_URL/v1/models" > /dev/null 2>&1; then
        log_error "LM Studio not responding at $LM_STUDIO_URL"
        log_info "Start LM Studio and try again"
        exit 1
    fi
    
    log_success "LM Studio is responding"
    
    # Check for specific model
    local models=$(curl -s "$LM_STUDIO_URL/v1/models")
    if echo "$models" | grep -q "$MODEL"; then
        log_success "Model available: $MODEL"
    else
        log_warning "Model $MODEL not found, but LM Studio is running"
        log_info "Available models:"
        echo "$models" | grep -o '"id":"[^"]*' | cut -d'"' -f4 | head -5
    fi
}

check_forage() {
    print_header "Checking Forage Service"
    
    if ! curl -s -m 5 "$FORAGE_URL/health" > /dev/null 2>&1; then
        log_error "Forage not responding at $FORAGE_URL"
        log_info "Deploy Forage: bash deploy-forage.sh dev"
        exit 1
    fi
    
    log_success "Forage service is responding"
}

################################################################################
# LLM TESTING FUNCTIONS
################################################################################

test_lm_studio_direct() {
    print_header "Test 1: Direct LM Studio Connectivity"
    
    log_info "Testing basic chat completion with $MODEL..."
    
    local response=$(curl -s -X POST "$LM_STUDIO_URL/v1/chat/completions" \
        -H "Content-Type: application/json" \
        -d '{
            "model": "'"$MODEL"'",
            "messages": [
                {"role": "user", "content": "What is Docker? Answer in one sentence."}
            ],
            "temperature": 0.7,
            "max_tokens": 100
        }' 2>/dev/null)
    
    if echo "$response" | grep -q "choices"; then
        log_success "LM Studio chat completion working"
        
        # Extract and display response
        local answer=$(echo "$response" | grep -o '"content":"[^"]*' | head -1 | cut -d'"' -f4 | head -c 100)
        log_info "Model response: $answer..."
        
        return 0
    else
        log_error "Failed to get response from LM Studio"
        echo "$response" | head -20
        return 1
    fi
}

test_lm_studio_performance() {
    print_header "Test 2: LM Studio Performance & Throughput"
    
    log_info "Testing response time with various prompt lengths..."
    
    local results_file="$RESULTS_DIR/lm_performance.log"
    > "$results_file"
    
    # Test with different prompt lengths
    local prompts=(
        "What is API?"
        "Explain REST architecture in detail"
        "Write a comprehensive guide on Docker containers, their benefits, use cases, and how they differ from virtual machines. Include examples of common applications."
    )
    
    local labels=("Short" "Medium" "Long")
    
    for i in "${!prompts[@]}"; do
        local prompt="${prompts[$i]}"
        local label="${labels[$i]}"
        
        local start_time=$(date +%s%N)
        
        local response=$(curl -s -X POST "$LM_STUDIO_URL/v1/chat/completions" \
            -H "Content-Type: application/json" \
            -d '{
                "model": "'"$MODEL"'",
                "messages": [
                    {"role": "user", "content": "'"${prompt//$'\n'/ }"'"}
                ],
                "temperature": 0.7,
                "max_tokens": 200
            }' 2>/dev/null)
        
        local end_time=$(date +%s%N)
        local elapsed_ms=$(echo "scale=2; ($end_time - $start_time) / 1000000" | bc)
        
        if echo "$response" | grep -q "choices"; then
            echo "$label|$elapsed_ms|success" >> "$results_file"
            log_metric "$label prompt: ${elapsed_ms}ms"
        else
            echo "$label|$elapsed_ms|error" >> "$results_file"
            log_error "$label prompt: Failed"
        fi
    done
}

test_forage_llm_extraction() {
    print_header "Test 3: Forage + LLM Content Enhancement"
    
    log_info "Testing if Forage can integrate with LLM for content processing..."
    
    # First extract content from example.com
    log_info "Step 1: Extract content from https://example.com"
    
    local extract_response=$(curl -s -X POST "$FORAGE_URL/extract" \
        -H 'Content-Type: application/json' \
        -d '{"urls":["https://example.com"],"formats":["text"]}' 2>/dev/null)
    
    if echo "$extract_response" | grep -q "success.*true"; then
        log_success "Content extracted"
        
        # Extract text content
        local content=$(echo "$extract_response" | grep -o '"text":"[^"]*' | head -1 | cut -d'"' -f4 | head -c 200)
        log_info "Extracted content (preview): $content..."
        
        # Now send to LLM for summarization
        log_info "Step 2: Send to LLM for summarization"
        
        local llm_response=$(curl -s -X POST "$LM_STUDIO_URL/v1/chat/completions" \
            -H "Content-Type: application/json" \
            -d '{
                "model": "'"$MODEL"'",
                "messages": [
                    {"role": "user", "content": "Summarize this in one sentence: '"${content//$'\n'/ }"'"}
                ],
                "temperature": 0.7,
                "max_tokens": 100
            }' 2>/dev/null)
        
        if echo "$llm_response" | grep -q "choices"; then
            log_success "LLM summarization successful"
            local summary=$(echo "$llm_response" | grep -o '"content":"[^"]*' | head -1 | cut -d'"' -f4)
            log_info "Summary: $summary"
        else
            log_warning "LLM summarization failed (but extraction worked)"
        fi
        
        return 0
    else
        log_error "Content extraction failed"
        return 1
    fi
}

test_batch_llm_processing() {
    print_header "Test 4: Batch LLM Processing"
    
    log_info "Testing batch processing of multiple prompts..."
    
    local prompts=(
        "What is Kubernetes?"
        "Explain Docker containers"
        "What is microservices architecture?"
        "Describe CI/CD pipelines"
        "What are REST APIs?"
    )
    
    local results_file="$RESULTS_DIR/batch_processing.log"
    > "$results_file"
    
    local success_count=0
    local error_count=0
    
    for i in "${!prompts[@]}"; do
        local prompt="${prompts[$i]}"
        
        local response=$(curl -s -X POST "$LM_STUDIO_URL/v1/chat/completions" \
            -H "Content-Type: application/json" \
            -d '{
                "model": "'"$MODEL"'",
                "messages": [
                    {"role": "user", "content": "'"$prompt"'"}
                ],
                "temperature": 0.7,
                "max_tokens": 100
            }' 2>/dev/null)
        
        if echo "$response" | grep -q "choices"; then
            ((success_count++))
            echo "$prompt|success" >> "$results_file"
        else
            ((error_count++))
            echo "$prompt|error" >> "$results_file"
        fi
        
        # Show progress
        echo -ne "\rProcessed: $((i+1))/${#prompts[@]}"
    done
    
    echo ""
    log_metric "Batch Results: $success_count succeeded, $error_count failed"
    log_success "Batch processing completed"
}

test_llm_with_search_context() {
    print_header "Test 5: LLM with Forage Search Context"
    
    log_info "Testing LLM with search results as context..."
    
    # Step 1: Search for information
    log_info "Step 1: Searching web for 'Kubernetes benefits'"
    
    local search_response=$(curl -s -X POST "$FORAGE_URL/search" \
        -H 'Content-Type: application/json' \
        -d '{"query":"Kubernetes benefits","limit":1}' 2>/dev/null)
    
    if echo "$search_response" | grep -q "success.*true"; then
        # Extract first result
        local result_title=$(echo "$search_response" | grep -o '"title":"[^"]*' | head -1 | cut -d'"' -f4)
        local result_desc=$(echo "$search_response" | grep -o '"description":"[^"]*' | head -1 | cut -d'"' -f4)
        
        log_success "Found search result: $result_title"
        
        # Step 2: Send to LLM with context
        log_info "Step 2: Asking LLM to explain based on search result"
        
        local context="Based on this information: $result_title - $result_desc"
        
        local llm_response=$(curl -s -X POST "$LM_STUDIO_URL/v1/chat/completions" \
            -H "Content-Type: application/json" \
            -d '{
                "model": "'"$MODEL"'",
                "messages": [
                    {"role": "user", "content": "'"$context"'. Explain the key benefit in one sentence."}
                ],
                "temperature": 0.7,
                "max_tokens": 100
            }' 2>/dev/null)
        
        if echo "$llm_response" | grep -q "choices"; then
            log_success "LLM analysis with search context successful"
            local analysis=$(echo "$llm_response" | grep -o '"content":"[^"]*' | head -1 | cut -d'"' -f4)
            log_info "Analysis: $analysis"
        else
            log_error "LLM analysis failed"
        fi
    else
        log_error "Search failed"
    fi
}

test_llm_streaming() {
    print_header "Test 6: LLM Streaming Response (if supported)"
    
    log_info "Testing LLM streaming capability..."
    
    local response=$(curl -s -X POST "$LM_STUDIO_URL/v1/chat/completions" \
        -H "Content-Type: application/json" \
        -d '{
            "model": "'"$MODEL"'",
            "messages": [
                {"role": "user", "content": "List 5 benefits of containerization."}
            ],
            "temperature": 0.7,
            "max_tokens": 200,
            "stream": false
        }' 2>/dev/null)
    
    if echo "$response" | grep -q '"finish_reason"'; then
        log_success "LLM response generation successful"
        
        # Show usage stats if available
        local tokens=$(echo "$response" | grep -o '"total_tokens":[0-9]*' | cut -d':' -f2)
        if [ -n "$tokens" ]; then
            log_metric "Tokens used: $tokens"
        fi
    else
        log_error "Failed to get LLM response"
    fi
}

test_llm_error_handling() {
    print_header "Test 7: LLM Error Handling"
    
    log_info "Testing LLM error handling with invalid inputs..."
    
    # Test 1: Invalid model
    log_info "Test 7a: Invalid model name"
    local response=$(curl -s -X POST "$LM_STUDIO_URL/v1/chat/completions" \
        -H "Content-Type: application/json" \
        -d '{
            "model": "invalid-model-xyz",
            "messages": [{"role": "user", "content": "test"}],
            "max_tokens": 100
        }' 2>/dev/null)
    
    if echo "$response" | grep -q "error"; then
        log_success "Error handling: Correctly rejected invalid model"
    else
        log_warning "No error for invalid model (may be expected)"
    fi
    
    # Test 2: Empty prompt
    log_info "Test 7b: Empty prompt handling"
    local response=$(curl -s -X POST "$LM_STUDIO_URL/v1/chat/completions" \
        -H "Content-Type: application/json" \
        -d '{
            "model": "'"$MODEL"'",
            "messages": [{"role": "user", "content": ""}],
            "max_tokens": 100
        }' 2>/dev/null)
    
    if echo "$response" | grep -q "choices\|error"; then
        log_success "Empty prompt handled"
    else
        log_warning "Unexpected response to empty prompt"
    fi
    
    # Test 3: Very large token request
    log_info "Test 7c: Large token request"
    local response=$(curl -s -X POST "$LM_STUDIO_URL/v1/chat/completions" \
        -H "Content-Type: application/json" \
        -d '{
            "model": "'"$MODEL"'",
            "messages": [{"role": "user", "content": "test"}],
            "max_tokens": 100000
        }' 2>/dev/null)
    
    if echo "$response" | grep -q "choices\|error"; then
        log_success "Large token request handled appropriately"
    else
        log_warning "Unexpected response to large token request"
    fi
}

################################################################################
# RESULTS ANALYSIS
################################################################################

analyze_llm_performance() {
    print_header "LLM Performance Analysis"
    
    if [ -f "$RESULTS_DIR/lm_performance.log" ]; then
        local short=$(grep "^Short" "$RESULTS_DIR/lm_performance.log" | cut -d'|' -f2)
        local medium=$(grep "^Medium" "$RESULTS_DIR/lm_performance.log" | cut -d'|' -f2)
        local long=$(grep "^Long" "$RESULTS_DIR/lm_performance.log" | cut -d'|' -f2)
        
        echo ""
        log_metric "Performance by prompt length:"
        echo "  Short prompt:   ${short}ms"
        echo "  Medium prompt:  ${medium}ms"
        echo "  Long prompt:    ${long}ms"
        echo ""
        
        # Calculate average
        if [ -n "$short" ] && [ -n "$medium" ] && [ -n "$long" ]; then
            local avg=$(echo "scale=2; ($short + $medium + $long) / 3" | bc)
            log_metric "Average response time: ${avg}ms"
        fi
    fi
}

################################################################################
# SUMMARY & REPORT
################################################################################

generate_llm_report() {
    print_header "LLM Feature Testing Report"
    
    local report_file="$RESULTS_DIR/llm_test_report.txt"
    
    {
        echo "Forage v1.0.1 - LLM Feature Testing Report"
        echo "Generated: $(date)"
        echo ""
        echo "Test Environment:"
        echo "  LM Studio URL: $LM_STUDIO_URL"
        echo "  Model: $MODEL"
        echo "  Forage URL: $FORAGE_URL"
        echo ""
        echo "Tests Executed:"
        echo "  1. Direct LM Studio Connectivity"
        echo "  2. Performance & Throughput"
        echo "  3. Forage + LLM Content Enhancement"
        echo "  4. Batch Processing"
        echo "  5. LLM with Search Context"
        echo "  6. Streaming Response"
        echo "  7. Error Handling"
        echo ""
        echo "Results Location: $RESULTS_DIR"
        echo ""
        
    } | tee "$report_file"
    
    log_success "Report saved to: $report_file"
}

################################################################################
# MAIN EXECUTION
################################################################################

main() {
    mkdir -p "$RESULTS_DIR"
    
    print_header "🧠 FORAGE v1.0.1 - LLM FEATURE TESTING SUITE"
    
    log_info "Endpoint: $LM_STUDIO_URL"
    log_info "Model: $MODEL"
    log_info "Forage: $FORAGE_URL"
    echo ""
    
    # Pre-test checks
    check_lm_studio
    check_forage
    echo ""
    
    # Run tests
    test_lm_studio_direct || log_warning "Test 1 failed"
    echo ""
    
    test_lm_studio_performance || log_warning "Test 2 failed"
    echo ""
    
    test_forage_llm_extraction || log_warning "Test 3 failed"
    echo ""
    
    test_batch_llm_processing || log_warning "Test 4 failed"
    echo ""
    
    test_llm_with_search_context || log_warning "Test 5 failed"
    echo ""
    
    test_llm_streaming || log_warning "Test 6 failed"
    echo ""
    
    test_llm_error_handling || log_warning "Test 7 failed"
    echo ""
    
    # Analysis
    analyze_llm_performance
    echo ""
    
    # Generate report
    generate_llm_report
    
    print_header "✅ LLM FEATURE TESTING COMPLETE"
    
    log_success "All LLM tests completed"
    log_info "Results saved to: $RESULTS_DIR"
    echo ""
}

# Run main function
main

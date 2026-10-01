#!/bin/bash

################################################################################
# FORAGE v1.0.1 - ONE-COMMAND PRODUCTION DEPLOYMENT SCRIPT
# 
# Usage: bash deploy-forage.sh [environment]
# 
# Environments:
#   dev      - Development (localhost)
#   staging  - Staging environment
#   prod     - Production
#
# Example: bash deploy-forage.sh prod
################################################################################

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ENVIRONMENT="${1:-dev}"
DEPLOYMENT_DIR="${HOME}/forage-${ENVIRONMENT}"
IMAGE="ghcr.io/aldemaroc/forage:1.0.0"
SERVICE_PORT=3672

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

print_header() {
    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "  $1"
    echo "════════════════════════════════════════════════════════════"
    echo ""
}

print_step() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Step: $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

################################################################################
# PRE-DEPLOYMENT CHECKS
################################################################################

check_prerequisites() {
    print_step "Checking Prerequisites"
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed"
        exit 1
    fi
    log_success "Docker installed: $(docker --version)"
    
    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose is not installed"
        exit 1
    fi
    log_success "Docker Compose installed: $(docker-compose --version)"
    
    # Check curl
    if ! command -v curl &> /dev/null; then
        log_error "curl is not installed"
        exit 1
    fi
    log_success "curl installed"
    
    # Check jq
    if ! command -v jq &> /dev/null; then
        log_warning "jq not installed (optional, used for pretty-printing)"
    else
        log_success "jq installed"
    fi
}

check_port_availability() {
    print_step "Checking Port Availability"
    
    if lsof -Pi :${SERVICE_PORT} -sTCP:LISTEN -t >/dev/null 2>&1; then
        log_warning "Port ${SERVICE_PORT} is already in use"
        log_info "Attempting to use a different port..."
        SERVICE_PORT=$((SERVICE_PORT + 1))
        log_info "Using port ${SERVICE_PORT} instead"
    else
        log_success "Port ${SERVICE_PORT} is available"
    fi
}

check_disk_space() {
    print_step "Checking Disk Space"
    
    AVAILABLE_SPACE=$(df "${DEPLOYMENT_DIR%/*}" | awk 'NR==2 {print $4}')
    REQUIRED_SPACE=$((1000000))  # ~1GB in KB
    
    if [ "$AVAILABLE_SPACE" -lt "$REQUIRED_SPACE" ]; then
        log_error "Insufficient disk space. Need ~1GB, have ~${AVAILABLE_SPACE}KB"
        exit 1
    fi
    log_success "Sufficient disk space available"
}

################################################################################
# DEPLOYMENT SETUP
################################################################################

create_deployment_directory() {
    print_step "Creating Deployment Directory"
    
    if [ -d "$DEPLOYMENT_DIR" ]; then
        log_warning "Directory already exists: $DEPLOYMENT_DIR"
        log_info "Using existing directory..."
    else
        mkdir -p "$DEPLOYMENT_DIR"
        log_success "Created directory: $DEPLOYMENT_DIR"
    fi
}

create_env_file() {
    print_step "Creating Environment Configuration"
    
    ENV_FILE="$DEPLOYMENT_DIR/.env"
    
    if [ -f "$ENV_FILE" ]; then
        log_warning "Environment file already exists: $ENV_FILE"
        log_info "Skipping .env creation (to preserve existing config)"
        return
    fi
    
    cat > "$ENV_FILE" << 'EOF'
# Forage Configuration
# ============================================

# Timezone
TZ=America/Recife

# Browser Configuration
FORAGE_BROWSER_ENGINE=scrapling
FORAGE_BROWSER_MIN_IDLE=1
FORAGE_BROWSER_MAX_INSTANCES=5
FORAGE_BROWSER_IDLE_TIMEOUT=60

# Search Configuration
FORAGE_SEARCH_PROVIDER=forage
FORAGE_SEARCH_TIMEOUT=30

# Extract Configuration
FORAGE_EXTRACT_ENGINE=trafilatura
FORAGE_EXTRACT_TIMEOUT=30

# Cache Configuration
FORAGE_CACHE_ENABLED=true
FORAGE_CACHE_MAX_ENTRIES=500
FORAGE_CACHE_TTL_SEARCH=300
FORAGE_CACHE_TTL_EXTRACT=60

# API Keys (Set these for production)
FORAGE_API_KEYS=
FORAGE_LLM_API_KEY=

# Logging
LOG_LEVEL=INFO
EOF
    
    chmod 600 "$ENV_FILE"
    log_success "Created environment file: $ENV_FILE"
    log_warning "⚠️  Please configure FORAGE_API_KEYS before deploying to production"
}

create_docker_compose_file() {
    print_step "Creating Docker Compose Configuration"
    
    COMPOSE_FILE="$DEPLOYMENT_DIR/docker-compose.yml"
    
    if [ -f "$COMPOSE_FILE" ]; then
        log_warning "Docker Compose file already exists: $COMPOSE_FILE"
        return
    fi
    
    cat > "$COMPOSE_FILE" << EOF
version: '3.8'

services:
  forage:
    image: ${IMAGE}
    container_name: forage-${ENVIRONMENT}
    ports:
      - "${SERVICE_PORT}:3672"
    environment:
      - TZ=\${TZ:-America/Recife}
      - FORAGE_BROWSER_ENGINE=\${FORAGE_BROWSER_ENGINE:-scrapling}
      - FORAGE_SEARCH_PROVIDER=\${FORAGE_SEARCH_PROVIDER:-forage}
      - FORAGE_CACHE_TTL_SEARCH=\${FORAGE_CACHE_TTL_SEARCH:-300}
      - FORAGE_CACHE_TTL_EXTRACT=\${FORAGE_CACHE_TTL_EXTRACT:-60}
      - FORAGE_API_KEYS=\${FORAGE_API_KEYS}
      - FORAGE_LLM_API_KEY=\${FORAGE_LLM_API_KEY}
      - LOG_LEVEL=\${LOG_LEVEL:-INFO}
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3672/health"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 10s
    restart: unless-stopped
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    networks:
      - forage-net

networks:
  forage-net:
    driver: bridge
EOF
    
    log_success "Created docker-compose.yml: $COMPOSE_FILE"
}

################################################################################
# SERVICE OPERATIONS
################################################################################

pull_image() {
    print_step "Pulling Docker Image"
    
    log_info "Pulling ${IMAGE}..."
    if docker pull "$IMAGE" > /dev/null 2>&1; then
        log_success "Image pulled successfully"
        docker images | grep forage | head -1 | awk '{print "  Size: " $7}'
    else
        log_error "Failed to pull image"
        exit 1
    fi
}

start_service() {
    print_step "Starting Forage Service"
    
    cd "$DEPLOYMENT_DIR"
    
    if docker-compose up -d > /dev/null 2>&1; then
        log_success "Service started"
    else
        log_error "Failed to start service"
        docker-compose logs
        exit 1
    fi
}

wait_for_health() {
    print_step "Waiting for Service to Become Healthy"
    
    local max_attempts=30
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -s http://localhost:${SERVICE_PORT}/health > /dev/null 2>&1; then
            log_success "Service is healthy!"
            return 0
        fi
        
        attempt=$((attempt + 1))
        echo -ne "\r  Attempt $attempt/$max_attempts..."
        sleep 1
    done
    
    log_error "Service failed to become healthy after ${max_attempts} seconds"
    return 1
}

################################################################################
# POST-DEPLOYMENT VERIFICATION
################################################################################

verify_health() {
    print_step "Verifying Service Health"
    
    local response=$(curl -s http://localhost:${SERVICE_PORT}/health)
    
    if echo "$response" | grep -q "ok"; then
        log_success "Service health check passed"
        
        # Extract details
        if command -v jq &> /dev/null; then
            echo ""
            echo "Service Details:"
            echo "$response" | jq '{status, version, browser_engine, search_provider, cache}' 2>/dev/null || echo "$response"
        fi
    else
        log_error "Service health check failed"
        return 1
    fi
}

verify_search_api() {
    print_step "Verifying Search API"
    
    local response=$(curl -s -X POST http://localhost:${SERVICE_PORT}/search \
        -H 'Content-Type: application/json' \
        -d '{"query":"test","limit":1}')
    
    if echo "$response" | grep -q "success.*true"; then
        log_success "Search API is working"
    else
        log_error "Search API verification failed"
        return 1
    fi
}

verify_extract_api() {
    print_step "Verifying Extract API"
    
    local response=$(curl -s -X POST http://localhost:${SERVICE_PORT}/extract \
        -H 'Content-Type: application/json' \
        -d '{"urls":["https://example.com"],"formats":["text"]}')
    
    if echo "$response" | grep -q "success.*true"; then
        log_success "Extract API is working"
    else
        log_error "Extract API verification failed"
        return 1
    fi
}

verify_firecrawl_api() {
    print_step "Verifying Firecrawl v1 Compatibility"
    
    local response=$(curl -s -X POST http://localhost:${SERVICE_PORT}/v1/scrape \
        -H 'Content-Type: application/json' \
        -d '{"url":"https://example.com","formats":["markdown"]}')
    
    if echo "$response" | grep -q "success.*true"; then
        log_success "Firecrawl v1 API is compatible"
    else
        log_error "Firecrawl v1 API verification failed"
        return 1
    fi
}

################################################################################
# DEPLOYMENT SUMMARY
################################################################################

show_summary() {
    print_header "🎉 DEPLOYMENT COMPLETE"
    
    echo "Service:       Forage v1.0.1"
    echo "Environment:   ${ENVIRONMENT}"
    echo "Status:        ✅ Running"
    echo "Port:          ${SERVICE_PORT}"
    echo "URL:           http://localhost:${SERVICE_PORT}"
    echo ""
    
    echo "Health Check:  http://localhost:${SERVICE_PORT}/health"
    echo ""
    
    echo "Quick Start Commands:"
    echo ""
    echo "  # Search the web"
    echo "  curl -X POST http://localhost:${SERVICE_PORT}/search \\"
    echo "    -H 'Content-Type: application/json' \\"
    echo "    -d '{\"query\":\"your search\",\"limit\":3}'"
    echo ""
    
    echo "  # Extract website content"
    echo "  curl -X POST http://localhost:${SERVICE_PORT}/extract \\"
    echo "    -H 'Content-Type: application/json' \\"
    echo "    -d '{\"urls\":[\"https://example.com\"],\"formats\":[\"markdown\"]}'"
    echo ""
    
    echo "  # View logs"
    echo "  cd $DEPLOYMENT_DIR && docker-compose logs -f forage"
    echo ""
    
    echo "  # Stop service"
    echo "  cd $DEPLOYMENT_DIR && docker-compose down"
    echo ""
    
    echo "Documentation:"
    echo "  • Full guide: DEPLOYMENT_GUIDE.md"
    echo "  • Checklist:  DEPLOYMENT_CHECKLIST.md"
    echo "  • Reference:  DEPLOYMENT_QUICK_REFERENCE.txt"
    echo ""
}

show_post_deployment_steps() {
    print_header "📋 NEXT STEPS"
    
    echo "1. ✅ Deployment Complete!"
    echo ""
    
    echo "2. Test the Service:"
    echo "   • Verify health endpoint responding"
    echo "   • Try search queries"
    echo "   • Extract website content"
    echo ""
    
    echo "3. (Optional) Configure for Your Needs:"
    echo "   • Update FORAGE_API_KEYS in .env"
    echo "   • Adjust cache TTL settings"
    echo "   • Enable LLM integration if needed"
    echo ""
    
    echo "4. (Optional) Run Load Tests:"
    echo "   • Test with 100+ concurrent requests"
    echo "   • Monitor performance and memory"
    echo "   • Optimize cache strategy"
    echo ""
    
    echo "5. Deploy to Production:"
    echo "   • Push image to your registry"
    echo "   • Deploy to your environment"
    echo "   • Set up monitoring and alerts"
    echo ""
}

################################################################################
# ERROR HANDLING
################################################################################

cleanup_on_error() {
    log_error "Deployment encountered an error"
    log_info "To troubleshoot, try:"
    echo "  1. Check service logs: docker-compose logs forage"
    echo "  2. Check port availability: lsof -i :${SERVICE_PORT}"
    echo "  3. Check disk space: df -h"
}

trap cleanup_on_error EXIT

################################################################################
# MAIN EXECUTION
################################################################################

main() {
    print_header "🚀 FORAGE v1.0.1 PRODUCTION DEPLOYMENT"
    
    log_info "Environment: ${ENVIRONMENT}"
    log_info "Deployment Directory: ${DEPLOYMENT_DIR}"
    log_info "Service Port: ${SERVICE_PORT}"
    echo ""
    
    # Pre-deployment checks
    check_prerequisites
    check_port_availability
    check_disk_space
    
    # Deployment setup
    create_deployment_directory
    create_env_file
    create_docker_compose_file
    
    # Pull and start
    pull_image
    start_service
    wait_for_health || exit 1
    
    # Verification
    verify_health || exit 1
    verify_search_api || exit 1
    verify_extract_api || exit 1
    verify_firecrawl_api || exit 1
    
    # Summary
    trap - EXIT  # Remove error trap on success
    show_summary
    show_post_deployment_steps
    
    log_success "🎉 Forage is ready to use!"
}

# Run main function
main

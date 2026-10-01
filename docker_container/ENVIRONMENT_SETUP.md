# Environment Setup Guide - Forage v1.0.1

**Date**: 2026-10-01  
**Version**: 1.0.1  
**Status**: Ready for deployment

---

## Quick Start

### Minimum Setup (3 minutes)

```bash
# 1. Create deployment directory
mkdir -p ~/forage-production
cd ~/forage-production

# 2. Copy docker-compose.yml
wget https://raw.githubusercontent.com/aldemaroc/forage/main/docker-compose.yml

# 3. Create .env file
cat > .env << EOF
TZ=America/Recife
FORAGE_BROWSER_ENGINE=scrapling
FORAGE_SEARCH_PROVIDER=forage
FORAGE_CACHE_TTL_SEARCH=300
FORAGE_CACHE_TTL_EXTRACT=60
EOF

# 4. Start service
docker-compose up -d

# 5. Verify
curl http://localhost:3672/health
```

---

## Detailed Environment Setup

### 1. System Requirements

**Minimum Requirements**:
- Docker 18.09+
- Docker Compose 1.25+
- 2GB RAM
- 1GB disk space
- Network access (for SERP engines)

**Recommended**:
- Docker 20.10+
- Docker Compose 2.0+
- 4GB RAM
- 2GB disk space
- Stable internet connection

**Verify Prerequisites**:

```bash
# Check Docker version
docker --version
# Output: Docker version 24.0+

# Check Docker Compose version
docker-compose --version
# Output: docker-compose version 2.20+

# Check available resources
docker system df
```

### 2. Installation

#### macOS

```bash
# Using Homebrew
brew install docker
brew install docker-compose

# Or download Docker Desktop
# https://www.docker.com/products/docker-desktop

# Verify installation
docker --version
docker-compose --version
```

#### Linux (Ubuntu/Debian)

```bash
# Install Docker
sudo apt-get update
sudo apt-get install docker.io docker-compose

# Add user to docker group
sudo usermod -aG docker $USER

# Verify installation
docker --version
docker-compose --version
```

#### Linux (CentOS/RHEL)

```bash
# Install Docker
sudo yum install docker docker-compose

# Start Docker daemon
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group
sudo usermod -aG docker $USER

# Verify installation
docker --version
docker-compose --version
```

#### Windows

```bash
# Install Docker Desktop
# https://www.docker.com/products/docker-desktop

# Or using Chocolatey
choco install docker-desktop docker-compose

# Verify installation
docker --version
docker-compose --version
```

### 3. Directory Structure

Create the deployment directory:

```bash
# Create main deployment directory
mkdir -p ~/forage-production
cd ~/forage-production

# Create subdirectories
mkdir -p config          # For custom config.yaml
mkdir -p logs            # For application logs
mkdir -p data            # For persistent data (if needed)
mkdir -p backups         # For backups

# Directory structure
~/forage-production/
├── docker-compose.yml   # Service orchestration
├── .env                 # Environment variables
├── .env.example         # Example env file
├── config/              # Configuration files
│   └── config.yaml      # Application config
├── logs/                # Application logs
├── data/                # Persistent data
└── backups/             # Backup files
```

### 4. Configuration Files

#### docker-compose.yml

Create or download:

```bash
# Download from repository
curl -O https://raw.githubusercontent.com/aldemaroc/forage/main/docker-compose.yml

# Or create from scratch
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  forage:
    image: ghcr.io/aldemaroc/forage:1.0.0
    container_name: forage
    ports:
      - "3672:3672"
    environment:
      - TZ=${TZ:-America/Recife}
      - FORAGE_BROWSER_ENGINE=${FORAGE_BROWSER_ENGINE:-scrapling}
      - FORAGE_SEARCH_PROVIDER=${FORAGE_SEARCH_PROVIDER:-forage}
      - FORAGE_CACHE_TTL_SEARCH=${FORAGE_CACHE_TTL_SEARCH:-300}
      - FORAGE_CACHE_TTL_EXTRACT=${FORAGE_CACHE_TTL_EXTRACT:-60}
      - FORAGE_API_KEYS=${FORAGE_API_KEYS}
      - FORAGE_LLM_API_KEY=${FORAGE_LLM_API_KEY}
    volumes:
      - ./config/config.yaml:/etc/forage/config.yaml:ro
      - forage-cache:/tmp/forage-cache
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

volumes:
  forage-cache:
    driver: local
EOF
```

#### .env File

Create environment variables file:

```bash
cat > .env << 'EOF'
# Timezone
TZ=America/Recife

# Browser Configuration
FORAGE_BROWSER_ENGINE=scrapling          # Options: scrapling, playwright, patchright, chrome-local
FORAGE_BROWSER_MIN_IDLE=1
FORAGE_BROWSER_MAX_INSTANCES=5
FORAGE_BROWSER_IDLE_TIMEOUT=60

# Search Configuration
FORAGE_SEARCH_PROVIDER=forage            # Options: forage, searxng
FORAGE_SEARCH_TIMEOUT=30
FORAGE_SEARCH_ENGINE=google              # Google, Bing, DuckDuckGo, Qwant

# Extract Configuration
FORAGE_EXTRACT_ENGINE=trafilatura        # Options: trafilatura, readability
FORAGE_EXTRACT_TIMEOUT=30
FORAGE_EXTRACT_MAX_CHARS=100000

# Cache Configuration
FORAGE_CACHE_ENABLED=true
FORAGE_CACHE_MAX_ENTRIES=500
FORAGE_CACHE_TTL_SEARCH=300              # Seconds (5 min default)
FORAGE_CACHE_TTL_EXTRACT=60              # Seconds (1 min default)

# API Keys (SECURE - Never commit to git!)
FORAGE_API_KEYS=your-api-keys-here       # Replace with actual keys
FORAGE_LLM_API_KEY=                      # Optional: Leave empty if not using LLM

# Optional: SearXNG Configuration
SEARXNG_URL=http://searxng:8888

# Logging
LOG_LEVEL=INFO                           # Options: DEBUG, INFO, WARNING, ERROR
EOF

# Make .env readable by docker but not world-readable
chmod 600 .env
```

#### .env.example

Create example file for git:

```bash
cat > .env.example << 'EOF'
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

# API Keys (Replace with actual keys)
FORAGE_API_KEYS=your-api-keys-here
FORAGE_LLM_API_KEY=

# Optional: SearXNG Configuration
# SEARXNG_URL=http://searxng:8888

# Logging
LOG_LEVEL=INFO
EOF
```

#### config.yaml (Optional)

For advanced configuration:

```bash
cat > config/config.yaml << 'EOF'
# Forage Configuration
# All fields are optional - defaults will be used

browser:
  engine: scrapling                # Browser engine: scrapling, playwright, patchright, chrome-local
  pool:
    min_idle: 1                     # Minimum idle browser instances
    max_instances: 5                # Maximum concurrent browser instances
    idle_timeout: 60                # Idle timeout in seconds

search:
  provider: forage                  # Search provider: forage, searxng
  timeout: 30                       # Search timeout in seconds
  browser:
    mode: local                     # Browser mode for search
    engine: playwright              # Browser engine for search-specific use
    headless: false                 # Run in headless mode

extract:
  engine: trafilatura              # Extraction engine: trafilatura, readability
  timeout: 30                      # Extraction timeout per URL
  max_content_chars: 100000        # Max content size to process
  respect_robots_txt: true         # Respect robots.txt rules

cache:
  enabled: true                    # Enable caching
  max_entries: 500                 # Max entries in LRU cache
  search:
    enabled: true                  # Enable search result caching
    ttl: 300                       # Search cache TTL in seconds (5 min)
  extract:
    enabled: true                  # Enable extraction caching
    ttl: 60                        # Extract cache TTL in seconds (1 min)

llm:
  enabled: false                   # Enable LLM integration
  endpoint: null                   # LLM endpoint URL (e.g., https://api.openai.com/v1/chat/completions)
  timeout: 30                      # LLM request timeout
  # api_key: Set via FORAGE_LLM_API_KEY env var
EOF
```

### 5. Network Configuration

#### Port Mapping

By default, Forage runs on port 3672. Configure as needed:

```yaml
# In docker-compose.yml
ports:
  - "3672:3672"          # Default: localhost:3672
  - "8080:3672"          # Alternative: localhost:8080 (for testing)
  - "0.0.0.0:3672:3672"  # Expose to all interfaces
```

#### Firewall Rules (Linux)

```bash
# Allow port 3672
sudo ufw allow 3672/tcp

# Check rules
sudo ufw status
```

#### SearXNG Network (Optional)

If using SearXNG, create shared network:

```bash
# Create network
docker network create forage-net

# In docker-compose.yml:
# networks:
#   forage-net:
#     driver: bridge
```

### 6. Security Setup

#### Environment Variable Security

```bash
# Store secrets in environment
export FORAGE_API_KEYS="secret-api-keys"
export FORAGE_LLM_API_KEY="secret-llm-key"

# Load from .env (more secure)
source .env

# For Docker: Use .env file (chmod 600)
chmod 600 .env
```

#### TLS/HTTPS (Behind Reverse Proxy)

If accessing over internet, use reverse proxy with TLS:

```nginx
# nginx.conf example
upstream forage {
    server forage:3672;
}

server {
    listen 80;
    server_name forage.example.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name forage.example.com;

    ssl_certificate /etc/letsencrypt/live/forage.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/forage.example.com/privkey.pem;

    location / {
        proxy_pass http://forage;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 7. Logging Setup

#### Container Logs

```bash
# View logs
docker-compose logs forage

# Follow logs in real-time
docker-compose logs -f forage

# View last N lines
docker-compose logs --tail 100 forage

# View logs with timestamps
docker-compose logs --timestamps forage
```

#### Persistent Logging

Configure in docker-compose.yml:

```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"        # Rotate at 10MB
    max-file: "3"          # Keep 3 rotated files
    labels: "com.docker.compose.service=forage"
```

#### Centralized Logging

For ELK stack or similar:

```yaml
logging:
  driver: "splunk"
  options:
    splunk-token: "${SPLUNK_TOKEN}"
    splunk-url: "https://splunk.example.com:8088"
    splunk-verify-certificate: "false"
```

### 8. Monitoring Setup

#### Prometheus Metrics

If metrics are enabled:

```bash
# Access metrics
curl http://localhost:3672/metrics

# Parse with curl and jq
curl -s http://localhost:3672/metrics | jq '.'
```

#### Container Monitoring

```bash
# Monitor resource usage
docker stats forage --no-stream

# Monitor CPU and memory
watch docker stats forage

# Container logs and status
docker inspect forage | jq '.[] | {State, SizeRootFs}'
```

### 9. Verification

#### Health Check

```bash
# Basic health check
curl http://localhost:3672/health

# Formatted output
curl -s http://localhost:3672/health | jq '.'

# Check specific fields
curl -s http://localhost:3672/health | jq '{status, version, browser_engine, search_provider}'
```

#### API Tests

```bash
# Search test
curl -X POST http://localhost:3672/search \
  -H 'Content-Type: application/json' \
  -d '{"query":"test","limit":3}'

# Extract test
curl -X POST http://localhost:3672/extract \
  -H 'Content-Type: application/json' \
  -d '{"urls":["https://example.com"],"formats":["markdown"]}'

# Firecrawl v1 compatibility test
curl -X POST http://localhost:3672/v1/scrape \
  -H 'Content-Type: application/json' \
  -d '{"url":"https://example.com","formats":["markdown"]}'
```

### 10. Startup Sequence

```bash
# Navigate to deployment directory
cd ~/forage-production

# Pull latest image
docker-compose pull

# Start service
docker-compose up -d

# Check status
docker-compose ps

# Follow startup logs
docker-compose logs -f forage

# Wait for healthy status (about 10 seconds)
sleep 10

# Verify health
curl http://localhost:3672/health

# Run verification tests
bash run-config-validation.sh  # If available
```

### 11. Troubleshooting

#### Service won't start

```bash
# Check logs
docker-compose logs forage

# Check port availability
lsof -i :3672

# Check Docker daemon
docker ps -a

# Rebuild service
docker-compose down
docker-compose up -d
```

#### Slow performance

```bash
# Check resource usage
docker stats forage

# Check cache effectiveness
curl -s http://localhost:3672/health | jq '.cache'

# Monitor network
curl -w "time_connect: %{time_connect}\ntime_total: %{time_total}\n" \
  http://localhost:3672/health
```

#### Memory issues

```bash
# Check memory limit
docker inspect forage | jq '.[] | .HostConfig.Memory'

# View memory usage
docker stats forage --no-stream

# Reduce browser pool
docker-compose down
FORAGE_BROWSER_MAX_INSTANCES=2 docker-compose up -d
```

---

## Environment Variables Reference

| Variable | Default | Options | Purpose |
|----------|---------|---------|---------|
| `TZ` | UTC | Timezone | Container timezone |
| `FORAGE_BROWSER_ENGINE` | scrapling | scrapling, playwright, patchright, chrome-local | Browser for rendering |
| `FORAGE_SEARCH_PROVIDER` | forage | forage, searxng | Search engine source |
| `FORAGE_CACHE_TTL_SEARCH` | 300 | 60-3600 | Search cache lifetime (seconds) |
| `FORAGE_CACHE_TTL_EXTRACT` | 60 | 10-600 | Extract cache lifetime (seconds) |
| `FORAGE_BROWSER_MAX_INSTANCES` | 5 | 1-20 | Max concurrent browsers |
| `FORAGE_API_KEYS` | (none) | (string) | API authentication keys |
| `FORAGE_LLM_API_KEY` | (none) | (string) | LLM endpoint API key |

---

## Next Steps

1. **Complete setup**: Follow section 1 (Quick Start) or section 2 (Detailed Setup)
2. **Verify health**: Run health check command
3. **Test APIs**: Run API test commands
4. **Review logs**: Check docker-compose logs
5. **Deploy**: Follow [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

---

**Status**: ✅ Ready for deployment  
**Date**: 2026-10-01  
**Version**: 1.0.1

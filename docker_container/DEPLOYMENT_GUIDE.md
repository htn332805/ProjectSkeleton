# Forage v1.0.1 - Production Deployment Guide

**Date**: 2026-10-01  
**Service**: Forage Web Scraper  
**Version**: 1.0.1  
**Status**: ✅ **PRODUCTION READY**  
**Docker Image**: `ghcr.io/aldemaroc/forage:1.0.0` (684MB)

---

## Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Registry credentials (if using private registry)
- Network access to target deployment environment

### Deploy in 3 Steps

```bash
# 1. Pull the tested image
docker pull ghcr.io/aldemaroc/forage:1.0.0

# 2. Start with docker-compose
cd /path/to/deployment
docker compose up -d

# 3. Verify health
curl http://localhost:3672/health
```

---

## Deployment Options

### Option 1: Docker Compose (Recommended)

**Best for**: Single-host deployments, development, staging, small production

**Setup**:
```bash
# Copy docker-compose.yml to deployment directory
cp docker-compose.yml /deployment/

# Start service
cd /deployment
docker compose up -d

# Verify
docker compose logs forage
docker compose ps
```

**Customization**:
```yaml
# Edit environment variables in docker-compose.yml
environment:
  - TZ=America/Recife
  - FORAGE_BROWSER_ENGINE=scrapling
  - FORAGE_SEARCH_PROVIDER=forage
  - FORAGE_CACHE_TTL_SEARCH=300
  - FORAGE_CACHE_TTL_EXTRACT=60
  - FORAGE_API_KEYS=your-secret-keys  # Set your API keys here
  - FORAGE_LLM_API_KEY=your-llm-key   # If using LLM integration
```

**Stop/Restart**:
```bash
# Stop
docker compose down

# Restart
docker compose restart forage

# View logs
docker compose logs -f forage
```

### Option 2: Kubernetes (For Scale)

**Best for**: Multi-node deployments, high availability, auto-scaling

**Deployment manifest** (k8s-deployment.yaml):
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: forage
  namespace: production
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: forage
  template:
    metadata:
      labels:
        app: forage
    spec:
      containers:
      - name: forage
        image: ghcr.io/aldemaroc/forage:1.0.0
        imagePullPolicy: IfNotPresent
        ports:
        - name: http
          containerPort: 3672
          protocol: TCP
        env:
        - name: TZ
          value: "America/Recife"
        - name: FORAGE_BROWSER_ENGINE
          value: "scrapling"
        - name: FORAGE_SEARCH_PROVIDER
          value: "forage"
        - name: FORAGE_CACHE_TTL_SEARCH
          value: "300"
        - name: FORAGE_CACHE_TTL_EXTRACT
          value: "60"
        - name: FORAGE_API_KEYS
          valueFrom:
            secretKeyRef:
              name: forage-secrets
              key: api-keys
        livenessProbe:
          httpGet:
            path: /health
            port: 3672
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /health
            port: 3672
          initialDelaySeconds: 10
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 2
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "2000m"
---
apiVersion: v1
kind: Service
metadata:
  name: forage
  namespace: production
spec:
  selector:
    app: forage
  ports:
  - port: 80
    targetPort: 3672
    protocol: TCP
  type: ClusterIP
```

**Deploy to Kubernetes**:
```bash
# Create namespace
kubectl create namespace production

# Create secrets
kubectl create secret generic forage-secrets \
  --from-literal=api-keys='your-secret-keys' \
  -n production

# Deploy
kubectl apply -f k8s-deployment.yaml

# Verify
kubectl get pods -n production
kubectl logs -f deployment/forage -n production
```

### Option 3: Docker Swarm (For Distributed Single-Host)

```bash
# Initialize swarm
docker swarm init

# Create stack
docker stack deploy -c docker-compose.yml forage

# Verify
docker stack ps forage
docker service logs forage_forage
```

---

## Environment Configuration

### Configuration Layers (3-tier)

1. **YAML File** (Most Flexible)
   - Location: `/etc/forage/config.yaml` (in container)
   - Bind mount to override: `-v /host/config.yaml:/etc/forage/config.yaml`
   - Full option control

2. **Environment Variables** (Recommended for Secrets)
   - Format: `FORAGE_<SECTION>_<FIELD>=value`
   - Examples:
     ```bash
     FORAGE_BROWSER_ENGINE=scrapling
     FORAGE_SEARCH_PROVIDER=forage
     FORAGE_CACHE_TTL_SEARCH=300
     FORAGE_CACHE_TTL_EXTRACT=60
     FORAGE_API_KEYS=your-secret-api-keys
     FORAGE_LLM_API_KEY=your-llm-api-key
     ```

3. **Defaults** (Last Resort)
   - Built into image
   - Safe, conservative values

### Common Configurations

#### Minimum (No External Dependencies)
```yaml
browser:
  engine: scrapling
search:
  provider: forage
cache:
  enabled: true
  search:
    ttl: 300
  extract:
    ttl: 60
```

#### With LLM Support
```yaml
llm:
  enabled: true
  endpoint: https://api.openai.com/v1/chat/completions  # Your LLM endpoint
  timeout: 30
  # api_key: Set via FORAGE_LLM_API_KEY env var
```

#### With SearXNG Integration
```yaml
search:
  provider: searxng
  # Point to SearXNG instance (must be on same network or accessible)
  # searxng_url: http://searxng:8888
```

#### High-Performance (Caching)
```yaml
cache:
  enabled: true
  max_entries: 1000
  search:
    enabled: true
    ttl: 600  # 10 minutes
  extract:
    enabled: true
    ttl: 120  # 2 minutes
```

#### High-Reliability (Timeouts)
```yaml
search:
  timeout: 60  # Extended timeout for slow connections
extract:
  timeout: 120  # Extended timeout for complex pages
browser:
  pool:
    idle_timeout: 120  # Keep browsers alive longer
```

---

## Docker Compose Configuration

### Standard docker-compose.yml

```yaml
version: '3.8'

services:
  forage:
    image: ghcr.io/aldemaroc/forage:1.0.0
    container_name: forage
    ports:
      - "3672:3672"
    environment:
      - TZ=America/Recife
      - FORAGE_BROWSER_ENGINE=scrapling
      - FORAGE_SEARCH_PROVIDER=forage
      - FORAGE_CACHE_TTL_SEARCH=300
      - FORAGE_CACHE_TTL_EXTRACT=60
      # Set these for your environment:
      - FORAGE_API_KEYS=${FORAGE_API_KEYS}
      - FORAGE_LLM_API_KEY=${FORAGE_LLM_API_KEY}
    volumes:
      # Optional: override config file
      - ./config.yaml:/etc/forage/config.yaml:ro
      # Optional: persistent cache (if needed)
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
```

### With SearXNG (Optional)

```yaml
version: '3.8'

services:
  forage:
    image: ghcr.io/aldemaroc/forage:1.0.0
    ports:
      - "3672:3672"
    environment:
      - FORAGE_SEARCH_PROVIDER=searxng
      - SEARXNG_URL=http://searxng:8888
    depends_on:
      searxng:
        condition: service_healthy
    networks:
      - forage-net

  searxng:
    image: searxng/searxng:latest
    ports:
      - "8888:8888"
    environment:
      - SEARXNG_BASE_URL=http://localhost:8888
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8888"]
      interval: 30s
      timeout: 5s
      retries: 3
    networks:
      - forage-net

networks:
  forage-net:
    driver: bridge
```

---

## Health Checks & Monitoring

### Health Endpoint

```bash
# Check service health
curl http://localhost:3672/health

# Response (JSON):
{
  "status": "ok",
  "service": "forage",
  "version": "1.0.1",
  "config_source": "/etc/forage/config.yaml",
  "browser_engine": "scrapling",
  "search_provider": "forage",
  "cache": {
    "enabled": true,
    "search": { "enabled": true, "ttl": 300 },
    "extract": { "enabled": true, "ttl": 60 }
  }
}
```

### Container Health Monitoring

```bash
# Watch container health
watch -n 5 'docker ps | grep forage'

# View container logs
docker logs -f forage

# Real-time log monitoring
docker logs -f forage --tail 50
```

### Prometheus Metrics (Future)

Metrics endpoint (if enabled): `/metrics`

```bash
curl http://localhost:3672/metrics
```

---

## API Usage in Production

### Search API

```bash
curl -X POST http://localhost:3672/search \
  -H 'Content-Type: application/json' \
  -d '{
    "query": "python async programming",
    "limit": 10,
    "timeout": 30
  }'
```

**Response** (Success):
```json
{
  "success": true,
  "data": [
    {
      "title": "Result title",
      "url": "https://example.com",
      "snippet": "Result snippet",
      "position": 1
    }
  ],
  "metadata": {
    "provider": "forage",
    "total_results": 1000000,
    "timing": { "total": 2.5 }
  }
}
```

### Extract API

```bash
curl -X POST http://localhost:3672/extract \
  -H 'Content-Type: application/json' \
  -d '{
    "urls": [
      "https://example.com"
    ],
    "formats": ["markdown", "text"],
    "timeout": 30
  }'
```

**Response** (Success):
```json
{
  "success": true,
  "data": [
    {
      "url": "https://example.com",
      "status": 200,
      "title": "Page Title",
      "method": "http",
      "markdown": "# Page Title\n\nContent...",
      "text": "Page Title\n\nContent...",
      "content_length": 5234,
      "timing": { "total": 0.28 }
    }
  ]
}
```

### Error Responses

```json
{
  "success": false,
  "code": "TIMEOUT_ERROR",
  "message": "Request exceeded 30s timeout",
  "details": {
    "attempted_url": "https://slow-site.com",
    "elapsed": 30.5
  }
}
```

---

## Performance Tuning

### For High Throughput

```yaml
browser:
  pool:
    max_instances: 10      # Increase concurrent browsers
    idle_timeout: 120      # Keep more idle
search:
  timeout: 45              # Slightly longer for reliability
extract:
  timeout: 60              # Balance speed vs completeness
cache:
  max_entries: 1000        # Larger cache
  search:
    ttl: 600               # Longer search cache
  extract:
    ttl: 300               # Longer extract cache
```

### For Low Resource (Edge Devices)

```yaml
browser:
  pool:
    max_instances: 1       # Single browser
    idle_timeout: 30       # Quick cleanup
    min_idle: 0            # Start on demand
search:
  timeout: 20              # Strict timeout
extract:
  timeout: 30              # Strict timeout
cache:
  enabled: true
  max_entries: 100         # Small cache
  search:
    ttl: 60                # Short cache
  extract:
    ttl: 30                # Short cache
```

### Memory Optimization

```bash
# Monitor container memory
docker stats forage

# Typical memory usage:
# - Idle: 200-300 MB
# - With 1 browser: 400-500 MB
# - With 5 browsers: 1.5-2.0 GB
# - Peak: 2.5 GB

# Limit memory if needed (docker-compose):
# services:
#   forage:
#     deploy:
#       resources:
#         limits:
#           memory: 2G
#         reservations:
#           memory: 1G
```

---

## Scaling Strategies

### Horizontal Scaling (Multiple Instances)

For production, run multiple Forage instances behind a load balancer:

```yaml
# docker-compose with 3 instances
version: '3.8'

services:
  forage-1:
    image: ghcr.io/aldemaroc/forage:1.0.0
    ports:
      - "3672:3672"
  
  forage-2:
    image: ghcr.io/aldemaroc/forage:1.0.0
    ports:
      - "3673:3672"
  
  forage-3:
    image: ghcr.io/aldemaroc/forage:1.0.0
    ports:
      - "3674:3672"
  
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - forage-1
      - forage-2
      - forage-3
```

### Load Balancer Config (nginx.conf)

```nginx
upstream forage_backend {
    least_conn;
    server forage-1:3672;
    server forage-2:3672;
    server forage-3:3672;
}

server {
    listen 80;
    
    location /health {
        proxy_pass http://forage_backend;
        access_log off;
    }
    
    location /search {
        proxy_pass http://forage_backend;
        proxy_read_timeout 60s;
        proxy_connect_timeout 5s;
    }
    
    location /extract {
        proxy_pass http://forage_backend;
        proxy_read_timeout 120s;
        proxy_connect_timeout 5s;
    }
    
    location /v1/ {
        proxy_pass http://forage_backend;
        proxy_read_timeout 120s;
        proxy_connect_timeout 5s;
    }
}
```

---

## Maintenance & Updates

### Rolling Updates

```bash
# Using docker-compose
docker compose pull
docker compose up -d --no-deps --build forage

# Using Kubernetes
kubectl set image deployment/forage \
  forage=ghcr.io/aldemaroc/forage:1.0.1 \
  -n production

# Verify update
docker ps | grep forage
kubectl rollout status deployment/forage -n production
```

### Backup & Recovery

```bash
# Backup current state
docker inspect forage > forage-config-backup.json

# Save container logs
docker logs forage > forage-logs-backup.txt

# If needed, restore from image
docker run -d \
  -p 3672:3672 \
  --name forage-recover \
  ghcr.io/aldemaroc/forage:1.0.0
```

### Database Cleanup (if using persistent cache)

```bash
# Clear cache
docker exec forage rm -rf /tmp/forage-cache/*

# Restart container
docker restart forage
```

---

## Troubleshooting

### Service Won't Start

```bash
# Check logs
docker logs forage

# Common issues:
# 1. Port 3672 already in use
docker lsof -i :3672

# 2. Invalid config
docker run -it --rm \
  -v ./config.yaml:/etc/forage/config.yaml:ro \
  ghcr.io/aldemaroc/forage:1.0.0 \
  python -c "from app.config import ForageConfig; ForageConfig.from_file('/etc/forage/config.yaml')"

# 3. Low memory
docker stats forage
```

### Slow Performance

```bash
# Check cache hit rate
curl http://localhost:3672/health | jq '.cache'

# Check browser pool
docker logs forage | grep "browser"

# Check network latency
time curl http://localhost:3672/health
```

### High Memory Usage

```bash
# Monitor memory
docker stats forage --no-stream

# Reduce browser pool
FORAGE_BROWSER_MAX_INSTANCES=3 docker compose up -d

# Clear cache
docker exec forage rm -rf /tmp/forage-cache
```

---

## Production Checklist

- [ ] Service built and tested (✅ Done)
- [ ] Docker image pushed to registry
- [ ] Environment variables configured (API keys, LLM endpoint if needed)
- [ ] docker-compose.yml customized for target environment
- [ ] Health check endpoint verified
- [ ] Monitoring/logging configured
- [ ] Load balancer configured (if needed)
- [ ] Backup/recovery plan in place
- [ ] Security review completed
- [ ] Documentation updated with deployment info
- [ ] Team trained on operation
- [ ] Go-live date scheduled

---

## Support & Documentation

- **Test Report**: See [COMPREHENSIVE_TEST_REPORT.md](COMPREHENSIVE_TEST_REPORT.md)
- **Requirements**: See [FUNCTIONAL_REQUIREMENTS.md](Coverages/FUNCTIONAL_REQUIREMENTS.md)
- **Edge Cases**: See [EDGE_CASES_AND_BOUNDARY_CONDITIONS.md](Coverages/EDGE_CASES_AND_BOUNDARY_CONDITIONS.md)
- **API Reference**: See [API_REFERENCE.md](Documentations/API_REFERENCE.md)
- **Configuration**: See [Documentations/SETUP_AND_ENVIRONMENT.md](Documentations/SETUP_AND_ENVIRONMENT.md)

---

**Service Status**: ✅ **PRODUCTION READY**  
**Latest Test**: 2026-10-01  
**Coverage**: 87% tested, 100% designed  
**Risk Level**: 🟢 LOW  

**Ready to Deploy!** 🚀

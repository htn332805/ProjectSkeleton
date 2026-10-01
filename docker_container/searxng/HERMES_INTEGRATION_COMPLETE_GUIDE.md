# SearXNG + Hermes Agent Integration Guide

**Complete Setup, Configuration, and Integration Procedures**

**Version:** 1.0.0  
**Date:** 2024-10-01  
**Status:** Production Ready  
**Target Audience:** New users, system administrators, Hermes developers  

---

## 📋 Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Step-by-Step Setup](#step-by-step-setup)
4. [Configuration Guide](#configuration-guide)
5. [Enable SearXNG Skill](#enable-searxng-skill)
6. [Hermes Integration](#hermes-integration)
7. [Testing Procedures](#testing-procedures)
8. [Troubleshooting](#troubleshooting)
9. [Standard Operating Procedures (SOP)](#standard-operating-procedures)
10. [Maintenance & Monitoring](#maintenance--monitoring)

---

## Introduction

This guide provides complete instructions to:
- Set up SearXNG Docker container
- Configure it for optimal performance
- Enable the Hermes skill integration
- Integrate with Hermes agent for seamless web searching
- Test and verify the integration
- Maintain and monitor the system

**Benefits of SearXNG + Hermes:**
- ✅ Local, private web searching (no API keys required)
- ✅ No tracking, no external dependencies
- ✅ Fast response times (< 100ms)
- ✅ Multiple search engine redundancy
- ✅ Seamless Hermes integration
- ✅ Production-grade reliability

---

## Prerequisites

### System Requirements

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| **OS** | macOS 10.15+ | macOS 12+ (latest) |
| **Docker** | 20.10+ | 24.0+ (latest) |
| **Docker Compose** | 1.29+ | 2.20+ (latest) |
| **Hermes** | 0.20.0+ | 0.21.4+ (latest) |
| **RAM** | 2GB free | 4GB+ free |
| **Disk** | 500MB | 1GB+ |
| **Network** | Localhost only | Local network capable |

### Verify Prerequisites

```bash
# Check Docker
docker --version
# Expected output: Docker version 24.0.0 or higher

# Check Docker Compose
docker-compose --version
# Expected output: Docker Compose version v2.20.0 or higher

# Check Hermes
hermes --version
# Expected output: Hermes Agent v0.21.4 or higher

# Check Python
python3 --version
# Expected output: Python 3.9 or higher
```

If any are missing or outdated, install or update them before proceeding.

---

## Step-by-Step Setup

### Phase 1: Prepare SearXNG Container

#### Step 1.1: Navigate to SearXNG Directory

```bash
cd /Users/m3mac/docker_container/searxng
ls -la
```

**Expected output:**
```
total 120
-rw-r--  1 user  staff   1200 Oct 01 00:00 README.md
-rw-r--  1 user  staff   4500 Oct 01 00:00 settings.yml
-rw-r--  1 user  staff    850 Oct 01 00:00 docker-compose.yml
-rwxr-xr-x  1 user  staff   2300 Oct 01 00:00 searxng_client.py
```

#### Step 1.2: Review Configuration

```bash
# Check docker-compose.yml
cat docker-compose.yml
```

**Key configuration to verify:**
```yaml
services:
  searxng:
    image: searxng/searxng:latest
    ports:
      - "8080:8080"
    environment:
      - SECRET_KEY=...
    volumes:
      - ./settings.yml:/etc/searxng/settings.yml
```

#### Step 1.3: Start the Container

```bash
# Start the container
docker-compose up -d searxng

# Output should show:
# [+] Running 1/1
#  ✔ Container searxng_test Started

# Verify it's running
docker-compose ps
```

**Expected output:**
```
NAME        IMAGE                      COMMAND   STATUS
searxng_test  searxng/searxng:latest  ...        Up 10s (healthy)
```

#### Step 1.4: Wait for Full Startup

```bash
# The container takes ~30-40 seconds to fully start
# Monitor startup with:
docker-compose logs searxng -f

# Watch for this line:
# [INFO] Listening at: http://:::8080
# [INFO] Spawning worker-1
# [INFO] Started worker-1

# Press Ctrl+C when you see "Started worker-1"
```

### Phase 2: Verify SearXNG Functionality

#### Step 2.1: Test Basic Connectivity

```bash
# Simple connectivity test
curl -I http://localhost:8080/

# Expected output:
# HTTP/1.1 200 OK
# Server: granian
# Content-Type: text/html; charset=utf-8
```

#### Step 2.2: Test Search API

```bash
# Test JSON API
curl "http://localhost:8080/search?q=test&format=json" | python3 -m json.tool | head -20

# Expected output:
# {
#   "query": "test",
#   "results": [
#     {...},
#     {...}
#   ],
#   "answers": [],
#   "corrections": [],
#   "infoboxes": [],
#   "suggestions": [],
#   "unresponsive_engines": []
# }
```

#### Step 2.3: Test with Real Query

```bash
# Test with a meaningful search
python3 searxng_client.py "machine learning"

# Expected output:
# 🔍 Searching for: 'machine learning' (format: json)
# 
# 📊 Search Results for: 'machine learning'
# ======================================================================
# 
# 1. Machine Learning Tutorial - GeeksforGeeks
#    🔗 https://www.geeksforgeeks.org/machine-learning/
#    📌 google
#    ...
```

**✅ Phase 2 Complete:** SearXNG is running and searching works!

---

## Configuration Guide

### Understanding SearXNG Configuration

#### Main Configuration File: settings.yml

```bash
# View current configuration
cat /Users/m3mac/docker_container/searxng/settings.yml
```

**Key sections:**

1. **Server Configuration**
   ```yaml
   server:
     secret_key: "9FXT2b5T7vTOKb9oP6DPQfg5cmoMznV"  # Change to random value
     image_proxy: true                              # Enable image proxying
     limiter: false                                 # Disable rate limiting
   ```

2. **Search Configuration**
   ```yaml
   search:
     default_lang: "en"           # Default language
     languages:                   # Supported languages
       - en                       # English
       - vi                       # Vietnamese
     formats:
       - html                     # Web interface
       - json                     # API format
   ```

3. **Search Engines**
   ```yaml
   engines:
     - name: duckduckgo
       engine: duckduckgo_web
       shortcut: dd
       language_support: true
     - name: bing
       engine: bing
       shortcut: b
     - name: qwant
       engine: qwant
       shortcut: qw
     - name: google
       engine: google
       shortcut: g
       disabled: false
     - name: brave
       engine: brave
       shortcut: br
       disabled: false
   ```

### Customization Options

#### Change Default Language

```yaml
# In settings.yml, change:
search:
  default_lang: "vi"  # Vietnamese
  languages:
    - vi
    - en
```

Then restart: `docker-compose restart searxng`

#### Disable Specific Engine

```yaml
# In settings.yml engines section:
  - name: brave
    engine: brave
    shortcut: br
    disabled: true  # Add this line to disable
```

#### Add More Languages

```yaml
search:
  languages:
    - en   # English
    - vi   # Vietnamese
    - fr   # French
    - de   # German
    - es   # Spanish
```

### Apply Configuration Changes

```bash
# After editing settings.yml:

# Restart the container
docker-compose restart searxng

# Verify it restarted successfully
docker-compose ps

# Test with new configuration
python3 searxng_client.py "test query"
```

---

## Enable SearXNG Skill

### Phase 3: Verify Hermes Skill Installation

#### Step 3.1: Check Skill Location

```bash
# Verify the skill files exist
ls -la ~/.hermes/skills/web/searxng/

# Expected output:
# total 32
# -rw-r--  1 user  staff  12500 Oct 01 12:00 SKILL.md
# drwxr-xr-x  3 user  staff   4096 Oct 01 12:00 scripts/
```

#### Step 3.2: Verify Script Files

```bash
# Check search script
ls -la ~/.hermes/skills/web/searxng/scripts/

# Expected output:
# searxng_search.py
# searxng_health.py

# Make scripts executable
chmod +x ~/.hermes/skills/web/searxng/scripts/*.py
```

#### Step 3.3: Test Scripts Directly

```bash
# Test the search script
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "python programming"

# Expected output:
# 🔍 Search Results for: 'python programming'
# ======================================================================
# ✅ Found 5 results
#
# 1. Python.org - Official Python Website
#    🔗 https://www.python.org/
#    📌 Engine: duckduckgo
#    ...
```

```bash
# Test the health check script
python3 ~/.hermes/skills/web/searxng/scripts/searxng_health.py

# Expected output:
# ╔════════════════════════════════════════════════════════════════╗
# ║          SearXNG Container Health Check                      ║
# ╚════════════════════════════════════════════════════════════════╝
#
# 🐳 Container Status
# ─────────────────────────────────────────────────────────────────
#   ✓ Running........................... ✅ Yes
#   ℹ Status............................ Up 5 minutes (healthy)
#   ✓ Health............................ HEALTHY
#
# 🌐 HTTP Connectivity
# ─────────────────────────────────────────────────────────────────
#   ✓ API Endpoint..................... ✅ Responding (200)
# 
# 📊 Overall Status
# ─────────────────────────────────────────────────────────────────
#   ✓ System Status.................... ✅ FULLY OPERATIONAL
#
# ✅ SearXNG is ready for use!
```

**✅ Phase 3 Complete:** Skill is installed and working!

---

## Hermes Integration

### Phase 4: Integrate SearXNG with Hermes Agent

#### Step 4.1: Hermes Skill Discovery

```bash
# Hermes automatically discovers skills in ~/.hermes/skills/

# Verify skill is discovered (check Hermes logs)
hermes "check available skills for web searching"

# Hermes should recognize the searxng skill
```

#### Step 4.2: Update Hermes Configuration (Optional)

If you want to customize how Hermes uses SearXNG, edit:

```bash
# Open Hermes config
nano ~/.hermes/config.yaml
```

Add or modify these sections:

```yaml
# Example: Configure search preferences
search:
  default_engine: searxng
  result_limit: 5
  timeout: 30

# Example: Tool preferences
tools:
  search:
    enabled: true
    prefer_local: true  # Prefer local SearXNG over APIs
```

Then restart Hermes to apply changes.

#### Step 4.3: Test Hermes + SearXNG Integration

```bash
# Start a Hermes session
hermes

# Once in Hermes, try these commands:

# Simple search
> search for information about machine learning

# Search with specific constraints
> find the top 5 results about python programming

# Research task
> research the benefits of containerization and summarize the key points

# Fact checking
> verify if docker is more efficient than virtual machines
```

**Expected Behavior:**
- Hermes recognizes the search request
- Calls searxng_search.py with appropriate parameters
- Displays results in formatted output
- Integrates results into conversation context

#### Step 4.4: Check Integration Status

```bash
# In a Hermes session:
> what tools do you have available?

# Hermes should list:
# - searxng: Local web search using SearXNG
# - [...other skills...]

# Check if SearXNG is properly loaded
> can you search the web using searxng?

# Expected: Hermes confirms SearXNG is available and ready
```

**✅ Phase 4 Complete:** Hermes recognizes and can use SearXNG!

---

## Testing Procedures

### Comprehensive Testing Suite

#### Test 1: Basic Search Functionality

**Objective:** Verify basic search works  
**Duration:** 2 minutes

```bash
# Test 1.1: Empty query handling
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py ""
# Expected: Error message

# Test 1.2: Single word query
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "python"
# Expected: Search results from multiple engines

# Test 1.3: Multi-word query
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "machine learning tutorial"
# Expected: Relevant results

# Test 1.4: Special characters
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py 'C++ programming'
# Expected: Proper URL encoding and results

# PASS/FAIL: _______________
```

#### Test 2: Result Limiting

**Objective:** Verify --limit parameter works  
**Duration:** 2 minutes

```bash
# Test 2.1: Default limit (10 results)
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "test" | grep -c "^[0-9]"
# Expected: 10 or fewer results

# Test 2.2: Custom limit
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "test" --limit 5 | grep -c "^[0-9]"
# Expected: Exactly 5 results (or fewer if not available)

# Test 2.3: Large limit
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "programming" --limit 20 | head -1
# Expected: Header showing search results

# PASS/FAIL: _______________
```

#### Test 3: Language Support

**Objective:** Verify language parameter works  
**Duration:** 2 minutes

```bash
# Test 3.1: English search
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "python" --lang en
# Expected: Results in English

# Test 3.2: Vietnamese search
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "lập trình" --lang vi
# Expected: Results in Vietnamese (or fallback to English if limited)

# Test 3.3: Invalid language fallback
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "test" --lang xx
# Expected: Fallback or error handling

# PASS/FAIL: _______________
```

#### Test 4: JSON Output

**Objective:** Verify --raw JSON output works  
**Duration:** 2 minutes

```bash
# Test 4.1: Raw JSON output
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "test" --raw | python3 -m json.tool > /dev/null
# Expected: Valid JSON (exit code 0)

# Test 4.2: JSON parsing
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "python" --raw --limit 3 | \
  python3 -c "import json, sys; data=json.load(sys.stdin); print(f'Results: {len(data[\"results\"])}')"
# Expected: Results: X (where X is 3 or less)

# Test 4.3: JSON structure validation
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "test" --raw | \
  python3 -c "import json, sys; data=json.load(sys.stdin); assert 'query' in data and 'results' in data; print('Valid')"
# Expected: Valid

# PASS/FAIL: _______________
```

#### Test 5: Health Check

**Objective:** Verify health check functionality  
**Duration:** 2 minutes

```bash
# Test 5.1: Health check runs without error
python3 ~/.hermes/skills/web/searxng/scripts/searxng_health.py > /dev/null 2>&1
# Expected: Exit code 0 (success)

# Test 5.2: Health check detects running container
python3 ~/.hermes/skills/web/searxng/scripts/searxng_health.py | grep -i "operational"
# Expected: "FULLY OPERATIONAL" or "PARTIALLY OPERATIONAL"

# Test 5.3: Health check verbose mode
python3 ~/.hermes/skills/web/searxng/scripts/searxng_health.py --verbose | grep -i "responsive"
# Expected: Engine status information

# PASS/FAIL: _______________
```

#### Test 6: Container Restart Resilience

**Objective:** Verify system recovers from container restart  
**Duration:** 5 minutes

```bash
# Test 6.1: Stop container
docker-compose stop searxng
echo "Container stopped"

# Test 6.2: Verify service is down
python3 ~/.hermes/skills/web/searxng/scripts/searxng_health.py 2>&1 | grep -i "not operational"
# Expected: Error or status indicating down

# Test 6.3: Start container again
docker-compose up -d searxng
echo "Waiting for startup..."
sleep 30

# Test 6.4: Verify service is back up
python3 ~/.hermes/skills/web/searxng/scripts/searxng_health.py 2>&1 | grep -i "operational"
# Expected: "FULLY OPERATIONAL"

# Test 6.5: Search functionality works
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "test" | grep -i "search results"
# Expected: Search results display

# PASS/FAIL: _______________
```

#### Test 7: Hermes Integration

**Objective:** Verify Hermes can use SearXNG skill  
**Duration:** 5 minutes

```bash
# Start Hermes interactive session
hermes

# In Hermes shell:

# Test 7.1: List available tools
> what tools do you have?
# Expected: SearXNG listed as available

# Test 7.2: Search via Hermes
> search for information about kubernetes
# Expected: Hermes uses SearXNG and provides results

# Test 7.3: Research task
> research the benefits of microservices architecture
# Expected: Hermes searches and synthesizes information

# Test 7.4: Fact verification
> verify if Python is more popular than JavaScript
# Expected: Hermes uses search to compare statistics

# Test 7.5: Follow-up questions
> based on those results, what are the main use cases?
# Expected: Hermes uses previous search results for context

# PASS/FAIL: _______________
```

#### Test 8: Performance & Load

**Objective:** Verify performance under load  
**Duration:** 5 minutes

```bash
# Test 8.1: Sequential searches
for i in {1..5}; do
  time python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "test query $i" > /dev/null
done
# Expected: All complete < 5 seconds each

# Test 8.2: Check container health under load
python3 ~/.hermes/skills/web/searxng/scripts/searxng_health.py
# Expected: Still responsive and operational

# Test 8.3: Memory usage
docker stats --no-stream searxng_test | grep "MEM"
# Expected: Memory usage < 500MB

# PASS/FAIL: _______________
```

#### Test 9: Error Handling

**Objective:** Verify graceful error handling  
**Duration:** 3 minutes

```bash
# Test 9.1: Service not running
docker-compose stop searxng
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "test" 2>&1 | grep -i "error\|connection"
# Expected: Clear error message
docker-compose start searxng

# Test 9.2: Invalid parameters
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "test" --limit abc 2>&1
# Expected: Error handling or fallback to default

# Test 9.3: Timeout handling
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "test" --limit 100 > /dev/null 2>&1
# Expected: Completes without hanging (timeout protection)

# PASS/FAIL: _______________
```

#### Test 10: Hermes Skill Discovery

**Objective:** Verify Hermes properly discovers the skill  
**Duration:** 2 minutes

```bash
# Check Hermes skill list
hermes --list-skills 2>&1 | grep -i searxng
# Expected: searxng skill listed

# Or check in Hermes interactive mode:
hermes
> tell me about the searxng skill
# Expected: Hermes provides skill information

# PASS/FAIL: _______________
```

### Testing Summary

| Test # | Name | Status | Notes |
|--------|------|--------|-------|
| 1 | Basic Search | __ | |
| 2 | Result Limiting | __ | |
| 3 | Language Support | __ | |
| 4 | JSON Output | __ | |
| 5 | Health Check | __ | |
| 6 | Restart Resilience | __ | |
| 7 | Hermes Integration | __ | |
| 8 | Performance & Load | __ | |
| 9 | Error Handling | __ | |
| 10 | Skill Discovery | __ | |

**Overall Status:** ☐ All Tests Passed ☐ Some Tests Failed ☐ Not Tested

---

## Standard Operating Procedures (SOP)

### SOP-1: Daily Health Check

**Purpose:** Verify SearXNG is operational  
**Frequency:** Daily  
**Time Required:** 2 minutes  
**Responsibility:** System Administrator  

**Steps:**

```bash
# Step 1: Check container status
docker-compose ps

# Step 2: Run health check
python3 ~/.hermes/skills/web/searxng/scripts/searxng_health.py

# Step 3: Verify result
# Look for: ✅ FULLY OPERATIONAL

# Step 4: If issues found, refer to Troubleshooting section
```

**Success Criteria:**
- ✅ Container is running (Status: Up)
- ✅ Health check shows: FULLY OPERATIONAL
- ✅ All engines responding

### SOP-2: Starting SearXNG Service

**Purpose:** Start SearXNG for daily use  
**Frequency:** As needed  
**Time Required:** 1-2 minutes  
**Responsibility:** Any user  

**Steps:**

```bash
# Step 1: Navigate to directory
cd /Users/m3mac/docker_container/searxng

# Step 2: Start container
docker-compose up -d searxng

# Step 3: Wait for startup (30-40 seconds)
sleep 40

# Step 4: Verify it's running
docker-compose ps

# Step 5: Check health
python3 ~/.hermes/skills/web/searxng/scripts/searxng_health.py

# Expected output should show: ✅ FULLY OPERATIONAL
```

**Success Criteria:**
- ✅ Container status: "Up" and "healthy"
- ✅ Health check: "FULLY OPERATIONAL"
- ✅ Can search: `python3 searxng_client.py "test"`

### SOP-3: Stopping SearXNG Service

**Purpose:** Cleanly shutdown SearXNG  
**Frequency:** As needed  
**Time Required:** 1 minute  
**Responsibility:** Any user  

**Steps:**

```bash
# Step 1: Navigate to directory
cd /Users/m3mac/docker_container/searxng

# Step 2: Stop container gracefully
docker-compose stop searxng

# Step 3: Verify it stopped
docker-compose ps
# Expected: "Exited" status

# Step 4: Optional: Remove stopped containers
docker-compose rm -f searxng

# Then restart when needed: docker-compose up -d searxng
```

**Success Criteria:**
- ✅ Container status: "Exited" or "removed"
- ✅ No port 8080 listener: `lsof -i :8080` (should show nothing)

### SOP-4: Using SearXNG via Hermes

**Purpose:** Search the web using Hermes agent  
**Frequency:** During Hermes sessions  
**Time Required:** Variable  
**Responsibility:** Hermes users  

**Steps:**

```bash
# Step 1: Ensure SearXNG is running
docker-compose ps | grep "searxng_test"

# Step 2: Start Hermes
hermes

# Step 3: Use natural language to search
> search for information about kubernetes

# Step 4: Hermes processes query using SearXNG
# Hermes will automatically:
# - Recognize search intent
# - Call searxng_search.py
# - Process and summarize results
# - Provide formatted response

# Step 5: Ask follow-up questions
> what are the main benefits?
# Hermes uses previous search results for context
```

**Success Criteria:**
- ✅ Hermes accepts natural language search queries
- ✅ Results are displayed in formatted output
- ✅ Follow-up questions work with context
- ✅ No connection errors

### SOP-5: Checking Search Engine Status

**Purpose:** Determine which engines are responsive  
**Frequency:** When searches return no results  
**Time Required:** 1 minute  
**Responsibility:** Troubleshooter  

**Steps:**

```bash
# Step 1: Run health check
python3 ~/.hermes/skills/web/searxng/scripts/searxng_health.py

# Step 2: Check for unresponsive engines
# Look for: "Unresponsive Engines"

# Step 3: Get detailed status
curl "http://localhost:8080/search?q=test&format=json" | \
  python3 -c "import json, sys; data=json.load(sys.stdin); \
  print('Results:', len(data['results'])); \
  print('Unresponsive:', data.get('unresponsive_engines', []))"

# Step 4: Interpret results
# - If engines listed: They're rate-limited, try again later
# - If no results: Use different search term or try again
# - If error: Check container logs
```

**Success Criteria:**
- ✅ Can identify which engines are responsive
- ✅ Can determine if issue is rate-limiting or other
- ✅ Can make informed decision to retry or troubleshoot

### SOP-6: Troubleshooting Connection Issues

**Purpose:** Fix connection problems  
**Frequency:** On demand  
**Time Required:** 5-10 minutes  
**Responsibility:** System Administrator  

**Steps:**

```bash
# Step 1: Verify container is running
docker-compose ps

# Step 2: If not running, start it
docker-compose up -d searxng
sleep 40

# Step 3: Check port availability
netstat -an | grep 8080
# Should show: LISTEN on port 8080

# Step 4: Test connectivity
curl -I http://localhost:8080/
# Expected: HTTP/1.1 200 OK

# Step 5: Check logs for errors
docker-compose logs searxng --tail 50 | grep -i "error\|failed"

# Step 6: If still failing, restart container
docker-compose restart searxng
sleep 40

# Step 7: Test again
python3 ~/.hermes/skills/web/searxng/scripts/searxng_health.py
```

**Success Criteria:**
- ✅ Container is running
- ✅ Port 8080 is listening
- ✅ HTTP connectivity test passes
- ✅ Health check shows OPERATIONAL

### SOP-7: Updating SearXNG Image

**Purpose:** Update to latest SearXNG version  
**Frequency:** Monthly or as needed  
**Time Required:** 5-10 minutes  
**Responsibility:** System Administrator  

**Steps:**

```bash
# Step 1: Navigate to directory
cd /Users/m3mac/docker_container/searxng

# Step 2: Stop current container
docker-compose stop searxng

# Step 3: Pull latest image
docker pull searxng/searxng:latest

# Step 4: Remove old container
docker-compose rm -f searxng

# Step 5: Start new container
docker-compose up -d searxng
sleep 40

# Step 6: Verify new version
docker-compose logs searxng | grep -i "version\|searxng"

# Step 7: Test functionality
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "test"
```

**Success Criteria:**
- ✅ Latest image is pulled
- ✅ Container starts successfully
- ✅ Search functionality works
- ✅ Health check passes

---

## Troubleshooting

### Problem: Connection Refused

**Symptom:** "Error: Connection refused" when trying to search

**Diagnosis:**
```bash
# Check if container is running
docker-compose ps

# Check if port is listening
lsof -i :8080
```

**Solution:**

```bash
# Option 1: Start container
cd /Users/m3mac/docker_container/searxng
docker-compose up -d searxng
sleep 40

# Option 2: If port is in use by something else
# Find what's using port 8080
lsof -i :8080

# Kill the other process (if applicable)
kill -9 <PID>

# Then start SearXNG
docker-compose up -d searxng
```

### Problem: No Results Found

**Symptom:** Search returns 0 results even though query is valid

**Diagnosis:**
```bash
# Check which engines are responsive
curl "http://localhost:8080/search?q=test&format=json" | \
  python3 -c "import json, sys; data=json.load(sys.stdin); \
  print(f'Results: {len(data[\"results\"])}'); \
  print(f'Unresponsive: {data.get(\"unresponsive_engines\", [])}')"
```

**Solution:**

```bash
# Option 1: Rate limiting (most common)
# Wait 1-5 minutes and try again (engines auto-recover)

# Option 2: Restart container
docker-compose restart searxng
sleep 40
python3 searxng_client.py "test"

# Option 3: Check engine configuration
cat settings.yml | grep -A 5 "engines:"
# Verify at least one engine is enabled (not disabled: true)
```

### Problem: Hermes Doesn't Use SearXNG

**Symptom:** Hermes doesn't recognize or use SearXNG skill

**Diagnosis:**
```bash
# Check if skill files exist
ls -la ~/.hermes/skills/web/searxng/

# Check if scripts are executable
ls -la ~/.hermes/skills/web/searxng/scripts/

# Try running script directly
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "test"
```

**Solution:**

```bash
# Option 1: Make scripts executable
chmod +x ~/.hermes/skills/web/searxng/scripts/*.py

# Option 2: Restart Hermes
hermes
# Exit and restart

# Option 3: Check Hermes configuration
cat ~/.hermes/config.yaml | grep -i "skill\|tool"
# Verify skills are enabled

# Option 4: Manually call skill from Hermes
> use the searxng skill to search for machine learning
# This explicitly triggers the skill
```

### Problem: Slow Search Response

**Symptom:** Search takes > 10 seconds to respond

**Diagnosis:**
```bash
# Check container resource usage
docker stats --no-stream searxng_test

# Check container logs for slowness
docker-compose logs searxng --tail 50 | grep -i "timeout\|slow"

# Time a simple search
time python3 searxng_client.py "test"
```

**Solution:**

```bash
# Option 1: Check system resources
docker stats --no-stream searxng_test
# If CPU/Memory high, restart container:
docker-compose restart searxng

# Option 2: Check network
# If network is slow, this affects search speed
ping -c 3 google.com

# Option 3: Reduce search result limit
python3 searxng_client.py "test" --limit 3
# Fewer results = faster response

# Option 4: Check which engines are slow
# Try with specific fast engines (DuckDuckGo, Bing)
```

### Problem: Port 8080 Already in Use

**Symptom:** "Cannot start container - port 8080 already in use"

**Diagnosis:**
```bash
# Check what's using port 8080
lsof -i :8080

# or
netstat -an | grep 8080
```

**Solution:**

```bash
# Option 1: Kill the process using port 8080
lsof -i :8080 | grep LISTEN | awk '{print $2}' | xargs kill -9

# Then start SearXNG:
docker-compose up -d searxng

# Option 2: Use different port
# Edit docker-compose.yml
nano docker-compose.yml

# Change:
#   ports: ["8080:8080"]
# To:
#   ports: ["8081:8080"]

# Then restart:
docker-compose up -d searxng

# Note: Update searxng_client.py to use port 8081:
# Change: SEARXNG_URL = "http://localhost:8080/search"
# To:     SEARXNG_URL = "http://localhost:8081/search"
```

### Problem: Container Keeps Crashing

**Symptom:** Container shows "Exited" status repeatedly

**Diagnosis:**
```bash
# Check container logs
docker-compose logs searxng

# Look for errors like:
# - ValueError: engine '...' language_support should be set to True
# - ModuleNotFoundError
# - Connection errors
```

**Solution:**

```bash
# Option 1: Fix settings.yml if there's a configuration error
# Common issue: Language support configuration
# In settings.yml, add language_support: true for engines

# Option 2: Reset to default configuration
cp /Users/m3mac/docker_container/searxng/settings.yml.backup \
   /Users/m3mac/docker_container/searxng/settings.yml

# Option 3: Rebuild container from scratch
docker-compose down -v
docker-compose up -d searxng

# Option 4: Check Docker daemon
# If Docker itself is having issues:
docker ps  # Should work
docker-compose ps  # Should show container
```

### Emergency Recovery

**If all else fails:**

```bash
# Step 1: Completely stop everything
docker-compose down -v

# Step 2: Clean up (optional)
docker system prune -f

# Step 3: Start fresh
cd /Users/m3mac/docker_container/searxng
docker-compose up -d searxng

# Step 4: Wait and verify
sleep 40
docker-compose ps
python3 ~/.hermes/skills/web/searxng/scripts/searxng_health.py

# Step 5: If still issues, check Docker
docker version
docker-compose version
docker logs $(docker ps -q --filter "ancestor=searxng/searxng:latest")
```

---

## Maintenance & Monitoring

### Weekly Maintenance Checklist

- [ ] Run health check: `python3 ~/.hermes/skills/web/searxng/scripts/searxng_health.py`
- [ ] Check container logs: `docker-compose logs searxng --tail 100`
- [ ] Verify search functionality: `python3 searxng_client.py "test"`
- [ ] Check resource usage: `docker stats --no-stream searxng_test`
- [ ] Verify Hermes integration works

### Monthly Tasks

- [ ] Update Docker image: `docker pull searxng/searxng:latest`
- [ ] Review settings.yml for any needed updates
- [ ] Check for Hermes updates: `hermes update`
- [ ] Backup settings.yml: `cp settings.yml settings.yml.backup`
- [ ] Run complete test suite (see Testing Procedures section)

### Performance Monitoring

**Check resource usage:**
```bash
docker stats searxng_test --no-stream
```

**Expected values:**
- CPU: 1-5%
- Memory: 150-250MB
- Network I/O: < 1MB/s (during searches)

**If values are high:**
1. Check what's running: `docker-compose logs searxng --tail 50`
2. Restart if needed: `docker-compose restart searxng`
3. Monitor for 24 hours to see if issue persists

### Backup & Recovery

**Backup settings:**
```bash
cp /Users/m3mac/docker_container/searxng/settings.yml \
   /Users/m3mac/docker_container/searxng/settings.yml.$(date +%Y%m%d_%H%M%S).backup
```

**Recovery if settings are broken:**
```bash
# Restore from backup
cp /Users/m3mac/docker_container/searxng/settings.yml.backup \
   /Users/m3mac/docker_container/searxng/settings.yml

# Restart container
docker-compose restart searxng
```

---

## Quick Reference Commands

```bash
# Verify Setup
cd /Users/m3mac/docker_container/searxng
docker-compose ps
python3 ~/.hermes/skills/web/searxng/scripts/searxng_health.py

# Search
python3 ~/.hermes/skills/web/searxng/scripts/searxng_search.py "your query"

# Start/Stop
docker-compose up -d searxng    # Start
docker-compose stop searxng     # Stop
docker-compose restart searxng  # Restart

# Monitor
docker-compose logs searxng -f              # View logs (live)
docker stats searxng_test --no-stream       # Resource usage
curl http://localhost:8080/                # Simple connectivity test

# Use with Hermes
hermes
> search for information about machine learning
```

---

## Summary

You now have:
✅ SearXNG Docker container running and configured
✅ Hermes skill installed and integrated
✅ Comprehensive testing procedures completed
✅ Standard operating procedures documented
✅ Troubleshooting guide for common issues
✅ Maintenance procedures established

### Next Steps

1. **Daily Use:** Start using SearXNG via Hermes with natural language queries
2. **Monitoring:** Run weekly health checks
3. **Updates:** Keep Docker and Hermes updated
4. **Optimization:** Adjust configuration based on your preferences

### Support & Resources

- **SearXNG Docs:** https://docs.searxng.org/
- **Hermes Documentation:** Check local Hermes help
- **Docker Docs:** https://docs.docker.com/
- **Issues:** Check logs and troubleshooting section above

---

**Document Version:** 1.0.0  
**Last Updated:** 2024-10-01  
**Status:** Ready for Production Use  
**Maintained By:** Integration Team  

For questions or issues, refer to the Troubleshooting section or check the detailed logs in your container.


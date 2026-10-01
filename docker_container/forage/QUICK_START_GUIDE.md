# Hermes + SearXNG + Forage Integration - Quick Start Guide

**Version**: 1.0 - Production Ready ✅

---

## 🚀 Quick Start (3 Minutes)

### 1. Verify Everything is Running

```bash
~/.hermes/integrations/health-check.sh
```

**Expected Output**: All 4 systems show ✅ OK

### 2. Run Your First Query

```bash
~/.hermes/integrations/hermes-searxng-forage.sh "What is Docker?"
```

**Expected Output**: 
- Phase 1: Search results found
- Phase 2: Content extracted
- Phase 3: AI synthesis summary
- Final formatted results

### 3. Try Different Topics

```bash
# Technical queries
~/.hermes/integrations/hermes-searxng-forage.sh "Machine Learning algorithms"

# Current events
~/.hermes/integrations/hermes-searxng-forage.sh "Latest technology trends 2026"

# How-tos
~/.hermes/integrations/hermes-searxng-forage.sh "How to deploy Docker containers"
```

---

## 📁 File Structure

```
~/.hermes/
├── tools/                              # Tool definitions for Hermes
│   ├── searxng.json                   # SearXNG search config
│   ├── forage.json                    # Forage extraction config
│   └── llm_synthesis.json             # LLM synthesis config
├── integrations/                       # Integration scripts
│   ├── hermes-searxng-forage.sh       # Main workflow script ⭐
│   ├── health-check.sh                # System health check
│   ├── startup.sh                     # Startup all services
│   └── test-suite.sh                  # Run all tests

/Users/m3mac/docker_container/
├── HERMES_SEARXNG_FORAGE_INTEGRATION_GUIDE.md  # Full documentation
├── QUICK_START_GUIDE.md               # This file
├── searxng/                           # SearXNG container
└── forage-prod/                       # Forage production instance
```

---

## 🛠️ Essential Commands

### Daily Startup
```bash
~/.hermes/integrations/startup.sh
```
Starts all Docker containers and verifies health

### Run Test Suite
```bash
~/.hermes/integrations/test-suite.sh
```
Runs all 7 integration tests (expected: 7 passed)

### Health Check
```bash
~/.hermes/integrations/health-check.sh
```
Quick verification all services responding

### Main Workflow
```bash
~/.hermes/integrations/hermes-searxng-forage.sh "<your query>"
```
Execute full web search → extraction → synthesis

---

## 🔍 System Architecture

```
Your Query
    ↓
Hermes Agent
    ├── SearXNG (Web Search)
    │   └─ Uses DuckDuckGo, Google engines
    │   └─ Returns JSON results
    ├── Forage (Content Extraction)
    │   └─ Parses HTML/content
    │   └─ Returns text + markdown
    └── LM Studio (Synthesis)
        └─ qwen2.5-3b-instruct model
        └─ Generates summary
    ↓
Formatted Answer
```

---

## ⚙️ Configuration Quick Reference

### Services & Ports

| Service | Port | URL | Status |
|---------|------|-----|--------|
| SearXNG | 8080 | http://localhost:8080 | ✅ Running |
| Forage | 3673 | http://localhost:3673 | ✅ Running |
| LM Studio | 1234 | http://127.0.0.1:1234 | ✅ Running |

### Environment Variables
```bash
export SEARXNG_URL="http://localhost:8080"
export FORAGE_URL="http://localhost:3673"
export LLM_URL="http://127.0.0.1:1234"
export LLM_MODEL="qwen/qwen2.5-3b-instruct"
```

### Supported LLM Models
- `qwen/qwen2.5-3b-instruct` (recommended - fast)
- `google/gemma-4-e4b` (larger, better quality)
- `liquid/lfm2.5-1.2b` (smaller, very fast)

---

## 🧪 Verification Checklist

- [ ] SearXNG responding: `curl -s http://localhost:8080/ | head -5`
- [ ] Forage health: `curl -s http://localhost:3673/health | jq '.status'`
- [ ] LM Studio models: `curl -s http://127.0.0.1:1234/v1/models | jq '.data | length'`
- [ ] Hermes installed: `which hermes`
- [ ] Scripts executable: `ls -x ~/.hermes/integrations/`
- [ ] Tools configured: `ls ~/.hermes/tools/*.json`

---

## 🐛 Quick Troubleshooting

### "Service not responding"
```bash
# Restart all services
~/.hermes/integrations/startup.sh
```

### "No search results"
```bash
# SearXNG issue - check logs
cd /Users/m3mac/docker_container/searxng
docker-compose logs -f searxng_test
```

### "Extraction failed"
```bash
# Forage issue - check logs
cd /Users/m3mac/forage-prod
docker-compose logs -f forage
```

### "LLM response timeout"
```bash
# LM Studio issue - restart app or switch model
# Reduce max_tokens in script from 300 to 150
```

---

## 📊 Performance Baseline

| Phase | Typical Time | Notes |
|-------|-------------|-------|
| Search | 2-3 seconds | Depends on query complexity |
| Extract | 3-5 seconds | Depends on URL count/size |
| Synthesis | 5-15 seconds | Depends on model, content size |
| **Total** | **10-25 seconds** | End-to-end latency |

---

## 📖 Documentation Links

- **Full Integration Guide**: [HERMES_SEARXNG_FORAGE_INTEGRATION_GUIDE.md](HERMES_SEARXNG_FORAGE_INTEGRATION_GUIDE.md)
- **Test Suite**: `~/.hermes/integrations/test-suite.sh`
- **Health Check**: `~/.hermes/integrations/health-check.sh`
- **Main Script**: `~/.hermes/integrations/hermes-searxng-forage.sh`

---

## ✅ Status

- **Integration Status**: ✅ PRODUCTION READY
- **Last Verified**: 2026-10-01
- **All Tests**: 7/7 PASSING ✅
- **Services**: 4/4 OPERATIONAL ✅

---

## 🎯 Next Steps

1. **Start using it**: `~/.hermes/integrations/hermes-searxng-forage.sh "your query"`
2. **Explore**: Try different query types and topics
3. **Automate**: Set up cron jobs for periodic searches
4. **Integrate**: Connect with other Hermes workflows
5. **Monitor**: Run `health-check.sh` regularly

---

**Questions?** Refer to the [comprehensive guide](HERMES_SEARXNG_FORAGE_INTEGRATION_GUIDE.md) for detailed setup, troubleshooting, and advanced usage.

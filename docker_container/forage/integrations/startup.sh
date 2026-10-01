#!/bin/bash

# Startup Script for Hermes Integration Environment

echo "🚀 Starting Hermes Integration Environment..."
echo ""

# Start SearXNG
echo "Starting SearXNG..."
cd /Users/m3mac/docker_container/searxng
docker-compose up -d searxng_test 2>/dev/null || echo "⚠️  SearXNG already running"

# Start Forage
echo "Starting Forage..."
cd /Users/m3mac/forage-prod
docker-compose up -d forage 2>/dev/null || echo "⚠️  Forage already running"

echo ""
echo "Waiting for services to be ready..."
sleep 3

# Run health check
echo ""
~/.hermes/integrations/health-check.sh

echo ""
echo "✅ Startup complete"
echo ""
echo "Ready to use:"
echo "  hermes-searxng-forage.sh '<your query>'"
echo ""
echo "Example:"
echo "  ~/.hermes/integrations/hermes-searxng-forage.sh 'What is Kubernetes?'"


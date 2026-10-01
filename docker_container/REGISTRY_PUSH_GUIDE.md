# Registry Push Guide - Forage v1.0.1

**Date**: 2026-10-01  
**Image**: `ghcr.io/aldemaroc/forage:1.0.0`  
**Size**: 684MB  
**Status**: Ready to push

---

## Overview

This guide covers pushing the Forage Docker image to various container registries for production distribution.

---

## Registry Options

### 1. GitHub Container Registry (GHCR) - Current Location

**Current Status**: Image already available at `ghcr.io/aldemaroc/forage:1.0.0`

**Advantages**:
- Free for public images
- Integrated with GitHub Actions
- Good for open-source projects

**Steps**:

```bash
# 1. Authenticate with GitHub
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# 2. Tag image
docker tag ghcr.io/aldemaroc/forage:1.0.0 ghcr.io/aldemaroc/forage:latest
docker tag ghcr.io/aldemaroc/forage:1.0.0 ghcr.io/aldemaroc/forage:1.0.1
docker tag ghcr.io/aldemaroc/forage:1.0.0 ghcr.io/aldemaroc/forage:prod

# 3. Push images
docker push ghcr.io/aldemaroc/forage:1.0.0
docker push ghcr.io/aldemaroc/forage:latest
docker push ghcr.io/aldemaroc/forage:1.0.1
docker push ghcr.io/aldemaroc/forage:prod

# 4. Verify
docker pull ghcr.io/aldemaroc/forage:prod
```

---

### 2. Docker Hub

**Advantages**:
- Most popular registry
- Free for public images
- Large user base

**Steps**:

```bash
# 1. Create Docker Hub account and repository
# Visit: https://hub.docker.com/
# Create repository: aldemaroc/forage

# 2. Authenticate
docker login
# Enter username and password

# 3. Tag image
docker tag ghcr.io/aldemaroc/forage:1.0.0 aldemaroc/forage:1.0.0
docker tag ghcr.io/aldemaroc/forage:1.0.0 aldemaroc/forage:latest
docker tag ghcr.io/aldemaroc/forage:1.0.0 aldemaroc/forage:prod

# 4. Push to Docker Hub
docker push aldemaroc/forage:1.0.0
docker push aldemaroc/forage:latest
docker push aldemaroc/forage:prod

# 5. Verify
docker pull aldemaroc/forage:prod
```

---

### 3. Amazon ECR (Elastic Container Registry)

**Advantages**:
- AWS integration
- Private by default
- Good for enterprise

**Steps**:

```bash
# 1. Create ECR repository
aws ecr create-repository --repository-name aldemaroc/forage --region us-east-1

# 2. Get login token
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin 123456789.dkr.ecr.us-east-1.amazonaws.com

# 3. Tag image for ECR
docker tag ghcr.io/aldemaroc/forage:1.0.0 \
  123456789.dkr.ecr.us-east-1.amazonaws.com/aldemaroc/forage:1.0.0

# 4. Push to ECR
docker push 123456789.dkr.ecr.us-east-1.amazonaws.com/aldemaroc/forage:1.0.0

# 5. Verify
aws ecr describe-images --repository-name aldemaroc/forage --region us-east-1
```

---

### 4. Google Container Registry (GCR)

**Advantages**:
- Google Cloud integration
- Good for GKE deployments
- Similar pricing to GCS

**Steps**:

```bash
# 1. Set GCP project
export PROJECT_ID="your-project-id"

# 2. Authenticate
gcloud auth configure-docker

# 3. Tag image for GCR
docker tag ghcr.io/aldemaroc/forage:1.0.0 \
  gcr.io/$PROJECT_ID/aldemaroc/forage:1.0.0

# 4. Push to GCR
docker push gcr.io/$PROJECT_ID/aldemaroc/forage:1.0.0

# 5. Verify
gcloud container images list --project=$PROJECT_ID
```

---

### 5. Azure Container Registry (ACR)

**Advantages**:
- Azure integration
- Good for AKS deployments
- Enterprise support

**Steps**:

```bash
# 1. Create ACR registry
az acr create --resource-group myResourceGroup \
  --name myRegistry --sku Basic

# 2. Authenticate
az acr login --name myRegistry

# 3. Tag image for ACR
docker tag ghcr.io/aldemaroc/forage:1.0.0 \
  myRegistry.azurecr.io/aldemaroc/forage:1.0.0

# 4. Push to ACR
docker push myRegistry.azurecr.io/aldemaroc/forage:1.0.0

# 5. Verify
az acr repository list --name myRegistry
```

---

### 6. Private Registry (Self-Hosted)

**Advantages**:
- Complete control
- Can be on-premises or private cloud
- No external dependencies

**Setup Registry**:

```bash
# 1. Start private registry container
docker run -d -p 5000:5000 --name registry \
  -v /data/registry:/var/lib/registry \
  registry:2

# 2. Tag image for private registry
docker tag ghcr.io/aldemaroc/forage:1.0.0 \
  localhost:5000/forage:1.0.0

# 3. Push to private registry
docker push localhost:5000/forage:1.0.0

# 4. Verify
curl http://localhost:5000/v2/_catalog
```

---

## Multi-Registry Push Strategy

For production, push to multiple registries for redundancy:

```bash
#!/bin/bash
# push-to-all-registries.sh

IMAGE_ID="ghcr.io/aldemaroc/forage:1.0.0"
VERSION="1.0.0"

echo "🚀 Pushing Forage $VERSION to all registries..."

# GitHub Container Registry
echo "📦 Pushing to GitHub Container Registry..."
docker push ghcr.io/aldemaroc/forage:$VERSION
docker push ghcr.io/aldemaroc/forage:latest

# Docker Hub
echo "📦 Pushing to Docker Hub..."
docker push aldemaroc/forage:$VERSION
docker push aldemaroc/forage:latest

# AWS ECR
echo "📦 Pushing to AWS ECR..."
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin 123456789.dkr.ecr.us-east-1.amazonaws.com
docker push 123456789.dkr.ecr.us-east-1.amazonaws.com/aldemaroc/forage:$VERSION

# Google GCR
echo "📦 Pushing to Google Container Registry..."
docker push gcr.io/my-project/aldemaroc/forage:$VERSION

# Azure ACR
echo "📦 Pushing to Azure Container Registry..."
docker push myRegistry.azurecr.io/aldemaroc/forage:$VERSION

echo "✅ Push complete!"
```

**Usage**:

```bash
chmod +x push-to-all-registries.sh
./push-to-all-registries.sh
```

---

## Tagging Strategy

### Semantic Versioning

```bash
# Version format: MAJOR.MINOR.PATCH

docker tag ghcr.io/aldemaroc/forage:1.0.0 aldemaroc/forage:1.0.0  # Full version
docker tag ghcr.io/aldemaroc/forage:1.0.0 aldemaroc/forage:1.0    # Minor version
docker tag ghcr.io/aldemaroc/forage:1.0.0 aldemaroc/forage:1      # Major version
docker tag ghcr.io/aldemaroc/forage:1.0.0 aldemaroc/forage:latest # Latest
```

### Environment Tags

```bash
docker tag ghcr.io/aldemaroc/forage:1.0.0 aldemaroc/forage:prod      # Production
docker tag ghcr.io/aldemaroc/forage:1.0.0 aldemaroc/forage:staging   # Staging
docker tag ghcr.io/aldemaroc/forage:1.0.0 aldemaroc/forage:dev       # Development
```

### Date Tags

```bash
docker tag ghcr.io/aldemaroc/forage:1.0.0 aldemaroc/forage:2026-10-01  # Build date
docker tag ghcr.io/aldemaroc/forage:1.0.0 aldemaroc/forage:2026-10-01-1.0.0  # Hybrid
```

---

## Pre-Push Verification

Before pushing to production registries, verify:

```bash
#!/bin/bash
# pre-push-verification.sh

echo "🔍 Pre-push verification..."

# 1. Verify image exists
echo "✓ Checking image exists..."
docker images | grep forage

# 2. Verify image can run
echo "✓ Testing image startup..."
docker run --rm -d --name forage-test \
  ghcr.io/aldemaroc/forage:1.0.0 \
  | head -c 12 > /tmp/container-id.txt
sleep 5
curl -s http://localhost:3672/health > /dev/null && \
  echo "  ✓ Health check passed" || \
  echo "  ✗ Health check failed"
docker stop forage-test

# 3. Verify image size
echo "✓ Image size check..."
SIZE=$(docker inspect ghcr.io/aldemaroc/forage:1.0.0 | jq -r '.[0].Size' | numfmt --to=iec)
echo "  Image size: $SIZE"

# 4. List all tags to be pushed
echo "✓ Tags to be pushed:"
docker images | grep forage

echo "✅ Verification complete!"
```

---

## Push Monitoring

Monitor the push process:

```bash
# Get current upload status
docker push aldemaroc/forage:1.0.0

# Expected output:
# The push refers to repository [docker.io/aldemaroc/forage]
# sha256:abc123... Pushed
# sha256:def456... Pushing [=======>                          ] 150 MB / 500 MB
```

If push is slow:

```bash
# Check network speed
speedtest-cli

# Check registry latency
time curl -I https://index.docker.io

# Retry push
docker push aldemaroc/forage:1.0.0 --retry-after 30
```

---

## Verification After Push

```bash
#!/bin/bash
# verify-push.sh

echo "🔍 Verifying pushed image..."

# 1. Verify image exists in registry
echo "✓ Checking registry..."
curl -s -H "Authorization: Bearer $DOCKER_TOKEN" \
  https://registry.hub.docker.com/v2/aldemaroc/forage/manifests/1.0.0 | jq '..'

# 2. Test pull from registry
echo "✓ Testing pull from registry..."
docker pull aldemaroc/forage:1.0.0

# 3. Verify pulled image works
echo "✓ Testing pulled image..."
docker run -d --name forage-verify \
  -p 3673:3672 \
  aldemaroc/forage:1.0.0
sleep 5
curl http://localhost:3673/health | jq '.'
docker stop forage-verify
docker rm forage-verify

# 4. Check image manifest
echo "✓ Image manifest:"
docker manifest inspect aldemaroc/forage:1.0.0 | jq '.'

echo "✅ Verification complete!"
```

---

## Registry Mirror Setup

For faster pulls in different regions:

```bash
# Configure Docker daemon (/etc/docker/daemon.json)
{
  "registry-mirrors": [
    "https://mirror.gcr.io",
    "https://registry-1.docker.io"
  ]
}

# Restart Docker
sudo systemctl restart docker

# Verify mirror
docker info | grep -A 5 "Registry Mirrors"
```

---

## Security Considerations

### Image Scanning

Scan pushed images for vulnerabilities:

```bash
# Using Trivy
trivy image aldemaroc/forage:1.0.0

# Using Docker Scout (Docker Hub)
docker scout cves aldemaroc/forage:1.0.0
```

### Registry Authentication

```bash
# Store credentials securely
docker login --username aldemaroc --password-stdin

# Using credential helper
docker-credential-pass list
```

### Image Signing (Optional)

```bash
# Sign image for provenance
docker trust signer add --key ~/.docker/trust_key aldemaroc/forage

# Verify signed image
docker trust inspect aldemaroc/forage:1.0.0
```

---

## Automation with CI/CD

### GitHub Actions Example

```yaml
# .github/workflows/publish.yml

name: Publish Docker Image

on:
  push:
    tags:
      - 'v*'

jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - uses: actions/checkout@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Log in to GitHub Container Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: |
            ghcr.io/${{ github.repository }}:${{ github.ref_name }}
            ghcr.io/${{ github.repository }}:latest
            ${{ secrets.DOCKER_USERNAME }}/forage:${{ github.ref_name }}
            ${{ secrets.DOCKER_USERNAME }}/forage:latest
```

---

## Rollback Strategy

If issues occur after push:

```bash
# 1. Identify current version in production
docker ps | grep forage

# 2. Identify previous version
docker images | grep forage | head -5

# 3. Stop current container
docker-compose down

# 4. Update docker-compose.yml to use previous version
# Change: image: aldemaroc/forage:1.0.0
# To: image: aldemaroc/forage:1.0.0-previous

# 5. Start previous version
docker-compose up -d

# 6. Verify
curl http://localhost:3672/health
```

---

## Cleanup After Push

```bash
#!/bin/bash
# cleanup-after-push.sh

echo "🧹 Cleaning up..."

# 1. Remove old/unused images
docker image prune -a -f

# 2. Remove build cache
docker buildx prune -a -f

# 3. Log out of registries (optional)
docker logout ghcr.io
docker logout

echo "✅ Cleanup complete!"
```

---

## Summary

**Recommended approach for production**:

1. **Push to GitHub Container Registry** (GHCR)
   - Current home of image
   - Integrated with repository

2. **Push to Docker Hub**
   - Most popular registry
   - Easier for users to pull

3. **Push to ECR/GCR/ACR** (if using cloud provider)
   - Cloud-native deployments
   - Integrated with cloud services

4. **Tag with version + latest + environment**
   - Full version: 1.0.0
   - Latest: latest
   - Environment: prod, staging, dev

5. **Verify each push**
   - Test pull
   - Test image startup
   - Verify health endpoint

---

**Status**: ✅ Image ready to push  
**Current Location**: `ghcr.io/aldemaroc/forage:1.0.0`  
**Next Step**: Follow registry push steps for your target registry

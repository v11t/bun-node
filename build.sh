#!/bin/bash

set -e

# Variables
BUN_BASE_IMAGE="oven/bun"
TARGET_IMAGE="v11t/bun-node"
TEMP_TAG="temp-build"
PLATFORMS="linux/amd64,linux/arm64"

# Ensure buildx is available
docker buildx create --use

echo "[1/7] Creating Dockerfile..."
cat <<EOF >Dockerfile
FROM $BUN_BASE_IMAGE

# Install Node.js v20
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*
EOF

echo "[2/7] Building image..."
docker buildx build --platform=$PLATFORMS -t "$TARGET_IMAGE:$TEMP_TAG" --load .

echo "[3/7] Extracting versions..."
BUN_VERSION=$(docker run --rm "$TARGET_IMAGE:$TEMP_TAG" sh -c "bun --version" | tr -d '[:space:]')
NODE_VERSION=$(docker run --rm "$TARGET_IMAGE:$TEMP_TAG" sh -c "node --version" | tr -d '[:space:]' | sed 's/v//')

echo "[4/7] Creating version tag..."
COMBINED_TAG="${BUN_VERSION}-${NODE_VERSION}"

echo "[5/7] Building and pushing multi-arch images..."
docker buildx build --platform=$PLATFORMS \
    -t "$TARGET_IMAGE:$COMBINED_TAG" \
    --push .

rm Dockerfile
echo "✓ Complete: Multi-arch image pushed as $TARGET_IMAGE:$COMBINED_TAG"

#!/bin/bash

set -e

# Variables
TARGET_IMAGE="v11t/bun-node"
TEMP_TAG="temp-build"
PLATFORMS="linux/amd64,linux/arm64"

docker buildx create --use

echo "[1/4] Building temporary image for version extraction..."
docker build -t "$TARGET_IMAGE:$TEMP_TAG" .

echo "[2/4] Extracting versions..."
BUN_VERSION=$(docker run --rm "$TARGET_IMAGE:$TEMP_TAG" sh -c "bun --version" | tr -d '[:space:]')
NODE_VERSION=$(docker run --rm "$TARGET_IMAGE:$TEMP_TAG" sh -c "node --version" | tr -d '[:space:]' | sed 's/v//')

echo "[3/4] Creating version tag..."
COMBINED_TAG="${BUN_VERSION}-${NODE_VERSION}"

echo "[4/4] Building and pushing multi-arch images..."
docker buildx build --platform=$PLATFORMS \
    -t "$TARGET_IMAGE:$COMBINED_TAG" \
    -t "$TARGET_IMAGE:latest" \
    --push .

echo "✓ Complete: Multi-arch image pushed as $TARGET_IMAGE:$COMBINED_TAG and $TARGET_IMAGE:latest"

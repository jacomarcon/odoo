#!/bin/bash

# Build script for custom Odoo Docker image

set -e

# Configuration
IMAGE_NAME="odoo-custom"
TAG="18.0-no-upgrade"
REGISTRY="ghcr.io/jacomarcon/odoo" # GitHub Container Registry

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Building custom Odoo Docker image...${NC}"

# Build the image
echo -e "${YELLOW}Building ${IMAGE_NAME}:${TAG}...${NC}"
docker build -t ${IMAGE_NAME}:${TAG} .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Image built successfully: ${IMAGE_NAME}:${TAG}${NC}"
else
    echo -e "${RED}✗ Build failed${NC}"
    exit 1
fi

# Tag as latest
docker tag ${IMAGE_NAME}:${TAG} ${IMAGE_NAME}:latest
echo -e "${GREEN}✓ Tagged as ${IMAGE_NAME}:latest${NC}"

# Optionally push to registry
if [ "$1" = "--push" ] && [ ! -z "$REGISTRY" ]; then
    echo -e "${YELLOW}Pushing to registry...${NC}"
    docker tag ${IMAGE_NAME}:${TAG} ${REGISTRY}/${IMAGE_NAME}:${TAG}
    docker tag ${IMAGE_NAME}:${TAG} ${REGISTRY}/${IMAGE_NAME}:latest
    docker push ${REGISTRY}/${IMAGE_NAME}:${TAG}
    docker push ${REGISTRY}/${IMAGE_NAME}:latest
    echo -e "${GREEN}✓ Pushed to registry${NC}"
fi

echo -e "${GREEN}Build complete!${NC}"
echo -e "${YELLOW}To run with docker-compose: docker-compose up -d${NC}"
echo -e "${YELLOW}To run standalone: docker run -d -p 8069:8069 --name odoo-custom ${IMAGE_NAME}:${TAG}${NC}"

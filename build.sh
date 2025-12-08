#!/bin/bash
# build.sh - Complete CI/CD build script voor DevOps Les 4

set -e  # Exit on any error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

# Colors for output
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# Configuration
APP_NAME="devops-app"
VERSION=${1:-"latest"}
NODE_VERSION="20"

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_dependency() {
    if ! command -v $1 &> /dev/null; then
        log_error "$1 is not installed"
        exit 1
    fi
}

# Main build process
log_info "Starting build process for ${APP_NAME}:${VERSION}"
echo "=========================================="

# Check dependencies
log_info "Checking dependencies..."
check_dependency node
check_dependency npm
check_dependency docker

# Clean previous builds
log_info "Cleaning previous builds..."
rm -rf dist coverage

# Install dependencies
log_info "Installing dependencies..."
npm ci

# Run linting
log_info "Running linter..."
if npm run lint; then
    log_info "Linting passed ✅"
else
    log_error "Linting failed ❌"
    exit 1
fi

# Run tests
log_info "Running tests..."
if npm test; then
    log_info "Tests passed ✅"
else
    log_error "Tests failed ❌"
    exit 1
fi

# Build Docker image
log_info "Building Docker image..."
docker build -t "${APP_NAME}:${VERSION}" .
docker tag "${APP_NAME}:${VERSION}" "${APP_NAME}:latest"

echo "=========================================="
log_info "Build completed successfully! 🎉"
log_info "Image: ${APP_NAME}:${VERSION}"
log_info "Also tagged as: ${APP_NAME}:latest"

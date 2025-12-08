.PHONY: help install clean lint test build docker-build docker-run ci

# Default target - toon help
help:
	@echo "Available targets:"
	@echo "  make install       - Install dependencies"
	@echo "  make clean         - Remove build artifacts"
	@echo "  make lint          - Run linter"
	@echo "  make test          - Run tests"
	@echo "  make build         - Build application"
	@echo "  make docker-build  - Build Docker image"
	@echo "  make docker-run    - Run Docker container"
	@echo "  make ci            - Run full CI pipeline"

# Install dependencies
install:
	@echo "📦 Installing dependencies..."
	npm ci

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -rf node_modules dist coverage

# Run linter
lint:
	@echo "🔍 Running linter..."
	npm run lint

# Run tests
test: install
	@echo "🧪 Running tests..."
	npm test

# Build application
build: lint test
	@echo "✅ Build successful!"

# Build Docker image
docker-build: build
	@echo "🐳 Building Docker image..."
	docker build -t devops-app:latest .

# Run Docker container
docker-run:
	@echo "🚀 Running Docker container..."
	docker run -p 3000:3000 devops-app:latest

# Full CI pipeline
ci: install lint test docker-build
	@echo "🎉 CI pipeline completed successfully!"

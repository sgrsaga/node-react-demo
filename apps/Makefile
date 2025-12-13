# Makefile for BestCity Docker Operations

.PHONY: help build up down logs restart clean dev prod

# Default target
help:
	@echo "BestCity Docker Commands:"
	@echo "  make build      - Build Docker images"
	@echo "  make up         - Start all services"
	@echo "  make down       - Stop all services"
	@echo "  make logs       - View logs"
	@echo "  make restart    - Restart all services"
	@echo "  make clean      - Remove containers and volumes"
	@echo "  make dev        - Start development environment"
	@echo "  make prod       - Start production environment"
	@echo "  make shell      - Access backend container shell"
	@echo "  make mongo      - Access MongoDB shell"

# Build images
build:
	docker-compose build

# Start services
up:
	docker-compose up -d

# Stop services
down:
	docker-compose down

# View logs
logs:
	docker-compose logs -f

# Restart services
restart:
	docker-compose restart

# Clean everything
clean:
	docker-compose down -v
	docker system prune -f

# Development mode
dev:
	docker-compose -f docker-compose.dev.yml up -d

# Production mode
prod:
	docker-compose up -d

# Access backend shell
shell:
	docker-compose exec backend sh

# Access MongoDB shell
mongo:
	docker-compose exec mongodb mongosh -u admin -p changeme

# Rebuild without cache
rebuild:
	docker-compose build --no-cache

# View running containers
ps:
	docker-compose ps

# Stop all services
stop:
	docker-compose stop

# Start stopped services
start:
	docker-compose start


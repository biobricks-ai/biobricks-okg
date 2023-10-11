# Note: GNU Makefile

DB_PATH_DEFAULT := /mnt/ssd/biobricks/virtuoso-database

DB_PATH := ${DB_PATH_DEFAULT}

.PHONY: docker-build docker-compose-up docker-compose-down

define MESSAGE
Targets for $(MAKE):
  - docker-build        : build Docker image
  - docker-compose-up   : run Docker Compose
  - docker-compose-down : run Docker Compose

Variables:
  - DB_PATH  : directory for top-level of database storage (default: ${DB_PATH_DEFAULT})
endef

export MESSAGE
help:
	@echo "$$MESSAGE"

docker-build:
	docker buildx bake -f docker-bake.hcl

docker-compose%: export DB_PATH:=${DB_PATH}

docker-compose-up: docker-build
	docker compose up -d

docker-compose-down:
	docker compose down

docker-compose-logs:
	docker compose logs -f

docker-compose-exec-db-virtuoso:
	docker compose exec db-virtuoso bash

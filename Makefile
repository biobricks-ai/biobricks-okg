# Note: GNU Makefile
ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

DB_PATH_DEFAULT := /mnt/ssd/biobricks/virtuoso-database

DB_PATH := ${DB_PATH_DEFAULT}

.PHONY: docker-build docker-compose-up docker-compose-down


### Platform helper
MKDIR_P := mkdir -p
ECHO    := echo


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
	@$(ECHO) "$$MESSAGE"

docker-build:
	docker buildx bake -f docker-bake.hcl

docker-compose%: export DB_PATH:=${DB_PATH}

docker-compose-up: docker-build
	[ -n "${DB_PATH}" ] || ( echo "Must set DB_PATH" && exit 1 )
	[ -f "${DB_PATH}/database/virtuoso.ini" ] || $(ECHO) -n '' > "${ROOT_DIR}/db-virtuoso/initdb.d/11-load-datasets.output.sql"
	$(MKDIR_P) "${DB_PATH}/database"
	$(MKDIR_P) "${DB_PATH}/data"
	docker compose up -d

docker-compose-down:
	docker compose down

docker-compose-logs:
	docker compose logs -f

docker-compose-exec-db-virtuoso:
	docker compose exec db-virtuoso bash
# Note: GNU Makefile
#
# Requires (on Ubuntu):
#  - apt:docker-compose-v2
#  - apt:docker-buildx
ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

DB_PATH_DEFAULT := /mnt/ssd/biobricks/virtuoso-database

DB_PATH := ${DB_PATH_DEFAULT}

.PHONY: \
	docker-build                                   \
	docker-compose-up docker-compose-down          \
	docker-compose-logs                            \
	docker-compose-exec-db-virtuoso                \
	docker-compose-exec-db-virtuoso-load-rdf-data  \
	docker-compose-exec-db-virtuoso-isql-load-list #

### Platform helper
MKDIR_P := mkdir -p
ECHO    := echo


define MESSAGE
# Targets for $(MAKE):

## Build

  - docker-build        : build Docker image

## Docker Compose

### Service

  - docker-compose-up   : start Docker Compose (in background)
  - docker-compose-down : stop Docker Compose
  - docker-compose-logs : show logs of Docker Compose

### Exec

  - docker-compose-exec-db-virtuoso                 : start bash inside of `db-virtuoso`
  - docker-compose-exec-db-virtuoso-load-rdf-data   : load RDF data from `/data` mount
  - docker-compose-exec-db-virtuoso-isql-load-list  : show the current load list (status of loading)

# Variables

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

docker-compose-exec-db-virtuoso-load-rdf-data:
	docker compose exec db-virtuoso bash -c '/script/load-rdf-dir /data > /tmp/load-rdf-dir.sql; isql "exec=LOAD /tmp/load-rdf-dir.sql"'

docker-compose-exec-db-virtuoso-isql-load-list:
	docker compose exec db-virtuoso isql 'exec=SELECT * FROM DB.DBA.load_list;'

# - `tpage` requires <pkg:cpan/Template-Toolkit>
#     $ cpanm Template::Toolkit
# - `sponge` requires <pkg:deb/debian/moreutils>
fuseki_config.ttl: fuseki_config.ttl.tt2
	tpage $< | perl -lpe 's/\s+$$//' | sponge $@

fuseki-start: fuseki_config.ttl
	./run-fuseki.sh --port 8080 --config=fuseki_config.ttl

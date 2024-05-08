# Note: GNU Makefile
ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

### Platform helper
MKDIR_P := mkdir -p
ECHO    := echo

.PHONY: help

define MESSAGE
Targets for $(MAKE):

endef

# Default target
export MESSAGE
help:
	@$(ECHO) "$$MESSAGE"


ifneq (,$(wildcard ./.env))
    include .env
    export
endif

.PHONY: _env-guard _bin-guard

env-guard-%: _env-guard
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

bin-guard-%: _bin-guard
	@ if ! which "${*}" >/dev/null; then \
		echo "Executable $* not found"; \
		exit 1; \
	fi


include Makefile.docker
include Makefile.model
include db-fuseki/Makefile
include Makefile.deploy

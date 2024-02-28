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


include Makefile.docker
include Makefile.model
include db-fuseki/Makefile

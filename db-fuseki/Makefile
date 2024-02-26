.PHONY: \
	db-fuseki-up      \
	db-fuseki-down    \
	db-fuseki-start   \
	db-fuseki-install

define DB_FUSEKI_MESSAGE

# Jena Fuseki server

## Configure

  - db-fuseki/fuseki_config.ttl : build configuration

## Service

  - db-fuseki-up      : start Jena Fuseki (in background)
  - db-fuseki-down    : stop Jena Fuseki that was started with db-fuseki-up

  - db-fuseki-start   : start Jena Fuseki (in foreground)

endef

MESSAGE += $(DB_FUSEKI_MESSAGE)

# - `tpage` requires <pkg:cpan/Template-Toolkit>
#     $ cpanm Template::Toolkit
# - `sponge` requires <pkg:deb/debian/moreutils>
db-fuseki/fuseki_config.ttl: db-fuseki/fuseki_config.ttl.tt2
	tpage $< | perl -lpe 's/\s+$$//' | sponge $@

export FUSEKI_BASE := ./_jena-fuseki-run

DB_FUSEKI_HTTP_PORT ?= 8080

# - `java` requires JDK
# - requires Alien::* listed in db-fuseki/cpanfile
db-fuseki-start: db-fuseki/fuseki_config.ttl db-fuseki/run-fuseki.sh
	$(MKDIR_P) $(FUSEKI_BASE)                                  \
	&& ./db-fuseki/run-fuseki.sh --port $(DB_FUSEKI_HTTP_PORT) \
		--config=db-fuseki/fuseki_config.ttl

db-fuseki-up: db-fuseki/fuseki_config.ttl db-fuseki/run-fuseki.sh
	[ -f $(FUSEKI_BASE)/jena.pid ]                                                \
		|| (                                                                  \
			$(MKDIR_P) $(FUSEKI_BASE)                                     \
			&& ( ./db-fuseki/run-fuseki.sh --port $(DB_FUSEKI_HTTP_PORT)  \
					--config=db-fuseki/fuseki_config.ttl          \
				>  "$(FUSEKI_BASE)/log.out"                           \
				2> "$(FUSEKI_BASE)/log.err"                           \
				&  echo "$$!" > "$(FUSEKI_BASE)/jena.pid" ) )         \
		&& sleep 5 && head "$(FUSEKI_BASE)/log.out" "$(FUSEKI_BASE)/log.err"

db-fuseki-down:
	[ -f "$(FUSEKI_BASE)/jena.pid" ]                          \
		&& echo "Killing `cat "$(FUSEKI_BASE)/jena.pid"`" \
		&& ps -lf -p `cat "$(FUSEKI_BASE)/jena.pid"`      \
		&& kill `cat "$(FUSEKI_BASE)/jena.pid"`           \
		&& rm "$(FUSEKI_BASE)/jena.pid"

db-fuseki-install: db-fuseki/cpanfile
	cpanm --installdeps ./db-fuseki/

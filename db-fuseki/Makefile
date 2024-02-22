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

# - `java` requires JDK
# - requires Alien::* listed in db-fuseki/cpanfile
db-fuseki-start: db-fuseki/fuseki_config.ttl db-fuseki/run-fuseki.sh
	./db-fuseki/run-fuseki.sh --port 8080 --config=db-fuseki/fuseki_config.ttl

db-fuseki-up: db-fuseki/fuseki_config.ttl db-fuseki/run-fuseki.sh
	[ -f "./_jena-fuseki-run/jena.pid" ]                                                    \
		|| ( ./db-fuseki/run-fuseki.sh --port 8080 --config=db-fuseki/fuseki_config.ttl \
			>  "./_jena-fuseki-run/log.out"                                         \
			2> "./_jena-fuseki-run/log.err"                                         \
			&  echo "$$!" > "./_jena-fuseki-run/jena.pid" )

db-fuseki-down:
	[ -f "./_jena-fuseki-run/jena.pid" ]                          \
		&& echo "Killing `cat "./_jena-fuseki-run/jena.pid"`" \
		&& ps -lf -p `cat "./_jena-fuseki-run/jena.pid"`      \
		&& kill `cat "./_jena-fuseki-run/jena.pid"`           \
		&& rm "./_jena-fuseki-run/jena.pid"

db-fuseki-install: db-fuseki/cpanfile
	cpanm --installdeps ./db-fuseki/

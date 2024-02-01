.PHONY: \
	fuseki-start \
	db-fuseki-install

define DB_FUSEKI_MESSAGE

# Jena Fuseki server

## Configure

  - db-fuseki/fuseki_config.ttl : build configuration

## Service

  - fuseki-start   : start Jena Fuseki (in foreground)

endef

MESSAGE += $(DB_FUSEKI_MESSAGE)

# - `tpage` requires <pkg:cpan/Template-Toolkit>
#     $ cpanm Template::Toolkit
# - `sponge` requires <pkg:deb/debian/moreutils>
db-fuseki/fuseki_config.ttl: db-fuseki/fuseki_config.ttl.tt2
	tpage $< | perl -lpe 's/\s+$$//' | sponge $@

# - `java` requires JDK
# - requires Alien::* listed in db-fuseki/cpanfile
fuseki-start: db-fuseki/fuseki_config.ttl db-fuseki/run-fuseki.sh
	./db-fuseki/run-fuseki.sh --port 8080 --config=db-fuseki/fuseki_config.ttl

db-fuseki-install: db-fuseki/cpanfile
	cpanm --installdeps ./db-fuseki/

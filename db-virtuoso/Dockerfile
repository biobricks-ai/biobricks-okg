# Deps from
#   - hdt-cpp/Dockerfile
#   - db-virtuoso/script/
ARG APT_PKGS_RUN=" \
libserd-0-0 zlib1g \
perl-modules       \
"
ARG APT_PKGS_TEST=" \
perl                \
libtest2-suite-perl \
"

FROM virtuoso-base AS db
ARG APT_PKGS_RUN

RUN apt-get update && apt-get install -y --no-install-recommends \
	$APT_PKGS_RUN

COPY --from=hdt-cpp /app /hdt-cpp
ENV LD_LIBRARY_PATH /hdt-cpp/lib:$LD_LIBRARY_PATH
ENV PATH /hdt-cpp/bin:$PATH

FROM db as tester
ARG APT_PKGS_TEST

RUN apt-get update && apt-get install -y --no-install-recommends \
	$APT_PKGS_TEST

COPY db-virtuoso/script /script

ARG CACHE_BUST
RUN perl -c /script/load-rdf-dir
RUN prove -v  /script/load-rdf-dir

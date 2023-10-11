# From hdt-cpp/Dockerfile
ARG APT_PKGS_RUN=" \
libserd-0-0 zlib1g \
"

FROM virtuoso-base AS db
ARG APT_PKGS_RUN

RUN apt-get update && apt-get install -y --no-install-recommends \
	$APT_PKGS_RUN

COPY --from=hdt-cpp /app /hdt-cpp
ENV LD_LIBRARY_PATH /hdt-cpp/lib:$LD_LIBRARY_PATH
ENV PATH /hdt-cpp/bin:$PATH

FROM db as tester

ARG CACHE_BUST
RUN true

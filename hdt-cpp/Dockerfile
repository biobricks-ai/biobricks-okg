ARG APT_PKGS_DEV="build-essential autoconf automake libtool pkg-config zlib1g-dev libserd-dev curl ca-certificates"
ARG APT_PKGS_RUN="libserd-0-0 zlib1g"

FROM builder-base AS builder

ARG APT_PKGS_DEV
ARG APT_PKGS_RUN

ARG HDT_CPP_TARBALL_URL="https://github.com/rdfhdt/hdt-cpp/archive/d9ae092bb37d9fe85558dfb3edfe0bb6ddddf41a.tar.gz"
ARG PATCH_SUM_URL="293915a8e4ce57c75cf5a9e39c77c9bdfe5d8c1c15b18bcab9122b1e37251534 https://github.com/rdfhdt/hdt-cpp/pull/273.patch?full_index=1"

RUN apt-get update && apt-get install -y --no-install-recommends \
	$APT_PKGS_DEV $APT_PKGS_RUN

WORKDIR /build

RUN curl -L $HDT_CPP_TARBALL_URL              \
	| tar -xvzC /build                    \
	&&                                    \
	( cd /build/hdt-cpp-*                 \
	  && bash -c '( \
		PATCH_SUM=$(echo $PATCH_SUM_URL | cut -d" " -f1 );    \
		PATCH_URL=$(echo $PATCH_SUM_URL | cut -d" " -f2 );    \
		PATCH_PATH=$(basename $PATCH_URL "?full_index=1" );   \
		curl -L $PATCH_URL                                    \
			| tee $PATCH_PATH                             \
			| sha256sum -c <( echo "$PATCH_SUM -" )       \
		&& patch -p1 < $PATCH_PATH )'                         \
	  && ./autogen.sh                     \
	  && ./configure --prefix=/app        \
	  && make -j$(nproc)                  \
	  && make install )

FROM runtime-base AS runtime

ARG APT_PKGS_RUN

RUN apt-get update && apt-get install -y --no-install-recommends \
		$APT_PKGS_RUN \
	&& apt-get -qq purge \
	&& apt-get -qq clean \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=builder /app /app

WORKDIR /work

ENV PATH /app/bin:$PATH

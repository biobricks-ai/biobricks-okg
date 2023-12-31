#!/bin/sh
#
# Requires:
#   coreutils: ln realpath cat

set -eu

CURDIR=`dirname "$0"`
cd $CURDIR

eval $( ../../vendor/biobricks-script-lib/activate.sh )

BRICK_NAME="ice"
if [ ! -r 'brick-data' ]; then
	biobricks install "$BRICK_NAME"
	ln -vsT "`biobrick-path "$BRICK_NAME"`" brick-data;
else
	cat <<EOF >&2
brick-data for $BRICK_NAME already exists at `realpath -s brick-data`
EOF
fi

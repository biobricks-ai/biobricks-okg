#!/bin/sh
#
# Requires:
#   Java
#   Jena: set $JENA_HOME


CURDIR=`dirname "$0"`
cd $CURDIR

if [ -z "$JENA_HOME" ]; then
	cat <<EOF >&2
Need to set \$JENA_HOME to path to Jena package.
EOF
	exit 1
fi

set -eu

$JENA_HOME/bin/riot --sink --check knowledge-graph.nt

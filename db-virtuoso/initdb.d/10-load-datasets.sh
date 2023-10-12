#!/bin/sh

set -eu

CURDIR=`dirname "$0"`

/script/load-rdf-dir /data > "$CURDIR"/11-load-datasets.output.sql

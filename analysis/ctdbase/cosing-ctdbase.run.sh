#!/bin/sh

set -eu

CURDIR=`dirname "$0"`

$JENA_HOME/bin/arq \
	--data $CURDIR/../../r2rml/pipeline-ctdbase/knowledge-graph.nt \
	--data $CURDIR/data/cosing.nt \
	\
	--query $CURDIR/cosing-ctdbase.rq \
	--results tsv



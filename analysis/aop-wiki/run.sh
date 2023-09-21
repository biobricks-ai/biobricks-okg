#!/bin/sh

set -eu

CURDIR=`dirname "$0"`

	#--data ../AOPWikiRDF/data/AOPWikiRDF-Genes.ttl \

$JENA_HOME/bin/arq \
	--data $CURDIR/data/AOPWikiRDF.ttl \
	--data $CURDIR/data/cosing.nt \
	\
	--query $CURDIR//search-by-cas.rq \
	--results tsv



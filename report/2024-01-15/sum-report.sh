#!/bin/sh

set -eu

CURDIR=`dirname "$0"`
#CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # works in sourced files, only works for bash

BY="void#triples"

echo dataset,triples
echo hgnc,$(./bin/sum-hdtInfo-by data-source/internal-hgnc-kg/ $BY)
echo tox21,$(./bin/sum-hdtInfo-by data-source/internal-tox21-kg/ $BY)
echo uniprot-kg,$(./bin/sum-hdtInfo-by data-source/uniprot-kg/ $BY)
echo mesh-kg,$(./bin/sum-hdtInfo-by data-source/mesh-kg/ $BY)
echo ice,$(./bin/sum-hdtInfo-by brick/ice.hdt $BY)
echo toxcast,$(./bin/sum-hdtInfo-by brick/toxcast.hdt $BY)

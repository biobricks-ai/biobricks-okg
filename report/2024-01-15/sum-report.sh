#!/bin/sh

set -eu

CURDIR=`dirname "$0"`
#CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # works in sourced files, only works for bash

BY="void#triples"

echo dataset,triples
echo hgnc,$(./bin/rdf-hdt-info-sum-by data-source/internal-hgnc-kg/ $BY)
echo tox21,$(./bin/rdf-hdt-info-sum-by data-source/internal-tox21-kg/ $BY)
echo uniprot-kg,$(./bin/rdf-hdt-info-sum-by data-source/uniprot-kg/ $BY)
echo mesh-kg,$(./bin/rdf-hdt-info-sum-by data-source/mesh-kg/ $BY)
echo ice,$(./bin/rdf-hdt-info-sum-by brick/ice.hdt $BY)
echo toxcast,$(./bin/rdf-hdt-info-sum-by brick/toxcast.hdt $BY)

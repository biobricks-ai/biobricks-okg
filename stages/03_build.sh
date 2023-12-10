#!/usr/bin/env bash

# Script to turn N-Triples into RDF HDT file

# Get local path
localpath=$(pwd)
echo "Local path: $localpath"

# Get raw path
rawpath="$localpath/raw"
echo "Raw path: $rawpath"

# Create brick directory
brickpath="$localpath/brick"
mkdir -p $brickpath
echo "Brick path: $brickpath"

for NAME in $(cd stages && ls *.graph | sed 's/\.graph$//' ); do
base_uri="$(cat stages/$NAME.graph)"
rdf2hdt -i -p -B "$base_uri" $rawpath/$NAME.nt brick/$NAME.hdt
done

#!/usr/bin/env bash

set -e

# Script to create N-Triples graph using RML

# Get local path
localpath=$(pwd)
echo "Local path: $localpath"

eval $( $localpath/vendor/biobricks-script-lib/activate.sh )

# Create raw directory
rawpath="$localpath/raw"
mkdir -p $rawpath
echo "Raw path: $rawpath"

# Process RML mapping
for NAME in $(cd stages && ls *.graph | sed 's/\.graph$//' ); do

cat <<EOF > stages/$NAME.gen.ini
# Configuration for Morph-KGC
[CONFIGURATION]
output_file: ./raw/$NAME.nt
logging_level: DEBUG

[DataSource1]
mappings: ./stages/$NAME.rml.ttl
EOF

python3 -m morph_kgc stages/$NAME.gen.ini

# Sort in-place for reproducible hash
sort-file-inplace $rawpath/$NAME.nt

done

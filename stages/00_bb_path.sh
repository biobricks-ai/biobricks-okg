#!/usr/bin/env bash

# Script to prepare data

# Get local [ath]
localpath=$(pwd)
echo "Local path: $localpath"

eval $( $localpath/vendor/biobricks-script-lib/activate.sh )

# Create the list directory to save list of remote files and directories
datapath="$localpath/data-source"
echo "Data path: $datapath"
mkdir -p $datapath

biobrick-setup-source --output-dir $datapath --pull-all-deps

### Temporary set up for tox21 and hgnc
for d in tox21 hgnc; do
	( cd $( realpath $datapath/$d/.. ) && dvc pull rml );
	ln -sfT $( realpath $datapath/$d/.. )/rdf $datapath/internal-$d-kg
done

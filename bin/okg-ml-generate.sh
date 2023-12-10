#!/bin/sh

okg.pl yaml process --file okg-ml.yaml  | $JENA_HOME/bin/riot --syntax=Turtle --formatted=Turtle > stages/okg-ml.rml.ttl

for DATASET in $(json_xs -f yaml < okg-ml.yaml | jq '.datasets | to_entries | map( .key ) | .[]' -r);
do
	export DATASET;
	export YAML_DATASET_ONLY="$DATASET.gen.yml"
	echo "$DATASET"
	json_xs -f yaml < okg-ml.yaml | jq '.datasets |= with_entries( select(.key | test($ENV.DATASET)) )' | json_xs -t yaml > $YAML_DATASET_ONLY
	okg.pl yaml process --file $YAML_DATASET_ONLY  | $JENA_HOME/bin/riot --syntax=Turtle --formatted=Turtle > stages/$DATASET.rml.ttl
	rm $YAML_DATASET_ONLY
done


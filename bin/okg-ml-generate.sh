#!/bin/sh

BB_OKG_HOME=vendor/biobricks-okg-tool
$BB_OKG_HOME/bin/okg.pl yaml process --file okg-ml.yaml  | $JENA_HOME/bin/riot --syntax=Turtle --formatted=Turtle > stages/okg-ml.rml.ttl

for DATASET in $(cpanel_json_xs -f yaml < okg-ml.yaml | jq '.datasets | to_entries | map( .key ) | .[]' -r);
do
	export DATASET;
	export YAML_DATASET_ONLY="$DATASET.gen.yml"
	echo "$DATASET"
	cpanel_json_xs -f yaml < okg-ml.yaml | jq '.datasets |= with_entries( select(.key | test($ENV.DATASET)) )' | cpanel_json_xs -t yaml > $YAML_DATASET_ONLY
	$BB_OKG_HOME/bin/okg.pl yaml process --file $YAML_DATASET_ONLY  | $JENA_HOME/bin/riot --syntax=Turtle --formatted=Turtle > stages/$DATASET.rml.ttl
	rm $YAML_DATASET_ONLY
done


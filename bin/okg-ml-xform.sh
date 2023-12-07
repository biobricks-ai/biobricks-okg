#!/bin/sh

set -eu

CURDIR=`dirname "$0"`
#CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # works in sourced files, only works for bash

export DATASET='ice';

json_xs -f yaml < okg-ml.yaml  | jq '[ .datasets[$ENV.DATASET].inputs | to_entries| .[] | {
	(.key): 
		[
			.value.elements| .[] | to_entries | .[] |
				{ (.key) :
					(
						.value.mapper | to_entries | .[0].value |
							if has("class")
							then .class
							else
								if has("value")
								then .value
								else null
								end
							end
					)
				}
		]
} ] ' \
	| jq -r '["file", "element", "map_cv"], ( .[] | to_entries | .[]
		| (.value | .[] | to_entries | .[]) as $element
		|
			{
				file: .key,
				element: $element.key,
			}
		| . + { map_cv : $element.value }
		| to_entries | map(.value)
		) | @csv' \
	| vd -f csv

 #| json_xs -t yaml

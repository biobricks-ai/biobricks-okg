#!/bin/sh

set -eu

CURDIR=`dirname "$0"`
#CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # works in sourced files, only works for bash

DATASET='ice';

json_xs -f yaml < okg-ml.yaml  | jq '.datasets.'"$DATASET"'.inputs."data-source/ice/DART_Data.parquet".elements|.[] | to_entries | .[] | { (.key) : .value.mapper } ' -c | grep -v '{}'

#!/bin/sh

set -eu

export PARALLEL_QUERY="$(cat <<'EOF'
EOF
)"

duckdb -csv -c "$(cat <<'EOF'
SELECT DISTINCT file_name, name
FROM parquet_schema('data-source/ice/*.parquet')
WHERE
name LIKE '%Endpoint%'
AND
file_name NOT LIKE '%MOA%'
AND
file_name NOT LIKE '%cHTS%'
AND
file_name NOT LIKE '%Tox21MT%'
AND
file_name NOT LIKE '%Chemical_Functional_Use_Categories_Data%'
EOF
)" \
	| awk 'NR>1' \
	| parallel --colsep ',' '
duckdb -csv -c "$(cat <<EOF
SELECT DISTINCT '\''{1}'\'',  '\"'{2}'\"' FROM "{1}";
EOF
)" | awk "NR>1"
'

#!/bin/sh

set -eu

INPUT="$1"
BASE="$2"
( \
	grep @prefix "$INPUT"; \
	ruby \
		-e "$(cat <<'EOF'
require 'rdf/normalize'
require 'rdf/turtle'
g = RDF::Graph.load(ARGV[0])
g_canon = g.canonicalize # graph with URIs, literals, and blank nodes canonicalized.
puts g_canon.dump(:nquads) # Normalized, but not sorted
EOF
)" \
		"$INPUT" | sort ) \
	| rapper -i turtle -I "$BASE" -o turtle - \
	| sponge "$INPUT"

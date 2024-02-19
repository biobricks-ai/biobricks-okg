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
	| sordi -i turtle -o turtle - "$BASE" \
	| perl -0777 -e '
		my $ttl = <>;
		my @head_bnodes = $ttl =~ /^(_:\S+)$/msg;
		$bnode_counter{$_} += $ttl =~ /(^|\b)@{[ quotemeta($_) ]}(\b|$)/msg for @head_bnodes;
		while(my ($bnode, $count) = each %bnode_counter) {
			unless($count == 1) {
				warn "$bnode is not a singleton";
				next;
			}
			$ttl =~ s/^@{[ quotemeta($bnode) ]}$/[]/mg;
		}

		print $ttl;
	' \
	| sponge "$INPUT"

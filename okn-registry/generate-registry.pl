#!/usr/bin/env perl
use v5.36;
use Template::Toolkit::Simple;
use YAML::PP;
use Path::Tiny;
use Getopt::Long;

my $config_file = 'kg-registry-config.yaml';
my $okn_registry_root = undef;
my @include_dirs = ();

GetOptions(
	'config=s' => \$config_file,
	'okn-registry=s' => \$okn_registry_root,
	'include=s@' => \@include_dirs,
) or die "Usage: $0 [--config=FILE] [--okn-registry=PATH] [--include=DIR]\n";

# Default include directories
push @include_dirs, path($okn_registry_root)->child(qw( docs registry kgs ))->stringify if !@include_dirs;

my $yaml = YAML::PP->new;
my $config = $yaml->load_file($config_file);

sub load_inherit_data ($inherit_file, $include_dirs) {
	my $parent_data;

	# Search for the inherit file in include directories
	for my $dir (@$include_dirs) {
		my $file_path = path($dir)->child($inherit_file);
		if ($file_path->exists) {
			my $content = $file_path->slurp_utf8;

			if ($inherit_file =~ /\.md$/ && $content =~ /^---\n(.*?)\n---/s) {
				# Parse YAML front matter from markdown files
				$parent_data = $yaml->load_string($1);
			} elsif ($inherit_file =~ /\.ya?ml$/) {
				# Parse regular YAML files
				$parent_data = $yaml->load_file($file_path);
			}
			last if $parent_data;
		}
	}

	return $parent_data || {};
}

my $template = <<~'EOF';
[% USE wrap -%]
---
template: overrides/kg.html
shortname: [% shortname %]
title: [% title %]
description: >
[% description | wrap(78, '  ', '  ') -%]
stats: https://frink.renci.org/kg-stats/[% shortname %]-kg
homepage: [% homepage %]
funding: [% funding %]
sparql: https://frink.apps.renci.org/[% shortname %]/sparql
tpf: https://frink.apps.renci.org/ldf/[% shortname %]
frink-options:
  lakefs-repo: [% shortname %]-kg
  documentation-path: [% shortname %]-kg
contact:
  email: [% contact.email %]
  github: "[% contact.github %]"
  label: "[% contact.label %]"
---
[% description | wrap(80) -%]
EOF

sub main {
	my $tt = Template::Toolkit::Simple->new();

	for my $shortname (keys %{$config->{graph}}) {
		my $graph = $config->{graph}{$shortname};

		# Load inherited data if specified
		my $inherited = {};
		if ($graph->{'@inherit'}) {
			$inherited = load_inherit_data($graph->{'@inherit'}, \@include_dirs);
			delete $graph->{'@inherit'};
		}

		# Merge inherited, common, and graph-specific fields
		my $data = {
			%$inherited,
			%{$config->{common} || {}},
			%$graph,
			shortname => $shortname,
		};

		my $output = $tt->render(\$template, $data);

		my $filename = path($okn_registry_root)->child(qw( docs registry kgs ), "$shortname.md");
		say "Generating: $filename";

		$filename->spew_utf8($output);
	}

	say "\nGenerated " . scalar(keys %{$config->{graph}}) . " registry documents.";
}

main;

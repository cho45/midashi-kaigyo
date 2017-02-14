#!/usr/bin/env perl

use strict;

use Text::MeCab;
use DBI;

my $mecab = Text::MeCab->new({
	dicdir => $ENV{'HOME'} . '/Downloads/mecab-ipadic-neologd-bin/'
});

sub segments {
	my ($text) = @_;
	my $segments = [];
	for (my $node = $mecab->parse($text); $node; $node = $node->next) {
		my $feature = [ split/,/, $node->feature ];

		my $surface = $node->surface;

		if ($feature->[1] eq '括弧開' ||
			$feature->[1] eq 'サ変接続' ||
			$feature->[1] eq '数' ||
			$node->surface =~ m{[(\[]}) {

			$node = $node->next;
			$surface .= $node->surface;
		}


		if (
			$feature->[0] eq '助詞' ||
			$feature->[0] eq '助動詞' ||
			$feature->[0] eq '記号' ||
			$feature->[1] eq '接尾' ||
			$feature->[1] eq '非自立' ||
			$node->surface =~ m{[-?)\]]} 
		) {
			if ($segments->[-1]) {
				$segments->[-1] .= $surface;
			} else {
				push @$segments, $surface;
			}
		} else {
			push @$segments, $surface;
		}
	}
	return $segments;
}



my $dbh = DBI->connect('dbi:SQLite:dbname=' . $ENV{HOME} . '/Downloads/2017-02-13_srv_www_lowreal.net_Nogag_db_data.db', "", "", {
	sqlite_allow_multiple_statements => 1,
	RaiseError => 1,
	sqlite_see_if_its_a_number => 1,
	sqlite_unicode => 1,
});

my $entries = $dbh->selectall_arrayref(q{
	SELECT * FROM entries ORDER BY created_at DESC
}, { Slice => {} });

my $mecab = Text::MeCab->new;
for my $entry (@$entries) {
	my $title = $entry->{title};
	my $html = $entry->{formatted_body};
	$title =~ s{\[[^]]+\]}{}g;
	$html =~ s{<script[\s\S]+?</script>}{}g;
	$html =~ s{<style[\s\S]+?</style>}{}g;
	$html =~ s{<pre[\s\S]+?</pre>}{}g;
	$html =~ s{<[^>]+?>}{}g;
	$html =~ s{^\s+|\s+$}{};

	my $segments = segments($title . ' ' . $html);
	print join(' ', @$segments, "\n");
}


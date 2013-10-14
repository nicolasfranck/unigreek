#!/usr/bin/env perl
use strict;
use utf8;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib";
use UniGreek;
use Unicode::Normalize;

binmode STDIN,":utf8";
binmode STDOUT,":utf8";
binmode STDERR,":utf8";

my %good_mapping = (
  NFC("Μῆνιν ἄειδε θεά") => "Mh=nin a)/eide qea/",
  NFC("Πηληϊάδεω Ἀχιλῆος") => "Phlhi+a/dew A)xilh=oj"
);
plan tests => scalar(keys %good_mapping);
for my $utf8(sort keys %good_mapping){
  my $got = UniGreek::to_unigreek($utf8);
  my $expected = $good_mapping{$utf8};
  is($got,$expected,"comparing '$got' <=> '$expected'");
}

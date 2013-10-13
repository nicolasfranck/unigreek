#!/usr/bin/env perl
use strict;
use utf8;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Greek::Transliterate;
use Unicode::Normalize;

binmode STDIN,":utf8";
binmode STDOUT,":utf8";

my %good_mapping = (
  "Mh=nin a)/eide qea/" => NFC("Μῆνιν ἄειδε θεά"),
  "Phlhi+a/dew A)xilh=os" => NFC("Πηληϊάδεω Ἀχιλῆος")
);
plan tests => scalar(keys %good_mapping);
for my $ascii(sort keys %good_mapping){
  my $got = Greek::Transliterate::from_transliteration($ascii);
  my $expected = $good_mapping{$ascii};
  is($got,$expected);
}

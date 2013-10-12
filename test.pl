#!/usr/bin/env perl
use strict;
use utf8;
use warnings;
use Greek;

binmode STDIN,":utf8";
binmode STDOUT,":utf8";

my $line;
while($line = <STDIN>){
  my $greek = Greek::map_str($line);
  print $greek;
}

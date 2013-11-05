#!/usr/bin/perl -w

use strict;
use lib '/home/ingmar/perl5';
use xmllite qw( xml2hash hash2xml );

use Data::Dumper;

my $hash = xml2hash(File => 'xmllite.xml');
print Dumper($hash) ."\n";
my $xml = hash2xml($hash);
print $xml;

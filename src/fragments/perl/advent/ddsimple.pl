#!/usr/bin/perl -w 

use lib '/opt/qpass/emtools/lib';

use strict;

my $one = { test1 => 'value1' };
my $two = ['test2', 'test2.1' ];
my $three = 'test3';
my %four = ( test4 => 'value4' );
my @five = qw( test5 test5.1 );

use Data::Dumper::Simple;
print Dumper($one, $two, $three, %four, @five);

# use Data::Dumper;
# print Dumper($one, $two, $three, %four, @five);
# print Data::Dumper->Dump([$one], ['one']);


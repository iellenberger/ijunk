#!/usr/bin/perl -w

use lib '/opt/local/lib/perl5/site_perl/5.8.9';
use Crypt::SmbHash qw( nthash lmhash );

use strict;
use warnings;

print nthash('foobar') ."\n";
print lmhash('foobar') ."\n";

#!/usr/bin/perl -w
use lib '.';

use Data::Dumper; $Data::Dumper::Indent=0; $Data::Dumper::Sortkeys=1; # for debugging
sub tdump { my $t = Dumper(@_); $t =~ s/^\$VAR\d+\s=\s//msg; $t }
use HashTie;

use strict;
use warnings;

# === Test Script ===========================================================
my $obj = new HashTie(seed => 1);
# my $obj = new HashTie({seed => 1});  # alternate constructor params
$obj->{'via {hashref}'} = 1;
$obj->private->{'via private()'} = 1;
$obj->public->{'via public()'} = 1;

print "\nExternal view:\n". indent(
	'obj           :       '.        tdump($obj) ."\n".
	'obj->public   :              '. tdump($obj->public) ."\n".
	'obj->private  : '.              tdump($obj->private) ."\n"
) ."\n";

print "Internal view:\n". indent($obj->barf) ."\n";

# --- convenience subs ---
sub indent {my $s=shift;$s=~s/^/   /mg;$s}


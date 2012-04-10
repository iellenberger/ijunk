#!/usr/bin/perl -w

use strict;
use warnings;


sub printme {
	my ($val, $desc) = @_;
	print "   $val\t". $val ."\t". ($val =~ /^[+-]/ ? '  signed' : 'unsigned') ." $desc\n";
}

print "Integers:\n";
printme  -1  , "negative one";
printme  -0  , "negative zero";
printme   0  , "         zero";
printme  +0  , "positive zero";
printme   1  , "         one";
printme  +1  , "positive one";

print "Strings:\n";
printme '-1' , "negative one";
printme '-0' , "negative zero";
printme  '0' , "         zero";
printme '+0' , "positive zero";
printme  '1' , "         one";
printme '+1' , "positive one";

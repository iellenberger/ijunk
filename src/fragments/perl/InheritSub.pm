package InheritSub;
use base 'InheritBase';

use strict;
use warnings;

sub printName {
	print "subclass ". join(' ', @_) ."\n";
}

1;

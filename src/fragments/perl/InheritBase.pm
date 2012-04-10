package InheritBase;
use base 'Exporter';

@EXPORT = qw( printMe );

use strict;
use warnings;

sub printMe {
	my $class = shift || __PACKAGE__;
	$class->printName($class, @_);
}

sub printName {
	print "base class ". join(' ', @_) ."\n";
}

1;

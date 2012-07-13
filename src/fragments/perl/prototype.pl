#!/usr/bin/perl -w

use Data::Dumper; $Data::Dumper::Indent=0; $Data::Dumper::Sortkeys=$Data::Dumper::Terse=1; # for debugging only

use strict;
use warnings;

# --- declare prototype (required if sub is after the main body of code) ---
sub shift2(\@);

# --- main body of code ---
my @array = qw( 1 2 3 4 5 6 7 8 9 );
print "array before : ". Dumper(\@array) ."\n";
my @return = shift2 @array;
print "array after  : ". Dumper(\@array) ."\n";
print "return array : ". Dumper(\@return) ."\n";

# --- shift 2 rather than 1 ---
sub shift2(\@) {
	my $args = shift;
	print "shift2 args  : ". Dumper($args) ."\n";
	return (shift @$args, shift @$args);
}

__END__

Not really sure what I was trying to demonstrate here

# foo('bar', { print "foo\n" }, 'test');

my $foo = new Foo;
$foo->foo(sub { print "hello\n"; bar() }, 'test');
sub bar { print "barring\n"; }

# === Package Foo ===========================================================
package Foo;

use Data::Dumper; $Data::Dumper::Indent=$Data::Dumper::Sortkeys=1; # for debugging only

sub new { bless {}, shift }
sub foo {
	print "one ". ref($_[1]) ."\n";
	print Dumper(@_);
	&{$_[1]}
}

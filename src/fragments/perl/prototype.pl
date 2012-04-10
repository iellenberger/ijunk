#!/usr/bin/perl -w

use Data::Dumper; $Data::Dumper::Indent = 1; # for debugging only

use strict;



# foo('bar', { print "foo\n" }, 'test');

my $foo = new Foo;
$foo->foo(sub { print "hello\n"; bar() }, 'test');

sub bar { print "barring\n"; }

package Foo;

use Data::Dumper; $Data::Dumper::Indent = 1; # for debugging only

sub new { bless {}, shift }

sub foo {
	print "one ". ref($_[1]) ."\n";
	print Dumper(@_);
	&{$_[1]}
}



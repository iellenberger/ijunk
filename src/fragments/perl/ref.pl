#!/usr/bin/env perl -w

use Term::ANSIColor;
use Data::Dumper; $Data::Dumper::Indent=0; $Data::Dumper::Terse=1;
use Scalar::Util qw( blessed reftype );

use strict;
use warnings;

print <<HEADING;

This sample shows the various mechanisms used to determine the type of
reference a given variable is

HEADING

my @tests = (
	[ undef       => undef ],
	[ "Scalar"    => 'value' ],
	[ "ScalarRef" => \q[value] ],
	[ "Arrayref"  => [ 'value' ] ],
	[ "HashRef"   => { key => 'value'} ],
	[ "Object"    => new myClass({ k => 'v'}) ],
);

foreach my $test (@tests) { test($test->[0], $test->[1]) }

exit;

# === Functions =============================================================

sub test {
	my ($message, $var) = @_;
	printf "%-25s : %s\n", $message, showval(Dumper($var));

	testline("Core", "qq", defined $var ? qq[$var] : undef);
	testline("",     "ref", ref $var);

	testline("Scalar::Util","reftype", reftype $var);
	testline("",            "blessed", blessed $var);

	my $function = "UNIVERSAL::isa";
	foreach my $type (qw( SCALAR HASH ARRAY myClass )) {
		testline($function, $type, UNIVERSAL::isa($var, $type));
		$function = '';
	}

	$function = "::_isa";
	foreach my $type (qw( SCALAR HASH ARRAY myClass )) {
		testline($function, $type, _isa($var, $type));
		$function = '';
	}

	print "\n";
}

sub testline {
	my ($type, $message, $val) = @_;
	printf "   %-14s %-7s : %s\n", $type, $message, showval($val);
}

sub showval {
	return colored('undef', 'yellow') unless defined $_[0];
	return colored('undef', 'yellow') if $_[0] eq 'undef';
	return colored('blank', 'dark')   if $_[0] eq '';
	return $_[0];
}

sub _isa {     
	my ($obj, $type) = @_;
		   
	return $obj->isa($type) if blessed $obj;
	return ref $obj eq $type;
}    

# === Inline Class for Object Tests =========================================
package myClass;

sub new { return bless $_[1], $_[0] }

1;

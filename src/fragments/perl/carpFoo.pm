package carpFoo;
use base Exporter;

@EXPORT_OK = qw( throw );

use Carp qw( carp cluck croak confess );
use Term::ANSIColor qw(:constants);

use strict;

sub new { return bless {}, ref $_[0] || $_[0] }

sub throw {
	my $function = 'throw';
	if (ref $_[0] eq 'carpFoo') {
		$function = "obj->$function";
		shift;
	}
	my $call = shift;

	# print "\n". BOLD . RED . ('=' x 77) .RESET ."\n";
	print BOLD . RED ."=== $call $function ===". RESET ."\n";

	carp   ("$call $function") if lc $call eq 'carp';
	cluck  ("$call $function") if lc $call eq 'cluck';
	croak  ("$call $function") if lc $call eq 'croak';
	confess("$call $function") if lc $call eq 'confess';

	print "\n";
}

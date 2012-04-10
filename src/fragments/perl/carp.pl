#!/usr/bin/perl -w
$VERSION=0.1;

use lib qw( . /opt/itools/lib );

use Carp qw( carp cluck croak confess );
use carpFoo qw( throw );
use Data::Dumper; $Data::Dumper::Indent = 1; # for debugging only
use Getopt::Long;
use Term::ANSIColor qw(:constants);

use strict;

# === Globals ===============================================================
my $options = {};

# === Main Body of Code =====================================================
# --- load up all the options ---
$options = configure();

my ($call, $function) = @{$options}{'call', 'function'};

if ($call || $function) {

	# $function = '$foo->throw' if $function eq 'objthrow';

	RUNFUNCTION: {
		'toss' eq $function && do {
			toss($call);
			showVars('eval', $?, $!, $^E, $@);
			last;
		};
		'lob' eq $function && do {
			lob($call);
			showVars('eval', $?, $!, $^E, $@);
			last;
		};
		'throw' eq $function && do {
			throw($call);
			showVars('eval', $?, $!, $^E, $@);
			last;
		};
		'objthrow' eq $function && do {
			my $foo = new carpFoo;
			$foo->throw($call);
			showVars('eval', $?, $!, $^E, $@);
			last;
		};
	};
	# eval "$function('$call')";
	showVars('eval', $?, $!, $^E, $@);

#	print "\n". BOLD . GREEN . ('e' x 77) .RESET ."\n";
#	print "\$?: $?\n" if $?;
#	print "\$!: $!\n" if $!;
#	print "\$^E: $^E\n" if $^E;
#	print "\$\@: $@\n" if $@;


	exit 0;
}

foreach my $function (qw( toss lob throw objthrow )) {
	foreach my $call (qw( carp cluck croak confess )) {
		system "perl $0 --function $function --call $call";
		showVars('system', $?, $!, $^E, $@);

#		print "\n". BOLD . GREEN . ('s' x 77) .RESET ."\n";
#		print "\$?: $?\n" if $?;
#		print "\$!: $!\n" if $!;
#		print "\$^E: $^E\n" if $^E;
#		print "\$\@: $@\n" if $@;
	}
}

exit 0;

# === Configuration =========================================================
sub configure {
	# --- parse the command line options ---
	$options = {};
	Getopt::Long::Configure ('bundling');
	GetOptions($options,
		# --- core parameters ---
		'help|?+', 'man+',    # usage and man pages
		'quiet|q+',           # do things quietly
		'verbose|v+',         # do things loudly

		'call=s', 'function=s',
	);

	# --- show usage or man page ---
	$options->{help} && do { usage() };
	$options->{man} && do { exec "perldoc $0" };

	# --- verbosity options ---
	$options->{quiet} ||= 0;
	$options->{verbose} ||= 0;
	usage("can't be quiet and verbose at the same time")
		if $options->{quiet} && $options->{verbose};

	# --- call both or neither ---
	usage("--call and --function must be called together")
		if    ( $options->{call} && !$options->{function})
		   || (!$options->{call} &&  $options->{function});

	return $options;
}

# === Functions =============================================================
sub toss {
	my ($call, $function) = (shift, shift || 'toss');

	# print "\n". BOLD . RED . ('=' x 77) .RESET ."\n";
	print BOLD . RED ."=== $call $function ===". RESET ."\n";

	carp   ("$call $function") if lc $call eq 'carp';
	cluck  ("$call $function") if lc $call eq 'cluck';
	croak  ("$call $function") if lc $call eq 'croak';
	confess("$call $function") if lc $call eq 'confess';

	print "\n";
}

sub lob { toss(shift, 'lob') }


sub showVars {
	my ($name, $child, $os, $osext, $eval) = @_;

	return unless ($child || $os || $osext || $eval);

	print BOLD . GREEN . "--- $name ---". RESET ."\n";
	print "\$?: $child\n" if $child;
	print "\$!: $os\n" if $os;
	print "\$^E: $osext\n" if $osext;
	print "\$\@: $eval\n" if $eval;
}

# === Usage and Error Message ===============================================
sub usage {
	my $error = shift;
	my $progname = ($0 =~ /([^\/]*)$/)[0] || $0;

	print STDERR qq[\nerror: $error\n] if $error;
	print STDERR qq[
usage: $progname [options] ARGS ...

   -?, --help     display this message
      --man          display the manual page for $progname
   -q, --quiet    do things quietly
   -v, --verbose  do things loudly

   --call CALL    carp, cluck, croak or confess
   --function FN  toss, lob, throw or objthrow

];
	exit 1;
}

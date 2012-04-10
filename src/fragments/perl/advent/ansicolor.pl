#!/usr/bin/perl -w 

use Term::ANSIColor; # color() and colored()
use Term::ANSIColor qw(:constants);

use strict;

my @options = qw(
	CLEAR BOLD DARK UNDERLINE UNDERSCORE
	BLINK REVERSE CONCEALED BLACK RED GREEN
	YELLOW BLUE MAGENTA CYAN WHITE ON_BLACK
	ON_RED ON_GREEN ON_YELLOW ON_BLUE ON_MAGENTA
	ON_CYAN ON_WHITE
);

# --- print header ---
print "constant   constant,  constant.  color()    colored()  autoreset\n";
print "---------- ---------- ---------- ---------- ---------- ----------\n";

foreach my $option (@options) {

	# --- calculate padding for option ---
	my $pad = ' ' x (11 - length($option));

	eval qq[ print $option '$option'; ]; print RESET, $pad;  # constants only
	eval qq[ print $option, '$option', RESET; ]; print $pad; # constants with commas
	eval qq[ print $option. '$option'. RESET; ]; print $pad; # constants with concatenation
	print color(lc($option)), $option, RESET; print $pad;    # color()
	print colored($option, lc($option)); print $pad;         # colored()
	$Term::ANSIColor::AUTORESET = 1;
	eval qq[ print $option '$option'; ]; print $pad;         # autoreset

	print "\n";
}

print "\n--- All Bold ----------------------------------------------------\n\n";
foreach my $option (@options) {

	# --- calculate padding for option ---
	my $pad = ' ' x (11 - length($option));

	print BOLD; eval qq[ print $option '$option'; ]; print RESET, $pad;  # constants only
	eval qq[ print BOLD, $option, '$option', RESET; ]; print $pad; # constants with commas
	eval qq[ print BOLD . $option. '$option'. RESET; ]; print $pad; # constants with concatenation
	print color(lc("BOLD $option")), $option, RESET; print $pad;    # color()
	print colored($option, lc("BOLD $option")); print $pad;         # colored()
	$Term::ANSIColor::AUTORESET = 1;
	eval qq[ print BOLD $option '$option'; ]; print $pad;         # autoreset

	print "\n";
}

print "\n--- All Dark ----------------------------------------------------\n\n";
foreach my $option (@options) {

	# --- calculate padding for option ---
	my $pad = ' ' x (11 - length($option));

	print DARK; eval qq[ print $option '$option'; ]; print RESET, $pad;  # constants only
	eval qq[ print DARK, $option, '$option', RESET; ]; print $pad; # constants with commas
	eval qq[ print DARK . $option. '$option'. RESET; ]; print $pad; # constants with concatenation
	print color(lc("DARK $option")), $option, RESET; print $pad;    # color()
	print colored($option, lc("DARK $option")); print $pad;         # colored()
	$Term::ANSIColor::AUTORESET = 1;
	eval qq[ print DARK $option '$option'; ]; print $pad;         # autoreset

	print "\n";
}

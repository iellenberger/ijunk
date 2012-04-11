#!/usr/bin/perl -w
$VERSION="0.4.8";

use Data::Dumper; $Data::Dumper::Indent=1; $Data::Dumper::Sortkeys=1; # for debugging only
use Getopt::Long;
use Term::ANSIColor qw(:constants);

use strict;
use warnings;

# === Globals ===============================================================
my $options = {
	# set defaults here
};

# === Main Body of Code =====================================================
# --- load up all the options ---
configure($options);

if ($options->{examples}) {
	runExamples();
} else {
	showOptions();
}

exit 0;

# === Configuration =========================================================
sub configure {
	usage() unless @ARGV; # force help message if no arguments

	# --- parse the command line options ---
	my $options = shift || {};
	Getopt::Long::Configure('bundling');
	GetOptions($options,
		# --- core parameters ---
		'help|?+', 'man+',  # usage and man pages
		'quiet|q+',         # do things quietly
		'verbose|v+',       # do things loudly
		'verbosity=n',      # set an explicit verbosity level
		'version+',         # show the version

		# --- run examples ---
		'examples|example|e+',

		# --- sample parameters ---
		'flag|f+',            # example of a flag
		'negatable!',         # example of a negatable
		'number|numeric|n=i', # numeric parameter
		'string|s=s',         # string parameter
	);

	# --- show usage, man page or version ---
	$options->{help}    && do { usage() };
	$options->{man}     && do { exec "perldoc $0" };
	$options->{version} && do { print "$::VERSION\n"; exit 0 };

# === old verbosity syntax ===
#	# --- verbosity options ---
#	$options->{quiet} ||= 0;
#	$options->{verbose} ||= 0;
#	usage("can't be quiet and verbose at the same time")
#		if $options->{quiet} && $options->{verbose};

	# --- verbosity ---
	usage("can't be quiet and verbose at the same time")
		if $options->{quiet} && $options->{verbose};
	$options->{verbosity} = ($options->{verbose} || 0) - ($options->{quiet} || 0);
	delete @{$options}{qw(quiet verbose)};

	return $options;
}

# === Functions =============================================================
sub runExamples {
	my @examples = (
		"Displaying manual page" => '--man',
		"Showing usage information via short option" => '-?',
		"Showing usage information via long option" => '--help',
		"Samples using short options" => '-ffff -n 1000 -s fooString barArg1 barArg2',
		"Samples using long options" => '--flag barArg3 --flag --number 500 barArg4 --string fooString barArg5',
	);

	print BOLD.YELLOW ."Running examples ...\n". RESET unless $options->{quiet};

	while (@examples) {
		my $description = shift @examples;
		my $flags = shift @examples;
		print BOLD.GREEN ."\n$description: ". RESET.GREEN ."$0 $flags\n". RESET;
		sleep 1;

		system "$0 $flags";
	}
}

sub showOptions {
	print "Displaying parameters recieved by $0\n\n" unless $options->{quiet};

	# --- process flags ---
	my $text = "   -?, --help    = ". (defined $options->{help}     ? $options->{help}     : 'undef');
	$text .= "\n   --man         = ". (defined $options->{man}      ? $options->{man}      : 'undef');
	$text .= "\n   -q, --quiet   = ". (defined $options->{quiet}    ? $options->{quiet}    : 'undef');
	$text .= "\n   -v, --verbose = ". (defined $options->{verbose}  ? $options->{verbose}  : 'undef');
	$text .= "\n   -e, --example = ". (defined $options->{examples} ? $options->{examples} : 'undef');
	$text .= "\n   -f, --flag    = ". (defined $options->{flag}     ? $options->{flag}     : 'undef');
	$text .= "\n   --negatable   = ". (defined $options->{negatable}? $options->{negatable}: 'undef');
	$text .= "\n   -n, --number  = ". (defined $options->{number}   ? $options->{number}   : 'undef');
	$text .= "\n   -s, --string  = ". (defined $options->{string}   ? $options->{string}   : 'undef');


	$text .= "\n\n   arguments:\n";
	foreach my $arg (@ARGV) {
		$text .= "      '$arg'\n";
	}

	print $text unless $options->{quiet};
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

   -e, --example  show examples

   -f, --flag            sample flag toggle parameter
   -n, --number NUMBER   sample numeric parameter
   -s, --string STRING   sample string parameter

Sample getopt, version $::VERSION

];
	exit 1;
}

=head1 NAME

getopt.pl - examples of usage for Getopt::Long

=head1 SYNOPSIS

 ./getopt.pl {-?|--man}
 ./getopt.pl [-qvv] [-e]
 ./getopt.pl [-fff] [-n NUMBER] [-s string] [ARG [...]]

=head1 DESCRIPTION

B<getopt.pl> is a code sample showing the usage of the L<Getopt::Long> module.
It also shows brief examples of L<Term::ANSIColor> and L<perlpod(1)>/L<perldoc(1)>.

=head1 OPTIONS

=over 4

=item B<-?>, B<--help>; B<--man>

Display a short usage message, or the full manual page (sic).

=item B<-q>, B<--quiet>; B<-v>[B<v>], B<--verbose>

Do things quietly or loudly.
There are two incremental levels of verbosity:

   -v     displays detailed progress
   -vv    displays system commands

=item B<-q>, B<--quiet>; B<-v>[B<vvv>], B<--verbose>, B<--verbosity> LEVEL

Do things quietly or loudly.
There are several incremental levels of verbosity (LEVEL in brackets) :

    -qq    (-2) suppress all messages
    -q     (-1) only show error messages
           (0)  normal output
    -v     (1)  show extended progress
    -vv    (2)  show detailed progress
    -vvv   (3)  show system and extended internal comands
    -vvvv  (4)  full debugging output

=item B<-e>, B<--example>, B<--examples>

Run a bunch of examples.

=item B<-f>, B<--flag>; B<-n>, B<--number>, B<--numeric> NUMBER; B<-s>, B<--string> STRING

These flags and parameters demonstrate the usage of B<--flag>s, B<--number>s and B<--string>s.

=back

=head1 KNOWN ISSUES AND BUGS

None.

=head1 AUTHOR

Written by Ingmar Ellenberger.

=head1 COPYRIGHT

Copyright (c) 2001-2012, Ingmar Ellenberger and distributed under The Artistic License.
For the text the license, see L<http://puma.sourceforge.net/license.psp>
or read the F<LICENSE> in the root of the Puma distribution.

=head1 SEE ALSO

perldoc(1),
perlpod(1),
Getopt::Long(3pm),
Term::ANSIColor(3pm)

=cut

__END__

Old stuff for reference:

Verbosity levels are as follows:

=begin man
   
.Vb 7
\&
\&   \fILevel\fR  \fIFlag\fR   \fIDescription\fR
\&    -2    -qq    suppress all messages
\&    -1    -q     only show error messages
\&     0           normal output
\&     1    -v     show extended progress
\&     2    -vv    show detailed progress
\&     3    -vvv   show system and ecternded internal comands
\&     4    -vvvv  full debugging output
.Ve

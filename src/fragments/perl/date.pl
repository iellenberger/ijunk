#!/usr/bin/perl -w
$VERSION="0.1.1";

use Data::Dumper; $Data::Dumper::Indent=1; $Data::Dumper::Sortkeys=1; # for debugging only
use Date::Format;
use Date::Parse;
#use POSIX 'strftime';

use strict;
use warnings;

# --- strftime/time2str output format ---
my $format = "%Y-%m-%d %H:%M:%S";

print "In the examples below, time2str() uses the format string '$format'\n\n";

# --- various examples ---
ptime("scalar localtime()", scalar localtime);
ptime("scalar gmtime()", scalar gmtime);
ptime('CLI: `date`', qx[ date ]);
ptime('CLI: `date -u`', qx[ date -u ]);
ptime('CLI: `date +"%Y-%m-%d %T %z"`', qx[ date +"%Y-%m-%d %T %z" ]);
ptime("string: '2012-01-01 10:10:10'", '2012-01-01 10:10:10');

# --- doesn't work ---
# ptime("time", time);

exit;

# --- take a date string and convert it to epoch seconds ---
sub ptime {
	my ($msg, $time) = @_;
	chomp $time;  # not neessary for Date::Parse - only for prettification

	print "$msg\n";
	print "   in        : $time\n";

	my $etime = str2time($time);
	print "   str2time  : $etime\n";
	print "   localtime : ". scalar localtime($etime) ."\n";
	print "   time2str  : ". time2str($format, $etime) ."\n";
	print "\n";
}

=head1 NAME

date.pl - examples of various date functions

=head1 SYNOPSIS

 ./date.pl

=head1 DESCRIPTION

B<date.pl> is a code fragment demonstrating the use of various date and time
conversion facilities available in Perl.

=head1 TODO

More exmaples using Date::Format(3pm) and POSIX's strftime

=head1 AUTHOR

Written by Ingmar Ellenberger.

=head1 COPYRIGHT

Copyright (c) 2001-2012, Ingmar Ellenberger and distributed under The Artistic License.
For the text the license, see L<http://puma.sourceforge.net/license.psp>
or read the F<LICENSE> in the root of the Puma distribution.

=head1 SEE ALSO

date(1),
perlfunc(3) localtime and gmtime,
Date::Parse(3pm)

=cut

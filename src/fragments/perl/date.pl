#!/usr/bin/perl -w


=options

use POSIX 'strftime';
use Date::Format;

=cut

use Data::Dumper; $Data::Dumper::Indent=1; $Data::Dumper::Sortkeys=1; # for debugging only
use Date::Parse;

use strict;
use warnings;


ptime("localtime", scalar localtime);
ptime("gmtime", scalar gmtime);
ptime('date', qx[ date ]);
ptime('date -u', qx[ date -u ]);
ptime('date +"%Y-%m-%d %T %z"', qx[ date +"%Y-%m-%d %T %z" ]);

# --- doesn't work ---
# ptime("time", time);


sub ptime {
	my ($msg, $time) = @_;
	chomp $time;  # note neessary for Dare::Parse - only for prettification

	print "$msg\n";
	print "   in        : $time\n";

	my $etime = str2time($time);
	print "   str2time  : $etime\n";
	print "   localtime : ". scalar localtime($etime) ."\n";
	print "\n";
}

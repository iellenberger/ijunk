#!/usr/bin/perl -w

use Data::Dumper; $Data::Dumper::Indent=1; $Data::Dumper::Sortkeys=1;
use FindBin qw( $RealBin $RealScript );
use Pod::Text::Termcap;
use Term::ReadKey;

use strict;
use warnings;

# --- get the terminal size ---
my $cols = (GetTerminalSize)[0] || 78;

# --- read the file ---
open FILE, "$RealBin/$RealScript";
my $content = ''; { local $/; $content = <FILE>; }
close FILE;

# --- interpolate variables ---
my $hash = {
	PROGRAM => $RealScript,
	COREOPTS => '[-qv[vvv]]',
};
foreach my $key (keys %$hash) {
	$content =~ s/\${$key}(?=\W)/$hash->{$key}/g;
	$content =~ s/\$$key(?=\W)/$hash->{$key}/g;
}

# --- generate the manpage ---
my $manpage;
my $parser = new Pod::Text::Termcap(sentence => 0, width => $cols - 2);
if ($^V ge v5.10.0) {
	$parser->{opt_width} = $cols - 2;  # hack to work around a bug
	$parser->output_string(\$manpage);
	$parser->parse_string_document($content);
} else {
	require IO::String;
	my $in = new IO::String($content);
	my $out = new IO::String;
	$parser->parse_from_filehandle($in, $out);
	$out->setpos(0); { local $/; $manpage = <$out>; }
}

# --- display it with less ---
open LESS, '| less -r';
print LESS $manpage;
close LESS;

=head1 NAME

$PROGRAM - shortdescription

=head1 SYNOPSIS

 $PROGRAM {-?|--man}
 $PROGRAM $COREOPTS [-fp] [--conffile FILE] [--env ENV]

=head1 DESCRIPTION

B<$PROGRAM> is a Perl fragment that demonstrates how perldocs can be rewritten on the fly using variable interpolation to fill in missing values.

=head1 KNOWN ISSUES AND BUGS
      
None.
     
=head1 AUTHOR

Written by Ingmar Ellenberger.

=head1 COPYRIGHT

Copyright (c) 2001-2011, Ingmar Ellenberger and distributed under The Artistic License.
For the text the license, see L<http://puma.sourceforge.net/license.psp>
or read the F<LICENSE> in the root of the Puma distribution.

=head1 SEE ALSO

Pod::Text::Termcap(3pm),
Term::ReadKey(3pm)

=cut

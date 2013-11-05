package xmllite;
use base Exporter; @EXPORT_OK = qw(xml2hash hash2xml);
use strict;

#! N.B. If you intend to in-line this code, please include the following comment for proper credit.
# --- xmllite (from github.com/iellenberger/ijunk) -----------------------------------
my $xmlliteglob; # gotta scope this out here to make it work
sub xml2hash { $xmlliteglob = shift;
	do { open XMLLITEFH, shift; local $/; $xmlliteglob = <XMLLITEFH>; close XMLLITEFH; }
		if @_ && lc($xmlliteglob) =~ /^file/;
	return $xmlliteglob ? { parse() } : undef;

	sub parse { while (1 == 1) {
			$xmlliteglob =~ /\G([^<>]*)([<>])/gs;      # read to next angle brace
			return undef unless $1 || $2;              # detect end of file
			my ($body, $brace) = ($1 || '', $2 || ''); # create/assign $body and $brace
			next if $body =~ /^\s*$/s;                 # skip to next if body is whitespace

			if ($body =~ /^(?:\?xml.*?\?|!--.*?--)$/s) { next; }          # catch ?xml? tags & comments
			if ($body =~ /^!--/s) { $xmlliteglob =~ /\G.*?-->/gs; next; } # catch multiline comments
			return ( $body, '' ) if $brace eq '<';                        # catch text blobs
			return parsetag($body) if $brace eq '>' && $body =~ /\/$/;    # catch selfending tags
			return $body if $body =~ /^\// && $brace eq '>';              # catch ending tags

			if ($brace eq '>' && $body =~ /^[^\/]/) { # recurse if it's not a selfending tag
				my ($tag, $hash, $child, $chash) = (parsetag($body), '', undef);
				do {{ ($child, $chash) = parse(); next unless $child && defined $chash;
					$hash->{$child} = [ $hash->{$child} ] if $hash->{$child} && !(ref $hash->{$child} eq 'ARRAY');
					push @{$hash->{$child}}, $chash;
				}} until $child =~ /\/$tag/ || !defined($child);
				return ( $tag => clean($hash) );
	}	}	}

	sub parsetag { my $body = shift; # parse tagname and key/value pairs from tag
		$body =~ /(\S*)(\s*|[\/>=])/sg; my ($tag, $hash) = ($1, {}); # grab tagname
		while ($body =~ /\G(.*?)(\s+|\/|=|$)/sg) {                   # grab key/value pairs
			my ($key, $value) = ($1, ''); next unless $key;           # store key, next if invalid
			if ($2 eq '=') {                                          # grab value if it exists
				$body =~ /\G(?:"([^"\\]*(?:\\.[^"\\]*)*)" # doublequoted value
				              |'([^'\\]*(?:\\.[^'\\]*)*)' # singlequoted value
				              |(`[^`\\]*(?:\\.[^`\\]*)*`) # backquoted value (keep quotes)
				              |([^\s>]*)                  # unquoted value
				             )(?:\s+|\/|$)/sgx;           # space or eof @ end of tag
				$value = (($1 || '') =~ /^"?(.*?)"?$/s)[0] || '';
			} push @{$hash->{$key}}, $value;
		} return ( $tag => clean($hash) );
	}

	sub clean { my $hash = shift; return unless ref $hash eq 'HASH'; # clean hash, remove extra stuff
		foreach my $key (keys %$hash) { my $value = $hash->{$key};                # process each value in hash
			if (ref $value eq 'ARRAY') {                                           # loop through array of values
				foreach my $subval (@$value) {
					$subval = clean($subval) if ref $subval eq 'HASH'; }             # clean subhashes in array
				$hash->{$key} = $value->[0] if @$value == 1;                        # only 1 value in array
			} elsif (ref $value eq 'HASH') { $hash->{$key} = clean($value); }      # recurse if value is hash
		}
		$hash = (keys %$hash)[0] if keys %$hash == 1 && (values %$hash)[0] eq ''; # one key w/o value
		return $hash;
}	}

sub hash2xml {
	my ($hash, $xml) = (shift, '');
	foreach my $key (sort keys %{$hash}) { $xml .= draw($key, $hash->{$key}, 0); } # draw each key
	return qq[<?xml version="1.0"?>\n$xml];                                        # add header, return xml

	sub draw {
		my ($tag, $data, $depth, $indent) = (@_, "\t" x $_[2]);
		my ($xml, $body, $inner) = ('', '', '');
		return "$indent<$tag>$data</$tag>\n" unless ref $data;                      # <tag>data</tag>
		return $xml . join '', map { draw($tag => $_, $depth) } @$data if ref $data eq 'ARRAY'; # hashes in array

		$xml .= "$indent<$tag";
		foreach my $key (sort keys %$data) { my $value = $data->{$key};
			if (ref $value) { $inner .= draw($key => $value, $depth + 1); next; }   # <tag><anothertag [/?]></tag>
			if ($value eq '') {
				if ($key =~ /^[\w.-]+$/) { $xml .= " $key"; }                        # <tag param>
				else { $body = $key; }                                               # <tag>body</tag>
			} else {
				if ($value =~ /\n/s) { $inner .= draw($key => $value, $depth + 1); } # <tag><key>value\n</key></tag>
				else { $xml .= qq[ $key="$value"]; }                                 # <tag key="value">
			}
		}

		$body .= "\n$inner$indent" if $inner; # concat body & inner
		return $xml .($body ? ">$body</$tag>\n" : "/>\n");
}	}

=head1 NAME

xmllite - a very light weight XML parser

=head1 SYNOPSIS

 use xmllite qw( xml2hash hash2xml );

 my $hash = xml2hash(File => 'filename');
    or
 my $hash = xml2hash('<?xml ...');

 my $xml = hash2xml($hash);

=head1 DESCRIPTION

xmllite is a small, light weight XML independant parser that can be used as
a stand-alone module or in-lined with other code.

When originally creating this package, I wanted a parser for XMLish
configuration files that could be easilly in-lined into other Perl
utilities.
In order to create stand-alone scripts, it was important that there were no
external dependencies.
This package is the result.

=over 3

=item My criteria for the package:

 - read/write XML within 80 lines of code (just barely made it)
 - don't obfuscate it so much that it's unmaintainable
 - doesn't need to be strict XML
    - accept double, single, backquotes for key=value
       - backquotes to be included as part of value
          - potential use as eval (in-lining code)
    - accept stand alone keys as key=""
 - no DTDs
 - doesn't need to write exactly what it reads as long as the data
      structure remains the same
 - return same data structure as iTools::XML::Simple

=back

=head1 CAVEATS

It's VERY important to note that this is NOT a strict XML parser.
It's not so important when reading XML (the parser does a pretty impressive
job of that), but writing XML is NOT IN ANY FORM guaranteed to maintain the
XML formatting you may expect.

As an example, look at this XML file:

 <?xml version="1.0"?>
 <maintag>
    <tag1 foo1="bar1" />
    <tag2>foo2</tag2>
    <tag3 foo3/>
    <tag4 foo4.1 foo4.2="bar4.2"/>
    <tag5 foo5="bar5.1">
       <foo5>bar5.2</foo5>
    </tag5>
 </maintag>

When read by I<xml2hash>, it will return this data structure:

 { 'maintag' => {
      'tag1' => { 'foo1' => 'bar1' },
      'tag2' => 'foo2',
      'tag3' => 'foo3',
      'tag4' => { 'foo4.1' => '', 'foo4.2' => 'bar4.2' }
      'tag5' => { 'foo5' => [ 'bar5.1', 'bar5.2' ] },
 } }

I<hash2xml> will then proceed to write it out like this:

 <?xml version="1.0"?>
 <maintag tag2="foo2" tag3="foo3">
    <tag1 foo1="bar1"/>
    <tag4 foo4.1 foo4.2="bar4.2"/>
    <tag5>
       <foo5>bar5.1</foo5>
       <foo5>bar5.2</foo5>
    </tag5>
 </maintag>

This occurs because the hash data structure created by I<xml2hash> is
stripped down to a very simple structure and contains no extra data to
indicate the exact format of the original XML.

The main reason this mangling is a concern is if you decide to use
I<has2xml> generated XML with another XML parser.
It is not a concern within xmllite, as it is designed to generate the same
data structure regardless of whether I<hash2xml> mangled the XML or not.
If you find that's not the case, please report it as a bug (see the
REPORTING BUGS section).

=head1 REPORTING BUGS

Report bugs here:
L<https://github.com/iellenberger/ijunk/issues>

=head1 AUTHOR

Written by Ingmar Ellenberger

=head1 COPYRIGHT

Copyright (c) 2003, Ingmar Ellenberger.

Distributed under The Artistic License.  For the text the license,
see L<https://github.com/iellenberger/ijunk/blob/master/LICENSE>
or read the F<LICENSE> in the root of the iJunk distribution.

=head1 SEE ALSO

iTools L<https://github.com/iellenberger/itools>

=cut

1;

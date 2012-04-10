#!/usr/bin/perl -w

use Data::Dumper;
use XML::LibXML;

use strict;
use warnings;

my $xml = "
<top>
	<element1 />
	<element3 />
</top>
";

my $parser = XML::LibXML->new;
#my $doc = $parser->parse_file("mytest.xml");
my $doc = $parser->parse_string($xml);
my $root = $doc->getDocumentElement();

my $new_element = $doc->createElement("element4");
$new_element->appendText('testing');
$root->appendChild($new_element);

my $fragment = $parser->parse_xml_chunk("
	<element2>text</element2>
");
$root->appendChild( $fragment );

$root->appendChild($parser->parse_xml_chunk("
	<element5>something</element5>
"));
$root->appendChild($parser->parse_xml_chunk(<<XML
	<element5>else</element5>
XML
));



print $root->toString() ."\n";

# see man XML::LibXML::Element

__END__

my $parser = XML::LibXML->new;
my $doc = $parser->parse_file("mytest.xml");
my $root = $doc->getDocumentElement();

my $new_element= $doc->createElement("element4");
$new_element->appendText('testing');

$root->appendChild($new_element);

print $root->toString(1);





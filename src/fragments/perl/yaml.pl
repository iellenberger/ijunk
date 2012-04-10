#!/usr/bin/perl -w

use Data::Dumper;
use YAML::Syck;

use strict;
use warnings;

# --- this example taken from the YAML.pm perldocs ---


# Load a YAML stream of 3 YAML documents into Perl data structures.
my ($hashref, $arrayref, $string) = Load(<<'...');
---
name: ingy
age: old
weight: heavy
# I should comment that I also like pink, but don't tell anybody.
favorite colors:
   - red
   - green
   - blue
foo:
   bar:
      alki
   beer:
      red hook
---
- Clark Evans
- Oren Ben-Kiki
- Ingy döt Net
--- >
You probably think YAML stands for "Yet Another Markup Language". It
ain't! YAML is really a data serialization language. But if you want
to think of it as a markup, that's OK with me. A lot of people try
to use XML as a serialization format.
"YAML" is catchy and fun to say. Try it. "YAML, YAML, YAML!!!"
...


# --- Dump the Perl data structures back into YAML ---
print "\nPerl DS -> YAML:\n\n";
# YAML::Dump is used the same way you'd use Data::Dumper::Dumper
print Dump($string, $arrayref, $hashref);

print "\nPerl DS:\n\n";
# --- Dump the Perl data structures back into YAML ---
print Dumper($string, $arrayref, $hashref);

print "\n";





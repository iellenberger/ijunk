#!/usr/bin/perl -w


use Data::Dumper;

use strict;

# --- sample data structure ---
my $ds = {
	foo => [ 1, 2, 3 ],
	bar => 'rrr',
};

print "Dumper(VAR): no settings\n". indent(
	Dumper($ds)
) ."\n";

print "Setting Indent=0, Sortkeys=1, Purity=1\n";
$Data::Dumper::Indent = 0;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Purity = 1;

print "Dumper->Dump([VAR], ['ds'])\n". indent(
	Data::Dumper->Dump([$ds], ['ds']) 
). "\n\n";

print "Dumper->Dump([VAR], [']): substr(4, -1)\n". indent(
	substr Data::Dumper->Dump([$ds], ['']), 4, -1
) ."\n\n";

print "Dumper->Dump([VAR], [']): substr(5, -2)\n". indent(
	substr Data::Dumper->Dump([$ds], ['']), 5, -2
) ."\n\n";

{
	print "Setting local Varname='ds'\n";
	local $Data::Dumper::Varname = 'ds';
	print "Dumper([VAR])\n". indent(
		Dumper([$ds])
	) ."\n\n";
}

my $string = hash2string($ds);
print "hash2string:\n". indent(
	$string
) ."\n\n";

my $hash = string2hash($string);
print "string2hash:\n". indent(
	Dumper($hash)
) ."\n\n";


# --- indent block 3 spaces ---
sub indent {$_[0]=~s/^/   /mg;shift}

# --- convert hash to eval'able string ---
sub string2hash {
	my ($string, $hash) = @_;
	my $tmphash = eval "{ $string }";  
	map { $hash->{$_} = $tmphash->{$_} } keys %$tmphash;
	return $hash;
}

# --- convert hash to eval'able string ---
sub hash2string {
	local $Data::Dumper::Indent = 0;   
	local $Data::Dumper::Sortkeys = 1;      
	local $Data::Dumper::Purity = 1;         
	return substr Data::Dumper->Dump([$_[0]], ['']), 4, -1          
}

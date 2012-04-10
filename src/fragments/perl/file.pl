#!/usr/bin/perl -w

use Carp;
use Symbol;

use strict;
use warnings;

# --- read a file ---
sub readfile {
	my $filename = shift                              # get filename or throw error
		# or usage('readfile() requires a filename');
		or confess('readfile() requires a filename');
	my $fh = gensym(); open $fh, $filename            # open file or throw error
		# or usage("Error opening file '$filename': $!");
		or confess("Error opening file '$filename': $!");
	my $content = ''; { local $/; $content = <$fh>; } # read contents
	close $fh; ungensym($fh);                         # close it up
	return $content;                                  # return file contents
}

# --- write a file ---
sub writefile {
	my $filename = shift                              # get filename or throw error
		# or usage('writefile() requires a filename');
		or confess('writefile() requires a filename');
	my $content = shift || '';

	# --- make a directory list ---
	my @dirs = split /\//, $filename;                                  # split path into components
	if ($filename =~ /^\//) { shift @dirs; $dirs[0] = '/'. $dirs[0]; } # correction for blank entry if '^/'
	pop @dirs;                                                         # remove the file name

	# --- create parent directories ---
	my $path;
	foreach my $dir (@dirs) {
		$path = ($path ? $path .'/' : ''). $dir; next if -d $path;
		# usage("Could not create directory '$path' - another file is in the way") if -e $path;
		confess("Could not create directory '$path' - another file is in the way") if -e $path;
		mkdir $path, 0755;
	}

	# --- (over)write the file ---
	my $fh = gensym(); open $fh, ">$filename"
		# or usage("Error opening file for write '$filename': $!");
		or confess("Error opening file for write '$filename': $!");
	print $fh $content; close $fh; ungensym($fh);
}

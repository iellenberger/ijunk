#!/usr/bin/env perl

use lib '.';

use strict;
use Win32API::File qw[ GetOsFHandle ];
use Win32::API::Prototype;

ApiLink(
	'Kernel32', q[
		BOOL PeekNamedPipe(
			HANDLE hNamedPipe,
			LPVOID lpBuffer,
			DWORD nBufferSize,
			LPDWORD lpBytesRead,
			LPDWORD lpTotalBytesAvail,
			LPDWORD lpBytesLeftThisMessage
		)
	]
) or die $^E;




# my $cmd = 'perl -le"$|++;print localtime().q[: some text] and sleep 1 for 1..10" |';
# my $pid = open my $pipe, $cmd or die $!;
# warn $pid;

use IPC::Open3;

my $pipe;
my $pid = open3(undef, $pipe, $pipe, "type $0");



my $pHandle = GetOsFHandle( $pipe );
# warn $pHandle;

while( 1 ) {
   my $cAvail = chr(0) x 4;
	my $buff = ' ' x 16;
	my $read =  chr(0) x 4;
	my $left =  chr(0) x 4;
   # my $retval = PeekNamedPipe( $pHandle, $buff, 16, $read, $cAvail, $left );
   my $retval = PeekNamedPipe( $pHandle, 0, 0, 0, $cAvail, 0 );

$cAvail = unpack 'l', $cAvail;
$read = unpack 'l', $read;
$left = unpack 'l', $left;

use Data::Dumper;
# print Dumper(\@b1);


# print "1. $retval <- $pHandle, $buff, 16, $read, $cAvail, $left\n";

    if( $cAvail ) {
# print "2\n";
			my $line;
        defined( read $pipe, $line, $cAvail ) or last;
# print "3\n";
        # chomp( $line );
# print "4\n";
        ## Do stuff with $line
			print $line;
        # printf "Got: '%s'\n", $line;
    }
    else {
        ## Do something else
        print 'Tum te tum';
        Win32::Sleep 500;
    }
}

sub toInt {
	
}

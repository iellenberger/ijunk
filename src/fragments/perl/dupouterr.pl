#!/usr/bin/env perl

use Data::Dumper;
use IPC::Open3;
use IO::Handle qw( autoflush );
use Symbol;
use Fcntl qw( :DEFAULT SEEK_SET SEEK_CUR SEEK_END );
use POSIX ":sys_wait_h";
use Time::HiRes qw( usleep );

use strict;
use warnings;

print "system : ". ("-" x 68) ."\n";

my $data = capSystem("cat $0; sleep 1; echo -n 'FOOFOO'; sleep 3; echo 'BARBAR'; ls -al; fo0; sleep 1");

# print "captured : ". ("-" x 66) ."\n";
# print $data;



sub capSystem {
	my $cmd = shift;

	# my ($out, $err, $cpid, $cout, $cerr);
	my ($out, $err) = (gensym(), gensym());
	my ($cpid, $cout, $cerr);
	my $capture = '';

	printf "executing '$cmd'\n\n";
	open3(undef, $out, $err, $cmd);

$| = 1;
$out->autoflush(1);
$err->autoflush(1);
# my $flags = fcntl($out, F_GETFL, 0);
# fcntl($out, F_SETFL, $flags | O_NDELAY);

	use IO::Select;
	my $sel = new IO::Select($out, $err);

	do {

		# $out->flush;
		# $err->flush;


		if ($sel->can_read(0.1)) {
			$cout = '';


			while (my @handles = $sel->can_read(0)) {
				foreach my $fh (@handles) {
# readEOH($fh);
					my $cc; sysread $fh, $cc, 1;
					if (!defined $cc || $cc eq '') {
						$sel->remove($fh);
						next;
					}
					if ($fh eq $out) {
						$cout .= "$cc";
						# printf "[$cc]";
					} else {
						printf "($cc)";
					}
					unless ($fh->opened) {
						print "fh not open!\n";
					}
				}
			}
		} else {
			$cout = undef;
		}


#		usleep(10000);
#		$cout = '';
#		# $cout = <$out>;
#		read $out, $cout, 1;


		if (defined $cout) {
			$capture .= $cout;
			print 'o', $cout;
		} else {
			print ".";
		}




		$cpid = waitpid(-1, WNOHANG);
	} until $cpid > 0;

	return $capture;
}

sub readEOH {
	my $handle = shift;

	my $current = sysseek $handle, 0, SEEK_CUR;
return unless defined $current;
	sysseek $handle, 0, SEEK_END;
	my $end = sysseek $handle, 0, SEEK_CUR;
	sysseek $handle, $current, SEEK_SET;
	my $count = $end - $current;
	print "{$count,$current,$end}"

#	my $current = tell $handle;
#	seek $handle, 0, SEEK_END;
#	my $end = tell $handle;
#	seek $handle, $current, SEEK_SET;
#	my $count = $end - $current;
#	print "{$count,$current,$end}";

#	# my $FIONREAD = 0x4004667f;
#	my $FIONREAD = 0x541b;
#	my $size = pack 'L', 0;
#	ioctl $handle, $FIONREAD, $size;
#	my $size = unpack 'L', 0;
#	print "{$size}" if $size;

}


__END__

my ($out, $err) = (gensym(), gensym());
my $ostr = '';

my $pid = open3(undef, $out, $err, "cat $0; sleep 1; echo -n 'FOOFOO'; sleep 1; echo 'BARBAR'; ls -al; sleep 1");

$| = 1;
autoflush($out, 1);
# my $flags = fcntl($out, F_GETFL, 0);
# fcntl($out, F_SETFL, $flags | O_NDELAY);

$out->blocking(0);

print(("-" x 77) ."\n");
my $kid;
do {
	usleep(10000);
	my $line = <$out>;
	if (defined $line) {
		$ostr .= $line;
		print $line;
	}
	print ".";
	# $kid = waitpid($pid, WNOHANG);
	$kid = waitpid(-1, WNOHANG);
} until $kid > 0;

print(("-" x 77) ."\n");
print $ostr;

# printf "%x %x %x\n", F_GETFL, F_SETFL, O_NDELAY;


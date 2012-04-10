#!/usr/bin/perl -w

=foo

Various examples for determing and manipulating a file path

=cut

# === Cwd ===================================================================

# --- cwd() and getcwd() are exported by default ---
use Cwd qw( cwd getcwd abs_path );

print "\nCwd:\n";
print "   cwd      : ". cwd ."\n";     # same as pwd
print "   getcwd   : ". getcwd ."\n";  # uses getcwd library
print "   abs_path : ". abs_path('./path.pl') ."\n";

# === FindBin ===============================================================

use FindBin qw( $Bin $Script $RealBin $RealScript );

print "\nFindBin:\n";
print "   \$Bin        : $Bin\n";         # path to bin directory from where script was invoked
print "   \$Script     : $Script\n";      # basename of script from which perl was invoked
print "   \$RealBin    : $RealBin\n";     # $Bin with all links resolved
print "   \$RealScript : $RealScript\n";  # $Script with all links resolved

print "\n";

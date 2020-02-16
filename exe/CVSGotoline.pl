# Get the active line. The format used to send
# is linenumber<tab>activefilename
# linenumber is 0 indexed.

($linenum,$activefilename) = split(/\t/,<STDIN>);

# Get input from OptiPerl.
@lines = <STDIN>;

# the first line of the output should containt
# the file used for diff

die unless ($lines[0]=~/Index: (\S+)/);
$difffile = $1;

# Now starting from the the active line in the
# editor and going backwards, find something
# like "--- 10,30"

while ($linenum >= 0) {

 if ($lines[$linenum]=~/^--- (\d+),(\d+)/)
 {
  # print now the line we want to go to in the
  # file we want to go to:
  print $1 - 1 . "\t$difffile";
  exit;
 }
 $linenum--;
}


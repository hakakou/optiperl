exit if (not defined($ARGV[1]));
$hosts = $ARGV[1];

open(HOSTS,"$hosts");
@lines = <HOSTS>;
close HOSTS;

open(HOSTS,">$hosts");

foreach (@lines) {
 $ismap = (~/^([\d\.]+)\s+(\S+)/);
 # lines look like 
 # 127.0.0.1       www.mysite.com 
 
 if (($ismap and ($2 ne $ARGV[0])) or (not ($ismap)))  { 
  # if the pattern that fits the line is found and is NOT the
  # line we want to remove OR the pattern is not found (could be a comment)
  # print the line.
  print HOSTS;
 }
}

close HOSTS;

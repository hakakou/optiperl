exit if (not defined($ARGV[1]));
$hosts = $ARGV[1];

open(HOSTS,"$hosts");
@lines = <HOSTS>;
close HOSTS;

foreach (@lines) {
 exit if ((~/^([\d\.]+)\s+(\S+)/) and ($2 eq $ARGV[0]));
 # lines look like 
 # 127.0.0.1       www.mysite.com 

 #If the line is already defined, exit so it doesn't get 
 #added a second time.
}

open(HOSTS,">>$hosts");
print HOSTS "127.0.0.1       $ARGV[0]\n";
close HOSTS;
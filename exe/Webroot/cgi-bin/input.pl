# This script is not a cgi script, but demonstrates 
# OptiPerl's debugger abilitily to debug scripts
# that expect input from the user.
#
# When executing the lines with <STDIN>, notice that
# the debugger will go in a "running" state while
# waiting for input. Enter a string in the edit box
# of the browser.

print "What is your name?\n\n\n";
$name = <STDIN> ;
chop ($name) ;

print "What is your company?\n\n\n\n" ;
$company = <STDIN> ;
chop ($company) ;

print "Hello, $name from $company!\n" ;


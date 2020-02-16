#!perl.exe

use strict;
use CGI qw(:standard);

print header;

print "<hr>";
print "The name was ",param('TextBox'),"<BR>";
print "The description was ",param('ScrollBox'),"<BR>";
print "<hr>";

my $key;
foreach $key (sort keys %ENV) {
  print "<b>$key</b> = " . $ENV{$key} . "<br>";
}

print "<hr>";

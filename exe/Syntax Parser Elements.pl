use CGI;		# "Reserved Word" - "Identifier"
my $a;			# "Perl Declared Identifier"
$int = 5;		# "Integer"
$float = 5.5;	# "Float"
print "test";	# "Perl internal function" & "String"
# All the () {} $ @ % ; etc are "delimiters"

sub test {		# "Reserved Word" - "Perl Declared Identifier"
 my $b;			# "Perl Variables"
 $a = 1; 		# This has "Declared Identifier" style
} 				# Because $a has been declared

s/bar/foo/;		# or multiline like:
s(foo)			# "RegExp Pattern"
 (bar);			# "RegExp Replacement"

print			# "Perl internal function"
q|<a 
href=
"http://url">
mysite
<a>|;	
# The above three lines were encoded with
# HTML style, because html was detected. They are:
# Line 18: "HTML Tags" (also line 22)
# Line 19: "HTML Params"
# Line 20: "String"
# Line 21: "Identifiers"

# Next are "Pod" and "Pod Tags" styles
=pod
pod
=cut
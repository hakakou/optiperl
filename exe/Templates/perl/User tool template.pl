# This is code that can be used with OptiPerl's
# %GETFILE%,%GETSELECTION%,%GETPROJECT%,%GETLINE% and 
# %SENDFILE%,%SENDSELECTION%,%SENDPROJECT%,%SENDLINE% parameters

# please read the comments below for commenting out lines 
# you do not need.

# Code for %SENDLINE%
# Get the active line. The format used to send
# is linenumber<tab>activefilename
# linenumber is 0 indexed. Don't add this line
# if you are not using %SENDLINE%
($linenum,$activefilename) = split(/\t/,<STDIN>);

# Code for %SENDFILE%, %SENDSELECTION%, %SENDPROJECT%
# Don't add the line below if you are not using them
@lines = <STDIN>;

# If you are also using arguments, they are here:
$param1 = $ARGV[0];
$param2 = $ARGV[1];

# Do now what you want with @lines and the rest of the variables
foreach (@lines) {
 $_ = "\t" . $_
}

# Code for %GETLINE%
# Print the line we want to go to and the
# file we want to go to. Don't add this line
# if you are not using %GETLINE%
print "$targetline\t$targetfile";

# Code for %GETFILE%,%GETSELECTION%,%GETPROJECT% 
# if you are also using the above parameters
# print the result. Remember that %GETFILE% will
# replace the file in the editor, so you might
# also want to use %n<filename>% to open a new file
# in the editor when using %GETFILE%.

print @lines;
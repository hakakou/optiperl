# Get input from OptiPerl
@lines = <STDIN>;

# Do now what you want with @lines and the rest of the variables
foreach (@lines) {
 $_ = "\t" . $_;
}

#Send it back
print @lines;
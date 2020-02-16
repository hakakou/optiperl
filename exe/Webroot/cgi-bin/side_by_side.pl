#!perl

use CGI qw/:standard :netscape/;

print header;

$frame_name = path_info();
$frame_name =~ s!^/!!;

# If no path information is provided, then we create
# a side-by-side frame set
if (!$frame_name) {
    print_frameset();
    exit 0;
}

# If we get here, then we either create the query form
# or we create the response.
print start_html();
print_query()    if $frame_name eq 'left';
print_response() if $frame_name eq 'right';
print end_html();

# Create the frameset
sub print_frameset {
    my $script = url();
    print title('Side by Side'),
    frameset({-cols=>'50%,50%'},
             frame({-name=>'left',-src=>"$script/left"}),
             frame({-name=>'right',-src=>"$script/right"})
             );
    exit 0;
}

sub print_query {
    my $script = url();
    print h1("Frameset Query"),
       start_form(-action=>"$script/right",
                  -target=>"right"),
       "What's your name? ",textfield('name'),p(),
       "What's the combination?",p(),
       checkbox_group(-name=>'words',
                      -values=>['eenie','meenie','minie','moe']),p(),
       "What's your favorite color? ",
       popup_menu(-name=>'color',
                -values=>['red','green','blue','chartreuse']),
       p(),submit,
       end_form;
}

 sub print_response {
   print h1("Frameset Result");
   unless (param) {
       print b("No query submitted yet.");
       return;
   }
   print "Your name is ",em(param(name)),p(),
   "The keywords are: ",em(join(", ",param('words'))),p(),
   "Your favorite color is ",em(param('color'));
}
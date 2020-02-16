#!perl

# Keep a growing list of phrases from the user.

# CONSTANTS
$STATE_DIR = ".";  # must be writable by 'nobody'

use CGI qw/:html/;
$q = new CGI;
$session_key = $q->path_info();
$session_key =~ s|^/||;             # get rid of the initial slash

# If no valid session key has been provided, then we
# generate one, tack it on to the end of our URL as
# additional path information, and redirect the user
# to this new location.
unless (valid($session_key)) {
    $session_key = generate_session_key();
    print $q->redirect($q->url() . "/$session_key");
    exit 0;
}

$old = fetch_old_state($session_key);

# Add the new item(s) to the old list of items
if ($q->param('action') eq 'ADD') {
    $q->param(-name=>'item',
              -value=>[$old->param('item'),$q->param('item')]);
} elsif ($action eq 'CLEAR') {
    $q->Delete('item');
}

# Save the new list to disk
save_state($session_key,$q);

# Now, at last, generate something for the use to look at.
print $q->header,
    $q->start_html("The growing list"),<<END;
<h1>The Growing List</h1>
Type a short phrase into the text field below.  Press <i>ADD</i>,
to append it to the history of the phrases that you've typed.  The
list is maintained on disk at the server end, so it won't get out of
order if you press the "back" button.  Press <i>CLEAR</i> to clear the
list and start fresh.  Bookmark this page to come back to the list later.
END
    ;
print $q->start_form,
    $q->textfield(-name=>'item',-default=>'',
                  -size=>50,-override=>1),p(),
    $q->submit(-name=>'action',-value=>'CLEAR'),
    $q->submit(-name=>'action',-value=>'ADD'),
    $q->end_form,
    $q->hr,
    $q->h2('Current list');

if ($q->param('item')) {
    my @items = $q->param('item');
    print ol(li(\@items));
} else {
    print em('Empty');
}
print <<END;
<hr>
<a href="../../source.html">Code examples</a></address>
END
    ;
print $q->end_html;

# Silly technique: we generate a session key from a random number
# generator, and keep calling until we find a unique one.
sub generate_session_key {
    my $key;
    do {
        $key = int(rand(1000000));
    } until (! -e "$STATE_DIR/$key");
    return $key;
}

# make sure the session ID passed to us is a valid one by
# looking for a numeric-only string
sub valid {
    my $key = shift;
    return $key=~/^\d+$/;
}

# Open the existing file, if any, and read the current state from it.
# We use the CGI object here, because it's straightforward to do.
# We don't check for success of the open() call, because if there is
# no file yet, the new CGI(FILEHANDLE) call will return an empty
# parameter list, which is exactly what we want.
sub fetch_old_state {
    my $session_key = shift;
    open(SAVEDSTATE,"$STATE_DIR/$session_key") || return;
    my $cgi = new CGI(SAVEDSTATE);
    close SAVEDSTATE;
    return $cgi;
}

sub save_state {
    my($session_key,$q) = @_;
    open(SAVEDSTATE,">$STATE_DIR/$session_key") ||
        die "Failed opening session state file: $!";
    $q->save(SAVEDSTATE);
    close SAVEDSTATE;
}
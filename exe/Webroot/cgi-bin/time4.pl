#!perl

use CGI ':standard';

use POSIX 'strftime';

# print the HTTP header and the HTML document
print header,
    start_html('A Virtual Clock'),
    h1('A Virtual Clock');
print_time();
print_form();
print end_html;

# print out the time
sub print_time {
    my($format);
    if (param) {
        $format = (param('type') eq '12-hour') ? '%r ' : '%T ' if param('time');
        $format .= '%d ' if param('day');
        $format .= '%B ' if param('month');
        $format .= '%A ' if param('day-of-month');
        $format .= '%Y ' if param('year');
    } else {
        $format = '%r %A %B %d %Y';
    }
    $current_time = strftime($format,localtime);
    print "The current time is ",strong($current_time),".",hr;
}

# print the clock settings form
sub print_form {
    print start_form,
    "Show: ",
    checkbox(-name=>'time',-checked=>1),
    checkbox(-name=>'day',-checked=>1),
    checkbox(-name=>'month',-checked=>1),
    checkbox(-name=>'day-of-month',-checked=>1),
    checkbox(-name=>'year',-checked=>1),
    p(),
    "Time style: ",
    radio_group(-name=>'type',
                -values=>['12-hour','24-hour']),
    p(),
    reset(-name=>'Reset'),
    submit(-name=>'Set'),
    end_form;
}
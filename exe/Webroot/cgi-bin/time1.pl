#!perl

use CGI ':standard';

$current_time = localtime;

print header,
     start_html('A Virtual Clock'),
     h1('A Virtual Clock'),
     "The current time is $current_time.",
     hr,
     end_html;
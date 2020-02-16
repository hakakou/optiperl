#!perl

use CGI ':standard';

@peppers = ('red','yellow','green');
@veggies = ('peas','broccoli','cabbage',
            'peppers' . ul(li(\@peppers)),
            'kolrabi'.'radishes');
print header,
    start_html('Vegetables'),
    h1('Eat Your Vegetables'),
    ol(
       li(\@veggies)
       ),
    end_html;

#!perl

use CGI ':standard';

print header,
    start_html('Vegetables'),
    h1('Eat Your Vegetables'),
    ol(
       li('peas'),
       li('broccoli'),
       li('cabbage'),
       li('peppers',
          ul(
             li('red'),
             li('yellow'),
             li('green')
             )
          ),
       li('kolrabi'),
       li('radishes')
       ),
    hr,
    end_html;
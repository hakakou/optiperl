#!perl

use CGI qw/:standard :html3/;

print header,
    start_html('Vegetables'),
    h1('Vegetables are for the Strong'),
    table({-border=>''},
          caption(strong('When Should You Eat Your Vegetables?')),
          Tr({-align=>CENTER,-valign=>TOP},
             [
              th(['','Breakfast','Lunch','Dinner']),
              th('Tomatoes').td(['no','yes','yes']),
              th('Broccoli').td(['no','no','yes']),
              th('Onions').td(['yes','yes','yes'])
              ]
             )
          ),
    end_html;
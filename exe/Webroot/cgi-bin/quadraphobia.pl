#!perl

use CGI qw/:standard/;

print header,
    start_html('QuadraPhobia'),
    h1('QuadraPhobia'),
    start_form(),
    image_button(-name=>'square',
                 -src=>'red_square.gif',
                 -width=>200,
                 -height=>200,
                 -align=>MIDDLE),
    end_form();
if (param()) {
    ($x,$y) = (param('square.x'),param('square.y'));
    $pos = 'top-left' if $x < 100 && $y < 100;
    $pos = 'top-right' if $x >= 100 && $y < 100;
    $pos = 'bottom-left' if $x < 100 && $y >= 100;
    $pos = 'bottom-right' if $x >= 100 && $y >= 100;
    print b("You clicked on the $pos part of the square.");
}
print p,a({href=>'../source.html'},"Code examples");
print end_html();
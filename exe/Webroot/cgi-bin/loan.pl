#!perl

use CGI qw/:standard :html3/;

# this defines the contents of the fill out forms
# on each page.
@PAGES = ('Personal Information','References','Assets','Review','Confirmation');
%FIELDS = ('Personal Information' => ['Name','Address','Telephone','Fax'],
           'References'           => ['Personal Reference 1','Personal Reference 2'],
           'Assets'               => ['Savings Account','Home','Car']
           );
# accumulate the field names into %ALL_FIELDS;
foreach (values %FIELDS) {
    grep($ALL_FIELDS{$_}++,@$_);
}


# figure out what page we're on and where we're heading.
$current_page = calculate_page(param('page'),param('go'));
$page_name = $PAGES[$current_page];

print_header();
print_form($current_page)         if $FIELDS{$page_name};
print_review($current_page)       if $page_name eq 'Review';
print_confirmation($current_page) if $page_name eq 'Confirmation';
print end_html;

# CALCULATE THE CURRENT PAGE
sub calculate_page {
    my ($prev,$dir) = @_;
    return 0 if $prev eq '';        # start with first page
    return $prev + 1 if $dir eq 'Submit Application';
    return $prev + 1 if $dir eq 'Next Page';
    return $prev - 1 if $dir eq 'Previous Page';
}

# PRINT HTTP AND HTML HEADERS
sub print_header {
    print header,
    start_html("Your Friendly Family Loan Center"),
    h1("Your Friendly Family Loan Center"),
    h2($page_name);
}

# PRINT ONE OF THE QUESTIONNAIRE PAGES
sub print_form {
    my $current_page = shift;
    print "Please fill out the form completely and accurately.",
       start_form,
       hr;
    draw_form(@{$FIELDS{$page_name}});
    print hr;
    print submit(-name=>'go',-value=>'Previous Page')
        if $current_page > 0;
    print submit(-name=>'go',-value=>'Next Page'),
       hidden(-name=>'page',-value=>$current_page,-override=>1),
       end_form;
}

# PRINT THE REVIEW PAGE
sub print_review {
    my $current_page = shift;
    print "Please review this information carefully before submitting it. ",
       start_form;
    my (@rows);
    foreach $page ('Personal Information','References','Assets') {
        push(@rows,th({-align=>LEFT},em($page)));
        foreach $field (@{$FIELDS{$page}}) {
            push(@rows,
                 TR(th({-align=>LEFT},$field),
                    td(param($field)))
                 );
            print hidden(-name=>$field);
        }
    }
    print table({-border=>1},caption($page),@rows),
       hidden(-name=>'page',-value=>$current_page,-override=>1),
       submit(-name=>'go',-value=>'Previous Page'),
       submit(-name=>'go',-value=>'Submit Application'),
       end_form;
}

# PRINT THE CONFIRMATION PAGE
sub print_confirmation {
    print "Thank you. A loan officer will be contacting you shortly.",
       p,
       a({-href=>'../source.html'},'Code examples');
}


# CREATE A GENERIC QUESTIONNAIRE
sub draw_form {
    my (@fields) = @_;
    my (%fields);
    grep ($fields{$_}++,@fields);
    my (@hidden_fields) = grep(!$fields{$_},keys %ALL_FIELDS);
    my (@rows);
    foreach (@fields) {
        push(@rows,
             TR(th({-align=>LEFT},$_),
                td(textfield(-name=>$_,-size=>50))
                )
             );
    }
    print table(@rows);

    foreach (@hidden_fields) {
        print hidden(-name=>$_);
    }
}
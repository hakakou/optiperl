#!/usr/local/bin/perl

# Sendmail and date test.
# To run this example, go first to
# item Run / Sendmail support, and
# enter the paths:
#
# /bin/sendmail
# /bin/date

$date = `/bin/date`;
$userfirstname = "Aristides";
$usersemail = 'ar@kalopoulos.com';

#Mail 1

open(MAIL,"|/bin/sendmail");
print MAIL <<MAILTEXT;
From: Nick Papadopoulos <nick\@pap.com>
To: $usersemail
Subject: Thank you for becoming a member $userfirstname

Thank you $userfirstname for your interest.
MAILTEXT


#Mail 2

open(MAIL,"|/bin/sendmail");
print MAIL <<MAILTEXT;
From: Server <admin\@pap.com>
To: Nick Papadopoulos <nick\@pap.com>
Subject: New Member

Hi,
@userfirstname using email $usersemail
became a member on $date
MAILTEXT

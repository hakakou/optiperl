#!perl

#@Local#?#@Server

### Using the version converter, 4 changes are made here when
### you press toggle, at lines 1,3,14,16,20

use strict;
use Fcntl qw(:flock);

print "Content-Type: text/html\n\n";

my $semaphore_file=
 'counter.sem';#?'/tmp/counter.sem';
my $counter_file=
 'counter.log';#?'/docs/logs/counter.log';

sub get_lock {
 open(SEM,">$semaphore_file");
 #?flock(SEM,LOCK_EX);
}

sub release_lock {
 close(SEM)
}

get_lock();
my $hits = 0;
if (open(CF,$counter_file)) {
 $hits=<CF>;
 close(CF);
}

$hits++;
print "Hits: ";
print "$hits<br>";

open(CF,">$counter_file");
print CF $hits;
close(CF);

release_lock();
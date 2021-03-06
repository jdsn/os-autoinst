#!/usr/bin/perl -w
use strict;
use bmwqemu;

# wait until ready
waitinststage "KDE", 200;
mousemove_raw(31000, 31000); # move mouse off screen again
waitidle 100;
sleep 10;

my $lastmenu=0;
# open KDE menu
sub open_menu($;$)
{ my $n=shift; my $wait=shift;
	waitidle;
	sendkey "alt-f1";
	waitidle;
	my $diff=$n-$lastmenu;
	$lastmenu=$n;
	if($diff<0) {
		for(1..-$diff) {
			sendkey "up";
		}
	}
	if($diff>0) {
		for(1..$diff) {
			sendkey "down";
		}
	}
	sleep 1;
	sendkey "ret";
	waitidle $wait;
	sleep 4;
}

sub start_program($)
{ my $program=shift;
	sendkey "alt-f2"; sleep 2;
	sendautotype $program; sleep 1;
	sendkey "ret";
	waitidle;
	sleep 2;
}

my %kdemenu=(firefox=>1, pim=>2, office=>3, audio=>4, fileman=>5, config=>6, help=>7, xterm=>8);

if($ENV{NETBOOT}) { # has photomanager added on #5
#	$kdemenu{audio}++; # and office on #3
	for my $x (qw(fileman config help xterm)) {
		$kdemenu{$x}+=1;
	}
}

do "inst/consoletest.pm" or die @$;

#open_menu($kdemenu{audio});
#sendkey "alt-f4"; sleep 3; # mp3 popup
#sendkey "alt-f4"; sleep 3; # close kwallet popup
#sendkey "alt-f4"; sleep 9; # close another popup
#sendkey "ctrl-q"; # really quit. alt-f4 just backgrounds

#open_menu($kdemenu{pim}, 100);
#sleep 10; waitidle 100; sleep 10; # pim needs extra time for first init
#sendkey "alt-f4"; sleep 10; # close popup (tips on startup)
#sendkey "alt-f4";


1;

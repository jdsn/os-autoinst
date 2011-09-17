#!/usr/bin/perl -w
use strict;
use base "basetest";
use bmwqemu;

sub is_applicable()
{
  return !$ENV{LIVECD};
}

sub addonproduct()
{
	if($ENV{ADDONURL}) {
		if(!$ENV{NET}) {
			sendkey $cmd{"next"}; waitidle; # use network
			sendkey "alt-o"; waitidle; # OK DHCP network
		}
		my $repo=0;
		foreach my $url (split(/\+/, $ENV{ADDONURL})) {
			if($repo++) {sendkey "alt-a"; waitidle;} # Add another
			sendkey $cmd{"next"}; waitidle; # Specify URL (default)
			sendautotype($url);
			sendkey $cmd{"next"}; waitidle;
			sendkey "alt-i";sendkey "alt-t"; waitidle; # confirm import (trust) key
		}
		sendkey $cmd{"next"}; waitidle; # done
	}
}

sub run()
{
	# autoconf phase
	waitinststage "systemanalysis";
	# includes downloads, so waitidle is bad.
	waitgoodimage(($ENV{UPGRADE}?120:25));
	# TODO waitstillimage(10)
	waitidle 29;
	# Installation Mode = new Installation
	if($ENV{UPGRADE}) {
		sendkey "alt-u";
	}
	if($ENV{ADDONURL}) {
		sendkey "alt-c"; # Include Add-On Products
	}
	sendkey $cmd{"next"};
	waitidle(29);
      if(!$ENV{UPGRADE}) {
	addonproduct();
      } else {
	# upgrade system select
	sendkey "alt-c"; # "Cancel" on warning popup (11.1->11.3)
	waitidle;
	sendkey "alt-s"; # "Show All Partitions"
	waitidle;

	sendkey $cmd{"next"};
	# repos
	waitidle;
	sendkey $cmd{"next"};
	waitidle;
	# might need to resolve conflicts here
	if($ENV{UPGRADE}=~m/11\.1/) {
		sendkey "alt-c";
		waitidle;
		sendkey "p";
		waitidle;
	# alt-c p # Change Packages
		for(1..4) {sendkey "tab"}
		sendkey "spc";
		sleep 3;
		sendkey "alt-o";
	# tab tab tab tab space alt-o # Select+OK
		waitidle;
		sendkey "alt-a";
		waitidle;
		sendkey "alt-o";
	# alt-a alt-o # Accept + Continue(with auto-changes)
	}
	addonproduct();
	waitidle;
	sendkey "alt-c"; # change
	sendkey "p";	# Packages
	sleep 120;
	sendkey "alt-a"; # Accept
	sleep 2;
	sendkey "alt-o"; # cOntinue
	waitidle;
	sendkey "alt-u"; # Update if available
	waitidle 10;
	sendkey "alt-u"; # confirm
	sleep 20;
	sendkey "alt-d"; # details
	{
		local $ENV{SCREENSHOTINTERVAL}=5;
		waitinststage("splashscreen|booted|check-and-install-the-updates", 5600); # time for install
		sendkey "alt-n"; # 12.1-Build0221+ asks about installing package-updates
	}
	waitidle 100;
      }
}

1;
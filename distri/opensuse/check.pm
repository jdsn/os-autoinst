#!/usr/bin/perl -w
use strict;
use base "basetest";
use bmwqemu;
use autotest;

sub check() {
	my %notinupgrade=qw(timezone 1 disk 1 usersettings 1 automaticconfiguration 1);
	my %notinlive=(%notinupgrade,qw(welcome 1 installationoverview 1 performinstallation 1));
	my @stages=(qw"booted");
	my $results=\%::results;
	foreach my $s (@stages) {
		next if($notinupgrade{$s} && $ENV{UPGRADE});
		next if($notinlive{$s} && $ENV{LIVETEST});
		my $found=0;
		foreach(keys(%::stageseen)) {if(m/$s/){$found=1;last;}}
		$results->{$s}=($found?"OK":"unknown");
		::printresult $s;
	}

	autotest::runtest("$scriptdir/distri/$ENV{DISTRI}/inst.d/010_initenv.pm",sub{my $test=shift;$test->run;});

	autotest::runtestdir("$scriptdir/inst.d", \&::checkfunc);
	autotest::runtestdir("$scriptdir/distri/$ENV{DISTRI}/inst.d", \&::checkfunc);
	autotest::runtestdir("$scriptdir/consoletest.d", \&::checkfunc);
	autotest::runtestdir("$scriptdir/x11test.d", \&::checkfunc);

	my $overall=(::is_ok($results->{xterm}) or ::is_ok($results->{sshxterm}) or ::is_ok($results->{firefox}));
	for my $test (qw(booted zypper_in zypper_up yast2_lan isosize)) {
		next if($test eq "automaticconfiguration" && ($ENV{UPGRADE}||$ENV{LIVETEST}));
		$overall=0 unless ::is_ok $results->{$test};
	}
	return $overall;
}

1;

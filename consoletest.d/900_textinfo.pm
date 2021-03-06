use base "basetest";
use strict;
use bmwqemu;

# have various useful general info included in videos
sub run()
{
	my $self=shift;
	script_run('uname -a');
#	$self->take_screenshot;
	script_run('df');
	script_run('free');
	script_run('rpm -qa kernel-*');
	script_run('grep DISPLAYMANAGER= /etc/sysconfig/displaymanager');
	script_run('grep DEFAULT /etc/sysconfig/windowmanager');
	script_run("ls -l /etc/ntp*");
	$self->take_screenshot;
	local $ENV{SCREENSHOTINTERVAL}=3; # uninteresting stuff for automatic processing:
	script_run("ps ax > /dev/$serialdev");
	script_run("rpm -qa > /dev/$serialdev");
	script_sudo("tar cjf /tmp/logs.tar.bz2 /var/log");
	my $ver=`cat testname`; chomp($ver);
	script_run("curl --form testname=$ver --form upload=@/tmp/logs.tar.bz2 10.0.2.2/cgi-bin/uploadlog");
}

sub checklist()
{
	# return hashref:
	return {qw(
	)}
}

1;

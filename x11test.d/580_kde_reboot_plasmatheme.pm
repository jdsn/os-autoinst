use base "basetest";
use bmwqemu;
# test for https://bugzilla.novell.com/show_bug.cgi?id=613824

sub is_applicable()
{
	return $ENV{DESKTOP} eq "kde" && !$ENV{LIVETEST};
}

sub run()
{
	my $self=shift;
	waitinststage "KDE", 200; # wait until reboot is finished
	waitidle 100;
}

sub checklist()
{
	# return hashref:
	return {qw(
		6d18b2d816f80e55fdc6ce1a06a908be fail
		844621cdb1baa93b49429e425d424d75 fail
		252dfb98f3b8f0a8c9e9bcb4b3af7a64 OK
		bc4a7feb678ef2596a67583b14d763f6 OK
		866a30651084f519426acdb539574ed9 OK
		8cab6a5eae51915a2682b6df6a352dec OK
		96290e51d48b1774b49ee52288de943f OK
		051c7244d0e2f1d795b809b15255b444 OK
		174cefa8404b3d080f72f96e87968686 OK
		69144e56bfd9f8993926661a11ecfbc1 OK
		2893a944ae5efbf13d7a45b57361f5ab OK
		bed374e3df2d39efcba480701e51015c OK
	)}
}

1;

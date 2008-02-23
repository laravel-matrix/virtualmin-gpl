#!/usr/local/bin/perl
# Collect various pieces of general system information, for display by themes
# on their status pages. Run every 5 mins from Cron.

package virtual_server;
$main::no_acl_check++;
$no_virtualmin_plugins = 1;
require './virtual-server-lib.pl';
$start = time();

# Make sure we are not already running
if (&test_lock($collected_info_file)) {
	print "Already running\n";
	exit(0);
	}
local $gconfig{'logfiles'} = 0;		# Don't diff collected file
local $gconfig{'logfullfiles'} = 0;
&lock_file($collected_info_file);

$info = &collect_system_info();
if ($info) {
	&save_collected_info($info);
	&add_historic_collected_info($info, $start);
	}
&unlock_file($collected_info_file);

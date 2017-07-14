#!/bin/sh
#
#      I C E F L O O R    2
#
#      pf frontend for OS X
#
#        www.hanynet.com
#
#        by Hany El Imam
#
# pf startup script by hany@hanynet.com
#
# V 1.0.4
#
# IceFloor is free software. Please support free software!
# We accept small PayPal donations to << hany@hanynet.com >>
# We also accept and welcome BitCoin donations to address:
# << 16UvmZcqEEYT5gYrTaGrh82d12726fQi5x >> ...Thank you!
#
# PLEASE NOTE:
#
# this script has been installed by IceFloor 2.
# please chmod +x this script if you put/replace it manually!!
#
# this script must be executed at boot time by launchd
# it enables the pf firewall "on demand" using OS X PF Tokens (-E)
# and loads rules from custom IceFloor pf configuration dir /Library/IceFloor.
# it enables also pf logging using tcpdump.
# in order for logging to work you must add this line to /etc/syslog.conf:
# local2.*						/var/log/pffirewall.log
# this is done automatically by IceFloor.
#
# please note: this script works on OS X 10.7 or later
# earlier Mac OS X versions are not supported, they lack PF and use IPFW instead.

# start

#
# We need to trap on TERM signals, according to Apple's launchd docs:
#
trap 'exit 1' 15

#
# Use the "ipconfig waitall" command to wait for all the interfaces to come up:
#
ipconfig waitall
sleep 5
#
# System sysctl 
#
sysctl -w net.inet6.ip6.fw.verbose=0
sysctl -w net.inet.ip.fw.verbose=0
sysctl -w net.inet.ip.fw.verbose_limit=0

#
# interface forwarding enabled by default
#
sysctl -w net.inet.ip.forwarding=1
		
#		
# enable PF and load rules from default IceFloor configuration file using tokens (apple specific PF options -E and -X)
#
/sbin/pfctl -e
/sbin/pfctl -Ef /Library/psuiss/pf/psuiss.conf

# enable dummynet pipes
source /Library/psuiss/pf/dummynet.sh

#
# enable pf logs using tcpdump
#
ifconfig pflog0 create
/usr/sbin/tcpdump -lnettti pflog0 | /usr/bin/logger -t pf -p local2.info

# Exit with a clean status
exit 0

# this file is public domain and is available to everyone with no exceptions.

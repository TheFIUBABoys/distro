#!/bin/bash

#################################
# Set up Ethernet bridge on Linux
# Requires: bridge-utils
#################################

# Define Bridge Interface
br="br0"

# Define list of TAP interfaces to be bridged,
# for example tap="tap0 tap1 tap2".

tap="tap0 tap1 tap2 tap3 tap4 tap5 tap6 tap7"

# Define physical ethernet interface to be bridged
# with TAP interface(s) above.
eth="eth0"
eth_ip="192.168.2.115"
eth_netmask="255.255.255.0"
eth_broadcast="192.168.2.255"

#for t in $tap; do
#    openvpn --mktun --dev $t
#done

openvpn --mktun --dev tap0 
openvpn --mktun --dev tap1 --ifconfig 10.24.1.5 255.255.255.0
openvpn --mktun --dev tap2
openvpn --mktun --dev tap3
openvpn --mktun --dev tap4
openvpn --mktun --dev tap5
openvpn --mktun --dev tap6
openvpn --mktun --dev tap7 --ifconfig 


brctl addbr $br
brctl addif $br $eth

for t in $tap; do
    brctl addif $br $t
done

for t in $tap; do
    ifconfig $t 0.0.0.0 promisc up
done

ifconfig $eth 0.0.0.0 promisc up

ifconfig $br $eth_ip netmask $eth_netmask broadcast $eth_broadcast

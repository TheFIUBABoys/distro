
# $1 -> Ip del servidor

PHISICAL_IP=$1

IP=10.24.1.133
MASK=255.255.255.128
TAP=tap4

openvpn --remote $PHISICAL_IP --port 1198 --dev $TAP --ifconfig $IP $MASK
